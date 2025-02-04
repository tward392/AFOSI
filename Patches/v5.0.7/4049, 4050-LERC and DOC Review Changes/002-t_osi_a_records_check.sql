alter table t_osi_a_records_check
  add obj varchar2(20);

ALTER TABLE t_osi_a_records_check DROP CONSTRAINT FK_OSI_RECCHK_OBJ; 

ALTER TABLE WEBI2MS.T_OSI_A_RECORDS_CHECK ADD (
  CONSTRAINT FK_OSI_RECCHK_OBJ 
 FOREIGN KEY (OBJ) 
 REFERENCES WEBI2MS.T_CORE_OBJ (SID)
    ON DELETE CASCADE);
  


update t_osi_a_records_check set obj=sid;
commit;



CREATE OR REPLACE TRIGGER WEBI2MS.t_osi_a_records_check_b_i_sid
    before insert on t_osi_a_records_check for each row
begin
    if :new.SID is null then
       :new.SID := Core_Sidgen.NEXT_SID;
    end if;
end;
/



alter table t_osi_a_records_check
  add narrative clob;

update t_osi_a_records_check rc
  set narrative=(select narrative from t_osi_activity a where rc.sid=a.sid);
commit;

----update t_osi_activity set narrative=null where sid in (select sid from t_osi_a_records_check);
----commit;


alter table t_osi_a_records_check add activity_date date; 


update t_osi_a_records_check rc
  set activity_date=(select activity_date from t_osi_activity a where rc.sid=a.sid);
commit;


alter table t_osi_a_records_check add results varchar2(10);


ALTER TABLE t_osi_a_records_check  ADD (
  CONSTRAINT FK_OSI_A_RC_RESULTS 
 FOREIGN KEY (RESULTS) 
 REFERENCES T_OSI_A_RC_DR_RESULTS (CODE));














alter table t_osi_a_records_check add create_by varchar2(100);
alter table t_osi_a_records_check add create_on date;

alter table t_osi_a_records_check add modify_by varchar2(100);
alter table t_osi_a_records_check add modify_on date;

CREATE OR REPLACE TRIGGER WEBI2MS."OSI_RC_B_IU_TS" 
    before insert or update
    on t_osi_a_records_check
    for each row
/*
    This is a custom trigger. It is not generated like all the other _TS triggers.

    Modification History:
    18-Jan-2007 RWH     Added support for DOC2 thru DOC5.
    30-Jul-2008 TRM     Modified to not update Timestamps when re-indexing.
*/
declare
    V_WHO    Varchar2(100);
    V_WHEN   Date;
begin
    V_WHO := CORE_CONTEXT.PERSONNEL_NAME;

    if V_WHO is null then
        V_WHO := V( 'APP_USER');
    end if;

    if V_WHO is null then
        V_WHO := sys_context('USERENV', 'OS_USER');
    end if;

    if V_WHO is null then
        V_WHO := user;
    end if;

    V_WHEN := sysdate;

    if inserting then
        :new.CREATE_BY := V_WHO;
        :new.CREATE_ON := V_WHEN;
        :new.MODIFY_BY := V_WHO;
        :new.MODIFY_ON := V_WHEN;
    elsif not OSI_FTI.IS_REINDEXING then
        :new.MODIFY_BY := V_WHO;
        :new.MODIFY_ON := V_WHEN;
    end if;
end;
/







update t_osi_a_records_check rc
  set create_by=(select create_by from t_core_obj a where rc.sid=a.sid)
  where rc.create_by is null;
commit;

update t_osi_a_records_check rc
  set create_on=(select create_on from t_core_obj a where rc.sid=a.sid)
  where rc.create_on is null;
commit;

update t_osi_a_records_check rc
  set modify_by=(select modify_by from t_core_obj a where rc.sid=a.sid)
  where rc.modify_by is null;
commit;

update t_osi_a_records_check rc
  set modify_on=(select modify_on from t_core_obj a where rc.sid=a.sid)
  where rc.modify_on is null;
commit;






alter table t_osi_a_records_check modify (obj not null);




