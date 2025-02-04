CREATE OR REPLACE TRIGGER WEBI2MS.OSI_NOTIFY_STATHIST_B_I_01
    AFTER INSERT
    ON T_OSI_STATUS_HISTORY
    REFERENCING NEW AS NEW OLD AS OLD
    FOR EACH ROW
declare
    v_file_rec       t_osi_file%rowtype;
    v_nl             varchar2(10)                              := chr(10);              -- new line
    v_general        t_osi_notification_event.specifics%type;
    v_specifics      t_osi_notification_event.specifics%type;
    v_cnt            number;
    v_med_afsc       t_core_config.setting%type;
    v_status_desc    varchar2(200);
    v_is_open_file   varchar2(2);

    function get_file_unit(pfile in varchar2)
        return varchar2 is
        v_unit   t_osi_f_unit.unit_sid%type;
    begin
        select unit_sid
          into v_unit
          from t_osi_f_unit
         where file_sid = pfile and end_date is null;

        return v_unit;
    exception
        when no_data_found then
            return null;
        when others then
            CORE_LOGGER.log_it('NOTIFICATION', 'STATHIST_B_I_02 Error: ' || sqlerrm);
            return null;
    end get_file_unit;
begin
    CORE_LOGGER.log_it('NOTIFICATION', '>> INSIDE OSI_STATHIST_B_I_0: SID' || :new.OBJ);
    --determine if this is a file about to be oppened.
    v_is_open_file := 'N';

    FOR g in (SELECT SID
                FROM T_OSI_FILE
               WHERE SID = :new.obj)
    loop
        Select UPPER(OSI_STATUS.GET_STATUS_DESC(:new.STATUS))
          into v_status_desc
          from dual;

        If v_status_desc = 'OPEN' then
            v_is_open_file := 'Y';
        end if;
    end loop;

    IF v_is_open_file = 'N' then
        CORE_LOGGER.log_it('NOTIFICATION', 'IS_OPEN_FILE=N');
        return;
    end if;

    CORE_LOGGER.log_it('NOTIFICATION', 'IS_OPEN_FILE=Y');

    -- This trigger records events that result from Investigative File Opens

    -- Get basic information about the file
    select *
      into v_file_rec
      from T_OSI_FILE
     where SID = :new.obj;

    if trunc(nvl(:new.effective_on, :new.create_on)) <> trunc(:new.create_on) then
        v_general := '; Effective Date: ' || to_char(:new.effective_on, 'dd-Mon-yyyy');
    end if;

    -- Determine if this is a Death Case (INV.DEATH) by looking at the
    -- associated offense codes.
    v_specifics := null;
    v_cnt := 0;

    for o in (select   dot.description
                  from T_dibrs_offense_type dot, t_osi_f_inv_offense q
                 where dot.SID = q.offense
                   and q.investigation = :new.obj
                   and (   dot.code like '0000A%'
                        or dot.nibrs_code like '09%')
              order by dot.description)
    loop
        v_cnt := v_cnt + 1;
        v_specifics := v_specifics || ' (' || v_cnt || ') ' || o.description;
    end loop;

    if v_specifics is not null then                                          -- we have a death case
        v_specifics := v_general || '; Death Offenses:' || v_specifics;
        v_specifics := ltrim(v_specifics, '; ');
        -- Insert the Event record(s)
        osi_notification.record_detection('INV.DEATH',
                                          :new.obj,
                                          'File: ' || v_file_rec.id || ' - ' || v_file_rec.title,
                                          :new.create_by,
                                          :new.create_on,
                                          get_file_unit(:new.obj),
                                          v_specifics);
    end if;

    -- Determine if this is a Sex Crime Case (INV.SEX) by looking at the
    -- associated offense codes.
    v_specifics := null;
    v_cnt := 0;

    for o in (select   dot.description
                  from t_dibrs_offense_type dot, t_osi_f_inv_offense g
                 where dot.SID = g.offense
                   and g.investigation = :new.obj
                   and (   dot.code like '120%'
                        or dot.code like '125%'
                        or dot.code in('134-B1', '134-B5', '134-B6')
                        or dot.code in('134-R1', '134-R2', '134-R5')
                        or dot.code in('134-C1'))
              order by dot.description)
    loop
        v_cnt := v_cnt + 1;
        v_specifics := v_specifics || ' (' || v_cnt || ') ' || o.description;
    end loop;

    if v_specifics is not null then                                           -- we have a sex crime
        v_specifics := v_general || '; Sex Offenses:' || v_specifics;
        v_specifics := ltrim(v_specifics, '; ');
        -- Insert the Event record(s)
        OSI_NOTIFICATION.record_detection('INV.SEX',
                                          :new.obj,
                                          'File: ' || v_file_rec.id || ' - ' || v_file_rec.title,
                                          :new.create_by,
                                          :new.create_on,
                                          get_file_unit(:new.obj),
                                          v_specifics);
    end if;

    -- Determine if this is a Fraud Crime Case (INV.FRAUD) by looking at the
    -- associated offense codes.
    v_specifics := null;
    v_cnt := 0;

    for o in (select   dot.description
                  from t_dibrs_offense_type dot, t_osi_f_inv_offense g
                 where dot.SID = g.offense
                   and g.investigation = :new.obj
                   and (   dot.code in('132-A-', '132-B-', '132-C-', '132-D-', '132-E-', '132-F-')
                        or dot.code in('083-A-', '083-B-'))
              order by dot.description)
    loop
        v_cnt := v_cnt + 1;
        v_specifics := v_specifics || ' (' || v_cnt || ') ' || o.description;
    end loop;

    if v_specifics is not null then                                         -- we have a Fraud crime
        v_specifics := v_general || '; Fraud Offenses:' || v_specifics;
        v_specifics := ltrim(v_specifics, '; ');
        -- Insert the Event record(s)
        OSI_NOTIFICATION.record_detection('INV.FRAUD',
                                          :new.obj,
                                          'File: ' || v_file_rec.id || ' - ' || v_file_rec.title,
                                          :new.create_by,
                                          :new.create_on,
                                          get_file_unit(:new.obj),
                                          v_specifics);
    end if;

    -- Determine if this is a Violent Crime Case (INV.VIOLENT) by looking at the
    -- associated description (ASSAULT) and/or offense codes.
    v_specifics := null;
    v_cnt := 0;

    for o in (select   dot.description
                  from t_dibrs_offense_type dot, t_osi_f_inv_offense g
                 where dot.SID = g.offense
                   and g.investigation = :new.obj
                   and (   (dot.description like 'ASSAULT:%' and dot.code <> '134-C1')
                        or dot.code like '114%'
                        or dot.code like '124%')
              order by dot.description)
    loop
        v_cnt := v_cnt + 1;
        v_specifics := v_specifics || ' (' || v_cnt || ') ' || o.description;
    end loop;

    if v_specifics is not null then                                       -- we have a violent crime
        v_specifics := v_general || '; Violent Offenses:' || v_specifics;
        v_specifics := ltrim(v_specifics, '; ');
        -- Insert the Event record(s)
        OSI_NOTIFICATION.record_detection('INV.VIOLENT',
                                          :new.obj,
                                          'File: ' || v_file_rec.id || ' - ' || v_file_rec.title,
                                          :new.create_by,
                                          :new.create_on,
                                          get_file_unit(:new.obj),
                                          v_specifics);
    end if;

