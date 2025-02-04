INSERT INTO T_CORE_CONFIG ( SID, CODE, SETTING, DESCRIPTION, CREATE_BY, CREATE_ON, MODIFY_BY, MODIFY_ON ) VALUES ( '333162OO', 'CORE.BASE_URL', 'https://hqcuiwi2ms01.ogn.af.mil:4443/pls/apex/i2ms/pSid/', NULL, 'timothy.ward',  TO_Date( '03/14/2011 10:04:23 AM', 'MM/DD/YYYY HH:MI:SS AM'), 'timothy.ward',  TO_Date( '03/14/2011 10:04:23 AM', 'MM/DD/YYYY HH:MI:SS AM')); 
COMMIT;

-- "Set define off" turns off substitution variables. 
Set define off; 

CREATE OR REPLACE PACKAGE "CORE_UTIL" as
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
    15-Mar-2011 TJW     CR#3608 - Added P_MAIL_TYPE to EMAIL_SEND.
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
        P_MAIL_PORT   in   Number := null,
        P_MAIL_TYPE   in   Varchar2 := 'text/plain;')
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


CREATE OR REPLACE PACKAGE BODY "CORE_UTIL" as
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
    15-Mar-2011 TJW     CR#3608 - Added P_MAIL_TYPE to EMAIL_SEND.
    
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
        P_MAIL_PORT   in   Number := null,
        P_MAIL_TYPE   in   Varchar2 := 'text/plain;')
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
            'Subject:' || P_SUBJECT || UTL_TCP.CRLF || 'Content-TYPE: ' || P_MAIL_TYPE || 'From:I2G <'
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
--   Date and Time:   09:54 Monday March 14, 2011
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

PROMPT ...Remove page 105
 
begin
 
wwv_flow_api.remove_page (p_flow_id=>wwv_flow.g_flow_id, p_page_id=>105);
 
end;
/

 
--application/pages/page_00105
prompt  ...PAGE 105: External Link Page
--
 
begin
 
declare
    h varchar2(32767) := null;
    ph varchar2(32767) := null;
begin
h := null;
ph := null;
wwv_flow_api.create_page(
  p_id     => 105,
  p_flow_id=> wwv_flow.g_flow_id,
  p_tab_set=> '',
  p_name   => 'External Link Page',
  p_step_title=> 'External Link Page',
  p_step_sub_title_type => 'TEXT_WITH_SUBSTITUTIONS',
  p_first_item=> 'NO_FIRST_ITEM',
  p_include_apex_css_js_yn=>'Y',
  p_footer_text => '<script type="text/javascript">'||chr(10)||
' &P105_OBJ_URL.;'||chr(10)||
' var t=setTimeout(doSubmit(''SUBMIT_FORM''),300);'||chr(10)||
'</script>'||chr(10)||
'',
  p_autocomplete_on_off => 'ON',
  p_group_id => 88817126738005514+ wwv_flow_api.g_id_offset,
  p_help_text => '',
  p_html_page_header => '',
  p_step_template => 92011431286949262+ wwv_flow_api.g_id_offset,
  p_required_patch=> null + wwv_flow_api.g_id_offset,
  p_last_updated_by => 'TWARD',
  p_last_upd_yyyymmddhh24miss => '20110314095227',
  p_page_is_public_y_n=> 'N',
  p_protection_level=> 'N',
  p_page_comment  => '');
 
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
  p_id=> 5063602414261208 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_page_id=> 105,
  p_plug_name=> 'Opening Object.............Please Wait!',
  p_region_name=>'',
  p_plug_template=> 179216655889554481+ wwv_flow_api.g_id_offset,
  p_plug_display_sequence=> 10,
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
 
begin
 
null;
 
end;
/

 
begin
 
wwv_flow_api.create_page_branch(
  p_id=>5081432032173390 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 105,
  p_branch_action=> 'f?p=&APP_ID.:1000:&SESSION.::&DEBUG.&success_msg=#SUCCESS_MSG#',
  p_branch_point=> 'AFTER_PROCESSING',
  p_branch_type=> 'REDIRECT_URL',
  p_branch_sequence=> 10,
  p_save_state_before_branch_yn=>'N',
  p_branch_comment=> 'Created 14-MAR-2011 09:48 by TWARD');
 
 
end;
/

declare
    h varchar2(32767) := null;
begin
wwv_flow_api.create_page_item(
  p_id=>5063921807266859 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 105,
  p_name=>'P105_OBJ_TO_OPEN',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 10,
  p_item_plug_id => 5063602414261208+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'YES',
  p_item_default_type => 'STATIC_TEXT_WITH_SUBSTITUTIONS',
  p_prompt=>'Object To Open',
  p_source_type=> 'STATIC',
  p_display_as=> 'HIDDEN',
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
  p_id=>5076213120437657 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 105,
  p_name=>'P105_OBJ_URL',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 20,
  p_item_plug_id => 5063602414261208+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'YES',
  p_item_default_type => 'STATIC_TEXT_WITH_SUBSTITUTIONS',
  p_prompt=>'Obj Url',
  p_source_type=> 'STATIC',
  p_display_as=> 'HIDDEN',
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
  p_field_template => 179220647225554497+wwv_flow_api.g_id_offset,
  p_is_persistent=> 'Y',
  p_lov_display_extra=>'NO',
  p_protection_level => 'N',
  p_item_comment => '');
 
 
end;
/

 
begin
 
wwv_flow_api.create_page_computation(
  p_id=> 5076611173446540 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 105,
  p_computation_sequence => 10,
  p_computation_item=> 'P105_OBJ_URL',
  p_computation_point=> 'BEFORE_HEADER',
  p_computation_type=> 'PLSQL_EXPRESSION',
  p_computation_processed=> 'REPLACE_EXISTING',
  p_computation=> 'osi_object.get_object_url(:P105_OBJ_TO_OPEN);'||chr(10)||
'',
  p_compute_when => '',
  p_compute_when_type=>'');
 
null;
 
end;
/

 
begin
 
---------------------------------------
-- ...updatable report columns for page 105
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



set define off;

CREATE OR REPLACE TRIGGER WEBI2MS.osi_feedback_a_i_send
    after insert
    on t_osi_feedback
    referencing new as new old as old
    for each row
declare
    v_email_to               t_core_config.setting%type;
    v_username               varchar2(100);
    v_object_type_desc       varchar2(400);
    v_object_title           varchar2(400);
    v_object_id              varchar2(400);
    v_page_desc              varchar2(400);
    v_user_email_address     varchar2(400);
    v_msg                    varchar2(4500);
    v_status                 varchar2(400);
    v_crlf                   varchar2(10)                 := chr(11) || chr(13);
    v_allowed_addresses      varchar2(200);
    v_have_allowed_address   boolean;
    v_url                    varchar2(4000) := core_util.get_config('CORE.BASE_URL');
    v_unit_sid               varchar2(20);
begin
     ---Get Helpdesk Email Address---
     v_email_to := core_util.get_config('OSI.FEEDBACK_EMAIL_ADDRESS');

     ---Get the sending personnels name---
     v_username := osi_personnel.get_name(:new.personnel);

     if (:new.obj is not null) then

       ---Get Object Type---
       v_object_type_desc := osi_object.get_objtype_desc(core_obj.get_objtype(:new.obj));

       ---Get the title of the object in question---
       v_object_title := core_obj.get_tagline(:new.obj);

       ---Get the ID of the object in question---
       v_object_id := osi_object.get_id(:new.obj, null);
       
       if v_object_id is null or v_object_id='' then
       
         v_object_id := '(not found)';
         
       end if;
       
     else

       ---Get Object Type---
       v_object_type_desc := '(not applicable)';

       ---Get the title of the object in question---
       v_object_title := '(not applicable)';

       ---Get the ID of the object in question---
       v_object_id := '(not applicable)';

     end if;

     ---See if the user has a primary email address---
     begin
          v_have_allowed_address := false;
 
          select value into v_user_email_address
            from t_osi_personnel_contact opc, t_osi_reference tor
             where opc.type = tor.sid and tor.code = 'EMLP' and opc.personnel = :new.personnel;

          v_allowed_addresses := core_list.convert_to_list(core_util.get_config('OSI.NOTIF_EMAIL_ALLOW_ADDRESSES'), ',');

          ---Check to make sure they are allowed to send with this email address (if not, just default to NO_REPLY address)---
          for cnt in 1 .. core_list.count_list_elements(v_allowed_addresses)
          loop
              if (substr(v_user_email_address,instr(v_user_email_address, '@') + 1,length(v_user_email_address)) = core_list.get_list_element(v_allowed_addresses, cnt)) then

                ---Found it!---
                v_have_allowed_address := true;
                exit;

              end if;

          end loop;

          if (v_have_allowed_address = false) then

            return;

          end if;

     exception
         when no_data_found then
             ---If user has no primary email address, use the NO_REPLY address---
             --v_user_email_address := core_util.get_config('OSI.NOTIF_SNDR');
             return;
     end;

     ---Probably shouldn't need the IF block, but better safe than sorry..---
     if (v_have_allowed_address = true) then
 
       ---Get Page Description---
       select page_name || ' Page' into v_page_desc
          from apex_030200.apex_application_pages
         where page_id = :new.page_id and application_id = 100;

       ---Create Message---
       v_unit_sid := osi_personnel.get_current_unit(:new.personnel);
       v_msg := '<p style="font-family:Courier New;"><table border=0 style="font-family:Courier New;">';
       v_msg := v_msg || '<tr><td align=right valign=top>Personnel / User:&nbsp;</td><td>' || '<a href="' || v_url  || :new.personnel || '">' || v_username || '</a></td></tr>';
       v_msg := v_msg || '<tr><td align=right valign=top>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;User Unit:&nbsp;</td><td><a href="' || v_url || v_unit_sid || '">' ||  osi_unit.get_name(v_unit_sid) || '</a></td></tr>';
       
       for a in (select REGEXP_REPLACE(REGEXP_REPLACE(c.value,
                 '([[:digit:]]{3})([[:digit:]]{3})([[:digit:]]{4})',
                 '(\1) \2-\3'),'([[:digit:]]{3})([[:digit:]]{4})',
                 '\1-\2') as PhoneNumber,r.code from t_osi_personnel_contact c,t_osi_reference r where personnel=:new.personnel and r.sid=c.type and r.code in ('OFFP','DSNP'))
       loop
           if a.code='OFFP' then

             v_msg := v_msg || '<tr><td align=right valign=top>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Phone:&nbsp;</td><td>' ||  a.PhoneNumber || '</td></tr>';

           end if;
           
           if a.code='DSNP' then
  
             v_msg := v_msg || '<tr><td align=right valign=top>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;DSN:&nbsp;</td><td>' ||  a.PhoneNumber || '</td></tr>';
           
           end if;
                    
       end loop;
              
       v_msg := v_msg || '<tr><td align=right valign=top>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Date/Time:&nbsp;</td><td>' || to_char(sysdate, 'Dy DD-Mon-YYYY HH24:MI:SS') || '</td></tr>';
       v_msg := v_msg || '<tr><td align=right valign=top>Page Desctiption:&nbsp;</td><td>' || v_page_desc || '</td></tr>';
       v_msg := v_msg || '<tr><td align=right valign=top>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Object Type:&nbsp;</td><td>' || v_object_type_desc || '</td></tr>';
       v_msg := v_msg || '<tr><td align=right valign=top>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Object ID:&nbsp;</td><td>' || '<a href="' || v_url || :new.obj || '">' || v_object_id || '</a>' || '</td></tr>';
       v_msg := v_msg || '<tr><td align=right valign=top>&nbsp;&nbsp;&nbsp;&nbsp;Object Title:&nbsp;</td><td>' || v_object_title || '</td></tr>';
       v_msg := v_msg || '<tr><td align=right valign=top>&nbsp;&nbsp;&nbsp;&nbsp;User Message:&nbsp;</td><td>' || replace(replace(:new.user_text,chr(10),'<BR>'),chr(13),'') || '</td></tr>';
       v_msg := v_msg || '</table></p>';

       ---Send email---
       v_status := core_util.email_send(v_email_to, 'Help Desk Ticket', v_msg, v_user_email_address, null, null, null, 'text/html;');

       ---Should we do something with the status output?---

     end if;

exception
    when others then
        raise;

end osi_feedback_a_i_send;
/

CREATE OR REPLACE PACKAGE BODY Osi_Notification AS
/*
  Package: Notification_Pkg - Holds notification processing. Includes
           detection, generation, delivery and cleanup functions. All
           notification routines log their actions to the I2MS.NOTIF
           pipe (using the UTIL.LOGGER package).

  History:
    26-Feb-2002 RWH      Initial version.
    03-Jul-2002 RWH/AES  Added Detect_ACTLEADLATE and Detect_INVINACTIVE.
    29-Oct-2002 AES      Added Detect_PERCHANGED.
    04-Nov-2002 AES      Added Generate_PERCHANGED.
    24-Feb-2003 RWH      Corrected Priv Code usage in Generate_INVHEADSUP.
                         Updated Generate_For_Lead_Agents to not create
                          notifications for the personnel that caused the
                          original event to occur.
    24-Feb-2003 AES      Added Generate_ASGNMADE.
    25-Feb-2003 AES      Added Generate_FLEASSOCFLE, Generate_FLEASSOCACT.
    02-Apr-2004 AES      Added Detect_TMEXPIRATION.
    26-Oct-2005 WCC      Modified the Email_Send and Textmsg_Send functions to
                          filter for OGN addresses only.
    30-Mar-2006 TJW      PR #1854 Added Content-TYPE: text/html;' || to email_send to
                          send messages in html format.  Needed to send links
                          to notifications.
                          Also changes to deliver_generic, deliver_actleaddoneemail,
                          and deliver_invdeathemail.
    30-Mar-2006 TJW      PR #1796 Added notifications for Fraud Cases
                          Added deliver_invfraudemail.  This also requires changes
                          to T_NOTIFICATION_EVENT_TYPE, t_osi_notification_method,
                          T_STATUS_HISTORY.STATHIST_B_I_02, and T_OFFENSE_V2.OFFENSEV2_B_I_02.
    03-Apr-2006 WCC      Updates to deliver procedures and email_send to support FOUO and email length limits.
    10-Aug-2006 WCC      Added DeliverSpot15 and Deliver_INVSPOTEMAIL procedures
    11-Jun-2008 WCC      CheckForIAFISNotifications updated for CR#2634
    30-Sep-2008 WCC      Added a CheckForSurveillanceActivities call into the generate procedure
    07-Sep-2010 JLH      Added generate_cfexpreject
    22-Sep-2010 JAF      CHG0003182 - Added error handling to get_primary_email (post 1.7 build fix).
    09-Nov-2009 TJW      PR#3289 - Added 80, 90, 100 Days Advance Notifications.
                          New Functions checkforcfundadvances and cfundadvanceissuedbydays.
                          Changed in Generate.
    10-Oct-2010 JAF      CHG0003174 - modified deliver_actsurvexpiredemail (currently empty) to return pOK := 'Y'
                         to prevent errors on delivery.
    20-Oct-2010 TJW      PR#3211 - Reviewer Note Notification needed to change generate to
                          update Specifics since :NEW.NOTE_TEXT can not be read in the Trigger.
                           *** These types of notifications can not be Immediate Generation since it will cause a Mutating Trigger.
    25-Oct-2010 TJW      PR#3224 - Check Access Failure Notifications.
                          New Function generate_accessfailed.
    25-Oct-2010 JAF      WCHG0000357 - Removed the priv check from generate_invheadsup.
    01-Dec-2010 JAF      CHG0003182 - Enabled deliver_actsurvexpiredemail.
    19-Jan-2011 WCC      Modified deliver_invspotemail and deliverspot15 to use the sid not code.
    26-Jan-2011 JAF      Modified deliver_generic to omit 'Agent:' label on objects that cannot have a 'Lead Agent' (ie. Cfunds)
    14-Mar-2011 TJW      Changed I2MS:: to core_util.get_config('CORE.BASE_URL') to provide the new style links.
    
*/
    v_pipe             VARCHAR2(50)                       := 'NOTIFICATION';
    v_can_generate     BOOLEAN                            := FALSE;
    -- internal lock to control access to generate routines.
    v_can_deliver      BOOLEAN                            := FALSE;
    -- internal lock to control access to deliver routines.
    v_curr_event_rec   T_OSI_NOTIFICATION_EVENT%ROWTYPE;
    v_sender           VARCHAR2(50)                       := NULL;
    v_sendhost         VARCHAR2(50)                       := NULL;
    v_mailhost         VARCHAR2(30)                       := NULL;
    v_mailport         NUMBER                             := NULL;
    v_max_textmsg      NUMBER                             := NULL;

-- Private support routines
    FUNCTION email_default_addr(pfor IN VARCHAR2)
        RETURN VARCHAR2 IS
        v_rtn   T_OSI_PERSONNEL_CONTACT.VALUE%TYPE   := NULL;
    BEGIN
        FOR e IN (SELECT   VALUE
                      FROM T_OSI_PERSONNEL_CONTACT
                     WHERE personnel = pfor
                       AND TYPE = (SELECT SID
                                     FROM T_OSI_REFERENCE
                                    WHERE USAGE = 'CONTACT_TYPE' AND CODE = 'EMLP')
                       AND VALUE IS NOT NULL
                  ORDER BY modify_on DESC)
        LOOP
            v_rtn := e.VALUE;
            Core_Logger.log_it(v_pipe, 'Default Email Address: ' || v_rtn);
            EXIT;                                                                    -- only need 1
        END LOOP;

        RETURN v_rtn;
    END email_default_addr;

    FUNCTION email_send(precipient IN VARCHAR2, psubject IN VARCHAR2, pmsg IN VARCHAR2)
        RETURN BOOLEAN IS
        v_mail_conn     utl_smtp.connection;
        v_reply         utl_smtp.reply;
        v_tag           VARCHAR2(30);
        v_msg           VARCHAR2(32000);
        v_recipient     VARCHAR2(500);
        v_parent        VARCHAR2(20);
        a_mail_error    EXCEPTION;
        v_mail_suffix   VARCHAR2(20000);

        PROCEDURE log_reply IS
        BEGIN
            Core_Logger.log_it(v_pipe, v_reply.code || ' ' || v_reply.text);
            RETURN;
        END log_reply;
    BEGIN
        v_recipient := LTRIM(RTRIM(precipient));              -- Remove trailing and leading blanks
        v_mail_suffix := Core_Util.GET_CONFIG('OSI.NOTIF_EMAIL_SUFFIX');

        IF     UPPER(v_recipient) LIKE '%' || v_mail_suffix || '%'                 --'%OGN.AF.MIL')
           --AND INSTR(v_recipient, '.') < INSTR(v_recipient, '@')  --JF commented, not needed
           AND REPLACE(TRANSLATE(UPPER(v_recipient),
                                 'ABCDEFGHIJKLMNOPQRSTUVWXYZ1234567890.@',
                                 '**************************************'),
                       '*',
                       '') IS NULL THEN
            IF v_sender IS NULL THEN
                Core_Logger.log_it(v_pipe, 'Getting Email Config Data');
                v_sender := Core_Util.get_config('OSI.NOTIF_SNDR');
                v_sendhost := Core_Util.get_config('OSI.NOTIF_SNDH');
                v_mailhost := Core_Util.get_config('OSI.NOTIF_SRVR');
                v_mailport := Core_Util.get_config('OSI.NOTIF_PORT');
            END IF;

            v_msg :=
                'Subject:FOUO - I2MS Notifications - ' || psubject || utl_tcp.crlf
                || 'Content-TYPE: text/html;' || 'From:I2MS <' || v_sender || '>' || utl_tcp.crlf
                || 'To:' || precipient || utl_tcp.crlf || utl_tcp.crlf
                || '<CENTER><B>This e-mail contains FOR OFFICIAL USE ONLY (FOUO) information which must be protected under the Privacy Act and AFI 33-332.</B></CENTER><HR>'
                || utl_tcp.crlf || REPLACE(pmsg, CHR(13) || CHR(10), '<BR>' || CHR(13) || CHR(10))
                || utl_tcp.crlf
                || '<CENTER><B>This e-mail contains FOR OFFICIAL USE ONLY (FOUO) information which must be protected under the Privacy Act and AFI 33-332.</B></CENTER>';
            Core_Logger.log_it(v_pipe, 'Sending email TO: ' || precipient);
            --CORE_LOGGER.log_it(v_pipe, 'MSG: ' || v_msg);
            v_tag := 'OPEN';
            Core_Logger.log_it(v_pipe, 'Opening Connection: ' || v_mailhost || ' / ' || v_mailport);
            v_reply := utl_smtp.open_connection(v_mailhost, v_mailport, v_mail_conn);
            log_reply;

            IF v_reply.code <> 220 THEN
                RAISE a_mail_error;
            END IF;

            v_tag := 'helo';
            v_reply := utl_smtp.helo(v_mail_conn, v_sendhost);
            log_reply;

            IF v_reply.code <> 250 THEN
                RAISE a_mail_error;
            END IF;

            v_tag := 'mail';
            utl_smtp.mail(v_mail_conn, v_sender);
            v_tag := 'rcpt';
            utl_smtp.rcpt(v_mail_conn, precipient);
            v_tag := 'data';
            utl_smtp.DATA(v_mail_conn, v_msg);
            v_tag := 'quit';
            utl_smtp.quit(v_mail_conn);
            RETURN TRUE;
        ELSE
            Core_Logger.log_it(v_pipe, 'EMAIL_Address Error: ' || precipient);
            RETURN FALSE;
        END IF;
    EXCEPTION
        WHEN a_mail_error THEN
            --utl_smtp.quit(v_mail_conn);
            Core_Logger.log_it(v_pipe, 'EMAIL_Send Error (' || v_tag || '): ' || v_reply.text);
            RETURN FALSE;
        WHEN OTHERS THEN
            --utl_smtp.quit(v_mail_conn);
            Core_Logger.log_it(v_pipe, 'EMAIL_Send Error (' || v_tag || '): ' || SQLERRM);
            Core_Logger.log_it(v_pipe,
                               'EMAIL_Send Error (' || v_tag || '): ' || 'Length: '
                               || TO_CHAR(LENGTH(v_msg)));
            RETURN FALSE;
    END email_send;

    FUNCTION email_update_blank_addresses(pdelivery_method IN VARCHAR2)
        RETURN BOOLEAN IS
        v_cnt   NUMBER;
        v_tmp   VARCHAR2(200);
    BEGIN
        v_cnt := 0;

        FOR n IN (SELECT *
                    FROM T_OSI_NOTIFICATION
                   WHERE delivery_method = pdelivery_method
                     AND delivery_address IS NULL
                     AND delivery_date IS NULL)
        LOOP
            v_tmp := email_default_addr(n.recipient);

            IF v_tmp IS NOT NULL THEN
                UPDATE T_OSI_NOTIFICATION
                   SET delivery_address = v_tmp
                 WHERE SID = n.SID;

                v_cnt := v_cnt + 1;
            END IF;
        END LOOP;

        Core_Logger.log_it(v_pipe, 'Updated ' || v_cnt || ' NULL delivery addresses');
        RETURN TRUE;
    EXCEPTION
        WHEN OTHERS THEN
            Core_Logger.log_it(v_pipe, 'Error UPDATING blank email addresses: ' || SQLERRM);
            RETURN FALSE;
    END email_update_blank_addresses;

    FUNCTION find_closest_interest(
        ppersonnel    IN   VARCHAR2,
        pevent_type   IN   VARCHAR2,
        punit         IN   VARCHAR2 := NULL)
        RETURN T_OSI_NOTIFICATION_INTEREST%ROWTYPE IS
