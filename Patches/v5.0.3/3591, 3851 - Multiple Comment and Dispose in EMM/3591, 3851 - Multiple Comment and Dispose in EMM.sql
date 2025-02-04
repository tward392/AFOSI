-- "Set define off" turns off substitution variables. 
Set define off; 

CREATE OR REPLACE PACKAGE "OSI_EVIDENCE" as
/******************************************************************************
   Name:     Osi_Evidence
   Purpose:  Provides Functionality For Evidence Objects.

   Revisions:
    Date          Author          Description
    ------------  --------------  ------------------------------------
    26-Jun-2009   Richard Dibble  Created Package.
    30-Jun-2009   Richard Dibble  Added get_starting_status and get_last_seq_num
    06-Jul-2009   Richard Dibble  Added get_next_seq_num, get_last_address
    08-Jul-2009   Richard Dibble  Added submit_to_custodian, lookup_evid_trans_type_sid,
                                  lookup_evid_status_sid, lookup_evid_status_code
    09-Jul-2009   Richard Dibble  Added recall_from_custodian
    10-Jul-2009   Ricahrd Dibble  Added lookup_evid_status_desc
    20-Jul-2009   Richard Dibble  Added misc. optional parameters to create_instance
    27-Aug-2009   Richard Dibble  Added get_tag_number, get_status_sid
    19-Jan-2010   Tim McGuffin    Added check_writability.
    25-Jun-2010   Tim McGuffin    Added create_transaction_log, login_evidence, logout_evidence,
                                  split_tag_evidence, transfer_evidence, dispose_evidence,
                                  undispose_evidence, edit_evidence, get_last_transaction, 
                                  generate_receipt_rpt, generate_i2ms_tag_rpt, generate_orig_tag_rpt,
                                  generate_inventory_rpt
    09-Jun-2011   Tim Ward        CR#3591 - Allow Multiple Comments.
                                   Changed edit_evidence.
******************************************************************************/

    /* Given an evidence sid as p_obj, returns a default evidence tagline.
       Currently using the default activity tagline */
    function get_tagline(p_obj in varchar2)
        return varchar2;

    /* Given an evidence sid as p_obj, returns the evidence tag # */
    function get_tag_number(p_obj in varchar2)
        return varchar2;

    /* Given an evidence sid as p_obj, return a summary.  Can pass a variant
       in p_variant to affect the format of the results (i.e. HTML)
       Currently using the default activity summary */
    function get_summary(
        p_obj       in   varchar2,
        p_variant   in   varchar2 := null)
        return clob;

    /* Given an evidence sid as p_obj and a reference to a clob, will fill in
       the clob with xml data to be used for the doc1 index
       Currently using the default activity index1 */
    procedure index1(
        p_obj    in              varchar2,
        p_clob   in out nocopy   clob);

    /* Given an evidence sid as p_obj, will return the current status of the evidence
       Currently using the default activity status */
    function get_status(p_obj in varchar2)
        return varchar2;

    /* This function creates a new evidence instance and returns the new sid */
    function create_instance(
        p_obj                    in   varchar2,
        p_description            in   varchar2,
        p_obtained_by_sid        in   varchar2,
        p_obtained_date          in   date,
        p_unit_sid               in   varchar2,
        p_obtained_by_unit_sid   in   varchar2,
        p_owner                  in   varchar2 := null,
        p_rec_final_disp         in   varchar2 := null,
        p_aquisition_method      in   varchar2 := null,
        p_odso_comment           in   varchar2 := null,
        p_rfp                    in   varchar2 := null,
        p_sfp                    in   varchar2 := null)
        return varchar2;

    /* Used to clone an activity */
    procedure clone(
        p_obj       in   varchar2,
        p_new_sid   in   varchar2);

    /* Returns whether or not the input evidence object should be read-only or not. */
    function check_writability(
        p_obj       in   varchar2,
        p_context   in   varchar2)
        return varchar2;

    /* Reports the last sequence number for a given activity */
    function get_last_seq_num(p_obj in varchar2)
        return varchar2;

    /* Reports the next sequence number for a given activity */
    function get_next_seq_num(p_obj in varchar2)
        return varchar2;

    /* Returns the SID of the status type of 'New Entry ' (N) */
    function get_starting_status
        return varchar2;

    /* Returns the last used address (for defaulting when adding new objects) */
    --This is a slightly different method than in the fat client, but since we don't
    --have persistent datasets, its not really feasible to make the functionality identical
    function get_last_address(p_obj_parent in varchar2)
        return varchar2;

    /* Returns the sid of an evidence status sid when given a code */
    function lookup_evid_status_sid(p_code in varchar2)
        return varchar2;

    /* Returns an evidence status code when given a sid */
    function lookup_evid_status_code(p_sid in varchar2)
        return varchar2;

    /* Returns an evidence status description when given a sid or a code*/
    function lookup_evid_status_desc(
        p_sid_or_code   in   varchar2)
        return varchar2;

    /* Returns an evidence transaction type sid when given a code */
    function lookup_evid_trans_type_sid(p_code in varchar2)
        return varchar2;

    /* Returns an evidence status's sid when given an object SID */
    function get_status_sid(p_obj in varchar2)
        return varchar2;

    function get_id(
        p_obj       in   varchar2,
        p_context   in   varchar2)
        return varchar2;

    /* Used to submit a piece of evidence to the custodian */
    procedure submit_to_custodian(
        p_obj                in   varchar2,
        p_condition_change   in   number,
        p_effective_date     in   date,
        p_purpose            in   varchar2);

    /* Used to recall a piece of evidence from the custodian */
    procedure recall_from_custodian(
        p_obj              in   varchar2,
        p_effective_date   in   date,
        p_purpose          in   varchar2);

    /* Used by a custodian to log in a piece of evidence */
    procedure login_evidence(
        p_obj                in   varchar2,
        p_unit               in   varchar2,
        p_effective_date     in   date,
        p_purpose            in   varchar2,
        p_description        in   varchar2,
        p_condition_change   in   varchar2,
        p_storage_location   in   varchar2);

    /* Used by a custodian to log out one or more items of evidence */
    procedure logout_evidence(
        p_selected           in   varchar2,
        p_effective_date     in   date,
        p_purpose            in   varchar2,
        p_other_party        in   varchar2,
        p_condition_change   in   varchar2);

    /* Used by a custodian to split an evidence item into 2 items */
    procedure split_tag_evidence(
        p_obj                in   varchar2,
        p_effective_date     in   date,
        p_purpose            in   varchar2,
        p_description        in   varchar2,
        p_split_tag_char     in   varchar2,
        p_storage_location   in   varchar2);

    /* Used by a custodian to transfer one or more items of evidence to another unit */
    procedure transfer_evidence(
        p_selected           in   varchar2,
        p_effective_date     in   date,
        p_purpose            in   varchar2,
        p_new_unit           in   varchar2,
        p_old_unit           in   varchar2,
        p_condition_change   in   varchar2);

    /* Used by a custodian to dispose one or more items of evidence */
    procedure dispose_evidence(
        p_selected           in   varchar2,
        p_effective_date     in   date,
        p_purpose            in   varchar2,
        p_condition_change   in   varchar2);

    /* Used by a custodian to undispose an item evidence */
    procedure undispose_evidence(
        p_obj                in   varchar2,
        p_effective_date     in   date,
        p_purpose            in   varchar2,
        p_condition_change   in   varchar2);

    /* Used by a custodian to add a comment to an item of evidence */
    procedure edit_evidence(
        p_selected           in   varchar2,
        p_effective_date     in   date,
        p_purpose            in   varchar2,
        p_condition_change   in   varchar2);

    /* gets information about how an item of evidence was obtained (for reports) */
    function obtained_method(p_obj in varchar2)
        return varchar2;

    /* gets information about how an item of evidence was obtained (for reports) */
    function obtained_detail(p_obj in varchar2)
        return varchar2;

    /* gets the sid of the last transaction applied to an item of evidence */
    function get_last_transaction(p_evidence in varchar2)
        return varchar2;

    /* generates a report listing the evidence inventory for EMM  
       only p_inventory is used, but p_obj was provided since we're calling this
       from the EMM Module */
    function generate_inventory_rpt(
        p_obj         in   varchar2,
        p_inventory   in   varchar2)
        return clob;

    /* generates the i2ms version evidence tag report 
       only p_evidence is used, but p_obj was provided since we're calling this
       from the EMM Module */
    function generate_i2ms_tag_rpt(
        p_obj        in   varchar2,
        p_evidence   in   varchar2)
        return clob;

    /* generates the original evidence tag report (form 52) 
       only p_evidence is used, but p_obj was provided since we're calling this
       from the EMM Module */
    function generate_orig_tag_rpt(
        p_obj        in   varchar2,
        p_evidence   in   varchar2)
        return clob;

    /* generates the evidence receipt report from an activity (given an act sid) */
    function generate_receipt_rpt(p_sid in varchar2)
        return clob;

    /* generates the manual evidence tag */
    function generate_manual_tag_rpt(p_sid in varchar2)
        return clob;
end osi_evidence;
/


CREATE OR REPLACE package body osi_evidence as
/******************************************************************************
   Name:     Osi_Evidence
   Purpose:  Provides Functionality For Evidence Objects.

   Revisions:
    Date          Author          Description
    ------------  --------------  ------------------------------------
    26-Jun-2009   Richard Dibble  Created Package.
    30-Jun-2009   Richard Dibble  Added get_starting_status and get_last_seq_num
    06-Jul-2009   Richard Dibble  Added get_next_seq_num, get_last_address
    08-Jul-2009   Richard Dibble  Added submit_to_custodian, lookup_evid_trans_type_sid,
                                  lookup_evid_status_sid, lookup_evid_status_code
    09-Jul-2009   Richard Dibble  Added recall_from_custodian
    20-Jul-2009   Richard Dibble  Added misc. optional parameters to create_instance
    27-Aug-2009   Richard Dibble  Added get_tag_number, get_status_sid
    19-Jan-2010   Tim McGuffin    Added check_writability.
    11-Feb-2010   Tim McGuffin    Modified check_writability and get_status.
    25-Jun-2010   Tim McGuffin    Added create_transaction_log, login_evidence, logout_evidence,
                                  split_tag_evidence, transfer_evidence, dispose_evidence,
                                  undispose_evidence, edit_evidence, get_last_transaction,
                                  generate_receipt_rpt, generate_i2ms_tag_rpt, generate_orig_tag_rpt,
                                  generate_inventory_rpt
    10-Mar-2011   Carl Grunert   Modifed Otained_method and Obtained detail. Both functions had '
                                 received_from participant_sid', and 'seized_from_participant_sid' reversed.
    10-Mar-2011   Carl Grunert   Also modified 'generate-receipt_rpt'. Changed 'Token' to 'Remarks'
    10-Mar-2011   Carl Grunert   Both of the above modifications were related to  CR#  CHG0003558
    09-Jun-2011   Tim Ward       CR#3591 - Allow Multiple Comments.
                                  Changed edit_evidence.

******************************************************************************/
    c_pipe   varchar2(100)
        := core_util.get_config('CORE.PIPE_PREFIX')
           || 'OSI_Evidence';

    procedure log_error(p_msg in varchar2) is
    begin
        core_logger.log_it(c_pipe, p_msg);
    end log_error;

    function get_tagline(p_obj in varchar2)
        return varchar2 is
    begin
        return 'Evidence Tag #: ' || get_tag_number(p_obj);
    end get_tagline;

    /* Given an evidence sid as p_obj, returns the evidence tag # */
    function get_tag_number(p_obj in varchar2)
        return varchar2 is
    begin
        for k in (select oa.id, oe.seq_num,
                         oe.split_tag_char
                    from t_osi_activity oa,
                         t_osi_evidence oe
                   where oe.sid = p_obj and oa.sid = oe.obj)
        loop
            return k.id || '-' || k.seq_num
                   || k.split_tag_char;
        end loop;

        return 'XXXXX-X';
    exception
        when others then
            log_error('get_tag_number: ' || sqlerrm);
            return 'get_tag_number: Error';
    end get_tag_number;

    function get_summary(
        p_obj       in   varchar2,
        p_variant   in   varchar2 := null)
        return clob is
    begin
        return 'Evidence Summary Here (Modify OSI_EVIDENCE.get_summary)';
    exception
        when others then
            log_error('get_summary: ' || sqlerrm);
            return 'get_summary: Error';
    end get_summary;

    procedure index1(
        p_obj    in              varchar2,
        p_clob   in out nocopy   clob) is
        v_temp   number;
    begin
        v_temp := 1;
    --Do Indexing here, (not even sure if evidence gets indexed.)
    exception
        when others then
            log_error('index1: ' || sqlerrm);
    end index1;

    function get_status(p_obj in varchar2)
        return varchar2 is
        v_status   t_osi_reference.description%type;
    begin
        return lookup_evid_status_desc
                                     (get_status_sid(p_obj));
    exception
        when others then
            log_error('get_status: ' || sqlerrm);
            return 'get_status: Error';
    end get_status;

    function create_instance(
        p_obj                    in   varchar2,
        p_description            in   varchar2,
        p_obtained_by_sid        in   varchar2,
        p_obtained_date          in   date,
        p_unit_sid               in   varchar2,
        p_obtained_by_unit_sid   in   varchar2,
        p_owner                  in   varchar2 := null,
        p_rec_final_disp         in   varchar2 := null,
        p_aquisition_method      in   varchar2 := null,
        p_odso_comment           in   varchar2 := null,
        p_rfp                    in   varchar2 := null,
        p_sfp                    in   varchar2 := null)
        return varchar2 is
        v_sid            t_core_obj.sid%type;
        v_next_seq_num   number;
    begin
        insert into t_core_obj
                    (obj_type)
             values (core_obj.lookup_objtype('EVIDENCE'))
          returning sid
               into v_sid;

        --Set the starting status
        --osi_status.change_status_brute(v_sid, osi_status.get_starting_status(p_obj_type), 'Created');
        core_obj.bump(v_sid);
        --Get next sequence number
        v_next_seq_num := get_next_seq_num(p_obj);

        if (   v_next_seq_num is null
            or v_next_seq_num < 1) then
            v_next_seq_num := 1;
        end if;

        insert into t_osi_evidence
                    (sid,
                     seq_num,
                     description,
                     obtained_by_sid,
                     obtained_date,
                     unit_sid,
                     status_sid,
                     obtained_by_unit_sid,
                     obj,
                     owner_sid,
                     final_disp,
                     acquisition_method,
                     odso_comment,
                     received_from_participant_sid,
                     seized_from_participant_sid)
             values (v_sid,
                     v_next_seq_num,
                     p_description,
                     p_obtained_by_sid,
                     p_obtained_date,
                     p_unit_sid,
                     get_starting_status,
                     p_obtained_by_unit_sid,
                     p_obj,
                     p_owner,
                     p_rec_final_disp,
                     p_aquisition_method,
                     p_odso_comment,
                     p_rfp,
                     p_sfp);

        core_obj.bump(v_sid);
        return v_sid;
    exception
        when others then
            log_error('create_instance: ' || sqlerrm);
            raise;
    end create_instance;

    /* Used to clone an activity */
    procedure clone(p_obj in varchar2, p_new_sid in varchar2) is
        v_osi_evidence_record   t_osi_evidence%rowtype;
    begin
        --Get Evidence Activity record
        select *
          into v_osi_evidence_record
          from t_osi_evidence
         where sid = p_obj;
