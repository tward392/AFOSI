set define off;

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
        p_obj                in   varchar2,
        p_effective_date     in   date,
        p_purpose            in   varchar2,
        p_condition_change   in   varchar2) is
    begin
        create_transaction_log(p_obj,
                               'COMMENT',
                               p_effective_date,
                               p_purpose,
                               p_condition_change);
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