/*
    This routine searches the t_osi_notification_interest table for the row
    that most closely matches the input requirements, and returns that
    row as the function result.

    Parameters:
        Personnel  - The personnel to search for. Required.
        Event_Type - The event code to search for. Required.
        Unit       - The unit to search for. If omitted, it
                     means that the interest record must have
                     a Null unit (meaning interest in all units).

    If a unit is specified, that unit is searched first, and then any
    parent and supporting units.
*/
        v_ni_rec           T_OSI_NOTIFICATION_INTEREST%ROWTYPE   := NULL;
        v_unit             VARCHAR2(20);
        v_subs             NUMBER;
        v_event_type_sid   VARCHAR2(20);
    BEGIN
        --CORE_LOGGER.log_it(v_pipe, '^^^^0:pevent_type=' || pevent_type);
        --SELECT SID INTO V_EVENT_TYPE_SID FROM T_OSI_NOTIFICATION_EVENT_TYPE where CODE = pevent_type;
        --CORE_LOGGER.log_it(v_pipe, '^^^^1');
        -- Check special case where no unit is specified.
        IF punit IS NULL THEN
            Core_Logger.log_it(v_pipe, '^^^^2');
            Core_Logger.log_it(v_pipe, 'IN FIND_CLOSEST_INTEREST:  PUNIT IS NULL!!');
            Core_Logger.log_it(v_pipe, 'PPERSONNEL: ' || PPERSONNEL);
            Core_Logger.log_it(v_pipe, 'PEVENT_TYPE: ' || PEVENT_TYPE);

            BEGIN
                SELECT *
                  INTO v_ni_rec
                  FROM T_OSI_NOTIFICATION_INTEREST
                 WHERE personnel = ppersonnel
                   AND event_type = PEVENT_TYPE
                   AND unit IS NULL
                   AND ROWNUM = 1;
            EXCEPTION
                WHEN NO_DATA_FOUND THEN
                    Core_Logger.log_it(v_pipe, '^^ NO DATA FOUND!');
                    NULL;
            END;

            RETURN v_ni_rec;
        END IF;

        Core_Logger.log_it(v_pipe, '^^^^3');
        -- Check for interest in specified and parent units
        v_unit := punit;
        Core_Logger.log_it(v_pipe, '^^^^2');

        LOOP
            BEGIN
                Core_Logger.log_it(v_pipe,
                                   'IN FIND_CLOSEST_INTEREST (UNIT OR PARENT):  PUNIT IS ' || v_unit);
                Core_Logger.log_it(v_pipe, 'PPERSONNEL: ' || PPERSONNEL);
                Core_Logger.log_it(v_pipe, 'PEVENT_TYPE: ' || PEVENT_TYPE);

                SELECT *
                  INTO v_ni_rec
                  FROM T_OSI_NOTIFICATION_INTEREST
                 WHERE personnel = ppersonnel AND event_type = PEVENT_TYPE AND unit = v_unit;

                RETURN v_ni_rec;
            EXCEPTION
                WHEN NO_DATA_FOUND THEN
                    Core_Logger.log_it(v_pipe, '^^ NO DATA FOUND!');

                    SELECT unit_parent
                      INTO v_unit
                      FROM T_OSI_UNIT
                     WHERE SID = v_unit;
            END;

            EXIT WHEN v_unit IS NULL;
        END LOOP;

        Core_Logger.log_it(v_pipe, '^^^^6');

        -- Check for interest in any supporting unit
        FOR s IN (SELECT DISTINCT sup_unit
                             FROM T_OSI_UNIT_SUP_UNITS
                            WHERE unit = punit)
        LOOP
            BEGIN
                Core_Logger.log_it(v_pipe,
                                   'IN FIND_CLOSEST_INTEREST (SUPPORT):  PUNIT IS ' || punit);
                Core_Logger.log_it(v_pipe, 'PPERSONNEL: ' || PPERSONNEL);
                Core_Logger.log_it(v_pipe, 'PEVENT_TYPE: ' || PEVENT_TYPE);

                SELECT *
                  INTO v_ni_rec
                  FROM T_OSI_NOTIFICATION_INTEREST
                 WHERE personnel = ppersonnel AND event_type = PEVENT_TYPE AND unit = s.sup_unit;

                RETURN v_ni_rec;
            EXCEPTION
                WHEN NO_DATA_FOUND THEN
                    Core_Logger.log_it(v_pipe, '^^ NO DATA FOUND!');
                    NULL;
            END;
        END LOOP;

        -- Check for interest in all units
        BEGIN
            Core_Logger.log_it(v_pipe, 'IN FIND_CLOSEST_INTEREST (ALL):  PUNIT IS ' || punit);
            Core_Logger.log_it(v_pipe, 'PPERSONNEL: ' || PPERSONNEL);
            Core_Logger.log_it(v_pipe, 'PEVENT_TYPE: ' || PEVENT_TYPE);
            Core_Logger.log_it(v_pipe, '^^^^10');

            SELECT *
              INTO v_ni_rec
              FROM T_OSI_NOTIFICATION_INTEREST
             WHERE personnel = ppersonnel AND event_type = PEVENT_TYPE AND unit IS NULL;

            RETURN v_ni_rec;
        EXCEPTION
            WHEN NO_DATA_FOUND THEN
                Core_Logger.log_it(v_pipe, '^^ NO DATA FOUND!');
                NULL;
        END;

        Core_Logger.log_it(v_pipe, '^^ NO INTEREST FOUND!');
        RETURN NULL;                                                        -- no place else to look
    EXCEPTION
        WHEN OTHERS THEN
            Core_Logger.log_it(v_pipe, 'Error during Find_Closest_Interest: ' || SQLERRM);
            RETURN NULL;
    END find_closest_interest;

    FUNCTION insert_notification(
        precipient          IN   VARCHAR2,
        pdelivery_method    IN   VARCHAR2,
        pdelivery_address   IN   VARCHAR2)
        RETURN BOOLEAN IS
        v_nm_rec   T_OSI_NOTIFICATION_METHOD%ROWTYPE;
        v_sid      VARCHAR2(20);
    BEGIN
        IF pdelivery_method IS NOT NULL THEN
            SELECT *
              INTO v_nm_rec
              FROM T_OSI_NOTIFICATION_METHOD
             WHERE SID = pdelivery_method;
        END IF;

        v_sid := Core_Sidgen.next_sid;

        INSERT INTO T_OSI_NOTIFICATION
                    (SID,
                     event,
                     recipient,
                     generation_date,
                     delivery_method,
                     delivery_address,
                     delivery_date)
             VALUES (v_sid,
                     v_curr_event_rec.SID,
                     precipient,
                     SYSDATE,
                     pdelivery_method,
                     pdelivery_address,
                     NULL);

        IF UPPER(v_nm_rec.immediate_delivery) = 'Y' THEN
            deliver(v_sid);
        END IF;

        RETURN TRUE;
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            Core_Logger.log_it(v_pipe, 'Error IN Insert_Notification: Invalid Delivery Method');
            RETURN FALSE;
        WHEN OTHERS THEN
            Core_Logger.log_it(v_pipe, 'Error IN Insert_Notification: ' || SQLERRM);
            RETURN FALSE;
    END insert_notification;

    FUNCTION textmsg_send(precipient IN VARCHAR2, psubject IN VARCHAR2, pmsg IN VARCHAR2)
        RETURN BOOLEAN IS
        v_mail_conn   utl_smtp.connection;
        v_tag         VARCHAR2(30);
        v_msg         VARCHAR2(32000);
        v_recipient   VARCHAR2(500);
    BEGIN
        v_recipient := LTRIM(RTRIM(precipient));              -- Remove trailing and leading blanks

        IF     UPPER(v_recipient) LIKE '%OGN.AF.MIL'
           AND REPLACE(TRANSLATE(UPPER(v_recipient),
                                 'ABCDEFGHIJKLMNOPQRSTUVWXYZ1234567890.@',
                                 '**************************************'),
                       '*',
                       '') IS NULL THEN
            IF v_sender IS NULL THEN
                v_sender := Core_Util.get_config('NOTIF_SNDR');
                v_mailhost := Core_Util.get_config('NOTIF_SRVR');
                v_mailport := Core_Util.get_config('NOTIF_PORT');
            END IF;

            IF v_max_textmsg IS NULL THEN
                v_max_textmsg := Core_Util.get_config('NOTIF_MAX1');
                v_max_textmsg := NVL(v_max_textmsg, 200);
            END IF;

            v_msg := 'Subject: FOUO - ' || psubject || utl_tcp.crlf || utl_tcp.crlf || pmsg;
            v_msg := SUBSTR(v_msg, 1, v_max_textmsg);
            Core_Logger.log_it(v_pipe, 'Sending text message TO: ' || precipient);
            v_tag := 'OPEN';
            v_mail_conn := utl_smtp.open_connection(v_mailhost, v_mailport);
            v_tag := 'helo';
            utl_smtp.helo(v_mail_conn, v_mailhost);
            v_tag := 'mail';
            utl_smtp.mail(v_mail_conn, v_sender);
            v_tag := 'rcpt';
            utl_smtp.rcpt(v_mail_conn, precipient);
            v_tag := 'data';
            utl_smtp.DATA(v_mail_conn, v_msg);
            v_tag := 'quit';
            utl_smtp.quit(v_mail_conn);
            RETURN TRUE;
        ELSE
            Core_Logger.log_it(v_pipe, 'TEXT_Address Error: ' || precipient);
            RETURN FALSE;
        END IF;
    EXCEPTION
        WHEN OTHERS THEN
            Core_Logger.log_it(v_pipe, 'TEXTMSG_Send Error (' || v_tag || '): ' || SQLERRM);
            RETURN FALSE;
    END textmsg_send;

-- Generic Routines (don't need TO be PUBLIC because they are normally called
-- in error handling situations, but they do need to be after all other private
-- support routines.)
    PROCEDURE generate_generic(pok OUT VARCHAR2) IS
/*
    Generate notifications for any personnel interested in the current event
    for the impacted unit. The interest determines the delivery method.
*/
        v_ni_rec       T_OSI_NOTIFICATION_INTEREST%ROWTYPE   := NULL;
        a_problem      EXCEPTION;
        v_event_code   VARCHAR(30);
    BEGIN
        FOR a IN (SELECT DISTINCT personnel
                             FROM T_OSI_NOTIFICATION_INTEREST
                            WHERE event_type = v_curr_event_rec.event_code)
        LOOP
            -- Determine interest and extract delivery method
            v_ni_rec :=
                find_closest_interest(a.personnel,
                                      v_curr_event_rec.event_code,
                                      v_curr_event_rec.impacted_unit);

            IF v_ni_rec.SID IS NOT NULL THEN
                IF NOT insert_notification(a.personnel,
                                           v_ni_rec.delivery_method,
                                           v_ni_rec.delivery_address) THEN
                    RAISE a_problem;
                END IF;
            END IF;
        END LOOP;

        pok := 'Y';
        RETURN;
    EXCEPTION
        WHEN a_problem THEN
            pok := 'N';
            RETURN;
        WHEN OTHERS THEN
            Core_Logger.log_it(v_pipe, 'Error: In Generate_Generic' || SQLERRM);
            pok := 'N';
            RETURN;
    END generate_generic;

    PROCEDURE generate_for_lead_agents(pok OUT VARCHAR2) IS
/*
    Generate notification for lead agent of the file/activity, assuming
    the lead agent specified an interest in this type of notification.
    The interest determines the delivery method.
*/
        v_ni_rec    T_OSI_NOTIFICATION_INTEREST%ROWTYPE   := NULL;
        a_problem   EXCEPTION;
    BEGIN
        FOR a IN (SELECT   *
                      FROM T_OSI_ASSIGNMENT
                     WHERE obj = v_curr_event_rec.PARENT
                       AND assign_role IN(SELECT SID
                                            FROM T_OSI_ASSIGNMENT_ROLE_TYPE
                                           WHERE UPPER(DESCRIPTION) IN('LEAD AGENT', 'EXAMINER'))
                       AND Osi_Personnel.GET_NAME(PERSONNEL) <> v_curr_event_rec.event_by
                  ORDER BY start_date DESC)
        LOOP
            Core_Logger.log_it(v_pipe, 'Found Lead Agent: ' || Osi_Personnel.GET_NAME(a.PERSONNEL));
            -- Determine interest and extract delivery method
            v_ni_rec :=
                find_closest_interest(a.personnel,
                                      v_curr_event_rec.event_code,
                                      v_curr_event_rec.impacted_unit);

            IF v_ni_rec.SID IS NOT NULL THEN
                IF NOT insert_notification(a.personnel,
                                           v_ni_rec.delivery_method,
                                           v_ni_rec.delivery_address) THEN
                    RAISE a_problem;
                END IF;
            ELSE
                Core_Logger.log_it(v_pipe, 'No interest indicated.');
            END IF;

            EXIT;                                            -- only need the most recent lead agent
        END LOOP;

        pok := 'Y';
        RETURN;
    EXCEPTION
        WHEN a_problem THEN
            pok := 'N';
            RETURN;
        WHEN OTHERS THEN
            Core_Logger.log_it(v_pipe, 'Error: ' || SQLERRM);
            pok := 'N';
            RETURN;
    END generate_for_lead_agents;

    PROCEDURE deliver_generic(
        pdeliverymethod   IN       VARCHAR2,
        pok               OUT      VARCHAR2,
        pthis1            IN       VARCHAR2 := NULL) IS
        v_message   VARCHAR2(32000) := NULL;
        v_nl        VARCHAR2(10)    := CHR(10);                                          -- newline
    BEGIN
        Core_Logger.log_it(v_pipe, '>> DELIVER_GENERIC ');
        pok := 'N';

        IF NOT email_update_blank_addresses(pdeliverymethod) THEN
            Core_Logger.log_it(v_pipe, 'EMAIL UPDATE BLANK ADDRESSES: FALSE');
            RETURN;
        END IF;

        -- Loop through all the notifications, grouped by effective address
        FOR a IN (SELECT DISTINCT n.delivery_address, net.description
                             FROM T_OSI_NOTIFICATION n,
                                  T_OSI_NOTIFICATION_EVENT ne,
                                  T_OSI_NOTIFICATION_EVENT_TYPE net
                            WHERE n.delivery_method = pdeliverymethod
                              AND n.delivery_date IS NULL
                              AND n.delivery_address IS NOT NULL
                              AND (   n.SID = pthis1
                                   OR pthis1 IS NULL)
                              AND ne.SID = n.event
                              AND net.SID = ne.event_code)
        LOOP
            v_message := NULL;
            Core_Logger.log_it(v_pipe, 'Starting new message to: ' || a.delivery_address);

            FOR n IN (SELECT   n.*
                          FROM v_osi_notification n
                         WHERE n.delivery_method = pdeliverymethod
                           AND n.delivery_date IS NULL
                           AND n.delivery_address = a.delivery_address
                           AND (   n.SID = pthis1
                                OR pthis1 IS NULL)
                      ORDER BY n.parent_info)
            LOOP
                Core_Logger.log_it(v_pipe, 'INSIDE TEST LOOP');
                         -- v_message := v_message || 'Got Notification (Details follow)' || '<BR>';
                         -- v_message := v_message || 'Address: ' || n.EFF_ADDR || '<BR>';
                         -- v_message := v_message || 'Event: ' || n.DESCRIPTION || '<BR>';
                --
                --v_message := v_message || '<A HREF="' || core_util.get_config('CORE.BASE_URL') || n.PARENT || '"><IMG BORDER=0 ALT="Open in I2MS" SRC="http://hqsbui2ms/images/I2MS/OBJ_SEARCH/i2ms.gif"></A> ';
                v_message :=
                    v_message || '<A HREF="' || core_util.get_config('CORE.BASE_URL') || n.PARENT || '"'
                    || ' Title="Open in I2MS" ' || '>' || n.parent_info || '</A> <BR>';
                --v_message := v_message || n.PARENT_INFO || '<BR>';
                v_message :=
                    v_message || 'Date: ' || TO_CHAR(n.event_on, 'dd-Mon-yyyy hh24:mi:ss')
                    || '<BR>';
                v_message := v_message || 'Unit: ' || n.unit || '<BR>';

                if n.event_by <> 'get_name: Error' then  --occurs on objects that cannot have a 'Lead Agent'
                   v_message := v_message || 'Agent: ' || n.event_by || '<BR>';
                end if;

                v_message := v_message || 'Specifics: ' || n.specifics || '<BR>';
                v_message := v_message || '<BR>';
                Core_Logger.log_it(v_pipe, 'Added to message: ' || n.parent_info);

                UPDATE T_OSI_NOTIFICATION
                   SET delivery_date = SYSDATE
                 WHERE SID = n.SID;

                IF LENGTH(v_message) > 28000 THEN
                    v_message :=
                        v_message || '<HR>'
                        || '<B>YOU HAVE ADDITIONAL NOTIFICATIONS IN I2MS THAT COULD NOT BE SHOWN IN THIS EMAIL DUE TO SIZE LIMITATIONS.</B><BR>';
                    Core_Logger.log_it(v_pipe,
                                       'Added message length notice: ' || LENGTH(v_message));
                    EXIT;
                END IF;
            END LOOP;

            IF email_send(a.delivery_address, a.description, v_message) THEN
                NULL;
            END IF;
        END LOOP;

        pok := 'Y';
        Core_Logger.log_it(v_pipe, '<< DELIVER_GENERIC ');
        RETURN;
    EXCEPTION
        WHEN OTHERS THEN
            Core_Logger.log_it(v_pipe, 'Error: ' || SQLERRM);
            pok := 'N';
            Core_Logger.log_it(v_pipe, '<< DELIVER_GENERIC ');
    END deliver_generic;