--Not sure if we need this here. (Clone, that is)
/*
        --Insert a new Evidence Activity record
        insert into t_osi_a_Evidence
                    (sid, advisement, dd2701)
             values (p_new_sid, v_osi_a_Evidence_record.advisement,
                     v_osi_a_Evidence_record.dd2701);
*/
    exception
        when others then
            log_error('osi_Evidence.clone: ' || sqlerrm);
            raise;
    end clone;

    /* Reports the last sequence number for a given activity */
    function get_last_seq_num(p_obj in varchar2)
        return varchar2 is
        v_return   number;
    begin
        select max(seq_num)
          into v_return
          from t_osi_evidence
         where obj = p_obj;

        return v_return;
    exception
        when no_data_found then
            return 0;
        when others then
            log_error('osi_Evidence.get_last_seq_num: '
                      || sqlerrm);
            raise;
    end get_last_seq_num;

    /* Reports the next sequence number for a given activity */
    function get_next_seq_num(p_obj in varchar2)
        return varchar2 is
    begin
        return to_char(get_last_seq_num(p_obj) + 1);
    exception
        when others then
            log_error('osi_Evidence.get_next_seq_num: '
                      || sqlerrm);
            raise;
    end get_next_seq_num;

    /* Returns the SID of the status type of 'New Entry ' (N) */
    function get_starting_status
        return varchar2 is
        v_return   t_osi_reference.sid%type;
    begin
        select sid
          into v_return
          from t_osi_reference
         where usage = 'EVIDENCE_STATUS_TYPE' and code = 'N';

        return v_return;
    exception
        when others then
            log_error
                   ('osi_Evidence.get_starting_status: '
                    || sqlerrm);
            raise;
    end get_starting_status;

    /* Returns the last used address (for defaulting when adding new objects) */
    function get_last_address(p_obj_parent in varchar2)
        return varchar2 is
    begin
        for k in (select   oa.sid as address_sid
                      from t_osi_address oa,
                           t_osi_evidence oe
                     where oa.obj = oe.sid
                       and oe.obj = p_obj_parent
                  order by oa.modify_on desc)
        loop
            if (k.address_sid is not null) then
                dbms_output.put_line('Trying address:['
                                     || k.address_sid || ']');
                --Now we have the address SID, need to get the address
                return osi_address.get_addr_fields
                                              (k.address_sid);
            end if;
        end loop;

        --If nothing, then return nothing
        return null;
    exception
        when others then
            log_error('osi_Evidence.get_last_address: '
                      || sqlerrm);
            raise;
    end get_last_address;

    /* Returns an evidence transaction type sid when given a code */
    function lookup_evid_trans_type_sid(p_code in varchar2)
        return varchar2 is
        v_return   t_osi_reference.sid%type;
    begin
        select sid
          into v_return
          from t_osi_reference
         where code = p_code
           and usage = 'EVIDENCE_TRANS_TYPE';

        return v_return;
    exception
        when no_data_found then
            return null;
        when others then
            log_error
                ('osi_Evidence.lookup_evid_trans_type_sid: '
                 || sqlerrm);
            raise;
    end lookup_evid_trans_type_sid;

    /* Returns an evidence status's sid when given an object SID */
    function get_status_sid(p_obj in varchar2)
        return varchar2 is
        v_return   t_osi_evidence.status_sid%type;
    begin
        select status_sid
          into v_return
          from t_osi_evidence
         where sid = p_obj;

        return v_return;
    exception
        when no_data_found then
            return null;
        when others then
            log_error('osi_Evidence.get_status_sid: '
                      || sqlerrm);
            raise;
    end get_status_sid;

    /* Returns an evidence status code when given a sid */
    function lookup_evid_status_code(p_sid in varchar2)
        return varchar2 is
        v_return   t_osi_reference.code%type;
    begin
        select code
          into v_return
          from t_osi_reference
         where sid = p_sid
               and usage = 'EVIDENCE_STATUS_TYPE';

        return v_return;
    exception
        when no_data_found then
            return null;
        when others then
            log_error
                ('osi_Evidence.lookup_evid_status_code: '
                 || sqlerrm);
            raise;
    end lookup_evid_status_code;

    /* Returns the sid of an evidence status sid when given a code */
    function lookup_evid_status_sid(p_code in varchar2)
        return varchar2 is
        v_return   t_osi_reference.sid%type;
    begin
        select sid
          into v_return
          from t_osi_reference
         where code = p_code
           and usage = 'EVIDENCE_STATUS_TYPE';

        return v_return;
    exception
        when no_data_found then
            return null;
        when others then
            log_error
                ('osi_Evidence.lookup_evid_status_sid: '
                 || sqlerrm);
            raise;
    end lookup_evid_status_sid;

    /* Returns an evidence status description when given a sid or a code*/
    function lookup_evid_status_desc(
        p_sid_or_code   in   varchar2)
        return varchar2 is
        v_return   t_osi_reference.description%type;
    begin
        select description
          into v_return
          from t_osi_reference
         where (   code = p_sid_or_code
                or sid = p_sid_or_code)
           and usage = 'EVIDENCE_STATUS_TYPE';

        return v_return;
    exception
        when no_data_found then
            return null;
        when others then
            log_error
                ('osi_Evidence.lookup_evid_status_desc: '
                 || sqlerrm);
            raise;
    end lookup_evid_status_desc;

    function get_id(p_obj in varchar2, p_context in varchar2)
        return varchar2 is
    begin
        return 'STATUS: '
               || lookup_evid_status_desc
                                     (get_status_sid(p_obj));
    exception
        when others then
            log_error('get_id: ' || sqlerrm);
    end get_id;

    procedure create_transaction_log(
        p_evidence           in   varchar2,
        p_trans_type         in   varchar2,
        p_effective_date     in   date,
        p_purpose            in   varchar2,
        p_condition_change   in   varchar2 := null,
        p_other_party        in   varchar2 := null) is
    begin
        insert into t_osi_evidence_trans_log
                    (evidence_sid,
                     tran_type_sid,
                     effective_date,
                     purpose,
                     condition_change,
                     other_party,
                     custodian_sid)
             values (p_evidence,
                     lookup_evid_trans_type_sid
                                               (p_trans_type),
                     p_effective_date,
                     p_purpose,
                     nvl(p_condition_change, 'N'),
                     p_other_party,
                     core_context.personnel_sid);
    exception
        when others then
            log_error
                ('osi_evidence.create_transaction_log: '
                 || sqlerrm);
            raise;
    end create_transaction_log;

    /* Used to submit a piece of evidence to the custodian */
    procedure submit_to_custodian(
        p_obj                in   varchar2,
        p_condition_change   in   number,
        p_effective_date     in   date,
        p_purpose            in   varchar2) is
    begin
        create_transaction_log(p_obj,
                               'SUBMIT',
                               p_effective_date,
                               p_purpose);

        --Change status to S in T_OSI_EVIDENCE
        update t_osi_evidence
           set status_sid =
                    osi_evidence.lookup_evid_status_sid('S')
         where sid = p_obj;
    exception
        when others then
            log_error
                   ('osi_Evidence.submit_to_custodian: '
                    || sqlerrm);
            raise;
    end submit_to_custodian;

    /* Used to recall a piece of evidence from the custodian */
    procedure recall_from_custodian(
        p_obj              in   varchar2,
        p_effective_date   in   date,
        p_purpose          in   varchar2) is
    begin
        create_transaction_log(p_obj,
                               'RECALL',
                               p_effective_date,
                               p_purpose);

        --Change status to S in T_OSI_EVIDENCE
        update t_osi_evidence
           set status_sid =
                    osi_evidence.lookup_evid_status_sid('N')
         where sid = p_obj;
    exception
        when others then
            log_error
                 ('osi_Evidence.recall_from_custodian: '
                  || sqlerrm);
            raise;
    end recall_from_custodian;

    procedure login_evidence(
        p_obj                in   varchar2,
        p_unit               in   varchar2,
        p_effective_date     in   date,
        p_purpose            in   varchar2,
        p_description        in   varchar2,
        p_condition_change   in   varchar2,
        p_storage_location   in   varchar2) is
    begin
        create_transaction_log(p_obj,
                               'LOGIN',
                               p_effective_date,
                               p_purpose,
                               p_condition_change);

        update t_osi_evidence
           set status_sid =
                    osi_evidence.lookup_evid_status_sid('C'),
               description = p_description,
               storage_location =
                   nvl(p_storage_location, storage_location),
               transferred_from_unit_sid = null,
               unit_sid = p_unit
         where sid = p_obj;
    exception
        when others then
            log_error('osi_evidence.login_evidence: '
                      || sqlerrm);
            raise;
    end login_evidence;

    procedure logout_evidence(
        p_selected           in   varchar2,
        p_effective_date     in   date,
        p_purpose            in   varchar2,
        p_other_party        in   varchar2,
        p_condition_change   in   varchar2) is
    begin
        for i in
            1 .. core_list.count_list_elements(p_selected)
        loop
            create_transaction_log
                  (core_list.get_list_element(p_selected, i),
                   'LOGOUT',
                   p_effective_date,
                   p_purpose,
                   p_condition_change,
                   p_other_party);

            update t_osi_evidence
               set status_sid =
                       osi_evidence.lookup_evid_status_sid
                                                        ('T')
             where sid =
                       core_list.get_list_element
                                                (p_selected,
                                                 i);
        end loop;
    exception
        when others then
            log_error('osi_evidence.logout_evidence: '
                      || sqlerrm);
            raise;
    end logout_evidence;

    procedure split_tag_evidence(
        p_obj                in   varchar2,
        p_effective_date     in   date,
        p_purpose            in   varchar2,
        p_description        in   varchar2,
        p_split_tag_char     in   varchar2,
        p_storage_location   in   varchar2) is
        v_sid   t_core_obj.sid%type;
    begin
        insert into t_core_obj
                    (obj_type)
             values (core_obj.lookup_objtype('EVIDENCE'))
          returning sid
               into v_sid;

        insert into t_osi_evidence
                    (sid,
                     obj,
                     description,
                     obtained_by_sid,
                     seq_num,
                     status_sid,
                     unit_sid,
                     appellate_review,
                     congress_review,
                     identify_as,
                     obtained_by_unit_sid,
                     obtained_date,
                     odso_comment,
                     split_tag_char,
                     storage_location)
            select v_sid, obj, p_description,
                   obtained_by_sid, seq_num, status_sid,
                   unit_sid, appellate_review,
                   congress_review, identify_as,
                   obtained_by_unit_sid, obtained_date,
                   odso_comment, p_split_tag_char,
                   p_storage_location
              from t_osi_evidence
             where sid = p_obj;

        insert into t_osi_address
                    (obj,
                     address_type,
                     address_1,
                     address_2,
                     city,
                     province,
                     state,
                     postal_code,
                     country,
                     geo_coords,
                     start_date,
                     end_date,
                     known_date,
                     comments)
            select v_sid, address_type, address_1,
                   address_2, city, province, state,
                   postal_code, country, geo_coords,
                   start_date, end_date, known_date,
                   comments
              from t_osi_address
             where obj = p_obj;

        create_transaction_log(v_sid,
                               'LOGIN',
                               p_effective_date,
                               p_purpose);
        create_transaction_log(p_obj,
                               'SPLIT',
                               p_effective_date,
                               p_purpose,
                               'Y');
    exception
        when others then
            log_error
                    ('osi_evidence.split_tag_evidence: '
                     || sqlerrm);
            raise;
    end split_tag_evidence;

    procedure transfer_evidence(
        p_selected           in   varchar2,
        p_effective_date     in   date,
        p_purpose            in   varchar2,
        p_new_unit           in   varchar2,
        p_old_unit           in   varchar2,
        p_condition_change   in   varchar2) is
    begin
        for i in
            1 .. core_list.count_list_elements(p_selected)
        loop
            create_transaction_log
                  (core_list.get_list_element(p_selected, i),
                   'TRANSFER',
                   p_effective_date,
                   p_purpose,
                   p_condition_change);

            update t_osi_evidence
               set status_sid =
                       osi_evidence.lookup_evid_status_sid
                                                        ('X'),
                   unit_sid = p_new_unit,
                   transferred_from_unit_sid = p_old_unit,
                   storage_location = null
             where sid =
                       core_list.get_list_element
                                                (p_selected,
                                                 i);
        end loop;
    exception
        when others then
            log_error
                     ('osi_evidence.transfer_evidence: '
                      || sqlerrm);
            raise;
    end transfer_evidence;

    procedure dispose_evidence(
        p_selected           in   varchar2,
        p_effective_date     in   date,
        p_purpose            in   varchar2,
        p_condition_change   in   varchar2) is
    begin
        for i in
            1 .. core_list.count_list_elements(p_selected)
        loop
            create_transaction_log
                  (core_list.get_list_element(p_selected, i),
                   'DISPOSE',
                   p_effective_date,
                   p_purpose,
                   p_condition_change);

            update t_osi_evidence
               set status_sid =
                       osi_evidence.lookup_evid_status_sid
                                                        ('D')
             where sid =
                       core_list.get_list_element
                                                (p_selected,
                                                 i);
        end loop;
    exception
        when others then
            log_error('osi_evidence.dispose_evidence: '
                      || sqlerrm);
            raise;
    end dispose_evidence;

    procedure undispose_evidence(
        p_obj                in   varchar2,
        p_effective_date     in   date,
        p_purpose            in   varchar2,
        p_condition_change   in   varchar2) is
    begin
        create_transaction_log(p_obj,
                               'UNDISPOSE',
                               p_effective_date,
                               p_purpose,
                               p_condition_change);

        update t_osi_evidence
           set status_sid =
                    osi_evidence.lookup_evid_status_sid('C')
         where sid = p_obj;
    exception
        when others then
            log_error
                    ('osi_evidence.undispose_evidence: '
                     || sqlerrm);
            raise;
    end undispose_evidence;

    procedure edit_evidence(
        p_selected           in   varchar2,
        p_effective_date     in   date,
        p_purpose            in   varchar2,
        p_condition_change   in   varchar2) is
    begin
        for i in
            1 .. core_list.count_list_elements(p_selected)
        loop
            create_transaction_log(core_list.get_list_element(p_selected, i),
                                   'COMMENT',
                                   p_effective_date,
                                   p_purpose,
                                   p_condition_change);
        end loop;
    exception
        when others then
            log_error
                    ('osi_evidence.undispose_evidence: '
                     || sqlerrm);
            raise;
    end edit_evidence;

/*
    procedure custodian_change(
        p_obj           in   varchar2) is
    begin
        for i in (select
                    from t_osi_evidence e,
                         t_osi_reference s
                   where e.status_sid = s.sid
                     and s.code = 'C'
                     and e.sid = p_obj
                     and exists (select 1
                                   from t_osi_evidence_inventory i,
                                        t_osi_reference ir
                                  where i.unit_sid = e.unit_sid
                                    and i.inventory_reason_sid = ir.sid
                                    and ir.code in ('ACC','PCC')
                                    and (i.end_date is null or sysdate-7 <= i.end_date))) loop
            create_transaction_log( p_obj, 'LOGOUT', sysdate, 'Logging Out for Custodian Change.','N',
                                    osi_personnel.get_name(core_context.personnel_sid), );

          INSERT INTO T_EVIDENCE_TRANSACTION_LOG
            (SID,EVIDENCE,TRAN_TYPE,CONDITION_CHANGE,CUSTODIAN, OTHER_PARTY, PURPOSE)
          SELECT 'GETONE',TE.SID,'XOUT',0,
                   DECODE(TI.OUTGOING_CUSTODIAN,NULL,mConnection.UserSID,TI.OUTGOING_CUSTODIAN),
                   mConnection.PersonnelName,
                   DECODE(INV_REASON, Me.cPrimaryCustodianChange, 'Logging Out for Primary Custodian Change.',Me.cAlternateCustodianChange,'Logging Out for Alternate Custodian Change.')
           FROM T_EVIDENCE_V2 TE,
                T_EVIDENCE_INVENTORY TI
          WHERE TE.UNIT=TI.UNIT
            AND INV_REASON IN ('ACC','PCC')
            AND (END_DATE IS NULL OR SYSDATE-7 <= END_DATE)
            AND STATUS='C'
            AND TE.UNIT='" & Me.EvidenceUnit & "'
            AND TI.SID='" & Me.InventoryListSID & "'"

  ' Log In Evidence Second '
  INSERT INTO T_EVIDENCE_TRANSACTION_LOG
    (SID,EVIDENCE,TRAN_TYPE,CONDITION_CHANGE,CUSTODIAN,EFFECTIVE_DATE,
          OTHER_PARTY, PURPOSE)"
  SELECT 'GETONE',TE.SID,'XIN',0,mConnection.UserSID,dEffectiveDate,
          '', DECODE(INV_REASON,Me.cPrimaryCustodianChange,'Logging In for Primary Custodian Change.',Me.cAlternateCustodianChange,'Logging In for Alternate Custodian Change.')
    FROM T_EVIDENCE_V2 TE,T_EVIDENCE_INVENTORY TI
   WHERE TE.UNIT=TI.UNIT
     AND INV_REASON IN ('ACC','PCC')
     AND (END_DATE IS NULL OR SYSDATE-7 <= END_DATE)
     AND STATUS='C'
     AND TE.UNIT='" & Me.EvidenceUnit & "'
     AND TI.SID='" & Me.InventoryListSID & "'"

  UPDATE T_EVIDENCE_V2
     SET TRANSFERRED_FROM_UNIT=Null,
         UNIT='" & mOwningUnitSID & "'
   WHERE SID IN (SELECT TE.SID
                  FROM T_EVIDENCE_V2 TE,
                       T_EVIDENCE_INVENTORY TI
                 WHERE TE.UNIT=TI.UNIT
                   AND INV_REASON IN ('ACC','PCC')
                   AND (END_DATE IS NULL OR SYSDATE-7 <= END_DATE)
                   AND STATUS='C'
                   AND TE.UNIT='" & Me.EvidenceUnit & "'
                   AND TI.SID='" & Me.InventoryListSID & "')"

        end loop;
    exception
        when others then
            log_error('osi_evidence.custodian_change: ' || sqlerrm);
            raise;
    end custodian_change;
*/
    function check_writability(
        p_obj       in   varchar2,
        p_context   in   varchar2)
        return varchar2 is
        v_parent   t_core_obj.sid%type;
    begin
        if lookup_evid_status_code(get_status_sid(p_obj)) =
                                                        'N' then
            select obj
              into v_parent
              from t_osi_evidence
             where sid = p_obj;

            return osi_object.check_writability(v_parent,
                                                null);
        else
            return 'N';
        end if;
    exception
        when others then
            log_error('check_writability: ' || sqlerrm);
            raise;
    end check_writability;

    function get_last_transaction(p_evidence in varchar2)
        return varchar2 is
    begin
        for i in (select   l.sid
                      from t_osi_evidence_trans_log l,
                           t_osi_reference t
                     where t.sid = l.tran_type_sid
                       and l.evidence_sid = p_evidence
                       and t.code <> 'COM'
                  order by trunc(l.effective_date) desc,
                           l.sid desc)
        loop
            return(i.sid);       -- only need the first one
        end loop;

        return null;               -- in case there are none
    end get_last_transaction;

    function obtained_method(p_obj in varchar2)
        return varchar2 is
        v_result     varchar2(1000);
        v_id_as      t_osi_evidence.identify_as%type;
        v_odso_cmt   t_osi_evidence.odso_comment%type;
        v_rec_frm    t_osi_evidence.received_from_participant_sid%type;
        v_sez_frm    t_osi_evidence.seized_from_participant_sid%type;
    begin
        v_result := 'Received from:';

        select identify_as, odso_comment,
               received_from_participant_sid,
               seized_from_participant_sid
          into v_id_as, v_odso_cmt,
               v_rec_frm,
               v_sez_frm
          from t_osi_evidence e
         where e.sid = p_obj;

        if v_id_as is not null then
            return 'Received from:';
        end if;

        if v_odso_cmt is not null then
            return 'Obtained during search of:';
        end if;

        if v_rec_frm is not null then
            return 'Received from:';
        end if;

        if v_sez_frm is not null then
            return 'Seized from:';
        end if;

        return null;
    exception
        when no_data_found then
            return null;
        when others then
            log_error('obtained_method: ' || sqlerrm);
            raise;
    end obtained_method;

    function obtained_detail(p_obj in varchar2)
        return varchar2 is
        v_id_as      t_osi_evidence.identify_as%type;
        v_odso_cmt   t_osi_evidence.odso_comment%type;
        v_rec_frm    t_osi_evidence.received_from_participant_sid%type;
        v_sez_frm    t_osi_evidence.seized_from_participant_sid%type;
    begin
        select identify_as, odso_comment,
               received_from_participant_sid,
               seized_from_participant_sid
          into v_id_as, v_odso_cmt,
               v_rec_frm,
               v_sez_frm
          from t_osi_evidence e
         where e.sid = p_obj;

        if v_id_as is not null then
            return v_id_as;
        end if;

        if v_odso_cmt is not null then
            return v_odso_cmt;
        end if;

        if v_rec_frm is not null then
            return osi_participant.get_name(v_rec_frm);
        end if;

        if v_sez_frm is not null then
            return osi_participant.get_name(v_sez_frm);
        end if;

        return 'Received from:';
    exception
        when no_data_found then
            return null;
        when others then
            log_error('obtained_detail: ' || sqlerrm);
            raise;
    end obtained_detail;

    ------------------------
