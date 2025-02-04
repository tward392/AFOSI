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

      function get_file_unit(pfile in varchar2) return varchar2 is
        v_unit   t_osi_f_unit.unit_sid%type;
      begin
           select unit_sid into v_unit
             from t_osi_f_unit
            where file_sid = pfile 
              and end_date is null;

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

     FOR g in (SELECT SID FROM T_OSI_FILE WHERE SID=:new.obj)
     loop
         Select UPPER(OSI_STATUS.GET_STATUS_DESC(:new.STATUS)) into v_status_desc from dual;
         
         case v_status_desc
             
             when 'OPEN' then

                 v_is_open_file := 'Y';
             
             when 'INVESTIGATIVELY CLOSED' then

                 osi_notification.record_detection('FILE.INV_CLOSED',
                                                   :new.obj,
                                                   'File: ' || v_file_rec.id || ' - ' || v_file_rec.title,
                                                   :new.create_by,
                                                   :new.create_on,
                                                   get_file_unit(:new.obj),
                                                   'File has been Investigatively Closed.');
                         
         end case;

     end loop;

     IF v_is_open_file = 'N' then

       CORE_LOGGER.log_it('NOTIFICATION', 'IS_OPEN_FILE=N');
       return;

     end if;

     CORE_LOGGER.log_it('NOTIFICATION', 'IS_OPEN_FILE=Y');

     --- This trigger records events that result from Investigative File Opens ---

     --- Get basic information about the file ---
     select * into v_file_rec from T_OSI_FILE where SID=:new.obj;

     if trunc(nvl(:new.effective_on, :new.create_on)) <> trunc(:new.create_on) then

       v_general := '; Effective Date: ' || to_char(:new.effective_on, 'dd-Mon-yyyy');

     end if;

     ---  Determine if this is a Death Case (INV.DEATH) by looking at the associated offense codes. ---
     v_specifics := null;
     v_cnt := 0;

     for o in (select dot.description from T_dibrs_offense_type dot, t_osi_f_inv_offense q
                 where dot.SID = q.offense
                   and q.investigation = :new.obj
                   and dot.notification='DEATH'
              order by dot.description)
     loop
         v_cnt := v_cnt + 1;
         v_specifics := v_specifics || ' (' || v_cnt || ') ' || o.description;
     end loop;

     if v_specifics is not null then                                          -- we have a death case

       v_specifics := v_general || '; Death Offenses:' || v_specifics;
       v_specifics := ltrim(v_specifics, '; ');

       --- Insert the Event record(s) ---
       osi_notification.record_detection('INV.DEATH',
                                         :new.obj,
                                         'File: ' || v_file_rec.id || ' - ' || v_file_rec.title,
                                         :new.create_by,
                                         :new.create_on,
                                         get_file_unit(:new.obj),
                                         v_specifics);
     end if;

     --- Determine if this is a Sex Crime Case (INV.SEX) by looking at the associated offense codes. ---
     v_specifics := null;
     v_cnt := 0;

     for o in (select dot.description from t_dibrs_offense_type dot, t_osi_f_inv_offense g
                 where dot.SID = g.offense
                   and g.investigation = :new.obj
                   and dot.notification='SEX'
              order by dot.description)
     loop
         v_cnt := v_cnt + 1;
         v_specifics := v_specifics || ' (' || v_cnt || ') ' || o.description;
     end loop;

     if v_specifics is not null then                                           --- we have a sex crime ---

       v_specifics := v_general || '; Sex Offenses:' || v_specifics;
       v_specifics := ltrim(v_specifics, '; ');

       --- Insert the Event record(s) ---
       OSI_NOTIFICATION.record_detection('INV.SEX',
                                         :new.obj,
                                         'File: ' || v_file_rec.id || ' - ' || v_file_rec.title,
                                         :new.create_by,
                                         :new.create_on,
                                         get_file_unit(:new.obj),
                                         v_specifics);
     end if;

     --- Determine if this is a Fraud Crime Case (INV.FRAUD) by looking at the associated offense codes. ---
     v_specifics := null;
     v_cnt := 0;

     for o in (select dot.description from t_dibrs_offense_type dot, t_osi_f_inv_offense g
                 where dot.SID = g.offense
                   and g.investigation = :new.obj
                   and dot.notification='FRAUD'
              order by dot.description)
     loop
         v_cnt := v_cnt + 1;
         v_specifics := v_specifics || ' (' || v_cnt || ') ' || o.description;
     end loop;

     if v_specifics is not null then                                         --- we have a Fraud crime ---

       v_specifics := v_general || '; Fraud Offenses:' || v_specifics;
       v_specifics := ltrim(v_specifics, '; ');

       --- Insert the Event record(s) ---
       OSI_NOTIFICATION.record_detection('INV.FRAUD',
                                         :new.obj,
                                         'File: ' || v_file_rec.id || ' - ' || v_file_rec.title,
                                         :new.create_by,
                                         :new.create_on,
                                         get_file_unit(:new.obj),
                                         v_specifics);
     end if;

     --- Determine if this is a Violent Crime Case (INV.VIOLENT) by looking at the associated description (ASSAULT) and/or offense codes. ---
     v_specifics := null;
     v_cnt := 0;

     for o in (select dot.description from t_dibrs_offense_type dot, t_osi_f_inv_offense g
                 where dot.SID = g.offense
                   and g.investigation = :new.obj
                   and dot.notification='VIOLENT'
              order by dot.description)
     loop
         v_cnt := v_cnt + 1;
         v_specifics := v_specifics || ' (' || v_cnt || ') ' || o.description;
     end loop;

     if v_specifics is not null then                                       --- we have a violent crime ---
   
       v_specifics := v_general || '; Violent Offenses:' || v_specifics;
       v_specifics := ltrim(v_specifics, '; ');

       --- Insert the Event record(s) ---
       OSI_NOTIFICATION.record_detection('INV.VIOLENT',
                                         :new.obj,
                                         'File: ' || v_file_rec.id || ' - ' || v_file_rec.title,
                                         :new.create_by,
                                         :new.create_on,
                                         get_file_unit(:new.obj),
                                         v_specifics);
     end if;

    -- Determine if medical personnel are being investigated by looking
    -- at the SA_SPECIALTY_CODE of the Subjects
    v_specifics := null;
    v_cnt := 0;
    v_med_afsc :=  core_util.get_config('OSI.NOTIF_MED');

    for s in (select   pv.full_name, pv.sa_specialty_code
                  from t_osi_partic_involvement pi, v_osi_participant_version pv, t_osi_partic_role_type rt
                 where pi.obj = :new.obj
                   and rt.sid=pi.INVOLVEMENT_ROLE
                   and rt.role='Subject'
                   and pv.sid = pi.participant_version
                   and instr(v_med_afsc, '~' || upper(pv.sa_specialty_code) || '~') > 0
              order by pv.full_name)
    loop
        v_cnt := v_cnt + 1;
        v_specifics :=
               v_specifics || ' (' || v_cnt || ') ' || s.full_name || ' [' || s.sa_specialty_code || ']';
    end loop;

    if v_specifics is not null then                                   -- we have a medical personnel
        v_specifics := v_general || '; Medical Personnel:' || v_specifics;
        v_specifics := ltrim(v_specifics, '; ');
        -- Insert the Event record(s)
        osi_notification.record_detection('INV.MEDICAL',
                                          :new.obj,
                                          'File: ' || v_file_rec.id || ' - ' || v_file_rec.title,
                                          :new.create_by,
                                          :new.create_on,
                                          get_file_unit(:new.obj),
                                          v_specifics);
    end if;

    -- Determine if subject or victim is member of organization
    -- that belongs to a MAJCOM

    -- Find impacted MAJCOMs
    for m in (select distinct r.code as org_majcom
                         from t_osi_partic_involvement pi, v_osi_partic_version_current pvc, t_osi_partic_role_type rt, t_osi_reference r
                        where pi.obj = :new.obj
                          and rt.sid=pi.involvement_role
                          and rt.role in('Subject', 'Victim')
                          and pvc.person = osi_participant.latest_org(pi.participant_version, 'POUM')
                          and pvc.org_majcom is not null
                          and pvc.org_majcom=r.sid
                     order by org_majcom)
    loop
        -- Reset specifics for this MAJCOM
        v_specifics := null;
        v_cnt := 0;
        CORE_LOGGER.log_it('NOTIFICATION', 'MAJCOM (' || m.org_majcom || ') Participants found');

        -- Find file participants in this MAJCOM
        for n in (select distinct pv.full_name, pvc.ind_full_name as memorg_name
                             from t_osi_partic_involvement pi,
                                  v_osi_participant_version pv,
                                  v_osi_partic_version_current pvc,
                                  t_osi_partic_role_type rt,
                                  t_osi_reference r
                            where pi.obj = :new.obj
                              and rt.role in('Subject', 'Victim')
                              and pv.sid = pi.participant_version
                              and pvc.person = osi_participant.latest_org(pv.sid, 'POUM')
                              and pvc.org_majcom=r.sid
                              and r.code = m.org_majcom
                         order by pv.full_name)
        loop
            v_cnt := v_cnt + 1;
            v_specifics :=
                     v_specifics || ' (' || v_cnt || ') ' || n.full_name || ' [' || n.memorg_name || ']';
        end loop;                                                                     -- Person Name

        v_specifics := v_general || '; MAJCOM Persons:' || v_specifics;
        v_specifics := ltrim(v_specifics, '; ');
        osi_notification.record_detection('INV.MAJCOM.' || m.org_majcom,
                                          :new.obj,
                                          'File: ' || v_file_rec.id || ' - ' || v_file_rec.title,
                                          :new.create_by,
                                          :new.create_on,
                                          get_file_unit(:new.obj),
                                          v_specifics);
    end loop;                                                                              -- MAJCOM

    --- Check the New AFRC Flag in the Case File ---
    v_specifics := null;
    v_cnt := 0;

    for m in (select * from t_osi_f_investigation where sid=:new.obj and afrc='Y')
    loop
        v_cnt := v_cnt + 1;
        v_specifics := v_specifics || ' (' || v_cnt || ') ' || v_file_rec.id;
        v_specifics := v_general || '; Cases Related to AFRC:  ' || v_specifics;
        v_specifics := ltrim(v_specifics, '; ');
        osi_notification.record_detection('INV.MAJCOM.AFRC',
                                          :new.obj,
                                          'File: ' || v_file_rec.id || ' - ' || v_file_rec.title,
                                          :new.create_by,
                                          :new.create_on,
                                          get_file_unit(:new.obj),
                                          v_specifics);
    end loop;                                                                     ---  AFRC Flag ---
  
     --- Determine if this is a "Heads-Up" situation by looking at the Units to Notify data. ---
     v_specifics := null;
     v_cnt := 0;

     select osi_unit.GET_NAME(fu.unit_sid) into v_specifics
       from t_osi_f_unit fu
        where fu.file_sid=v_file_rec.sid 
          and fu.end_date is null;

     v_specifics := 'Controlling Unit: ' || v_specifics;

     --- Insert the Event record(s) ---
     for u in (select unit_sid from t_osi_f_notify_unit
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
    
     --- Determine if this is a "SPOT" report by looking at the notification data. ---
     v_specifics := null;
     v_cnt := 0;

     Select Count(*) into v_cnt
      from T_OSI_MISSION M, T_OSI_MISSION_CATEGORY C
     where C.SID = M.MISSION(+) and M.OBJ = :new.obj and C.DESCRIPTION = 'SPOT Report'
           and M.OBJ_CONTEXT = 'I';

     if v_cnt > 0 then

       --- Insert the Event record(s) ---
       OSI_NOTIFICATION.record_detection('INV.SPOT',
                                         :new.obj,
                                         'File: ' || v_file_rec.id || ' - ' || v_file_rec.title,
                                         :new.create_by,
                                         :new.create_on,
                                         get_file_unit(:new.obj),
                                         v_specifics);
     end if;

exception
    when others then
        CORE_LOGGER.log_it('NOTIFICATION', 'OSI_NOTIFY_STATHIST_B_I_01: SID = ' || :new.SID || ' Error = ' || sqlerrm);
end;
/