-- DETECTION
    PROCEDURE detect_actleadlate IS
        v_event_by        VARCHAR2(50)   := 'Detect_ACTLEADLATE';
        --Current Event is Detect_ACTLEADLATE
        v_event_type      VARCHAR2(50)   := 'ACT.LEADLATE';      --Event_Type for this notification
        v_lag_code        VARCHAR2(50)   := 'OSI.NOTIF_LAT1';
        --CODE in T_I2MS_CONFIG for Activity Lead Past Suspense Date
        v_lag             NUMBER         := 0; --time lag allowed for inactivity past suspense date
        v_counter         NUMBER         := 0;                            --count resulting records
        v_parent          VARCHAR2(200);
        v_parent_info     VARCHAR2(200);
        v_event_on        DATE;
        v_impacted_unit   VARCHAR2(200);
        v_specifics       VARCHAR2(1000);
    BEGIN
           -- Loop through all the activities
        -- where the auxiliary unit and the created_by unit are different,
        -- the current date is past the suspense date by v_LAG
        -- and the complete and closed dates are null
        Core_Logger.log_it(v_pipe, '>>> ' || v_event_by || ': started');          --Start Procedure
        v_lag := Core_Util.get_config(v_lag_code);                  --GET v_lag based on v_lag_code

        FOR n IN (SELECT a.*
                    FROM v_osi_activity_summary a
                   WHERE a.creating_unit <> a.auxiliary_unit
                     AND a.suspense_date IS NOT NULL
                     AND (a.suspense_date <= SYSDATE - v_lag)
                     AND a.complete_date IS NULL
                     AND a.close_date IS NULL)
        LOOP
            v_counter := v_counter + 1;
            v_parent := n.SID;
            v_parent_info := n.ID || ' - ' || n.title;
            v_event_on := SYSDATE;
            v_impacted_unit := NULL;

            FOR i IN (SELECT *
                        FROM T_OSI_UNIT
                       WHERE UNIT_CODE = n.CREATING_UNIT)
            LOOP
                v_impacted_unit := i.SID;
            END LOOP;

            --v_impacted_unit := n.creating_unit;
            v_specifics := 'Assigned to Unit ' || n.assigned_unit;
            v_specifics := v_specifics || ' with a Suspense Date of ' || n.suspense_date;
            Osi_Notification.record_detection(v_event_type,
                                              v_parent,
                                              v_parent_info,
                                              v_event_by,
                                              v_event_on,
                                              v_impacted_unit,
                                              v_specifics);
        -- CORE_LOGGER.log_it(v_pipe, '>>> ' || v_Event_By || ' ' || v_counter || '. ' || v_Parent || ' / ' || v_Parent_Info);
        END LOOP;

        COMMIT;
        Core_Logger.log_it(v_pipe, v_counter || ' records found.');
        Core_Logger.log_it(v_pipe, '<<< ' || v_event_by || ': stopped');            --Stop Procedure
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            Core_Logger.log_it(v_pipe, '!!! ' || v_event_by || ': No Data Found');
        WHEN OTHERS THEN
            Core_Logger.log_it(v_pipe, '!!! ' || v_event_by || ': Error: ' || SQLERRM);
    END detect_actleadlate;

    PROCEDURE detect_invinactive IS
        v_event_by           VARCHAR2(50)   := 'Detect_INVINACTIVE';
        --Current Event is Detect_INVINACTIVE
        v_event_type         VARCHAR2(50)   := 'INV.INACTIVE';   --Event_Type for this notification
        v_lag_code           VARCHAR2(50)   := 'OSI.NOTIF_LAT2';
        --CODE in T_I2MS_CONFIG for No Activity on Open Investigation.
        v_type_code          VARCHAR2(50)   := 'INVSTGTV';
        --CODE in T_FILE_V2 for Investigative Files
        v_lag                NUMBER         := 0; --time lag allowed for inactivity past given date
        v_counter            NUMBER         := 0;                         --count resulting records
        v_parent             VARCHAR2(200);
        v_parent_info        VARCHAR2(200);
        v_event_on           DATE;
        v_impacted_unit      VARCHAR2(200);
        v_specifics          VARCHAR2(1000);
        x_active             EXCEPTION;                     --FLAG for files which are still active
        v_last_modify_by     VARCHAR2(200);                                 --Most recent Modify By
        v_last_modify_on     DATE;                                     --Most recent Modify On date
        v_last_modify_desc   VARCHAR2(50);               --Most recently modified table description
    BEGIN
        Core_Logger.log_it(v_pipe, '>>> ' || v_event_by || ': started');          --Start Procedure
        v_lag := Core_Util.get_config(v_lag_code);                  --GET v_lag based on v_lag_code

        -- Initially loop through candidate records in T_FILE_V2
        -- Only look at Investigative Files (TYPE_CODE='INVSTGTV') and
        -- Only look at those with inactivity (MODIFY_ON <= sysdate - v_lag)
        -- Only look at Open Investigative Files (STATUS ='OP' )
        FOR n IN (SELECT obj.SID AS OBJ_SID, obj.MODIFY_ON AS obj_modify_on,
                         obj.MODIFY_BY AS OBJ_MODIFY_BY, fyle.*,
                         Osi_File.GET_UNIT_OWNER(fyle.SID) AS OWNING_UNIT,
                         Osi_Object.GET_STATUS(obj.SID) AS CURRENT_STATUS
                    FROM T_OSI_FILE fyle, T_OSI_F_INVESTIGATION inv, T_CORE_OBJ obj
                   WHERE fyle.SID = inv.SID
                     AND fyle.SID = obj.SID
                     AND (obj.modify_on <= SYSDATE - v_lag)
                     AND UPPER(Osi_Object.GET_STATUS(obj.SID)) = 'OPEN')
        LOOP
            BEGIN
                v_parent := n.SID;
                v_parent_info := n.ID || ' - ' || n.title;
                v_event_on := SYSDATE;
                v_impacted_unit := n.owning_unit;
                v_last_modify_by := n.obj_modify_by;
                v_last_modify_on := n.obj_modify_on;
                v_last_modify_desc := 'Investigative File';

                --Look at each T_INVESTIGATIVE child table:
                --   T_ARREST, T_INVESTIGATIVE_CR05, T_INVESTIGATIVE_CR17, T_INVESTIGATIVE_DISPOSITION,
                --   T_OFFENSE_V2, T_SPECIFICATION_V2, T_SUBJECT_DISPOSITION, T_PROPERTY, T_INCIDENT
                BEGIN
                    --Look for updates to child tables
                    FOR m IN (
                              /*select 'Arrest' modify_desc, modify_by, modify_on
                                from t_arrest
                               where investigation = v_parent
                              union
                              select 'CR05' modify_desc, modify_by, modify_on
                                from t_investigative_cr05
                               where investigation = v_parent
                              union
                              select 'CR17' modify_desc, modify_by, modify_on
                                from t_investigative_cr17
                               where investigation = v_parent

                              union*/
                              SELECT 'Investigative Disposition' modify_desc, modify_by, modify_on
                                FROM T_OSI_F_INV_DISPOSITION
                               WHERE investigation = v_parent
                              UNION
                              SELECT 'Offense' modify_desc, modify_by, modify_on
                                FROM T_OSI_F_INV_OFFENSE
                               WHERE investigation = v_parent
                              UNION
                              SELECT 'Specification' modify_desc, modify_by, modify_on
                                FROM T_OSI_F_INV_SPEC
                               WHERE investigation = v_parent
                              UNION
                              SELECT 'Subject Disposition' modify_desc, modify_by, modify_on
                                FROM T_OSI_F_INV_SUBJ_DISPOSITION
                               WHERE investigation = v_parent
                              UNION
                              SELECT 'Property' modify_desc, p.modify_by, p.modify_on
                                FROM T_OSI_F_INV_PROPERTY p, T_OSI_F_INV_SPEC s
                               WHERE p.SPECIFICATION = s.SID AND s.investigation = v_parent
                              UNION
                              SELECT 'Incident' modify_desc, a.modify_by, a.modify_on
                                FROM T_OSI_F_INV_INCIDENT a, T_OSI_F_INV_INCIDENT_MAP b
                               WHERE b.investigation = v_parent AND b.incident = a.SID)
                    LOOP
                        --Determine the most recent table update
                        IF m.modify_on > v_last_modify_on THEN
                            v_last_modify_on := m.modify_on;
                            v_last_modify_by := m.modify_by;
                            v_last_modify_desc := m.modify_desc;
                        ELSIF m.modify_on = v_last_modify_on THEN
                            --track all changes with the same date
                            v_last_modify_by := v_last_modify_by || ' & ' || m.modify_by;
                            v_last_modify_desc := v_last_modify_desc || ' & ' || m.modify_desc;
                        END IF;
                    END LOOP;

                    --If the latest Modify_On date is recent then current record is active)
                    IF (v_last_modify_on > SYSDATE - v_lag) THEN
                        RAISE x_active;
                    END IF;
                EXCEPTION
                    --If NO_DATA_FOUND then there are no recent updates to the Investigative File
                    WHEN NO_DATA_FOUND THEN
                        NULL;
                END;

                v_specifics := 'Last Modified ' || RTRIM(v_last_modify_desc);
                v_specifics := v_specifics || ' on ' || v_last_modify_on;
                v_specifics := v_specifics || ' by ' || v_last_modify_by;
                Core_Logger.log_it(v_pipe, 'ABOUT TO DO RECORED_DETECTION');
                Osi_Notification.record_detection(v_event_type,
                                                  v_parent,
                                                  v_parent_info,
                                                  v_event_by,
                                                  v_event_on,
                                                  v_impacted_unit,
                                                  v_specifics);
                v_counter := v_counter + 1;
                Core_Logger.log_it(v_pipe,
                                   '>>> ' || v_Event_By || ' ' || v_counter || '. ' || v_Parent
                                   || ' / ' || v_Parent_Info);
            EXCEPTION
                WHEN x_active THEN
                    NULL;             --If the File is Active then exclude it from the Notification
                WHEN OTHERS THEN
                    Core_Logger.log_it(v_pipe, '!!! ' || v_event_by || ': Error: ' || SQLERRM);
            END;
        END LOOP;

        COMMIT;
        Core_Logger.log_it(v_pipe, '<<< ' || v_event_by || ': stopped');            --Stop Procedure
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            Core_Logger.log_it(v_pipe, '!!!! ' || v_event_by || ': No Data Found');
        WHEN OTHERS THEN
            Core_Logger.log_it(v_pipe, '!!!! ' || v_event_by || ': Error: ' || SQLERRM);
    END detect_invinactive;

    PROCEDURE detect_perchanged IS
        v_event_type       VARCHAR2(50)                                  := 'PER.CHANGED';
        --Event_Type for this notification
        v_begin_run_code   VARCHAR2(50)                                  := 'OSI.NOTIF_LR1';
        --CODE in T_I2MS_CONFIG for begin date/time range to run Detect_PERCHANGED
        v_end_run_code     VARCHAR2(50)                                  := 'OSI.NOTIF_LR2';
        --CODE in T_I2MS_CONFIG for end date/time range to run Detect_PERCHANGED
        v_begin_run        DATE;                                            --begin date/time range
        v_end_run          DATE;                                         --end date/time code range
        v_cnt              NUMBER                                        := 0;
        --count resulting records
        v_parent           T_OSI_NOTIFICATION_EVENT.PARENT%TYPE;
        v_last_parent      T_OSI_NOTIFICATION_EVENT.PARENT%TYPE;
        v_parent_info      T_OSI_NOTIFICATION_EVENT.parent_info%TYPE;
        v_event_by         T_OSI_NOTIFICATION_EVENT.event_by%TYPE;
        v_event_on         T_OSI_NOTIFICATION_EVENT.event_on%TYPE;
        v_impacted_unit    T_OSI_NOTIFICATION_EVENT.impacted_unit%TYPE;
        v_specifics        T_OSI_NOTIFICATION_EVENT.specifics%TYPE;
        v_count            NUMBER;
    BEGIN
        --GET PREVIOUS DATE RANGE
        v_begin_run := TO_DATE(Core_Util.get_config(v_begin_run_code), 'DD-MON-YYYY hh24:mi:ss');
        --GET begin date/time range fron I2MS Config
        v_end_run := TO_DATE(Core_Util.get_config(v_end_run_code), 'DD-MON-YYYY hh24:mi:ss');
                                                         --GET end date/time range fron I2MS Config
        --UPDATE DATE RANGE
        v_begin_run := v_end_run;
        v_end_run := SYSDATE;
        Core_Logger.log_it(v_pipe, 'BEGIN RUN: ' || v_begin_run);
        Core_Logger.LOG_IT(v_pipe, 'END RUN:   ' || v_end_run);

        --update I2MS_CONFIG table with new begin and end dates
        UPDATE T_CORE_CONFIG
           SET setting = TO_CHAR(v_begin_run, 'DD-MON-YYYY hh24:mi:ss')
         WHERE code = v_begin_run_code;

        UPDATE T_CORE_CONFIG
           SET setting = TO_CHAR(v_end_run, 'DD-MON-YYYY hh24:mi:ss')
         WHERE code = v_end_run_code;

        Core_Logger.log_it(v_pipe,
                           '>>> Detect_PERCHANGED: started. Date Range:' || v_begin_run || '-'
                           || v_end_run);                                          --Start Procedure
        Core_Logger.log_it('I2MS.DEBUG',
                           '>>> Detect_PERCHANGED started. Date Range:' || v_begin_run || '-'
                           || v_end_run);                                          --Start Procedure
        v_last_parent := NULL;
        Core_Logger.log_it(v_pipe, v_begin_run);
        Core_Logger.LOG_IT(v_pipe, v_end_run);

        -- Loop through all participants changed since Detect_PERCHANGED was last run
        --This includes participants with a different T_PERSON_VERSION.SID but the same T_PERSON_VERSION.PERSON
        FOR m IN (
                  --GET ALL PERSON_VERSIONS WHICH HAVE BEEN MODIFIED
                  --FIND THE PERSON LINKED TO THAT PERSON_VERSION
                  SELECT   pv.participant, pvs.partic_version, pvs.modify_by, pvs.modify_on
                      FROM T_OSI_PARTICIPANT_VERSION pv,
                           (
                            --GET ALL MODIFY_ON DATES AFTER v_last_run FROM PERSON-RELATED TABLES
                            SELECT SID partic_version, modify_by, modify_on
                              FROM T_OSI_PARTICIPANT_VERSION
                             WHERE modify_on > v_begin_run AND modify_on <= v_end_run
                            UNION ALL
                            SELECT partic_a partic_version, modify_by, modify_on
                              FROM T_OSI_PARTIC_RELATION
                             WHERE modify_on > v_begin_run AND modify_on <= v_end_run
                            UNION ALL
                            SELECT partic_b partic_version, modify_by, modify_on
                              FROM T_OSI_PARTIC_RELATION
                             WHERE modify_on > v_begin_run AND modify_on <= v_end_run
                            UNION ALL
                            SELECT participant_version partic_version, modify_by, modify_on
                              FROM T_OSI_PARTIC_NUMBER
                             WHERE modify_on > v_begin_run AND modify_on <= v_end_run
                            UNION ALL
                            SELECT participant_version partic_version, modify_by, modify_on
                              FROM T_OSI_PARTIC_MARK
                             WHERE modify_on > v_begin_run AND modify_on <= v_end_run
                            UNION ALL
                            SELECT participant_version partic_version, modify_by, modify_on
                              FROM T_OSI_PARTIC_NAME
                             WHERE modify_on > v_begin_run AND modify_on <= v_end_run
                            UNION ALL
                            SELECT participant_version partic_version, modify_by, modify_on
                              FROM T_OSI_PARTIC_CONTACT
                             WHERE modify_on > v_begin_run AND modify_on <= v_end_run
                            UNION ALL
                            SELECT participant_version partic_version, modify_by, modify_on
                              FROM T_OSI_PARTIC_ADDRESS
                             WHERE modify_on > v_begin_run AND modify_on <= v_end_run) pvs
                     WHERE pv.SID = pvs.partic_version
                  ORDER BY pv.participant, pvs.modify_on DESC)
        LOOP
            Core_Logger.log_it(v_pipe, 'INSIDE LOOP SO AT LEAST ONE RECORD FOUND!!!');
            v_parent := m.participant;
            v_event_by := m.modify_by;
            v_event_on := m.modify_on;
            v_impacted_unit := NULL;
            v_specifics := NULL;

            FOR I IN (SELECT *
                        FROM T_CORE_PERSONNEL
                       WHERE Osi_Personnel.GET_NAME(SID) = UPPER(v_event_by))
            LOOP
                v_EVENT_BY := I.SID;
            END LOOP;

            --LOOP ONCE FOR EACH PERSON
            IF v_last_parent <> v_parent THEN
                v_cnt := v_cnt + 1;                         --ONLY COUNT ONCE FOR EACH PERSON FOUND
                v_parent_info := Osi_Participant.GET_NAME(v_parent);
                --GET FIRST AVAILABLE NAME (LEGAL NAME IF IT EXISTS)
                Core_Logger.log_it(v_pipe,
                                   '>>> ' || v_event_by || ' ' || v_event_on || ' ' || v_cnt || '. '
                                   || v_parent || ' [' || v_parent_info || '] ' || m.modify_by
                                   || ':::' || m.modify_on);
                Core_Logger.log_it('I2MS.DEBUG',
                                   '>>> ' || v_event_by || ' ' || v_event_on || ' ' || v_cnt || '. '
                                   || v_parent || ' [' || v_parent_info || '] ' || m.modify_by
                                   || ':::' || m.modify_on);
                Osi_Notification.record_detection(v_event_type,
                                                  v_parent,
                                                  v_parent_info,
                                                  v_event_by,
                                                  v_event_on,
                                                  v_impacted_unit,
                                                  v_specifics);
            END IF;

            v_last_parent := m.participant;
        END LOOP;

        COMMIT;
        Core_Logger.log_it(v_pipe, v_cnt || ' records found.');
        Core_Logger.log_it(v_pipe, '<<< Detect_PERCHANGED: stopped');               --Stop Procedure
        Core_Logger.log_it('I2MS.DEBUG', v_cnt || ' records found.');
        Core_Logger.log_it('I2MS.DEBUG', '<<< Detect_PERCHANGED: stopped');         --Stop Procedure
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            Core_Logger.log_it(v_pipe, '!!! ' || v_event_by || ': No Data Found');
            Core_Logger.log_it('I2MS.DEBUG', '!!! ' || v_event_by || ': No Data Found');
        WHEN OTHERS THEN
            Core_Logger.log_it(v_pipe, '!!! ' || v_event_by || ': Error: ' || SQLERRM);
            Core_Logger.log_it('I2MS.DEBUG', '!!! ' || v_event_by || ': Error: ' || SQLERRM);
    END detect_perchanged;

    PROCEDURE detect_tmexpiration IS
        v_event_by           VARCHAR2(50)                                  := 'Detect_TMEXPIRATION';
        --Current Event is Detect_TMEXPIRATION
        v_event_type         VARCHAR2(50)                                  := 'TM.EXPIRATION';
        --Event_Type for this notification
        v_counter            NUMBER                                        := 0;
        --count resulting records
        v_subcounter         NUMBER                                        := 0; --count duplicates
        v_months_until_exp   NUMBER                                        := 0;
        --number of months until expiration date
        v_reminder_text      VARCHAR2(100)                                 := '';
        v_code_attendee      VARCHAR2(100)                                 := '';
        v_parent             T_OSI_NOTIFICATION_EVENT.PARENT%TYPE;
        v_parent_info        T_OSI_NOTIFICATION_EVENT.parent_info%TYPE;
        v_event_on           T_OSI_NOTIFICATION_EVENT.event_on%TYPE;
        v_impacted_unit      T_OSI_NOTIFICATION_EVENT.impacted_unit%TYPE;
        v_specifics          T_OSI_NOTIFICATION_EVENT.specifics%TYPE;
    BEGIN
        NULL;
    END detect_tmexpiration;

    PROCEDURE record_detection(
        pevent_type      IN   VARCHAR2,
        pparent          IN   VARCHAR2,
        pparent_info     IN   VARCHAR2,
        pevent_by        IN   VARCHAR2,
        pevent_on        IN   DATE,
        pimpacted_unit   IN   VARCHAR2,
        pspecifics       IN   VARCHAR2) IS
/*
    This routine is used by various database triggers and timed jobs
    to record event detections. This routine verifies that the event
    type is valid, and also determines if the event should be immediately
    generated. If so, it generates the notifications for the event.

    Parameters: (Correspond to columns of T_NOTIFICATION_EVENT)
*/
        v_net_rec   T_OSI_NOTIFICATION_EVENT_TYPE%ROWTYPE;
        v_sid       VARCHAR2(20);
    BEGIN
        Core_Logger.log_it(v_pipe, 'RECORD_DETECTION CALLED / EVENT_TYPE: ' || pevent_type);

        SELECT *
          INTO v_net_rec
          FROM T_OSI_NOTIFICATION_EVENT_TYPE
         WHERE code = pevent_type;

        Core_Logger.log_it(v_pipe, 'DEBUG: EVENT_TYPE: ' || pevent_type);

        IF UPPER(v_net_rec.active) <> 'Y' THEN
            Core_Logger.log_it(v_pipe,
                               'Record_Detection: Inactive Event Type - ' || v_net_rec.code);
            RETURN;
        END IF;

        v_sid := Core_Sidgen.NEXT_SID;
        --SELECT SID INTO pevent_type FROM T_OSI_NOTIFICATION_EVENT_TYPE WHERE CODE = pevent_type;
        Core_Logger.log_it(v_pipe, 'RECORD_DETECTION ABOUT TO INSERT EVENT');

        INSERT INTO T_OSI_NOTIFICATION_EVENT
                    (SID,
                     event_code,
                     PARENT,
                     parent_info,
                     event_by,
                     event_on,
                     impacted_unit,
                     specifics,
                     GENERATED)
             VALUES (v_sid,
                     v_net_rec.SID,
                     pparent,
                     pparent_info,
                     pevent_by,
                     pevent_on,
                     pimpacted_unit,
                     pspecifics,
                     'N');

        Core_Logger.log_it(v_pipe, 'Record_Detection: ' || pevent_type || ' on ' || pparent_info);

        -- Check for immediate generation
        IF UPPER(v_net_rec.immediate_generation) = 'Y' THEN
            Core_Logger.log_it(v_pipe, 'Record_Detection: Immediate Generation Requested');
            generate(v_sid);
        END IF;

        RETURN;
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            Core_Logger.log_it(v_pipe, 'Error in Record_Detection. Details follow:');
            Core_Logger.log_it(v_pipe, '.  Event Type:  ' || pevent_type);
            Core_Logger.log_it(v_pipe, '.  Error Msg:   Invalid event type');
            RETURN;
        WHEN OTHERS THEN
            Core_Logger.log_it(v_pipe, 'Error in Record_Detection. Details follow:');
            Core_Logger.log_it(v_pipe, '.  Event Type:  ' || pevent_type);
            Core_Logger.log_it(v_pipe, '.  Parent Info: ' || pparent_info);
            Core_Logger.log_it(v_pipe, '.  Specifics:   ' || pspecifics);
            Core_Logger.log_it(v_pipe, '.  Error Msg:   ' || SQLERRM);
            RETURN;
    END record_detection;

    PROCEDURE checkcasesapproachingdaysopen IS
        v_cnt                  NUMBER;
        v_records              NUMBER;
        v_lastsid              VARCHAR2(20)                              := '~~~VERY_FIRST_ONE~~~';
        v_lastid               VARCHAR2(100);
        v_lasttitle            VARCHAR2(300);
        v_lastopened           DATE;
        v_unit                 VARCHAR2(20);
        v_specifics            T_OSI_NOTIFICATION_EVENT.specifics%TYPE;
        v_status_sid           VARCHAR2(20)                              := NULL;
        v_event_sid_not_code   VARCHAR2(20)                              := NULL;
    BEGIN
        Core_Logger.log_it(v_pipe, '>>> CheckCasesApproachingDaysOpen');

-----------------------------------------------------
-----------------------------------------------------
-- Check for Fraud Cases approaching 180 days open --
-----------------------------------------------------
-----------------------------------------------------
        SELECT SID
          INTO v_status_sid
          FROM T_OSI_STATUS
         WHERE CODE = 'OP';

        SELECT COUNT(*)
          INTO v_records
          FROM T_OSI_F_INVESTIGATION f, T_OSI_F_INV_OFFENSE o
         WHERE f.SID = o.investigation
           AND o.offense IN(
                   SELECT SID
                     FROM T_DIBRS_OFFENSE_TYPE
                    WHERE CODE IN
                              ('132-A-', '132-B-', '132-C-', '132-D-', '132-E-', '132-F-', '083-A-',
                               '083-B-'))
           AND Get_Days_Since_Opened(f.SID) = 178;

        Core_Logger.log_it(v_pipe,
                           'Generating Events for Fraud Cases Approaching 180 Days Open:  '
                           || v_records || ' case(s) found!');

        FOR fraud IN (SELECT   f.SID AS fyle, f.ID AS ID, f.title AS title,
                               Osi_Status.last_sh_date(f.SID, 'OP') AS opened,
                               dot.description AS odesc
                          FROM T_OSI_FILE f, T_OSI_F_INV_OFFENSE o, T_DIBRS_OFFENSE_TYPE dot
                         WHERE f.SID = o.investigation
                           AND dot.SID = o.offense
                           AND o.offense IN(
                                   SELECT SID
                                     FROM T_DIBRS_OFFENSE_TYPE
                                    WHERE CODE IN
                                              ('132-A-', '132-B-', '132-C-', '132-D-', '132-E-',
                                               '132-F-', '083-A-', '083-B-'))
                           AND Get_Days_Since_Opened(f.SID) = 178
                      ORDER BY f.SID, o.offense)
        LOOP
            BEGIN
                IF v_lastsid <> fraud.fyle THEN
                    IF v_lastsid <> '~~~VERY_FIRST_ONE~~~' THEN
                        SELECT unit_sid
                          INTO v_unit
                          FROM T_OSI_F_UNIT
                         WHERE file_sid = v_lastsid AND end_date IS NULL;

                        Core_Logger.LOG_IT('NOTIFICATION', 'UNIT SID: ' || v_unit);

                        SELECT COUNT(*)
                          INTO v_records
                          FROM T_OSI_NOTIFICATION_EVENT
                         WHERE event_code = 'INV.FRAUD.180' AND PARENT = v_lastsid;

                        IF v_records = 0 THEN
                            INSERT INTO T_OSI_NOTIFICATION_EVENT
                                        (SID,
                                         event_code,
                                         PARENT,
                                         parent_info,
                                         event_by,
                                         event_on,
                                         impacted_unit,
                                         specifics,
                                         GENERATED)
                                 VALUES (NULL,
                                         'INV.FRAUD.180',
                                         v_lastsid,
                                         'File:  ' || v_lastid || ' - ' || v_lasttitle,
                                         'I2MS',
                                         SYSDATE,
                                         v_unit,
                                         'Fraud Offenses:' || v_specifics,
                                         'N');
                        END IF;
                    END IF;

                    v_lastsid := fraud.fyle;
                    v_lastid := fraud.ID;
                    v_lasttitle := fraud.title;
                    v_lastopened := fraud.opened;
                    v_cnt := 1;
                    v_specifics := ' (' || v_cnt || ') ' || fraud.odesc;
                ELSE
                    v_cnt := v_cnt + 1;
                    v_specifics := v_specifics || ' (' || v_cnt || ') ' || fraud.odesc;
                END IF;
            END;
        END LOOP;

        IF v_specifics IS NOT NULL THEN
            SELECT COUNT(*)
              INTO v_records
              FROM T_OSI_NOTIFICATION_EVENT
             WHERE event_code = 'INV.FRAUD.180' AND PARENT = v_lastsid;

            IF v_records = 0 THEN
                Core_Logger.log_it(v_pipe,
                                   '>>> CheckCasesApproachingDaysOpen: About to insert event');
                Core_Logger.log_it(v_pipe,
                                   '>>> CheckCasesApproachingDaysOpen: V_LAST_SID:' || v_lastsid);

                SELECT SID
                  INTO v_event_sid_not_code
                  FROM T_OSI_NOTIFICATION_EVENT_TYPE
                 WHERE CODE = 'INV.FRAUD.180';

                SELECT unit_sid
                  INTO v_unit
                  FROM T_OSI_F_UNIT
                 WHERE file_sid = v_lastsid AND end_date IS NULL;

                Core_Logger.LOG_IT('NOTIFICATION', 'UNIT SID: ' || v_unit);

                INSERT INTO T_OSI_NOTIFICATION_EVENT
                            (SID,
                             event_code,
                             PARENT,
                             parent_info,
                             event_by,
                             event_on,
                             impacted_unit,
                             specifics,
                             GENERATED)
                     VALUES (NULL,
                             v_event_sid_not_code,
                             v_lastsid,
                             'File:  ' || v_lastid || ' - ' || v_lasttitle,
                             'I2MS',
                             SYSDATE,
                             v_unit,
                             'Fraud Offenses:' || v_specifics,
                             'N');
            END IF;
        END IF;

        Core_Logger.log_it(v_pipe, '>>> CheckCasesApproachingDaysOpen: EVENT INSERTED');
-------------------------------------------------------
-------------------------------------------------------
-- Check for Criminal Cases approaching 90 days open --
-------------------------------------------------------
-------------------------------------------------------
        v_cnt := 0;
        v_records := 0;
        v_lastsid := '~~~VERY_FIRST_ONE~~~';
        v_lastid := '';
        v_lasttitle := '';
        v_lastopened := NULL;
        v_unit := '';
        v_specifics := NULL;

        SELECT COUNT(*)
          INTO v_records
          FROM T_OSI_FILE f, T_OSI_F_INV_OFFENSE o
         WHERE f.SID = o.investigation
           AND o.offense NOT IN(
                   SELECT SID
                     FROM T_DIBRS_OFFENSE_TYPE
                    WHERE CODE IN
                              ('132-A-', '132-B-', '132-C-', '132-D-', '132-E-', '132-F-', '083-A-',
                               '083-B-'))
           AND Get_Days_Since_Opened(f.SID) = 88;

        Core_Logger.log_it(v_pipe,
                           'Generating Events for Criminal Cases Approaching 90 Days Open:  '
                           || v_records || ' case(s) found!');

        FOR fraud IN (SELECT   f.SID AS fyle, f.ID AS ID, f.title AS title,
                               Osi_Status.last_sh_date(f.SID, 'OP') AS opened,
                               dot.description AS odesc
                          FROM T_OSI_FILE f, T_OSI_F_INV_OFFENSE o, T_DIBRS_OFFENSE_TYPE dot
                         WHERE f.SID = o.investigation
                           AND dot.SID = o.offense
                           AND o.offense NOT IN(
                                   SELECT SID
                                     FROM T_DIBRS_OFFENSE_TYPE
                                    WHERE CODE IN
                                              ('132-A-', '132-B-', '132-C-', '132-D-', '132-E-',
                                               '132-F-', '083-A-', '083-B-'))
                           AND Get_Days_Since_Opened(f.SID) = 88
                      ORDER BY f.SID, o.offense)
        LOOP
            BEGIN
                IF v_lastsid <> fraud.fyle THEN
                    IF v_lastsid <> '~~~VERY_FIRST_ONE~~~' THEN
                        SELECT unit_sid
                          INTO v_unit
                          FROM T_OSI_F_UNIT
                         WHERE file_sid = v_lastsid AND end_date IS NULL;

                        SELECT SID
                          INTO v_event_sid_not_code
                          FROM T_OSI_NOTIFICATION_EVENT_TYPE
                         WHERE CODE = 'INV.CRIME.90';

                        SELECT COUNT(*)
                          INTO v_records
                          FROM T_OSI_NOTIFICATION_EVENT
                         WHERE event_code = v_event_sid_not_code AND PARENT = v_lastsid;

                        IF v_records = 0 THEN
                            INSERT INTO T_OSI_NOTIFICATION_EVENT
                                        (SID,
                                         event_code,
                                         PARENT,
                                         parent_info,
                                         event_by,
                                         event_on,
                                         impacted_unit,
                                         specifics,
                                         GENERATED)
                                 VALUES (NULL,
                                         v_event_sid_not_code,
                                         v_lastsid,
                                         'File:  ' || v_lastid || ' - ' || v_lasttitle,
                                         'I2MS',
                                         SYSDATE,
                                         v_unit,
                                         'Offenses:' || v_specifics,
                                         'N');
                        END IF;
                    END IF;

                    v_lastsid := fraud.fyle;
                    v_lastid := fraud.ID;
                    v_lasttitle := fraud.title;
                    v_lastopened := fraud.opened;
                    v_cnt := 1;
                    v_specifics := ' (' || v_cnt || ') ' || fraud.odesc;
                ELSE
                    v_cnt := v_cnt + 1;
                    v_specifics := v_specifics || ' (' || v_cnt || ') ' || fraud.odesc;
                END IF;
            END;
        END LOOP;

        IF v_specifics IS NOT NULL THEN
            SELECT SID
              INTO v_event_sid_not_code
              FROM T_OSI_NOTIFICATION_EVENT_TYPE
             WHERE CODE = 'INV.CRIME.90';

            SELECT COUNT(*)
              INTO v_records
              FROM T_OSI_NOTIFICATION_EVENT
             WHERE event_code = v_event_sid_not_code AND PARENT = v_lastsid;

            IF v_records = 0 THEN
                SELECT unit_sid
                  INTO v_unit
                  FROM T_OSI_F_UNIT
                 WHERE file_sid = v_lastsid AND end_date IS NULL;

                Core_Logger.LOG_IT('NOTIFICATION', 'UNIT SID: ' || v_unit);

                INSERT INTO T_OSI_NOTIFICATION_EVENT
                            (SID,
                             event_code,
                             PARENT,
                             parent_info,
                             event_by,
                             event_on,
                             impacted_unit,
                             specifics,
                             GENERATED)
                     VALUES (NULL,
                             v_event_sid_not_code,
                             v_lastsid,
                             'File:  ' || v_lastid || ' - ' || v_lasttitle,
                             'I2MS',
                             SYSDATE,
                             v_unit,
                             'Offenses:' || v_specifics,
                             'N');
            END IF;
        END IF;

        Core_Logger.log_it(v_pipe, '<<< CheckCasesApproachingDaysOpen');
    END checkcasesapproachingdaysopen;