--- Evidence Reports ---
------------------------
    function generate_inventory_rpt(
        p_obj         in   varchar2,
        p_inventory   in   varchar2)
        return clob is
        v_ok                     varchar2(100);
        v_parent_sid             t_osi_evidence.sid%type;
        v_template               clob;
        v_template_date          date;
        v_mime_type              t_core_template.mime_type%type;
        v_mime_disposition       t_core_template.mime_disposition%type;
        htmlorrtf                varchar2(4)       := 'RTF';
        v_unit_sid               varchar2(20);
        v_unit_name              varchar2(400);
        v_last_associated_file   varchar2(500)
            := '!@#$!@#$!#$!#$!@$!@#$!@$#!#$!@#$FIRTONE!@#$!@#$!#$!#$!@$!@#$!@$#!#$!@#$';
        v_start_date             varchar2(15);
        v_end_date               varchar2(15);
        v_tempstring             varchar2(32000);
        v_tempstring2            clob;
    begin
        v_parent_sid := p_inventory;
        v_ok :=
            core_template.get_latest('EVIDENCE_INVENTORY',
                                     v_template,
                                     v_template_date,
                                     v_mime_type,
                                     v_mime_disposition);

        begin
            select unit_sid,
                   to_char(start_date, 'DD-Mon-YYYY'),
                   to_char(end_date, 'DD-Mon-YYYY')
              into v_unit_sid,
                   v_start_date,
                   v_end_date
              from t_osi_evidence_inventory
             where sid = v_parent_sid;
        exception
            when no_data_found then
                null;
        end;

        v_unit_name := osi_unit.get_name(v_unit_sid);
        --- 1st Page Header Information ---
        v_ok :=
            core_template.replace_tag
                (v_template,
                 'UNIT',
                 osi_report.replace_special_chars
                                               (v_unit_name,
                                                htmlorrtf));
        v_ok :=
            core_template.replace_tag
                (v_template,
                 'STARTDATE',
                 osi_report.replace_special_chars
                                              (v_start_date,
                                               htmlorrtf));

        if    v_end_date = ''
           or v_end_date is null then
            v_ok :=
                core_template.replace_tag(v_template,
                                          'COMPLETEDATE',
                                          '\tab\tab');
        else
            v_ok :=
                core_template.replace_tag
                    (v_template,
                     'COMPLETEDATE',
                     osi_report.replace_special_chars
                                                (v_end_date,
                                                 htmlorrtf));
        end if;

        --- Get Parts we can get from the Main Tables ---
        for a in (select   *
                      from v_osi_rpt_emm_inventory
                     where unit_sid = v_unit_sid
                  order by assoc_file_info,
                           activity_id,
                           seq_num,
                           split_tag_char,
                           description,
                           storage_location)
        loop
            if v_last_associated_file <> a.assoc_file_info then
                v_last_associated_file := a.assoc_file_info;
                v_tempstring :=
                    v_tempstring
                    || '\fs16\trowd\trgaph108\trleft-108\trpaddl108\trpaddr108\trpaddfl3\trpaddfr3\clbrdrt\brdrw20\brdrs\clbrdrb\brdrw20\brdrs \cellx15358\pard\intbl\f1\cell\row\trowd\trgaph108\trleft-108\trpaddl108\trpaddr108\trpaddfl3\trpaddfr3\clbrdrt\brdrw20\brdrs \cellx15358\pard\intbl\b\fs20 ASSOCIATED FILE:  '
                    || osi_report.replace_special_chars
                                        (a.assoc_file_info,
                                         htmlorrtf)
                    || ' \cell\row\pard\b0\f0\fs2\par';
            end if;

            v_tempstring :=
                v_tempstring
                || '\trowd\trgaph108\trleft-108\trpaddl108\trpaddr108\trpaddfl3\trpaddfr3'
                || '\clbrdrt\brdrw20\brdrs \cellx1680\clbrdrt\brdrw20\brdrs \cellx3000\clbrdrt\brdrw20\brdrs \cellx5880\clbrdrt\brdrw20\brdrs \cellx9000\clbrdrt\brdrw20\brdrs \cellx12720\clbrdrt\brdrw20\brdrs \cellx15358\pard\intbl\b\f1\fs20 Tag Number\cell Date Rec\rquote d\cell Obtained By/From\cell Description\cell Last Change of Custody Information\cell Location                     \f2\fs24 o\f0\fs16\par'
                || '\cell\row\trowd\trgaph108\trleft-108\trpaddl108\trpaddr108\trpaddfl3\trpaddfr3'
                || '\clvmgf\cellx1680\clvmgf\cellx3000\cellx5880\clvmgf\cellx9000\cellx12720\cellx15358\pard\intbl\b0\f0 '
                || a.tag_number || '\cell '
                || to_char(a.obtained_date, 'DD-Mon-YYYY')
                || '\cell ' || a.obtained_by || '\cell '
                || a.description || '\cell '
                || to_char(a.last_tran_eff_date,
                           'DD-Mon-YYYY')
                || '  ' || a.last_tran_custodian || '\cell '
                || a.storage_location || '\par'
                || '\cell\row\trowd\trgaph108\trleft-108\trpaddl108\trpaddr108\trpaddfl3\trpaddfr3'
                || '\clvmrg\cellx1680\clvmrg\cellx3000\cellx5880\clvmrg\cellx9000\cellx12720\cellx15358\pard\intbl\cell\cell '
                || a.obtained_at || '\cell\cell '
                || a.last_tran_purpose || '\cell '
                || a.status_desc || '\cell\row\pard\fs2\par'
                || '\fs16';
            v_tempstring2 := v_tempstring2 || v_tempstring;
            v_tempstring := null;
        end loop;

        v_tempstring2 :=
            v_tempstring2 || '\page\par' || chr(13)
            || chr(10);
        v_tempstring2 :=
            v_tempstring2
            || '\viewkind1\uc1\trowd\trgaph108\trleft-108\trkeep\trkeepfollow\trbrdrt\brdrs\brdrw30 \trbrdrb\brdrs\brdrw30 \trpaddl108\trpaddr108\trpaddfl3\trpaddfr3'
            || chr(13) || chr(10);
        v_tempstring2 :=
            v_tempstring2
            || '\clbrdrt\brdrw30\brdrs \cellx15361\pard\intbl\b\f0\fs16\cell\row\trowd\trgaph108\trleft-108\trkeep\trkeepfollow\trbrdrt\brdrs\brdrw30 \trbrdrb\brdrs\brdrw30 \trpaddl108\trpaddr108\trpaddfl3\trpaddfr3'
            || chr(13) || chr(10);
        v_tempstring2 :=
            v_tempstring2
            || '\cellx15361\pard\intbl\qc\fs24 We hereby certify that in accordance with AFOSII 71-106, an accurate and complete inventory of all evidence was conducted and any and all discrepancies were documented as required.\cell\row\trowd\trgaph108\trleft-108\trkeep\trkeepfollow\trbrdrt\brdrs\brdrw30 \trbrdrb\brdrs\brdrw30 \trpaddl108\trpaddr108\trpaddfl3\trpaddfr3'
            || chr(13) || chr(10);
        v_tempstring2 :=
            v_tempstring2
            || '\cellx3757\cellx7621\cellx11491\cellx15361\pard\intbl\b0\par'
            || chr(13) || chr(10);
        v_tempstring2 :=
                v_tempstring2 || '\par' || chr(13)
                || chr(10);
        v_tempstring2 :=
                v_tempstring2 || '\par' || chr(13)
                || chr(10);
        v_tempstring2 :=
            v_tempstring2
            || '______________________________\cell\par'
            || chr(13) || chr(10);
        v_tempstring2 :=
                v_tempstring2 || '\par' || chr(13)
                || chr(10);
        v_tempstring2 :=
                v_tempstring2 || '\par' || chr(13)
                || chr(10);
        v_tempstring2 :=
            v_tempstring2
            || '______________________________\cell\par'
            || chr(13) || chr(10);
        v_tempstring2 :=
                v_tempstring2 || '\par' || chr(13)
                || chr(10);
        v_tempstring2 :=
                v_tempstring2 || '\par' || chr(13)
                || chr(10);
        v_tempstring2 :=
            v_tempstring2
            || '______________________________\cell\par'
            || chr(13) || chr(10);
        v_tempstring2 :=
                v_tempstring2 || '\par' || chr(13)
                || chr(10);
        v_tempstring2 :=
                v_tempstring2 || '\par' || chr(13)
                || chr(10);
        v_tempstring2 :=
            v_tempstring2
            || '______________________________\cell\row\trowd\trgaph108\trleft-108\trkeep\trkeepfollow\trbrdrt\brdrs\brdrw30 \trbrdrb\brdrs\brdrw30 \trpaddl108\trpaddr108\trpaddfl3\trpaddfr3'
            || chr(13) || chr(10);
        v_tempstring2 :=
            v_tempstring2
            || '\cellx3757\cellx7621\cellx11491\cellx15361\pard\intbl\qc\i\fs20 (Signature)\cell (Signature)\i0\fs24\cell\i\fs20 (Signature)\i0\fs24\cell\i\fs20 (Signature)\i0\fs24\cell\row\trowd\trgaph108\trleft-108\trkeep\trkeepfollow\trbrdrt\brdrs\brdrw30 \trbrdrb\brdrs\brdrw30 \trpaddl108\trpaddr108\trpaddfl3\trpaddfr3'
            || chr(13) || chr(10);
        v_tempstring2 :=
            v_tempstring2
            || '\cellx3757\cellx7621\cellx11491\cellx15361\pard\intbl\par'
            || chr(13) || chr(10);
        v_tempstring2 :=
                v_tempstring2 || '\par' || chr(13)
                || chr(10);
        v_tempstring2 :=
                v_tempstring2 || '\par' || chr(13)
                || chr(10);
        v_tempstring2 :=
            v_tempstring2
            || '______________________________\cell\par'
            || chr(13) || chr(10);
        v_tempstring2 :=
                v_tempstring2 || '\par' || chr(13)
                || chr(10);
        v_tempstring2 :=
                v_tempstring2 || '\par' || chr(13)
                || chr(10);
        v_tempstring2 :=
            v_tempstring2
            || '______________________________\cell\par'
            || chr(13) || chr(10);
        v_tempstring2 :=
                v_tempstring2 || '\par' || chr(13)
                || chr(10);
        v_tempstring2 :=
                v_tempstring2 || '\par' || chr(13)
                || chr(10);
        v_tempstring2 :=
            v_tempstring2
            || '______________________________\cell\par'
            || chr(13) || chr(10);
        v_tempstring2 :=
                v_tempstring2 || '\par' || chr(13)
                || chr(10);
        v_tempstring2 :=
                v_tempstring2 || '\par' || chr(13)
                || chr(10);
        v_tempstring2 :=
            v_tempstring2
            || '______________________________\cell\row\trowd\trgaph108\trleft-108\trkeep\trkeepfollow\trbrdrt\brdrs\brdrw30 \trbrdrb\brdrs\brdrw30 \trpaddl108\trpaddr108\trpaddfl3\trpaddfr3'
            || chr(13) || chr(10);
        v_tempstring2 :=
            v_tempstring2
            || '\clbrdrb\brdrw30\brdrs \cellx3757\clbrdrb\brdrw30\brdrs \cellx7621\clbrdrb\brdrw30\brdrs \cellx11491\clbrdrb\brdrw30\brdrs \cellx15361\pard\intbl\qc\i\fs20 (Name, Rank)\i0\fs24\cell\i\fs20 (Name, Rank)\i0\fs24\cell\i\fs20 (Name, Rank)\i0\fs24\cell\i\fs20 (Name, Rank)\par'
            || chr(13) || chr(10);
        v_tempstring2 :=
                v_tempstring2 || '\par' || chr(13)
                || chr(10);
        v_tempstring2 :=
            v_tempstring2 || '\i0\fs24\cell\row\pard\qj\par'
            || chr(13) || chr(10);
        v_ok :=
            core_template.replace_tag(v_template,
                                      'LISTING',
                                      v_tempstring2);
        return v_template;
        core_util.cleanup_temp_clob(v_template);
    exception
        when others then
            log_error('generate_inventory_rpt:' || sqlerrm);
            return v_template;
    end generate_inventory_rpt;

    function generate_i2ms_tag_rpt(
        p_obj        in   varchar2,
        p_evidence   in   varchar2)
        return clob is
        v_ok                 varchar2(100);
        v_template           clob;
        v_template_date      date;
        v_mime_type          t_core_template.mime_type%type;
        v_mime_disposition   t_core_template.mime_disposition%type;
        htmlorrtf            varchar2(4)           := 'RTF';
        v_temp_text          clob;
        v_temp_string        clob;
        v_record_count       number;
        v_temp_template      clob                   := null;
        v_tag_no             varchar2(210);
        v_top_brdr           varchar(2);
    begin
        v_ok :=
            core_template.get_latest('EVIDENCE_TAG_I2MS',
                                     v_template,
                                     v_template_date,
                                     v_mime_type,
                                     v_mime_disposition);

        --- Get Parts we can get from the Main Tables ---
        for a in (select *
                    from v_osi_rpt_emm_tag
                   where sid = p_evidence)
        loop
            v_ok :=
                core_template.replace_tag
                    (v_template,
                     'UNITNAME',
                     osi_report.replace_special_chars
                                               (a.unit_name,
                                                htmlorrtf));
            v_ok :=
                core_template.replace_tag
                    (v_template,
                     'ACTIVITY_ID',
                     osi_report.replace_special_chars
                                          (a.activity_title,
                                           htmlorrtf));
            v_ok :=
                core_template.replace_tag
                    (v_template,
                     'TAGNUMBER',
                     osi_report.replace_special_chars
                                                  (a.tag_no,
                                                   htmlorrtf));
            v_tag_no := a.tag_no;
            v_ok :=
                core_template.replace_tag
                    (v_template,
                     'CASEFILENO',
                     osi_report.replace_special_chars
                                            (a.case_file_no,
                                             htmlorrtf));
            v_ok :=
                core_template.replace_tag
                                  (v_template,
                                   'OBTAINED_DATE',
                                   to_char(a.obtained_date,
                                           'DD-Mon-YYYY'));

            select osi_report.replace_special_chars
                                             (a.description,
                                              htmlorrtf)
              into v_temp_text
              from dual;

            v_ok :=
                core_template.replace_tag(v_template,
                                          'DESCRIPTION',
                                          v_temp_text);
            v_ok :=
                core_template.replace_tag
                    (v_template,
                     'OBTAINEDLABEL',
                     osi_report.replace_special_chars
                                      (a.obtained_method
                                       || '   '
                                       || a.obtained_detail,
                                       htmlorrtf));

            if     a.received_at_address is not null
               and length(trim(a.received_at_address)) > 0 then
                v_ok :=
                    core_template.replace_tag
                        (v_template,
                         'LOCATION',
                         osi_report.replace_special_chars
                                     ('Received At:   '
                                      || a.received_at_address,
                                      htmlorrtf));
            else
                v_ok :=
                    core_template.replace_tag(v_template,
                                              'LOCATION',
                                              '');
            end if;

            v_ok :=
                core_template.replace_tag
                    (v_template,
                     'TAGNUMBER',
                     osi_report.replace_special_chars
                                       ('TAG NUMBER:   '
                                        || a.tag_no,
                                        htmlorrtf));
        end loop;

        --- Evidence Transaction Log ---
        v_record_count := 0;
        v_top_brdr := '45';

        for a in (select   *
                      from v_osi_evidence_trans_log
                     where evidence_sid = p_evidence
                  order by sort_date asc, modify_on asc)
        loop
            v_record_count := v_record_count + 1;
            v_temp_string :=
                v_temp_string
                || '\trowd \irow2\irowband2\lastrow \ts15\trgaph108\trleft-108\trbrdrt';
            v_temp_string :=
                v_temp_string
                || '\brdrs\brdrw10 \trbrdrl\brdrs\brdrw10 \trbrdrb\brdrs\brdrw10 \trbrdrr\brdrs\brdrw10 \trbrdrh\brdrs\brdrw10 \trbrdrv\brdrs\brdrw10';
            v_temp_string :=
                v_temp_string
                || '\trftsWidth1\trftsWidthB3\trftsWidthA3\trautofit1\trpaddl108\trpaddr108\trpaddfl3\trpaddft3\trpaddfb3\trpaddfr3\tbllkhdrrows\tbllklastrow\tbllkhdrcols\tbllklastcol \clvertalc\clbrdrt\brdrs\brdrw'
                || v_top_brdr
                || ' \clbrdrl\brdrs\brdrw10 \clbrdrb\brdrs\brdrw10 \clbrdrr';
            v_temp_string :=
                v_temp_string
                || '\brdrs\brdrw10 \cltxlrtb\clftsWidth3\clwWidth828\clshdrawnil \cellx717\clvertalc\clbrdrt\brdrs\brdrw'
                || v_top_brdr
                || ' \clbrdrl\brdrs\brdrw10 \clbrdrb\brdrs\brdrw10 \clbrdrr\brdrs\brdrw10 \cltxlrtb\clftsWidth3\clwWidth1560\clshdrawnil \cellx2257\clvertalc\clbrdrt';
            v_temp_string :=
                v_temp_string || '\brdrs\brdrw'
                || v_top_brdr
                || ' \clbrdrl\brdrs\brdrw10 \clbrdrb\brdrs\brdrw10 \clbrdrr\brdrs\brdrw10 \cltxlrtb\clftsWidth3\clwWidth3600\clshdrawnil \cellx5704\clvertalc\clbrdrt\brdrs\brdrw'
                || v_top_brdr
                || ' \clbrdrl\brdrs\brdrw10 \clbrdrb\brdrs\brdrw10 \clbrdrr\brdrs\brdrw10';
            v_temp_string :=
                v_temp_string
                || '\cltxlrtb\clftsWidth3\clwWidth1440\clshdrawnil \cellx7100\clvertalc\clbrdrt\brdrs\brdrw'
                || v_top_brdr
                || ' \clbrdrl\brdrs\brdrw10 \clbrdrb\brdrs\brdrw10 \clbrdrr\brdrs\brdrw10 \cltxlrtb\clftsWidth3\clwWidth2232\clshdrawnil \cellx9240\clvertalc\clbrdrt\brdrs\brdrw'
                || v_top_brdr || ' ';
            v_temp_string :=
                v_temp_string
                || '\clbrdrl\brdrs\brdrw10 \clbrdrb\brdrs\brdrw10 \clbrdrr\brdrs\brdrw10 \cltxlrtb\clftsWidth3\clwWidth1932\clshdrawnil \cellx11138\pard\plain \li0\ri0\widctlpar\intbl\aspalpha\aspnum\faauto\adjustright\rin0\lin0\pararsid16144215\yts15';
            v_temp_string :=
                v_temp_string
                || '\fs24\lang1033\langfe1033\cgrid\langnp1033\langfenp1033 {\b\fs20\insrsid13830262 '
                || v_record_count || '\cell '
                || a.tran_desc || '\cell ' || a.purpose
                || '\cell '
                || to_char(a.effective_date, 'DD-Mon-YYYY')
                || '\cell ' || a.custodian_name
                || '\cell \cell }\pard\plain \ql \li0\ri0\widctlpar\intbl\aspalpha\aspnum\faauto\adjustright\rin0\lin0';
            v_temp_string :=
                v_temp_string
                || '\fs24\lang1033\langfe1033\cgrid\langnp1033\langfenp1033 {\b\fs20\insrsid13830262 \trowd \irow2\irowband2\lastrow \ts15\trgaph108\trleft-108\trbrdrt\brdrs\brdrw10 \trbrdrl\brdrs\brdrw10 \trbrdrb\brdrs\brdrw10 \trbrdrr\brdrs\brdrw10 \trbrdrh\brdrs\brdrw10';
            v_temp_string :=
                v_temp_string
                || '\trbrdrv\brdrs\brdrw10 \trftsWidth1\trftsWidthB3\trftsWidthA3\trautofit1\trpaddl108\trpaddr108\trpaddfl3\trpaddft3\trpaddfb3\trpaddfr3\tbllkhdrrows\tbllklastrow\tbllkhdrcols\tbllklastcol \clvertalc\clbrdrt\brdrs\brdrw'
                || v_top_brdr
                || ' \clbrdrl\brdrs\brdrw10 \clbrdrb';
            v_temp_string :=
                v_temp_string
                || '\brdrs\brdrw10 \clbrdrr\brdrs\brdrw10 \cltxlrtb\clftsWidth3\clwWidth828\clshdrawnil \cellx717\clvertalc\clbrdrt\brdrs\brdrw'
                || v_top_brdr
                || ' \clbrdrl\brdrs\brdrw10 \clbrdrb\brdrs\brdrw10 \clbrdrr\brdrs\brdrw10 \cltxlrtb\clftsWidth3\clwWidth1560\clshdrawnil \cellx2257';
            v_temp_string :=
                v_temp_string
                || '\clvertalc\clbrdrt\brdrs\brdrw'
                || v_top_brdr
                || ' \clbrdrl\brdrs\brdrw10 \clbrdrb\brdrs\brdrw10 \clbrdrr\brdrs\brdrw10 \cltxlrtb\clftsWidth3\clwWidth3600\clshdrawnil \cellx5704\clvertalc\clbrdrt\brdrs\brdrw'
                || v_top_brdr
                || ' \clbrdrl\brdrs\brdrw10 \clbrdrb\brdrs\brdrw10 \clbrdrr';
            v_temp_string :=
                v_temp_string
                || '\brdrs\brdrw10 \cltxlrtb\clftsWidth3\clwWidth1440\clshdrawnil \cellx7100\clvertalc\clbrdrt\brdrs\brdrw'
                || v_top_brdr
                || ' \clbrdrl\brdrs\brdrw10 \clbrdrb\brdrs\brdrw10 \clbrdrr\brdrs\brdrw10 \cltxlrtb\clftsWidth3\clwWidth2232\clshdrawnil \cellx9240\clvertalc\clbrdrt';
            v_temp_string :=
                v_temp_string || '\brdrs\brdrw'
                || v_top_brdr
                || ' \clbrdrl\brdrs\brdrw10 \clbrdrb\brdrs\brdrw10 \clbrdrr\brdrs\brdrw10 \cltxlrtb\clftsWidth3\clwWidth1932\clshdrawnil \cellx11138\row }';
            v_top_brdr := '10';
        end loop;

        v_ok :=
            core_template.replace_tag
                                   (v_template,
                                    'EVIDENCE_TRANSACTIONS',
                                    v_temp_string);
        --- Manual Evidence Transaction Log ---
        v_ok :=
            core_template.get_latest('EVIDENCE_TAG_MANUAL',
                                     v_temp_template,
                                     v_template_date,
                                     v_mime_type,
                                     v_mime_disposition);
        v_ok :=
            core_template.replace_tag(v_template,
                                      'TAGNUMBER',
                                      v_tag_no);
        v_ok :=
            core_template.replace_tag(v_template,
                                      'MANUALTRANSACTIONS',
                                      v_temp_template);
        return v_template;
        core_util.cleanup_temp_clob(v_template);
    exception
        when others then
            log_error('generate_i2ms_tag_rpt: ' || sqlerrm);
            return v_template;
    end generate_i2ms_tag_rpt;

    function generate_orig_tag_rpt(
        p_obj        in   varchar2,
        p_evidence   in   varchar2)
        return clob is
        v_ok                 varchar2(100);
        v_template           clob;
        v_template_date      date;
        v_mime_type          t_core_template.mime_type%type;
        v_mime_disposition   t_core_template.mime_disposition%type;
        htmlorrtf            varchar2(4)           := 'RTF';
        v_temp_text          clob;
        v_value              number;
        v_found              number;
        v_record_count       number;
        v_date_format        varchar2(15)
                                       := 'FMDD Mon FMFXYY';
    begin
        v_ok :=
            core_template.get_latest
                                  ('EVIDENCE_TAG_ORIGINAL',
                                   v_template,
                                   v_template_date,
                                   v_mime_type,
                                   v_mime_disposition);

        --- Get Parts we can get from the Main Tables ---
        for a in (select *
                    from v_osi_rpt_emm_tag
                   where sid = p_evidence)
        loop
            v_ok :=
                core_template.replace_tag
                                (v_template,
                                 'OD',
                                 to_char(a.obtained_date,
                                         v_date_format),
                                 'TOKEN@',
                                 true);
            v_ok :=
                core_template.replace_tag
                    (v_template,
                     'TAG',
                     osi_report.replace_special_chars
                                                  (a.tag_no,
                                                   htmlorrtf),
                     'TOKEN@',
                     true);
            v_ok :=
                core_template.replace_tag
                    (v_template,
                     'CASE',
                     osi_report.replace_special_chars
                                            (a.case_file_no,
                                             htmlorrtf),
                     'TOKEN@',
                     true);
            v_ok :=
                core_template.replace_tag
                    (v_template,
                     'UNIT',
                     osi_report.replace_special_chars
                                               (a.unit_name,
                                                htmlorrtf),
                     'TOKEN@',
                     true);

            select osi_report.replace_special_chars
                                            (a.summary_line,
                                             htmlorrtf)
              into v_temp_text
              from dual;

            v_value := 0;
            v_found := 1;

            while v_found > 0
            loop
                v_value := v_value + 1;

                select instr(v_temp_text, '\par', 1,
                             v_value)
                  into v_found
                  from dual;
            end loop;

            while v_value < 5
            loop
                v_temp_text :=
                    v_temp_text || '\par' || chr(13)
                    || chr(10);
                v_value := v_value + 1;
            end loop;

            v_ok :=
                core_template.replace_tag(v_template,
                                          'SUMMARY_LINE',
                                          v_temp_text,
                                          'TOKEN@',
                                          true);

            select osi_report.replace_special_chars
                                             (a.description,
                                              htmlorrtf)
              into v_temp_text
              from dual;

            v_value := 0;
            v_found := 1;

            while v_found > 0
            loop
                v_value := v_value + 1;

                select instr(v_temp_text, '\par', 1,
                             v_value)
                  into v_found
                  from dual;
            end loop;

            while v_value < 18
            loop
                v_temp_text :=
                    v_temp_text || '\par' || chr(13)
                    || chr(10);
                v_value := v_value + 1;
            end loop;

            v_ok :=
                core_template.replace_tag(v_template,
                                          'DESCRIPTION',
                                          v_temp_text,
                                          'TOKEN@',
                                          true);
        end loop;

        select   count(*)
            into v_record_count
            from v_osi_evidence_trans_log
           where evidence_sid = p_evidence
        order by sort_date asc, modify_on asc;

        if v_record_count > 15 then
            log_error('in if > 15');
            v_record_count := 15;

            for a in
                (select   custodian_name, effective_date,
                          tran_desc,
                          decode
                              (condition_change,
                               'Y', 'Yes',
                               'No') as condition_change,
                          other_party
                     from v_osi_evidence_trans_log
                    where evidence_sid = p_evidence
                 order by sort_date desc, modify_on desc)
            loop
                v_ok :=
                    core_template.replace_tag
                        (v_template,
                         'CCRBY'
                         || ltrim
                               (rtrim
                                    (to_char(v_record_count))),
                         osi_report.replace_special_chars
                                (a.custodian_name || ', '
                                 || to_char
                                          (a.effective_date,
                                           v_date_format),
                                 htmlorrtf));
                v_ok :=
                    core_template.replace_tag
                        (v_template,
                         'CCPUR'
                         || ltrim
                               (rtrim
                                    (to_char(v_record_count))),
                         osi_report.replace_special_chars
                                               (a.tran_desc,
                                                htmlorrtf));
                v_ok :=
                    core_template.replace_tag
                        (v_template,
                         'CCCON'
                         || ltrim
                               (rtrim
                                    (to_char(v_record_count))),
                         osi_report.replace_special_chars
                                        (a.condition_change,
                                         htmlorrtf));
                v_ok :=
                    core_template.replace_tag
                        (v_template,
                         'CCRECBY'
                         || ltrim
                               (rtrim
                                    (to_char(v_record_count))),
                         osi_report.replace_special_chars
                                (a.other_party || ', '
                                 || to_char
                                          (a.effective_date,
                                           v_date_format),
                                 htmlorrtf));
                v_record_count := v_record_count - 1;
            end loop;
        else
            v_record_count := 1;

            for a in
                (select   custodian_name, effective_date,
                          tran_desc,
                          decode
                              (condition_change,
                               'Y', 'Yes',
                               'No') as condition_change,
                          other_party
                     from v_osi_evidence_trans_log
                    where evidence_sid = p_evidence
                 order by sort_date asc, modify_on asc)
            loop
                v_ok :=
                    core_template.replace_tag
                        (v_template,
                         'CCRBY'
                         || ltrim
                               (rtrim
                                    (to_char(v_record_count))),
                         osi_report.replace_special_chars
                                (a.custodian_name || ', '
                                 || to_char
                                          (a.effective_date,
                                           v_date_format),
                                 htmlorrtf));
                v_ok :=
                    core_template.replace_tag
                        (v_template,
                         'CCPUR'
                         || ltrim
                               (rtrim
                                    (to_char(v_record_count))),
                         osi_report.replace_special_chars
                                               (a.tran_desc,
                                                htmlorrtf));
                v_ok :=
                    core_template.replace_tag
                        (v_template,
                         'CCCON'
                         || ltrim
                               (rtrim
                                    (to_char(v_record_count))),
                         osi_report.replace_special_chars
                                        (a.condition_change,
                                         htmlorrtf));
                v_ok :=
                    core_template.replace_tag
                        (v_template,
                         'CCRECBY'
                         || ltrim
                               (rtrim
                                    (to_char(v_record_count))),
                         osi_report.replace_special_chars
                                (a.other_party || ', '
                                 || to_char
                                          (a.effective_date,
                                           v_date_format),
                                 htmlorrtf));
                v_record_count := v_record_count + 1;
            end loop;
        end if;

        v_record_count := 1;

        while v_record_count < 16
        loop
            v_ok :=
                core_template.replace_tag
                    (v_template,
                     'CCRBY'
                     || ltrim
                             (rtrim(to_char(v_record_count))),
                     '');
            v_ok :=
                core_template.replace_tag
                     (v_template,
                      'CCPUR'
                      || ltrim
                             (rtrim(to_char(v_record_count))),
                      '');
            v_ok :=
                core_template.replace_tag
                     (v_template,
                      'CCCON'
                      || ltrim
                             (rtrim(to_char(v_record_count))),
                      '');
            v_ok :=
                core_template.replace_tag
                     (v_template,
                      'CCRECBY'
                      || ltrim
                             (rtrim(to_char(v_record_count))),
                      '');
            v_record_count := v_record_count + 1;
        end loop;

        return v_template;
        core_util.cleanup_temp_clob(v_template);
    exception
        when others then
            log_error('generate_orig_tag_rpt: ' || sqlerrm);
            return v_template;
    end generate_orig_tag_rpt;

    function generate_receipt_rpt(p_sid in varchar2)
        return clob is
        v_ok                 varchar2(100);
        v_template           clob;
        v_template_date      date;
        v_mime_type          t_core_template.mime_type%type;
        v_mime_disposition   t_core_template.mime_disposition%type;
        htmlorrtf            varchar2(4)           := 'RTF';
        v_temp_string        clob;
        v_temp_text          clob;
    begin
        v_ok :=
            core_template.get_latest('EVIDENCE_RECEIPT',
                                     v_template,
                                     v_template_date,
                                     v_mime_type,
                                     v_mime_disposition);

        -- If sid passed in is an activity, get evidence for that.
        -- If sid passed in is evidence, get all evidence with same activity.
        for a in (select   *
                      from v_osi_evidence
                     where activity = p_sid
                        or activity = (select obj
                                          from t_osi_evidence
                                         where sid = p_sid)
                  order by seq_num, split_tag_char desc)
        loop
            select osi_report.replace_special_chars
                                             (a.description,
                                              htmlorrtf)
              into v_temp_text
              from dual;

            v_temp_string :=
                v_temp_string
                || '\trowd \irow0\irowband0\ts11\trgaph108\trleft-108\trbrdrt\brdrs\brdrw10 \trbrdrl\brdrs\brdrw10 \trbrdrb\brdrs\brdrw10 \trbrdrr\brdrs\brdrw10';
            v_temp_string :=
                v_temp_string
                || '\trftsWidth2\trwWidth5000\trftsWidthB3\trftsWidthA3\trautofit1\trpaddl108\trpaddr108\trpaddfl3\trpaddfr3\tblrsid13248001 \clvertalt\clbrdrt\brdrs\brdrw10 \clbrdrl\brdrs\brdrw10 \clbrdrb\brdrs\brdrw10 \clbrdrr\brdrs\brdrw10';
            v_temp_string :=
                v_temp_string
                || '\cltxlrtb\clftsWidth2\clwWidth1681\clshdrawnil \cellx3789\clvertalt\clbrdrt\brdrs\brdrw10 \clbrdrl\brdrs\brdrw10 \clbrdrb\brdrs\brdrw10 \clbrdrr\brdrs\brdrw10 \cltxlrtb\clftsWidth2\clwWidth2015\clshdrawnil \cellx8461\clvertalt\clbrdrt\brdrs\brdrw10';
            v_temp_string :=
                v_temp_string
                || '\clbrdrl\brdrs\brdrw10 \clbrdrb\brdrs\brdrw10 \clbrdrr\brdrs\brdrw10 \cltxlrtb\clftsWidth2\clwWidth1304\clshdrawnil \cellx11484\pard\plain \ql \li0\ri0\widctlpar\intbl\faauto\rin0\lin0 \fs24\lang1033\langfe1033\cgrid\langnp1033\langfenp1033 {';
            v_temp_string :=
                v_temp_string
                || '\b\f1\fs20\insrsid8469070 Tag No:  }{\f1\fs20\insrsid8469070 '
                || a.tag_number
                || '\cell }{\b\f1\fs20\insrsid8469070 Obtaining Unit:  }{\f1\fs20\insrsid8469070 '
                || a.obtained_by_unit_name
                || ' \cell }{\b\f1\fs20\insrsid8469070 Date Obtained:  }{\f1\fs20\insrsid8469070 ';
            v_temp_string :=
                v_temp_string
                || to_char(a.obtained_date, 'DD-Mon-YYYY')
                || '\cell }\pard \ql \li0\ri0\widctlpar\intbl\aspalpha\aspnum\faauto\adjustright\rin0\lin0 {\f1\fs20\insrsid5405955 \trowd \irow0\irowband0\ts11\trgaph108\trleft-108\trbrdrt\brdrs\brdrw10 \trbrdrl\brdrs\brdrw10 \trbrdrb\brdrs\brdrw10 \trbrdrr';
            v_temp_string :=
                v_temp_string
                || '\brdrs\brdrw10 \trftsWidth2\trwWidth5000\trftsWidthB3\trftsWidthA3\trautofit1\trpaddl108\trpaddr108\trpaddfl3\trpaddfr3\tblrsid13248001 \clvertalt\clbrdrt\brdrs\brdrw10 \clbrdrl\brdrs\brdrw10 \clbrdrb\brdrs\brdrw10 \clbrdrr\brdrs\brdrw10';
            v_temp_string :=
                v_temp_string
                || '\cltxlrtb\clftsWidth2\clwWidth1681\clshdrawnil \cellx3789\clvertalt\clbrdrt\brdrs\brdrw10 \clbrdrl\brdrs\brdrw10 \clbrdrb\brdrs\brdrw10 \clbrdrr\brdrs\brdrw10 \cltxlrtb\clftsWidth2\clwWidth2015\clshdrawnil \cellx8461\clvertalt\clbrdrt\brdrs\brdrw10';
            v_temp_string :=
                v_temp_string
                || '\clbrdrl\brdrs\brdrw10 \clbrdrb\brdrs\brdrw10 \clbrdrr\brdrs\brdrw10 \cltxlrtb\clftsWidth2\clwWidth1304\clshdrawnil \cellx11484\row }\trowd \irow1\irowband1\ts11\trgaph108\trleft-108\trbrdrt\brdrs\brdrw10 \trbrdrl\brdrs\brdrw10 \trbrdrb\brdrs\brdrw10';
            v_temp_string :=
                v_temp_string
                || '\trbrdrr\brdrs\brdrw10 \trftsWidth2\trwWidth5000\trftsWidthB3\trftsWidthA3\trautofit1\trpaddl108\trpaddr108\trpaddfl3\trpaddfr3\tblrsid13248001 \clvertalt\clbrdrt\brdrs\brdrw10 \clbrdrl\brdrs\brdrw10 \clbrdrb\brdrs\brdrw10 \clbrdrr\brdrnone';
            v_temp_string :=
                v_temp_string
                || '\cltxlrtb\clftsWidth2\clwWidth597\clshdrawnil \cellx1275\clvertalt\clbrdrt\brdrs\brdrw10 \clbrdrl\brdrnone \clbrdrb\brdrs\brdrw10 \clbrdrr\brdrs\brdrw10 \cltxlrtb\clftsWidth2\clwWidth4403\clshdrawnil \cellx11484\pard';
            v_temp_string :=
                v_temp_string
                || '\ql \li0\ri0\widctlpar\intbl\faauto\rin0\lin0 {\b\f1\fs20\insrsid8469070 Description:\cell }{\f1\fs20\insrsid8469070 '
                || v_temp_text
                || '\cell }\pard \ql \li0\ri0\widctlpar\intbl\aspalpha\aspnum\faauto\adjustright\rin0\lin0 {\f1\fs20\insrsid8469070';
            v_temp_string :=
                v_temp_string
                || '\trowd \irow1\irowband1\ts11\trgaph108\trleft-108\trbrdrt\brdrs\brdrw10 \trbrdrl\brdrs\brdrw10 \trbrdrb\brdrs\brdrw10 \trbrdrr\brdrs\brdrw10';
            v_temp_string :=
                v_temp_string
                || '\trftsWidth2\trwWidth5000\trftsWidthB3\trftsWidthA3\trautofit1\trpaddl108\trpaddr108\trpaddfl3\trpaddfr3\tblrsid13248001 \clvertalt\clbrdrt\brdrs\brdrw10 \clbrdrl\brdrs\brdrw10 \clbrdrb\brdrs\brdrw10 \clbrdrr\brdrnone';
            v_temp_string :=
                v_temp_string
                || '\cltxlrtb\clftsWidth2\clwWidth597\clshdrawnil \cellx1275\clvertalt\clbrdrt\brdrs\brdrw10 \clbrdrl\brdrnone \clbrdrb\brdrs\brdrw10 \clbrdrr\brdrs\brdrw10 \cltxlrtb\clftsWidth2\clwWidth4403\clshdrawnil \cellx11484\row }\trowd \irow2\irowband2';
            v_temp_string :=
                v_temp_string
                || '\ts11\trgaph108\trleft-108\trbrdrt\brdrs\brdrw10 \trbrdrl\brdrs\brdrw10 \trbrdrb\brdrs\brdrw10 \trbrdrr\brdrs\brdrw10 \trftsWidth2\trwWidth5000\trftsWidthB3\trftsWidthA3\trautofit1\trpaddl108\trpaddr108\trpaddfl3\trpaddfr3 \clvertalt\clbrdrt';
            v_temp_string :=
                v_temp_string
                || '\brdrs\brdrw10 \clbrdrl\brdrs\brdrw10 \clbrdrb\brdrs\brdrw10 \clbrdrr\brdrs\brdrw10 \cltxlrtb\clftsWidth2\clwWidth5000\clshdrawnil \cellx11484\pard \ql \li0\ri0\widctlpar\intbl\faauto\rin0\lin0 {\b\f1\fs20\insrsid8469070 Obtained/Seized From:  }{';
            v_temp_string :=
                v_temp_string || '\f1\fs20\insrsid8469070 '
                || a.obtained_at
                || '\cell }\pard \ql \li0\ri0\widctlpar\intbl\aspalpha\aspnum\faauto\adjustright\rin0\lin0 {\f1\fs20\insrsid8469070 \trowd \irow2\irowband2\ts11\trgaph108\trleft-108\trbrdrt\brdrs\brdrw10 \trbrdrl\brdrs\brdrw10';
            v_temp_string :=
                v_temp_string
                || '\trbrdrb\brdrs\brdrw10 \trbrdrr\brdrs\brdrw10 \trftsWidth2\trwWidth5000\trftsWidthB3\trftsWidthA3\trautofit1\trpaddl108\trpaddr108\trpaddfl3\trpaddfr3 \clvertalt\clbrdrt\brdrs\brdrw10 \clbrdrl\brdrs\brdrw10 \clbrdrb\brdrs\brdrw10 \clbrdrr\brdrs\brdrw10';
            v_temp_string :=
                v_temp_string
                || '\cltxlrtb\clftsWidth2\clwWidth5000\clshdrawnil \cellx11484\row }\trowd \irow3\irowband3\ts11\trgaph108\trleft-108\trbrdrt\brdrs\brdrw10 \trbrdrl\brdrs\brdrw10 \trbrdrb\brdrs\brdrw10 \trbrdrr\brdrs\brdrw10';
            v_temp_string :=
                v_temp_string
                || '\trftsWidth2\trwWidth5000\trftsWidthB3\trftsWidthA3\trautofit1\trpaddl108\trpaddr108\trpaddfl3\trpaddfr3\tblrsid13248001 \clvertalt\clbrdrt\brdrs\brdrw10 \clbrdrl\brdrs\brdrw10 \clbrdrb\brdrs\brdrw10 \clbrdrr\brdrnone';
            v_temp_string :=
                v_temp_string
                || '\cltxlrtb\clftsWidth2\clwWidth784\clshdrawnil \cellx1709\clvertalt\clbrdrt\brdrs\brdrw10 \clbrdrl\brdrnone \clbrdrb\brdrs\brdrw10 \clbrdrr\brdrs\brdrw10 \cltxlrtb\clftsWidth2\clwWidth4216\clshdrawnil \cellx11484\pard';
            v_temp_string :=
                v_temp_string
                || '\ql \li0\ri0\widctlpar\intbl\faauto\rin0\lin0 {\b\f1\fs20\insrsid13248001 Place Obtained:}{\b\f1\fs20\insrsid8469070 \cell }{\f1\fs20\insrsid8469070 '
                || a.odso_comment
                || '\cell }\pard \ql \li0\ri0\widctlpar\intbl\aspalpha\aspnum\faauto\adjustright\rin0\lin0 {';
            v_temp_string :=
                v_temp_string
                || '\f1\fs20\insrsid8469070 \trowd \irow3\irowband3\ts11\trgaph108\trleft-108\trbrdrt\brdrs\brdrw10 \trbrdrl\brdrs\brdrw10 \trbrdrb\brdrs\brdrw10 \trbrdrr\brdrs\brdrw10';
            v_temp_string :=
                v_temp_string
                || '\trftsWidth2\trwWidth5000\trftsWidthB3\trftsWidthA3\trautofit1\trpaddl108\trpaddr108\trpaddfl3\trpaddfr3\tblrsid13248001 \clvertalt\clbrdrt\brdrs\brdrw10 \clbrdrl\brdrs\brdrw10 \clbrdrb\brdrs\brdrw10 \clbrdrr\brdrnone';
            v_temp_string :=
                v_temp_string
                || '\cltxlrtb\clftsWidth2\clwWidth784\clshdrawnil \cellx1709\clvertalt\clbrdrt\brdrs\brdrw10 \clbrdrl\brdrnone \clbrdrb\brdrs\brdrw10 \clbrdrr\brdrs\brdrw10 \cltxlrtb\clftsWidth2\clwWidth4216\clshdrawnil \cellx11484\row }\trowd \irow4\irowband4\lastrow';
            v_temp_string :=
                v_temp_string
                || '\ts11\trgaph108\trleft-108\trbrdrt\brdrs\brdrw10 \trbrdrl\brdrs\brdrw10 \trbrdrb\brdrs\brdrw10 \trbrdrr\brdrs\brdrw10 \trftsWidth2\trwWidth5000\trftsWidthB3\trftsWidthA3\trautofit1\trpaddl108\trpaddr108\trpaddfl3\trpaddfr3 \clvertalt\clbrdrt';
            v_temp_string :=
                v_temp_string
                || '\brdrs\brdrw10 \clbrdrl\brdrs\brdrw10 \clbrdrb\brdrs\brdrw10 \clbrdrr\brdrs\brdrw10 \cltxlrtb\clftsWidth2\clwWidth5000\clshdrawnil \cellx11484\pard \ql \li0\ri0\widctlpar\intbl\faauto\rin0\lin0 {\b\f1\fs20\insrsid8469070';
            v_temp_string :=
                v_temp_string
                || 'Remarks (Indicate if item was returned to owner/authorized person)';
            v_temp_string :=
                v_temp_string
                || '\par }{\f1\fs20\insrsid8469070';
            v_temp_string := v_temp_string || '\par';
            v_temp_string := v_temp_string || '\par';
            v_temp_string :=
                v_temp_string
                || '\par \cell }\pard \ql \li0\ri0\widctlpar\intbl\aspalpha\aspnum\faauto\adjustright\rin0\lin0 {\f1\fs20\insrsid8469070 \trowd \irow4\irowband4\lastrow \ts11\trgaph108\trleft-108\trbrdrt\brdrs\brdrw10 \trbrdrl\brdrs\brdrw10 \trbrdrb\brdrs\brdrw10 \trbrdrr';
            v_temp_string :=
                v_temp_string
                || '\brdrs\brdrw10 \trftsWidth2\trwWidth5000\trftsWidthB3\trftsWidthA3\trautofit1\trpaddl108\trpaddr108\trpaddfl3\trpaddfr3 \clvertalt\clbrdrt\brdrs\brdrw10 \clbrdrl\brdrs\brdrw10 \clbrdrb\brdrs\brdrw10 \clbrdrr\brdrs\brdrw10';
            v_temp_string :=
                v_temp_string
                || '\cltxlrtb\clftsWidth2\clwWidth5000\clshdrawnil \cellx11484\row }\pard \ql \li0\ri0\widctlpar\faauto\rin0\lin0\itap0 {\fs10\insrsid8469070 ';
            v_temp_string :=
                v_temp_string
                || '\par }\pard \ql \li0\ri0\widctlpar\aspalpha\aspnum\faauto\adjustright\rin0\lin0\itap0\pararsid5511080 {\f1\fs20\insrsid5511080\charrsid5511080}';
        end loop;

        v_ok :=
            core_template.replace_tag(v_template,
                                      'TABLES',
                                      v_temp_string);
        return v_template;
        core_util.cleanup_temp_clob(v_template);
    exception
        when others then
            log_error('generate_receipt_rpt: ' || sqlerrm);
            return v_template;
    end generate_receipt_rpt;

    function generate_manual_tag_rpt(p_sid in varchar2)
        return clob is
        v_ok                 varchar2(100);
        htmlorrtf            varchar2(4)           := 'RTF';
        v_template           clob;
        v_template_date      date;
        v_mime_type          t_core_template.mime_type%type;
        v_mime_disposition   t_core_template.mime_disposition%type;
    begin
        v_ok :=
            core_template.get_latest
                                    ('EVIDENCE_TAG_MANUAL',
                                     v_template,
                                     v_template_date,
                                     v_mime_type,
                                     v_mime_disposition);
        return v_template;
        core_util.cleanup_temp_clob(v_template);
    exception
        when others then
            log_error('generate_manual_tag_rpt: ' || sqlerrm);
            return v_template;
    end generate_manual_tag_rpt;
