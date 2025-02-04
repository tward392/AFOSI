-- "Set define off" turns off substitution variables. 
Set define off; 

CREATE OR REPLACE package osi_personnel as
/******************************************************************************
   name:     osi_personnel
   purpose:  provides functionality for personnel objects.

   revisions:
    date        author          description
    ----------  --------------  ------------------------------------
     17-apr-2009 t.mcguffin      created package
     28-apr-2009 t.mcguffin      added get_current_unit function
     08-may-2009 t.whitehead     Added create_instance function.
     28-may-2009 t.whitehead     Changed get_name and get_current_unit functions
                                 to accept null parameters.
     29-jul-2009 r.dibble        Added get_login_id,get_pswd_exp_date
     31-jul-2009 r.dibble        Added get_status_desc, get_status_date,get_deployment_points,
                                 get_Deployment_Points_assign and filled in guts of get_status
     03-aug-2009 r.dibble        Added get_pay_category_desc
     06-aug-2009 r.dibble        Added get_experience_lov
     05-oct-2009 r.dibble        Modified create_instance to accept middle name
     16-dec-2009 r.dibble        Added user_is_assigned_to_unit
     06-jan-2010 r.dibble        Added user_is_foreign_nat
     10-jun-2010 r.dibble        Added assign_to_unit
     11-jun-2010 r.dibble        Added transfer_roles
     13-jun-2010 r.dibble        Added transfer_notifications
     18-aug-2010 r.dibble        Added has_valid_email_address
     25-aug-2011 tim ward        CR#3866 - Making EMM Logging Evidence Faster by giving the Option to Print Tag Auto.
                                  Created T_OSI_PERSONNEL_SETTINGS to save the users value.
                                  Created get_user_setting and set_user_setting functions.
******************************************************************************/

    /* Creates a login ID based on F/M/L names. */
    --Note: This is only in the spec for debugging.  This can be removed.
    function create_login_id(p_fname in varchar2, p_mname in varchar2, p_lname in varchar2)
        return varchar2;

    /* Creates a new Personnel returning its SID. */
    function create_instance(
        p_fname   in   varchar2,
        p_mname   in   varchar2,
        p_lname   in   varchar2,
        p_ssn     in   varchar2)
        return varchar2;

    /* Given a personnel sid for p_obj, returns the personnel name in the common format.
       This function should be used anywhere a personnel name is used.
       If no parameter is given the current logged on personnel is used. */
    function get_name(p_obj in varchar2 := null)
        return varchar2;

    /* Given a personnel sid for p_obj, return  the personnel's tagline */
    function get_tagline(p_obj in varchar2)
        return varchar2;

    /* Given a personnel sid for p_obj, return a summary.  p_variant can be used
       to specify how the summary should be returned (i.e. HTML) */
    function get_summary(p_obj in varchar2, p_variant in varchar2 := null)
        return clob;

    /* Given a personnel sid for p_obj and a reference to a clob, will fill in
       the clob with the xml data to be used for the doc1 index */
    procedure index1(p_obj in varchar2, p_clob in out nocopy clob);

    /* Given a personnel sid for p_obj, return the current status of the personnel */
    function get_status(p_obj in varchar2)
        return varchar2;

    /* Given a personnel sid for p_obj, return the current status description of the personnel */
    function get_status_desc(p_obj in varchar2)
        return varchar2;

    /* Given a personnel sid for p_obj, return the current status date of the personnel */
    function get_status_date(p_obj in varchar2)
        return date;

    /* Given a personnel sid for p_obj, return the current unit sid of the personnel.
       If no parameter is given the current logged on personnel is used. */
    function get_current_unit(p_obj in varchar2 := null)
        return varchar2;

    /* Retreives the Login ID for the given user */
    function get_login_id(p_obj in varchar2)
        return varchar2;

    /* Retreives the users PSWD expiration date */
    function get_pswd_exp_date(p_obj in varchar2)
        return date;

    /* Returns the number of deployment points for this personnels assignment */
    function get_deployment_points_assign(
        p_obj         in   varchar2,
        p_unit        in   varchar2,
        p_startdate   in   date,
        p_enddate     in   date,
        p_category    in   varchar2)
        return number;

    /* Returns the number of deployment points for this personnel */
    function get_deployment_points(p_obj in varchar2)
        return number;

    /* Returns the pay category description for either a personnel SID or a pay_category sid */
    function get_pay_category_desc(p_obj_or_sid in varchar2)
        return varchar2;

    /* Gets the LOV for Experience Types */
    function get_experience_lov(p_current_val in varchar2 := null)
        return varchar2;

    /* Tells if a specific username is currently assigned to a Unit */
    function user_is_assigned_to_unit(p_username in varchar2)
        return number;

    /* Tells if the user is a foreign national */
    function user_is_foreign_nat(p_obj in varchar2)
        return varchar2;

    /* Ends a current unit assignment if one exists, and assigns them to the new unit */
    function assign_to_unit(
        p_obj           in   varchar2,
        p_unit          in   varchar2,
        p_assign_cat    in   varchar2,
        p_assign_date   in   date)
        return varchar2;

    /* Transfers roles when a personnel is reassigned to a different unit */
    function transfer_roles(
        p_obj            in   varchar2,
        p_old_unit_sid   in   varchar2,
        p_new_unit_sid   in   varchar2,
        p_assign_date    in   date)
        return varchar2;

    /* Transfers notifications when a personnel is reassigned to a different unit */
    procedure transfer_notifications(p_obj in varchar2, p_new_unit_sid in varchar2);
    
    /* Given a Personnel SID, return Y or N depending on whether the user has a valid email address or not */
    function has_valid_email_address(p_obj in varchar2) return varchar2;
    
    function get_user_setting(p_personnel in varchar2, p_setting_name varchar2, p_default_value varchar2 := null) return varchar2;

    function set_user_setting(p_personnel in varchar2, p_setting_name varchar2, p_value varchar2 := null) return varchar2;
    
end osi_personnel;
/


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
     25-aug-2011 tim ward        CR#3866 - Making EMM Logging Evidence Faster by giving the Option to Print Tag Auto.
                                  Created T_OSI_PERSONNEL_SETTINGS to save the users value.
                                  Created get_user_setting and set_user_setting functions.
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
    
    function get_user_setting(p_personnel in varchar2, p_setting_name varchar2, p_default_value varchar2 := null) return varchar2 is

            p_setting_value varchar2(4000);
                
    begin
         select setting_value into p_setting_value from T_OSI_PERSONNEL_SETTINGS
               where PERSONNEL=p_personnel and SETTING_NAME=p_setting_name;

         return p_setting_value;
         
    exception when others then

             return p_default_value;            

   end get_user_setting;
   
   function set_user_setting(p_personnel in varchar2, p_setting_name varchar2, p_value varchar2 := null) return varchar2 is

            p_does_setting_exist number;
                
   begin
        select count(*) into p_does_setting_exist from T_OSI_PERSONNEL_SETTINGS
              where PERSONNEL=p_personnel and SETTING_NAME=p_setting_name;

        if p_does_setting_exist = 0 then
          
          insert into t_osi_personnel_settings (personnel,setting_name,setting_value) values (p_personnel, p_setting_name, p_value);
          return 'NEW';            
          commit;
        
        else

          update t_osi_personnel_settings set setting_value=p_value where PERSONNEL=p_personnel and SETTING_NAME=p_setting_name;
          return 'UPDATED';            
        
        end if;
        
   exception when others then

            return 'ERROR';            

   end set_user_setting;
    
end osi_personnel;
/


GRANT EXECUTE ON  OSI_PERSONNEL TO IOL;