--    18-Jun-08 TJW      PR#2702 - Make sure File/Activity ID shows in text incase HTML Link doesn't work.
--                     Changed in checkforiafisnotifications.

    -------------------------------------------------------------------------------------------------
---- PR#1967 - Notifications for IAFIS                                                       ----
----           New Function                                                                  ----
---- PR#2634 - Added OR R.RESPONSE_TEXT LIKE '%Updated information has been added to JABS.%' ----
---- PR#2702 - Make sure File/Activity ID shows in text incase HTML Link doesn't work        ----
-------------------------------------------------------------------------------------------------
    PROCEDURE checkforiafisnotifications IS
        v_records              NUMBER;
        v_lastsid              VARCHAR2(20)                              := '~~~VERY_FIRST_ONE~~~';
        v_lastid               VARCHAR2(100);
        v_lastunit             VARCHAR2(50);
        v_lasttitle            VARCHAR2(300);
        v_unit                 VARCHAR2(20);
        v_specifics            T_OSI_NOTIFICATION_EVENT.specifics%TYPE;
        v_event_sid_not_code   VARCHAR2(200);
    BEGIN
        Core_Logger.log_it(v_pipe, '>>> CheckForIAFISNotifications');
---------------------------------------------------------------
---------------------------------------------------------------
-- Check for Requests sent, but no IAFIS Reponse in 12 hours --
---------------------------------------------------------------
---------------------------------------------------------------
        Core_Logger.log_it
                        (v_pipe,
                         'Generating Events for IAFIS Requests Send, but NO Responses in 12 Hours.');

        FOR iafis IN
            (SELECT a.SID AS thesid, a.title AS thetitle, a.ID AS theid, a.assigned_unit AS theunit
               FROM T_OSI_A_FP_IAFIS_REQUEST s, T_OSI_ACTIVITY a
              WHERE request_sent_to_iafis = 'Y'
                AND (   a.complete_date IS NULL
                     OR a.close_date IS NULL)
                AND s.SID NOT IN(
                        SELECT r.request
                          FROM T_OSI_A_FP_IAFIS_RESPONSE r
                         WHERE UPPER(r.response_text) LIKE '%IAFIS RESPONSE RECEIVED: %'
                            OR r.response_text LIKE '%Updated information has been added to JABS.%')
                AND SYSDATE > s.request_on +(720 / 1440)
                AND a.SID = s.OBJ)
        LOOP
            BEGIN
                Core_Logger.log_it(v_pipe, 'IAFIS record found.');

                IF v_lastsid <> iafis.thesid THEN
                    IF v_lastsid <> '~~~VERY_FIRST_ONE~~~' THEN
                        SELECT SID
                          INTO v_event_sid_not_code
                          FROM T_OSI_NOTIFICATION_EVENT_TYPE
                         WHERE CODE = 'IAFIS.RSP.NOT.RCV';

                        SELECT COUNT(*)
                          INTO v_records
                          FROM T_OSI_NOTIFICATION_EVENT
                         WHERE event_code = v_event_sid_not_code AND PARENT = v_lastsid;

                        IF v_records = 0 THEN
                            Core_Logger.log_it(v_pipe, 'Insert record.');

                            INSERT INTO T_OSI_NOTIFICATION_EVENT
                                        (SID,
                                         event_code,
                                         PARENT,
                                         parent_info,
                                         event_by,
                                         event_on,
                                         impacted_unit,
                                         specifics,
                                         GENERATED)
                                 VALUES (NULL,
                                         v_event_sid_not_code,
                                         v_lastsid,
                                         'Activity:  ' || v_lastid || ' - ' || v_lasttitle,
                                         'I2MS',
                                         SYSDATE,
                                         v_lastunit,
                                         v_specifics,
                                         'N');
                        END IF;
                    END IF;

                    v_lastsid := iafis.thesid;
                    v_lasttitle := iafis.thetitle;
                    v_lastunit := iafis.theunit;
                    v_lastid := iafis.theid;
                    v_specifics := 'IAFIS Response NOT Recieved in 12 Hours or more.';
                    Core_Logger.log_it(v_pipe, 'IAFIS Response NOT Recieved in 12 Hours or more. 1');
                ELSE
                    v_specifics := ' IAFIS Response NOT Recieved in 12 Hours or more.';
                    Core_Logger.log_it(v_pipe,
                                       'IAFIS Response NOT Recieved in 12 Hours or more. 2');
                END IF;
            END;
        END LOOP;

        IF v_specifics IS NOT NULL THEN
            SELECT SID
              INTO v_event_sid_not_code
              FROM T_OSI_NOTIFICATION_EVENT_TYPE
             WHERE CODE = 'IAFIS.RSP.NOT.RCV';

            SELECT COUNT(*)
              INTO v_records
              FROM T_OSI_NOTIFICATION_EVENT
             WHERE event_code = v_event_sid_not_code AND PARENT = v_lastsid;

            IF v_records = 0 THEN
                Core_Logger.log_it(v_pipe, 'Insert record 2');

                INSERT INTO T_OSI_NOTIFICATION_EVENT
                            (SID,
                             event_code,
                             PARENT,
                             parent_info,
                             event_by,
                             event_on,
                             impacted_unit,
                             specifics,
                             GENERATED)
                     VALUES (NULL,
                             v_event_sid_not_code,
                             v_lastsid,
                             'Activity:  ' || v_lastid || ' - ' || v_lasttitle,
                             'I2MS',
                             SYSDATE,
                             v_unit,
                             v_specifics,
                             'N');
            END IF;
        END IF;

---------------------------------------------------------
---------------------------------------------------------
-- Check for Requests not sent, but fingerprints taken --
---------------------------------------------------------
---------------------------------------------------------------
        Core_Logger.log_it
                      (v_pipe,
                       'Generating Events for Fingerprints taken, but Prints not yet sent to IAFIS.');
        v_lastsid := '~~~VERY_FIRST_ONE~~~';
        v_lastid := '';
        v_lastunit := '';
        v_lasttitle := '';
        v_unit := '';
        v_specifics := '';

        FOR iafis IN (SELECT a.SID AS thesid, a.title AS thetitle, a.ID AS theid,
                             a.assigned_unit AS theunit
                        FROM T_OSI_ACTIVITY a, T_OSI_A_FINGERPRINT f, T_OSI_ATTACHMENT AT
                       WHERE a.SID NOT IN(SELECT r.obj
                                            FROM T_OSI_A_FP_IAFIS_REQUEST r
                                           WHERE SYSDATE > a.activity_date +(720 / 1440))
                         AND a.SID = f.SID
                         AND AT.obj = a.SID
                         AND AT.content IS NOT NULL
                         AND AT.SOURCE = 'Fingerprint Module')
        LOOP
            BEGIN
                IF v_lastsid <> iafis.thesid THEN
                    IF v_lastsid <> '~~~VERY_FIRST_ONE~~~' THEN
                        SELECT SID
                          INTO v_event_sid_not_code
                          FROM T_OSI_NOTIFICATION_EVENT_TYPE
                         WHERE CODE = 'IAFIS.NOT.SENT';

                        SELECT COUNT(*)
                          INTO v_records
                          FROM T_OSI_NOTIFICATION_EVENT
                         WHERE event_code = v_event_sid_not_code AND PARENT = v_lastsid;

                        IF v_records = 0 THEN
                            INSERT INTO T_OSI_NOTIFICATION_EVENT
                                        (SID,
                                         event_code,
                                         PARENT,
                                         parent_info,
                                         event_by,
                                         event_on,
                                         impacted_unit,
                                         specifics,
                                         GENERATED)
                                 VALUES ('GETONE',
                                         v_event_sid_not_code,
                                         v_lastsid,
                                         'Activity:  ' || v_lastid || ' - ' || v_lasttitle,
                                         'I2MS',
                                         SYSDATE,
                                         v_lastunit,
                                         v_specifics,
                                         'N');
                        END IF;
                    END IF;

                    v_lastsid := iafis.thesid;
                    v_lasttitle := iafis.thetitle;
                    v_lastunit := iafis.theunit;
                    v_lastid := iafis.theid;
                    v_specifics := 'Fingerprints taken, but Prints not yet sent to IAFIS.';
                ELSE
                    v_specifics := 'Fingerprints taken, but Prints not yet sent to IAFIS.';
                END IF;
            END;
        END LOOP;

        IF v_specifics IS NOT NULL THEN
            SELECT SID
              INTO v_event_sid_not_code
              FROM T_OSI_NOTIFICATION_EVENT_TYPE
             WHERE CODE = 'IAFIS.NOT.SENT';

            SELECT COUNT(*)
              INTO v_records
              FROM T_OSI_NOTIFICATION_EVENT
             WHERE event_code = v_event_sid_not_code AND PARENT = v_lastsid;

            IF v_records = 0 THEN
                INSERT INTO T_OSI_NOTIFICATION_EVENT
                            (SID,
                             event_code,
                             PARENT,
                             parent_info,
                             event_by,
                             event_on,
                             impacted_unit,
                             specifics,
                             GENERATED)
                     VALUES (NULL,
                             v_event_sid_not_code,
                             v_lastsid,
                             'Activity:  ' || v_lastid || ' - ' || v_lasttitle,
                             'I2MS',
                             SYSDATE,
                             v_unit,
                             v_specifics,
                             'N');
            END IF;
        END IF;

---------------------------------------------------------------
---------------------------------------------------------------
-- Check for Requests sent and response from IAFIS received ---
---------------------------------------------------------------
---------------------------------------------------------------
        Core_Logger.log_it(v_pipe, 'Generating Events for Reponse Received from IAFIS');
        v_lastsid := '~~~VERY_FIRST_ONE~~~';
        v_lastid := '';
        v_lastunit := '';
        v_lasttitle := '';
        v_unit := '';
        v_specifics := '';

        FOR iafis IN
            (SELECT a.SID AS thesid, a.title AS thetitle, a.ID AS theid, a.assigned_unit AS theunit
               FROM T_OSI_A_FP_IAFIS_REQUEST s, T_OSI_ACTIVITY a
              WHERE request_sent_to_iafis = 'Y'
                AND (   a.complete_date IS NULL
                     OR a.close_date IS NULL)
                AND s.SID IN(
                        SELECT r.request
                          FROM T_OSI_A_FP_IAFIS_RESPONSE r
                         WHERE UPPER(r.response_text) LIKE '%IAFIS RESPONSE RECEIVED: %'
                            OR r.response_text LIKE '%Updated information has been added to JABS.%')
                AND SYSDATE > s.request_on +(720 / 1440)
                AND a.SID = s.OBJ)
        LOOP
            IF v_lastsid <> iafis.thesid THEN
                IF v_lastsid <> '~~~VERY_FIRST_ONE~~~' THEN
                    SELECT SID
                      INTO v_event_sid_not_code
                      FROM T_OSI_NOTIFICATION_EVENT_TYPE
                     WHERE CODE = 'IAFIS.RSP.RCV';

                    SELECT COUNT(*)
                      INTO v_records
                      FROM T_OSI_NOTIFICATION_EVENT
                     WHERE event_code = v_event_sid_not_code AND PARENT = v_lastsid;

                    IF v_records = 0 THEN
                        Core_Logger.log_it(v_pipe, 'Insert record.');

                        INSERT INTO T_OSI_NOTIFICATION_EVENT
                                    (SID,
                                     event_code,
                                     PARENT,
                                     parent_info,
                                     event_by,
                                     event_on,
                                     impacted_unit,
                                     specifics,
                                     GENERATED)
                             VALUES (NULL,
                                     v_event_sid_not_code,
                                     v_lastsid,
                                     'Activity:  ' || v_lastid || ' - ' || v_lasttitle,
                                     'I2MS',
                                     SYSDATE,
                                     v_lastunit,
                                     v_specifics,
                                     'N');
                    END IF;
                END IF;

                v_lastsid := iafis.thesid;
                v_lasttitle := iafis.thetitle;
                v_lastunit := iafis.theunit;
                v_lastid := iafis.theid;
                v_specifics := 'IAFIS Response Recieved.';
                Core_Logger.log_it(v_pipe, 'IAFIS Response Recieved.');
            ELSE
                v_specifics := ' IAFIS Response Recieved.';
                Core_Logger.log_it(v_pipe, 'IAFIS Response Recieved. 2');
            END IF;
        END LOOP;

        IF v_specifics IS NOT NULL THEN
            SELECT SID
              INTO v_event_sid_not_code
              FROM T_OSI_NOTIFICATION_EVENT_TYPE
             WHERE CODE = 'IAFIS.RSP.RCV';

            SELECT COUNT(*)
              INTO v_records
              FROM T_OSI_NOTIFICATION_EVENT
             WHERE event_code = v_event_sid_not_code AND PARENT = v_lastsid;

            IF v_records = 0 THEN
                Core_Logger.log_it(v_pipe, 'Insert record 3');

                INSERT INTO T_OSI_NOTIFICATION_EVENT
                            (SID,
                             event_code,
                             PARENT,
                             parent_info,
                             event_by,
                             event_on,
                             impacted_unit,
                             specifics,
                             GENERATED)
                     VALUES (NULL,
                             v_event_sid_not_code,
                             v_lastsid,
                             'Activity:  ' || v_lastid || ' - ' || v_lasttitle,
                             'I2MS',
                             SYSDATE,
                             v_unit,
                             v_specifics,
                             'N');
            END IF;
        END IF;

        Core_Logger.log_it(v_pipe, '<<< CheckForIAFISNotifications');
    EXCEPTION
        WHEN OTHERS THEN
            Core_Logger.log_it(v_pipe, 'Error in checkforiafisnotifications: ' || SQLERRM);
    END checkforiafisnotifications;

    PROCEDURE checkforsurveillanceactivities IS
        v_records        NUMBER;
        expires          DATE;
        v_sid_not_code   VARCHAR2(20);
    BEGIN
        Core_Logger.log_it(v_pipe, '>>> CheckForSurveillanceActivities');

--------------------------------------------------------------------
--------------------------------------------------------------------
-- Check for Surveillance Activities within 10 days of expiration --
--------------------------------------------------------------------
--------------------------------------------------------------------
        SELECT SID
          INTO v_sid_not_code
          FROM T_OSI_NOTIFICATION_EVENT_TYPE
         WHERE CODE = 'ACT.SURV.EXPIRED';

        SELECT COUNT(*)
          INTO v_records
          FROM T_OSI_A_SURVEILLANCE s, T_OSI_ACTIVITY a
         WHERE TO_CHAR(s.activation_date + s.approved_duration - 10, 'MM/DD/YYYY') =
                                                                      TO_CHAR(SYSDATE, 'MM/DD/YYYY')
           AND a.complete_date IS NULL
           AND a.close_date IS NULL
           AND s.SID = a.SID;

        Core_Logger.log_it
               (v_pipe,
                'Generating Events for :  Surveillance Activities within 10 days of expiration, '
                || v_records || ' activitie(s) found!');

        FOR s IN (SELECT   narrative, s.SID AS activity, activation_date, approved_duration,
                           assigned_unit, ID, title AS title
                      FROM T_OSI_A_SURVEILLANCE s, T_OSI_ACTIVITY a
                     WHERE TO_CHAR(s.activation_date + s.approved_duration - 10, 'MM/DD/YYYY') =
                                                                      TO_CHAR(SYSDATE, 'MM/DD/YYYY')
                       AND a.complete_date IS NULL
                       AND a.close_date IS NULL
                       AND s.SID = a.SID
                  ORDER BY a.ID)
        LOOP
            BEGIN
                expires := s.activation_date + s.approved_duration;

                --Select Sid into v_sid_not_code from T_OSI_NOTIFICATION_EVENT_TYPE WHERE CODE = 'ACT.SURV.EXPIRED';
                SELECT COUNT(*)
                  INTO v_records
                  FROM T_OSI_NOTIFICATION_EVENT
                 WHERE event_code = v_sid_not_code AND PARENT = s.activity;

                IF v_records = 0 THEN
                    Core_Logger.log_it(v_pipe, 'ACT.SURV.EXPIRED:  ' || s.activity);

                    INSERT INTO T_OSI_NOTIFICATION_EVENT
                                (SID,
                                 event_code,
                                 PARENT,
                                 parent_info,
                                 event_by,
                                 event_on,
                                 impacted_unit,
                                 specifics,
                                 GENERATED)
                         VALUES (NULL,
                                 v_sid_not_code,
                                 s.activity,
                                 'Activity:  ' || s.ID || ' - ' || s.title,
                                 'I2MS',
                                 SYSDATE,
                                 s.assigned_unit,
                                 'Surveillance Activity Approaching Expiration ('
                                 || s.activation_date || '+' || s.approved_duration || ' Days ='
                                 || expires || '):<BR>' || s.narrative,
                                 'N');

                    COMMIT;
                END IF;
            END;
        END LOOP;

---------------------------------------------------------
---------------------------------------------------------
-- Check for Surveillance Activities that have expired --
---------------------------------------------------------
---------------------------------------------------------
        SELECT COUNT(*)
          INTO v_records
          FROM T_OSI_A_SURVEILLANCE s, T_OSI_ACTIVITY a
         WHERE TO_CHAR(s.activation_date + s.approved_duration + 1, 'MM/DD/YYYY') =
                                                                      TO_CHAR(SYSDATE, 'MM/DD/YYYY')
           AND a.complete_date IS NULL
           AND a.close_date IS NULL
           AND s.SID = a.SID;

        Core_Logger.log_it
                          (v_pipe,
                           'Generating Events for :  Surveillance Activities that have expired, '
                           || v_records || ' activitie(s) found!');

        FOR s IN (SELECT   narrative, s.SID AS activity, activation_date, approved_duration,
                           assigned_unit, ID, title AS title
                      FROM T_OSI_A_SURVEILLANCE s, T_OSI_ACTIVITY a
                     WHERE TO_CHAR(s.activation_date + s.approved_duration + 1, 'MM/DD/YYYY') =
                                                                      TO_CHAR(SYSDATE, 'MM/DD/YYYY')
                       AND a.complete_date IS NULL
                       AND a.close_date IS NULL
                       AND s.SID = a.SID
                  ORDER BY a.ID)
        LOOP
            BEGIN
                expires := s.activation_date + s.approved_duration;

                SELECT COUNT(*)
                  INTO v_records
                  FROM T_OSI_NOTIFICATION_EVENT
                 WHERE event_code = v_sid_not_code AND PARENT = s.activity;

                IF v_records = 0 THEN
                    Core_Logger.log_it(v_pipe, 'ACT.SURV.EXPIRED:  ' || s.activity);

                    INSERT INTO T_OSI_NOTIFICATION_EVENT
                                (SID,
                                 event_code,
                                 PARENT,
                                 parent_info,
                                 event_by,
                                 event_on,
                                 impacted_unit,
                                 specifics,
                                 GENERATED)
                         VALUES (NULL,
                                 v_sid_not_code,
                                 s.activity,
                                 'Activity:  ' || s.ID || ' - ' || s.title,
                                 'I2MS',
                                 SYSDATE,
                                 s.assigned_unit,
                                 'Surveillance Activity EXPIRED (' || s.activation_date || '+'
                                 || s.approved_duration || ' Days =' || expires || '):<BR>'
                                 || s.narrative,
                                 'N');

                    COMMIT;
                END IF;
            END;
        END LOOP;

        Core_Logger.log_it(v_pipe, '<<< CheckForSurveillanceActivities');
    END checkforsurveillanceactivities;

    PROCEDURE CFundAdvancesIssuedbyDays(Days IN NUMBER) IS
        v_records         NUMBER;
        v_event_counter   NUMBER;
        v_sid_not_code    VARCHAR2(20);
    BEGIN
        Core_Logger.LOG_IT(v_pipe, '>>> CFundAdvancesIssuedbyDays(' || Days || ')');

        SELECT SID
          INTO v_sid_not_code
          FROM T_OSI_NOTIFICATION_EVENT_TYPE
         WHERE CODE = 'CF.ADV100';

        v_event_counter := 0;

        FOR C IN (SELECT *
                    FROM V_CFUNDS_ADVANCE_V2 C
                   WHERE TO_CHAR(C.ISSUE_ON + Days, 'MM/DD/YYYY') = TO_CHAR(SYSDATE, 'MM/DD/YYYY')
                     AND C.CLOSE_DATE IS NULL)
        LOOP
            BEGIN
                SELECT COUNT(*)
                  INTO v_records
                  FROM T_OSI_NOTIFICATION_EVENT
                 WHERE EVENT_CODE = v_sid_not_code AND PARENT = C.SID;

                IF v_records = 0 THEN
                    Core_Logger.LOG_IT(v_pipe, 'CF.ADV100:  ' || C.VOUCHER_NO);

                    INSERT INTO T_OSI_NOTIFICATION_EVENT
                                (SID,
                                 EVENT_CODE,
                                 PARENT,
                                 PARENT_INFO,
                                 EVENT_BY,
                                 EVENT_ON,
                                 IMPACTED_UNIT,
                                 SPECIFICS,
                                 GENERATED)
                         VALUES (NULL,
                                 v_sid_not_code,
                                 C.SID,
                                 'CFund Advance Voucher #:  ' || C.VOUCHER_NO,
                                 'I2MS',
                                 SYSDATE,
                                 C.UNIT,
                                 C.VOUCHER_NO || ' CFund Advance ' || Days
                                 || ' days from Issue Date (' || C.ISSUE_ON || '):<BR>'
                                 || C.NARRATIVE,
                                 'N');

                    v_event_counter := v_event_counter + 1;
                    COMMIT;
                END IF;
            END;
        END LOOP;

        Core_Logger.LOG_IT(v_pipe,
                           v_event_counter || ' events generated for :  CFund Advances ' || Days
                           || ' days from Issue Date.');
        Core_Logger.LOG_IT(v_pipe, '<<< CFundAdvancesIssuedbyDays(' || Days || ')');
    END CFundAdvancesIssuedbyDays;

    PROCEDURE CheckForCFundAdvances IS
    BEGIN
        Core_Logger.LOG_IT(v_pipe, '>>> CheckForCFundAdvances');
--------------------------------------------------
--------------------------------------------------
-- Check for CFund Advances Issued  80 days ago --
--------------------------------------------------
--------------------------------------------------
        CFundAdvancesIssuedbyDays(80);
--------------------------------------------------
--------------------------------------------------
-- Check for CFund Advances Issued  90 days ago --
--------------------------------------------------
--------------------------------------------------
        CFundAdvancesIssuedbyDays(90);
--------------------------------------------------
--------------------------------------------------
-- Check for CFund Advances Issued 100 days ago --
--------------------------------------------------
--------------------------------------------------
        CFundAdvancesIssuedbyDays(100);
        Core_Logger.LOG_IT(v_pipe, '<<< CheckForCFundAdvances');
    END CheckForCFundAdvances;

    -- GENERATION --
    PROCEDURE generate(pthisevent IN VARCHAR2 := NULL) IS
        /*
        This procedure examines either the specified event or all previously
        un-generated events, and calls an event type specific generation routine.
        It is those specific routines that determine who gets notifications for
        the event. If the specific generation routine returns successfully, this
        routine marks the event as generated and commits all changes. If not,
        this routine rolls back any changes.

        Parameters:
            pThisEvent - Indicates a specific event to generate (optional).
        */
        v_cnt                  NUMBER;
        v_ok                   VARCHAR2(1);
        v_dyn_sql              VARCHAR2(200);
        v_event_code_not_sid   VARCHAR2(200);
        v_specifics            VARCHAR2(4000);
    BEGIN
        Core_Logger.log_it(v_pipe, '>>> Generate');

        IF pthisevent IS NOT NULL THEN
            Core_Logger.log_it(v_pipe, 'Generating specific event: ' || pthisevent);
        ELSE
            Checkcasesapproachingdaysopen;
            Checkforiafisnotifications;
            Checkforsurveillanceactivities;
            CheckForCFundAdvances;

            SELECT COUNT(*)
              INTO v_cnt
              FROM T_OSI_NOTIFICATION_EVENT ne
             WHERE ne.GENERATED = 'N';

            Core_Logger.log_it(v_pipe, 'Number of events found: ' || v_cnt);
        END IF;

        FOR ne IN (SELECT   *
                       FROM T_OSI_NOTIFICATION_EVENT
                      WHERE (   SID = pthisevent
                             OR pthisevent IS NULL) AND GENERATED = 'N'
                   ORDER BY event_on)
        LOOP
            -- Build the dynamic SQL statement to execute Event Code specific processing. --
            SELECT code
              INTO v_event_code_not_sid
              FROM T_OSI_NOTIFICATION_EVENT_TYPE
             WHERE SID = ne.event_code;

