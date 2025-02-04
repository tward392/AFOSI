-- "Set define off" turns off substitution variables. 
Set define off; 

CREATE OR REPLACE PACKAGE           "OSI_DOCUMENT_REVIEW" as
/******************************************************************************
   Name:     Osi_document_review
   Purpose:  Provides Functionality For Document Review Activity Objects.

   Revisions:
    Date        Author          Description
    ----------  --------------  ------------------------------------
    22-May-2009 M.Batdorf       Created this package spec. get_tagline, get_summary, index1,
                                get_status, create_instance, and clone.

******************************************************************************/

    /* Given a Document Review sid (p_obj), this function returns a default Document Review tagline.
       Currently using the default activity tagline */
    function get_tagline(p_obj in varchar2)
        return varchar2;

    /* Given a Document Review sid (p_obj), returns a summary.  Can pass a variant
       in p_variant to affect the format of the results (i.e. HTML)
       Currently using the default activity summary */
    function get_summary(p_obj in varchar2, p_variant in varchar2 := null)
        return clob;

    /* Given a Document Review sid (p_obj) and a reference to a clob, will fill in
       the clob with xml data to be used for the doc1 index
       Currently using the default activity index1 */
    procedure index1(p_obj in varchar2, p_clob in out nocopy clob);

    /* Given a Document Review sid (p_obj), will return the current status of the Document Review.
       Currently using the default activity status */
    function get_status(p_obj in varchar2)
        return varchar2;

    /* This function creates a new Document Review instance and returns the new sid */
    function create_instance(
        p_title             in   varchar2,
        p_doc_type          in   varchar2,
        p_explanation       in   varchar2,
        p_document_number   in   varchar2,
        p_rev_date          in   date,
        p_restriction       in   varchar2,
        p_narrative         in   clob)
        return varchar2;

    /* Used to clone an activity */
    procedure clone(p_obj in varchar2, p_new_sid in varchar2);
end osi_document_review;
/


CREATE OR REPLACE PACKAGE BODY           "OSI_DOCUMENT_REVIEW" as
/******************************************************************************
   Name:     Osi_document_review
   Purpose:  Provides Functionality For Document Review Activity Objects.

   Revisions:
    Date        Author          Description
    ----------  --------------  ------------------------------------
    22-May-2009 M.Batdorf       Created this package body. log_error, get_tagline, get_summary, index1,
                                get_status, create_instance, and clone.

******************************************************************************/
    c_pipe   varchar2(100) := core_util.get_config('CORE.PIPE_PREFIX') || 'OSI_DOCUMENT_REVIEW';

    procedure log_error(p_msg in varchar2) is
    begin
        core_logger.log_it(c_pipe, p_msg);
    end log_error;

    function get_tagline(p_obj in varchar2)
        return varchar2 is
    begin
        return osi_activity.get_tagline(p_obj);
    exception
        when others then
            log_error('get_tagline: p_obj = ' || nvl(p_obj, 'null') || '. Error is: ' || sqlerrm);
            return 'get_tagline: Error';
    end get_tagline;

    function get_summary(p_obj in varchar2, p_variant in varchar2 := null)
        return clob is
    begin
        return osi_activity.get_summary(p_obj, p_variant);
    exception
        when others then
            log_error('get_summary: p_obj = ' || nvl(p_obj, 'null') || ', p_variant = '
                      || nvl(p_variant, 'null') || '. Error is: ' || sqlerrm);
            return 'get_summary: Error';
    end get_summary;

    procedure index1(p_obj in varchar2, p_clob in out nocopy clob) is
    begin
        osi_activity.index1(p_obj, p_clob);
    exception
        when others then
            log_error('index1: p_obj = ' || nvl(p_obj, 'null') || '. Error is: ' || sqlerrm);
    end index1;

    function get_status(p_obj in varchar2)
        return varchar2 is
    begin
        return osi_activity.get_status(p_obj);
    exception
        when others then
            log_error('get_status: p_obj = ' || nvl(p_obj, 'null') || '. Error is: ' || sqlerrm);
            return 'get_status: Error';
    end get_status;

    function create_instance(
        p_title             in   varchar2,
        p_doc_type          in   varchar2,
        p_explanation       in   varchar2,
        p_document_number   in   varchar2,
        p_rev_date          in   date,
        p_restriction       in   varchar2,
        p_narrative         in   clob)
        return varchar2 is
        v_sid                t_core_obj.sid%type;
        v_participant_role   varchar2(20);
    begin
        v_sid :=
            osi_activity.create_instance(core_obj.lookup_objtype('ACT.DOCUMENT_REVIEW'),
--                                         null,
                                         p_rev_date,
                                         p_title,
                                         p_restriction,
                                         p_narrative);

        insert into t_osi_a_document_review
                    (sid, doc_type, explanation, document_number)
             values (v_sid, p_doc_type, p_explanation, p_document_number);

        core_obj.bump(v_sid);
        return v_sid;
    exception
        when others then
            log_error('create_instance: p_title = ' || nvl(p_title, 'null') || ', p_doc_type = '
                      || nvl(p_doc_type, 'null') || ', p_explanation = '
                      || nvl(p_explanation, 'null') || ', p_document_number = '
                      || nvl(p_document_number, 'null') || ', p_rev_date = '
                      || to_char(nvl(p_rev_date,
                                     to_date('01-JAN-1900 00:00', 'DD-MON-YYYY HH24:MI')),
                                 'DD-MON-YYYY HH24:MI')
                      || ', p_restriction = ' || nvl(p_restriction, 'null') || '. Error is: '
                      || sqlerrm);
            raise;
    end create_instance;

    /* Used to clone an activity */
    procedure clone(p_obj in varchar2, p_new_sid in varchar2) is
        v_docrev_rec   t_osi_a_document_review%rowtype;
    begin
        --Get Document Review Activity record
        select *
          into v_docrev_rec
          from t_osi_a_document_review
         where sid = p_obj;

        --Insert a new Document Review Activity record
        insert into t_osi_a_document_review
                    (sid, doc_type, explanation)
             values (p_new_sid, v_docrev_rec.doc_type, v_docrev_rec.explanation);
    exception
        when others then
            log_error('osi_document_review.clone: p_obj = ' || nvl(p_obj, 'null')
                      || ', p_new_sid = ' || nvl(p_new_sid, 'null') || '. Error is: ' || sqlerrm);
            raise;
    end clone;
end osi_document_review;
/