/*
    -- Determine if medical personnel are being investigated by looking
    -- at the SA_SPECIALTY_CODE of the Subjects
    v_specifics := null;
    v_cnt := 0;
    v_med_afsc := get_config('NOTIF_MED');

    for s in (select   pv.name, pv.sa_specialty_code
                  from t_person_involvement_v2 pi, v_person_version pv
                 where pi.parent = :new.related_to
                   and pi.involvement_role = 'Subject'
                   and pv.sid = pi.person_version
                   and instr(v_med_afsc, '~' || upper(pv.sa_specialty_code) || '~') > 0
              order by pv.name)
    loop
        v_cnt := v_cnt + 1;
        v_specifics :=
               v_specifics || ' (' || v_cnt || ') ' || s.name || ' [' || s.sa_specialty_code || ']';
    end loop;

    if v_specifics is not null then                                   -- we have a medical personnel
        v_specifics := v_general || '; Medical Personnel:' || v_specifics;
        v_specifics := ltrim(v_specifics, '; ');
        -- Insert the Event record(s)
        notification_pkg.record_detection('INV.MEDICAL',
                                          :new.related_to,
                                          'File: ' || v_file_rec.id || ' - ' || v_file_rec.title,
                                          :new.create_by,
                                          :new.create_on,
                                          get_file_unit(:new.related_to),
                                          v_specifics);
    end if;

    -- Determine if subject or victim is member of organization
    -- that belongs to a MAJCOM

    -- Find impacted MAJCOMs
    for m in (select distinct pvc.org_majcom
                         from t_person_involvement_v2 pi, v_person_version_current pvc
                        where pi.parent = :new.related_to
                          and pi.involvement_role in('Subject', 'Victim')
                          and pvc.person = person.latest_org(pi.person_version, 'M')
                          and pvc.org_majcom is not null
                     order by pvc.org_majcom)
    loop
        -- Reset specifics for this MAJCOM
        v_specifics := null;
        v_cnt := 0;
        util.logger.log_it('I2MS.DEBUG', 'MAJCOM (' || m.org_majcom || ') Participants found');

        -- Find file participants in this MAJCOM
        for n in (select distinct pv.name, pvc.name as memorg_name
                             from t_person_involvement_v2 pi,
                                  v_person_version pv,
                                  v_person_version_current pvc
                            where pi.parent = :new.related_to
                              and pi.involvement_role in('Subject', 'Victim')
                              and pv.sid = pi.person_version
                              and pvc.person = person.latest_org(pv.sid, 'M')
                              and pvc.org_majcom = m.org_majcom
                         order by pv.name)
        loop
            v_cnt := v_cnt + 1;
            v_specifics :=
                     v_specifics || ' (' || v_cnt || ') ' || n.name || ' [' || n.memorg_name || ']';
        end loop;                                                                     -- Person Name

        v_specifics := v_general || '; MAJCOM Persons:' || v_specifics;
        v_specifics := ltrim(v_specifics, '; ');
        notification_pkg.record_detection('INV.MAJCOM.' || m.org_majcom,
                                          :new.related_to,
                                          'File: ' || v_file_rec.id || ' - ' || v_file_rec.title,
                                          :new.create_by,
                                          :new.create_on,
                                          get_file_unit(:new.related_to),
                                          v_specifics);
    end loop;                                                                              -- MAJCOM

    --- Determine if this is a Reservist ---
    ---v_specifics := null;
    ---v_cnt       := 0;
    ---for m in (select pvc.NAME from T_PERSON_INVOLVEMENT_V2 pi, v_person_version_current pvc
    ---          where pi.PARENT = :new.RELATED_TO and pi.INVOLVEMENT_ROLE in ('Subject','Victim') and (pvc.sa_reservist=-1 or pvc.sa_component='V')
    ---          order by pvc.sid)
    ---loop
    ---    util.logger.log_it('I2MS.DEBUG', 'Reservist Participants found');
    ---
    ---    v_cnt := v_cnt + 1;
    ---   v_specifics := v_specifics || ' (' || v_cnt || ') ' || m.NAME;
    ---
    ---    v_specifics := v_general || '; Reservist Persons:' || v_specifics;
    ---    v_specifics := ltrim(v_specifics, '; ');
    ---
    ---    Notification_Pkg.Record_Detection('INV.MAJCOM.AFRC', :new.RELATED_TO, 'File: ' || v_file_rec.ID || ' - ' || v_file_rec.TITLE, :new.CREATE_BY, :new.CREATE_ON, Get_File_Unit(:new.RELATED_TO), v_specifics);
    ---
    ---end loop;   --- Reservist ---

    --- Check the New AFRC Flag in the Case File ---
    v_specifics := null;
    v_cnt := 0;

    for m in (select *
                from t_investigative_file
               where sid = :new.related_to and afrc = -1)
    loop
        util.logger.log_it('I2MS.DEBUG', 'AFRC Flag Set for Case File');
        v_cnt := v_cnt + 1;
        v_specifics := v_specifics || ' (' || v_cnt || ') ' || v_file_rec.id;
        v_specifics := v_general || '; Cases Related to AFRC:  ' || v_specifics;
        v_specifics := ltrim(v_specifics, '; ');
        notification_pkg.record_detection('INV.MAJCOM.AFRC',
                                          :new.related_to,
                                          'File: ' || v_file_rec.id || ' - ' || v_file_rec.title,
                                          :new.create_by,
                                          :new.create_on,
                                          get_file_unit(:new.related_to),
                                          v_specifics);
    end loop;                                                                     ---  AFRC Flag ---
*/  
    -- Determine if this is a "Heads-Up" situation by looking at the
    -- Units to Notify data.
    v_specifics := null;
    v_cnt := 0;

    select osi_unit.GET_NAME(fu.unit_sid)
      into v_specifics
      from t_osi_f_unit fu
     where fu.file_sid = v_file_rec.sid and fu.end_date is null;

    v_specifics := 'Controlling Unit: ' || v_specifics;

    -- Insert the Event record(s)
    for u in (select unit_sid
                from t_osi_f_notify_unit
               where file_sid = :new.obj /*and usage = 'I'*/)  /* and usage = 'I' used in I2MS to separate summary of allegation 'A' 
                                                                  vs. summary of investigation 'I' case data */
    loop
        OSI_NOTIFICATION.record_detection('INV.HEADSUP',
                                          :new.OBJ,
                                          'File: ' || v_file_rec.id || ' - ' || v_file_rec.title,
                                          :new.create_by,
                                          :new.create_on,
                                          get_file_unit(:new.obj),
                                          v_specifics);
    end loop;

    
    -- Determine if this is a "SPOT" report by looking at the notification data.
    v_specifics := null;
    v_cnt := 0;

    --select count(*)
    --  into v_cnt
    --  from T_INVESTIGATIVE_FILE i
    --  where i.SID = :new.RELATED_TO
    --   and i.SPECIAL_INTEREST_APPV = '12';
    /*select count(*)
      into v_cnt
      from v_special_interest_areas i
     where i.fyle = :new.related_to and i.description = 'SPOT Report' and i.investorallegation = 'I';
    */
    Select                                          --M.OBJ, M.OBJ_CONTEXT, C.Description as MISSION
           Count(*)
      into v_cnt
      from T_OSI_MISSION M, T_OSI_MISSION_CATEGORY C
     where C.SID = M.MISSION(+) and M.OBJ = :new.obj and C.DESCRIPTION = 'SPOT Report'
           and M.OBJ_CONTEXT = 'I';

    if v_cnt > 0 then
        -- Insert the Event record(s)
        OSI_NOTIFICATION.record_detection('INV.SPOT',
                                          :new.obj,
                                          'File: ' || v_file_rec.id || ' - ' || v_file_rec.title,
                                          :new.create_by,
                                          :new.create_on,
                                          get_file_unit(:new.obj),
                                          v_specifics);
    end if;
-- Check for other notification events here (could be many)
exception
    when others then
        CORE_LOGGER.log_it('NOTIFICATION',
                           'OSI_NOTIFY_STATHIST_B_I_01: SID = ' || :new.SID || ' Error = '
                           || sqlerrm);
end;
/