---------------------------------------------------------------------------------------------
--- Do this here since :NEW.NOTE_TEXT will not work in the Actual Trigger on T_OSI_NOTE   ---
---  *** These types of notifications can not be Immediate Generation since it will cause ---
---      a Mutating Trigger.                                                              ---
---------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------
            IF v_event_code_not_sid = 'FLE.REVIEW.NOTE' THEN
                BEGIN
                    SELECT SUBSTR(note_text, 1, 4000)
                      INTO v_specifics
                      FROM T_OSI_NOTE
                     WHERE SID = ne.specifics;
                EXCEPTION
                    WHEN OTHERS THEN
                        v_specifics := 'Note Text Not Found - ' || SQLERRM;
                END;

                BEGIN
                    UPDATE T_OSI_NOTIFICATION_EVENT
                       SET specifics = v_specifics
                     WHERE SID = ne.SID;

                    COMMIT;
                EXCEPTION
                    WHEN OTHERS THEN
                        v_specifics := 'Specifics Not Updated - ' || SQLERRM;
                END;
            ELSE
                v_specifics := ne.specifics;
            END IF;

---------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------
            Core_Logger.log_it(v_pipe, 'Processing event ' || ne.event_code);
            Core_Logger.log_it(v_pipe,
                               'Event occurred at '
                               || TO_CHAR(ne.event_on, 'dd-Mon-yyyy hh24:mi:ss'));
            Core_Logger.log_it(v_pipe, 'Parent info: ' || ne.parent_info);
            Core_Logger.log_it(v_pipe, 'Specifics: ' || v_specifics);
            -- save for specific processing --
            v_curr_event_rec := ne;
            v_dyn_sql := v_event_code_not_sid;
            v_dyn_sql := REPLACE(v_dyn_sql, '.', '');
            v_dyn_sql := REPLACE(v_dyn_sql, '_', '');
            v_dyn_sql := 'OSI_NOTIFICATION.Generate_' || v_dyn_sql;
            Core_Logger.log_it(v_pipe, 'Processing routine: ' || v_dyn_sql);
            v_dyn_sql := 'begin ' || v_dyn_sql || '(:ok); end;';
            v_can_generate := TRUE;

            DECLARE
                v_sqlerrm   VARCHAR2(4000);
            BEGIN
                v_ok := 'N';

                EXECUTE IMMEDIATE v_dyn_sql
                            USING OUT v_ok;
            EXCEPTION
                WHEN OTHERS THEN
                    -- If the error string contains PLS-00302, it means the specific --
                    -- generation routine doesn't exist (yet). Try using a generic   --
                    -- routine.                                                      --
                    v_sqlerrm := SQLERRM;

                    IF INSTR(v_sqlerrm, 'PLS-00302') > 0 THEN
                        Core_Logger.log_it(v_pipe,
                                           'Processing routine not found - Using generic routine');
                        generate_generic(v_ok);
                    ELSE
                        Core_Logger.log_it(v_pipe, 'Error: ' || v_sqlerrm);
                        v_ok := 'N';
                    END IF;
            END;

            v_can_generate := FALSE;

            -- if successful generation, mark this event as generated --
            IF v_ok = 'Y' THEN
                UPDATE T_OSI_NOTIFICATION_EVENT
                   SET GENERATED = 'Y'
                 WHERE SID = ne.SID;

                IF pthisevent IS NULL THEN
                    COMMIT;
                END IF;
            ELSE
                IF pthisevent IS NULL THEN
                    ROLLBACK;
                END IF;
            END IF;

            -- spacer --
            Core_Logger.log_it(v_pipe, '.');
        END LOOP;

        <<exit_proc>>
        Core_Logger.log_it(v_pipe, '<<< Generate');
    END generate;

-- Private generation routines specific to an event type.
    PROCEDURE generate_actleaddone(pok OUT VARCHAR2) IS
    BEGIN
        IF NOT v_can_generate THEN
            pok := 'N';
            Core_Logger.log_it(v_pipe, 'Illegal call to generation helper routine.');
            RETURN;
        END IF;

        generate_for_lead_agents(pok);
        RETURN;
    END generate_actleaddone;

    PROCEDURE generate_actnarrchng(pok OUT VARCHAR2) IS
    BEGIN
        IF NOT v_can_generate THEN
            pok := 'N';
            Core_Logger.log_it(v_pipe, 'Illegal call to generation helper routine.');
            RETURN;
        END IF;

        generate_for_lead_agents(pok);
        RETURN;
    END generate_actnarrchng;

    PROCEDURE generate_asgnmade(pok OUT VARCHAR2) IS
    BEGIN
        IF NOT v_can_generate THEN
            pok := 'N';
            Core_Logger.log_it(v_pipe, 'Illegal call to generation helper routine.');
            RETURN;
        END IF;

        generate_for_lead_agents(pok);
        RETURN;
    END generate_asgnmade;

    PROCEDURE generate_fleassocact(pok OUT VARCHAR2) IS
    BEGIN
        IF NOT v_can_generate THEN
            pok := 'N';
            Core_Logger.log_it(v_pipe, 'Illegal call to generation helper routine.');
            RETURN;
        END IF;

        generate_for_lead_agents(pok);
        RETURN;
    END generate_fleassocact;

    PROCEDURE generate_fleassocfle(pok OUT VARCHAR2) IS
    BEGIN
        IF NOT v_can_generate THEN
            pok := 'N';
            Core_Logger.log_it(v_pipe, 'Illegal call to generation helper routine.');
            RETURN;
        END IF;

        generate_for_lead_agents(pok);
        RETURN;
    END generate_fleassocfle;

/*  replaced by generic routine

procedure Generate_INVDEATH( pOK out Varchar2 ) is

--  Generate notifications for any personnel interested in death cases
--  for the impacted unit. The interest determines the delivery method.

    v_ni_rec t_osi_notification_interest%rowtype := null;
    a_problem exception;

begin
    if not v_can_generate then
        pOK := 'N';
        CORE_LOGGER.log_it(v_pipe, 'Illegal call to generation helper routine.');
        return;
    end if;

    for a in (select distinct PERSONNEL
              from t_osi_notification_interest
              where EVENT_TYPE = 'INV.DEATH')
    loop
        -- Determine interest and extract delivery method

        v_ni_rec := Find_Closest_Interest(a.PERSONNEL, 'INV.DEATH',
                                          v_curr_event_rec.IMPACTED_UNIT);
        if v_ni_rec.SID is not null then
            if not Insert_Notification(a.PERSONNEL,
                    v_ni_rec.DELIVERY_METHOD,
                    v_ni_rec.DELIVERY_ADDRESS) then
                raise a_problem;
            end if;
        end if;
    end loop;

    pOK := 'Y';
    return;

exception
    when a_problem then
        pOK := 'N';
        return;

    when OTHERS then
        CORE_LOGGER.log_it(v_pipe, 'Error: ' || sqlerrm);
        pOK := 'N';
        return;

end Generate_INVDEATH;
*/
    PROCEDURE generate_invheadsup(pok OUT VARCHAR2) IS
/*
    Generate notification for approval authority of the unit assuming
    the they specified an interest in this type of notification.
    The interest determines the delivery method.
*/
        v_event_type varchar2(20) := null;
        v_ni_rec    T_OSI_NOTIFICATION_INTEREST%ROWTYPE   := NULL;
        v_fu_rec    T_OSI_F_UNIT%ROWTYPE;
        a_problem   EXCEPTION;
    BEGIN
        Core_Logger.log_it(v_pipe, 'Starting GENERATE_INVHEADSUP');

        IF NOT v_can_generate THEN
            pok := 'N';
            Core_Logger.log_it(v_pipe, 'Illegal call to generation helper routine.');
            RETURN;
        END IF;

        -- Get the file's current unit info
        SELECT *
          INTO v_fu_rec
          FROM T_OSI_F_UNIT
         WHERE file_sid = v_curr_event_rec.PARENT AND end_date IS NULL;

        --Get INV.HEADSUP event type sid
        select SID
          into v_event_type
          from t_osi_notification_event_type
         where code = 'INV.HEADSUP';

        FOR a IN
            (SELECT   *
                 FROM T_CORE_PERSONNEL
                WHERE    /*removed the priv check per wchg0000357
                         Osi_Auth.CHECK_FOR_PRIV('APPROVE',
                                                 Core_Obj.GET_OBJTYPE(v_fu_rec.FILE_SID),
                                                 SID,
                                                 v_FU_REC.UNIT_SID) = 'Y'
                                          --('INV.APP', SID, v_curr_event_rec.impacted_unit) = 'Y'*/
                      --and OSI_AUTH.CHECK_FOR_PRIV('APPROVE', SID, v_fu_rec.unit_SID) = 'N'
                      -- would filter out "sibling" notifications
                      --AND
                      SID IN(SELECT personnel
                               FROM T_OSI_NOTIFICATION_INTEREST
                              WHERE event_type = v_event_type)
             ORDER BY LAST_NAME, FIRST_NAME)
        LOOP
            Core_Logger.log_it(v_pipe,
                               'Found Approval Authority: ' || a.Last_Name || ' ' || a.First_Name);
            -- Determine interest and extract delivery method
            v_ni_rec := find_closest_interest(a.SID, v_event_type, v_curr_event_rec.impacted_unit);

            IF v_ni_rec.SID IS NOT NULL THEN
                IF NOT insert_notification(a.SID,
                                           v_ni_rec.delivery_method,
                                           v_ni_rec.delivery_address) THEN
                    RAISE a_problem;
                END IF;
            ELSE
                Core_Logger.log_it(v_pipe, 'No interest indicated.');
            END IF;
--        exit;   -- only need 1
        END LOOP;

        pok := 'Y';
        RETURN;
    EXCEPTION
        WHEN a_problem THEN
            pok := 'N';
            RETURN;
        WHEN OTHERS THEN
            Core_Logger.log_it(v_pipe, 'Error: ' || SQLERRM);
            pok := 'N';
            RETURN;
    END generate_invheadsup;

    PROCEDURE generate_notenonlead(pok OUT VARCHAR2) IS
    BEGIN
        IF NOT v_can_generate THEN
            pok := 'N';
            Core_Logger.log_it(v_pipe, 'Illegal call to generation helper routine.');
            RETURN;
        END IF;

        generate_for_lead_agents(pok);
        RETURN;
    END generate_notenonlead;

    PROCEDURE generate_perchanged(pok OUT VARCHAR2) IS
/*
    Generate notification for lead agent of file/activity
    where the most recent personnel who modified the PERSON is not the lead agent.
    The interest determines the delivery method.
*/
        v_begin_run_code   VARCHAR2(50)                          := 'OSI.NOTIF_LR1';
        --CODE in T_I2MS_CONFIG for begin date/time range to run Detect_PERCHANGED
        v_end_run_code     VARCHAR2(50)                          := 'OSI.NOTIF_LR2';
        --CODE in T_I2MS_CONFIG for end date/time range to run Detect_PERCHANGED
        v_begin_run        DATE;                                            --begin date/time range
        v_end_run          DATE;                                         --end date/time code range
        v_lead_agent       VARCHAR2(200);                                      --Name of Lead Agent
        v_lead_agent_sid   VARCHAR2(200);                                       --SID of Lead Agent
        v_ni_rec           T_OSI_NOTIFICATION_INTEREST%ROWTYPE   := NULL;
        v_cnt              NUMBER                                := 0;
        a_problem          EXCEPTION;
    BEGIN
        IF NOT v_can_generate THEN
            pok := 'N';
            Core_Logger.log_it(v_pipe, 'Illegal call to generation helper routine.');
            RETURN;
        END IF;

        --GET DATE RANGE
        v_begin_run := TO_DATE(Core_Util.GET_CONFIG(v_begin_run_code), 'DD-MON-YYYY hh24:mi:ss');
        --GET begin date/time range fron I2MS Config
        v_end_run := TO_DATE(Core_Util.get_config(v_end_run_code), 'DD-MON-YYYY hh24:mi:ss');
         --GET end date/time range fron I2MS Config
        -- CORE_LOGGER.log_it(v_pipe,
                            --'>>> Generate_PERCHANGED: started ' || to_char(v_begin_run,'DD-MON-YYYY hh24:mi:ss') || '-' || to_char(v_end_run,'DD-MON-YYYY hh24:mi:ss'));
         --Start Procedure
        Core_Logger.log_it(v_pipe,
                           '>>> Generate_PERCHANGED: started '
                           || TO_CHAR(v_begin_run, 'DD-MON-YYYY hh24:mi:ss') || '-'
                           || TO_CHAR(v_end_run, 'DD-MON-YYYY hh24:mi:ss'));

        --Start Procedure

        --GET ALL PERSON_VERSIONs BASED ON current PERSON (PARENT)
        FOR m IN (SELECT DISTINCT SID
                             FROM T_OSI_PARTICIPANT_VERSION
                            WHERE participant = v_curr_event_rec.PARENT)
        LOOP
            --LOOP THROUGH ALL OPEN ACTIVITIES AND FILES HAVING ANY ROLE WITH SPECIFIED PERSON_VERSION
            FOR n IN
                (SELECT DISTINCT
                                 --PI.INVOLVEMENT_ROLE,           --INVOLVEMENT_ROLE NOT NEEDED AT THIS TIME
                                 pi.activity AS OBJ, pi.title
                            FROM v_osi_partic_act_involvement pi, T_OSI_ACTIVITY act_file
                           WHERE pi.participant_version = m.SID
                             AND                            --GET ALL ROLES WHERE PERSON IS INVOLVED
                                 pi.activity = act_file.SID
                             AND                       --GET ALL ACTIVITIES WHERE PERSON IS INVOLVED
                                 act_file.close_date IS NULL          --ONLY LOOK AT OPEN ACTIVITIES
                 UNION ALL
                 SELECT DISTINCT
                                 --PI.INVOLVEMENT_ROLE,           --INVOLVEMENT_ROLE NOT NEEDED AT THIS TIME
                                 pi.File_sid AS OBJ, pi.title
                            FROM v_osi_partic_file_involvement pi, T_OSI_FILE act_file
                           WHERE pi.participant_version = m.SID
                             AND                            --GET ALL ROLES WHERE PERSON IS INVOLVED
                                 pi.file_sid = act_file.SID
                             AND                            --GET ALL FILES WHERE PERSON IS INVOLVED
                                 UPPER(Osi_Status.GET_STATUS_DESC(pi.FIle_Sid)) NOT IN
                                     ('ARCHIVED', 'RECEIVED AT ARCHIVE', 'SENT TO ARCHIVE',
                                      'CLOSED')
                                               --ONLY GET FILES NOT CLOSED OR ARCHIVED
                )
            LOOP
                Core_Logger.log_it(v_pipe,
                                   'SID=' || m.SID || '///PARENT=' || n.OBJ || ':::' || n.title);
                Core_Logger.log_it('I2MS.DEBUG',
                                   'SID=' || m.SID || '///PARENT=' || n.OBJ || ':::' || n.title);

                FOR a IN (SELECT changes.*
                            FROM 
                                 --LOOP THROUGH ALL CHANGES TO PERSON_VERSION WITH MODIFY_ON AFTER LAST RUN DATE
                                 (SELECT SID person_version, modify_by, modify_on
                                    FROM T_OSI_PARTICIPANT_VERSION
                                   WHERE SID IN(SELECT SID
                                                  FROM T_OSI_PARTICIPANT_VERSION
                                                 WHERE participant = v_curr_event_rec.PARENT)
                                  UNION
                                  SELECT partic_a partic_version, modify_by, modify_on
                                    FROM T_OSI_PARTIC_RELATION
                                   WHERE partic_a IN(SELECT SID
                                                       FROM T_OSI_PARTICIPANT_VERSION
                                                      WHERE participant = v_curr_event_rec.PARENT)
                                  UNION
                                  SELECT partic_b partic_version, modify_by, modify_on
                                    FROM T_OSI_PARTIC_RELATION
                                   WHERE partic_b IN(SELECT SID
                                                       FROM T_OSI_PARTICIPANT_VERSION
                                                      WHERE participant = v_curr_event_rec.PARENT)
                                  UNION
                                  SELECT participant_version, modify_by, modify_on
                                    FROM T_OSI_PARTIC_NUMBER
                                   WHERE participant_version IN(
                                                         SELECT SID
                                                           FROM T_OSI_PARTICIPANT_VERSION
                                                          WHERE participant =
                                                                             v_curr_event_rec.PARENT)
                                  UNION
                                  SELECT participant_version, modify_by, modify_on
                                    FROM T_OSI_PARTIC_NUMBER
                                   WHERE participant_version IN(
                                                         SELECT SID
                                                           FROM T_OSI_PARTICIPANT_VERSION
                                                          WHERE participant =
                                                                             v_curr_event_rec.PARENT)
                                  UNION
                                  SELECT participant_version, modify_by, modify_on
                                    FROM T_OSI_PARTIC_MARK
                                   WHERE participant_version IN(
                                                         SELECT SID
                                                           FROM T_OSI_PARTICIPANT_VERSION
                                                          WHERE participant =
                                                                             v_curr_event_rec.PARENT)
                                  UNION
                                  SELECT participant_version, modify_by, modify_on
                                    FROM T_OSI_PARTIC_NAME
                                   WHERE participant_version IN(
                                                         SELECT SID
                                                           FROM T_OSI_PARTICIPANT_VERSION
                                                          WHERE participant =
                                                                             v_curr_event_rec.PARENT)
                                  UNION
                                  SELECT participant_version participant_version, modify_by,
                                         modify_on
                                    FROM T_OSI_PARTIC_CONTACT
                                   WHERE participant_version IN(
                                                         SELECT SID
                                                           FROM T_OSI_PARTICIPANT_VERSION
                                                          WHERE participant =
                                                                             v_curr_event_rec.PARENT)
                                  UNION
                                  SELECT participant_version person_version, modify_by, modify_on
                                    FROM T_OSI_PARTIC_ADDRESS
                                   WHERE participant_version IN(
                                                         SELECT SID
                                                           FROM T_OSI_PARTICIPANT_VERSION
                                                          WHERE participant =
                                                                             v_curr_event_rec.PARENT)) changes
                           WHERE changes.modify_on > v_begin_run AND changes.modify_on <= v_end_run)
                LOOP
                    --GET SID OF LEAD AGENT
                    v_lead_agent_sid := Osi_Object.GET_LEAD_AGENT(n.OBJ);

                    --GET FULL NAME OF ALEAD AGENT
                    SELECT LAST_NAME || ', ' || FIRST_NAME || ' ' || MIDDLE_NAME
                      INTO v_lead_agent
                      FROM T_CORE_PERSONNEL
                     WHERE SID = v_lead_agent_sid;

                    --IF AT LEAST ONE PERSON_VERSION RELATED TO FILE/ACTIVITY WAS MODIFIED BY PERSONNEL OTHER THAN LEAD AGENT
                    Core_Logger.log_it(v_pipe, 'LEAD AGENT:' || v_lead_agent);
                    Core_Logger.log_it(v_pipe, 'MODIFY BY:' || a.modify_by);

                    IF trim(v_lead_agent) <> trim(a.modify_by) THEN
                        --COUNT NOTIFICATIONS GENERATED
                        Core_Logger.log_it(v_pipe, 'GOT A HIT!!!!!!!');
                        v_cnt := v_cnt + 1;
                        Core_Logger.log_it(v_pipe,
                                           '****' || v_cnt || '.SID=' || m.SID || '/PARENT='
                                           || n.OBJ || '****Lead Agent[' || v_lead_agent
                                           || ']:::Modify_By[' || a.modify_by || ']');
                        Core_Logger.log_it('I2MS.DEBUG',
                                           '****' || v_cnt || '.SID=' || m.SID || '/PARENT='
                                           || n.OBJ || '****Lead Agent[' || v_lead_agent
                                           || ']:::Modify_By[' || a.modify_by || ']');
                        -- Determine interest and extract delivery method
                        v_ni_rec := find_closest_interest(v_lead_agent_sid, 'PER.CHANGED');
                        Core_Logger.log_it(v_pipe,
                                           'ABOUT TO DO INSERT_NOTIFICATION(' || v_lead_agent_sid
                                           || ',' || v_ni_rec.delivery_method || ','
                                           || v_ni_rec.delivery_address || ')');

                        IF v_ni_rec.SID IS NOT NULL THEN
                            IF NOT insert_notification(v_lead_agent_sid,
                                                       v_ni_rec.delivery_method,
                                                       v_ni_rec.delivery_address) THEN
                                RAISE a_problem;
                            END IF;
                        ELSE
                            Core_Logger.log_it(v_pipe, 'No interest indicated.');
                        END IF;

                        EXIT;                                                         -- only need 1
                    END IF;
                END LOOP;
            END LOOP;
        END LOOP;

        Core_Logger.log_it(v_pipe, '<<< Generate_PERCHANGED: stopped');             --Stop Procedure
        Core_Logger.log_it('I2MS.DEBUG', '<<< Generate_PERCHANGED: stopped');       --Stop Procedure
        pok := 'Y';
        RETURN;
    EXCEPTION
        WHEN a_problem THEN
            pok := 'N';
            RETURN;
        WHEN OTHERS THEN
            Core_Logger.log_it(v_pipe, '!!!  Generate_PERCHANGED : Error: ' || SQLERRM);
            Core_Logger.log_it('I2MS.DEBUG', '!!! Generate_PERCHANGED : Error: ' || SQLERRM);
            pok := 'N';
            RETURN;
    END generate_perchanged;

    PROCEDURE Generate_CFEXPREJECT(pOK OUT VARCHAR2) IS