end osi_evidence;
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
--   Date and Time:   13:01 Thursday June 9, 2011
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

PROMPT ...Remove page 30700
 
begin
 
wwv_flow_api.remove_page (p_flow_id=>wwv_flow.g_flow_id, p_page_id=>30700);
 
end;
/

 
--application/pages/page_30700
prompt  ...PAGE 30700: Evidence Management
--
 
begin
 
declare
    h varchar2(32767) := null;
    ph varchar2(32767) := null;
begin
h := null;
ph:=ph||'<script language="javascript">'||chr(10)||
'   function invTab(){'||chr(10)||
'      var imSure = true;'||chr(10)||
'      if (checkDirty()){'||chr(10)||
'         /*var msg = ''Leaving this tab will cause all unsaved changes to be '' +'||chr(10)||
'                   ''lost.  '' +'||chr(10)||
'                   ''Click Cancel to return to the page and save changes '||chr(10)||
'                    now.'';*/'||chr(10)||
'         var msg = ''You must save before you can perform this action.'';'||chr(10)||
'         imS';

ph:=ph||'ure = confirm(msg);'||chr(10)||
'      }'||chr(10)||
'      if (imSure){'||chr(10)||
'         window.location = ''f?p=&APP_ID.:30720:&SESSION.'' +'||chr(10)||
'                           '':OPEN:NO:30720:P0_OBJ:&P0_OBJ.'';'||chr(10)||
'      }'||chr(10)||
'  }'||chr(10)||
''||chr(10)||
'  function reject(){'||chr(10)||
'      var vOk = confirm(''Are you sure you want to Send this item '''||chr(10)||
'                 + ''back to the Obtaining Agent?'');'||chr(10)||
'      if (vOk) javascript:doSubmit(''REJECT'');'||chr(10)||
'  }'||chr(10)||
''||chr(10)||
'  function showLog(pEvidence';

ph:=ph||'){'||chr(10)||
'       popup({page:30715, '||chr(10)||
'            clear_cache:''30715'','||chr(10)||
'            item_names:''P0_OBJ,P30715_EVIDENCE'', '||chr(10)||
'            item_values:''&P0_OBJ.,''+pEvidence,'||chr(10)||
'            height:450});'||chr(10)||
'  }'||chr(10)||
''||chr(10)||
'  switch(''&REQUEST.''){'||chr(10)||
'     case ''LOGIN'':'||chr(10)||
'     case ''LOGOUT'':'||chr(10)||
'     case ''TRANSFER'':'||chr(10)||
'     case ''DISPOSE'':'||chr(10)||
'     case ''UNDISPOSE'':'||chr(10)||
'     case ''SPLIT'':'||chr(10)||
'     case ''COMMENT'':'||chr(10)||
'       popup({page:30710, '||chr(10)||
'            cl';

ph:=ph||'ear_cache:''30710'','||chr(10)||
'            item_names:''P0_OBJ,P30710_TRANS_SIDS,P30710_TRANS_TYPE'', '||chr(10)||
'            item_values:''&P0_OBJ.,&P30700_TRANS_SIDS.,&REQUEST.'','||chr(10)||
'            height:450});'||chr(10)||
'     default:'||chr(10)||
'         break;'||chr(10)||
'  }'||chr(10)||
''||chr(10)||
'</script>';

