set define off;

CREATE OR REPLACE package body osi_personnel as
/******************************************************************************
   name:     osi_personnel
   purpose:  provides functionality for personnel objects.

   revisions:
    date        author          description
    ----------  --------------  ------------------------------------
     17-apr-2009 t.mcguffin      created package
     28-apr-2009 t.mcguffin      added get_current_unit function
     28-apr-2009 t.mcguffin      modified get_name to return null if null sid passed in.
     08-may-2009 t.whitehead     Added create_instance function.
     15-may-2009 r.dibble        modified get_current_unit to actually do something
     18-may-2009 t.mcguffin      modified get_current_unit to make sure ended assignments are not returned.
     28-may-2009 t.whitehead     Changed get_name and get_current_unit functions
                                 to accept null parameters.
     29-jul-2009 r.dibble        Added get_login_id,get_pswd_exp_date
     31-jul-2009 r.dibble        Added get_status_desc, get_status_date,get_deployment_points and
                                 filled in guts of get_status
     31-jul-2009 r.dibble        Added get_status_desc, get_status_date,get_deployment_points,
                                 get_Deployment_Points_assign and filled in guts of get_status.
     03-aug-2009 r.dibble        added get_pay_category_desc
     06-aug-2009 r.dibble        added get_experience_lov
     05-oct-2009 r.dibble        modified create_instance to accept middle name
                                 added create_login_id
     16-dec-2009 r.dibble        added user_is_assigned_to_unit
     06-jan-2010 r.dibble        added user_is_foreign_national
     21-apr-2010 r.dibble        modified get_login_id to always return UPPER()
     09-jun-2010 t.mcguffin      fixed bug where middle name wasn't being saved in create_instance
     10-jun-2010 r.dibble        Added assign_to_unit
     11-jun-2010 r.dibble        Added transfer_roles
     28-jun-2010 r.dibble        Modified create_instance() to add a row to t_person_chars
     18-aug-2010 r.dibble        Added has_valid_email_address
     19-aug-2010 r.dibble        Modified Create_Instance() to create a starting status
     21-oct-2010 j.faris         Modified Create_Instance() to use the s_prsnl_num sequence
     26-oct-2010 j.faris         Bug 0543 - fixed bug where login id's were getting duplicated on same names
                                 due to lowercase entry
     29-nov-2010 r.dibble        Modified create_instance to NOT give a user a role on creation
     22-mar-2011 tim ward        CR#3760 - Changed create_instance to give an initial personnel_status_sid of 'OP' and
                                  and initial status date.
******************************************************************************/
    c_pipe   varchar2(100) := core_util.get_config('CORE.PIPE_PREFIX') || 'OSI_PERSONNEL';

    procedure log_error(p_msg in varchar2) is
    begin
        core_logger.log_it(c_pipe, p_msg);
    end log_error;

    function create_login_id(p_fname in varchar2, p_mname in varchar2, p_lname in varchar2)
        return varchar2 is
        v_orig_ln        varchar2(100);
        v_fi             varchar2(1);
        v_mi             varchar2(1);
        v_ln             varchar2(50);
        v_id             varchar2(30);
        v_return         varchar2(20);
        v_counter_temp   varchar2(3);
        v_temp_id        varchar2(20);

        function id_already_exists(p_id in varchar2)
            return boolean is
            v_count   number := 0;
        begin
            --See if ID already exists
            for k in (select SID
                        from t_core_personnel
                       where login_id = p_id)
            loop
                v_count := v_count + 1;
            end loop;

            if (v_count <= 0) then
                return false;
            else
                return true;
            end if;
        end;
    begin
        /*
        CPersonnel.Public Function FixLoginID() As Boolean
        Public Function InitClass(
        -->[InitSetup]
        PmmUtilities.CreateUserID
        */

        --Save off Original Last Name (minus spaces and dashes and apostrophies)
        v_orig_ln := replace(p_lname, '-', '');
        v_orig_ln := replace(v_orig_ln, ' ', '');
        v_orig_ln := replace(v_orig_ln, '''', '');
        --Get first initial
        v_fi := substr(p_fname, 1, 1);
        --Get middle initial
        v_mi := substr(p_mname, 1, 1);
        --Put both together
        v_id := v_fi || v_mi;
        --Get Last Name
        v_ln := ltrim(upper(v_orig_ln), 8 - length(v_id));
        --Concatonate ID
        v_id := substr(v_id || v_ln, 0, 8);

        if (id_already_exists(v_id) = false) then
            --ID Is original, so we're fine
            v_return := v_id;
        else
            --ID is taken, so lets increment its last number
            for v_counter in 1 .. 999
            loop
                v_counter_temp := to_char(v_counter);
                v_temp_id := substr(v_id, 0, 8 - length(v_counter_temp)) || v_counter_temp;

                if (id_already_exists(v_temp_id) = false) then
                    --ID is now original, lets return it
                    v_return := v_temp_id;
                    exit;
                end if;
            end loop;
        end if;

        --Return value
        return upper(v_return);
    exception
        when others then
            log_error('get_name: ' || sqlerrm);
            raise;
    end create_login_id;

    function create_instance(
        p_fname   in   varchar2,
        p_mname   in   varchar2,
        p_lname   in   varchar2,
        p_ssn     in   varchar2)
        return varchar2 is
        v_login_id   t_core_personnel.login_id%type;
        v_sid        t_core_personnel.SID%type;
        v_num        number;
        v_status     t_osi_personnel.personnel_status_sid%type;
    begin
        log_error('Creating Personnel instance for: ' || p_fname || ' ' || p_lname);

        v_login_id := create_login_id(upper(p_fname), upper(p_mname), upper(p_lname));

        insert into t_core_obj
                    (obj_type)
             values (core_obj.lookup_objtype('PERSONNEL'))
          returning SID
               into v_sid;

        select s_prsnl_num.nextval
          into v_num
          from dual;

        insert into t_core_personnel p
                    (p.SID, p.first_name, p.last_name, p.middle_name, login_id, personnel_num)
             values (v_sid, p_fname, p_lname, p_mname, v_login_id, lpad(v_num, 5, '0'));
        
        select sid into v_status from t_osi_reference where usage='PERSONNEL_STATUS' and code='OP';
        
        insert into t_osi_personnel op
                    (op.SID, op.ssn, op.personnel_status_sid, op.personnel_status_date)
             values (v_sid, p_ssn, v_status, sysdate);

        --- Create T_PERSON_CHARS Record ---
        insert into t_osi_person_chars
                    (SID)
             values (v_sid);

        --- Set the starting status ---
        osi_status.change_status_brute
                              (v_sid,
                               osi_status.get_starting_status(core_obj.lookup_objtype('PERSONNEL')),
                               'Created');

        log_error('Defaulting password: ' || core_context.reset_pswd(v_login_id));
        return v_sid;

    end create_instance;

    function get_name(p_obj in varchar2 := null)
        return varchar2 is
        v_personnel    t_core_personnel.SID%type;
        v_last_name    t_core_personnel.last_name%type;
        v_first_name   t_core_personnel.first_name%type;
    begin
        v_personnel := nvl(p_obj, core_context.personnel_sid);

        select last_name, first_name
          into v_last_name, v_first_name
          from t_core_personnel
         where SID = v_personnel;

        return v_last_name || ', ' || v_first_name;
    exception
        when others then
            log_error('get_name: ' || sqlerrm);
            return 'get_name: Error';
    end get_name;

    function get_tagline(p_obj in varchar2)
        return varchar2 is
    begin
        return get_name(p_obj);
    exception
        when others then
            log_error('get_tagline: ' || sqlerrm);
            return 'get_tagline: Error';
    end get_tagline;

    function get_summary(p_obj in varchar2, p_variant in varchar2 := null)
        return clob is
    begin
        return 'Personnel Summary';
    exception
        when others then
            log_error('get_summary: ' || sqlerrm);
            return 'get_summary: Error';
    end get_summary;

    procedure index1(p_obj in varchar2, p_clob in out nocopy clob) is
    begin
        p_clob := 'Personnel index';
    exception
        when others then
            log_error('index1: ' || sqlerrm);
    end index1;

    function get_status(p_obj in varchar2)
        return varchar2 is
        v_return   t_osi_reference.SID%type;
    begin
        select personnel_status_sid
          into v_return
          from t_osi_personnel
         where SID = p_obj;

        return v_return;
    exception
        when no_data_found then
            return 'No current status';
        when others then
            log_error('get_status: ' || sqlerrm);
            return 'get_status: Error';
    end get_status;

    /* Given a personnel sid for p_obj, return the current status description of the personnel */
    function get_status_desc(p_obj in varchar2)
        return varchar2 is
        v_return   t_osi_reference.description%type;
    begin
        select description
          into v_return
          from t_osi_reference
         where SID = get_status(p_obj);

        return v_return;
    exception
        when no_data_found then
            return 'No current status';
        when others then
            log_error('get_status_desc: ' || sqlerrm);
            return 'get_status_desc: Error';
    end get_status_desc;

    /* Given a personnel sid for p_obj, return the current status date of the personnel */
    function get_status_date(p_obj in varchar2)
        return date is
        v_rtn   date;
    begin
        select personnel_status_date
          into v_rtn
          from t_osi_personnel
         where SID = p_obj;

        return v_rtn;
    exception
        when others then
            log_error('get_status_date: ' || sqlerrm);
            return null;
    end get_status_date;

    function get_current_unit(p_obj in varchar2 := null)
        return varchar2 is
        v_personnel   t_core_personnel.SID%type;
    begin
        v_personnel := nvl(p_obj, core_context.personnel_sid);

        for k in (select   unit
                      from t_osi_personnel_unit_assign
                     where personnel = v_personnel and end_date is null
                  order by start_date desc)
        loop
            return k.unit;
        end loop;

        return null;
    exception
        when others then
            log_error('get_current_unit: ' || sqlerrm);
            return 'get_current_unit: Error';
    end get_current_unit;

    /* Retreives the Login ID for the given user */
    function get_login_id(p_obj in varchar2)
        return varchar2 is
        v_return   varchar2(200);
    begin
        select login_id
          into v_return
          from t_core_personnel
         where SID = p_obj;

        return v_return;
    exception
        when others then
            log_error('get_login_id: ' || sqlerrm);
            return 'get_login_id: Error';
    end get_login_id;

    /* Retreives the users PSWD expiration date */
    function get_pswd_exp_date(p_obj in varchar2)
        return date is
        v_return   date;
    begin
        select pswd_expiration_date
          into v_return
          from t_core_personnel
         where SID = p_obj;

        return v_return;
    exception
        when others then
            log_error('get_pswd_exp_date: ' || sqlerrm);
            return 'get_pswd_exp_date: Error';
    end get_pswd_exp_date;

    function get_deployment_points_assign(
        p_obj         in   varchar2,
        p_unit        in   varchar2,
        p_startdate   in   date,
        p_enddate     in   date,
        p_category    in   varchar2)
        return number is
        v_personnel_record   t_osi_personnel%rowtype;
        v_unit_record        t_osi_unit%rowtype;
        v_unit_addr_rec      t_osi_address%rowtype;
        v_unit_is_conus      boolean;
        v_rate               number;
        v_days               number;
    begin
--        select * into v_personnel_record from t_osi_personnel where sid = p_obj;
--
--        --Load_Unit( pUnit );
--
--        if p_Unit <> nvl(v_unit_record.SID,'xyz') then

        --            v_unit_is_conus := true;    -- assume US location

        --            select * into v_unit_record
--              from T_osi_UNIT
--              where SID = p_Unit;
--
--              for K in (select SID from t_osi_address where obj = p_unit)
--              loop
--                   select * into v_unit_addr_rec
--                  from T_osi_ADDRESS
--                  where obj = p_unit;

        --                if (v_unit_addr_rec.country not in (select SID from t_dibrs_country where CODE = 'US')) then
--
--                    v_unit_is_conus := false;
--                end if;
--
--                exit;
--
--              end loop;

        --        end if;
--
--
--    -->Everything below needs to be finished once Assignment Categories are completed
--        Load_Assignment_Category( pCategory );

        --        if v_unit_is_conus then
--            v_rate := v_assignment_category_rec.POINT_RATE_CONUS;
--        else
--            v_rate := v_assignment_category_rec.POINT_RATE_NON_CONUS;
--        end if;
--        v_rate := nvl(v_rate,0);

        --        v_days := nvl(pEndDate,trunc(sysdate)) -
--                               greatest(pStartDate,nvl(v_personnel_rec.GF_DEP_PTS_DATE,pStartDate));

        --        return v_days * v_rate;
        return 0;
    exception
        when others then
            return 0;
    end get_deployment_points_assign;

    function get_deployment_points(p_obj in varchar2)
        return number is
        v_personnel_record   t_osi_personnel%rowtype;
        v_rtn                number;
        v_osi_time           number;
        v_ah_pts             number                    := 0;                  -- assignment history
        v_cc_pts             number                    := 0;                   -- course completion
    begin
    --**THIS NEEDS TO BE COMPLETED ONCE ASSIGNMENT CATEGORIES ARE SETUP
--        select * into v_personnel_record from t_osi_personnel where sid = p_obj;
--
--        --Load_Personnel( pPersonnel );
--        v_rtn := nvl(v_personnel_record.GF_DEP_PTS,0);

        --        v_osi_time := months_between(trunc(sysdate),nvl(v_personnel_record.START_DATE,trunc(sysdate)));
--        v_osi_time := least(v_osi_time / 12, 7);    -- years
--        v_osi_time := round(v_osi_time);            -- each part rounded
--        v_rtn := v_rtn + v_osi_time;

        --        for a in (select * from T_osi_personnel_unit_assign
--                  where PERSONNEL = p_obj)
--        loop
--            v_ah_pts := v_ah_pts + Assignment_Dep_Points( a.PERSONNEL, a.UNIT,
--                            a.START_DATE, a.END_DATE, a.ASSIGN_CATEGORY );
--        end loop;

        --        v_ah_pts := round(v_ah_pts);                -- each part rounded
--        v_rtn := v_rtn + v_ah_pts;

        --        select nvl(sum(c.COMPLETION_POINT_CREDIT),0) into v_cc_pts
--          from T_PERSONNEL_COURSE pc, T_COURSE c
--          where pc.PERSONNEL = pPersonnel and
--                pc.COMPLETION_DATE > v_personnel_rec.GF_DEP_PTS_DATE and
--                c.CODE = pc.COURSE;

        --        v_cc_pts := round(v_cc_pts);    -- probably not needed - all values integer
--        v_rtn := v_rtn + v_cc_pts;

        --        return round(v_rtn);
        --**THIS NEEDS TO BE COMPLETED ONCE ASSIGNMENT CATEGORIES ARE SETUP
        return 0;
    exception
        when others then
            return 0;
    end get_deployment_points;

    /* Returns the pay category description for either a personnel SID or a pay_category sid */
    function get_pay_category_desc(p_obj_or_sid in varchar2)
        return varchar2 is
        v_personnels_pay_category_sid   t_osi_reference.SID%type           := 'dummy';
        v_return                        t_osi_reference.description%type;
    begin
        --See if we can find a users pay category sid
        for k in (select pay_category
                    from t_osi_personnel
                   where SID = p_obj_or_sid)
        loop
            v_personnels_pay_category_sid := k.pay_category;
        end loop;

        select description
          into v_return
          from t_osi_reference
         where SID = v_personnels_pay_category_sid
            or SID = p_obj_or_sid;

        return v_return;
    exception
        when others then
            log_error('get_pay_category_desc: ' || sqlerrm);
            return 'get_pay_category_desc: Error';
    end get_pay_category_desc;

    /* Gets the LOV for Experience Types */
    function get_experience_lov(p_current_val in varchar2 := null)
        return varchar2 is
        v_rtn    varchar2(32000);
        v_temp   varchar2(1000);
    begin
        for a in (select   description, SID
                      from t_osi_personnel_exp_type
                     where (   active = 'Y'
                            or SID = nvl(p_current_val, 'null'))
                  order by seq, description)
        loop
            v_rtn := v_rtn || replace(a.description, ', ', ' / ') || ';' || a.SID || ',';
        end loop;

        v_rtn := rtrim(v_rtn, ',');
        return v_rtn;
    exception
        when others then
            log_error('get_experience_lov: ' || sqlerrm);
            return 'get_experience_lov: Error';
    end get_experience_lov;

    /* Tells if a specific username is currently assigned to a Unit */
    function user_is_assigned_to_unit(p_username in varchar2)
        return number is
        v_user_sid   varchar2(20);
    begin
        begin
            --Get SID of this username
            select SID
              into v_user_sid
              from t_core_personnel
             where upper(login_id) = upper(p_username);
        exception
            when no_data_found then
                --Invalid username, return 2
                return 2;
        end;

        if (osi_personnel.get_current_unit(v_user_sid) is null) then
            --No Unit, return 0
            return 0;
        else
            --Has unit, return 1
            return 1;
        end if;
    exception
        when others then
            log_error('user_is_assigned_to_unit: ' || sqlerrm);
            return 0;
    end user_is_assigned_to_unit;

    /* Tells if the user is a foreign national */
    function user_is_foreign_nat(p_obj in varchar2)
        return varchar2 is
        v_temp   varchar2(20);
    begin
        select foreign_national
          into v_temp
          from t_osi_personnel
         where SID = p_obj;

        if (v_temp = 'N') then
            return 'N';
        else
            return 'YesOrUnknown';
        end if;
    exception
        when others then
            log_error('user_is_foreign_nat: ' || sqlerrm);
            raise;
    end user_is_foreign_nat;

    /* Ends a current unit assignment if one exists, and assigns them to the new unit */
    function assign_to_unit(
        p_obj           in   varchar2,
        p_unit          in   varchar2,
        p_assign_cat    in   varchar2,
        p_assign_date   in   date)
        return varchar2 is
    begin
        --End current unit assignment
        update t_osi_personnel_unit_assign
           set end_date = p_assign_date
         where personnel = p_obj and end_date is null;

        --Create new unit assignment record
        insert into t_osi_personnel_unit_assign
                    (personnel, unit, assign_category, start_date)
             values (p_obj, p_unit, p_assign_cat, p_assign_date);

        return 'Ok';
    exception
        when others then
            log_error('OSI_PERSONNEL.assign_to_unit: ' || sqlerrm);
            return sqlerrm;
    end assign_to_unit;

    /* Transfers roles when a personnel is reassigned to a different unit */
    function transfer_roles(
        p_obj            in   varchar2,
        p_old_unit_sid   in   varchar2,
        p_new_unit_sid   in   varchar2,
        p_assign_date    in   date)
        return varchar2 is
        v_return          varchar2(20);
        v_cnt_trans       number       := 0;
        v_cnt_not_trans   number       := 0;
    begin
        --Steps:
        --1.> Loop through Roles
        --2.> End Role
        --3.> If role is marked with "Keep On Transfer", then create new role with
        --    exact same parameters, but for the new unit sid.
        for k in (select opur.SID as opur_sid, opur.unit as opur_unit,
                         opur.assign_role as opur_assign_role, opur.grantable as opur_grantable,
                         opur.enabled as opur_enabled,
                         opur.include_subords as opur_include_subords,
                         oar.keep_on_transfer as oar_keep_on_transfer
                    from t_osi_personnel_unit_role opur, t_osi_auth_role oar
                   where opur.personnel = p_obj
                     --End roles with future end dates as well
                     and (   opur.end_date is null
                          or end_date > sysdate)
                     and opur.assign_role = oar.SID)
        loop
            --End Roles
            update t_osi_personnel_unit_role
               set end_date = p_assign_date
             where SID = k.opur_sid;

            --Check for Keep On Transfer
            --(Only transfer roles that have NO UNIT_SID or the outoging UNIT_SID
            --      -AND-
            --KEEP_ON_TRANSFER is set to Y
            if (    (   k.opur_unit is null
                     or k.opur_unit = p_old_unit_sid)
                and k.oar_keep_on_transfer = 'Y') then
                --Still need to follow business rules at the unit level
                if (osi_auth.validate_role_creation(k.opur_assign_role, p_new_unit_sid, p_obj) is null) then
                    --Role is acceptable at the unit level, so create it
                    insert into t_osi_personnel_unit_role
                                (unit,
                                 personnel,
                                 assign_role,
                                 start_date,
                                 grantable,
                                 enabled,
                                 include_subords)
                         values (p_new_unit_sid,
                                 p_obj,
                                 k.opur_assign_role,
                                 p_assign_date,
                                 k.opur_grantable,
                                 k.opur_enabled,
                                 k.opur_include_subords);

                    v_cnt_trans := v_cnt_trans + 1;
                else
                    --Not transfered because unit cannot have more people assigned to this role
                    v_cnt_not_trans := v_cnt_not_trans + 1;
                end if;
            else
                --Not transfered because this is not a transferable role
                v_cnt_not_trans := v_cnt_not_trans + 1;
            end if;
        end loop;

        v_return := '~' || v_cnt_trans || '~' || v_cnt_not_trans || '~';
        return v_return;
    exception
        when others then
            log_error('OSI_PERSONNEL.transfer_roles: ' || sqlerrm);
            return sqlerrm;
    end transfer_roles;

    /* Transfers notifications when a personnel is reassigned to a different unit */
    procedure transfer_notifications(p_obj in varchar2, p_new_unit_sid in varchar2) is
    begin
        --Updates notifications marked with a UNIT.  If a notification is not marked with a
        --UNIT, it means the notification is for "All OSI", in which case we leave it that way.
        update t_osi_notification_interest
           set unit = p_new_unit_sid
         where personnel = p_obj and unit is not null;
    exception
        when others then
            log_error('OSI_PERSONNEL.transfer_notifications: ' || sqlerrm);
            raise;
    end transfer_notifications;

    /* Given a Personnel SID, return Y or N depending on whether the user has a valid email address or not */
    function has_valid_email_address(p_obj in varchar2)
        return varchar2 is
        v_have_allowed_address   boolean;
        v_allowed_addresses      varchar2(4000);
        v_user_email_address     t_osi_personnel_contact.value%type;
    begin
        --Set to false to start
        v_have_allowed_address := false;

        --Grab current primary email
        begin
            select value
              into v_user_email_address
              from t_osi_personnel_contact opc, t_osi_reference tor
             where opc.type = tor.SID and tor.code = 'EMLP' and opc.personnel = p_obj;
        exception
            when no_data_found then
                --If they have no email address at all, then they definetly don't have a valid one
                return 'N';
        end;

        --Get currently allowed addresses
        v_allowed_addresses :=
             core_list.convert_to_list(core_util.get_config('OSI.NOTIF_EMAIL_ALLOW_ADDRESSES'), ',');

        --See if their address is in the list.
        for cnt in 1 .. core_list.count_list_elements(v_allowed_addresses)
        loop
            if (substr(v_user_email_address,
                       instr(v_user_email_address, '@') + 1,
                       length(v_user_email_address)) =
                                                core_list.get_list_element(v_allowed_addresses, cnt)) then
                --Found it!
                v_have_allowed_address := true;
                exit;
            end if;
        end loop;

        if (v_have_allowed_address = true) then
            return 'Y';
        else
            return 'N';
        end if;
    exception
        when others then
            log_error('OSI_PERSONNEL.has_valid_email_address: ' || sqlerrm);
            raise;
    end has_valid_email_address;
end osi_personnel;
/



set define off;

CREATE OR REPLACE package body osi_status_proc as
/**
 * Air Force - Office Of Special Investigation
 *    _____  ___________________    _________.___
 *   /  _  \ \_   _____/\_____  \  /   _____/|   |
 *  /  /_\  \ |    __)   /   |   \ \_____  \ |   |
 * /    |    \|     \   /    |    \/        \|   |
 * \____|__  /\___  /   \_______  /_______  /|___|
 *         \/     \/            \/        \/
 *  Investigative Information Management System
 *  .___________    _____    _________
 *  |   \_____  \  /     \  /   _____/
 *  |   |/  ____/ /  \ /  \ \_____  \
 *  |   /       \/    Y    \/        \
 *  |___\_______ \____|__  /_______  /
 *              \/       \/        \/
 *  Lifecycle - Support Class
 *
 * @author - Richard Norman Dibble
 /******************************************************************************
   NAME:       OSI_STATUS_PROC
   PURPOSE:    Provides functionality status change processing in WebI2MS.

    REVISIONS:
    Date        Author           Description
    ----------  ---------------  ------------------------------------
    11-may-2009  Richard Dibble  Created this package
    26-May-2009  Richard Dibble  Added transfer_file
    29-May-2009  Richard Dibble  Added verify_user_created_last_sh
    01-Jun-2009  Richard Dibble  Added mark_closed_short_file and unmark_closed_short_file
    04-Jun-2009  Tim McGuffin    Modified clone_activity to account for non-core addresses
    05-Jun-2009  Tim McGuffin    Modified verify_user_created_last_sh to reference new version
                                 of OSI_STATUS_PROC.last_sh_create_by.
    23-Jun-2009  Richard Dibble  Fixed reopen_object after Tim broke it
    02-Jul-2009  Richard Dibble  Modified reset_restriction to handle new ACL/ACE setup
                                 Added is_activity, is_file and get_restriction_sid
    15-Jul-2009  Tim McGuffin    Added update_activity_close_date function and called it from close_activity.
    15-Jul-2009  Tim McGuffin    Modified action text in Reopen_object to just say "Reopen", instead of
                                 "ReOpen-Last Open State"
    23-Jul-2009  T. Whitehead    Added confirm_participant, unconfirm_participant.
    06-Oct-2009  T.McGuffin      Added clone_to_case procedure.
    08-Oct-2009  T.McGuffin      Added set_file_full_id procedure.
    06-Nov-2009  T. Whitehead    Added case_from_init_notif.
    07-Dec-2009  T.Whitehead     Added transfer_file_end_assignments.
    28-Jan-2009  T.Whitehead     Added source_burn and source_unburn.
    08-Feb-2010  R.Dibble        Added aapp_can_recall  
    09-Feb-2010  Richard Dibble  Added recall_aapp_file 
    16-Mar-2010  Richard Dibble  Added aapp_set_restriction_ap
    18-Mar-2010  Jason Faris     Added sar_phase_update
    09-Apr-2010  Jason Faris     Added reopen_sar  
    29-Apr-2010  T.Whitehead     Added deers_update_links.
    06-May-2010  JaNelle Horne   Added copy_special_interest
    12-May-2010  Jason Faris     Added poly_file_auto_transfer.
    12-May-2010  T.Whitehead     Added source_exists.
    18-May-2010  JaNelle Horne   Added copy_mission_area, autofill_summary_inv
    28-May-2010  JaNelle Horne   Added create_sum_complaint_rpt
    05-Jun-2010  Richard Dibble  Added act_clear_complete_date, act_clear_close_date
    06-Jun-2010  JaNelle Horne   Updated create_sum_complaint_rpt so that attachment type sid is pulled back
                                 based on obj_type
    22-Jun-2010  JaNelle Horne   Updated find_last_valid_return_point; missing a join in the query
                                 Updated create_sum_complaint_rpt so that it checks for existing SCR and deletes any
                                 before adding final SCR.
    23-Jun-2010  Jason Faris     Added case_clear_negative_indexes.
    19-Aug-2010  Richard Dibble  Added pmm_close_account, user_can_close_account
    20-Aug-2010  Richard Dibble  Added pmm_suspend_account, pmm_reopen_account, 
                                 user_can_reopen_account, pmm_handle_pw_reset,
                                 pmm_handle_fix_login_id, pmm_user_can_fix_login_id,
                                 pmm_check_for_active_assign   
    30-Aug-2010  Richard Dibble  Modified pmm_disable_password to handle effective date
                                 Modified pmm_suspend_account and pmm_close_account to handle effective date
    09-Nov-2010  Richard Dibble  Added check_for_old_partic_links
    02-Mar-2011  Tim Ward        CR#3725 - Added Source to clone_activity for Sourc Meet Activities.
    08-Mar-2011  Tim Ward        CR#3740 - poly_file_auto_transfer not always auto tranferring to correct
                                  previous unit, also had to delete one of the auto_transfer calls because
                                  it was auto transferring twice on HQ Rejection:

                                  DELETE FROM T_OSI_STATUS_CHANGE_PROC WHERE SID='22200000XQB';
                                  COMMIT;                                  
    22-Mar-2011  Tim Ward        CR#3760 - Changed pmm_close/suspend/reopen_account to include personnel_status_date.
    
******************************************************************************/
    
    c_pipe                  varchar2(100) := core_util.get_config('CORE.PIPE_PREFIX')
                                       || 'OSI_status_proc';
    v_clone_new_sid         varchar2(20)  := null;

    procedure log_error(p_msg in varchar2) is
    begin
        core_logger.log_it(c_pipe, p_msg);
    end log_error;
    
    -- Tells whether or not the given object is an activity
    function is_activity(p_obj in varchar2) return number is
    begin
        for K in (select SID from t_osi_activity where sid = p_obj)
        loop
            return 1;
        end loop;
    return 0; 
       exception
     
        when others then
            log_error('OSI_STATUS_PROC.is_activity: ' || sqlerrm);
            raise;
    end is_activity;
    
    -- Tells whether or not the given object is a file
        function is_file(p_obj in varchar2) return number is
    begin
        for K in (select SID from t_osi_file where sid = p_obj)
        loop
            return 1;
        end loop;
    return 0; 
       exception
     
        when others then
            log_error('OSI_STATUS_PROC.is_file: ' || sqlerrm);
            raise;
    end is_file;
    
    --Returns the SID of the given restriction
    function get_restriction_sid(p_restriction in varchar2) return varchar2 is
    begin
        for K in (select SID from t_osi_reference where description = p_restriction and usage = 'RESTRICTION')
        loop
            return k.sid;
        end loop;
           exception
     
        when others then
            log_error('OSI_STATUS_PROC.get_acl_sid: ' || sqlerrm);
            raise;
    end get_restriction_sid;
    

    --Handles restriction changes when switching units
    --(Assures that an activity restricted to "Assigned Personnel" can be
    --accessed by others in the newly assigned unit, etc.)
    procedure reset_restriction(p_obj in varchar2) is
        v_current_restriction_desc   varchar2(300);
        v_new_restriction            t_core_obj.acl%type;
    --The hard coding in this function was recomended by Tim McGuffin on 05/12/2009
    begin
        --Get new restriction
        v_new_restriction := get_restriction_sid('Unit and Assigned Personnel');
        
        --ACTIVITIES
        if (is_activity(p_obj) = 1) then
        
            --Get the current ACL
            select tor.DESCRIPTION
            into v_current_restriction_desc
            from t_osi_reference tor, t_osi_activity toa
            where toa.RESTRICTION = tor.SID(+) and toa.sid = p_obj;

            --If the ACL is "Assigned Personnel", then we need to change it to
            --Unit and Assigned Personnel
            if (v_current_restriction_desc = 'Assigned Personnel') then

                --Update T_CORE_OBJ with new ACL
                update t_osi_activity
                   set restriction = v_new_restriction
                 where sid = p_obj;
            end if;
        
        end if;
        
        --FILES
        if (is_file(p_obj) = 1) then
        
            --Get the current ACL
            select tor.DESCRIPTION
            into v_current_restriction_desc
            from t_osi_reference tor, t_osi_file tof
            where tof.RESTRICTION = tor.SID(+)  and tof.sid = p_obj;

            --If the ACL is "Assigned Personnel", then we need to change it to
            --Unit and Assigned Personnel
            if (v_current_restriction_desc = 'Assigned Personnel') then

                --Update T_CORE_OBJ with new ACL
                update t_osi_file
                   set restriction = v_new_restriction
                 where sid = p_obj;
            end if;
        
        end if;
        
    exception
        when others then
            log_error('OSI_STATUS_PROC.reset_restriction: ' || sqlerrm);
            raise;
    end reset_restriction;

    --Returns the creating unit of an activity
    function get_activity_create_by_unit(p_obj in varchar2)
        return varchar2 is
        v_return   t_osi_activity.assigned_unit%type;
    begin
        select creating_unit
          into v_return
          from t_osi_activity
         where sid = p_obj;

        return v_return;
    exception
        when others then
            log_error('OSI_STATUS_PROC.get_activity_create_by_unit: ' || sqlerrm);
            raise;
    end get_activity_create_by_unit;

    --Ends all assignments for the specified object
    procedure end_all_assignments(p_obj in varchar2) is
    begin
        update t_osi_assignment
           set end_date = sysdate
         where obj = p_obj and end_date is null;
    exception
        when others then
            log_error('OSI_STATUS_PROC.end_all_assignments: ' || sqlerrm);
            raise;
    end end_all_assignments;

    --Finds the last valid return point in the status history chain
    function find_last_valid_return_point(p_obj in varchar2)
        return varchar2 is
        v_return   varchar2(20) := '<none>';
    begin
        --This is using a cursor-for loop although it will only grab the first record, then exit.
        --It was left with this architecture in case we need to add some further code to it later.
        for k in (select os.SID
                    from t_osi_status_history osh, t_osi_status os, t_osi_status_return_points osrp
                   where os.SID = osrp.status_sid and osrp.active = 'Y' and osh.obj = p_obj and osh.status = os.SID
                     and (   osrp.OBJ_TYPE member of osi_object.get_objtypes(core_obj.get_objtype(p_obj))
                     or obj_type = core_obj.lookup_objtype('ALL'))
                   order by osh.create_on desc)
        loop
            v_return := k.sid;
            exit;
        end loop;

        return v_return;
    exception
        when others then
            log_error('OSI_STATUS_PROC.find_last_valid_return_point: ' || sqlerrm);
            raise;
    end find_last_valid_return_point;

    --Finds the number of days to use for a suspense date calculation
    function find_days_for_suspense(p_obj in varchar2)
        return number is
        v_number_of_days   t_core_config.setting%type;
    begin
/************************************************************************
--Below is the SQL from the fat client.  This will need to be implemented once
we have out Investigative File tables in place
--        SQL = " SELECT "
--        SQL = SQL & "    SPECIAL_INTEREST"
--        SQL = SQL & " FROM "
--        SQL = SQL & "    T_INVESTIGATIVE_FILE"
--        SQL = SQL & " WHERE "
--        SQL = SQL & "    SID in"
--        SQL = SQL & "       (select FYLE from T_FILE_CONTENT "
--        SQL = SQL & "        where ACTIVITY = '" & pActivitySID & "') "
--        SQL = SQL & "    and"
--        SQL = SQL & "    SPECIAL_INTEREST = '13'"
************************************************************************/
--Notes:05/15/2009
--Basicaly what happens is, you check the associated investigative files,
--see if there is one with a special interest of 13 or'Seven Burner',
--and IF SO, it uses core_util.GET_CONFIG('OSI.ACTIVITY_SUSPENSE_DATE_LIMIT_2') which is 5 days
--and IF NOT, it uses core_util.GET_CONFIG('OSI.ACTIVITY_SUSPENSE_DATE_LIMIT_1') which is 20 days

        --For now, we will just return 20 days
        return core_util.get_config('OSI.ACTIVITY_SUSPENSE_DATE_LIMIT_1');
    exception
        when others then
            log_error('OSI_STATUS_PROC.find_days_for_suspense: ' || sqlerrm);
            raise;
    end find_days_for_suspense;

    --Used for updating an activities create by unit
    procedure update_activity_create_by_unit(p_obj in varchar2, p_unit in number) is
        v_date   date;
    begin
        update t_osi_activity
           set creating_unit = p_unit;
    exception
        when others then
            log_error('OSI_STATUS_PROC.update_activity_create_by_unit: ' || sqlerrm);
            raise;
    end update_activity_create_by_unit;

    --Used for updating an activities suspense date
    procedure update_activity_suspense_date(p_obj in varchar2, p_num_of_days in number) is
        v_date   date;
    begin
        --See if there is already a suspense date
        select suspense_date
          into v_date
          from t_osi_activity
         where sid = p_obj;

        if (v_date is null) then
            v_date := sysdate + p_num_of_days;
        else
            v_date := v_date + p_num_of_days;
        end if;

        update t_osi_activity
           set suspense_date = v_date
         where sid = p_obj;
    exception
        when others then
            log_error('OSI_STATUS_PROC.update_activity_suspense_date: ' || sqlerrm);
            raise;
    end update_activity_suspense_date;

    --Used for updating an activities complete date
    procedure update_activity_complete_date(p_obj in varchar2, p_date in date) is
    begin
        --Set the activity Completed Date
        update t_osi_activity
           set complete_date = p_date
         where sid = p_obj;
    exception
        when others then
            log_error('OSI_STATUS_PROC.update_activity_complete_date: ' || sqlerrm);
            raise;
    end;

    --Used for updating an activities complete date
    procedure update_activity_close_date(p_obj in varchar2, p_date in date) is
    begin
        --Set the activity Close Date
        update t_osi_activity
           set close_date = p_date
         where sid = p_obj;
    exception
        when others then
            log_error('OSI_STATUS_PROC.update_activity_close_date: ' || sqlerrm);
            raise;
    end;

    --Used for updating activity unit assignment
    procedure update_activity_unit_assign(p_obj in varchar2, p_unit in varchar2) is
    begin
        update t_osi_activity
           set assigned_unit = p_unit
         where sid = p_obj;
    exception
        when others then
            log_error('OSI_STATUS_PROC.update_activity_unit_assign: ' || sqlerrm);
            raise;
    end update_activity_unit_assign;

    --Used for updating activity unit assignment
    procedure update_activity_aux_unit(p_obj in varchar2, p_unit in varchar2) is
    begin
        update t_osi_activity
           set aux_unit = p_unit
         where sid = p_obj;
    exception
        when others then
            log_error('OSI_STATUS_PROC.update_activity_aux_unit: ' || sqlerrm);
            raise;
    end update_activity_aux_unit;

    /* Used to process an activity on Completion */
    procedure complete_activity(
        p_obj          in   varchar2,
        p_parameter1   in   varchar2 := null,
        p_parameter2   in   varchar2 := null) is
    begin
        --Reassign the creating unit (used mainly when an aux unit completes an activity)
        update_activity_unit_assign(p_obj, get_activity_create_by_unit(p_obj));
        --Set the activity Completed Date
        update_activity_complete_date(p_obj, sysdate);
        --Reset Restriction.  This will only reset objects whose restriction is set to
        --"Assigned Personnel"
        reset_restriction(p_obj);
    exception
        when others then
            log_error('OSI_STATUS_PROC.complete_activity: ' || sqlerrm);
            raise;
    end complete_activity;

    /* Used to process an activity on Closure */
    procedure close_activity(
        p_obj          in   varchar2,
        p_parameter1   in   varchar2 := null,
        p_parameter2   in   varchar2 := null) is
    begin
        update_activity_close_date(p_obj, sysdate);
        end_all_assignments(p_obj);
    exception
        when others then
            log_error('OSI_STATUS_PROC.close_activity: ' || sqlerrm);
            raise;
    end close_activity;

    /* Used to process an activity on Re-Open */
    procedure reopen_object(
        p_obj          in   varchar2,
        p_parameter1   in   varchar2 := null,
        p_parameter2   in   varchar2 := null) is
        v_status_sid   t_OSI_STATUS.sid%type;
    begin
        --Get last allowable return point
        v_status_sid := find_last_valid_return_point(p_obj);
        --Change to tha status we just got from the find_last_valid_return_point() function
        OSI_STATUS.change_status_brute(p_obj, v_status_sid, 'Reopen');
        --Reset Restriction.  This will only reset objects whose restriction is set to
        --"Assigned Personnel"
        reset_restriction(p_obj);
    exception
        when others then
            log_error('OSI_STATUS_PROC.reopen_object: ' || sqlerrm);
            raise;
    end reopen_object;

    /* Used to process an activiting on Assignment of an Auxilary Unit */
    procedure assign_auxilary_unit(
        p_obj          in   varchar2,
        p_parameter1   in   varchar2 := null,
        p_parameter2   in   varchar2 := null) is
        v_suspense_days_to_use   number;
    begin
/*****************************************************************/
--Keep the descriptiopn below "Assign Auxillary Unit DET 401"
--Me.SHDescription.xValue = Me.SHDescription.Value & " " & pUnitName
--NOTE SURE HOW WE'RE GOING TO HANDLE THIS
--Might have to just update the last SH change that was made..
/*****************************************************************/

        --Update Unit Assignment
        update_activity_unit_assign(p_obj, p_parameter1);
        --Update aux unit
        update_activity_aux_unit(p_obj, p_parameter1);
        --Update the suspense date
        update_activity_suspense_date(p_obj, find_days_for_suspense(p_obj));
        --Update the completed date
        update_activity_complete_date(p_obj, null);
        --Reset Restriction.  This will only reset objects whose restriction is set to
        --"Assigned Personnel"
        reset_restriction(p_obj);
        
    exception
        when others then
            log_error('OSI_STATUS_PROC.assign_auxilary_unit: ' || sqlerrm);
            raise;
    end assign_auxilary_unit;

    /* Used to process an activity on Re-Call */
    procedure recall_activity(
        p_obj          in   varchar2,
        p_parameter1   in   varchar2 := null,
        p_parameter2   in   varchar2 := null) is
        test   number;
    begin
        --**Note: This function is virtually identical to reject_activity, but left seperate for differentiation
        --**>
        --Reassign the creating unit (used mainly when an aux unit completes an activity)
        update_activity_unit_assign(p_obj, get_activity_create_by_unit(p_obj));
        --Update aux unit
        update_activity_aux_unit(p_obj, null);
        --Update the suspense date
        update_activity_suspense_date(p_obj, null);
        --Reset Restriction.  This will only reset objects whose restriction is set to
        --"Assigned Personnel"
        reset_restriction(p_obj);
    exception
        when others then
            log_error('OSI_STATUS_PROC.recall_activity: ' || sqlerrm);
            raise;
    end recall_activity;

    /* Used to process an activity on Rejection */
    procedure reject_activity(
        p_obj          in   varchar2,
        p_parameter1   in   varchar2 := null,
        p_parameter2   in   varchar2 := null) is
        test   number;
    begin
        --**Note: This function is virtually identical to recall_activity, but left seperate for differentiation
        --**>
        --Reassign the creating unit (used mainly when an aux unit completes an activity)
        update_activity_unit_assign(p_obj, get_activity_create_by_unit(p_obj));
        --Update aux unit
        update_activity_aux_unit(p_obj, null);
        --Update the suspense date
        update_activity_suspense_date(p_obj, null);
        --Reset Restriction.  This will only reset objects whose restriction is set to
        --"Assigned Personnel"
        reset_restriction(p_obj);
    exception
        when others then
            log_error('OSI_STATUS_PROC.reject_activity: ' || sqlerrm);
            raise;
    end reject_activity;

    procedure case_from_init_notif(
        p_obj          in   varchar2,
        p_parameter1   in   varchar2 := null,
        p_parameter2   in   varchar2 := null) is
    begin
        v_clone_new_sid := osi_init_notification.create_case_file(p_obj);
    exception
        when others then
            log_error('case_from_init_notif' || sqlerrm);
            raise;
    end case_from_init_notif;
    /* Used to process an activity on Clone */
    procedure clone_activity(
        p_obj          in   varchar2,
        p_parameter1   in   varchar2 := null,
        p_parameter2   in   varchar2 := null) is
        v_core_obj_record           t_core_obj%rowtype;
        v_object_type               t_core_obj_type.sid%type;
        v_object_type_description   t_core_obj_type.description%type;
        v_new_sid                   varchar2(20);
        v_new_id                    varchar(20);
        v_temp t_osi_note.sid%type;
    begin
        --Set v_object_type
        v_object_type := core_obj.get_objtype(p_obj);

        --Set v_object_type_description
        select description
          into v_object_type_description
          from t_core_obj_type
         where sid = v_object_type;

        --Get new ID
        v_new_id := osi_object.get_next_id;

        --Get the Core_Obj Information
        select *
          into v_core_obj_record
          from t_core_obj
         where sid = p_obj;

        --Create t_core_obj record
        insert into t_core_obj
                    (obj_type, acl)
             values (v_core_obj_record.obj_type, v_core_obj_record.acl)
          returning sid
               into v_new_sid;

        --Set global clone sid
        v_clone_new_sid := v_new_sid;

        --Create t_osi_activity_record
        for k in (select *
                    from t_osi_activity
                   where sid = p_obj)
        loop
            insert into t_osi_activity
                        (sid,
                         id,
                         title,
                         narrative,
                         creating_unit,
                         assigned_unit,
                         activity_date,
                         source)
                 values (v_new_sid,
                         v_new_id,
                         'Copy of: ' || k.title,
                         k.narrative,
                         k.creating_unit,
                         k.assigned_unit,
                         k.activity_date,
                         k.source);
        end loop;

        --Set status
        OSI_STATUS.change_status_brute(v_new_sid,
                                       OSI_STATUS.get_starting_status(v_object_type),
                                       'Created');
        --Add Note
        v_temp := osi_note.add_note(v_new_sid,
                          osi_note.get_note_type(v_object_type, 'CLONE'),
                          'This ' || v_object_type_description || ' Activity was created from the '
                          || v_object_type_description || ' with ID# ' || v_new_id || '.');

        --Clone AddressList
        for k in (select *
                    from t_osi_address
                   where obj = p_obj)
        loop
            insert into t_osi_address
                        (obj,
                         address_type,
                         address_1,
                         address_2,
                         city,
                         state,
                         postal_code,
                         country,
                         start_date,
                         end_date,
                         known_date,
                         province,
                         geo_coords,
                         comments)
                 values (v_new_sid,
                         k.address_type,
                         k.address_1,
                         k.address_2,
                         k.city,
                         k.state,
                         k.postal_code,
                         k.country,
                         k.start_date,
                         k.end_date,
                         k.known_date,
                         k.province,
                         k.geo_coords,
                         k.comments);
        end loop;

        --Clone Assignment List
        for k in (select *
                    from t_osi_assignment
                   where obj = p_obj)
        loop
            insert into t_osi_assignment
                        (obj, personnel, assign_role, start_date, end_date, unit)
                 values (v_new_sid, k.personnel, k.assign_role, k.start_date, k.end_date, k.unit);
        end loop;

        --Clone Investigative Support
        --t_osi_mission_category, t_osi_mission
        for k in (select *
                    from t_osi_mission
                   where obj = p_obj)
        loop
            insert into t_osi_mission
                        (obj, obj_context, mission)
                 values (v_new_sid, k.obj_context, k.mission);
        end loop;

        --Clone Associated Files
        for k in (select *
                    from t_osi_assoc_fle_act
                   where activity_sid = p_obj)
        loop
            insert into t_osi_assoc_fle_act
                        (activity_sid, file_sid, resource_allocation)
                 values (v_new_sid, k.file_sid, k.resource_allocation);
        end loop;

        --Clone Participant List
        for k in (select *
                    from t_osi_partic_involvement
                   where obj = p_obj)
        loop
            insert into t_osi_partic_involvement
                        (obj,
                         participant_version,
                         involvement_role,
                         num_briefed,
                         action_date,
                         response,
                         response_date,
                         agency_file_num,
                         report_to_dibrs,
                         report_to_nibrs,
                         reason)
                 values (v_new_sid,
                         k.participant_version,
                         k.involvement_role,
                         k.num_briefed,
                         k.action_date,
                         k.response,
                         k.response_date,
                         k.agency_file_num,
                         k.report_to_dibrs,
                         k.report_to_nibrs,
                         k.reason);
        end loop;

        --Do special processing (per object), each object will need its own CLONE() procedure.
        execute immediate 'BEGIN ' || osi_object.get_obj_package(v_object_type) || '.CLONE('''
                          || p_obj || ''', ''' || v_new_sid || '''); END;';
    exception
        when others then
            log_error('OSI_STATUS_PROC.clone_activity: ' || sqlerrm);
            raise;
    end clone_activity;

    procedure clone_to_case(
        p_sid          in   varchar2,
        p_parameter1   in   varchar2 := null,
        p_parameter2   in   varchar2 := null) is
    begin
        v_clone_new_sid := osi_investigation.clone_to_case(p_sid);
    exception
        when others then
            log_error('clone_to_case: ' || sqlerrm);
            raise;
    end clone_to_case;


    /* Used to retrieve the SID of a recently cloned object */
    function get_cloned_sid
        return varchar2 is
    begin
        return v_clone_new_sid;
    exception
        when others then
            log_error('OSI_STATUS_PROC.get_cloned_sid: ' || sqlerrm);
            raise;
    end get_cloned_sid;

    /* Used to process a file transfer */
    procedure transfer_file(
        p_obj          in   varchar2,
        p_parameter1   in   varchar2 := null,
        p_parameter2   in   varchar2 := null) is
    begin
        --Set the owning unit
        osi_file.set_unit_owner(p_obj, p_parameter1, p_parameter2);
    exception
        when others then
            log_error('OSI_STATUS_PROC.transfer_file: ' || sqlerrm);
            raise;
    end transfer_file;

    /* Used to process a file being closed short */
    procedure mark_closed_short_file(
        p_obj          in   varchar2,
        p_parameter1   in   varchar2 := null,
        p_parameter2   in   varchar2 := null) is
    begin
        update t_osi_file
           set closed_short = 'Y'
         where sid = p_obj;
    exception
        when others then
            log_error('OSI_STATUS_PROC.mark_closed_short_file: ' || sqlerrm);
            raise;
    end mark_closed_short_file;

    /* Used to process a file being re-opened */
    procedure unmark_closed_short_file(
        p_obj          in   varchar2,
        p_parameter1   in   varchar2 := null,
        p_parameter2   in   varchar2 := null) is
    begin
        update t_osi_file
           set closed_short = null
         where sid = p_obj;
    exception
        when others then
            log_error('OSI_STATUS_PROC.unmark_closed_short_file: ' || sqlerrm);
            raise;
    end unmark_closed_short_file;

    /* Used to unarchive a file */
    procedure unarchive_file(
        p_obj          in   varchar2,
        p_parameter1   in   varchar2 := null,
        p_parameter2   in   varchar2 := null) is
        v_temp   varchar2(2000);
    begin
        --Parameter 1 should be the unit
        --Parameter 2 should be the reason

        --Set the owner to the new unit (if it is different than the current unit)
        if (p_parameter1 != osi_file.get_unit_owner(p_obj)) then
            if (p_parameter2 is null) then
                v_temp := 'Unarchive to a Different Unit';
            else
                v_temp := p_parameter2;
            end if;

            osi_file.set_unit_owner(p_obj, p_parameter1, v_temp);
            
            reset_restriction(p_obj);
        end if;

    exception
        when others then
            log_error('OSI_STATUS_PROC.unarchive_file: ' || sqlerrm);
            raise;
    end unarchive_file;

    /* Used to verify that the current user was the one that created the last status history record */
    function verify_user_created_last_sh(p_obj in varchar2)
        return varchar2 is
        v_return       varchar2(3000);
        v_created_by   varchar2(200);
    begin
        v_created_by := OSI_STATUS.last_sh_create_by(p_obj, null);

        if (core_context.personnel_name != v_created_by) then
            v_return := 'Only ' || v_created_by || ' can perform this operation.';
        else
            v_return := null;
        end if;

        return v_return;
    exception
        when others then
            log_error('verify_user_created_last_sh: ' || sqlerrm);
            raise;
    end verify_user_created_last_sh;
    
    procedure confirm_participant(
        p_obj          in   varchar2,
        p_parameter1   in   varchar2 := null,
        p_parameter2   in   varchar2 := null) is
    begin
        osi_participant.confirm(p_obj);
    exception
        when others then
            log_error('confirm_participant: ' || sqlerrm);
            raise;
    end confirm_participant;

    procedure unconfirm_participant(
        p_obj          in   varchar2,
        p_parameter1   in   varchar2 := null,
        p_parameter2   in   varchar2 := null) is
    begin
        osi_participant.unconfirm(p_obj);
    exception
        when others then
            log_error('unconfirm_participant: ' || sqlerrm);
            raise;
    end unconfirm_participant;

    procedure set_file_full_id(p_obj in varchar2,
                               p_parameter1 in varchar2 := null,
                               p_parameter2 in varchar2 := null) is
        v_ot_code t_core_obj_type.code%type;
        v_full_id t_osi_file.full_id%type;
    begin
        log_error('set_file_full_id called');

        v_full_id := osi_file.generate_full_id(p_obj);

        if v_full_id is not null then
        update t_osi_file
           set full_id = v_full_id
         where sid = p_obj;
        end if;
    exception when others then
            log_error('OSI_STATUS_PROC.set_file_full_id: ' || sqlerrm);
    end set_file_full_id;
    
    procedure source_burn(
        p_obj          in   varchar2,
        p_parameter1   in   varchar2 := null,
        p_parameter2   in   varchar2 := null) is
    begin
        osi_source.burn(p_obj);
    exception
        when others then
            log_error('source_burn: ' || sqlerrm);
    end source_burn;
    
    function source_exists(p_obj in varchar2)
        return varchar2 is
    begin
        return osi_source.already_exists(p_obj);
    exception
        when others then
            log_error('source_exists: ' || sqlerrm);
    end source_exists;
    
    procedure source_migrate(
        p_obj           in varchar2,
        p_parameter1    in varchar2 := null,
        p_parameter2    in varchar2 := null)is
    begin
        v_clone_new_sid := osi_source.migrate(p_obj);
    exception
        when others then
            log_error('source_migrate: ' || sqlerrm);
    end source_migrate;
    
    procedure source_unburn(
        p_obj          in   varchar2,
        p_parameter1   in   varchar2 := null,
        p_parameter2   in   varchar2 := null) is
    begin
        osi_source.unburn(p_obj);
    exception
        when others then
            log_error('source_unburn: ' || sqlerrm);
    end source_unburn;
    
    procedure transfer_file_end_assignments(
        p_obj          in   varchar2,
        p_parameter1   in   varchar2 := null,
        p_parameter2   in   varchar2 := null) is
    begin
        transfer_file(p_obj, p_parameter1, p_parameter2);
        end_all_assignments(p_obj);
    exception when others then
        log_error('transfer_file_end_assignments: ' || sqlerrm);
    end transfer_file_end_assignments;
    
    /* Determines whether or not a certain 110 file can be recalled (based on current status) */
    function aapp_can_recall(p_obj in varchar2)
        return varchar2 is
        v_return        varchar2(3000);
        --v_current_lifecycle_state t_osi_status_history
        v_status_code   varchar2(200);
        v_crlf varchar2(200) := Chr(13) ;
    begin
        --Need to lock out Recall during the following status states:
        --NW,CL,STA,RAA,ARCH
        v_status_code := osi_object.get_status_code(p_obj);

        if (v_status_code in ('NW','CL','STA','RAA','ARCH')) then
            v_return :=
                'Recall can not be done in the following lifecycle states:' || v_crlf || 'New' || v_crlf || 'Closed' || v_crlf || 'Sent to Archive' || v_crlf || 'Received At Archive' || v_crlf || 'Archived';
        else
            v_return := null;
        end if;

        return v_return;
    exception
        when others then
            log_error('aapp_can_recall: ' || sqlerrm);
            raise;
    end aapp_can_recall;
    
    procedure recall_aapp_file(
        p_obj          in   varchar2,
        p_parameter1   in   varchar2 := null,
        p_parameter2   in   varchar2 := null) is
        v_new_status    t_osi_status_history.status%type;
    begin
        --Append to Note (Done in After Update process in the Page [Page 5450])
        
        --Get last status (where TO and FROM status are different)
        -->There is no FROM and TO in STATUS_HISTORY
        for K in (select STATUS from t_osi_status_history
        where is_current = 'N' and obj = p_obj order by create_on desc)
        loop
            --Ordering descending, grab the first item and leave
            v_new_status := k.status;
            exit;
        end loop;        
        
        --Change Status to last [real] status (Check to see how this works in a 
        --loop.  Assuming the user might expect to move back multiple 
        --lifecycle steps??) [meaning we would have to find items where 
        --TO and FROM status were different, AND also not coupled by a recall] 
        --NOT DOING THIS: SEE COMMENT BELOW
        osi_status.CHANGE_STATUS_BRUTE(p_obj, v_new_status, 'Recalled To ' || osi_status.GET_STATUS_DESC(v_new_status));
        --Will not be handling looping.  So, it someone Recalls from Open to New, 
        --then Recalls again, it will recall back to Open.
        
    exception
        when others then
            log_error('OSI_STATUS_PROC.recall_aapp_file: ' || sqlerrm);
            raise;
    end recall_aapp_file;
    
    /* Used to change an AAPP (110 File)'s restriction to "Assigned Personnel" on close .  This stops personnel from seeing their own file. */
    procedure aapp_set_restriction_ap(
        p_obj          in   varchar2,
        p_parameter1   in   varchar2 := null,
        p_parameter2   in   varchar2 := null) is
        v_new_restriction            t_core_obj.acl%type;
        v_current_restriction_desc   varchar2(300);
    begin
        --Get new restriction
        v_new_restriction := get_restriction_sid('Assigned Personnel');

        --Get the current ACL
        select tor.description
          into v_current_restriction_desc
          from t_osi_reference tor, t_osi_file tof
         where tof.restriction = tor.sid(+) and tof.sid = p_obj;

        --If the ACL is "Assigned Personnel", then we need to change it to
        --Unit and Assigned Personnel
        if (v_current_restriction_desc = 'Unit and Assigned Personnel') then
            --Update T_CORE_OBJ with new ACL
            update t_osi_file
               set restriction = v_new_restriction
             where sid = p_obj;
        end if;
    exception
        when others then
            log_error('OSI_STATUS_PROC.aapp_set_restriction_ap: ' || sqlerrm);
            raise;
    end aapp_set_restriction_ap;

    /* Suspicious Activity (phase) status changes update the "follow-up suffix" */
    procedure sar_phase_update(p_obj in varchar2,
        p_parameter1   in   varchar2 := null,
        p_parameter2   in   varchar2 := null) is
        --v_current_lifecycle_state t_osi_status_history
        v_status_code   varchar2(200);
        v_cur_suffix    t_osi_a_suspact_report.followup_suffix%type;
        v_new_suffix    varchar2(50);
        v_version_char   varchar2(1);
    begin
        --get current status
        v_status_code := osi_object.get_status_code(p_obj);

        begin
            select followup_suffix
              into v_cur_suffix
              from t_osi_a_suspact_report
             where sid = p_obj;
        exception
            when NO_DATA_FOUND then
                 v_cur_suffix := '';
        end;

        v_version_char := nvl(substr(v_cur_suffix, 3), '');

        case v_status_code
            when 'SR' then--Submit for Review
            v_new_suffix := 'YN' || v_version_char; 
            when 'SP' then--Submit to Publish
            v_new_suffix := 'YY' || v_version_char; 
            when 'PU' then--Publish SAR
            v_new_suffix := 'NY' || v_version_char; 
            when 'OP' then--Create Echo
               if v_version_char is null then
                  v_version_char := 'a';
               else
                  v_version_char := CHR(ASCII(SUBSTR(v_version_char, 1, 1)) + 1);
               end if;
               v_new_suffix := 'NN' || v_version_char;
        end case;

        update t_osi_a_suspact_report set followup_suffix = v_new_suffix where sid = p_obj;

    exception
        when others then
            log_error('sar_phase_update: ' || sqlerrm);
            raise;
    end sar_phase_update; 

    /*Suspicious Activity "reopen" restores to the last phase transition */
    procedure reopen_sar(
    p_obj          in   varchar2,
    p_parameter1   in   varchar2 := null,
    p_parameter2   in   varchar2 := null) is
    v_cur_suffix    t_osi_a_suspact_report.followup_suffix%type;
    v_status_code   varchar2(100);
    v_to_status     varchar2(20);
    begin
        begin
            select followup_suffix
              into v_cur_suffix
              from t_osi_a_suspact_report
             where SID = p_obj;
        exception
            when NO_DATA_FOUND then
                v_cur_suffix := '';
        end;

        case nvl(substr(v_cur_suffix, 1, 2), '')
            when '' then                                --indicates no phase transitions
                v_status_code := 'CM';
            when 'YN' then                              --indicates last phase was: Submitted for Review
                v_status_code := 'SR';
            when 'YY' then                              --indicates last phase was: Submitted to Publish
                v_status_code := 'SP';
            when 'NY' then                              --indicates last phase was: Published
                v_status_code := 'PU';
            when 'NN' then/* This is special...indicates last phase was Echo created, then completed, closed, and re-opened.
                             In this case the status goes back to 'Published'*/
                v_status_code := 'PU';
        end case;

        select SID
          into v_to_status
          from t_osi_status
         where code = v_status_code;

        OSI_STATUS.change_status_brute(p_obj, v_to_status, 'Reopen');
        --Reset Restriction.  This will only reset objects whose restriction is set to
        --"Assigned Personnel"
        reset_restriction(p_obj);
    exception
        when OTHERS then
            log_error('reopen_sar error: ' || sqlerrm);
    end;   

    /*Used to copy special interests on Case when approved*/
    procedure copy_special_interest(
        p_obj          in   varchar2, 
        p_parameter1   in   varchar2 := null,
        p_parameter2   in   varchar2 := null) is
    
    begin
        
        --delete existing special interests with obj_context of 'A', if any

        delete from t_osi_mission
        where obj = p_obj
        and obj_context = 'A';

        --make copies of existing special interestes

        insert into t_osi_mission (obj, mission, obj_context)
            select obj, mission, 'A'
             from t_osi_mission
            where obj = p_obj
             and obj_context = 'I';

    exception
        when others then
            log_error('OSI_STATUS_PROC.copy_special_interest: ' || sqlerrm);
            raise;
    end copy_special_interest;

    procedure deers_update_links(
        p_obj          in   varchar2,
        p_parameter1   in   varchar2 := null,
        p_parameter2   in   varchar2 := null) is
        l_result varchar2(32767) := null;
    begin
        -- Status methods that execute AFTER do not have return values.
        l_result := osi_deers.update_all_pv_links(p_obj);
    exception
        when others then
            log_error('osi_status_proc.deers_update_links: ' || sqlerrm);
            raise;
    end deers_update_links;
    
    function check_for_old_partic_links(p_obj in varchar2)
        return varchar2 is
        l_yr_ago   date         := sysdate - 365;
        l_pv_sid   varchar2(50) := null;
    begin
        --Loop through activity participants tied to this file
        for i in (select activity_sid
                    from t_osi_assoc_fle_act
                   where file_sid = p_obj and modify_on > l_yr_ago)
        loop
            for j in (select pv.participant, z.participant_version
                        from v_osi_partic_act_involvement z,
                             t_osi_participant ip,
                             t_osi_participant_version pv
                       where z.activity = i.activity_sid
                         and z.participant_version = pv.sid
                         and pv.participant = ip.sid)
            loop
                begin
                    select sid
                      into l_pv_sid
                      from v_osi_participant_version
                     where participant = j.participant and sid = current_version;
                exception
                    when no_data_found then
                        l_pv_sid := null;
                end;

                if (l_pv_sid <> j.participant_version and l_pv_sid is not null) then
                    --update_pv_links(j.participant_version, l_pv_sid, i.activity_sid, false);
                    --Updatable link was found, return null and allow user to update
                    return null;
                end if;
            end loop;
        end loop;

        --Loop through file participants
        for m in (select pv.participant, f.participant_version
                    from v_osi_partic_file_involvement f,
                         t_osi_participant ip,
                         t_osi_participant_version pv
                   where f.file_sid = p_obj
                     and f.participant_version = pv.sid
                     and pv.participant = ip.sid)
        loop
            begin
                select sid
                  into l_pv_sid
                  from v_osi_participant_version
                 where participant = m.participant and sid = current_version;
            exception
                when no_data_found then
                    l_pv_sid := null;
            end;

            if (l_pv_sid <> m.participant_version and l_pv_sid is not null) then
                
                --Updatable link was found, return null and allow user to update
                return null;
            end if;
        end loop;

        return 'No Participant Links need updating.';
    exception
        when OTHERS then
            log_error('OSI_STATUS_PROC.check_for_old_partic_links: ' || sqlerrm || ' ' || dbms_utility.format_error_backtrace);
            raise;
    end check_for_old_partic_links;

    /* Used to transfer ownership of a Poly File automatically based on status. */
    procedure poly_file_auto_transfer(p_obj in varchar2, p_parameter1 in varchar2 := null, p_parameter2 in varchar2 := null) is
        
        v_transfer_reason  varchar2(500);
        v_prev_unit        varchar2(20);
        v_status_code      varchar2(200);
        
    begin
         v_status_code := osi_object.get_status_code(p_obj);
       
         select transition_comment into v_transfer_reason
           from t_osi_status_history
          where obj = p_obj
            and is_current = 'Y';
        
                      
         --- if 'Awaiting Approval' set the requesting_unit = Poly Auth Unit, if 'Awaiting ---
         ---    Closure' set the RPO Unit = Poly Auth Unit.                                ---
         case
             when v_status_code = 'AA' then
         
                 --- transfer ownership to Poly Auth Unit ---
                 transfer_file(p_obj, core_util.get_config('POLY_SID'), v_transfer_reason);
                 update t_osi_f_poly_file set requesting_unit = core_util.get_config('POLY_SID') where sid = p_obj;

             when v_status_code = 'AC' then

                 --- transfer ownership to Poly Auth Unit ---
                 transfer_file(p_obj, core_util.get_config('POLY_SID'), v_transfer_reason);
                 update t_osi_f_poly_file set rpo_unit = core_util.get_config('POLY_SID') where sid = p_obj;

             --- if status is reverting to 'New' or 'Open' transfer ownership to PREVIOUS unit. --- 
             when v_status_code in('NW','OP') then

                 for a in(select unit_sid from t_osi_f_unit
                                where file_sid = p_obj
                                  and end_date is not null
                                order by start_date desc)
                 loop
                     v_prev_unit := a.unit_sid;
                     exit;
                          
                 end loop;

                 --- transfer ownership to the previous unit ---
                 transfer_file(p_obj, v_prev_unit, v_transfer_reason); 

         end case;  
    
    exception
        when OTHERS then
            log_error('OSI_STATUS_PROC.POLY_FILE_AUTO_TRANSFER: ' || sqlerrm || ' ' || dbms_utility.format_error_backtrace);
            raise;
    end;

/*Used to copy mission area value at the time the investigative file was approved */
     procedure copy_mission_area(
        p_obj          in   varchar2, 
        p_parameter1   in   varchar2 := null,
        p_parameter2   in   varchar2 := null) is
    
    begin
           --make copies of existing mission areas

            update t_osi_f_investigation 
                set manage_by_appv = (select manage_by
                                        from t_osi_f_investigation
                                        where sid = p_obj
                                        and manage_by is not null)
                where sid = p_obj;

    exception
        when others then
            log_error('OSI_STATUS_PROC.copy_mission_area: ' || sqlerrm);
            raise;
    end copy_mission_area;

/*Used to fill in the summary of investigation if null and add default suffix when investigative
    file is approved. */
 procedure autofill_summary_inv(
         p_obj          in   varchar2, 
   p_parameter1   in   varchar2 := null,
   p_parameter2   in   varchar2 := null) is

    v_summary clob;

    
    begin 
 
   select summary_investigation
                 into v_summary
             from T_OSI_F_INVESTIGATION
   where sid = p_obj; 
   
    --Copy background into summary investigation if summary investigation is null
    
    if dbms_lob.getlength(v_summary) = 0 then

     update t_osi_f_investigation
      set summary_investigation = (select summary_allegation
                                                       from t_osi_f_investigation
                                                       where sid = p_obj)
       where sid = p_obj;
  
    end if;
    
  --Add default suffix to summary investigation

           update t_osi_f_investigation
    set summary_investigation = summary_investigation || core_util.get_config('OSI.INV_SUMMARY_SUFFIX')
   where sid = p_obj;
 
 exception
        when others then
            log_error('OSI_STATUS_PROC.autofill_summary_inv: ' || sqlerrm);
            raise;
    end autofill_summary_inv; 

procedure create_sum_complaint_rpt(
    p_obj          in   varchar2,
    p_parameter1   in   varchar2 := null,
    p_parameter2   in   varchar2 := null) is
        v_blob           blob;
        v_clob           clob;
        v_in Pls_Integer := 1;
        v_out Pls_Integer := 1;
        v_lang Pls_Integer := 0;
        v_warning Pls_Integer := 0;
        v_attach_count   varchar2(10);
begin
    -- Check for existing SCR and delete if any exist
    select count(*)
      into v_attach_count
      from t_osi_attachment a, t_osi_attachment_type at
     where a.obj = p_obj
       and a.type = at.SID
       and at.usage = 'REPORT'
       and at.code = 'CR';


       if(v_attach_count > 0) then

             delete from t_osi_attachment a
               where a.obj = p_obj
               and a.type =
                 (select SID
                    from t_osi_attachment_type
                   where (usage = 'REPORT' and code = 'CR')
                     and obj_type = core_obj.get_objtype(p_obj));

       end if;

    -- Create Summary Complaint Report
    DBMS_LOB.CREATETEMPORARY(v_blob, FALSE);
    DBMS_LOB.OPEN(v_blob, DBMS_LOB.LOB_READWRITE);
    v_clob := osi_investigation.summary_complaint_rpt(p_obj);
    --Attach complaint report to investigative file
    dbms_lob.converttoblob(v_blob, v_clob, dbms_lob.getlength(v_clob), v_in, v_out, 1 ,v_lang, v_warning);

    insert into t_osi_attachment
                (obj, type, content, storage_loc_type, description, mime_type, creating_personnel)
         values (p_obj,
                 (select SID
                    from t_osi_attachment_type
                   where (usage = 'REPORT' and code = 'CR')
                     and obj_type = core_obj.get_objtype(p_obj)),
                 v_blob,
                 'DB',
                 'Complaint Report-Final',
                 'application/msword',
                 core_context.personnel_sid);
exception
    when others then
        log_error('OSI_STATUS_PROC.create_sum_complaint_rpt: ' || sqlerrm);
        raise;
end create_sum_complaint_rpt;
    
   /* Clears the COMPLETE_DATE of an activity - Used for re-opening activities*/
    procedure act_clear_complete_date(
        p_obj          in   varchar2,
        p_parameter1   in   varchar2 := null,
        p_parameter2   in   varchar2 := null) is
    begin
        update t_osi_activity
           set complete_date = null
         where sid = p_obj;
    exception
        when others then
            log_error('OSI_STATUS_PROC.act_clear_complete_date: ' || sqlerrm);
            raise;
    end act_clear_complete_date;

    /* Clears the CLOSE_DATE of an activity - Used for re-opening activities*/
    procedure act_clear_close_date(
        p_obj          in   varchar2,
        p_parameter1   in   varchar2 := null,
        p_parameter2   in   varchar2 := null) is
    begin
        update t_osi_activity
           set close_date = null
         where sid = p_obj;
    exception
        when others then
            log_error('OSI_STATUS_PROC.act_clear_close_date: ' || sqlerrm);
            raise;
    end act_clear_close_date;

    /* At case approval, clear all subjects' negative DCII indications */
    procedure case_clear_negative_indexes(
        p_obj          in   varchar2,
        p_parameter1   in   varchar2 := null,
        p_parameter2   in   varchar2 := null) is
    begin
        update t_osi_dcii_intentions
           set include_in_index = null
         where investigation = p_obj
     and include_in_index = 'N';
    exception
        when others then
            log_error('OSI_STATUS_PROC.case_clear_negative_indexes: ' || sqlerrm);
            raise;
    end case_clear_negative_indexes;

    /* Used to disable a Personnel PW */
    procedure pmm_disable_password(p_obj in varchar2, p_effective_date in date) is
        v_effective_date date;
    begin
        --Get PW Expirt Effective Date
        if (p_effective_date is not null) then
            v_effective_date := p_effective_date;
        else
            v_effective_date := sysdate;
        end if;
        
        --Disable Password
        update t_core_personnel
           set pswd = 'DISABLED'
         where sid = p_obj;

        --Update Pswd Exp. date
        update t_core_personnel
           set pswd_expiration_date = v_effective_date - 30
         where sid = p_obj;
    exception
        when others then
            log_error('OSI_STATUS_PROC.pmm_disable_password: ' || sqlerrm);
            raise;
    end pmm_disable_password;

    /* Used to Close a Personnel File (User Account) */
    procedure pmm_close_account(
        p_obj          in   varchar2,
        p_parameter1   in   varchar2 := null,
        p_parameter2   in   varchar2 := null) is
        v_status   t_osi_personnel.personnel_status_sid%type;
        v_effective_date date;
    begin
        --Get Effective Date
        select effective_on 
          into v_effective_date  
          from t_osi_status_history
            where obj = p_obj and 
            create_on = (select max(create_on) from t_osi_status_history where obj = p_obj);
        
        --Disable Password
        pmm_disable_password(p_obj, v_effective_date);

        --End current unit assignment
        update t_osi_personnel_unit_assign
           set end_date = sysdate - 2
         where personnel = p_obj and end_date is null;

        --End roles
        update t_osi_personnel_unit_role
           set end_date = sysdate - 2
         where personnel = p_obj and end_date is null;

        --End privs
        update t_osi_personnel_priv
           set end_date = sysdate - 2
         where personnel = p_obj and end_date is null;

        --Clear Badge Number
        update t_osi_personnel
           set badge_num = null
         where sid = p_obj;

        --Update Personnel Status
        select sid
          into v_status
          from t_osi_reference
         where usage = 'PERSONNEL_STATUS' and
                code = 'CL';

        update t_osi_personnel
           set personnel_status_sid = v_status,
               personnel_status_date = v_effective_date
         where sid = p_obj;
    exception
        when others then
            log_error('OSI_STATUS_PROC.pmm_close_account: ' || sqlerrm);
            raise;
    end pmm_close_account;

    /* Used to verify that the current user is allowed to close the given account SID */
    function pmm_user_can_close_account(p_obj in varchar2)
        return varchar2 is
        v_return   varchar2(3000) := null;
    begin
        if (core_context.personnel_sid = p_obj) then
            v_return := 'You may not close your own Personnel Record.';
        end if;

        return v_return;
    exception
        when others then
            log_error('OSI_STATUS_PROC.pmm_user_can_close_account: ' || sqlerrm);
            raise;
    end pmm_user_can_close_account;

    /* Used to Suspend a Personnel File (User Account) */
    procedure pmm_suspend_account(
        p_obj          in   varchar2,
        p_parameter1   in   varchar2 := null,
        p_parameter2   in   varchar2 := null) is
        v_status   t_osi_personnel.personnel_status_sid%type;
        v_effective_date date;
    begin
        --Get Effective Date
        select effective_on 
          into v_effective_date  
          from t_osi_status_history
            where obj = p_obj and 
            create_on = (select max(create_on) from t_osi_status_history where obj = p_obj);
        
        
        --Disable Password
        pmm_disable_password(p_obj, v_effective_date);

        --Update Personnel Status
        select sid
          into v_status
          from t_osi_reference
         where usage = 'PERSONNEL_STATUS' and
                code = 'SU';

        update t_osi_personnel
           set personnel_status_sid = v_status,
               personnel_status_date = v_effective_date
         where sid = p_obj;
    exception
        when others then
            log_error('OSI_STATUS_PROC.pmm_suspend_account: ' || sqlerrm);
            raise;
    end pmm_suspend_account;

    /* Used to Reopen a Personnel File (User Account) */
    procedure pmm_reopen_account(
        p_obj          in   varchar2,
        p_parameter1   in   varchar2 := null,
        p_parameter2   in   varchar2 := null) is
        v_username   t_core_personnel.login_id%type;
        v_status     t_osi_personnel.personnel_status_sid%type;
        v_ok         varchar2(200);
        v_effective_date date;
    begin
        --Get Effective Date
        select effective_on 
          into v_effective_date  
          from t_osi_status_history
            where obj = p_obj and 
            create_on = (select max(create_on) from t_osi_status_history where obj = p_obj);

        --Get Username
        select login_id
          into v_username
          from t_core_personnel
         where sid = p_obj;

        --Reset Password
        v_ok := core_context.reset_pswd(v_username, core_util.get_config('CORE.PSWD_RESET'));

        --Update Personnel Status
        select sid
          into v_status
          from t_osi_reference
         where usage = 'PERSONNEL_STATUS' and
                code = 'OP';

        update t_osi_personnel
           set personnel_status_sid = v_status,
               personnel_status_date = v_effective_date
         where sid = p_obj;
    exception
        when others then
            log_error('OSI_STATUS_PROC.pmm_reopen_account: ' || sqlerrm);
            raise;
    end pmm_reopen_account;

    /* Used to verify that the current user is allowed to reopen the given account SID */
    function pmm_user_can_reopen_account(p_obj in varchar2)
        return varchar2 is
        v_return   varchar2(3000) := null;
    begin
        --Must be able to reset a PW
        if (osi_auth.check_for_priv('RESET_PW', core_obj.get_objtype(p_obj)) <> 'Y') then
            v_return :=
                'You do not have permission to reset a users password which is required to reopen an account.'
                || chr(13);
        end if;

        --Target Personnel must have a current Unit Assignment
        if (osi_personnel.get_current_unit(p_obj) is null) then
            v_return :=
                v_return
                || 'This account can only be re-opened if the Agent has been assigned to a Unit.';
        end if;

        return v_return;
    exception
        when others then
            log_error('OSI_STATUS_PROC.pmm_user_can_reopen_account: ' || sqlerrm);
            raise;
    end pmm_user_can_reopen_account;

    /* Used to reset password via the Actions Menu */
    procedure pmm_handle_pw_reset(
        p_obj          in   varchar2,
        p_parameter1   in   varchar2 := null,
        p_parameter2   in   varchar2 := null) is
        v_username   t_core_personnel.login_id%type;
        v_ok         varchar2(200);
    begin
        --Get Username
        select login_id
          into v_username
          from t_core_personnel
         where sid = p_obj;

        --Reset Password
        v_ok := core_context.reset_pswd(v_username, core_util.get_config('CORE.PSWD_RESET'));
    exception
        when others then
            log_error('OSI_STATUS_PROC.pmm_handle_pw_reset: ' || sqlerrm);
            raise;
    end pmm_handle_pw_reset;
    
    /* PMM: Used to Fix Login ID's via the Actions Menu */
    procedure pmm_handle_fix_login_id(
        p_obj          in   varchar2,
        p_parameter1   in   varchar2 := null,
        p_parameter2   in   varchar2 := null) is
        v_current_login_id t_core_personnel.LOGIN_ID%type;
        v_new_id            t_core_personnel.LOGIN_ID%type;
        v_orig_ln        varchar2(100);
        v_fi             varchar2(1);
        v_mi             varchar2(1);
        v_ln             varchar2(50);
        v_id             varchar2(30);
        v_fname         varchar2(100);
        v_mname         varchar2(100);
        v_lname         varchar2(100);
     
        begin
              --Get Old ID and other info
        select login_id, last_name, first_name, middle_name 
         into v_current_login_id, v_lname, v_fname, v_mname
          from t_core_personnel where sid = p_obj;
        
        
        --Save off Original Last Name (minus spaces and dashes and apostrophies)
        v_orig_ln := replace(v_lname, '-', '');
        v_orig_ln := replace(v_orig_ln, ' ', '');
        v_orig_ln := replace(v_orig_ln, '''', '');
        --Get first initial
        v_fi := substr(v_fname, 1, 1);
        --Get middle initial
        v_mi := substr(v_mname, 1, 1);
        --Put both together
        v_id := v_fi || v_mi;
        --Get Last Name
        v_ln := ltrim(upper(v_orig_ln), 8 - length(v_id));
        --Concatonate ID
        v_id := substr(v_id || v_ln, 0, 8);
        
        if (v_current_login_id <> v_id) then
            --If these two are the same, then the only thing we would be 
            --doing is incrementing the nunber at the end, which is pointless
            v_new_id := osi_personnel.CREATE_LOGIN_ID(v_fname, v_mname, v_lname);
                     
            update t_core_personnel
            set login_id = v_new_id where sid = p_obj;
        end if;
         
        exception
        when others then
            log_error('OSI_STATUS_PROC.pmm_handle_fix_login_id: ' || sqlerrm);
            raise;
    end pmm_handle_fix_login_id;
    
    
    /* PMM: Used to verify that the current user is allowed to fix a login ID on the given account SID */
    function pmm_user_can_fix_login_id(p_obj in varchar2)
      
      return varchar2 is
        v_return   varchar2(3000) := null;
    begin
         if (core_context.personnel_sid = p_obj) then
            v_return := 'You may not fix your own Login ID.';
        end if;

        return v_return;
    exception
        when others then
            log_error('OSI_STATUS_PROC.pmm_user_can_fix_login_id: ' || sqlerrm);
            raise;
    end pmm_user_can_fix_login_id;
    
    /*PMM: Returns message as to whether the object has open assignments. */
   function pmm_check_for_active_assign(p_obj in varchar2)
        return varchar2 is
        v_return   varchar2(3000) := null;
        v_act      boolean := false;
        v_file     boolean := false;
    begin
        for k in (select *
                    from t_osi_assignment oa
                   where personnel = p_obj
                     and end_date is null
                     and osi_object.get_objtype_code(core_obj.get_objtype(oa.obj)) like 'ACT%')
        loop
            v_act := true;
        end loop;

        for k in (select *
                    from t_osi_assignment oa
                   where personnel = p_obj
                     and end_date is null
                     and osi_object.get_objtype_code(core_obj.get_objtype(oa.obj)) like 'FILE%')
        loop
            v_file := true;
        end loop;

        if (v_act and v_file) then
            v_return :=
                'This user has current assignment(s) in both Activities and Files, are you sure you would like to perform this action?';
        elsif(v_act and not v_file) then
            v_return :=
                'This user has current assignment(s) in Activities, are you sure you would like to perform this action?';
        elsif(not v_act and v_file) then
            v_return :=
                'This user has current assignment(s) in Files, are you sure you would like to perform this action?';
        end if;

        return v_return;
    exception
        when others then
            log_error('OSI_STATUS_PROC.pmm_check_for_active_assign: ' || sqlerrm);
            raise;
    end pmm_check_for_active_assign;
 
end osi_status_proc;
/