/*
    Generate notifications for any personnel interested in the current event
    for the impacted unit. The interest determines the delivery method.
*/
        v_ni_rec        T_OSI_NOTIFICATION_INTEREST%ROWTYPE   := NULL;
        v_deliverymtd   VARCHAR2(20);
        a_problem       EXCEPTION;
    BEGIN
        FOR a IN (SELECT DISTINCT PERSONNEL
                             FROM T_OSI_NOTIFICATION_INTEREST
                            WHERE EVENT_TYPE = v_curr_event_rec.EVENT_CODE)
        LOOP
            --- Determine interest and extract delivery method ---
            v_ni_rec :=
                Find_Closest_Interest(a.PERSONNEL,
                                      v_curr_event_rec.EVENT_CODE,
                                      v_curr_event_rec.IMPACTED_UNIT);

            IF v_ni_rec.SID IS NOT NULL THEN
                IF NOT Insert_Notification(a.PERSONNEL,
                                           v_ni_rec.DELIVERY_METHOD,
                                           v_ni_rec.DELIVERY_ADDRESS) THEN
                    RAISE a_problem;
                END IF;
            END IF;
        END LOOP;

        FOR A IN (SELECT *
                    FROM T_CFUNDS_EXPENSE_V3
                   WHERE SID = v_curr_event_rec.PARENT)
        LOOP
            SELECT SID
              INTO v_deliverymtd
              FROM T_OSI_NOTIFICATION_METHOD
             WHERE code = 'CF.EXP.REJECT.EMAIL';

            IF NOT Insert_Notification(a.claimant, v_deliverymtd, '') THEN
                RAISE a_problem;
            END IF;
        END LOOP;

        pOK := 'Y';
        RETURN;
    EXCEPTION
        WHEN a_problem THEN
            pOK := 'N';
            RETURN;
        WHEN OTHERS THEN
            Core_Logger.LOG_IT(v_pipe, 'Error: ' || SQLERRM);
            pOK := 'N';
            RETURN;
    END Generate_CFEXPREJECT;

    PROCEDURE Generate_ACCESSFAILED(pOK OUT VARCHAR2) IS
        v_ni_rec                T_OSI_NOTIFICATION_INTEREST%ROWTYPE   := NULL;
        v_fu_rec                T_OSI_F_UNIT%ROWTYPE;
        a_problem               EXCEPTION;
        pSID                    VARCHAR2(20);
        pObjTypeCode            VARCHAR2(30);
        pObjTypeDesc            VARCHAR2(100);
        pClass                  VARCHAR2(50);
        pForm                   VARCHAR2(50);
        pLocatorClass           VARCHAR2(50);
        pLocatorForm            VARCHAR2(50);
        pUnitSID                VARCHAR2(20);
        pUsername               VARCHAR2(1000);
        pCurrentUnit            VARCHAR2(20);
        pUserUnitName           VARCHAR2(50);
        pPersonnelAlreadySent   VARCHAR2(4000)                        := ',';
        pDeliveryMethodSID      VARCHAR2(20);
    BEGIN
        Core_Logger.LOG_IT(v_pipe, '>>>Generate_ACCESSFAILED');

        IF NOT v_can_generate THEN
            pOK := 'N';
            Core_Logger.LOG_IT(v_pipe, 'Illegal call to generation helper routine.');
            Core_Logger.LOG_IT(v_pipe, '<<<Generate_ACCESSFAILED');
            RETURN;
        END IF;

        pSID := v_curr_event_rec.PARENT;

        --- Get Sid of Delivery Method ---
        BEGIN
            SELECT M.SID
              INTO pDeliveryMethodSID
              FROM T_OSI_NOTIFICATION_METHOD M, T_OSI_NOTIFICATION_EVENT_TYPE T
             WHERE M.EVENT_TYPE = T.SID AND T.CODE = 'ACCESS.FAILED';
        EXCEPTION
            WHEN OTHERS THEN
                NULL;
        END;

        --- Get the Objects Owning Unit SID ---

        --- Check to See if it is a File ---
        BEGIN
            SELECT UNIT_SID
              INTO pUnitSID
              FROM T_OSI_F_UNIT
             WHERE FILE_SID = v_curr_event_rec.PARENT AND END_DATE IS NULL;
        EXCEPTION
            WHEN NO_DATA_FOUND THEN
                pUnitSID := NULL;
        END;

        --- Check to See if it is an Activity ---
        IF pUnitSID IS NULL THEN
            BEGIN
                SELECT ASSIGNED_UNIT
                  INTO pUnitSID
                  FROM T_OSI_ACTIVITY
                 WHERE SID = v_curr_event_rec.PARENT;
            EXCEPTION
                WHEN NO_DATA_FOUND THEN
                    pUnitSID := NULL;
            END;
        END IF;

        Core_Logger.LOG_IT(v_pipe, 'pUnitSID=' || pUnitSID);

        --- Get Personnel Name of Person that Check Access Failed for ---
        BEGIN
            SELECT P.PERSONNEL_NAME, P.UNIT_NAME
              INTO pUserName, pUserUnitName
              FROM V_OSI_PERSONNEL P
             WHERE P.SID = v_curr_event_rec.specifics;
        EXCEPTION
            WHEN NO_DATA_FOUND THEN
                pUserName := '<<NAME NOT FOUND>>';
        END;

        Core_Logger.LOG_IT(v_pipe, 'pUserName=' || pUserName);
        --- Try to deliver to the Lead Agent, if they are still in the owning unit ---
        Core_Logger.LOG_IT(v_pipe, 'Searching for Lead Agent, still in owning unit..............');

        FOR A IN (SELECT *
                    FROM V_OSI_ASSIGNMENT
                   WHERE ASSIGN_ROLE = 'Lead Agent' AND PARENT = v_curr_event_rec.PARENT)
        LOOP
            Core_Logger.LOG_IT(v_pipe, 'A.PERSONNEL_NAME=' || A.PERSONNEL_NAME);

            BEGIN
                SELECT UNIT
                  INTO pCurrentUnit
                  FROM T_OSI_PERSONNEL_UNIT_ASSIGN
                 WHERE PERSONNEL = A.PERSONNEL AND END_DATE IS NULL;
            EXCEPTION
                WHEN NO_DATA_FOUND THEN
                    pCurrentUnit := '~~NOT FOUND~~';
            END;

            Core_Logger.LOG_IT(v_pipe, 'pCurrentUnit=' || pCurrentUnit || ', pUnitSID=' || pUnitSID);

            IF pCurrentUnit = pUnitSID THEN
                IF INSTR(pPersonnelAlreadySent, a.personnel || ',') = 0 THEN
                    Core_Logger.LOG_IT(v_pipe, 'Lead Agent Found.');

                    IF NOT Insert_Notification(a.personnel, pDeliveryMethodSID, NULL) THEN
                        RAISE a_problem;
                    END IF;

                    pPersonnelAlreadySent := pPersonnelAlreadySent || a.personnel || ',';
                END IF;
            END IF;
        END LOOP;

        --- Try to deliver to the DETCO of the owning unit ---
        Core_Logger.LOG_IT(v_pipe, 'Searching for DETCO of the owning unit..............');

        FOR A IN (SELECT *
                    FROM V_OSI_UNIT_ASSIGNMENT
                   WHERE ASSIGN_ROLE = 'COMMANDER' AND END_DATE IS NULL AND UNIT = pUnitSID)
        LOOP
            IF INSTR(pPersonnelAlreadySent, a.personnel || ',') = 0 THEN
                Core_Logger.LOG_IT(v_pipe,
                                   'A.PERSONNEL_NAME=' || A.PERSONNEL_NAME || ', DETCO Found.');

                IF NOT Insert_Notification(a.personnel, pDeliveryMethodSID, NULL) THEN
                    RAISE a_problem;
                END IF;

                pPersonnelAlreadySent := pPersonnelAlreadySent || a.personnel || ',';
            END IF;
        END LOOP;

        --- Try to deliver to any other Agents that are interested ---
        Core_Logger.LOG_IT(v_pipe, 'Searching for any other Interested parties..............');

        FOR a IN (SELECT DISTINCT PERSONNEL
                             FROM T_OSI_NOTIFICATION_INTEREST
                            WHERE EVENT_TYPE = v_curr_event_rec.EVENT_CODE)
        LOOP
            --- Determine interest and extract delivery method ---
            v_ni_rec := Find_Closest_Interest(a.PERSONNEL, v_curr_event_rec.EVENT_CODE, pUnitSID);

            IF v_ni_rec.SID IS NOT NULL THEN
                IF INSTR(pPersonnelAlreadySent, a.personnel || ',') = 0 THEN
                    Core_Logger.LOG_IT(v_pipe, 'Interest Found....');

                    IF NOT Insert_Notification(a.PERSONNEL,
                                               v_ni_rec.DELIVERY_METHOD,
                                               v_ni_rec.DELIVERY_ADDRESS) THEN
                        RAISE a_problem;
                    END IF;

                    pPersonnelAlreadySent := pPersonnelAlreadySent || a.personnel || ',';
                END IF;
            END IF;
        END LOOP;

        UPDATE T_OSI_NOTIFICATION_EVENT
           SET IMPACTED_UNIT = pUnitSID,
               SPECIFICS =
                   pUsername || ' from ' || pUserUnitName
                   || ' Failed to gain access to this object.'
         WHERE SID = v_curr_event_rec.SID;

        COMMIT;
        pOK := 'Y';
        Core_Logger.LOG_IT(v_pipe, '<<<Generate_ACCESSFAILED');
        RETURN;
    EXCEPTION
        WHEN a_problem THEN
            pOK := 'N';
            Core_Logger.LOG_IT(v_pipe, '<<<Generate_ACCESSFAILED');
            RETURN;
        WHEN OTHERS THEN
            Core_Logger.LOG_IT(v_pipe, 'Error: ' || SQLERRM);
            pOK := 'N';
            Core_Logger.LOG_IT(v_pipe, '<<<Generate_ACCESSFAILED');
            RETURN;
    END Generate_ACCESSFAILED;

-- DELIVERY
    PROCEDURE deliver(pthisnotification IN VARCHAR2 := NULL) IS
/*
    This procedure examines either the specified notification or all
    previously un-delivered notifications, groups them by delivery
    method, and calls a delivery method specific routine for each group.

    Each delivery routine has complete control over the delivery process.
    Options such as grouping of notification within an address, the content
    of the delivery, etc.

    Parameters:
        pThisNotification - A specific notification to deliver (optional).
*/
        v_cnt                   NUMBER;
        v_ok                    VARCHAR2(1);
        v_dyn_sql               VARCHAR2(200);
        v_method_code_not_sid   VARCHAR2(200);
    BEGIN
        Core_Logger.log_it(v_pipe, '>>> Deliver');

        -- Mark all Desktop-only notifications as delivered
        UPDATE T_OSI_NOTIFICATION
           SET delivery_date = SYSDATE
         WHERE delivery_date IS NULL AND delivery_method IS NULL;

        v_cnt := SQL%rowcount;
        Core_Logger.log_it(v_pipe, 'Marked ' || v_cnt || ' desktop notifications as delivered.');

        IF pthisnotification IS NOT NULL THEN
            Core_Logger.log_it(v_pipe, 'Delivering specified notification: ' || pthisnotification);
        ELSE
            SELECT COUNT(*)
              INTO v_cnt
              FROM T_OSI_NOTIFICATION n
             WHERE n.delivery_date IS NULL;

            Core_Logger.log_it(v_pipe, 'Number of notifications found: ' || v_cnt);
        END IF;

        FOR n IN (SELECT DISTINCT n.delivery_method
                             FROM T_OSI_NOTIFICATION n
                            WHERE n.delivery_date IS NULL
                              AND (   pthisnotification IS NULL
                                   OR pthisnotification = n.SID))
        LOOP
            Core_Logger.log_it(v_pipe, 'Delivering ' || n.delivery_method);

            -- Build the dynamic SQL statement to execute Delivery Method
            -- specific processing.
            SELECT code
              INTO v_method_code_not_sid
              FROM T_OSI_NOTIFICATION_METHOD
             WHERE SID = n.delivery_method;

            v_dyn_sql := v_method_code_not_sid;
            v_dyn_sql := REPLACE(v_dyn_sql, '.', '');
            v_dyn_sql := REPLACE(v_dyn_sql, '_', '');
            v_dyn_sql := 'OSI_NOTIFICATION.Deliver_' || v_dyn_sql;
            Core_Logger.log_it(v_pipe, 'Processing routine: ' || v_dyn_sql);
            v_dyn_sql := 'begin ' || v_dyn_sql || '(:ok,:t1); end;';
            v_can_deliver := TRUE;

            DECLARE
                v_sqlerrm   VARCHAR2(4000);
            BEGIN
                v_ok := 'N';

                EXECUTE IMMEDIATE v_dyn_sql
                            USING OUT v_ok, IN pthisnotification;
            EXCEPTION
                WHEN OTHERS THEN
                    -- If the error string contains PLS-00302, it means the specific
                    -- generation routine doesn't exist (yet). Try using a generic
                    -- routine.
                    v_sqlerrm := SQLERRM;

                    IF INSTR(v_sqlerrm, 'PLS-00302') > 0 THEN
                        Core_Logger.log_it(v_pipe,
                                           'Processing routine not found - Using generic routine');
                        deliver_generic(n.delivery_method, v_ok, pthisnotification);
                    ELSE
                        Core_Logger.log_it(v_pipe, 'Error #1: ' || v_sqlerrm);
                        v_ok := 'N';
                    END IF;
            END;

            v_can_deliver := FALSE;

            IF v_ok = 'Y' THEN
                IF pthisnotification IS NULL THEN
                    COMMIT;
                END IF;
            ELSE
                IF pthisnotification IS NULL THEN
                    ROLLBACK;
                END IF;
            END IF;
        END LOOP;

        <<exit_proc>>
        Core_Logger.log_it(v_pipe, '<<< Deliver');
    EXCEPTION
        WHEN OTHERS THEN
            Core_Logger.log_it(v_pipe, 'Error: ' || SQLERRM);
            Core_Logger.log_it(v_pipe, '<<< Deliver');

            IF pthisnotification IS NULL THEN
                ROLLBACK;
            END IF;

            RETURN;
    END deliver;

-- Private delivery routines specific to a delivery mechanism
    PROCEDURE deliver_actleaddoneemail(pok OUT VARCHAR2, pthis1 IN VARCHAR2 := NULL) IS
        v_message   VARCHAR2(32000) := NULL;
        v_nl        VARCHAR2(10)    := CHR(10);                                        -- Line Feed
    BEGIN
/*
        pok := 'N';

        if not v_can_deliver then
            CORE_LOGGER.log_it(v_pipe, 'Illegal call to delivery helper routine.');
            return;
        end if;

        if not email_update_blank_addresses('ACT.LEADDONE.EMAIL') then
            return;
        end if;

        -- Loop through all the notifications, grouped by effective address
        for a in (select distinct n.delivery_address
                             from t_osi_notification n
                            where n.delivery_method = 'ACT.LEADDONE.EMAIL'
                              and n.delivery_date is null
                              and n.delivery_address is not null
                              and (   n.SID = pthis1
                                   or pthis1 is null))
        loop
            v_message := null;
            CORE_LOGGER.log_it(v_pipe, 'Starting new message to: ' || a.delivery_address);

            for n in (select   n.*
                          from v_notification n
                         where n.delivery_method = 'ACT.LEADDONE.EMAIL'
                           and n.delivery_date is null
                           and n.delivery_address = a.delivery_address
                           and (   n.SID = pthis1
                                or pthis1 is null)
                      order by n.parent_info)
            loop
                         -- v_message := v_message || 'Got Notification (Details follow)' || '<BR>';
                         -- v_message := v_message || 'Address: ' || n.EFF_ADDR || '<BR>';
                         -- v_message := v_message || 'Event: ' || n.DESCRIPTION || '<BR>';
                --
                --v_message := v_message || '<A HREF="' || core_util.get_config('CORE.BASE_URL') || n.PARENT || '"><IMG BORDER=0 ALT="Open in I2MS" SRC="http://hqsbui2ms/images/I2MS/OBJ_SEARCH/i2ms.gif"></A> ';
                v_message :=
                    v_message || '<A HREF="' || core_util.get_config('CORE.BASE_URL') || n.parent || '"'
                    || ' Title="Open in I2MS" ' || '>' || n.parent_info || '</A> <BR>';
                --v_message := v_message || n.PARENT_INFO || '<BR>';
                v_message :=
                    v_message || 'Date: ' || to_char(n.event_on, 'dd-Mon-yyyy hh24:mi:ss')
                    || '<BR>';
                v_message := v_message || 'Unit: ' || n.unit || '<BR>';
                v_message := v_message || 'Agent: ' || n.event_by || '<BR>';
                v_message := v_message || 'Specifics: ' || n.specifics || '<BR>';
                v_message := v_message || 'Narrative (first 2k): ' || '<BR>';

                for t in (select *
                            from t_activity
                           where SID = n.parent)
                loop
                    if t.narrative is not null then
                        v_message := v_message || '<BR>' || clob_text(t.narrative, 2000) || '<BR>';
                    end if;
                end loop;

                v_message := v_message || '<HR>';
                CORE_LOGGER.log_it(v_pipe, 'Added to message: ' || n.parent_info);

                update t_notification
                   set delivery_date = sysdate
                 where SID = n.SID;

                if length(v_message) > 28000 then
                    v_message :=
                        v_message || '<HR>'
                        || '<B>YOU HAVE ADDITIONAL NOTIFICATIONS IN I2MS THAT COULD NOT BE SHOWN IN THIS EMAIL DUE TO SIZE LIMITATIONS.</B><BR>';
                    CORE_LOGGER.log_it(v_pipe,
                                       'Added message length notice: ' || length(v_message));
                    exit;
                end if;
            end loop;

            if email_send(a.delivery_address, 'Activity Completions', v_message) then
                null;
            end if;
        end loop;

        pok := 'Y';
        return;
    exception
        when others then
            CORE_LOGGER.log_it(v_pipe, 'Error: ' || sqlerrm);
            pok := 'N';
*/
        NULL;
    END deliver_actleaddoneemail;

    PROCEDURE deliver_actleaddonetextmsg(pok OUT VARCHAR2, pthis1 IN VARCHAR2 := NULL) IS
        v_message   VARCHAR2(32000) := NULL;
        v_nl        VARCHAR2(10)    := CHR(13) || CHR(10);             -- Carriage Return/Line Feed
    BEGIN
/*
        pok := 'N';

        if not v_can_deliver then
            CORE_LOGGER.log_it(v_pipe, 'Illegal call to delivery helper routine.');
            return;
        end if;

    if not EMAIL_Update_Blank_Addresses('ACT.LEADDONE.TEXTMSG') then
        return;
    end if;
*/  -- Loop through all the notifications. Since each message will contain
    -- only 1 notification, there is no need to group them like the E-mail
    -- delivery method.