wwv_flow_api.create_page(
  p_id     => 30700,
  p_flow_id=> wwv_flow.g_flow_id,
  p_tab_set=> '',
  p_name   => 'Evidence Management',
  p_step_title=> 'Evidence Management',
  p_step_sub_title_type => 'TEXT_WITH_SUBSTITUTIONS',
  p_first_item=> 'NO_FIRST_ITEM',
  p_include_apex_css_js_yn=>'Y',
  p_autocomplete_on_off => 'ON',
  p_help_text => '',
  p_html_page_header => ' ',
  p_step_template => '',
  p_required_patch=> null + wwv_flow_api.g_id_offset,
  p_last_updated_by => 'TWARD',
  p_last_upd_yyyymmddhh24miss => '20110609130129',
  p_page_is_public_y_n=> 'N',
  p_protection_level=> 'N',
  p_page_comment  => '09-Jun-2011 - Tim Ward - CR#3851 - Allow Disposing of Multiple pieces of '||chr(10)||
'                                   Evidence like Legacy did.  Had to change '||chr(10)||
'                                   the Validation to ":REQUEST IN '||chr(10)||
'                                   (''REJECT'',''LOGIN'',''SPLIT'',''UNDISPOSE'','||chr(10)||
'                                   ''COMMENT'')" instead of using the where '||chr(10)||
'                                   REQUEST CONTAINS...  Since UNDISPOSE '||chr(10)||
'                                   contains DISPOSE, the validation was wrong.');
 
wwv_flow_api.set_html_page_header(p_flow_id=>wwv_flow.g_flow_id,p_flow_step_id=>30700,p_text=>ph);
end;
 
end;
/

declare
  s varchar2(32767) := null;
  l_clob clob;
  l_length number := 1;
begin
s:=s||'select htmldb_item.checkbox(1, sid) "Select", sid,'||chr(10)||
'       obtained_by, obtained_date, tag_number,'||chr(10)||
'       obj_tagline "Activity", status, description,'||chr(10)||
'       null log,'||chr(10)||
'       decode(:p30700_sel_evidence,'||chr(10)||
'              sid, ''Y'','||chr(10)||
'              ''N'') "Current"'||chr(10)||
'  from v_osi_evidence e'||chr(10)||
' where (   (    (   (    instr(:p30700_filter, ''INBOX'') > 0'||chr(10)||
'                     and status_code in(''S'', ''X''))'||chr(10)||
'         ';

s:=s||'        or (    instr(:p30700_filter, ''LOGIN'') > 0'||chr(10)||
'                     and status_code = ''C'')'||chr(10)||
'                 or (    instr(:p30700_filter, ''LOGOUT'') > 0'||chr(10)||
'                     and status_code = ''T'')'||chr(10)||
'                 or (    instr(:p30700_filter, ''DISPOSED'') >'||chr(10)||
'                                                           0'||chr(10)||
'                     and status_code = ''D''))'||chr(10)||
'            and evidence_unit_sid';

s:=s||' = :p0_obj)'||chr(10)||
'        or (    instr(:p30700_filter, ''XFER'') > 0'||chr(10)||
'            and status_code = ''X'''||chr(10)||
'            and transferred_from_unit_sid = :p0_obj))'||chr(10)||
'   and (   nvl(:p30700_file_filter, ''N'') <> ''Y'''||chr(10)||
'        or :p30700_file = ''ALL'''||chr(10)||
'        or obj in(select activity_sid'||chr(10)||
'                    from t_osi_assoc_fle_act'||chr(10)||
'                   where file_sid = :p30700_file))';

wwv_flow_api.create_report_region (
  p_id=> 8300810196204981 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_page_id=> 30700,
  p_name=> 'Evidence List',
  p_region_name=>'',
  p_template=> 92560720055766143+ wwv_flow_api.g_id_offset,
  p_display_sequence=> 10,
  p_display_column=> 1,
  p_display_point=> 'AFTER_SHOW_ITEMS',
  p_source=> s,
  p_source_type=> 'SQL_QUERY',
  p_display_error_message=> '#SQLERRM#',
  p_plug_caching=> 'NOT_CACHED',
  p_customized=> '0',
  p_translate_title=> 'Y',
  p_ajax_enabled=> 'Y',
  p_query_row_template=> 179219067086554487+ wwv_flow_api.g_id_offset,
  p_query_headings_type=> 'COLON_DELMITED_LIST',
  p_query_num_rows=> '10000',
  p_query_options=> 'DERIVED_REPORT_COLUMNS',
  p_query_show_nulls_as=> ' - ',
  p_query_break_cols=> '0',
  p_query_no_data_found=> 'No evidence found.',
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
  p_plug_query_exp_filename=> '&P30700_EXPORT_NAME.',
  p_plug_query_strip_html=> 'Y',
  p_comment=>'');
end;
/
declare
  s varchar2(32767) := null;
begin
s := null;
wwv_flow_api.create_report_columns (
  p_id=> 8419012822339418 + wwv_flow_api.g_id_offset,
  p_region_id=> 8300810196204981 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_query_column_id=> 1,
  p_form_element_id=> null,
  p_column_alias=> 'Select',
  p_column_display_sequence=> 1,
  p_column_heading=> ' ',
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
  p_id=> 8447524989721445 + wwv_flow_api.g_id_offset,
  p_region_id=> 8300810196204981 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_query_column_id=> 2,
  p_form_element_id=> null,
  p_column_alias=> 'SID',
  p_column_display_sequence=> 2,
  p_column_heading=> 'Edit',
  p_column_link=>'javascript:doSubmit(''EDIT_#SID#'');',
  p_column_linktext=>'&ICON_EDIT.',
  p_column_alignment=>'LEFT',
  p_heading_alignment=>'CENTER',
  p_default_sort_column_sequence=>0,
  p_disable_sort_column=>'Y',
  p_sum_column=> 'N',
  p_hidden_column=> 'N',
  p_display_as=>'WITHOUT_MODIFICATION',
  p_lov_show_nulls=> 'NO',
  p_pk_col_source=> s,
  p_lov_display_extra=> 'YES',
  p_include_in_export=> 'Y',
  p_column_comment=>'');
end;
/
declare
  s varchar2(32767) := null;
begin
s := null;
wwv_flow_api.create_report_columns (
  p_id=> 8301113765204998 + wwv_flow_api.g_id_offset,
  p_region_id=> 8300810196204981 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_query_column_id=> 3,
  p_form_element_id=> null,
  p_column_alias=> 'OBTAINED_BY',
  p_column_display_sequence=> 3,
  p_column_heading=> 'Obtained By',
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
  p_id=> 8301229731205003 + wwv_flow_api.g_id_offset,
  p_region_id=> 8300810196204981 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_query_column_id=> 4,
  p_form_element_id=> null,
  p_column_alias=> 'OBTAINED_DATE',
  p_column_display_sequence=> 4,
  p_column_heading=> 'Date',
  p_column_format=> '&FMT_DATE.',
  p_column_alignment=>'LEFT',
  p_heading_alignment=>'LEFT',
  p_default_sort_column_sequence=>0,
  p_disable_sort_column=>'N',
  p_sum_column=> 'N',
  p_hidden_column=> 'N',
  p_display_as=>'WITHOUT_MODIFICATION',
  p_lov_show_nulls=> 'NO',
  p_pk_col_source=> s,
  p_lov_display_extra=> 'YES',
  p_include_in_export=> 'Y',
  p_column_comment=>'');
end;
/
declare
  s varchar2(32767) := null;
begin
s := null;
wwv_flow_api.create_report_columns (
  p_id=> 8301318705205003 + wwv_flow_api.g_id_offset,
  p_region_id=> 8300810196204981 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_query_column_id=> 5,
  p_form_element_id=> null,
  p_column_alias=> 'TAG_NUMBER',
  p_column_display_sequence=> 5,
  p_column_heading=> 'Tag Number',
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
  p_id=> 8301411315205004 + wwv_flow_api.g_id_offset,
  p_region_id=> 8300810196204981 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_query_column_id=> 6,
  p_form_element_id=> null,
  p_column_alias=> 'Activity',
  p_column_display_sequence=> 6,
  p_column_heading=> 'Activity',
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
  p_id=> 8301526047205004 + wwv_flow_api.g_id_offset,
  p_region_id=> 8300810196204981 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_query_column_id=> 7,
  p_form_element_id=> null,
  p_column_alias=> 'STATUS',
  p_column_display_sequence=> 7,
  p_column_heading=> 'Status',
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
  p_id=> 8301605686205004 + wwv_flow_api.g_id_offset,
  p_region_id=> 8300810196204981 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_query_column_id=> 8,
  p_form_element_id=> null,
  p_column_alias=> 'DESCRIPTION',
  p_column_display_sequence=> 8,
  p_column_heading=> 'Description',
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
  p_id=> 8824113383475126 + wwv_flow_api.g_id_offset,
  p_region_id=> 8300810196204981 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_query_column_id=> 9,
  p_form_element_id=> null,
  p_column_alias=> 'LOG',
  p_column_display_sequence=> 9,
  p_column_heading=> '',
  p_column_link=>'javascript:showLog(''#SID#'');',
  p_column_linktext=>'<img src="#IMAGE_PREFIX#themes/OSI/attach_text.gif" alt="View Log">',
  p_column_alignment=>'CENTER',
  p_heading_alignment=>'CENTER',
  p_default_sort_column_sequence=>0,
  p_disable_sort_column=>'Y',
  p_sum_column=> 'N',
  p_hidden_column=> 'N',
  p_display_as=>'WITHOUT_MODIFICATION',
  p_lov_show_nulls=> 'NO',
  p_pk_col_source=> s,
  p_lov_display_extra=> 'YES',
  p_include_in_export=> 'Y',
  p_column_comment=>'');
end;
/
declare
  s varchar2(32767) := null;
begin
s := null;
wwv_flow_api.create_report_columns (
  p_id=> 8479315582314884 + wwv_flow_api.g_id_offset,
  p_region_id=> 8300810196204981 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_query_column_id=> 10,
  p_form_element_id=> null,
  p_column_alias=> 'Current',
  p_column_display_sequence=> 10,
  p_column_heading=> 'Current',
  p_column_alignment=>'LEFT',
  p_heading_alignment=>'CENTER',
  p_default_sort_column_sequence=>0,
  p_disable_sort_column=>'Y',
  p_sum_column=> 'N',
  p_hidden_column=> 'Y',
  p_display_as=>'WITHOUT_MODIFICATION',
  p_pk_col_source=> s,
  p_column_comment=>'');
end;
/
declare
  s varchar2(32767) := null;
  l_clob clob;
  l_length number := 1;