/*        for n in (select   n.*
                      from v_notification n
                     where n.delivery_method = 'ACT.LEADDONE.TEXTMSG'
                       and n.delivery_date is null
                       and n.delivery_address is not null
                       and (   n.SID = pthis1
                            or pthis1 is null)
                  order by n.event_on)
        loop
            v_message := n.parent_info;

            if textmsg_send(n.delivery_address, 'Lead Done', v_message) then
                update t_notification
                   set delivery_date = sysdate
                 where SID = n.SID;
            end if;
        end loop;

        pok := 'Y';
        return;
    exception
        when others then
            CORE_LOGGER.log_it(v_pipe, 'Error: ' || sqlerrm);
            pok := 'N';
*/
        NULL;
    END deliver_actleaddonetextmsg;

    PROCEDURE deliver_invdeathemail(pok OUT VARCHAR2, pthis1 IN VARCHAR2 := NULL) IS
        v_message               VARCHAR2(32000) := NULL;
        v_nl                    VARCHAR2(10)    := CHR(10);                            -- Line Feed
        v_tmp                   VARCHAR2(1000);
        v_cnt                   NUMBER;
        v_method_sid_not_code   VARCHAR2(20);
    BEGIN
        pok := 'N';

        IF NOT v_can_deliver THEN
            Core_Logger.log_it(v_pipe, 'Illegal call to delivery helper routine.');
            RETURN;
        END IF;

        Core_Logger.log_it(v_pipe, '%%%%%%%%%%%%%%%Inside deliver_invdeathemail');

        IF NOT email_update_blank_addresses('INV.DEATH.EMAIL') THEN
            RETURN;
        END IF;

        SELECT SID
          INTO v_method_sid_not_code
          FROM T_OSI_NOTIFICATION_METHOD
         WHERE code = 'INV.DEATH.EMAIL';

        -- Loop through all the notifications, grouped by effective address
        FOR a IN (SELECT DISTINCT n.delivery_address
                             FROM T_OSI_NOTIFICATION n
                            WHERE n.delivery_method = v_method_sid_not_code
                              AND n.delivery_date IS NULL
                              AND n.delivery_address IS NOT NULL
                              AND (   n.SID = pthis1
                                   OR pthis1 IS NULL))
        LOOP
            v_message := NULL;
            Core_Logger.log_it(v_pipe, 'Starting new message to: ' || a.delivery_address);

            FOR n IN (SELECT   n.*
                          FROM v_osi_notification n
                         WHERE n.delivery_method = v_method_sid_not_code
                           AND n.delivery_date IS NULL
                           AND n.delivery_address = a.delivery_address
                           AND (   n.SID = pthis1
                                OR pthis1 IS NULL)
                      ORDER BY n.parent_info)
            LOOP
                         -- v_message := v_message || 'Got Notification (Details follow)' || '<BR>';
                         -- v_message := v_message || 'Address: ' || n.EFF_ADDR || '<BR>';
                         -- v_message := v_message || 'Event: ' || n.DESCRIPTION || '<BR>';
                --
                --v_message := v_message || '<A HREF="' || core_util.get_config('CORE.BASE_URL') || n.PARENT || '"><IMG BORDER=0 ALT="Open in I2MS" SRC="http://hqsbui2ms/images/I2MS/OBJ_SEARCH/i2ms.gif"></A> ';
                v_message :=
                    v_message || '<A HREF="' || core_util.get_config('CORE.BASE_URL') || n.PARENT || '"'
                    || ' Title="Open in I2MS" ' || '>' || n.parent_info || '</A> <BR>';
                --v_message := v_message || n.PARENT_INFO || '<BR>';
                v_message :=
                    v_message || 'Date: ' || TO_CHAR(n.event_on, 'dd-Mon-yyyy hh24:mi:ss')
                    || '<BR>';
                v_message := v_message || 'Unit: ' || n.unit || '<BR>';
                v_message := v_message || 'Agent: ' || n.event_by || '<BR>';
                v_message := v_message || 'Specifics: ' || n.specifics || '<BR>';
                v_message := v_message || 'Summary of Investigation (first 2k): ' || '<BR>';

                FOR t IN (SELECT *
                            FROM T_OSI_F_INVESTIGATION
                           WHERE SID = n.PARENT)
                LOOP
                    IF t.summary_investigation IS NOT NULL THEN
                        v_message :=
                            v_message || '<BR>' || Clob_Text(t.summary_investigation, 2000)
                            || '<BR>';
                    END IF;
                END LOOP;

                v_message := v_message || '<HR>';
                Core_Logger.log_it(v_pipe, 'Added to message: ' || n.parent_info);

                UPDATE T_OSI_NOTIFICATION
                   SET delivery_date = SYSDATE
                 WHERE SID = n.SID;

                IF LENGTH(v_message) > 28000 THEN
                    v_message :=
                        v_message || '<HR>'
                        || '<B>YOU HAVE ADDITIONAL NOTIFICATIONS IN I2MS THAT COULD NOT BE SHOWN IN THIS EMAIL DUE TO SIZE LIMITATIONS.</B><BR>';
                    Core_Logger.log_it(v_pipe,
                                       'Added message length notice: ' || LENGTH(v_message));
                    EXIT;
                END IF;
            END LOOP;

            IF email_send(a.delivery_address, 'Death Case', v_message) THEN
                NULL;
            END IF;
        END LOOP;

        pok := 'Y';
        RETURN;
    EXCEPTION
        WHEN OTHERS THEN
            Core_Logger.log_it(v_pipe, 'Error: ' || SQLERRM);
            pok := 'N';
    END deliver_invdeathemail;

    PROCEDURE deliver_invfraudemail(pok OUT VARCHAR2, pthis1 IN VARCHAR2 := NULL) IS
        v_message               VARCHAR2(32000) := NULL;
        v_nl                    VARCHAR2(10)    := CHR(10);                            -- Line Feed
        v_tmp                   VARCHAR2(1000);
        v_cnt                   NUMBER;
        v_method_sid_not_code   VARCHAR2(200);
    BEGIN
        pok := 'N';

        IF NOT v_can_deliver THEN
            Core_Logger.log_it(v_pipe, 'Illegal call to delivery helper routine.');
            RETURN;
        END IF;

        IF NOT email_update_blank_addresses('INV.FRAUD.EMAIL') THEN
            RETURN;
        END IF;

        SELECT SID
          INTO v_method_sid_not_code
          FROM T_OSI_NOTIFICATION_METHOD
         WHERE code = 'INV.FRAUD.EMAIL';

        -- Loop through all the notifications, grouped by effective address
        FOR a IN (SELECT DISTINCT n.delivery_address
                             FROM T_OSI_NOTIFICATION n
                            WHERE n.delivery_method = v_method_sid_not_code
                              AND n.delivery_date IS NULL
                              AND n.delivery_address IS NOT NULL
                              AND (   n.SID = pthis1
                                   OR pthis1 IS NULL))
        LOOP
            v_message := NULL;
            Core_Logger.log_it(v_pipe, 'Starting new message to: ' || a.delivery_address);

            FOR n IN (SELECT   n.*
                          FROM v_osi_notification n
                         WHERE n.delivery_method = v_method_sid_not_code
                           AND n.delivery_date IS NULL
                           AND n.delivery_address = a.delivery_address
                           AND (   n.SID = pthis1
                                OR pthis1 IS NULL)
                      ORDER BY n.parent_info)
            LOOP
                         -- v_message := v_message || 'Got Notification (Details follow)' || '<BR>';
                         -- v_message := v_message || 'Address: ' || n.EFF_ADDR || '<BR>';
                         -- v_message := v_message || 'Event: ' || n.DESCRIPTION || '<BR>';
                --
                --v_message := v_message || '<A HREF="' || core_util.get_config('CORE.BASE_URL') || n.PARENT '"><IMG BORDER=0 ALT="Open in I2MS" SRC="http://hqsbui2ms/images/I2MS/OBJ_SEARCH/i2ms.gif"></A> ';
                v_message :=
                    v_message || '<A HREF="' || core_util.get_config('CORE.BASE_URL') || n.PARENT || '"'
                    || ' Title="Open in I2MS" ' || '>' || n.parent_info || '</A> <BR>';
                --v_message := v_message || n.PARENT_INFO || '<BR>';
                v_message :=
                    v_message || 'Date: ' || TO_CHAR(n.event_on, 'dd-Mon-yyyy hh24:mi:ss')
                    || '<BR>';
                v_message := v_message || 'Unit: ' || n.unit || '<BR>';
                v_message := v_message || 'Agent: ' || n.event_by || '<BR>';
                v_message := v_message || 'Specifics: ' || n.specifics || '<BR>';
                v_message := v_message || 'Summary of Investigation (first 5k): ' || '<BR>';

                FOR t IN (SELECT *
                            FROM T_OSI_F_INVESTIGATION
                           WHERE SID = n.PARENT)
                LOOP
                    IF t.summary_investigation IS NOT NULL THEN
                        v_message :=
                            v_message || '<BR>' || Clob_Text(t.summary_investigation, 5000)
                            || '<BR>';
                    END IF;
                END LOOP;

                v_message := v_message || '<HR>';
                Core_Logger.log_it(v_pipe, 'Added to message: ' || n.parent_info);

                UPDATE T_OSI_NOTIFICATION
                   SET delivery_date = SYSDATE
                 WHERE SID = n.SID;

                IF LENGTH(v_message) > 28000 THEN
                    v_message :=
                        v_message || '<HR>'
                        || '<B>YOU HAVE ADDITIONAL NOTIFICATIONS IN I2MS THAT COULD NOT BE SHOWN IN THIS EMAIL DUE TO SIZE LIMITATIONS.</B><BR>';
                    Core_Logger.log_it(v_pipe,
                                       'Added message length notice: ' || LENGTH(v_message));
                    EXIT;
                END IF;
            END LOOP;

            IF email_send(a.delivery_address, 'Fraud Case', v_message) THEN
                NULL;
            END IF;
        END LOOP;

        pok := 'Y';
        RETURN;
    EXCEPTION
        WHEN OTHERS THEN
            Core_Logger.log_it(v_pipe, 'Error: ' || SQLERRM);
            pok := 'N';
    END deliver_invfraudemail;

    PROCEDURE deliver_invfraud180email(pok OUT VARCHAR2, pthis1 IN VARCHAR2 := NULL) IS
        v_message               VARCHAR2(32000) := NULL;
        v_nl                    VARCHAR2(10)    := CHR(10);                            -- Line Feed
        v_tmp                   VARCHAR2(1000);
        v_cnt                   NUMBER;
        v_method_sid_not_code   VARCHAR2(20);
    BEGIN
        pok := 'N';

        IF NOT v_can_deliver THEN
            Core_Logger.log_it(v_pipe, 'Illegal call to delivery helper routine.');
            RETURN;
        END IF;

        IF NOT email_update_blank_addresses('INV.FRAUD.180.EMAIL') THEN
            RETURN;
        END IF;

        SELECT SID
          INTO v_method_sid_not_code
          FROM T_OSI_NOTIFICATION_METHOD
         WHERE code = 'INV.FRAUD.180.EMAIL';

        -- Loop through all the notifications, grouped by effective address
        FOR a IN (SELECT DISTINCT n.delivery_address
                             FROM T_OSI_NOTIFICATION n
                            WHERE n.delivery_method = v_method_sid_not_code
                              AND n.delivery_date IS NULL
                              AND n.delivery_address IS NOT NULL
                              AND (   n.SID = pthis1
                                   OR pthis1 IS NULL))
        LOOP
            v_message := NULL;
            Core_Logger.log_it(v_pipe, 'Starting new message to: ' || a.delivery_address);

            FOR n IN (SELECT   n.*
                          FROM v_osi_notification n
                         WHERE n.delivery_method = v_method_sid_not_code
                           AND n.delivery_date IS NULL
                           AND n.delivery_address = a.delivery_address
                           AND (   n.SID = pthis1
                                OR pthis1 IS NULL)
                      ORDER BY n.parent_info)
            LOOP
                --v_message := v_message || '<A HREF="' || core_util.get_config('CORE.BASE_URL') || n.PARENT || '"><IMG BORDER=0 ALT="Open in I2MS" SRC="http://hqsbui2ms/images/I2MS/OBJ_SEARCH/i2ms.gif"></A> ';
                v_message :=
                    v_message || '<A HREF="' || core_util.get_config('CORE.BASE_URL') || n.PARENT || '"'
                    || ' Title="Open in I2MS" ' || '>' || n.parent_info || '</A> <BR>';
                --v_message := v_message || n.PARENT_INFO || '<BR>';
                v_message :=
                    v_message || 'Date Opened: '
                    || TO_CHAR(Osi_Status.last_sh_date(n.PARENT, 'Open'), 'dd-Mon-yyyy hh24:mi:ss')
                    || '<BR>';
                v_message :=
                       v_message || 'Total Days Open: ' || Get_Days_Since_Opened(n.PARENT)
                       || '<BR>';
                v_message := v_message || 'Specifics: ' || n.specifics || '<BR>';
                v_message := v_message || 'Summary of Investigation (first 2k): ' || '<BR>';

                FOR t IN (SELECT *
                            FROM T_OSI_F_INVESTIGATION
                           WHERE SID = n.PARENT)
                LOOP
                    IF t.summary_investigation IS NOT NULL THEN
                        v_message :=
                            v_message || '<BR>' || Clob_Text(t.summary_investigation, 2000)
                            || '<BR>';
                    END IF;
                END LOOP;

                v_message := v_message || '<HR>';
                Core_Logger.log_it(v_pipe, 'Added to message: ' || n.parent_info);

                UPDATE T_OSI_NOTIFICATION
                   SET delivery_date = SYSDATE
                 WHERE SID = n.SID;

                IF LENGTH(v_message) > 28000 THEN
                    v_message :=
                        v_message
                        || '<B>YOU HAVE ADDITIONAL NOTIFICATIONS IN I2MS THAT COULD NOT BE SHOWN IN THIS EMAIL DUE TO SIZE LIMITATIONS.</B><BR>';
                    Core_Logger.log_it(v_pipe,
                                       'Added message length notice: ' || LENGTH(v_message));
                    EXIT;
                END IF;
            END LOOP;

            IF email_send(a.delivery_address, 'Approaching 180 Days into a Fraud Case.', v_message) THEN
                NULL;
            END IF;
        END LOOP;

        pok := 'Y';
        RETURN;
    EXCEPTION
        WHEN OTHERS THEN
            Core_Logger.log_it(v_pipe, 'Error: ' || SQLERRM);
            pok := 'N';
    END deliver_invfraud180email;

    PROCEDURE deliver_invcrime90email(pok OUT VARCHAR2, pthis1 IN VARCHAR2 := NULL) IS
        v_message               VARCHAR2(32000) := NULL;
        v_nl                    VARCHAR2(10)    := CHR(10);                            -- Line Feed
        v_tmp                   VARCHAR2(1000);
        v_cnt                   NUMBER;
        v_method_sid_not_code   VARCHAR2(20);
    BEGIN
        pok := 'N';

        IF NOT v_can_deliver THEN
            Core_Logger.log_it(v_pipe, 'Illegal call to delivery helper routine.');
            RETURN;
        END IF;

        IF NOT email_update_blank_addresses('INV.CRIME.90.EMAIL') THEN
            RETURN;
        END IF;

        SELECT SID
          INTO v_method_sid_not_code
          FROM T_OSI_NOTIFICATION_METHOD
         WHERE code = 'INV.CRIME.90.EMAIL';

        -- Loop through all the notifications, grouped by effective address
        FOR a IN (SELECT DISTINCT n.delivery_address
                             FROM T_OSI_NOTIFICATION n
                            WHERE n.delivery_method = v_method_sid_not_code
                              AND n.delivery_date IS NULL
                              AND n.delivery_address IS NOT NULL
                              AND (   n.SID = pthis1
                                   OR pthis1 IS NULL))
        LOOP
            v_message := NULL;
            Core_Logger.log_it(v_pipe, 'Starting new message to: ' || a.delivery_address);

            FOR n IN (SELECT   n.*
                          FROM v_OSI_notification n
                         WHERE n.delivery_method = v_method_sid_not_code
                           AND n.delivery_date IS NULL
                           AND n.delivery_address = a.delivery_address
                           AND (   n.SID = pthis1
                                OR pthis1 IS NULL)
                      ORDER BY n.parent_info)
            LOOP
                --v_message := v_message || '<A HREF="' || core_util.get_config('CORE.BASE_URL') || n.PARENT || '"><IMG BORDER=0 ALT="Open in I2MS" SRC="http://hqsbui2ms/images/I2MS/OBJ_SEARCH/i2ms.gif"></A> ';
                v_message :=
                    v_message || '<A HREF="' || core_util.get_config('CORE.BASE_URL') || n.PARENT || '"'
                    || ' Title="Open in I2MS" ' || '>' || n.parent_info || '</A> <BR>';
                --v_message := v_message || n.PARENT_INFO || '<BR>';
                v_message :=
                    v_message || 'Date Opened: '
                    || TO_CHAR(Osi_Status.last_sh_date(n.PARENT, 'Open'), 'dd-Mon-yyyy hh24:mi:ss')
                    || '<BR>';
                v_message :=
                       v_message || 'Total Days Open: ' || Get_Days_Since_Opened(n.PARENT)
                       || '<BR>';
                v_message := v_message || 'Specifics: ' || n.specifics || '<BR>';
                v_message := v_message || 'Summary of Investigation (first 2k): ' || '<BR>';

                FOR t IN (SELECT *
                            FROM T_OSI_F_INVESTIGATION
                           WHERE SID = n.PARENT)
                LOOP
                    IF t.summary_investigation IS NOT NULL THEN
                        v_message :=
                            v_message || '<BR>' || Clob_Text(t.summary_investigation, 2000)
                            || '<BR>';
                    END IF;
                END LOOP;

                v_message := v_message || '<HR>';
                Core_Logger.log_it(v_pipe, 'Added to message: ' || n.parent_info);

                UPDATE T_OSI_NOTIFICATION
                   SET delivery_date = SYSDATE
                 WHERE SID = n.SID;

                IF LENGTH(v_message) > 28000 THEN
                    v_message :=
                        v_message
                        || '<B>YOU HAVE ADDITIONAL NOTIFICATIONS IN I2MS THAT COULD NOT BE SHOWN IN THIS EMAIL DUE TO SIZE LIMITATIONS.</B><BR>';
                    Core_Logger.log_it(v_pipe,
                                       'Added message length notice: ' || LENGTH(v_message));
                    EXIT;
                END IF;
            END LOOP;

            IF email_send(a.delivery_address, 'Approaching 90 Days into a Criminal Case.',
                          v_message) THEN
                NULL;
            END IF;
        END LOOP;

        pok := 'Y';
        RETURN;
    EXCEPTION
        WHEN OTHERS THEN
            Core_Logger.log_it(v_pipe, 'Error: ' || SQLERRM);
            pok := 'N';
    END deliver_invcrime90email;

    PROCEDURE deliverspot15(pthisnotification IN VARCHAR2 := NULL) IS
/*
     For email delivery of SPOT reports on a more frequent basis.
 This procedure may be called on 15 minute intervals for SPOT reports only. WC
    Parameters:
        pThisNotification - A specific notification to deliver (optional).
*/
        v_cnt       NUMBER;
        v_ok        VARCHAR2(1);
        v_dyn_sql   VARCHAR2(200);
        v_method_sid_not_code   VARCHAR2(200);
    BEGIN
        Core_Logger.log_it(v_pipe, '>>> DeliverSpot15');
        
        SELECT SID
          INTO v_method_sid_not_code
          FROM T_OSI_NOTIFICATION_METHOD
         WHERE code = 'INV.SPOT.EMAIL';

        SELECT COUNT(*)
          INTO v_cnt
          FROM T_OSI_NOTIFICATION n
         WHERE n.delivery_date IS NULL AND n.delivery_method = v_method_sid_not_code;

        Core_Logger.log_it(v_pipe, 'Number of SPOT notifications found: ' || v_cnt);
        Core_Logger.log_it(v_pipe, 'Delivering INV.SPOT.EMAIL');
        v_dyn_sql := 'OSI_NOTIFICATION.Deliver_INVSPOTEMAIL';
        Core_Logger.log_it(v_pipe, 'Processing routine: ' || v_dyn_sql);
        v_dyn_sql := 'begin ' || v_dyn_sql || '(:ok,:t1); end;';
        v_can_deliver := TRUE;

        DECLARE
            v_sqlerrm   VARCHAR2(4000);
        BEGIN
            v_ok := 'N';

            EXECUTE IMMEDIATE v_dyn_sql
                        USING OUT v_ok, IN pthisnotification;
        EXCEPTION
            WHEN OTHERS THEN
                v_sqlerrm := SQLERRM;
                Core_Logger.log_it(v_pipe, 'Error: ' || v_sqlerrm);
                v_ok := 'N';
        END;

        v_can_deliver := FALSE;

        IF v_ok = 'Y' THEN
            IF pthisnotification IS NULL THEN
                COMMIT;
            END IF;
        ELSE
            IF pthisnotification IS NULL THEN
                ROLLBACK;
            END IF;
        END IF;

        <<exit_proc>>
        Core_Logger.log_it(v_pipe, '<<< DeliverSpot15');
    EXCEPTION
        WHEN OTHERS THEN
            Core_Logger.log_it(v_pipe, 'Error: ' || SQLERRM);
            Core_Logger.log_it(v_pipe, '<<< DeliverSpot15');

            IF pthisnotification IS NULL THEN
                ROLLBACK;
            END IF;

            RETURN;
    END deliverspot15;

    PROCEDURE deliver_invspotemail(pok OUT VARCHAR2, pthis1 IN VARCHAR2 := NULL) IS
        v_message   VARCHAR2(32000) := NULL;
        v_nl        VARCHAR2(10)    := CHR(10);                                        -- Line Feed
        v_tmp       VARCHAR2(1000);
        v_cnt       NUMBER;
        v_method_sid_not_code   VARCHAR2(200);
    BEGIN
        pok := 'N';

        IF NOT v_can_deliver THEN
            Core_Logger.log_it(v_pipe, 'Illegal call to delivery helper routine.');
            RETURN;
        END IF;

        IF NOT email_update_blank_addresses('INV.SPOT.EMAIL') THEN
            RETURN;
        END IF;
        
        SELECT SID
          INTO v_method_sid_not_code
          FROM T_OSI_NOTIFICATION_METHOD
         WHERE code = 'INV.SPOT.EMAIL';
         
        -- Loop through all the notifications, grouped by effective address
        FOR a IN (SELECT DISTINCT n.delivery_address
                             FROM T_OSI_NOTIFICATION n
                            WHERE n.delivery_method = v_method_sid_not_code
                              AND n.delivery_date IS NULL
                              AND n.delivery_address IS NOT NULL
                              AND (   n.SID = pthis1
                                   OR pthis1 IS NULL))
        LOOP
            v_message := NULL;
            Core_Logger.log_it(v_pipe, 'Starting new message to: ' || a.delivery_address);

            FOR n IN (SELECT   n.*
                          FROM v_osi_notification n
                         WHERE n.delivery_method = v_method_sid_not_code
                           AND n.delivery_date IS NULL
                           AND n.delivery_address = a.delivery_address
                           AND (   n.SID = pthis1
                                OR pthis1 IS NULL)
                      ORDER BY n.parent_info)
            LOOP
                v_message :=
                    v_message || '<A HREF="' || core_util.get_config('CORE.BASE_URL') || n.PARENT || '"'
                    || ' Title="Open in I2MS" ' || '>' || n.parent_info || '</A> <BR>';
                v_message :=
                    v_message || 'Date: ' || TO_CHAR(n.event_on, 'dd-Mon-yyyy hh24:mi:ss')
                    || '<BR>';
                v_message := v_message || 'Unit: ' || n.unit || '<BR>';
                v_message := v_message || 'Agent: ' || n.event_by || '<BR>';
                v_message := v_message || 'Specifics: ' || n.specifics || '<BR>';
                v_message := v_message || 'Summary of Investigation (first 6k): ' || '<BR>';

                FOR t IN (SELECT *
                            FROM T_OSI_F_INVESTIGATION
                           WHERE SID = n.PARENT)
                LOOP
                    IF t.summary_investigation IS NOT NULL THEN
                        v_message :=
                            v_message || '<BR>' || Clob_Text(t.summary_investigation, 6000)
                            || '<BR>';
                    END IF;
                END LOOP;

                v_message := v_message || '<HR>';
                Core_Logger.log_it(v_pipe, 'Added to message: ' || n.parent_info);

                UPDATE T_OSI_NOTIFICATION
                   SET delivery_date = SYSDATE
                 WHERE SID = n.SID;

                IF LENGTH(v_message) > 24000 THEN
                    v_message :=
                        v_message || '<HR>'
                        || '<B>YOU HAVE ADDITIONAL NOTIFICATIONS IN I2MS THAT COULD NOT BE SHOWN IN THIS EMAIL DUE TO SIZE LIMITATIONS.</B><BR>';
                    Core_Logger.log_it(v_pipe,
                                       'Added message length notice: ' || LENGTH(v_message));
                    EXIT;
                END IF;
            END LOOP;

            IF email_send(a.delivery_address, 'SPOT Reportable Cases', v_message) THEN
                NULL;
            END IF;
        END LOOP;

        pok := 'Y';
        RETURN;
    EXCEPTION
        WHEN OTHERS THEN
            Core_Logger.log_it(v_pipe, 'Error: ' || SQLERRM);
            pok := 'N';
    END deliver_invspotemail;

    PROCEDURE deliver_actsurvexpiredemail(pok OUT VARCHAR2, pthis1 IN VARCHAR2 := NULL) IS
    v_message   VARCHAR2(32000) := NULL;
    v_nl        VARCHAR2(10)    := CHR(10);                                            -- Line Feed
    v_tmp       VARCHAR2(1000);
    v_cnt       NUMBER;
    BEGIN
        pok := 'N';

        if not v_can_deliver then
            CORE_LOGGER.log_it(v_pipe, 'Illegal call to delivery helper routine.');
            return;
        end if;

        if not email_update_blank_addresses('ACT.SURV.EXPIRED.EMAIL') then
            return;
        end if;

        -- Loop through all the notifications, grouped by effective address
        for a in (SELECT DISTINCT n.delivery_address, net.description
                             FROM T_OSI_NOTIFICATION n,
                                  T_OSI_NOTIFICATION_EVENT ne,
                                  T_OSI_NOTIFICATION_EVENT_TYPE net
                            WHERE net.code = 'ACT.SURV.EXPIRED'
                              AND n.delivery_date IS NULL
                              AND n.delivery_address IS NOT NULL
                              AND (   n.SID = pthis1
                                   OR pthis1 IS NULL)
                              AND ne.SID = n.event
                              AND net.SID = ne.event_code)
        loop
            v_message := null;
            CORE_LOGGER.log_it(v_pipe, 'Starting new message to: ' || a.delivery_address);

            for n in (SELECT   n.*
                          FROM v_osi_notification n, t_osi_notification_method nm
                         WHERE nm.code = 'ACT.SURV.EXPIRED.EMAIL'
                           AND n.delivery_date IS NULL
                           AND n.delivery_address = a.delivery_address
                           AND (   n.SID = pthis1
                                OR pthis1 IS NULL)
                           AND n.delivery_method = nm.SID
                      ORDER BY n.parent_info)
            loop
                --v_message := v_message || '<A HREF="' || core_util.get_config('CORE.BASE_URL') || n.PARENT || '"><IMG BORDER=0 ALT="Open in I2MS" SRC="http://hqsbui2ms/images/I2MS/OBJ_SEARCH/i2ms.gif"></A> ';
                v_message :=
                    v_message || '<A HREF="' || core_util.get_config('CORE.BASE_URL') || n.parent || '"'
                    || ' Title="Open in I2MS" ' || '>' || n.parent_info || '</A> <BR>';
                --v_message := v_message || n.PARENT_INFO || '<BR>';
                v_message := v_message || 'Specifics: ' || n.specifics || '<BR>';
                v_message := v_message || '<HR>';
                CORE_LOGGER.log_it(v_pipe, 'Added to message: ' || n.parent_info);

                update t_osi_notification
                   set delivery_date = sysdate
                 where SID = n.SID;

                if length(v_message) > 28000 then
                    v_message :=
                        v_message
                        || '<B>YOU HAVE ADDITIONAL NOTIFICATIONS IN I2MS THAT COULD NOT BE SHOWN IN THIS EMAIL DUE TO SIZE LIMITATIONS.</B><BR>';
                    CORE_LOGGER.log_it(v_pipe, 'Added message length notice: ' || length(v_message));
                    exit;
                end if;
            end loop;

            if email_send(a.delivery_address, 'Surveillance Expired or Expiring in 10 Days.', v_message) then
                null;
            end if;
        end loop;

        pok := 'Y';
        return;
    exception
        when others then
            CORE_LOGGER.log_it(v_pipe, 'Error: ' || sqlerrm);
            pok := 'N';
            pok := 'Y';
            NULL;
    END deliver_actsurvexpiredemail;

-- CLEANUP
    PROCEDURE cleanup IS
        v_desktop_age_limit   NUMBER;
        v_undeliv_age_limit   NUMBER;
        v_cnt                 NUMBER;
    BEGIN
        Core_Logger.log_it(v_pipe, '>>> Cleanup');
        v_desktop_age_limit := NVL(Core_Util.get_config('NOTIF_CLN1'), 14);
        v_undeliv_age_limit := NVL(Core_Util.get_config('NOTIF_CLN2'), 21);
        -- Get notifications that have done their job (or apparently won't)
        v_cnt := 0;

        FOR n IN (SELECT n.SID
                    FROM T_OSI_NOTIFICATION n, T_OSI_NOTIFICATION_METHOD nm
                   WHERE nm.code(+) = n.delivery_method
                     AND (   (n.delivery_date + NVL(nm.age_limit, v_desktop_age_limit)) < SYSDATE
                          OR (n.generation_date + v_undeliv_age_limit) < SYSDATE))
        LOOP
            BEGIN
                DELETE FROM T_OSI_NOTIFICATION
                      WHERE SID = n.SID;

                v_cnt := v_cnt + SQL%rowcount;
            EXCEPTION
                WHEN OTHERS THEN
                    Core_Logger.log_it(v_pipe, 'Error (notifications): ' || SQLERRM);
            END;
        END LOOP;

        COMMIT;
        Core_Logger.log_it(v_pipe, 'Deleted ' || v_cnt || ' notifications');
        -- Get generated events that no longer have any notifications
        v_cnt := 0;

        FOR e IN (SELECT SID
                    FROM T_OSI_NOTIFICATION_EVENT ne
                   WHERE UPPER(ne.GENERATED) = 'Y' AND ne.SID NOT IN(SELECT event
                                                                       FROM T_OSI_NOTIFICATION))
        LOOP
            BEGIN
                DELETE FROM T_OSI_NOTIFICATION_EVENT
                      WHERE SID = e.SID;

                v_cnt := v_cnt + SQL%rowcount;
            EXCEPTION
                WHEN OTHERS THEN
                    Core_Logger.log_it(v_pipe, 'Error (events): ' || SQLERRM);
            END;
        END LOOP;

        COMMIT;
        Core_Logger.log_it(v_pipe, 'Deleted ' || v_cnt || ' events');
        Core_Logger.log_it(v_pipe, '<<< Cleanup');
    END cleanup;

    FUNCTION get_primary_email(p_personnel IN VARCHAR2)
        RETURN VARCHAR2 IS
        v_email   VARCHAR2(200);
        v_code    VARCHAR2(200);
    BEGIN
        SELECT SID
          INTO V_CODE
          FROM T_OSI_REFERENCE
         WHERE USAGE = 'CONTACT_TYPE' AND CODE = 'EMLP';

        FOR i IN (SELECT   *
                      FROM T_OSI_PERSONNEL_CONTACT
                     WHERE PERSONNEL = p_PERSONNEL AND TYPE = v_CODE AND VALUE IS NOT NULL
                  ORDER BY modify_on DESC)
        LOOP
            RETURN i.VALUE;
        END LOOP;

        RETURN NULL;
    EXCEPTION
        WHEN OTHERS THEN
            Core_Logger.log_it(v_pipe,
                               'get_primary_email error: ' || DBMS_UTILITY.format_error_backtrace
                               || ' p_personnel= ' || p_personnel);
            RETURN NULL;
    END get_primary_email;

    FUNCTION is_open_file(p_sid IN VARCHAR2)
        RETURN VARCHAR2 IS
    BEGIN
        FOR i IN (SELECT SID
                    FROM T_OSI_FILE
                   WHERE SID = p_sid AND UPPER(Osi_Object.GET_STATUS(p_SID)) = 'OPEN')
        LOOP
            RETURN 'Y';
        END LOOP;

        RETURN 'N';
    END;
END Osi_Notification;
/

-- "Set define off" turns off substitution variables. 
Set define off; 

CREATE OR REPLACE package osi_cfunds as
/******************************************************************************
   Name:     Osi_CFunds
   Purpose:  Provides Functionality Common Across Multiple Object Types.

   Revisions:
    Date        Author          Description
    ----------  --------------  ------------------------------------
    24-Jun-2009 C.Hall          Created Package
    26-Jun-2009 C.Hall          Added get_tagline.
    17-Aug-2009 M.Batdorf       Added get_cfunds_mgmt_url.
    21-Oct-2009 R.Dibble        Added get_cfunds_mgmt_url_raw so it would
                                *actually* function correctly
    9-Nov-2009  J.Faris         Added can_delete.
    19-Jan-2010 T.McGuffin      Added check_writability.
    24-Jan-2011 J.Faris         Added create_instance, creates a new cfunds expense object.
    02-Mar-2011 Tim Ward        CR#3705 - Added generate_expense_cover_sheet.
    02-Mar-2011 Tim Ward        CR#3722 - Added get_default_charge_unit.
    16-Mar-2011 Tim Ward        Added get_id function.
******************************************************************************/
    function validate_amount(p_amount in varchar2, p_mask varchar2)
        return varchar2;

    function get_cfunds_url(p_obj in varchar2)
        return varchar2;

    function get_tagline(p_obj in varchar2)
        return varchar2;

    function get_cfunds_mgmt_url
        return varchar2;

    function get_cfunds_mgmt_url_raw
        return varchar2;

    /*  Given a file sid as p_obj, can_delete will return a custom error message if the object
        is not deletable, otherwise will return a 'Y' */
    function can_delete(p_obj in varchar2)
        return varchar2;

    /* checks whether a given cfunds expense object should be writable or not */
    function check_writability(p_obj in varchar2, p_context in varchar2)
        return varchar2;

    /* create_instance creates a new cfunds expense object  */
    function create_instance(
        p_incurred_date             IN   DATE,
        p_charge_to_unit            IN   VARCHAR2,
        p_claimant                  IN   VARCHAR2,
        p_category                  IN   VARCHAR2,
        p_paragraph                 IN   VARCHAR2,
        p_description               IN   VARCHAR2,
        p_parent                    IN   VARCHAR2,
        p_parent_info               IN   VARCHAR2,
        p_take_from_advances        IN   NUMBER,
        p_take_from_other_sources   IN   NUMBER,
        p_receipt_disposition       IN   VARCHAR2,
        p_source_amount             IN   NUMBER,
        p_agent_amount              IN   NUMBER,
        p_conversion_rate           IN   NUMBER)
        return varchar2;

    function generate_expense_cover_sheet(p_obj in varchar2) return clob;

    function get_default_charge_unit return varchar2;

    function get_id(p_obj in varchar2, p_obj_context in varchar2 := null) return varchar2;
    
end osi_cfunds;
/


CREATE OR REPLACE package body osi_cfunds as
/******************************************************************************
   Name:     Osi_CFunds
   Purpose:  Provides Functionality Common Across Multiple Object Types.

   Revisions:
    Date        Author          Description
    ----------  --------------  ------------------------------------
    24-Jun-2009 C.Hall          Created Package
    26-Jun-2009 C.Hall          Added get_tagline.
    21-Oct-2009 R.Dibble        Added get_cfunds_mgmt_url_raw
    9-Nov-2009  J.Faris         Added can_delete.
    19-Jan-2010  T.McGuffin     Added check_writability.
    24-Jan-2011 J.Faris         Added create_instance, creates a new cfunds expense object.
    02-Mar-2011 Tim Ward        CR#3705 - Added generate_expense_cover_sheet.
    02-Mar-2011 Tim Ward        CR#3722 - Added get_default_charge_unit and call it from
                                 get_cfunds_mgmt_url and get_cfunds_mgmt_url_raw.
    16-Mar-2011 Tim Ward        Added get_id function.
******************************************************************************/
    c_pipe   varchar2(100) := core_util.get_config('CORE.PIPE_PREFIX') || 'OSI_CFUNDS';

    procedure log_error(p_msg in varchar2) is
    begin
        core_logger.log_it(c_pipe, p_msg);
    end log_error;

    function validate_amount(p_amount in varchar2, p_mask varchar2)
        return varchar2 is
        v_err_found    varchar2(10) := 'N';
        v_amount_num   number;
    begin
        begin
            v_amount_num := to_number(p_amount, p_mask);
        exception
            when value_error then
                v_err_found := 'Y';
        end;

        -- try converting without the mask
        if (v_err_found = 'Y') then
            begin
                v_amount_num := to_number(p_amount);
            exception
                when value_error then
                    return 'N';
            end;
        end if;

        if (v_amount_num > 0) then
            return 'Y';
        elsif(v_amount_num = 0) then
            return 'Y0';
        else
            return 'N';
        end if;
    exception
        when others then
            log_error('Amount conversion error: ' || p_amount || ' ~ ' || p_mask || ' ~ ' || sqlerrm);
            return 'N';
    end validate_amount;

    function get_cfunds_url(p_obj in varchar2)
        return varchar2 is
        v_url   varchar2(200);
    begin
        select 'javascript:newWindow({page:' || page_num || ',clear_cache:''' || page_num
               || ''',name:''' || p_obj || ''',item_names:''P' || page_num
               || '_SID'',item_values:''' || p_obj || ''',request:''OPEN''})'
          into v_url
          from t_core_dt_obj_type_page
         where obj_type = core_obj.get_objtype(p_obj) and page_function = 'OPEN';

        return v_url;
    exception
        when others then
            log_error('get_cfunds_url: ' || sqlerrm);
            return('get_funds_url: Error');
    end get_cfunds_url;

    function get_default_charge_unit return varchar2 is

         myCount           number;
         myUnit            varchar2(20);

    begin
         myUnit := osi_personnel.get_current_unit;

         while myUnit is not null
         loop
     
              select count(*) into myCount from t_cfunds_unit where sid=myUnit;
          
              if myCount = 1 then
       
                return myUnit;

              end if;

              select unit_parent into myUnit from t_osi_unit where sid=myUnit;

         end loop;

         return null;

    end get_default_charge_unit;

    function get_cfunds_mgmt_url
        return varchar2 is
        v_ticket   varchar2(200);
    begin
        --ticket_pkg.get_ticket_for_vb(core_context.personnel_sid, v_ticket);
        ticket_pkg.get_ticket(core_context.personnel_sid, v_ticket);
        return core_util.get_config('CFUNDS_URL') || '?punit=' || nvl(get_default_charge_unit,osi_personnel.get_current_unit)
               || '&' || core_util.get_config('TICKET_PARAM_NAME') || '=' || v_ticket || '"'
               || ' target=' || chr(39) || '_blank' || chr(39);
    end get_cfunds_mgmt_url;

    function get_cfunds_mgmt_url_raw
        return varchar2 is
        v_ticket   varchar2(200);
    begin
        return core_util.get_config('CFUNDS_URL') || '?punit=' || nvl(get_default_charge_unit,osi_personnel.get_current_unit);
    end get_cfunds_mgmt_url_raw;

    function get_tagline(p_obj in varchar2)
        return varchar2 is
        v_claimant   varchar2(120);
    begin
        select osi_personnel.get_name(claimant)
          into v_claimant
          from v_cfunds_expense_v3
         where SID = p_obj;

        return 'C-Funds Expense for ' || v_claimant;
    exception
        when others then
            log_error('get_tagline error: ' || sqlerrm);
            return 'get_tagline: Error';
    end get_tagline;

    function can_delete(p_obj in varchar2)
        return varchar2 is
        v_stat       varchar2(20);
        v_claimant   varchar2(200);
    begin
        -- if status in new, submitted, approved, or disallowed AND not paid, ok to delete
        begin
            select 'Y'
              into v_stat
              from t_cfunds_expense_v3
             where osi_object.get_status(p_obj) in('NEW', 'SUBMITTED', 'APPROVED', 'DISALLOWED')
               and paid_on is null;
        exception
            when no_data_found then
                return 'The Expense has already been paid to the agent, therefore it cannot be deleted.';
        end;

        -- Check if this is the claimant of the expense OR has the proxy privilege.
        begin
            select 'Y'
              into v_claimant
              from t_cfunds_expense_v3
             where SID = p_obj and claimant = core_context.personnel_sid;
        --TBD: potential check for "Proxy" Privilege
        exception
            when no_data_found then
                return 'You can only delete your own expense.';
        end;

        return 'Y';
    exception
        when others then
            log_error('OSI_CFUNDS.Can_Delete: Error encountered using Object ' || nvl(p_obj, 'NULL')
                      || ':' || sqlerrm);
            return 'Untrapped error in OSI_CFUNDS.Can_Delete using Object: ' || nvl(p_obj, 'NULL');
    end can_delete;

    function check_writability(p_obj in varchar2, p_context in varchar2)
        return varchar2 is
        v_claimant          t_core_personnel.SID%type;
        v_obj_type          t_core_obj_type.SID%type;
        v_status            varchar2(50);
        v_parent_writable   varchar2(1);
    begin
        select claimant,
               cfunds_pkg.get_expense_status(submitted_on,
                                             approved_on,
                                             rejected_on,
                                             paid_on,
                                             invalidated_on,
                                             repaid_on,
                                             reviewing_unit,
                                             closed_on),
               core_obj.lookup_objtype('CFUNDS_EXP'), osi_object.check_writability(parent, null)
          into v_claimant,
               v_status,
               v_obj_type, v_parent_writable
          from t_cfunds_expense_v3
         where SID = p_obj;

        if v_parent_writable = 'Y' then
            if (    (   v_claimant = core_context.personnel_sid
                     or osi_auth.check_for_priv('EXP_CRE_PROXY', v_obj_type) = 'Y')
                and v_status in('New', 'Disallowed', 'Rejected')) then
                return 'Y';
            elsif     osi_auth.check_for_priv('APPROVE_CL', v_obj_type) = 'Y'
                  and v_status in('Submitted', 'Disallowed') then
                return 'Y';
            end if;
        end if;

        return 'N';
    exception
        when no_data_found then
            return 'N';
        when others then
            log_error('check_writability: ' || sqlerrm);
            raise;
    end check_writability;

    function create_instance(
        p_incurred_date             IN   DATE,
        p_charge_to_unit            IN   VARCHAR2,
        p_claimant                  IN   VARCHAR2,
        p_category                  IN   VARCHAR2,
        p_paragraph                 IN   VARCHAR2,
        p_description               IN   VARCHAR2,
        p_parent                    IN   VARCHAR2,
        p_parent_info               IN   VARCHAR2,
        p_take_from_advances        IN   NUMBER,
        p_take_from_other_sources   IN   NUMBER,
        p_receipt_disposition       IN   VARCHAR2,
        p_source_amount             IN   NUMBER,
        p_agent_amount              IN   NUMBER,
        p_conversion_rate           IN   NUMBER)
        return VARCHAR2 IS
        v_sid        T_CORE_OBJ.SID%TYPE;
        v_obj_type   VARCHAR2(20);
    begin
        v_obj_type := core_obj.lookup_objtype('CFUNDS_EXP');

        insert into t_core_obj
                    (obj_type)
             values (v_obj_type)
          returning SID
               into v_sid;

        insert into t_cfunds_expense_v3
                    (SID,
                     incurred_date,
                     charge_to_unit,
                     claimant,
                     category,
                     paragraph,
                     description,
                     parent,
                     parent_info,
                     take_from_advances,
                     take_from_other_sources,
                     receipts_disposition,
                     source_amount,
                     agent_amount,
                     conversion_rate)
             values (v_sid,
                     p_incurred_date,
                     p_charge_to_unit,
                     p_claimant,
                     p_category,
                     p_paragraph,
                     p_description,
                     p_parent,
                     p_parent_info,
                     p_take_from_advances,
                     p_take_from_other_sources,
                     p_receipt_disposition,
                     p_source_amount,
                     p_agent_amount,
                     p_conversion_rate);

        Core_Obj.bump(v_sid);
        return v_sid;
    exception
        when OTHERS then
            log_error('Error creating CFunds Expense. Error is: ' || SQLERRM);
            RAISE;
    end create_instance;

    function generate_expense_cover_sheet(p_obj in varchar2) return clob is

        v_agent             varchar2(4000);
        v_paragraph         varchar2(4000);
        v_category          varchar2(4000);
        v_date_incurred     date;
        v_expense_id        varchar2(30);
        v_charge_to_unit    varchar2(20);
        v_context           varchar2(4000);
        v_source_id         varchar2(19);
        v_source_amount     number;
        v_agent_amount      number;
        v_total_amount      number;
        v_conversion_rate   number;
        v_total_amount_us   number;
        v_description       varchar2(4000);
        v_paragraph_number  varchar2(4000);
        v_paragraph_content varchar2(4000);
        v_parent            varchar2(20);
        v_return            clob := null;
        v_fmt_cf_currency   varchar2(4000) := core_util.get_config('CFUNDS.CURRENCY');
        v_date_fmt_day      varchar2(4000) := core_util.get_config('CORE.DATE_FMT_DAY');
        v_CRLF              varchar2(4) := CHR(13) || CHR(10);

    begin

        select claimant_name,
               paragraph_number || ' - ' || paragraph_content,
               category_desc, incurred_date, voucher_no, charge_to_unit,
               parent_info, decode(source_id,null,'N/A','','N/A',source_id), source_amount,
               agent_amount, total_amount, conversion_rate,
               total_amount_us, description,
               paragraph_number,
               paragraph_content,
               parent
          into v_agent,
               v_paragraph,
               v_category, v_date_incurred, v_expense_id, v_charge_to_unit,
               v_context, v_source_id, v_source_amount,
               v_agent_amount, v_total_amount, v_conversion_rate,
               v_total_amount_us, v_description,
               v_paragraph_number,
               v_paragraph_content,
               v_parent
          from v_cfunds_expense_v3
         where sid = p_obj;


        v_return :=
            '***************************************************************' || v_CRLF
            || 'CFunds Expense Cover Sheet, printed on '
            || to_char(systimestamp, v_date_fmt_day || ' HH12:MI:SS AM') || v_CRLF
            || '***************************************************************'
            || v_CRLF || v_CRLF || 'Agent Name                 :  ' || v_agent
            || v_CRLF || v_CRLF || 'Incurred Date              :  '
            || to_char(v_date_incurred, v_date_fmt_day) || v_CRLF || v_CRLF
            || 'Expense ID                 :  ' || v_expense_id || v_CRLF
            || v_CRLF || v_CRLF || 'Unit Charged with Expense  :  '
            || osi_unit.get_name(v_charge_to_unit) || v_CRLF || v_CRLF
            || 'Paragraph                  :  ' || v_paragraph_number || ' - ' || osi_util.wordwrapfunc(v_paragraph_content, 40 - Length(v_paragraph_number) -3, v_CRLF || '                              ' || lpad(' ', Length(v_paragraph_number) + 3, ' ')) || v_CRLF || v_CRLF
            || v_CRLF || 'Category                   :  ' || v_category || v_CRLF
            || v_CRLF || 'Context                    :  ' || 'Activity: ' || osi_activity.get_id(v_parent) || ' - ' || core_obj.get_tagline(v_parent) || v_CRLF
            || v_CRLF || v_CRLF || 'Source Number              :  ' || v_source_id
            || v_CRLF || v_CRLF || 'Source Amount              :  '
            || ltrim(to_char(v_source_amount, v_fmt_cf_currency), '$') || v_CRLF
            || v_CRLF || 'Agent Amount               :  '
            || ltrim(to_char(v_agent_amount, v_fmt_cf_currency), '$') || v_CRLF
            || v_CRLF || '                              __________' || v_CRLF
            || 'Amount Spent               :  '
            || ltrim(to_char(v_total_amount, v_fmt_cf_currency), '$') || v_CRLF
            || v_CRLF || 'Conversion Rate            :  ' || v_conversion_rate
            || v_CRLF || v_CRLF || '                              __________'
            || v_CRLF || 'Expense Amount (US Dollars):  '
            || to_char(v_total_amount_us, v_fmt_cf_currency) || v_CRLF || v_CRLF
            || v_CRLF || 'Details                    :  ' || v_description;
            
            return v_return;

    end generate_expense_cover_sheet;

    function get_id(p_obj in varchar2, p_obj_context in varchar2 := null)
        return varchar2 is
        v_id   t_cfunds_expense_v3.voucher_no%type;
    begin
        if p_obj is null then
            log_error('get_id: null value passed');
            return null;
        end if;

        select voucher_no
          into v_id
          from t_cfunds_expense_v3
         where SID = p_obj;

        return v_id;
    exception
        when no_data_found then
            return null;
        when others then
            log_error('get_id: ' || sqlerrm);
    end get_id;
            
end osi_cfunds;
/


-- "Set define off" turns off substitution variables. 
Set define off; 

CREATE OR REPLACE PACKAGE "OSI_CFUNDS_ADV" as
/******************************************************************************
   NAME:       OSI_CFUNDS_ADV
   PURPOSE:    Used to handle CFunds Advance objects

   REVISIONS:
   Date         Author           Description
   -----------  ---------------  ------------------------------------
   07-Oct-2009  Richard Dibble   Created this package.
   09-Nov-2009  Jason Faris      Added can_delete.
   10-Feb-2010  Tim McGuffin     Added check_writability.
   25-Mar-2010  Tim McGuffin     Added get_claimant.
   16-Mar-2011  Tim Ward         Added get_id function.
*****************************************************************************/

    /* Given an object sid as p_obj, returns a default activity tagline */
    function get_tagline(p_obj in varchar2)
        return varchar2;

    /* Will take all necessary steps to create a new instance of this type of object */
    function create_instance(
        p_obj_type           in   varchar2,
        p_claimant           in   varchar2,
        p_requested_amount   in   varchar2,
        p_requested_unit     in   varchar2,
        p_voucher_no         in   varchar2,
        p_narrative          in   varchar2,
        p_date_of_request    in   date)
        return varchar2;

    /*  Given a file sid as p_obj, can_delete will return a custom error message if the object
        is not deletable, otherwise will return a 'Y' */
    function can_delete(p_obj in varchar2)
        return varchar2;

    /* checks whether a given cfunds advance object should be writable or not */
    function check_writability(p_obj in varchar2, p_context in varchar2)
        return varchar2;

    /* returns the sid of the personnel for the claimant responsible for a cfunds advance */
    function get_claimant(p_obj in varchar2) return varchar2;

    function get_id(p_obj in varchar2, p_obj_context in varchar2 := null) return varchar2;
end osi_cfunds_adv;
/


CREATE OR REPLACE PACKAGE BODY "OSI_CFUNDS_ADV" AS
/******************************************************************************
   NAME:       OSI_CFUNDS_ADV
   PURPOSE:    Used to handle CFunds Advance objects

   REVISIONS:
   Date         Author           Description
   -----------  ---------------  ------------------------------------
   07-Oct-2009  Richard Dibble   Created this package.
   09-Nov-2009  Jason Faris      Added can_delete.
   16-Dec-2009  Richard Dibble   Modified can_delete to use the proper
                                  "get status" function
   10-Feb-2010  Tim McGuffin     Added check_writability, fixed can_delete.
   25-Mar-2010  Tim McGuffin     Added get_claimant.
   06-Oct-2010  Tim Ward         CR#3232 - Allow Rejected (Disallowed) Advances
                                  to be Submitted Again.
								  Changed in check_writability.
   16-Mar-2011  Tim Ward         Added get_id function.
******************************************************************************/
    c_pipe   VARCHAR2(100) := Core_Util.get_config('CORE.PIPE_PREFIX') || 'OSI_cfunds_adv';

    PROCEDURE log_error(p_msg IN VARCHAR2) IS
    BEGIN
        Core_Logger.log_it(c_pipe, p_msg);
    END log_error;

    /* Given an object sid as p_obj, returns a default activity tagline */
    FUNCTION get_tagline(p_obj IN VARCHAR2)
        RETURN VARCHAR2 IS
        v_return   VARCHAR2(300);
    BEGIN
        FOR k IN (SELECT voucher_no, request_date, claimant
                    FROM T_CFUNDS_ADVANCE_V2
                   WHERE SID = p_obj)
        LOOP
            v_return :=
                'CFunds Advance: ' || k.voucher_no || ' - '
                || TO_CHAR(k.request_date, 'dd-Mon-yyyy') || ' - '
                || Osi_Personnel.get_name(k.claimant);
        END LOOP;

        RETURN v_return;
    EXCEPTION
        WHEN OTHERS THEN
            log_error('get_tagline: ' || SQLERRM);
            RETURN 'get_tagline: Error';
    END get_tagline;

    /* Will take all necessary steps to create a new instance of this type of object */
    FUNCTION create_instance(
        p_obj_type           IN   VARCHAR2,
        p_claimant           IN   VARCHAR2,
        p_requested_amount   IN   VARCHAR2,
        p_requested_unit     IN   VARCHAR2,
        p_voucher_no         IN   VARCHAR2,
        p_narrative          IN   VARCHAR2,
        p_date_of_request    IN   DATE)
        RETURN VARCHAR2 IS
        v_sid   T_CORE_OBJ.SID%TYPE;
    BEGIN
        INSERT INTO T_CORE_OBJ
                    (obj_type)
             VALUES (p_obj_type)
          RETURNING SID
               INTO v_sid;

        INSERT INTO T_CFUNDS_ADVANCE_V2
                    (SID, voucher_no, claimant, request_date, amount_requested, narrative, unit)
             VALUES (v_sid,
                     p_voucher_no,
                     p_claimant,
                     p_date_of_request,
                     p_requested_amount,
                     p_narrative,
                     p_requested_unit);

        Core_Obj.bump(v_sid);
        RETURN v_sid;
    EXCEPTION
        WHEN OTHERS THEN
            log_error('Error creating CFunds Advance. Error is: ' || SQLERRM);
            RAISE;
    END create_instance;

    FUNCTION can_delete(p_obj IN VARCHAR2)
        RETURN VARCHAR2 IS
        v_claimant          T_CORE_PERSONNEL.SID%TYPE;
        v_obj_type          T_CORE_OBJ_TYPE.SID%TYPE;
        v_status            VARCHAR2(50);
        v_parent_writable   VARCHAR2(1);
    BEGIN
        SELECT claimant,
               Cfunds_Pkg.get_advance_status(submitted_on,
                                             approved_on,
                                             rejected_on,
                                             issue_on,
                                             close_date),
               Core_Obj.lookup_objtype('CFUNDS_ADV')
          INTO v_claimant,
               v_status,
               v_obj_type
          FROM T_CFUNDS_ADVANCE_V2
         WHERE SID = p_obj;

        IF    v_claimant = Core_Context.personnel_sid
           OR Osi_Auth.check_for_priv('CF_PROXY', v_obj_type) = 'Y' THEN
            IF v_status IN('New', 'Rejected') THEN
                RETURN 'Y';
            ELSE
                RETURN 'Cannot delete unless status is New or Rejected.';
            END IF;
        ELSE
            RETURN 'You can only delete your own advance.';
        END IF;
    EXCEPTION
        WHEN OTHERS THEN
            log_error('can_delete: ' || SQLERRM);
            RAISE;
    END can_delete;

    FUNCTION check_writability(p_obj IN VARCHAR2, p_context IN VARCHAR2)
        RETURN VARCHAR2 IS
        v_claimant          T_CORE_PERSONNEL.SID%TYPE;
        v_obj_type          T_CORE_OBJ_TYPE.SID%TYPE;
        v_status            VARCHAR2(50);
        v_parent_writable   VARCHAR2(1);
    BEGIN
        SELECT claimant,
               Cfunds_Pkg.get_advance_status(submitted_on,
                                             approved_on,
                                             rejected_on,
                                             issue_on,
                                             close_date),
               Core_Obj.lookup_objtype('CFUNDS_ADV')
          INTO v_claimant,
               v_status,
               v_obj_type
          FROM T_CFUNDS_ADVANCE_V2
         WHERE SID = p_obj;

        IF (    (   v_claimant = Core_Context.personnel_sid
                 OR Osi_Auth.check_for_priv('CF_PROXY', v_obj_type) = 'Y')
            AND v_status IN('New', 'Rejected', 'Disallowed')) THEN
            RETURN 'Y';
        ELSIF     Osi_Auth.check_for_priv('APPROVE_CL', v_obj_type) = 'Y'
              AND v_status IN('Submitted', 'Rejected', 'Disallowed') THEN
            RETURN 'Y';
        END IF;

        RETURN 'N';
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            RETURN 'N';
        WHEN OTHERS THEN
            log_error('check_writability: ' || SQLERRM);
            RAISE;
    END check_writability;

    FUNCTION get_claimant(p_obj IN VARCHAR2)
        RETURN VARCHAR2 IS
        v_rtn   T_CFUNDS_ADVANCE_V2.claimant%TYPE;
    BEGIN
        SELECT claimant
          INTO v_rtn
          FROM T_CFUNDS_ADVANCE_V2
         WHERE SID = p_obj;

        RETURN v_rtn;
    EXCEPTION
        WHEN OTHERS THEN
            log_error('get_claimant: ' || SQLERRM);
            RAISE;
    END get_claimant;

    function get_id(p_obj in varchar2, p_obj_context in varchar2 := null)
        return varchar2 is
        v_id   t_cfunds_advance_v2.voucher_no%type;
    begin
        if p_obj is null then
            log_error('get_id: null value passed');
            return null;
        end if;

        select voucher_no
          into v_id
          from t_cfunds_advance_v2
         where SID = p_obj;

        return v_id;
    exception
        when no_data_found then
            return null;
        when others then
            log_error('get_id: ' || sqlerrm);
    end get_id;        

END Osi_Cfunds_Adv;
/