begin
s := null;
wwv_flow_api.create_page_plug (
  p_id=> 8303116823235265 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_page_id=> 30700,
  p_plug_name=> 'Filters',
  p_region_name=>'',
  p_plug_template=> 179216655889554481+ wwv_flow_api.g_id_offset,
  p_plug_display_sequence=> 5,
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
  p_id=> 8453232589922307 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_page_id=> 30700,
  p_plug_name=> 'Details of Selected Evidence',
  p_region_name=>'',
  p_plug_template=> 179216655889554481+ wwv_flow_api.g_id_offset,
  p_plug_display_sequence=> 20,
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
  p_plug_display_condition_type => 'ITEM_IS_NOT_NULL',
  p_plug_display_when_condition => 'P30700_SEL_EVIDENCE',
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
s:=s||'<a class ="here">Evidence List</a>'||chr(10)||
'<a href="javascript:void(0);" '||chr(10)||
'   onclick="javascript:invTab();">Evidence Inventory</a>';

wwv_flow_api.create_page_plug (
  p_id=> 8926600425254917 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_page_id=> 30700,
  p_plug_name=> 'Tabs',
  p_region_name=>'',
  p_plug_template=> 179217264383554481+ wwv_flow_api.g_id_offset,
  p_plug_display_sequence=> 1,
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
  p_plug_display_condition_type => '',
  p_pagination_display_position=>'BOTTOM_RIGHT',
  p_plug_customized=>'0',
  p_plug_caching=> 'NOT_CACHED',
  p_plug_comment=> '');
end;
/
 
begin
 
wwv_flow_api.create_page_button(
  p_id             => 9064617484485134 + wwv_flow_api.g_id_offset,
  p_flow_id        => wwv_flow.g_flow_id,
  p_flow_step_id   => 30700,
  p_button_sequence=> 1,
  p_button_plug_id => 8453232589922307+wwv_flow_api.g_id_offset,
  p_button_name    => 'I2MS_VERSION',
  p_button_image   => 'template:'||to_char(179221063608554498+wwv_flow_api.g_id_offset),
  p_button_image_alt=> 'Print I2MS Version',
  p_button_position=> 'REGION_TEMPLATE_CHANGE',
  p_button_alignment=> 'RIGHT',
  p_button_redirect_url=> 'f?p=&APP_ID.:800:&SESSION.::&DEBUG.:800:P800_REPORT_TYPE,P0_OBJ,P800_PARAM_2:&P30700_I2MS_RPT.,&P0_OBJ.,&P30700_SEL_EVIDENCE.',
  p_required_patch => null + wwv_flow_api.g_id_offset);
 
wwv_flow_api.create_page_button(
  p_id             => 9073412149748517 + wwv_flow_api.g_id_offset,
  p_flow_id        => wwv_flow.g_flow_id,
  p_flow_step_id   => 30700,
  p_button_sequence=> 2,
  p_button_plug_id => 8453232589922307+wwv_flow_api.g_id_offset,
  p_button_name    => 'EVIDENCE_TAG',
  p_button_image   => 'template:'||to_char(179221063608554498+wwv_flow_api.g_id_offset),
  p_button_image_alt=> 'Print Evidence Tag',
  p_button_position=> 'REGION_TEMPLATE_CHANGE',
  p_button_alignment=> 'RIGHT',
  p_button_redirect_url=> 'f?p=&APP_ID.:800:&SESSION.::&DEBUG.:800:P800_REPORT_TYPE,P0_OBJ,P800_PARAM_2:&P30700_ORIG_RPT.,&P0_OBJ.,&P30700_SEL_EVIDENCE.',
  p_required_patch => null + wwv_flow_api.g_id_offset);
 
wwv_flow_api.create_page_button(
  p_id             => 8800019542871315 + wwv_flow_api.g_id_offset,
  p_flow_id        => wwv_flow.g_flow_id,
  p_flow_step_id   => 30700,
  p_button_sequence=> 30,
  p_button_plug_id => 8300810196204981+wwv_flow_api.g_id_offset,
  p_button_name    => 'REJECT',
  p_button_image   => 'template:'||to_char(179221063608554498+wwv_flow_api.g_id_offset),
  p_button_image_alt=> 'Reject',
  p_button_position=> 'REGION_TEMPLATE_CHANGE',
  p_button_alignment=> 'RIGHT',
  p_button_redirect_url=> 'javascript:reject();',
  p_button_condition=> 'instr(:P30700_FILTER,''INBOX'')>0',
  p_button_condition_type=> 'PLSQL_EXPRESSION',
  p_required_patch => null + wwv_flow_api.g_id_offset);
 
wwv_flow_api.create_page_button(
  p_id             => 8802428246902214 + wwv_flow_api.g_id_offset,
  p_flow_id        => wwv_flow.g_flow_id,
  p_flow_step_id   => 30700,
  p_button_sequence=> 40,
  p_button_plug_id => 8300810196204981+wwv_flow_api.g_id_offset,
  p_button_name    => 'LOGIN',
  p_button_image   => 'template:'||to_char(179221063608554498+wwv_flow_api.g_id_offset),
  p_button_image_alt=> 'Log In',
  p_button_position=> 'REGION_TEMPLATE_CHANGE',
  p_button_alignment=> 'RIGHT',
  p_button_redirect_url=> '',
  p_button_condition=> 'instr(:P30700_FILTER, ''INBOX'')>0 or'||chr(10)||
'instr(:P30700_FILTER, ''LOGOUT'')>0 or'||chr(10)||
'instr(:P30700_FILTER, ''XFER'')>0',
  p_button_condition_type=> 'PLSQL_EXPRESSION',
  p_required_patch => null + wwv_flow_api.g_id_offset);
 
wwv_flow_api.create_page_button(
  p_id             => 8805208338934335 + wwv_flow_api.g_id_offset,
  p_flow_id        => wwv_flow.g_flow_id,
  p_flow_step_id   => 30700,
  p_button_sequence=> 50,
  p_button_plug_id => 8300810196204981+wwv_flow_api.g_id_offset,
  p_button_name    => 'LOGOUT',
  p_button_image   => 'template:'||to_char(179221063608554498+wwv_flow_api.g_id_offset),
  p_button_image_alt=> 'Log Out',
  p_button_position=> 'REGION_TEMPLATE_CHANGE',
  p_button_alignment=> 'RIGHT',
  p_button_redirect_url=> '',
  p_button_condition=> 'instr(:P30700_FILTER,''LOGIN'')>0',
  p_button_condition_type=> 'PLSQL_EXPRESSION',
  p_required_patch => null + wwv_flow_api.g_id_offset);
 
wwv_flow_api.create_page_button(
  p_id             => 8805407431943446 + wwv_flow_api.g_id_offset,
  p_flow_id        => wwv_flow.g_flow_id,
  p_flow_step_id   => 30700,
  p_button_sequence=> 60,
  p_button_plug_id => 8300810196204981+wwv_flow_api.g_id_offset,
  p_button_name    => 'TRANSFER',
  p_button_image   => 'template:'||to_char(179221063608554498+wwv_flow_api.g_id_offset),
  p_button_image_alt=> 'Transfer',
  p_button_position=> 'REGION_TEMPLATE_CHANGE',
  p_button_alignment=> 'RIGHT',
  p_button_redirect_url=> '',
  p_button_condition=> 'instr(:P30700_FILTER, ''LOGIN'')>0',
  p_button_condition_type=> 'PLSQL_EXPRESSION',
  p_required_patch => null + wwv_flow_api.g_id_offset);
 
wwv_flow_api.create_page_button(
  p_id             => 8805606869952814 + wwv_flow_api.g_id_offset,
  p_flow_id        => wwv_flow.g_flow_id,
  p_flow_step_id   => 30700,
  p_button_sequence=> 70,
  p_button_plug_id => 8300810196204981+wwv_flow_api.g_id_offset,
  p_button_name    => 'SPLIT',
  p_button_image   => 'template:'||to_char(179221063608554498+wwv_flow_api.g_id_offset),
  p_button_image_alt=> 'Split Tag',
  p_button_position=> 'REGION_TEMPLATE_CHANGE',
  p_button_alignment=> 'RIGHT',
  p_button_redirect_url=> '',
  p_button_condition=> 'instr(:P30700_FILTER,''LOGIN'')>0',
  p_button_condition_type=> 'PLSQL_EXPRESSION',
  p_required_patch => null + wwv_flow_api.g_id_offset);
 
wwv_flow_api.create_page_button(
  p_id             => 8805800074960290 + wwv_flow_api.g_id_offset,
  p_flow_id        => wwv_flow.g_flow_id,
  p_flow_step_id   => 30700,
  p_button_sequence=> 80,
  p_button_plug_id => 8300810196204981+wwv_flow_api.g_id_offset,
  p_button_name    => 'DISPOSE',
  p_button_image   => 'template:'||to_char(179221063608554498+wwv_flow_api.g_id_offset),
  p_button_image_alt=> 'Dispose',
  p_button_position=> 'REGION_TEMPLATE_CHANGE',
  p_button_alignment=> 'RIGHT',
  p_button_redirect_url=> '',
  p_button_condition=> 'instr(:P30700_FILTER,''LOGOUT'')>0 or'||chr(10)||
'instr(:P30700_FILTER,''LOGIN'')>0',
  p_button_condition_type=> 'PLSQL_EXPRESSION',
  p_required_patch => null + wwv_flow_api.g_id_offset);
 
wwv_flow_api.create_page_button(
  p_id             => 8806008385962662 + wwv_flow_api.g_id_offset,
  p_flow_id        => wwv_flow.g_flow_id,
  p_flow_step_id   => 30700,
  p_button_sequence=> 90,
  p_button_plug_id => 8300810196204981+wwv_flow_api.g_id_offset,
  p_button_name    => 'UNDISPOSE',
  p_button_image   => 'template:'||to_char(179221063608554498+wwv_flow_api.g_id_offset),
  p_button_image_alt=> 'Undispose',
  p_button_position=> 'REGION_TEMPLATE_CHANGE',
  p_button_alignment=> 'RIGHT',
  p_button_redirect_url=> '',
  p_button_condition=> 'instr(:P30700_FILTER,''DISPOSE'')>0',
  p_button_condition_type=> 'PLSQL_EXPRESSION',
  p_required_patch => null + wwv_flow_api.g_id_offset);
 
wwv_flow_api.create_page_button(
  p_id             => 8806916182002748 + wwv_flow_api.g_id_offset,
  p_flow_id        => wwv_flow.g_flow_id,
  p_flow_step_id   => 30700,
  p_button_sequence=> 100,
  p_button_plug_id => 8300810196204981+wwv_flow_api.g_id_offset,
  p_button_name    => 'COMMENT',
  p_button_image   => 'template:'||to_char(179221063608554498+wwv_flow_api.g_id_offset),
  p_button_image_alt=> 'Comment',
  p_button_position=> 'REGION_TEMPLATE_CHANGE',
  p_button_alignment=> 'RIGHT',
  p_button_redirect_url=> '',
  p_button_condition=> 'instr(:P30700_FILTER,''LOGIN'')>0',
  p_button_condition_type=> 'PLSQL_EXPRESSION',
  p_required_patch => null + wwv_flow_api.g_id_offset);
 
wwv_flow_api.create_page_button(
  p_id             => 9598818482496157 + wwv_flow_api.g_id_offset,
  p_flow_id        => wwv_flow.g_flow_id,
  p_flow_step_id   => 30700,
  p_button_sequence=> 110,
  p_button_plug_id => 8300810196204981+wwv_flow_api.g_id_offset,
  p_button_name    => 'MANUAL_TAG',
  p_button_image   => 'template:'||to_char(179221063608554498+wwv_flow_api.g_id_offset),
  p_button_image_alt=> 'Print Manual Tag',
  p_button_position=> 'REGION_TEMPLATE_CHANGE',
  p_button_alignment=> 'RIGHT',
  p_button_redirect_url=> 'f?p=&APP_ID.:800:&SESSION.::&DEBUG.:800:P0_OBJ,P800_REPORT_TYPE:&P0_OBJ.,&P30700_MANUAL_RPT.',
  p_required_patch => null + wwv_flow_api.g_id_offset);
 
wwv_flow_api.create_page_button(
  p_id             => 8478311511294745 + wwv_flow_api.g_id_offset,
  p_flow_id        => wwv_flow.g_flow_id,
  p_flow_step_id   => 30700,
  p_button_sequence=> 10,
  p_button_plug_id => 8453232589922307+wwv_flow_api.g_id_offset,
  p_button_name    => 'SAVE',
  p_button_image   => 'template:'||to_char(179221063608554498+wwv_flow_api.g_id_offset),
  p_button_image_alt=> '&BTN_SAVE.',
  p_button_position=> 'REGION_TEMPLATE_CREATE',
  p_button_alignment=> 'RIGHT',
  p_button_redirect_url=> '',
  p_button_condition=> ':P30700_STATUS_CODE in (''C'',''X'',''T'')',
  p_button_condition_type=> 'PLSQL_EXPRESSION',
  p_required_patch => null + wwv_flow_api.g_id_offset);
 
wwv_flow_api.create_page_button(
  p_id             => 16059309939198856 + wwv_flow_api.g_id_offset,
  p_flow_id        => wwv_flow.g_flow_id,
  p_flow_step_id   => 30700,
  p_button_sequence=> 120,
  p_button_plug_id => 8300810196204981+wwv_flow_api.g_id_offset,
  p_button_name    => 'EXPORT',
  p_button_image   => 'template:'||to_char(15353513871475325+wwv_flow_api.g_id_offset),
  p_button_image_alt=> '&BTN_EXPORT.',
  p_button_position=> 'REGION_TEMPLATE_HELP',
  p_button_alignment=> 'LEFT',
  p_button_redirect_url=> 'javascript:void(0);',
  p_button_cattributes=>'onclick="javascript:getCSV(null, this, 30700);"',
  p_required_patch => null + wwv_flow_api.g_id_offset);
 
wwv_flow_api.create_page_button(
  p_id             => 8478501252301246 + wwv_flow_api.g_id_offset,
  p_flow_id        => wwv_flow.g_flow_id,
  p_flow_step_id   => 30700,
  p_button_sequence=> 20,
  p_button_plug_id => 8453232589922307+wwv_flow_api.g_id_offset,
  p_button_name    => 'CANCEL',
  p_button_image   => 'template:'||to_char(179221063608554498+wwv_flow_api.g_id_offset),
  p_button_image_alt=> '&BTN_CANCEL.',
  p_button_position=> 'REGION_TEMPLATE_PREVIOUS',
  p_button_alignment=> 'RIGHT',
  p_button_redirect_url=> 'f?p=&APP_ID.:30700:&SESSION.::&DEBUG.:::',
  p_required_patch => null + wwv_flow_api.g_id_offset);
 
 
end;
/

 
begin
 
wwv_flow_api.create_page_branch(
  p_id=>8303725050256629 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 30700,
  p_branch_action=> 'f?p=&APP_ID.:30700:&SESSION.:&REQUEST.:&DEBUG.:::&success_msg=#SUCCESS_MSG#',
  p_branch_point=> 'AFTER_PROCESSING',
  p_branch_type=> 'REDIRECT_URL',
  p_branch_sequence=> 10,
  p_save_state_before_branch_yn=>'N',
  p_branch_comment=> 'Created 17-JUN-2010 12:00 by TIM');
 
 
end;
/

declare
    h varchar2(32767) := null;
begin
wwv_flow_api.create_page_item(
  p_id=>8302826389228634 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 30700,
  p_name=>'P30700_FILTER',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 10,
  p_item_plug_id => 8303116823235265+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'YES',
  p_item_default_type => 'STATIC_TEXT_WITH_SUBSTITUTIONS',
  p_source_type=> 'STATIC',
  p_display_as=> 'CHECKBOX',
  p_lov => 'STATIC2:Inbox;INBOX,Logged In;LOGIN,Logged Out;LOGOUT,Disposed;DISPOSED,In Transfer;XFER',
  p_lov_columns=> 5,
  p_lov_display_null=> 'NO',
  p_lov_translated=> 'N',
  p_cSize=> 30,
  p_cMaxlength=> 2000,
  p_cHeight=> 5,
  p_cAttributes=> 'nowrap',
  p_tag_attributes  => 'onclick="javascript:doSubmit(''FILTER'');"',
  p_begin_on_new_line => 'YES',
  p_begin_on_new_field=> 'YES',
  p_colspan => 1,
  p_rowspan => 1,
  p_label_alignment  => 'LEFT',
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
  p_id=>8453610903925553 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 30700,
  p_name=>'P30700_SEL_EVIDENCE',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 100,
  p_item_plug_id => 8453232589922307+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'NO',
  p_item_default_type => 'STATIC_TEXT_WITH_SUBSTITUTIONS',
  p_source=>'SID',
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
  p_id=>8454332158941126 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 30700,
  p_name=>'P30700_DESCRIPTION',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 110,
  p_item_plug_id => 8453232589922307+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'NO',
  p_item_default_type => 'STATIC_TEXT_WITH_SUBSTITUTIONS',
  p_prompt=>'Description',
  p_source=>'DESCRIPTION',
  p_source_type=> 'DB_COLUMN',
  p_display_as=> 'TEXTAREA_CHAR_COUNT',
  p_lov_columns=> 1,
  p_lov_display_null=> 'NO',
  p_lov_translated=> 'N',
  p_cSize=> 80,
  p_cMaxlength=> 4000,
  p_cHeight=> 7,
  p_cAttributes=> 'nowrap',
  p_tag_attributes  => '&DISABLE_TEXTAREA.',
  p_begin_on_new_line => 'YES',
  p_begin_on_new_field=> 'YES',
  p_colspan => 4,
  p_rowspan => 1,
  p_label_alignment  => 'LEFT-TOP',
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
  p_id=>8454625710948750 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 30700,
  p_name=>'P30700_OBTAINED_FROM',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 120,
  p_item_plug_id => 8453232589922307+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'NO',
  p_item_default_type => 'STATIC_TEXT_WITH_SUBSTITUTIONS',
  p_prompt=>'Received From',
  p_source=>'case osi_object.get_objtype_code(core_obj.get_objtype(:P30700_OBJ))'||chr(10)||
'   when ''ACT.SOURCE_MEET'' then ''SOURCE'''||chr(10)||
'   else ''INVESTIGATIVE ACTIVITY'''||chr(10)||
'end',
  p_source_type=> 'FUNCTION',
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
  p_id=>8460422686004665 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 30700,
  p_name=>'P30700_OBTAINED_AT',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 130,
  p_item_plug_id => 8453232589922307+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'NO',
  p_item_default_type => 'STATIC_TEXT_WITH_SUBSTITUTIONS',
  p_prompt=>'at (place):',
  p_source=>'osi_address.get_addr_display(osi_address.get_address_sid(:P30700_SEL_EVIDENCE, ''OBTAINED_AT''),''SID'')',
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
  p_id=>8468118250183175 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 30700,
  p_name=>'P30700_IDENTIFY_AS',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 140,
  p_item_plug_id => 8453232589922307+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'NO',
  p_item_default_type => 'STATIC_TEXT_WITH_SUBSTITUTIONS',
  p_prompt=>'Identify As',
  p_source=>'IDENTIFY_AS',
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
  p_id=>8470111801190776 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 30700,
  p_name=>'P30700_OBTAINING_UNIT_NAME',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 150,
  p_item_plug_id => 8453232589922307+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'NO',
  p_item_default_type => 'STATIC_TEXT_WITH_SUBSTITUTIONS',
  p_prompt=>'Obtaining Unit',
  p_source=>'osi_unit.get_name(:P30700_OBTAINED_BY_UNIT_SID)',
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
  p_id=>8471221497193582 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 30700,
  p_name=>'P30700_OBTAINED_BY_UNIT_SID',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 145,
  p_item_plug_id => 8453232589922307+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'NO',
  p_item_default_type => 'STATIC_TEXT_WITH_SUBSTITUTIONS',
  p_source=>'OBTAINED_BY_UNIT_SID',
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
  p_id=>8474126608213996 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 30700,
  p_name=>'P30700_APPELLATE_REVIEW',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 160,
  p_item_plug_id => 8453232589922307+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'NO',
  p_item_default => 'U',
  p_item_default_type => 'STATIC_TEXT_WITH_SUBSTITUTIONS',
  p_prompt=>'Pending Appellate Review',
  p_source=>'APPELLATE_REVIEW',
  p_source_type=> 'DB_COLUMN',
  p_display_as=> 'RADIOGROUP',
  p_named_lov=> '?/YES/NO',
  p_lov => '.'||to_char(90561820814157692 + wwv_flow_api.g_id_offset)||'.',
  p_lov_columns=> 3,
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
  p_display_when=>':P30700_STATUS_CODE in (''C'',''T'')',
  p_display_when_type=>'PLSQL_EXPRESSION',
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
  p_id=>8474321890222057 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 30700,
  p_name=>'P30700_CONGRESS_REVIEW',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 170,
  p_item_plug_id => 8453232589922307+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'NO',
  p_item_default => 'U',
  p_item_default_type => 'STATIC_TEXT_WITH_SUBSTITUTIONS',
  p_prompt=>'Pending Congressional Review',
  p_source=>'CONGRESS_REVIEW',
  p_source_type=> 'DB_COLUMN',
  p_display_as=> 'RADIOGROUP',
  p_named_lov=> '?/YES/NO',
  p_lov => '.'||to_char(90561820814157692 + wwv_flow_api.g_id_offset)||'.',
  p_lov_columns=> 3,
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
  p_label_alignment  => 'LEFT',
  p_field_alignment  => 'LEFT',
  p_display_when=>':P30700_STATUS_CODE in (''C'',''T'')',
  p_display_when_type=>'PLSQL_EXPRESSION',
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
  p_id=>8474924446232271 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 30700,
  p_name=>'P30700_STORAGE_LOCATION',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 180,
  p_item_plug_id => 8453232589922307+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'NO',
  p_item_default_type => 'STATIC_TEXT_WITH_SUBSTITUTIONS',
  p_prompt=>'Storage Location',
  p_source=>'STORAGE_LOCATION',
  p_source_type=> 'DB_COLUMN',
  p_display_as=> 'TEXT',
  p_lov_columns=> 1,
  p_lov_display_null=> 'NO',
  p_lov_translated=> 'N',
  p_cSize=> 80,
  p_cMaxlength=> 255,
  p_cHeight=> 5,
  p_cAttributes=> 'nowrap',
  p_tag_attributes  => '&P30700_STORAGE_LOCATION_RO.',
  p_begin_on_new_line => 'YES',
  p_begin_on_new_field=> 'YES',
  p_colspan => 3,
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
  p_id=>8476102198244748 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 30700,
  p_name=>'P30700_FINAL_DISP',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 190,
  p_item_plug_id => 8453232589922307+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'NO',
  p_item_default_type => 'STATIC_TEXT_WITH_SUBSTITUTIONS',
  p_prompt=>'Recommended Final Disposition',
  p_source=>'FINAL_DISP',
  p_source_type=> 'DB_COLUMN',
  p_display_as=> 'TEXT',
  p_lov_columns=> 1,
  p_lov_display_null=> 'NO',
  p_lov_translated=> 'N',
  p_cSize=> 80,
  p_cMaxlength=> 2000,
  p_cHeight=> 5,
  p_cAttributes=> 'nowrap',
  p_tag_attributes  => '&P30700_FINAL_DISP_RO.',
  p_begin_on_new_line => 'YES',
  p_begin_on_new_field=> 'YES',
  p_colspan => 3,
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
  p_id=>8489108684539946 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 30700,
  p_name=>'P30700_OBJ',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 105,
  p_item_plug_id => 8453232589922307+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'NO',
  p_item_default_type => 'STATIC_TEXT_WITH_SUBSTITUTIONS',
  p_source=>'OBJ',
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
  p_id=>8494706624690768 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 30700,
  p_name=>'P30700_TRANS_SIDS',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 200,
  p_item_plug_id => 8300810196204981+wwv_flow_api.g_id_offset,
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
  p_id=>8716331768188840 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 30700,
  p_name=>'P30700_MSG',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 210,
  p_item_plug_id => 8300810196204981+wwv_flow_api.g_id_offset,
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
  p_id=>8995620584934190 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 30700,
  p_name=>'P30700_APPELLATE_REVIEW_RO',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 151,
  p_item_plug_id => 8453232589922307+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'NO',
  p_item_default_type => 'STATIC_TEXT_WITH_SUBSTITUTIONS',
  p_prompt=>'Pending Appellate Review',
  p_source=>'select decode(appellate_review,''Y'',''Yes'',''No'')'||chr(10)||
'  from t_osi_evidence'||chr(10)||
' where sid = :p30700_sel_evidence',
  p_source_type=> 'QUERY',
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
  p_display_when=>':P30700_STATUS_CODE not in (''C'',''T'')',
  p_display_when_type=>'PLSQL_EXPRESSION',
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
  p_id=>8995917252942760 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 30700,
  p_name=>'P30700_STATUS_CODE',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 101,
  p_item_plug_id => 8453232589922307+wwv_flow_api.g_id_offset,
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
  p_id=>8997705740958339 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 30700,
  p_name=>'P30700_CONGRESS_REVIEW_RO',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 152,
  p_item_plug_id => 8453232589922307+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'NO',
  p_item_default_type => 'STATIC_TEXT_WITH_SUBSTITUTIONS',
  p_prompt=>'Pending Congressional Review',
  p_source=>'select decode(congress_review,''Y'',''Yes'',''No'')'||chr(10)||
'  from t_osi_evidence'||chr(10)||
' where sid = :p30700_sel_evidence',
  p_source_type=> 'QUERY',
  p_display_as=> 'DISPLAY_AND_SAVE',
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
  p_label_alignment  => 'LEFT',
  p_field_alignment  => 'LEFT',
  p_display_when=>':P30700_STATUS_CODE not in (''C'',''T'')',
  p_display_when_type=>'PLSQL_EXPRESSION',
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
  p_id=>9011120537255910 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 30700,
  p_name=>'P30700_STORAGE_LOCATION_RO',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 175,
  p_item_plug_id => 8453232589922307+wwv_flow_api.g_id_offset,
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
  p_id=>9011428849258376 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 30700,
  p_name=>'P30700_FINAL_DISP_RO',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 185,
  p_item_plug_id => 8453232589922307+wwv_flow_api.g_id_offset,
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
  p_id=>9083519945138776 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 30700,
  p_name=>'P30700_I2MS_RPT',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 220,
  p_item_plug_id => 8300810196204981+wwv_flow_api.g_id_offset,
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
  p_begin_on_new_field=> 'NO',
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
  p_id=>9089918123776453 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 30700,
  p_name=>'P30700_ORIG_RPT',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 230,
  p_item_plug_id => 8300810196204981+wwv_flow_api.g_id_offset,
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
  p_begin_on_new_field=> 'NO',
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
  p_id=>9137719141161507 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 30700,
  p_name=>'P30700_FILE',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 15,
  p_item_plug_id => 8303116823235265+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'YES',
  p_item_default_type => 'STATIC_TEXT_WITH_SUBSTITUTIONS',
  p_source_type=> 'STATIC',
  p_display_as=> 'COMBOBOX_WITH_SUBMIT',
  p_lov => 'select f.id || '' - '' || f.title disp, f.sid retn'||chr(10)||
'  from t_osi_file f'||chr(10)||
' where f.sid in('||chr(10)||
'           select file_sid'||chr(10)||
'             from t_osi_assoc_fle_act fa,'||chr(10)||
'                  t_osi_evidence e,'||chr(10)||
'                  t_osi_reference s'||chr(10)||
'            where fa.activity_sid = e.obj'||chr(10)||
'              and e.unit_sid = :p0_obj'||chr(10)||
'              and s.sid = e.status_sid'||chr(10)||
'              and s.code <> ''N'''||chr(10)||
'              and (nvl(:P30700_HIDE_DISPOSED,''N'') = ''N'''||chr(10)||
'                   or s.code <> ''D''))',
  p_lov_columns=> 1,
  p_lov_display_null=> 'YES',
  p_lov_translated=> 'N',
  p_lov_null_text=>'- Select File -',
  p_lov_null_value=> 'ALL',
  p_cSize=> 30,
  p_cMaxlength=> 2000,
  p_cHeight=> 5,
  p_cAttributes=> 'nowrap',
  p_begin_on_new_line => 'NO',
  p_begin_on_new_field=> 'YES',
  p_colspan => 1,
  p_rowspan => 1,
  p_label_alignment  => 'LEFT',
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
  p_id=>9137908321177317 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 30700,
  p_name=>'P30700_FILE_FILTER',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 12,
  p_item_plug_id => 8303116823235265+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'YES',
  p_item_default_type => 'STATIC_TEXT_WITH_SUBSTITUTIONS',
  p_source_type=> 'STATIC',
  p_display_as=> 'CHECKBOX',
  p_lov => 'STATIC2:Filter by File:;Y',
  p_lov_columns=> 1,
  p_lov_display_null=> 'NO',
  p_lov_translated=> 'N',
  p_cSize=> 30,
  p_cMaxlength=> 2000,
  p_cHeight=> 5,
  p_cAttributes=> 'nowrap',
  p_tag_attributes  => 'onclick="javascript:doSubmit(''FILE_FILTER'');"',
  p_begin_on_new_line => 'YES',
  p_begin_on_new_field=> 'YES',
  p_colspan => 1,
  p_rowspan => 1,
  p_label_alignment  => 'LEFT',
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
  p_id=>9139628931221085 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 30700,
  p_name=>'P30700_X',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 11,
  p_item_plug_id => 8303116823235265+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'YES',
  p_display_as=> 'STOP_AND_START_HTML_TABLE',
  p_lov_columns=> 1,
  p_lov_display_null=> 'NO',
  p_lov_translated=> 'N',
  p_cSize=> null,
  p_cMaxlength=> 2000,
  p_cHeight=> null,
  p_cAttributes=> 'nowrap="nowrap"',
  p_begin_on_new_line => 'YES',
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
  p_id=>9151221892360995 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 30700,
  p_name=>'P30700_HIDE_DISPOSED',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 16,
  p_item_plug_id => 8303116823235265+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'YES',
  p_item_default_type => 'STATIC_TEXT_WITH_SUBSTITUTIONS',
  p_source_type=> 'STATIC',
  p_display_as=> 'CHECKBOX',
  p_lov => 'STATIC2:Hide files where all evidence has been disposed?;Y',
  p_lov_columns=> 1,
  p_lov_display_null=> 'NO',
  p_lov_translated=> 'N',
  p_cSize=> 30,
  p_cMaxlength=> 2000,
  p_cHeight=> 5,
  p_cAttributes=> 'nowrap',
  p_tag_attributes  => 'onclick="javascript:doSubmit(''HIDE_DISPOSED'');"',
  p_begin_on_new_line => 'YES',
  p_begin_on_new_field=> 'YES',
  p_colspan => 3,
  p_rowspan => 1,
  p_label_alignment  => 'LEFT',
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
  p_id=>9599126447498404 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 30700,
  p_name=>'P30700_MANUAL_RPT',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 240,
  p_item_plug_id => 8300810196204981+wwv_flow_api.g_id_offset,
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
  p_begin_on_new_field=> 'NO',
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
  p_id=>16059517904201110 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 30700,
  p_name=>'P30700_EXPORT_NAME',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 250,
  p_item_plug_id => 8300810196204981+wwv_flow_api.g_id_offset,
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

 
begin
 
wwv_flow_api.create_page_computation(
  p_id=> 9140601273241476 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 30700,
  p_computation_sequence => 10,
  p_computation_item=> 'P30700_FILE',
  p_computation_point=> 'AFTER_SUBMIT',
  p_computation_type=> 'STATIC_ASSIGNMENT',
  p_computation_processed=> 'REPLACE_EXISTING',
  p_computation=> 'ALL',
  p_compute_when => '(:REQUEST = ''FILE_FILTER'' and nvl(:P30700_FILE_FILTER, ''N'') <> ''Y'') or (:REQUEST = ''HIDE_DISPOSED'' and :P30700_HIDE_DISPOSED = ''Y'')',
  p_compute_when_type=>'PLSQL_EXPRESSION');
 
null;
 
end;
/

 
begin
 
wwv_flow_api.create_page_validation(
  p_id => 8445117801700468 + wwv_flow_api.g_id_offset,
  p_flow_id => wwv_flow.g_flow_id,
  p_flow_step_id => 30700,
  p_validation_name => 'Evidence Selected',
  p_validation_sequence=> 10,
  p_validation => '(apex_application.g_f01.count > 0) or :P30700_SEL_EVIDENCE is not null',
  p_validation_type => 'PLSQL_EXPRESSION',
  p_error_message => 'No Evidence Selected',
  p_validation_condition=> 'LOGIN,LOGOUT,TRANSFER,DISPOSE,UNDISPOSE,REJECT,SPLIT,COMMENT',
  p_validation_condition_type=> 'REQUEST_IN_CONDITION',
  p_error_display_location=>'INLINE_WITH_FIELD_AND_NOTIFICATION',
  p_validation_comment=> '');
 
null;
 
end;
/

 
begin
 
wwv_flow_api.create_page_validation(
  p_id => 8498430111212743 + wwv_flow_api.g_id_offset,
  p_flow_id => wwv_flow.g_flow_id,
  p_flow_step_id => 30700,
  p_validation_name => 'Single Evidence Selected',
  p_validation_sequence=> 20,
  p_validation => 'not (apex_application.g_f01.count > 1)',
  p_validation_type => 'PLSQL_EXPRESSION',
  p_error_message => 'This transaction does not support multiple evidence selections.  Please select a single evidence item.',
  p_validation_condition=> ':REQUEST IN (''REJECT'',''LOGIN'',''SPLIT'',''UNDISPOSE'')',
  p_validation_condition_type=> 'SQL_EXPRESSION',
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
p:=p||'#OWNER#:T_OSI_EVIDENCE:P30700_SEL_EVIDENCE:SID|U';

wwv_flow_api.create_page_process(
  p_id     => 8480107402321920 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id => 30700,
  p_process_sequence=> 10,
  p_process_point=> 'AFTER_SUBMIT',
  p_process_type=> 'DML_PROCESS_ROW',
  p_process_name=> 'ARP',
  p_process_sql_clob => p, 
  p_process_error_message=> '&FAILURE_MSG.',
  p_process_when_button_id=>8478311511294745 + wwv_flow_api.g_id_offset,
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
p:=p||':P30700_TRANS_SIDS := null;'||chr(10)||
'if :REQUEST in (''LOGIN'',''LOGOUT'',''TRANSFER'',''DISPOSE'',''UNDISPOSE'',''REJECT'',''SPLIT'',''COMMENT'') then'||chr(10)||
'   for i in 1..apex_application.g_f01.count loop'||chr(10)||
'      if not core_list.add_item_to_list(apex_application.g_f01(i), :P30700_TRANS_SIDS) then'||chr(10)||
'         null;'||chr(10)||
'      end if;'||chr(10)||
'   end loop;'||chr(10)||
'   if :P30700_TRANS_SIDS is null then'||chr(10)||
'      if not core_list.add_item_to_list(:P30700_SEL_';

p:=p||'EVIDENCE, :P30700_TRANS_SIDS) then'||chr(10)||
'          null;'||chr(10)||
'      end if;'||chr(10)||
'   end if;'||chr(10)||
'   :P30700_SEL_EVIDENCE := null;'||chr(10)||
'end if;';

wwv_flow_api.create_page_process(
  p_id     => 8494819438694425 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id => 30700,
  p_process_sequence=> 20,
  p_process_point=> 'AFTER_SUBMIT',
  p_process_type=> 'PLSQL',
  p_process_name=> 'Prepare Transaction Parameters',
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
p:=p||'delete from t_osi_evidence_trans_log'||chr(10)||
' where evidence_sid = core_list.get_list_element(:P30700_TRANS_SIDS, 1);'||chr(10)||
'update t_osi_evidence set status_sid ='||chr(10)||
'   (select sid'||chr(10)||
'      from t_osi_reference'||chr(10)||
'     where usage = ''EVIDENCE_STATUS_TYPE'''||chr(10)||
'       and code = ''N'')'||chr(10)||
' where sid = core_list.get_list_element(:P30700_TRANS_SIDS, 1);';

wwv_flow_api.create_page_process(
  p_id     => 8498928089316193 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id => 30700,
  p_process_sequence=> 30,
  p_process_point=> 'AFTER_SUBMIT',
  p_process_type=> 'PLSQL',
  p_process_name=> 'Reject Item',
  p_process_sql_clob => p, 
  p_process_error_message=> '&FAILURE_MSG.',
  p_process_when=>'REJECT',
  p_process_when_type=>'REQUEST_EQUALS_CONDITION',
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
p:=p||':P30700_SEL_EVIDENCE := substr(:REQUEST,6);';

wwv_flow_api.create_page_process(
  p_id     => 8454005493933423 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id => 30700,
  p_process_sequence=> 40,
  p_process_point=> 'AFTER_SUBMIT',
  p_process_type=> 'PLSQL',
  p_process_name=> 'Select Evidence',
  p_process_sql_clob => p, 
  p_process_error_message=> '',
  p_process_when=>':REQUEST like ''EDIT_%''',
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
p:=p||'P30700_SEL_EVIDENCE';

wwv_flow_api.create_page_process(
  p_id     => 9600425979564521 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id => 30700,
  p_process_sequence=> 50,
  p_process_point=> 'AFTER_SUBMIT',
  p_process_type=> 'CLEAR_CACHE_FOR_ITEMS',
  p_process_name=> 'Clear Items',
  p_process_sql_clob => p, 
  p_process_error_message=> '',
  p_process_when=>'FILE_FILTER,P30700_FILE,P30700_HIDE_DISPOSED',
  p_process_when_type=>'REQUEST_EQUALS_CONDITION',
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
p:=p||'F|#OWNER#:T_OSI_EVIDENCE:P30700_SEL_EVIDENCE:SID';

wwv_flow_api.create_page_process(
  p_id     => 8477223238269720 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id => 30700,
  p_process_sequence=> 5,
  p_process_point=> 'BEFORE_HEADER',
  p_process_type=> 'DML_FETCH_ROW',
  p_process_name=> 'ARF',
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
p:=p||'if :P30700_FILTER is null then'||chr(10)||
'  :P30700_FILTER := ''INBOX'';'||chr(10)||
'end if;'||chr(10)||
''||chr(10)||
'if :P30700_I2MS_RPT is null then'||chr(10)||
'  select sid into :P30700_I2MS_RPT'||chr(10)||
'    from t_osi_report_type'||chr(10)||
'   where obj_type = core_obj.lookup_objtype(''EMM'')'||chr(10)||
'     and description = ''I2MS Version'';'||chr(10)||
'end if;'||chr(10)||
''||chr(10)||
'if :P30700_ORIG_RPT is null then'||chr(10)||
'  select sid into :P30700_ORIG_RPT'||chr(10)||
'    from t_osi_report_type'||chr(10)||
'   where obj_type = core_obj.lookup_objtyp';

p:=p||'e(''EMM'')'||chr(10)||
'     and description = ''Evidence Tag'';'||chr(10)||
'end if;'||chr(10)||
''||chr(10)||
'if :P30700_MANUAL_RPT is null then'||chr(10)||
'  select sid into :P30700_MANUAL_RPT'||chr(10)||
'    from t_osi_report_type'||chr(10)||
'   where obj_type = core_obj.lookup_objtype(''EMM'')'||chr(10)||
'     and description = ''Manual Tag'';'||chr(10)||
'end if;'||chr(10)||
''||chr(10)||
'if :p30700_sel_evidence is not null then'||chr(10)||
'select s.code'||chr(10)||
'  into :P30700_STATUS_CODE'||chr(10)||
'  from t_osi_evidence e,'||chr(10)||
'       t_osi_reference s'||chr(10)||
' where s.sid = ';

p:=p||'e.status_sid'||chr(10)||
'   and e.sid = :p30700_sel_evidence;'||chr(10)||
''||chr(10)||
'if :P30700_STATUS_CODE not in (''X'',''T'',''C'') then'||chr(10)||
'   :P30700_STORAGE_LOCATION_RO := :DISABLE_TEXT;'||chr(10)||
'   :P30700_FINAL_DISP_RO := :DISABLE_TEXT;'||chr(10)||
'else'||chr(10)||
'   if :P30700_STATUS_CODE = ''X'' then'||chr(10)||
'      :P30700_FINAL_DISP_RO := :DISABLE_TEXT;'||chr(10)||
'   else'||chr(10)||
'      :P30700_FINAL_DISP_RO := null;'||chr(10)||
'   end if;'||chr(10)||
'   :P30700_STORAGE_LOCATION_RO := null;'||chr(10)||
'end if;'||chr(10)||
''||chr(10)||
'if :P30700_STAT';

p:=p||'US_CODE in (''C'',''X'',''T'') then'||chr(10)||
'   :P0_DIRTABLE := ''Y'';'||chr(10)||
'end if;'||chr(10)||
'end if;';

wwv_flow_api.create_page_process(
  p_id     => 8342028483781060 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id => 30700,
  p_process_sequence=> 10,
  p_process_point=> 'BEFORE_HEADER',
  p_process_type=> 'PLSQL',
  p_process_name=> 'Setup',
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
 
---------------------------------------
-- ...updatable report columns for page 30700
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
--   Date and Time:   13:22 Thursday June 9, 2011
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

PROMPT ...Remove page 30710
 
begin
 
wwv_flow_api.remove_page (p_flow_id=>wwv_flow.g_flow_id, p_page_id=>30710);
 
end;
/

 
--application/pages/page_30710
prompt  ...PAGE 30710: Evidence Transaction
--
 
begin
 
declare
    h varchar2(32767) := null;
    ph varchar2(32767) := null;
begin
h := null;
ph:=ph||'"JS_POPUP_LOCATOR"'||chr(10)||
'<script language="JavaScript">'||chr(10)||
''||chr(10)||
'  function confirmSave(){'||chr(10)||
'     var vOk = true;'||chr(10)||
'     if ($v(''P30710_TRANS_TYPE'')==''LOGIN'')'||chr(10)||
'        vOk = confirm(''You can no longer edit the Description once you '' +'||chr(10)||
'                          ''exit this form.  Do you want to continue?'');'||chr(10)||
'     '||chr(10)||
'     if (vOk)'||chr(10)||
'        javascript:doSubmit(''SAVE'');'||chr(10)||
'  }        '||chr(10)||
''||chr(10)||
'  if (''&REQUEST.''==''SAVE''){'||chr(10)||
'     opener.do';

ph:=ph||'Submit(''REFRESH'');'||chr(10)||
'     close();'||chr(10)||
'  }'||chr(10)||
'</script>';

wwv_flow_api.create_page(
  p_id     => 30710,
  p_flow_id=> wwv_flow.g_flow_id,
  p_tab_set=> '',
  p_name   => 'Evidence Transaction',
  p_step_title=> '&P30710_TITLE.',
  p_step_sub_title_type => 'TEXT_WITH_SUBSTITUTIONS',
  p_first_item=> 'NO_FIRST_ITEM',
  p_include_apex_css_js_yn=>'Y',
  p_autocomplete_on_off => 'ON',
  p_group_id => 89627319612224885+ wwv_flow_api.g_id_offset,
  p_help_text => '',
  p_html_page_header => ' ',
  p_step_template => 179215770461554476+ wwv_flow_api.g_id_offset,
  p_required_patch=> null + wwv_flow_api.g_id_offset,
  p_last_updated_by => 'TWARD',
  p_last_upd_yyyymmddhh24miss => '20110609132211',
  p_page_is_public_y_n=> 'N',
  p_protection_level=> 'N',
  p_page_comment  => '09-Jun-2011 - Tim Ward - CR#3591 - Allow multiple Comments.');
 
wwv_flow_api.set_html_page_header(p_flow_id=>wwv_flow.g_flow_id,p_flow_step_id=>30710,p_text=>ph);
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
  p_id=> 8410712719206937 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_page_id=> 30710,
  p_plug_name=> 'Hidden',
  p_region_name=>'',
  p_plug_template=> 0,
  p_plug_display_sequence=> 5,
  p_plug_display_column=> 1,
  p_plug_display_point=> 'AFTER_SHOW_ITEMS',
  p_plug_source=> s,
  p_plug_source_type=> 'STATIC_TEXT',
  p_plug_display_error_message=> '#SQLERRM#',
  p_plug_query_row_template=> 1,
  p_plug_query_headings_type=> 'QUERY_COLUMNS',
  p_plug_query_num_rows => 15,
  p_plug_query_num_rows_type => 'NEXT_PREVIOUS_LINKS',
  p_plug_query_row_count_max => 500,
  p_plug_query_show_nulls_as => ' - ',
  p_plug_display_condition_type => '',
  p_pagination_display_position=>'BOTTOM_RIGHT',
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
  p_id=> 8410918260208554 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_page_id=> 30710,
  p_plug_name=> '&P30710_TITLE.',
  p_region_name=>'',
  p_region_attributes=>'width="100%"',
  p_plug_template=> 179216655889554481+ wwv_flow_api.g_id_offset,
  p_plug_display_sequence=> 10,
  p_plug_display_column=> 1,
  p_plug_display_point=> 'AFTER_SHOW_ITEMS',
  p_plug_source=> s,
  p_plug_source_type=> 'STATIC_TEXT',
  p_translate_title=> 'Y',
  p_plug_display_error_message=> '#SQLERRM#',
  p_plug_query_row_template=> 1,
  p_plug_query_headings_type=> 'COLON_DELMITED_LIST',
  p_plug_query_row_count_max => 500,
  p_plug_display_condition_type => 'ITEM_IS_NULL',
  p_plug_display_when_condition => 'P30710_ERRORS',
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
  p_id=> 8723211146169965 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_page_id=> 30710,
  p_plug_name=> 'Errors',
  p_region_name=>'',
  p_plug_template=> 0,
  p_plug_display_sequence=> 7,
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
  p_plug_display_condition_type => 'ITEM_IS_NOT_NULL',
  p_plug_display_when_condition => 'P30710_ERRORS',
  p_pagination_display_position=>'BOTTOM_RIGHT',
  p_plug_customized=>'0',
  p_plug_caching=> 'NOT_CACHED',
  p_plug_comment=> '');
end;
/
 
begin
 
wwv_flow_api.create_page_button(
  p_id             => 8638310897708112 + wwv_flow_api.g_id_offset,
  p_flow_id        => wwv_flow.g_flow_id,
  p_flow_step_id   => 30710,
  p_button_sequence=> 10,
  p_button_plug_id => 8410918260208554+wwv_flow_api.g_id_offset,
  p_button_name    => 'SAVE',
  p_button_image   => 'template:'||to_char(179221063608554498+wwv_flow_api.g_id_offset),
  p_button_image_alt=> '&P30710_TITLE.',
  p_button_position=> 'REGION_TEMPLATE_CREATE',
  p_button_alignment=> 'RIGHT',
  p_button_redirect_url=> 'javascript:confirmSave();',
  p_required_patch => null + wwv_flow_api.g_id_offset);
 
 
end;
/

 
begin
 
wwv_flow_api.create_page_branch(
  p_id=>8667201960202637 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 30710,
  p_branch_action=> 'f?p=&APP_ID.:30710:&SESSION.:&REQUEST.:&DEBUG.:::',
  p_branch_point=> 'AFTER_PROCESSING',
  p_branch_type=> 'REDIRECT_URL',
  p_branch_sequence=> 10,
  p_save_state_before_branch_yn=>'N',
  p_branch_comment=> 'Created 22-JUN-2010 11:17 by TIM');
 
 
end;
/

declare
    h varchar2(32767) := null;
begin
wwv_flow_api.create_page_item(
  p_id=>8634926285523309 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 30710,
  p_name=>'P30710_TRANS_SIDS',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 10,
  p_item_plug_id => 8410712719206937+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'YES',
  p_item_default_type => 'STATIC_TEXT_WITH_SUBSTITUTIONS',
  p_prompt=>'Trans Sids',
  p_source_type=> 'STATIC',
  p_display_as=> 'HIDDEN',
  p_lov_columns=> 1,
  p_lov_display_null=> 'NO',
  p_lov_translated=> 'N',
  p_cSize=> 80,
  p_cMaxlength=> 2000,
  p_cHeight=> 5,
  p_cAttributes=> 'nowrap',
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
  p_id=>8635202174525809 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 30710,
  p_name=>'P30710_TRANS_TYPE',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 20,
  p_item_plug_id => 8410712719206937+wwv_flow_api.g_id_offset,
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
  p_id=>8635621567531401 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 30710,
  p_name=>'P30710_TITLE',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 40,
  p_item_plug_id => 8410712719206937+wwv_flow_api.g_id_offset,
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
  p_id=>8637126341627345 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 30710,
  p_name=>'P30710_DESCRIPTION',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 60,
  p_item_plug_id => 8410918260208554+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'YES',
  p_item_default_type => 'STATIC_TEXT_WITH_SUBSTITUTIONS',
  p_prompt=>'Description',
  p_source_type=> 'STATIC',
  p_display_as=> 'TEXTAREA_CHAR_COUNT',
  p_lov_columns=> 1,
  p_lov_display_null=> 'NO',
  p_lov_translated=> 'N',
  p_cSize=> 80,
  p_cMaxlength=> 4000,
  p_cHeight=> 5,
  p_cAttributes=> 'nowrap',
  p_begin_on_new_line => 'YES',
  p_begin_on_new_field=> 'YES',
  p_colspan => 1,
  p_rowspan => 1,
  p_label_alignment  => 'LEFT-TOP',
  p_field_alignment  => 'LEFT',
  p_display_when=>'(:P30710_TRANS_TYPE=''LOGIN'' and :P30710_EV_STATUS=''S'') or'||chr(10)||
'(:P30710_TRANS_TYPE=''SPLIT'')',
  p_display_when_type=>'PLSQL_EXPRESSION',
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
  p_id=>8637404140668328 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 30710,
  p_name=>'P30710_EFFECTIVE_DATE',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 130,
  p_item_plug_id => 8410918260208554+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'YES',
  p_item_default => 'to_char(sysdate,:FMT_DATE)',
  p_item_default_type => 'PLSQL_EXPRESSION',
  p_prompt=>'Effective Date',
  p_format_mask=>'&FMT_DATE.',
  p_source_type=> 'STATIC',
  p_display_as=> 'TEXT',
  p_lov_columns=> 1,
  p_lov_display_null=> 'NO',
  p_lov_translated=> 'N',
  p_cSize=> 12,
  p_cMaxlength=> 2000,
  p_cHeight=> 5,
  p_cAttributes=> 'nowrap',
  p_tag_attributes  => 'class="datepickernew"',
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
  p_id=>8637822625683129 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 30710,
  p_name=>'P30710_STORAGE_LOCATION',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 140,
  p_item_plug_id => 8410918260208554+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'YES',
  p_item_default_type => 'STATIC_TEXT_WITH_SUBSTITUTIONS',
  p_prompt=>'Storage Location',
  p_source_type=> 'STATIC',
  p_display_as=> 'TEXT',
  p_lov_columns=> 1,
  p_lov_display_null=> 'NO',
  p_lov_translated=> 'N',
  p_cSize=> 50,
  p_cMaxlength=> 255,
  p_cHeight=> 5,
  p_cAttributes=> 'nowrap',
  p_begin_on_new_line => 'YES',
  p_begin_on_new_field=> 'YES',
  p_colspan => 1,
  p_rowspan => 1,
  p_label_alignment  => 'LEFT',
  p_field_alignment  => 'LEFT',
  p_display_when=>'P30710_TRANS_TYPE',
  p_display_when2=>'LOGIN:SPLIT',
  p_display_when_type=>'VALUE_OF_ITEM_IN_CONDITION_IN_COLON_DELIMITED_LIST',
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
  p_id=>8638131413695067 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 30710,
  p_name=>'P30710_PURPOSE',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 150,
  p_item_plug_id => 8410918260208554+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'YES',
  p_item_default_type => 'STATIC_TEXT_WITH_SUBSTITUTIONS',
  p_prompt=>'Purpose/Comments',
  p_source_type=> 'STATIC',
  p_display_as=> 'TEXTAREA_CHAR_COUNT',
  p_lov_columns=> 1,
  p_lov_display_null=> 'NO',
  p_lov_translated=> 'N',
  p_cSize=> 80,
  p_cMaxlength=> 4000,
  p_cHeight=> 5,
  p_cAttributes=> 'nowrap',
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
  p_id=>8649218219705870 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 30710,
  p_name=>'P30710_CONDITION_CHANGE',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 120,
  p_item_plug_id => 8410918260208554+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'YES',
  p_item_default => 'N',
  p_item_default_type => 'STATIC_TEXT_WITH_SUBSTITUTIONS',
  p_prompt=>'Condition Change',
  p_source_type=> 'STATIC',
  p_display_as=> 'RADIOGROUP',
  p_lov => 'STATIC2:Yes;Y,No;N',
  p_lov_columns=> 3,
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
  p_display_when=>'P30710_TRANS_TYPE',
  p_display_when2=>'SUBMIT:LOGIN:LOGOUT:DISPOSE:UNDISPOSE:COMMENT',
  p_display_when_type=>'VALUE_OF_ITEM_IN_CONDITION_IN_COLON_DELIMITED_LIST',
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
  p_id=>8649814671723714 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 30710,
  p_name=>'P30710_EV_STATUS',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 30,
  p_item_plug_id => 8410712719206937+wwv_flow_api.g_id_offset,
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
  p_cAttributes=> 'nowrap',
  p_begin_on_new_line => 'YES',
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
  p_id=>8652308878778798 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 30710,
  p_name=>'P30710_TAG_NO_SUFFIX',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 110,
  p_item_plug_id => 8410918260208554+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'YES',
  p_item_default_type => 'STATIC_TEXT_WITH_SUBSTITUTIONS',
  p_prompt=>'Tag Number Suffix',
  p_source_type=> 'STATIC',
  p_display_as=> 'TEXT',
  p_lov_columns=> 1,
  p_lov_display_null=> 'NO',
  p_lov_translated=> 'N',
  p_cSize=> 5,
  p_cMaxlength=> 1,
  p_cHeight=> 5,
  p_cAttributes=> 'nowrap',
  p_begin_on_new_line => 'YES',
  p_begin_on_new_field=> 'YES',
  p_colspan => 1,
  p_rowspan => 1,
  p_label_alignment  => 'LEFT',
  p_field_alignment  => 'LEFT',
  p_display_when=>'P30710_TRANS_TYPE',
  p_display_when2=>'SPLIT',
  p_display_when_type=>'VAL_OF_ITEM_IN_COND_EQ_COND2',
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
  p_id=>8653213389855815 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 30710,
  p_name=>'P30710_OTHER_PARTY',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 70,
  p_item_plug_id => 8410918260208554+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'YES',
  p_item_default_type => 'STATIC_TEXT_WITH_SUBSTITUTIONS',
  p_prompt=>'Log Out To',
  p_source_type=> 'STATIC',
  p_display_as=> 'TEXT',
  p_lov_columns=> 1,
  p_lov_display_null=> 'NO',
  p_lov_translated=> 'N',
  p_cSize=> 50,
  p_cMaxlength=> 2000,
  p_cHeight=> 5,
  p_cAttributes=> 'nowrap',
  p_begin_on_new_line => 'YES',
  p_begin_on_new_field=> 'YES',
  p_colspan => 1,
  p_rowspan => 1,
  p_label_alignment  => 'LEFT',
  p_field_alignment  => 'LEFT',
  p_display_when=>'P30710_TRANS_TYPE',
  p_display_when2=>'LOGOUT',
  p_display_when_type=>'VAL_OF_ITEM_IN_COND_EQ_COND2',
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
  p_id=>8655706041948315 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 30710,
  p_name=>'P30710_EVIDENCE_DISPLAY',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 50,
  p_item_plug_id => 8410918260208554+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'NO',
  p_item_default_type => 'STATIC_TEXT_WITH_SUBSTITUTIONS',
  p_prompt=>'Evidence',
  p_source=>'begin'||chr(10)||
'  if core_list.count_list_elements(:P30710_TRANS_SIDS) > 1 then'||chr(10)||
'     return core_list.count_list_elements(:P30710_TRANS_SIDS) ||'||chr(10)||
'            '' pieces of Evidence selected.<br>'' ||'||chr(10)||
'            ''Note: The effective dates and comments will be entered '' ||'||chr(10)||
'            ''the same for each.'';'||chr(10)||
'  else'||chr(10)||
'     return osi_evidence.get_tagline('||chr(10)||
'                 core_list.get_list_element(:P30710_TRANS_SIDS, 1));'||chr(10)||
'  end if;'||chr(10)||
'end;',
  p_source_type=> 'FUNCTION_BODY',
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
  p_label_alignment  => 'LEFT-TOP',
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
  p_id=>8659712106987942 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 30710,
  p_name=>'P30710_TRANSFER_UNIT',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 80,
  p_item_plug_id => 8410918260208554+wwv_flow_api.g_id_offset,
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
  p_id=>8660104272995178 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 30710,
  p_name=>'P30710_TRANSFER_UNIT_DISPLAY',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 90,
  p_item_plug_id => 8410918260208554+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'NO',
  p_item_default_type => 'STATIC_TEXT_WITH_SUBSTITUTIONS',
  p_prompt=>'Transfer To',
  p_post_element_text=>'<a href="javascript:popupLocator(500,''P30710_TRANSFER_UNIT'');">&ICON_LOCATOR.</a>',
  p_source=>'osi_unit.get_name(:P30710_TRANSFER_UNIT)',
  p_source_type=> 'FUNCTION',
  p_display_as=> 'TEXT_DISABLED_AND_SAVE',
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
  p_display_when=>'P30710_TRANS_TYPE',
  p_display_when2=>'TRANSFER',
  p_display_when_type=>'VAL_OF_ITEM_IN_COND_EQ_COND2',
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
  p_id=>8724326608240709 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 30710,
  p_name=>'P30710_ERRORS',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 25,
  p_item_plug_id => 8410712719206937+wwv_flow_api.g_id_offset,
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
  p_id=>8724808778273429 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 30710,
  p_name=>'P30710_ERROR_DISPLAY',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 45,
  p_item_plug_id => 8723211146169965+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'YES',
  p_item_default_type => 'STATIC_TEXT_WITH_SUBSTITUTIONS',
  p_source=>'&P30710_ERRORS.',
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
  p_label_alignment  => 'RIGHT',
  p_field_alignment  => 'LEFT',
  p_field_template => 179220564785554493+wwv_flow_api.g_id_offset,
  p_is_persistent=> 'Y',
  p_lov_display_extra=>'NO',
  p_protection_level => 'N',
  p_item_comment => '');
 
 
end;
/

 
begin
 
wwv_flow_api.create_page_validation(
  p_id => 11821931637488028 + wwv_flow_api.g_id_offset,
  p_flow_id => wwv_flow.g_flow_id,
  p_flow_step_id => 30710,
  p_validation_name => 'Valid date',
  p_validation_sequence=> 1,
  p_validation => 'P30710_EFFECTIVE_DATE',
  p_validation_type => 'ITEM_IS_DATE',
  p_error_message => 'Invalid date.',
  p_validation_condition=> ':REQUEST = ''SAVE'' AND :P30710_EFFECTIVE_DATE IS NOT NULL',
  p_validation_condition_type=> 'PLSQL_EXPRESSION',
  p_associated_item=> 8637404140668328 + wwv_flow_api.g_id_offset,
  p_error_display_location=>'INLINE_WITH_FIELD_AND_NOTIFICATION',
  p_validation_comment=> '');
 
null;
 
end;
/

 
begin
 
wwv_flow_api.create_page_validation(
  p_id => 8668419210377921 + wwv_flow_api.g_id_offset,
  p_flow_id => wwv_flow.g_flow_id,
  p_flow_step_id => 30710,
  p_validation_name => 'description not null',
  p_validation_sequence=> 10,
  p_validation => 'P30710_DESCRIPTION',
  p_validation_type => 'ITEM_NOT_NULL',
  p_error_message => 'Description must be specified.',
  p_validation_condition=> '(:P30710_TRANS_TYPE=''LOGIN'' and :P30710_EV_STATUS=''S'') or'||chr(10)||
'(:P30710_TRANS_TYPE=''SPLIT'')',
  p_validation_condition_type=> 'PLSQL_EXPRESSION',
  p_when_button_pressed=> 8638310897708112 + wwv_flow_api.g_id_offset,
  p_associated_item=> 8637126341627345 + wwv_flow_api.g_id_offset,
  p_error_display_location=>'INLINE_IN_NOTIFICATION',
  p_validation_comment=> '');
 
null;
 
end;
/

 
begin
 
wwv_flow_api.create_page_validation(
  p_id => 8668830423390653 + wwv_flow_api.g_id_offset,
  p_flow_id => wwv_flow.g_flow_id,
  p_flow_step_id => 30710,
  p_validation_name => 'transfer unit not null',
  p_validation_sequence=> 20,
  p_validation => 'P30710_TRANSFER_UNIT',
  p_validation_type => 'ITEM_NOT_NULL',
  p_error_message => 'Transfer Unit must be specified.',
  p_validation_condition=> 'P30710_TRANS_TYPE',
  p_validation_condition2=> 'TRANSFER',
  p_validation_condition_type=> 'VAL_OF_ITEM_IN_COND_EQ_COND2',
  p_when_button_pressed=> 8638310897708112 + wwv_flow_api.g_id_offset,
  p_associated_item=> 8659712106987942 + wwv_flow_api.g_id_offset,
  p_error_display_location=>'INLINE_IN_NOTIFICATION',
  p_validation_comment=> '');
 
null;
 
end;
/

 
begin
 
wwv_flow_api.create_page_validation(
  p_id => 8669030338409521 + wwv_flow_api.g_id_offset,
  p_flow_id => wwv_flow.g_flow_id,
  p_flow_step_id => 30710,
  p_validation_name => 'tag no suffix alphabetic',
  p_validation_sequence=> 30,
  p_validation => 'lower(:P30710_TAG_NO_SUFFIX) between ''a'' and ''z''',
  p_validation_type => 'PLSQL_EXPRESSION',
  p_error_message => 'Tag Number Suffix must be between A and Z.',
  p_validation_condition=> 'P30710_TRANS_TYPE',
  p_validation_condition2=> 'SPLIT',
  p_validation_condition_type=> 'VAL_OF_ITEM_IN_COND_EQ_COND2',
  p_when_button_pressed=> 8638310897708112 + wwv_flow_api.g_id_offset,
  p_associated_item=> 8652308878778798 + wwv_flow_api.g_id_offset,
  p_error_display_location=>'INLINE_IN_NOTIFICATION',
  p_validation_comment=> '');
 
null;
 
end;
/

 
begin
 
wwv_flow_api.create_page_validation(
  p_id => 8669428176427898 + wwv_flow_api.g_id_offset,
  p_flow_id => wwv_flow.g_flow_id,
  p_flow_step_id => 30710,
  p_validation_name => 'other party not null',
  p_validation_sequence=> 40,
  p_validation => 'P30710_OTHER_PARTY',
  p_validation_type => 'ITEM_NOT_NULL',
  p_error_message => 'Log Out To must be specified.',
  p_validation_condition=> 'P30710_TRANS_TYPE',
  p_validation_condition2=> 'LOGOUT',
  p_validation_condition_type=> 'VAL_OF_ITEM_IN_COND_EQ_COND2',
  p_when_button_pressed=> 8638310897708112 + wwv_flow_api.g_id_offset,
  p_associated_item=> 8653213389855815 + wwv_flow_api.g_id_offset,
  p_error_display_location=>'INLINE_IN_NOTIFICATION',
  p_validation_comment=> '');
 
null;
 
end;
/

 
begin
 
wwv_flow_api.create_page_validation(
  p_id => 8668601679382320 + wwv_flow_api.g_id_offset,
  p_flow_id => wwv_flow.g_flow_id,
  p_flow_step_id => 30710,
  p_validation_name => 'purpose not null',
  p_validation_sequence=> 50,
  p_validation => 'P30710_PURPOSE',
  p_validation_type => 'ITEM_NOT_NULL',
  p_error_message => 'Purpose/Comments must be specified.',
  p_when_button_pressed=> 8638310897708112 + wwv_flow_api.g_id_offset,
  p_associated_item=> 8638131413695067 + wwv_flow_api.g_id_offset,
  p_error_display_location=>'INLINE_IN_NOTIFICATION',
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
p:=p||'begin'||chr(10)||
'    case :p30710_trans_type'||chr(10)||
'        when ''LOGIN'' then'||chr(10)||
'            osi_evidence.login_evidence(core_list.get_list_element(:p30710_trans_sids, 1),'||chr(10)||
'                                        :p0_obj,'||chr(10)||
'                                        :p30710_effective_date,'||chr(10)||
'                                        :p30710_purpose,'||chr(10)||
'                                        :p30710_description,'||chr(10)||
'                  ';

p:=p||'                      :p30710_condition_change,'||chr(10)||
'                                        :p30710_storage_location);'||chr(10)||
'        when ''LOGOUT'' then'||chr(10)||
'            osi_evidence.logout_evidence(:p30710_trans_sids,'||chr(10)||
'                                         :p30710_effective_date,'||chr(10)||
'                                         :p30710_purpose,'||chr(10)||
'                                         :p30710_other_party,'||chr(10)||
'            ';

p:=p||'                             :p30710_condition_change);'||chr(10)||
'        when ''SPLIT'' then'||chr(10)||
'            osi_evidence.split_tag_evidence(core_list.get_list_element(:p30710_trans_sids, 1),'||chr(10)||
'                                            :p30710_effective_date,'||chr(10)||
'                                            :p30710_purpose,'||chr(10)||
'                                            :p30710_description,'||chr(10)||
'                             ';

p:=p||'               :p30710_tag_no_suffix,'||chr(10)||
'                                            :p30710_storage_location);'||chr(10)||
'        when ''TRANSFER'' then'||chr(10)||
'            osi_evidence.transfer_evidence(:p30710_trans_sids,'||chr(10)||
'                                           :p30710_effective_date,'||chr(10)||
'                                           :p30710_purpose,'||chr(10)||
'                                           :p30710_transfer_unit,'||chr(10)||
'      ';

p:=p||'                                     :p0_obj,'||chr(10)||
'                                           :p30710_condition_change);'||chr(10)||
'        when ''DISPOSE'' then'||chr(10)||
'            osi_evidence.dispose_evidence(:p30710_trans_sids,'||chr(10)||
'                                          :p30710_effective_date,'||chr(10)||
'                                          :p30710_purpose,'||chr(10)||
'                                          :p30710_condition_change);'||chr(10)||
'';

p:=p||'        when ''UNDISPOSE'' then'||chr(10)||
'            osi_evidence.undispose_evidence(core_list.get_list_element(:p30710_trans_sids, 1),'||chr(10)||
'                                          :p30710_effective_date,'||chr(10)||
'                                          :p30710_purpose,'||chr(10)||
'                                          :p30710_condition_change);'||chr(10)||
'        when ''COMMENT'' then'||chr(10)||
'            osi_evidence.edit_evidence(:p30710_trans_';

p:=p||'sids,'||chr(10)||
'                                       :p30710_effective_date,'||chr(10)||
'                                       :p30710_purpose,'||chr(10)||
'                                       :p30710_condition_change);'||chr(10)||
'        else'||chr(10)||
'            null;'||chr(10)||
'    end case;'||chr(10)||
'end;';

wwv_flow_api.create_page_process(
  p_id     => 8675527717919781 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id => 30710,
  p_process_sequence=> 10,
  p_process_point=> 'AFTER_SUBMIT',
  p_process_type=> 'PLSQL',
  p_process_name=> 'Perform Transaction',
  p_process_sql_clob => p, 
  p_process_error_message=> '&FAILURE_MSG.',
  p_process_when_button_id=>8638310897708112 + wwv_flow_api.g_id_offset,
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
p:=p||'declare'||chr(10)||
'   v_evidence t_osi_evidence%rowtype;'||chr(10)||
'begin'||chr(10)||
'   if :P30710_TRANS_TYPE in (''LOGIN'',''SPLIT'',''UNDISPOSE'') then'||chr(10)||
'      select *'||chr(10)||
'        into v_evidence'||chr(10)||
'        from t_osi_evidence'||chr(10)||
'       where sid = core_list.get_list_element(:P30710_TRANS_SIDS, 1);'||chr(10)||
'   end if;'||chr(10)||
''||chr(10)||
'   case :P30710_TRANS_TYPE'||chr(10)||
'      when ''SUBMIT'' then'||chr(10)||
'         :P30710_TITLE := ''Submit'';'||chr(10)||
'         :P30710_PURPOSE := ''Submitting Evidence';

p:=p||''';'||chr(10)||
'      when ''LOGIN'' then'||chr(10)||
'         :P30710_DESCRIPTION := v_evidence.description;'||chr(10)||
'         :P30710_STORAGE_LOCATION := v_evidence.storage_location;'||chr(10)||
'         :P30710_EV_STATUS := osi_reference.lookup_ref_code(v_evidence.status_sid);'||chr(10)||
''||chr(10)||
'         case :P30710_EV_STATUS'||chr(10)||
'            when ''S'' then'||chr(10)||
'               :P30710_TITLE := ''Accept'';'||chr(10)||
'               :P30710_PURPOSE := ''Accepting Submitted Evidence'';'||chr(10)||
'';

p:=p||'            when ''X'' then'||chr(10)||
'               if :p0_obj = v_evidence.transferred_from_unit_sid then'||chr(10)||
'                  :P30710_PURPOSE := ''Recalling Transferred Evidence'';'||chr(10)||
'               else'||chr(10)||
'                  :P30710_PURPOSE := ''Logging In Transferred Evidence'';'||chr(10)||
'               end if;'||chr(10)||
'               :P30710_TITLE := ''Log In'';'||chr(10)||
'            when ''T'' then'||chr(10)||
'               :P30710_TITLE := ''Log In'';'||chr(10)||
'        ';

p:=p||'       :P30710_PURPOSE := ''Logging in Evidence'';'||chr(10)||
'            else null;'||chr(10)||
'         end case;'||chr(10)||
'      when ''LOGOUT'' then'||chr(10)||
'         :P30710_TITLE := ''Log Out'';'||chr(10)||
'         :P30710_PURPOSE := ''Logging Out Evidence'';'||chr(10)||
'         :P30710_OTHER_PARTY := osi_personnel.get_name(:USER_SID);'||chr(10)||
'      when ''TRANSFER'' then'||chr(10)||
'         :P30710_TITLE := ''Transfer'';'||chr(10)||
'         :P30710_PURPOSE := ''Transferring Evidence'';'||chr(10)||
'      when';

p:=p||' ''SPLIT'' then'||chr(10)||
'         :P30710_TITLE := ''Split Tag'';'||chr(10)||
'         :P30710_PURPOSE := ''Splitting Evidence from Tag Number: '' ||'||chr(10)||
'              osi_activity.get_id(v_evidence.obj) || ''-'' || v_evidence.seq_num ||'||chr(10)||
'              v_evidence.split_tag_char;'||chr(10)||
'         :P30710_DESCRIPTION := v_evidence.description;'||chr(10)||
'         :P30710_STORAGE_LOCATION := v_evidence.storage_location;'||chr(10)||
'      when ''RECALL'' then'||chr(10)||
'       ';

p:=p||'  :P30710_TITLE := ''Recall'';'||chr(10)||
'         :P30710_PURPOSE := ''Recalling Evidence'';'||chr(10)||
'      when ''DISPOSE'' then'||chr(10)||
'         :P30710_TITLE := ''Dispose'';'||chr(10)||
'         :P30710_PURPOSE := ''Disposing Evidence'';'||chr(10)||
'      when ''UNDISPOSE'' then'||chr(10)||
'         :P30710_TITLE := ''Un-Dispose'';'||chr(10)||
'         :P30710_PURPOSE := ''Un-Disposing Evidence'';'||chr(10)||
'      when ''COMMENT'' then'||chr(10)||
'         :P30710_TITLE := ''Edit'';'||chr(10)||
'      else'||chr(10)||
'         null;'||chr(10)||
' ';

p:=p||'   end case;'||chr(10)||
'end;';

wwv_flow_api.create_page_process(
  p_id     => 8635827632570946 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id => 30710,
  p_process_sequence=> 10,
  p_process_point=> 'BEFORE_HEADER',
  p_process_type=> 'PLSQL',
  p_process_name=> 'Setup',
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
p:=p||'declare'||chr(10)||
'    v_evid   t_osi_evidence.sid%type;'||chr(10)||
'    v_err_count number := 0;'||chr(10)||
'begin'||chr(10)||
'    :p30710_errors := null;'||chr(10)||
''||chr(10)||
'    for i in 1 .. core_list.count_list_elements(:p30710_trans_sids)'||chr(10)||
'    loop'||chr(10)||
'        v_evid := core_list.get_list_element(:p30710_trans_sids, i);'||chr(10)||
''||chr(10)||
'        case osi_evidence.lookup_evid_status_code'||chr(10)||
'                                           (osi_evidence.get_status_sid(v_evid))'||chr(10)||
'            ';

p:=p||'when ''S'' then'||chr(10)||
'                if :p30710_trans_type not in(''REJECT'', ''LOGIN'') then'||chr(10)||
'                    v_err_count := v_err_count + 1;'||chr(10)||
'                    :p30710_errors :='||chr(10)||
'                        :p30710_errors || ''<li>'' || osi_evidence.get_tag_number(v_evid)'||chr(10)||
'                        || '': Cannot '' || :p30710_title || '' submitted evidence</li>'';'||chr(10)||
'                end if;'||chr(10)||
'            when ''X'' then'||chr(10)||
'  ';

p:=p||'              if :p30710_trans_type <> ''LOGIN'' then'||chr(10)||
'                    v_err_count := v_err_count + 1;'||chr(10)||
'                    :p30710_errors :='||chr(10)||
'                        :p30710_errors || ''<li>'' || osi_evidence.get_tag_number(v_evid)'||chr(10)||
'                        || '': Cannot '' || :p30710_title || '' evidence '''||chr(10)||
'                        || ''transferred to another unit</li>'';'||chr(10)||
'                end if;'||chr(10)||
'           ';

p:=p||' when ''C'' then'||chr(10)||
'                if :p30710_trans_type in(''REJECT'', ''LOGIN'', ''UNDISPOSE'') then'||chr(10)||
'                    v_err_count := v_err_count + 1;'||chr(10)||
'                    :p30710_errors :='||chr(10)||
'                        :p30710_errors || ''<li>'' || osi_evidence.get_tag_number(v_evid)'||chr(10)||
'                        || '': Cannot '' || :p30710_title || '' evidence in '''||chr(10)||
'                        || ''Custodian control</li>'';'||chr(10)||
' ';

p:=p||'               end if;'||chr(10)||
'            when ''T'' then'||chr(10)||
'                if :p30710_trans_type not in(''LOGIN'', ''DISPOSE'') then'||chr(10)||
'                    v_err_count := v_err_count + 1;'||chr(10)||
'                    :p30710_errors :='||chr(10)||
'                        :p30710_errors || ''<li>'' || osi_evidence.get_tag_number(v_evid)'||chr(10)||
'                        || '': Cannot '' || :p30710_title || '' logged out '''||chr(10)||
'                        || ''e';

p:=p||'vidence</li>'';'||chr(10)||
'                end if;'||chr(10)||
'            when ''D'' then'||chr(10)||
'                if :p30710_trans_type <> ''UNDISPOSE'' then'||chr(10)||
'                    v_err_count := v_err_count + 1;'||chr(10)||
'                    :p30710_errors :='||chr(10)||
'                        :p30710_errors || ''<li>'' || osi_evidence.get_tag_number(v_evid)'||chr(10)||
'                        || '': Cannot '' || :p30710_title || '' disposed '''||chr(10)||
'                        || ';

p:=p||'''evidence</li>'';'||chr(10)||
'                end if;'||chr(10)||
'            else'||chr(10)||
'                null;'||chr(10)||
'        end case;'||chr(10)||
'    end loop;'||chr(10)||
''||chr(10)||
'    if v_err_count > 0 then'||chr(10)||
'        if v_err_count > 1 then'||chr(10)||
'            :p30710_errors := ''<div class="t9notification">'' ||'||chr(10)||
'                              v_err_count || '' errors have occurred.'' ||'||chr(10)||
'                              ''<ul class="htmldbUlErr">'' || :p30710_errors || ''</ul></div>';

p:=p||''';'||chr(10)||
'        else'||chr(10)||
'            :p30710_errors := ''<div class="t9notification">'' ||'||chr(10)||
'                              v_err_count || '' error has occurred.'' ||'||chr(10)||
'                              ''<ul class="htmldbUlErr">'' || :p30710_errors || ''</ul></div>'';'||chr(10)||
'        end if;'||chr(10)||
'    end if;'||chr(10)||
''||chr(10)||
'end;';

wwv_flow_api.create_page_process(
  p_id     => 8723409593207398 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id => 30710,
  p_process_sequence=> 15,
  p_process_point=> 'BEFORE_HEADER',
  p_process_type=> 'PLSQL',
  p_process_name=> 'Check inputs',
  p_process_sql_clob => p, 
  p_process_error_message=> '',
  p_process_when=>'OPEN',
  p_process_when_type=>'REQUEST_EQUALS_CONDITION',
  p_process_success_message=> '',
  p_process_is_stateful_y_n=>'N',
  p_process_comment=>'');
end;
null;
 
end;
/

 
begin
 
---------------------------------------
-- ...updatable report columns for page 30710
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

