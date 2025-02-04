alter trigger OSI_ACT_B_IUD_BUMP disable;

ALTER TABLE T_OSI_ACTIVITY ADD READY_FOR_REVIEW VARCHAR2(1) DEFAULT 'N';
ALTER TABLE T_OSI_ACTIVITY_LOOKUP ADD READY_FOR_REVIEW VARCHAR2(1) DEFAULT 'N';
ALTER TABLE T_OSI_ACTIVITY_LOOKUP ADD SIGNED_FORM_40_ATTACHED VARCHAR2(1) DEFAULT 'N';

declare
  v_signed_form40_count number;
begin
     for a in (select sid from t_osi_activity_lookup order by sid)
     loop
         select count(*) into v_signed_form40_count from t_osi_attachment attach,t_osi_attachment_type at,t_core_obj o,t_core_obj_type ot 
                where attach.obj=o.sid 
                  and o.obj_type=ot.sid
                  and attach.type=at.sid
                  and at.code='FFORM40'
                  and o.sid=a.sid;
         
         if (v_signed_form40_count > 0) then

           update t_osi_activity_lookup set signed_form_40_attached='Y' where sid=a.sid;
           commit;

         end if;
    end loop;
end;

alter trigger OSI_ACT_B_IUD_BUMP enable;




CREATE OR REPLACE VIEW V_OSI_ACTIVITY_SUMMARY
(SID, ID, TITLE, CREATE_ON, CREATE_BY, 
 RESTRICTION, ACTIVITY_DATE, CREATING_UNIT, ASSIGNED_UNIT, AUXILIARY_UNIT, 
 COMPLETE_DATE, SUSPENSE_DATE, CLOSE_DATE, CURRENT_STATUS, INV_SUPPORT, 
 NARRATIVE, OBJECT_TYPE_DESCRIPTION, OBJECT_TYPE_CODE, OBJECT_TYPE_SID, SUBSTANTIVE, 
 LEADERSHIP_APPROVED, READY_FOR_REVIEW)
AS 
select a.sid, a.id, a.title, o.create_on, o.create_by, a.restriction, a.activity_date,
           osi_unit.get_name(a.creating_unit) creating_unit,
           osi_unit.get_name(a.assigned_unit) assigned_unit,
           osi_unit.get_name(a.aux_unit) auxiliary_unit, a.complete_date, a.suspense_date,
           a.close_date, osi_object.get_status(a.sid) current_status,
           osi_activity.get_inv_support(a.sid) inv_support, a.narrative,
           ot.description as "OBJECT_TYPE_DESCRIPTION",
           ot.code as object_type_code,
           ot.sid as object_type_sid,
           substantive,
           leadership_approved,
           ready_for_review
      from t_core_obj o, t_osi_activity a, t_core_obj_type ot
     where a.sid = o.sid
       and o.obj_type=ot.sid
/


CREATE OR REPLACE TRIGGER "OSI_ACTIVITY_SUMMARY_IO_U_01" 
    instead of update
    on v_osi_activity_summary
    for each row
begin
    update t_osi_activity
       set title = :new.title,
           activity_date = :new.activity_date,
           restriction = :new.restriction,
           substantive = nvl(:new.substantive,'N'),
           leadership_approved = nvl(:new.leadership_approved,'N'),
           ready_for_review = nvl(:new.ready_for_review,'N')
     where sid = :new.sid;

    if nvl(:new.inv_support, 'null') <> nvl(:old.inv_support, 'null') then
        osi_activity.set_inv_support(:new.sid, :new.inv_support);
    end if;

    core_obj.bump(:new.sid);
end;
/


-- "Set define off" turns off substitution variables. 
Set define off; 

CREATE OR REPLACE PACKAGE OSI_ACT_LOOK_UPDATES AS
/******************************************************************************
   NAME:       OSI_ACT_LOOK_UPDATES
   PURPOSE:

   REVISIONS:
   Ver        Date        Author           Description
   ---------  ----------  ---------------  ------------------------------------
   1.0        12/28/2011  Administrator    1. Created this package.
              12/29/2011  wcc              Procedures to update the t_osi_activity_lookup table.  
                                            These are called from a schedule job every 2 minutes.
              11/26/2012  Tim Ward         CR#4165 - Added up_ready_for_review.
              12/13/2012  Wayne Combs      CR#4205 - Added UP_ACT_TYPE.
******************************************************************************/

   PROCEDURE UP_TITLE;
   PROCEDURE UP_CONUNIT;
   PROCEDURE UP_LEAD;
   PROCEDURE UP_NOLEAD;
   PROCEDURE UP_LEADAGT;
   PROCEDURE UP_COMPDATE;
   PROCEDURE UP_APPROVED;
   PROCEDURE UP_READY_FOR_REVIEW;
   PROCEDURE DEL_ACT;
   PROCEDURE ADD_ACT;
   PROCEDURE UP_ACT_TYPE;
   
END OSI_ACT_LOOK_UPDATES;
/


CREATE OR REPLACE PACKAGE BODY OSI_ACT_LOOK_UPDATES AS
/******************************************************************************
   NAME:       OSI_ACT_LOOK_UPDATES
   PURPOSE:

   REVISIONS:
   Ver        Date        Author           Description
   ---------  ----------  ---------------  ------------------------------------
   1.0        12/28/2011  Administrator    1. Created this package.
              12/29/2011  wcc              Procedures to update the t_osi_activity_lookup table.  
                                            These are called from a schedule job every 2 minutes.
              11/26/2012  Tim Ward         CR#4165 - Added up_ready_for_review.
              12/13/2012  Wayne Combs      CR#4205 - Added UP_ACT_TYPE.
******************************************************************************/

PROCEDURE UP_TITLE is 
current_record    ROWID := null;
cursor update_title is
  select w.rowid 
  from t_osi_activity_lookup w
  where   W.TITLE <> (select a.title from t_osi_activity a where a.sid = w.sid);
cursor update_title2 is
  select w2.rowid from t_osi_activity_lookup w2
   where w2.rowid = current_record
   for update nowait;
rec_to_update update_title2%ROWTYPE;
   
begin

for w_rec in update_title loop

  current_record := w_rec.rowid;
   
  begin
  
  open update_title2;
  fetch update_title2 into rec_to_update;
  
  --Update Title
  update t_osi_activity_lookup w
  set w.title = (select a.title from t_osi_activity a where a.sid = w.sid)
  where w.rowid =  rec_to_update.rowid;
  
  close update_title2;

  commit;

  exception
  when others then
  rollback;
  if update_title2%ISOPEN then
    close update_title2;
  end if;
  end;
 end loop;
 exception
  when others then
  rollback;
end up_title;

PROCEDURE up_conunit is 
current_record    ROWID := null;
cursor update_conunit is
  select w.rowid 
  from t_osi_activity_lookup w
  where w.controlling_unit_sid  <> (select a.assigned_unit from t_osi_activity a where a.sid = w.sid);
cursor update_conunit2 is
  select w2.rowid from t_osi_activity_lookup w2
   where w2.rowid = current_record
   for update nowait;
rec_to_update update_conunit2%ROWTYPE;
   
begin

for w_rec in update_conunit loop

  current_record := w_rec.rowid;
   
  begin
  
  open update_conunit2;
  fetch update_conunit2 into rec_to_update;
  
  -- Update Controlling Unit
 update t_osi_activity_lookup w
 set w.controlling_unit = (select Osi_Unit.get_name (a.assigned_unit) from t_osi_activity a where a.sid = w.sid), w.controlling_unit_sid = (select a.assigned_unit from t_osi_activity a where a.sid = w.sid)
 where w.rowid =  rec_to_update.rowid;
  
  close update_conunit2;

  commit;

  exception
  when others then
  rollback;
  if update_conunit2%ISOPEN then
    close update_conunit2;
  end if;
  end;
 end loop;
 exception
  when others then
  rollback;
end up_conunit;

PROCEDURE up_lead is
current_record    ROWID := null;
cursor update_lead is
  select w.rowid 
  from t_osi_activity_lookup w
  where w.sid in (select a.sid from t_osi_activity a where a.aux_unit = a.assigned_unit)
  and w.is_lead is null;
cursor update_lead2 is
  select w2.rowid from t_osi_activity_lookup w2
   where w2.rowid = current_record
   for update nowait;
rec_to_update update_lead2%ROWTYPE;
   
begin

for w_rec in update_lead loop

  current_record := w_rec.rowid;
   
  begin
  
  open update_lead2;
  fetch update_lead2 into rec_to_update;
  
  -- Update Lead and Suspense Date
  update t_osi_activity_lookup w
  set w.is_lead = 'Yes', W.SUSPENSE_DATE = (select to_date(a.suspense_date,'DD-MON-RRRR') from t_osi_activity a where a.sid = w.sid)
  where w.rowid =  rec_to_update.rowid;
  
  close update_lead2;

  commit;

  exception
  when others then
  rollback;
  if update_lead2%ISOPEN then
    close update_lead2;
  end if;
  end;
 end loop;
 exception
  when others then
  rollback;
end up_lead;

PROCEDURE up_nolead is
current_record    ROWID := null;
cursor update_nolead is
  select w.rowid 
  from t_osi_activity_lookup w
  where w.sid in (select a.sid from t_osi_activity a where a.aux_unit != a.assigned_unit)
  and w.is_lead is not null;
cursor update_nolead2 is
  select w2.rowid from t_osi_activity_lookup w2
   where w2.rowid = current_record
   for update nowait;
rec_to_update update_nolead2%ROWTYPE;
   
begin

for w_rec in update_nolead loop

  current_record := w_rec.rowid;
   
  begin
  
  open update_nolead2;
  fetch update_nolead2 into rec_to_update;
  
  -- End Lead
  update t_osi_activity_lookup w
  set w.is_lead = null
  where w.rowid =  rec_to_update.rowid;
  
  close update_nolead2;

  commit;

  exception
  when others then
  rollback;
  if update_nolead2%ISOPEN then
    close update_nolead2;
  end if;
  end;
 end loop;
 exception
  when others then
  rollback;
end up_nolead;

PROCEDURE up_leadagt is
current_record    ROWID := null;
cursor update_leadagt is
  select w.rowid 
  from t_osi_activity_lookup w
  where w.lead_agent <> (select Osi_Object.get_lead_agent_name (a.SID) from t_osi_activity a where a.sid = w.sid);
cursor update_leadagt2 is
  select w2.rowid from t_osi_activity_lookup w2
   where w2.rowid = current_record
   for update nowait;
rec_to_update update_leadagt2%ROWTYPE;
   
begin

for w_rec in update_leadagt loop

  current_record := w_rec.rowid;
   
  begin
  
  open update_leadagt2;
  fetch update_leadagt2 into rec_to_update;
  
  -- Update Lead Agent
  update t_osi_activity_lookup w
  set w.lead_agent =  Osi_Object.get_lead_agent_name (w.SID)
  where  w.rowid =  rec_to_update.rowid;
  
  close update_leadagt2;

  commit;

  exception
  when others then
  rollback;
  if update_leadagt2%ISOPEN then
    close update_leadagt2;
  end if;
  end;
 end loop;
 exception
  when others then
  rollback;
end up_leadagt;

PROCEDURE up_compdate is
current_record    ROWID := null;
cursor update_compdate is
  select w.rowid 
  from t_osi_activity_lookup w
  where w.date_completed is NULL 
     and exists (select 'x' from t_osi_activity a where a.sid = w.sid and a.complete_date is not null );
cursor update_compdate2 is
  select w2.rowid from t_osi_activity_lookup w2
   where w2.rowid = current_record
   for update nowait;
rec_to_update update_compdate2%ROWTYPE;
   
begin

for w_rec in update_compdate loop

  current_record := w_rec.rowid;
   
  begin
  
  open update_compdate2;
  fetch update_compdate2 into rec_to_update;
  
  -- Update Complete on Date
  update t_osi_activity_lookup w
  set w.date_completed = (select a.complete_date from t_osi_activity a where a.sid = w.sid)
  where  w.rowid =  rec_to_update.rowid;
  
  close update_compdate2;

  commit;

  exception
  when others then
  rollback;
  if update_compdate2%ISOPEN then
    close update_compdate2;
  end if;
  end;
 end loop;
 exception
  when others then
  rollback;
end up_compdate;

PROCEDURE del_act is
current_record    ROWID := null;
cursor delete_activity is
  select w.rowid 
  from t_osi_activity_lookup w
  where not exists (select 'x' from t_osi_activity a where a.sid = w.sid );

cursor delete_activity2 is
  select w2.rowid from t_osi_activity_lookup w2
   where w2.rowid = current_record
   for update nowait;
rec_to_update delete_activity2%ROWTYPE;
   
begin

for w_rec in delete_activity loop

  current_record := w_rec.rowid;
   
  begin
  
  open delete_activity2;
  fetch delete_activity2 into rec_to_update;
  
  -- Remove deleted activities
  delete from t_osi_activity_lookup w
 where  w.rowid =  rec_to_update.rowid;
  
  close delete_activity2;

  commit;

  exception
  when others then
  rollback;
  if delete_activity2%ISOPEN then
    close delete_activity2;
  end if;
  end;
 end loop;
 exception
  when others then
  rollback;
end del_act;

PROCEDURE add_act is
begin
-- Add any activities that might be missing (should not happen)
insert into t_osi_activity_lookup
 SELECT /*+INDEX(a PK_OSI_ACT) INDEX(o PK_CORE_OBJ) INDEX(ot PK_CORE_OBJTYP) */
         a.SID,
        'javascript:getObjURL('''
         || a.SID
         || ''');'
            AS url,
         a.ID AS ID,
         ot.description AS Activity_Type,
         a.title AS Title,
         Osi_Object.get_lead_agent_name (a.SID) AS Lead_Agent,
         DECODE (
            DECODE (DECODE (a.close_date, NULL, NULL, 'Closed'),
                    NULL, TO_CHAR (A.complete_DATE),
                    'Closed'),
            NULL, 'Open',
            'Closed', 'Closed',
            'Completed')
            AS Status,
         Osi_Unit.get_name (a.assigned_unit) as Controlling_Unit,
         a.assigned_unit as Controlling_Unit_Sid,
         TO_DATE (o.create_on, 'dd-Mon-rrrr') AS Created_On,
         'javascript:newWindow({page:5550,clear_cache:''5550'',name:''VLT'
         || a.sid
         || ''',item_names:''P0_OBJ'',item_values:'
         || ''
         || ''''
         || a.sid
         || ''''
         || ''
         || ',request:''OPEN''})'  AS VLT,
         o.create_by AS Created_By,
         DECODE (a.assigned_unit, a.aux_unit, 'Yes', NULL) Is_Lead,
         TO_DATE (a.complete_date, 'dd-Mon-rrrr') Date_Completed,
         TO_DATE (a.suspense_date, 'dd-Mon-rrrr') Suspense_Date,
         sysdate as updated_on,
         a.leadership_approved,
         a.ready_for_review,
         (select CASE WHEN count(*) > 0 THEN 'Y' ELSE 'N' END
          from t_osi_attachment attach,t_osi_attachment_type at where attach.obj=a.sid and attach.type=at.sid and at.code like 'FFORM40' and storage_loc_type='DB')
    FROM T_OSI_ACTIVITY a, T_CORE_OBJ_TYPE ot, T_CORE_OBJ o
   WHERE a.SID = o.SID AND o.obj_type = ot.SID 
   AND not exists (select 'x' from t_osi_activity_lookup x where x.sid = a.sid);
  commit;
  exception
  when others then
  rollback;
end add_act;
PROCEDURE UP_approved is 
current_record    ROWID := null;

cursor update_approved is
  select w.rowid 
  from t_osi_activity_lookup w
  where   W.leadership_approved <> (select a.leadership_approved from t_osi_activity a where a.sid = w.sid);
cursor update_approved2 is
  select w2.rowid from t_osi_activity_lookup w2
   where w2.rowid = current_record
   for update nowait;
rec_to_update update_approved2%ROWTYPE;
   
begin

for w_rec in update_approved loop

  current_record := w_rec.rowid;
   
  begin
  
  open update_approved2;
  fetch update_approved2 into rec_to_update;
  
  --Update Title
  update t_osi_activity_lookup w
  set w.leadership_approved = (select a.leadership_approved from t_osi_activity a where a.sid = w.sid)
  where w.rowid =  rec_to_update.rowid;
  
  close update_approved2;

  commit;

  exception
  when others then
  rollback;
  if update_approved2%ISOPEN then
    close update_approved2;
  end if;
  end;
 end loop;
 exception
  when others then
  rollback;
end up_approved;

PROCEDURE UP_ready_for_review is 
current_record    ROWID := null;

cursor update_ready_for_review is
  select w.rowid 
  from t_osi_activity_lookup w
  where   w.ready_for_review <> (select a.ready_for_review from t_osi_activity a where a.sid = w.sid);
cursor update_ready_for_review2 is
  select w2.rowid from t_osi_activity_lookup w2
   where w2.rowid = current_record
   for update nowait;
rec_to_update update_ready_for_review2%ROWTYPE;
   
begin

for w_rec in update_ready_for_review loop

  current_record := w_rec.rowid;
   
  begin
  
  open update_ready_for_review2;
  fetch update_ready_for_review2 into rec_to_update;
  
  --Update READY_FOR_REVIEW
  update t_osi_activity_lookup w
  set w.ready_for_review = (select a.ready_for_review from t_osi_activity a where a.sid = w.sid)
  where w.rowid =  rec_to_update.rowid;
  
  close update_ready_for_review2;

  commit;

  exception
  when others then
  rollback;
  if update_ready_for_review2%ISOPEN then
    close update_ready_for_review2;
  end if;
  end;
 end loop;
 exception
  when others then
  rollback;
end up_ready_for_review;

PROCEDURE UP_ACT_TYPE is 
current_record    ROWID := null;
cursor update_act_type is
  select w.rowid 
  from t_osi_activity_lookup w
  where   W.ACTIVITY_TYPE <> (select A.DESCRIPTION from t_core_obj_type a, t_core_obj b where a.sid = B.OBJ_TYPE and B.SID = W.SID );
cursor update_act_type2 is
  select w2.rowid from t_osi_activity_lookup w2
   where w2.rowid = current_record
   for update nowait;
rec_to_update update_act_type2%ROWTYPE;

begin

for w_rec in update_act_type loop

  current_record := w_rec.rowid;
   
  begin
  
  open update_act_type2;
  fetch update_act_type2 into rec_to_update;
  
  --Update Activity Type
  update t_osi_activity_lookup w
  set W.ACTIVITY_TYPE = (select a.DESCRIPTION from t_core_obj_type a, t_core_obj b where a.sid = B.OBJ_TYPE and B.SID = W.SID)
  where w.rowid =  rec_to_update.rowid;
  
  close update_act_type2;

  commit;

  exception
  when others then
  rollback;
  if update_act_type2%ISOPEN then
    close update_act_type2;
  end if;
  end;
 end loop;
 exception
  when others then
  rollback;
 end up_act_type;

END OSI_ACT_LOOK_UPDATES;
/

--277 

DECLARE
  X NUMBER;
BEGIN
  SYS.DBMS_JOB.SUBMIT
  ( job       => X 
   ,what      => 'begin
OSI_ACT_LOOK_UPDATES.UP_TITLE;
OSI_ACT_LOOK_UPDATES.UP_CONUNIT;
OSI_ACT_LOOK_UPDATES.UP_LEAD;
OSI_ACT_LOOK_UPDATES.UP_NOLEAD;
OSI_ACT_LOOK_UPDATES.UP_LEADAGT;
OSI_ACT_LOOK_UPDATES.UP_COMPDATE;
OSI_ACT_LOOK_UPDATES.DEL_ACT;
OSI_ACT_LOOK_UPDATES.ADD_ACT;
OSI_ACT_LOOK_UPDATES.UP_APPROVED;
OSI_ACT_LOOK_UPDATES.UP_READY_FOR_REVIEW;
OSI_ACT_LOOK_UPDATES.UP_ACT_TYPE;
end;'
   ,next_date => to_date('26/11/2012 08:12:56','dd/mm/yyyy hh24:mi:ss')
   ,interval  => 'SYSDATE+2/1440 '
   ,no_parse  => FALSE
  );
END;
/


CREATE OR REPLACE VIEW V_OSI_ASSOC_FLE_ACT
(SID, FILE_SID, FILE_ID, FILE_TITLE, FILE_TYPE_DESC, 
 ACTIVITY_SID, ACTIVITY_ID, ACTIVITY_TITLE, ACTIVITY_TYPE_DESC, ACTIVITY_COMPLETE_DATE, 
 ACTIVITY_CLOSE_DATE, ACTIVITY_DATE, ACTIVITY_SUSPENSE_DATE, ACTIVITY_UNIT_ASSIGNED, SUBSTANTIVE, 
 LEADERSHIP_APPROVED, READY_FOR_REVIEW, SOURCE, ACTIVITY_TYPE_CODE, FILE_TYPE_CODE, FORM40ATTACHED)
AS 
select oafa.sid, oafa.file_sid, of1.id as "FILE_ID", of1.title as "FILE_TITLE",
           cot1.description as "FILE_TYPE_DESC", oafa.activity_sid, oa.id as "ACTIVITY_ID",
           oa.title as "ACTIVITY_TITLE", cot2.description as "ACTIVITY_TYPE_DESC",
           oa.complete_date as "ACTIVITY_COMPLETE_DATE", oa.close_date as "ACTIVITY_CLOSE_DATE",
           oa.activity_date as "ACTIVITY_DATE", oa.suspense_date as "ACTIVITY_SUSPENSE_DATE", 
           osi_unit.get_name(oa.assigned_unit) as "ACTIVITY_UNIT_ASSIGNED",
           oa.substantive as "SUBSTANTIVE",
           oa.leadership_approved as "APPROVED",
           oa.ready_for_review as "READY_FOR_REVIEW",
           oa.source as "SOURCE",
           cot2.code as "ACTIVITY_TYPE_CODE",
           cot1.code as "FILE_TYPE_CODE",
           alup.signed_form_40_attached as "FORM40ATTACHED"
    from   t_osi_assoc_fle_act oafa,
           t_osi_file of1,
           t_core_obj co1,
           t_core_obj_type cot1,
           t_osi_activity oa,
           t_core_obj co2,
           t_core_obj_type cot2,
           t_osi_activity_lookup alup
     where of1.sid = oafa.file_sid
       and of1.sid = co1.sid
       and cot1.sid = co1.obj_type
       and oa.sid = oafa.activity_sid
       and oa.sid = co2.sid
       and cot2.sid = co2.obj_type
       and oa.sid=alup.sid(+)
/



CREATE OR REPLACE VIEW V_OSI_ASSOC_SOURCE_MEET
(SID, FILE_SID, FILE_ID, FILE_TITLE, FILE_TYPE_DESC, 
 ACTIVITY_SID, ACTIVITY_ID, ACTIVITY_TITLE, ACTIVITY_TYPE_DESC, ACTIVITY_COMPLETE_DATE, 
 ACTIVITY_CLOSE_DATE, ACTIVITY_DATE, ACTIVITY_SUSPENSE_DATE, ACTIVITY_UNIT_ASSIGNED, SUBSTANTIVE, 
 LEADERSHIP_APPROVED, READY_FOR_REVIEW, FORM40ATTACHED)
AS 
select oasm.sid, of1.sid, of1.id as "FILE_ID", of1.title as "FILE_TITLE",
           cot1.description as "FILE_TYPE_DESC", oasm.sid, oa.id as "ACTIVITY_ID",
           oa.title as "ACTIVITY_TITLE", cot2.description as "ACTIVITY_TYPE_DESC",
           oa.complete_date as "ACTIVITY_COMPLETE_DATE", oa.close_date as "ACTIVITY_CLOSE_DATE",
           oa.activity_date as "ACTIVITY_DATE", oa.suspense_date as "ACTIVITY_SUSPENSE_DATE", 
           osi_unit.get_name(oa.assigned_unit) as "ACTIVITY_UNIT_ASSIGNED",
           oa.substantive as "SUBSTANTIVE",
           oa.leadership_approved as "APPROVED",
           oa.ready_for_review as "READY_FOR_REVIEW",
           alup.signed_form_40_attached as "FORM40ATTACHED"
    from   t_osi_a_source_meet oasm,
           t_osi_file of1,
           t_core_obj co1,
           t_core_obj_type cot1,
           t_osi_activity oa,
           t_core_obj co2,
           t_core_obj_type cot2,
           t_osi_activity_lookup alup
     where of1.sid = co1.sid
       and cot1.sid = co1.obj_type
       and oa.sid = oasm.sid
       and oa.sid = co2.sid
       and cot2.sid = co2.obj_type
       and cot2.code='ACT.SOURCE_MEET'
       and oa.source=of1.sid
       and oa.sid=alup.sid(+)
/



set define off;

CREATE OR REPLACE PACKAGE BODY "OSI_DESKTOP" AS
/******************************************************************************
   Name:     osi_desktop
   Purpose:  Provides Functionality for OSI Desktop Views

   Revisions:
    Date        Author          Description
    ----------  --------------  ------------------------------------
    18-Oct-2010 Tim Ward        Created Package (WCGH0000264)
    02-Nov-2010 Tim Ward        WCHG0000262 - Notification Filters Missing
    16-Nov-2010 Jason Faris     WCHG0000262 - replaced missing comma on line 240
    02-Dec-2010 Tim Ward        WCHG0000262 - replaced missing comma on line 137
    02-Mar-2011 Tim Ward        CR#3723 - Changed DesktopCFundExpensesSQL to 
                                 use PARAGRAPH_NUMBER instead of PARAGRAPH so it 
                                 displays the correct #.
    02-Mar-2011 Tim Ward        CR#3716/3709 - Context is Wrong. 
                                 Changed DesktopCFundExpensesSQL to build context.
    18-Apr-2011 Tim Ward        CR#3754-CFunds Expense Desktop View Description too large. 
                                 Changed DesktopCFundExpensesSQL make Context and Description
                                 links truncated to 25 characters, title has the full text so
                                 when the user hovers over the link, it pops-up as a tooltip.
    23-Jun-2011 Tim Ward        CR#3868 - Added p_ReturnPageItemName to DesktopSQL 
                                 to support popup locators.
    23-Jun-2011 Tim Ward        CR#3868 - Added DesktopMilitaryLocationsSQL AND DesktopCityStateCountrySQL. 
    28-Nov-2011 Tim Ward        CR#3738 - Adding Active/All Flag.
                                CR#3623 - Active/All Filters Missing.
                                 Added correct order by for Activities (when not recent).
                                 Added ACTIVE_FILTER, NUM_ROWS, and PAGE_ID 
                                 parameters to DesktopSQL
                                 Changed desktopactivitiessql, desktopcfundexpensessql.
    28-Nov-2011 Tim Ward        CR#3446 - Implement improved code for faster performance
                                CR#3447 - Implement improved code for faster performance
                                 Added DesktopFilesSQL and DesktopParticipantsSQL.
    28-Nov-2011 Tim Ward        CR#3563 - Default Desktop Views.
                                CR#3742 - Default # Rows and Desktop Views.
                                CR#3728 - Default # Rows and Filters.
                                 Changed in DesktopSQL (to save to T_OSI_PERSONNEL_SETTINGS).
    28-Nov-2011 Tim Ward        CR#3641 - Default Sort Order for "Recent" Filters.
                                CR#3635 - Last Accessed/Times Accessed Inconsistencies.
                                 Changed all Desktop*SQL Functions.
    28-Nov-2011 Tim Ward        CR#3711 - Add Category to AAPP (Agent Applicant) Desktop View.
                                 Actually added any noticable missing columns to Desktop Views.
                                 Changed DesktopFilesSQL.
    28-Nov-2011 Tim Ward        CR#3964 - Add Lead Agent to Desktop->Files Desktop View.
                                CR#3727 - Add Lead Agent to Desktop->Files Desktop View.
                                 Changed DesktopFilesSQL.
    05-Dec-2011 Tim Ward        CR#3639 - Full Text Search added/optimized.
                                 Added DesktopFullTextSearchSQL and added p_OtherSearchCriteria to DesktopSQL.
    29-Dec-2011 WCC             Modified DesktopActivitiesSQL to use t_osi_activity_lookup
    05-Jan-2012 Tim Ward        CR#3781 - Added order by to CFunds Expenses to make it sort like Legacy.
                                 Changed in DesktopCFundExpensesSQL.
    06-Jan-2012 Tim Ward        CR#3446 - Implement improved code for faster performance
                                CR#3447 - Implement improved code for faster performance
                                 Added DesktopCFundsAdvanceSQL.
                                 Added DesktopEvidenceManagementSQL.
                                 Added DesktopPersonnelSQL.
                                 Added DesktopWorkHoursSQL.
                                 Added DesktopSourcesSQL.
                                 Added DesktopUnitSQL.
    27-Feb-2012 Tim Ward        CR#4002 - Combining Locators and Adding Active/All filters with Optimization.
                                 Added p_isLocator, p_Exclude, and p_isLocateMany to DesktopSQL parameters.
                                 Added Get_Filter_LOV, Get_Active_Filter_LOV, and Get_Participants_LOV.
                                 Added addLocatorReturnLink, AddFilter, and Desktop Functions for Locators.  
                                  Changed DesktopSQL to support the the locators.
                                  Changed existing Desktop Functions that needt to be Locators as well.
    26-Mar-2012 Tim Ward        CR#3446 - Improvements to the Files Desktop My Unit Query.
                                        - Subordinate Units should not show "My Unit".
                                        - Missing columns in Activities Search.
                                 Changed in DesktopFilesSQL.
                                 Changed in DesktopActivitiesSQL.
    29-Mar-2012 Tim Ward        CR#3446 - Commented out Piping in DesktopSQL as the Query in DesktopParticpantSQL
                                 can exceed 4000 characters which makes the log_error function error out.
    30-Mar-2012 Tim Ward        CR#3446 - Moved the log_error line before the return in ApexProcessRowTextContains.
                                          Added a Number of Previous Filters Logging to AddApexSearchFilters.
                                          Removed all formatting of SQLString from all procedures (removed extra
                                           spaces and vCRLF).
                                          Added the Call to the Pipe in DesktopSQL and added some error checking
                                           to CORE_LOGGER.LOG_IT.
    04-Apr-2012 Tim Ward        CR#3738 - Added Primary Offense Back into Columns.
                                 Changed DesktopFilesSQL.
    04-Apr-2012 Tim Ward        CR#3689 - Right Click Menu on Desktop.
                                 Added AddRankingToSelect, made KEEP_ON_TOP part of select and order by 
                                  for Recent Objects.  T_OSI_PERSONNEL_RECENT_OBJECTS.KEEP_ON_TOP Date
                                  field added.
                                 Added Support for "Email Link to this Object", new Locator Type of PERSONNEL_EMAIL.
                                  Changed in DesktopSQL, DesktopPersonnelSQL, and get_filter_lov.
    05-Jun-2012 Tim Ward        CR#4036 - Recent My Unit Duplicates.
                                 Added Sum/Max and Group By to SelectString.
                                 Changed AddRankingToSelect, DesktopActivitiesSQL, DesktopCFundAdvancesSQL, DesktopCFundExpensesSQL, 
                                  DesktopCityStateCountrySQL, DesktopEvidenceManagementSQL, DesktopFilesSQL, DesktopMilitaryLocationsSQL, 
                                  DesktopNotificationsSQL, DesktopOffensesSQL, DesktopParticipantsSQL, DesktopPersonnelSQL, DesktopSourcesSQL,
                                  DesktopUnitSQL, and DesktopWorkHoursSQL.
    12-Jul-2012 Tim Ward        CR#3983 - Add Date Opened and Date Closed to Sources Desktop View and make them fill in in the All Files View.
                                 Changed in DesktopFilesSQL and DesktopSourcesSQL.
    07-Sep-2012 Tim Ward        CR#4046 - Added Approved to Activities Desktop View.
                                 Changed in DesktopActivitiesSQL.
    27-Sep-2012 Tim Ward        CR#4129 - Units without parents not being selected (added the (+) to the join).
                                 Changed in DesktopUnitSQL.
    26-Nov-2012 Tim Ward        CR#4165 - Added Ready To Review column to the Activities Desktop.
                                 Changed in DesktopActivitiesSQL.
    28-Nov-2012 Tim Ward        CR#4185 - Added Signed Form 40 Attached Field.                                       
                                 Changed in DesktopActivitiesSQL.

******************************************************************************/
    c_pipe   VARCHAR2(100) := Core_Util.get_config('CORE.PIPE_PREFIX') || 'OSI_DESKTOP';
    type assoc_arr is table of varchar2(255) index by varchar2(255);

    PROCEDURE log_error(p_msg IN VARCHAR2) IS
    BEGIN
        Core_Logger.log_it(c_pipe, p_msg);
    END log_error;

    FUNCTION addLocatorReturnLink(ReturnValue in varchar2 := 'o.sid', p_isLocatorMulti IN VARCHAR2, p_ReturnPageItemName IN VARCHAR2, p_isLocateMany IN VARCHAR2 := 'N') return varchar2 is
      
      SQLString VARCHAR2(32000);
        
    BEGIN
         if p_isLocatorMulti='Y' then
           
           if p_isLocateMany='Y' then
           
             SQLString := 'select apex_item.checkbox(1,' || 
                                                     ReturnValue || ',' || 
                                                     '''' || 'onclick="toggleCheckbox(this); loadIndividuals();"' || '''' || ',' || 
                                                     '''' || ':p0_loc_selections' || '''' || ',' || 
                                                     '''' || ':' || '''' || ') as "Include",';
           
           else
  
             SQLString := 'select apex_item.checkbox(1,' || 
                                                     ReturnValue || ',' || 
                                                     '''' || 'onclick="toggleCheckbox(this);"' || '''' || ',' || 
                                                     '''' || ':p0_loc_selections' || '''' || ',' || 
                                                     '''' || ':' || '''' || ') as "Include",';
           
           end if;
           
         else

           if p_isLocateMany='Y' then
           
             SQLString := 'select ' || '''' || '<a href="javascript:loadIndividuals(''''' || '''' || ' || ' || ReturnValue || ' || ''''' || '''' || ');">Select</a>' || '''' || ' as "Select",' || vCRLF;
           
           else
             
             SQLString := 'select ' || '''' || '<a href="javascript:passBack(''''' || '''' || ' || ' || ReturnValue || ' || ''''' || '''' || ',' || '''' || '''' || p_ReturnPageItemName || '''' || '''' || ');">Select</a>' || '''' || ' as "Select",' || vCRLF;

           end if;
         
         end if;

         return SQLString;
         
    END addLocatorReturnLink;
    
    FUNCTION AddRankingToSelect(asNull in varchar2 := 'N', leadingComma in varchar2 := 'Y', trailingComma in varchar2 := 'N', FILTER in varchar2) return varchar2 is

            vTempString CLOB;
            
    BEGIN
         if asNull = 'Y' then

           vTempString := vTempString || CASE leadingComma when 'Y' then ',' else '' END || 
                          'NULL as "Last Accessed",' || 
                          'NULL as "Times Accessed",' || 
                          'NULL as "Ranking"' || CASE trailingComma when 'Y' then ',' else '' END;
         
         else
           
           if (FILTER='RECENT') then

             vTempString := vTempString || CASE leadingComma when 'Y' then ',' else '' END || 
                            'to_char(r1.last_accessed,''dd-Mon-rrrr'') as "Last Accessed",' || 
                            'to_char(r1.times_accessed,''00000'') as "Times Accessed",' || 
                            'to_char(decode(r1.keep_on_top,null,r1.times_accessed/power((sysdate-r1.last_accessed+1),2),999999.999999),''000000.000000'') as "Ranking"' || CASE trailingComma when 'Y' then ',' else '' END;
           else

             ----RECENT MY UNIT----         
             vTempString := vTempString || CASE leadingComma when 'Y' then ',' else '' END || 
                           'to_char(max(r1.last_accessed),''dd-Mon-rrrr'') as "Last Accessed",' || 
                           'to_char(sum(r1.times_accessed),''00000'') as "Times Accessed",' || 
                           'to_char(decode(r1.keep_on_top,null,sum(r1.times_accessed)/power((sysdate-max(r1.last_accessed)+1),2),999999.999999),''000000.000000'') as "Ranking"' || CASE trailingComma when 'Y' then ',' else '' END;

           end if;                    

         end if;
         
         return vTempString;
         
    END AddRankingToSelect;
        
    FUNCTION ApexProcessRowTextContains(RowTextContains in varchar2, column_names in assoc_arr) return varchar2 is

      CurrentColumn VARCHAR2(255);
      ColumnCount NUMBER;
      SQLString VARCHAR2(32000);

    BEGIN
         log_error('>>>ApexProcessRowTextContains(' || RowTextContains || ',column_names' || ')');
         IF RowTextContains is not null THEN
                 
           IF length(RowTextContains)>0 THEN

             SQLString := SQLString || 
                              ' AND (';
                 
             CurrentColumn := column_names.first;
             ColumnCount := 0;
             loop
                 exit when CurrentColumn is null;
                 ColumnCount := ColumnCount + 1;
                     
                 IF ColumnCount > 1 THEN
  
                   SQLString := SQLString ||  
                                    ' or ';
                                  
                 END IF;

                 SQLString := SQLString ||
                              'instr(upper(' || column_names(CurrentColumn) || '),upper(' || '''' || RowTextContains || '''' || '))> 0';
                                
                 CurrentColumn := column_names.next(CurrentColumn);

             end loop;
                 
             SQLString := SQLString || ')';
  
           END IF;
                              
         END IF;

         log_error('<<<ApexProcessRowTextContains(' || RowTextContains || ',column_names' || ')');
         return SQLString;

    EXCEPTION WHEN OTHERS THEN
             log_error('Error in ApexProcessRowTextContains - ' || sqlerrm);
             return '';
         
    END ApexProcessRowTextContains;

    FUNCTION AddApexSearchFilters(p_OtherSearchCriteria in VARCHAR2, column_names in assoc_arr, p_WorksheetID IN VARCHAR2 := NULL, p_APP_USER IN VARCHAR2 := NULL, p_Instance IN VARCHAR2 := NULL, p_ReportName IN VARCHAR2 := '') RETURN VARCHAR2 IS

      SQLString VARCHAR2(32000);
      RowTextContains VARCHAR2(32000);
      ColumnName VARCHAR2(32000);
      Operator VARCHAR2(32000);
      EXPR VARCHAR2(32000);
      EXPR2 VARCHAR2(32000);
      ConditionID VARCHAR2(32000);
      strPOS number;
      Multiplier VARCHAR2(32000);
      mySelect VARCHAR2(32000);
      
      p_Cursor SYS_REFCURSOR;
      
    BEGIN
         log_error('>>>AddApexSearchFilters(' || p_OtherSearchCriteria || ',column_names' || ',' || p_WorksheetID  || ',' || p_APP_USER  || ',' || p_Instance || ',' || p_ReportName || ')');
         
         --- Handle Current Search Criteria ---
         IF instr(p_OtherSearchCriteria, '^~^') > 0 THEN
                 
           IF instr(p_OtherSearchCriteria, 'Row text contains ') > 0 THEN
                   
             RowTextContains := replace(replace(p_OtherSearchCriteria,'Row text contains ^~^',''), chr(39), chr(39) || chr(39));
             SQLString := SQLString || ApexProcessRowTextContains(RowTextContains, column_names);

           ELSE
                 
             strPOS := instr(p_OtherSearchCriteria, '^~^');
                 
             SQLString := SQLString || 
                          ' AND (upper(' || column_names(substr(p_OtherSearchCriteria,1,strPOS-1)) || ') like upper(''%' || replace(substr(p_OtherSearchCriteria,strPOS+3), chr(39), chr(39) || chr(39)) || '%' || '''' || '))';
                              
           END IF;

         END IF;

         --- Build the APEX FILTER SEARCH ---
         mySelect := 'select c.name,c.column_name,c.operator,c.expr,c.expr2' ||  
                     ' from apex_030200.wwv_flow_worksheet_conditions c,apex_030200.wwv_flow_worksheet_rpts r' ||  
                     ' where c.enabled=''Y''' || 
                     ' and c.REPORT_ID=r.ID' || 
                     ' and r.session_id=' || p_Instance || 
                     ' and r.application_user=' || '''' || p_APP_USER || '''' || 
                     ' and r.worksheet_id=' || p_WorksheetID;
        
        if p_ReportName is null or p_ReportName='' then

          mySelect := mySelect || ' and (r.name='''' or r.name is null)';
        
        else

          mySelect := mySelect || ' and r.name=' || '''' || replace(p_ReportName, chr(39), chr(39) || chr(39)) || '''';
                
        end if;
        
        log_error('AddApexSearchFilters - ' || mySelect);
          
         OPEN P_CURSOR FOR mySelect;

         log_error('AddApexSearchFilters - Previous APEX filters Found:  ' || P_CURSOR%ROWCOUNT);
                        
         --- Get any Previous APEX Filters for the Report ---
         BEGIN
              LOOP

                  FETCH p_Cursor INTO RowTextContains, ColumnName, Operator, EXPR, EXPR2;
                  EXIT WHEN p_Cursor%NOTFOUND;

                  EXPR := replace(EXPR, chr(39), chr(39) || chr(39));
                  EXPR2 := replace(EXPR2, chr(39), chr(39) || chr(39));

                  IF instr(RowTextContains, 'Row text contains ') > 0 THEN
                   
                    RowTextContains := replace(RowTextContains,'Row text contains ' || chr(39), '');
                    RowTextContains := substr(RowTextContains, 1, length(RowTextContains)-1);
                    RowTextContains := replace(RowTextContains, chr(39), chr(39) || chr(39));
                    SQLString := SQLString || ApexProcessRowTextContains(RowTextContains, column_names);
                       
                  ELSIF instr(Operator,'contains') > 0 THEN

                       SQLString := SQLString || 
                                    ' AND (upper(' || column_names(ColumnName) || ') like upper(''%' || EXPR || '%' || '''' || '))';

                  ELSIF instr(Operator,'does not contain') > 0 THEN

                       SQLString := SQLString || 
                                    ' AND (upper(' || column_names(ColumnName) || ') not like upper(''%' || EXPR || '%' || '''' || '))';
                       
                  ELSIF Operator in ('like','not like') THEN

                       SQLString := SQLString || 
                                    ' AND (' || column_names(ColumnName) || ' ' || Operator || '''' || EXPR || '''' || ')';

                  ELSIF Operator in ('in','not in') THEN

                       SQLString := SQLString || 
                                    ' AND (' || column_names(ColumnName) || ' ' || Operator || ' (''' || replace(EXPR, ',', chr(39) || ',' || chr(39)) || '''' || '))';

                  ELSIF instr(Operator,'between') > 0 THEN
                  
                       IF instr(ColumnName,'TO_DATE(') > 0 THEN

                         SQLString := SQLString || 
                                      ' AND (' || column_names(ColumnName) || ' between ' || 'TO_DATE(' || '''' || EXPR || '''' || ',''YYYYMMDDHH24MISS'')' || ' AND ' || 'TO_DATE(' || '''' || EXPR2 || '''' || ',''YYYYMMDDHH24MISS'')' || ')';

                       ELSE     

                         SQLString := SQLString || 
                                      ' AND (' || column_names(ColumnName) || ' between ' || '''' || EXPR || '''' || ' AND ' || '''' || EXPR2 || '''' || ')';

                       END IF;
                  
                  ELSIF instr(Operator,'>') > 0 or instr(Operator,'<') > 0 THEN
                  
                       IF instr(ColumnName,'TO_DATE(') > 0 THEN
                    
                         SQLString := SQLString || 
                                      ' AND (' || column_names(ColumnName) || ' ' || Operator || ' TO_DATE(' || '''' || EXPR || '''' || ',''YYYYMMDDHH24MISS''))';

                       END IF;

                  ELSIF instr(Operator,'is in the') > 0 or instr(Operator,'is not in the') > 0 THEN

                       Case upper(EXPR2)

                           WHEN 'MINUTES' THEN
                                              MultiPlier := '((1/1440)*' || EXPR || ')';
                                           
                             WHEN 'HOURS' THEN
                                              MultiPlier := '((1/24)*' || EXPR || ')';
                                           
                              WHEN 'DAYS' THEN
                                              MultiPlier := '(1*' || EXPR || ')';
                                           
                             WHEN 'WEEKS' THEN
                                              MultiPlier := '(7*' || EXPR || ')';
                                           
                            WHEN 'MONTHS' THEN
                                              MultiPlier := 'add_months(systimestamp, -1*' || EXPR || ')';
                                           
                             WHEN 'YEARS' THEN
                                              MultiPlier := 'add_months(systimestamp, -12*' || EXPR || ')';
                                         
                        
                       end Case;
                  
                       if instr(Operator,'is in the last') > 0 then
                    
                         if upper(EXPR2) in ('MONTHS','YEARS') then
                    
                           SQLString := SQLString || 
                                        ' AND (' || column_names(ColumnName) || ' between ' || MultiPlier || ' and systimestamp)';
                    
                         else
                     
                           SQLString := SQLString || 
                                        ' AND (' || column_names(ColumnName) || ' between systimestamp-' || MultiPlier || ' and systimestamp)';
                    
                         end if;
                    
                       elsif instr(Operator,'is not in the last') > 0 then
                    
                         if upper(EXPR2) in ('MONTHS','YEARS') then
                    
                           SQLString := SQLString || 
                                        ' AND (' || column_names(ColumnName) || ' not between ' || MultiPlier || ' and systimestamp)';
                    
                         else
                    
                           SQLString := SQLString || 
                                        ' AND (' || column_names(ColumnName) || ' not between systimestamp-' || MultiPlier || ' and systimestamp)';

                         end if;

                       elsif instr(Operator,'is in the next') > 0 then

                            if upper(EXPR2) in ('MONTHS','YEARS') then
                    
                              SQLString := SQLString || 
                                           ' AND (' || column_names(ColumnName) || ' between systimestamp and ' || replace(MultiPlier,'-','') || ')';
                       
                            else
                       
                              SQLString := SQLString || 
                                           ' AND (' || column_names(ColumnName) || ' between systimestamp and systimestamp+' || MultiPlier || ')';
                            end if;
                    
                       elsif instr(Operator,'is not in the next') > 0 then

                            if upper(EXPR2) in ('MONTHS','YEARS') then
                    
                              SQLString := SQLString || 
                                           ' AND (' || column_names(ColumnName) || ' not between systimestamp and ' || replace(MultiPlier,'-','') || ')';
                       
                            else
                       
                              SQLString := SQLString || 
                                           ' AND (' || column_names(ColumnName) || ' not between systimestamp and systimestamp+' || MultiPlier || ')';

                            end if;
                            
                       end if;

                  ELSIF length(Operator) > 0 and length(EXPR) > 0 and length(ColumnName) > 0 then
                       
                       SQLString := SQLString || 
                                    ' AND (' || column_names(ColumnName) || ' ' || Operator || ' ' || '''' || EXPR || '''' || ')';

                  END IF;
             
              end loop;
         END;
         log_error('<<<AddApexSearchFilters');
         RETURN SQLString;
  
    EXCEPTION WHEN OTHERS THEN
             log_error('Error in AddApexSearchFilters - ' || sqlerrm);
             return '';
           
    END AddApexSearchFilters;

    -----------------------------------------------------------------------------------
    ---   RETURN ALL subordinate units TO THE specified unit. THE specified unit IS ---
    ---   included IN THE output (AS THE FIRST ENTRY). THE LIST IS comma separated. ---
    -----------------------------------------------------------------------------------
    FUNCTION Get_Subordinate_Units  (pUnit IN VARCHAR2) RETURN VARCHAR2 IS

      pSubUnits VARCHAR2(32000) := NULL;
  
    BEGIN
         FOR u IN (SELECT SID FROM T_OSI_UNIT 
                         WHERE SID <> pUnit
                              START WITH SID = pUnit CONNECT BY PRIOR SID = UNIT_PARENT)
         LOOP
         
             IF pSubUnits IS NOT NULL THEN

               pSubUnits := pSubUnits || ',';
         
             END IF;

             pSubUnits := pSubUnits || '''' || u.SID || '''';
             
         END LOOP;

         IF pSubUnits IS NULL THEN
       
           pSubUnits := '''none''';
         
         END IF;

         pSubUnits := '(' || pSubUnits || ')';

         RETURN pSubUnits;

    EXCEPTION WHEN OTHERS THEN
             
             pSubUnits := '''none''';
             log_error('OSI_DESKTOP.Get_Subordinate_Units(' || pUnit || ') error: ' || SQLERRM );
             RETURN pSubUnits;

    END Get_Subordinate_Units;

    FUNCTION Get_Supported_Units (pUnit IN VARCHAR2)  RETURN VARCHAR2 IS

      pSupportedUnits VARCHAR2(32000) := NULL;
  
    BEGIN
         pSupportedUnits := NULL;

         FOR u IN (SELECT DISTINCT unit FROM T_OSI_UNIT_SUP_UNITS WHERE sup_unit=pUnit)
         LOOP
             IF pSupportedUnits IS NOT NULL THEN
          
               pSupportedUnits := pSupportedUnits || ',';
          
             END IF;
          
             pSupportedUnits := pSupportedUnits || '''' || u.unit || '''';
         
         END LOOP;

         IF pSupportedUnits IS NULL THEN
         
           pSupportedUnits := '''none''';
         
         END IF;

         pSupportedUnits := '(' || pSupportedUnits || ')';

         RETURN pSupportedUnits;

    EXCEPTION
             WHEN OTHERS THEN

                 pSupportedUnits := '''none''';
                 log_error('OSI_DESKTOP.Get_Supported_Units(' || pUnit || ') error: ' || SQLERRM );
                 RETURN pSupportedUnits;

    END Get_Supported_Units;
         
    /***************************/ 
    /*  CFund Expenses Section */   
    /***************************/ 
    FUNCTION DesktopCFundExpensesSQL(FILTER IN VARCHAR2, user_sid IN VARCHAR2, ACTIVE_FILTER IN VARCHAR2, p_OtherSearchCriteria IN VARCHAR2 := '', APXWS_MAX_ROW_CNT IN NUMBER := 10000, p_WorksheetID IN VARCHAR2 := NULL, p_APP_USER IN VARCHAR2 := NULL, p_Instance IN VARCHAR2 := NULL, p_ReportName IN VARCHAR2 := '') RETURN VARCHAR2 IS

      SQLString VARCHAR2(32000);
      UnitSID VARCHAR2(20);
   
      column_names assoc_arr;
      
    BEGIN
         log_error('>>>OSI_DESKTOP.DesktopCFundExpensesSQL(' || FILTER || ',' || user_sid || ',' || ACTIVE_FILTER || ',' || p_OtherSearchCriteria || ',' || APXWS_MAX_ROW_CNT || ',' || p_WorksheetID || ',' || p_APP_USER || ',' || p_Instance || ')');

         column_names('C002'):='to_char(e.incurred_date,''dd-Mon-rrrr'')';
         column_names('C003'):='e.claimant_name';
         column_names('C004'):='''Activity: '' || osi_activity.get_id(e.parent) || '' - '' || core_obj.get_tagline(e.parent)';
         column_names('C005'):='TO_CHAR(e.total_amount_us,''FML999G999G999G990D00'')';
         column_names('C006'):='e.CATEGORY';
         column_names('C007'):='e.paragraph_number';
         column_names('C008'):='e.modify_on';
         column_names('C009'):='e.voucher_no';
         column_names('C010'):='e.charge_to_unit_name';
         column_names('C011'):='e.status';

         UnitSID := Osi_Personnel.get_current_unit(user_sid);
         
         --- Main Select ---
         SQLString := 'SELECT ''javascript:getObjURL(''''''|| e.SID ||'''''');'' as url,' || 
                      'to_char(e.incurred_date,''dd-Mon-rrrr'') as "Date Incurred",' || 
                      'e.claimant_name as "Claimant",' || 
                      '''<div class="tooltip" tip="Activity: '' || to_clob(htf.escape_sc(osi_activity.get_id(e.parent)) || '' - '' || core_obj.get_tagline(e.parent)) || ''">'' || substr(''Activity: '' || osi_activity.get_id(e.parent) || '' - '' || core_obj.get_tagline(e.parent),1,25) || case when length(''Activity: '' || osi_activity.get_id(e.parent) || '' - '' || core_obj.get_tagline(e.parent)) > 25 then ''...'' end || ''</div>'' as "Context",' || 
                      'TO_CHAR(e.total_amount_us, ''FML999G999G999G990D00'') as "Total Amount",' || 
                      '''<div class="tooltip" tip="'' || htf.escape_sc(substr(e.description,1,3000)) || ''">'' || substr(e.description,1,25) || case when length(e.description) > 25 then ''...'' end || ''</div>'' as "Description",' || 
                      'e.CATEGORY as "Category",' || 
                      'e.paragraph_number as "Paragraph",' || 
                      'e.modify_on as "Last Modified",' || 
                      'e.voucher_no as "Voucher #",' || 
                      'e.charge_to_unit_name as "Charge to Unit",' || 
                      'e.status as "Status"';

         --- Fields only Needed for Recent/Recent Unit Filters  ---
         IF FILTER IN ('RECENT','RECENT_UNIT') THEN
           
           SQLString := SQLString || AddRankingToSelect('N','Y','N',FILTER);

         ELSE

           SQLString := SQLString || AddRankingToSelect('Y','Y','N',FILTER);
         
         END IF;

         --- From Clause ---
         SQLString := SQLString || 
                      ' from v_cfunds_expense_v3 e,' || 
                      'T_CORE_OBJ_TYPE ot,' || 
                      'T_CORE_OBJ o';

         --- From portion  Needed for Recent/Recent Unit Filters  ---
         IF FILTER IN ('RECENT','RECENT_UNIT') THEN
          
           SQLString := SQLString || ',' || 
                        't_osi_personnel_recent_objects r1';
        
         END IF;              

         --- Where Clause  ---
         IF FILTER NOT IN ('NONE') THEN

           SQLString := SQLString || 
                        ' WHERE e.SID=o.SID' || 
                        ' AND ot.code=''CFUNDS_EXP''';
                        
         END IF;

         IF ACTIVE_FILTER='ACTIVE' THEN

           SQLString := SQLString || 
                        ' AND OSI_OBJECT.IS_OBJECT_ACTIVE(e.SID)=''Y''';
                        
         END IF;

         --- Add the Max Row Number Check ---
         SQLString := SQLString || 
                      ' AND ROWNUM<=' || APXWS_MAX_ROW_CNT;
                                         
         --- Add Search Filters ---
         SQLString := SQLString || AddApexSearchFilters(p_OtherSearchCriteria, column_names, p_WorksheetID, p_APP_USER, p_Instance, p_ReportName);

         --- Add Pieces to the Where Clause depending on the Filter ---
         CASE 
             
                              WHEN FILTER='ME' THEN
                                                   SQLString := SQLString ||  
                                                                ' AND e.claimant=''' || user_sid ||  '''' || 
                                                                ' ORDER BY ' || '''' || 'Activity: ' || '''' || ' || osi_activity.get_id(e.parent) || ' || '''' || ' - ' || '''' || ' || core_obj.get_tagline(e.parent)'; 
             
                            WHEN FILTER='UNIT' THEN
                                                   SQLString := SQLString ||  
                                                                ' AND e.charge_to_unit=''' || UnitSID ||  '''' || 
                                                                ' ORDER BY ' || '''' || 'Activity: ' || '''' || ' || osi_activity.get_id(e.parent) || ' || '''' || ' - ' || '''' || ' || core_obj.get_tagline(e.parent)'; 

                        WHEN FILTER='SUB_UNIT' THEN
                                                   SQLString := SQLString ||  
                                                                ' AND e.charge_to_unit in ' || Get_Subordinate_Units(UnitSID) || 
                                                                ' ORDER BY ' || '''' || 'Activity: ' || '''' || ' || osi_activity.get_id(e.parent) || ' || '''' || ' - ' || '''' || ' || core_obj.get_tagline(e.parent)'; 
            
                        WHEN FILTER='SUP_UNIT' THEN
                                                   SQLString := SQLString ||  
                                                                ' AND e.charge_to_unit IN ' || Get_Supported_Units(UnitSID) || 
                                                                ' ORDER BY ' || '''' || 'Activity: ' || '''' || ' || osi_activity.get_id(e.parent) || ' || '''' || ' - ' || '''' || ' || core_obj.get_tagline(e.parent)'; 
                                                     
                          WHEN FILTER='RECENT' THEN
                                                   SQLString := SQLString ||   
                                                                ' AND r1.obj=o.sid' || 
                                                                ' AND r1.personnel=''' || user_sid ||  '''' || 
                                                                ' ORDER BY "Ranking" DESC,KEEP_ON_TOP DESC';

                     WHEN FILTER='RECENT_UNIT' THEN
                                                   SQLString := SQLString ||  
                                                                ' AND r1.obj=o.sid' || 
                                                                ' AND r1.unit=''' || UnitSID ||  '''' ||
                                                                ' group by e.sid,e.incurred_date,e.claimant_name,e.total_amount_us,e.paragraph_number,e.voucher_no,e.modify_on,e.charge_to_unit_name,e.parent,e.description,e.category,e.status,r1.keep_on_top' ||                                                                 
                                                                ' ORDER BY "Ranking" DESC,KEEP_ON_TOP DESC';

             WHEN FILTER='ALL' OR FILTER='OSI' THEN            
                                                   SQLString := SQLString ||  
                                                                ' ORDER BY ' || '''' || 'Activity: ' || '''' || ' || osi_activity.get_id(e.parent) || ' || '''' || ' - ' || '''' || ' || core_obj.get_tagline(e.parent)'; 
                                                                
                            WHEN FILTER='NONE' THEN            
                                                   SQLString := SQLString ||  
                                                                ' WHERE 1=2';
 
         END CASE;
         
         log_error('<<<OSI_DESKTOP.DesktopCFundExpensesSQL(' || FILTER || ',' || user_sid || ',' || ACTIVE_FILTER || ',' || p_OtherSearchCriteria || ',' || APXWS_MAX_ROW_CNT || ',' || p_WorksheetID || ',' || p_APP_USER || ',' || p_Instance || ')');
         RETURN SQLString;
         
    END DesktopCFundExpensesSQL;

    /***************************/ 
    /*  CFund Advances Section */   
    /***************************/ 
    FUNCTION DesktopCFundAdvancesSQL(FILTER IN VARCHAR2, user_sid IN VARCHAR2, ACTIVE_FILTER IN VARCHAR2, p_OtherSearchCriteria IN VARCHAR2 := '', APXWS_MAX_ROW_CNT IN NUMBER := 10000, p_WorksheetID IN VARCHAR2 := NULL, p_APP_USER IN VARCHAR2 := NULL, p_Instance IN VARCHAR2 := NULL, p_ReportName IN VARCHAR2 := '') RETURN VARCHAR2 IS

      SQLString VARCHAR2(32000);
      UnitSID VARCHAR2(20);
   
      column_names assoc_arr;
      
    BEGIN
         log_error('>>>OSI_DESKTOP.DesktopCFundAdvancesSQL(' || FILTER || ',' || user_sid || ',' || ACTIVE_FILTER || ',' || p_OtherSearchCriteria || ',' || APXWS_MAX_ROW_CNT || ',' || p_WorksheetID || ',' || p_APP_USER || ',' || p_Instance || ')');

         column_names('C002'):='to_char(a.request_date,''dd-Mon-rrrr'')';
         column_names('C003'):='to_char(a.issue_on+90,''dd-Mon-rrrr'')';
         column_names('C004'):='osi_personnel.get_name(a.claimant)';
         column_names('C005'):='a.narrative';
         column_names('C006'):='TO_CHAR(a.amount_requested,''FML999G999G999G990D00'')';
         column_names('C007'):='cfunds_pkg.get_advance_status(a.submitted_on,a.approved_on,a.rejected_on,a.issue_on,a.close_date)';
         column_names('C008'):='osi_unit.get_name(a.unit)';
         column_names('C009'):='osi_unit.get_name(osi_personnel.get_current_unit(a.claimant))';

         UnitSID := Osi_Personnel.get_current_unit(user_sid);

         --- Main Select ---
         SQLString := 'SELECT ''javascript:getObjURL(''''''|| a.SID ||'''''');'' as url,' || 
                      'to_char(a.request_date,''dd-Mon-rrrr'') as "Date Requested",' || 
                      'to_char(a.issue_on+90,''dd-Mon-rrrr'') as "Suspense Date",' || 
                      'osi_personnel.get_name(a.claimant) as "Claimant",' || 
                      '''<div class="tooltip" tip="'' || htf.escape_sc(substr(a.narrative,1,3000)) || ''">'' || substr(a.narrative,1,25) || case when length(a.narrative) > 25 then ''...'' end || ''</div>'' as "Description",' || 
                      'TO_CHAR(a.amount_requested,''FML999G999G999G990D00'') as "Amount Requested",' || 
                      'cfunds_pkg.get_advance_status(a.submitted_on,a.approved_on,a.rejected_on,a.issue_on,a.close_date) as "Status",' || 
                      'osi_unit.get_name(a.unit) as "Charge To Unit",' || 
                      'osi_unit.get_name(osi_personnel.get_current_unit(a.claimant)) as "Claimants Unit"';

         --- Fields only Needed for Recent/Recent Unit Filters  ---
         IF FILTER IN ('RECENT','RECENT_UNIT') THEN

           SQLString := SQLString || AddRankingToSelect('N','Y','N',FILTER);
    
         ELSE

           SQLString := SQLString || AddRankingToSelect('Y','Y','N',FILTER);
         
         END IF;

         --- From Clause ---
         SQLString := SQLString || 
                      ' from t_cfunds_advance_v2 a,' || 
                      'T_CORE_OBJ_TYPE ot,' || 
                      'T_CORE_OBJ o';

         --- From portion  Needed for Recent/Recent Unit Filters  ---
         IF FILTER IN ('RECENT','RECENT_UNIT') THEN
          
           SQLString := SQLString || ',' || 
                        't_osi_personnel_recent_objects r1';
        
         END IF;              

         --- Where Clause  ---
         IF FILTER NOT IN ('NONE') THEN

           SQLString := SQLString || 
                        ' WHERE a.SID=o.SID' || 
                        ' AND ot.sid=o.obj_type' || 
                        ' AND ot.code=''CFUNDS_ADV''';
                        
         END IF;

         IF ACTIVE_FILTER='ACTIVE' THEN

           SQLString := SQLString || 
                        ' AND DECODE(Cfunds_Pkg.Get_Advance_Status(A.SUBMITTED_ON,A.APPROVED_ON,A.REJECTED_ON,A.ISSUE_ON,A.CLOSE_DATE),''Closed'',0,1)=1';
                        
         END IF;

         --- Add the Max Row Number Check ---
         SQLString := SQLString || 
                      ' AND ROWNUM<=' || APXWS_MAX_ROW_CNT;
                                         
         --- Add Search Filters ---
         SQLString := SQLString || AddApexSearchFilters(p_OtherSearchCriteria, column_names, p_WorksheetID, p_APP_USER, p_Instance, p_ReportName);

         --- Add Pieces to the Where Clause depending on the Filter ---
         CASE 
             
                              WHEN FILTER='ME' THEN
                                                   SQLString := SQLString ||  
                                                                ' AND a.claimant=''' || user_sid ||  '''' || 
                                                                ' ORDER BY a.request_date desc,"Suspense Date" asc'; 
             
                            WHEN FILTER='UNIT' THEN
                                                   SQLString := SQLString ||  
                                                                ' AND a.unit=''' || UnitSID ||  '''' || 
                                                                ' ORDER BY a.request_date desc,"Suspense Date" asc'; 

                        WHEN FILTER='SUB_UNIT' THEN
                                                   SQLString := SQLString ||  
                                                                ' AND a.unit in ' || Get_Subordinate_Units(UnitSID) || 
                                                                ' ORDER BY a.request_date desc,"Suspense Date" asc'; 
            
                        WHEN FILTER='SUP_UNIT' THEN
                                                   SQLString := SQLString ||  
                                                                ' AND a.unit IN ' || Get_Supported_Units(UnitSID) || 
                                                                ' ORDER BY a.request_date desc,"Suspense Date" asc'; 
                                                     
                          WHEN FILTER='RECENT' THEN
                                                   SQLString := SQLString ||   
                                                                ' AND r1.obj=o.sid' || 
                                                                ' AND r1.personnel=''' || user_sid ||  '''' || 
                                                                ' ORDER BY "Ranking" DESC,KEEP_ON_TOP DESC';

                     WHEN FILTER='RECENT_UNIT' THEN
                                                   SQLString := SQLString ||  
                                                                ' AND r1.obj=o.sid' || 
                                                                ' AND r1.unit=''' || UnitSID ||  '''' ||
                                                                ' group by a.sid,a.request_date,a.issue_on,a.claimant,a.narrative,a.amount_requested,a.submitted_on,a.approved_on,a.rejected_on,a.issue_on,a.close_date,a.unit,r1.keep_on_top' ||
                                                                ' ORDER BY "Ranking" DESC,KEEP_ON_TOP DESC';

             WHEN FILTER='ALL' OR FILTER='OSI' THEN            
                                                   SQLString := SQLString ||  
                                                                ' ORDER BY a.request_date desc,"Suspense Date" asc'; 
                                                                
                            WHEN FILTER='NONE' THEN            
                                                   SQLString := SQLString ||  
                                                                ' WHERE 1=2';
 
         END CASE;
         
         log_error('<<<OSI_DESKTOP.DesktopCFundAdvancesSQL(' || FILTER || ',' || user_sid || ',' || ACTIVE_FILTER || ',' || p_OtherSearchCriteria || ',' || APXWS_MAX_ROW_CNT || ',' || p_WorksheetID || ',' || p_APP_USER || ',' || p_Instance || ')');
         RETURN SQLString;
         
    END DesktopCFundAdvancesSQL;

    /**************************/ 
    /*  Notifications Section */   
    /**************************/ 
    FUNCTION DesktopNotificationsSQL(FILTER IN VARCHAR2, user_sid IN VARCHAR2, ACTIVE_FILTER IN VARCHAR2, p_OtherSearchCriteria IN VARCHAR2 := '', APXWS_MAX_ROW_CNT IN NUMBER := 10000, p_WorksheetID IN VARCHAR2 := NULL, p_APP_USER IN VARCHAR2 := NULL, p_Instance IN VARCHAR2 := NULL, p_ReportName IN VARCHAR2 := '') RETURN VARCHAR2 IS

      SQLString VARCHAR2(32000);
      UnitSID VARCHAR2(20);
   
      column_names assoc_arr;
      
    BEGIN
         log_error('>>>OSI_DESKTOP.DesktopNotificationsSQL(' || FILTER || ',' || user_sid || ',' || ACTIVE_FILTER || ',' || p_OtherSearchCriteria || ',' || APXWS_MAX_ROW_CNT || ',' || p_WorksheetID || ',' || p_APP_USER || ',' || p_Instance || ')');

         column_names('C002'):='et.description';
         column_names('TO_DATE(C003)'):='to_char(n.generation_date,''dd-Mon-rrrr'')';
         column_names('C004'):='Core_Obj.get_tagline(e.PARENT)';
         column_names('C005'):='p.PERSONNEL_NAME';
         column_names('C006'):='e.specifics';
         column_names('C007'):='Osi_Unit.GET_NAME(e.impacted_unit)';

         UnitSID := Osi_Personnel.get_current_unit(user_sid);
         
         --- Main Select ---
         SQLString := 'SELECT ''javascript:getObjURL(''''''|| e.parent ||'''''');'' as url,' || 
                      'et.description as "Event",' || 
                      'to_char(n.generation_date,''dd-Mon-rrrr'') as "Event Date",' || 
                      '''<div class="tooltip" tip="'' || htf.escape_sc(substr(Core_Obj.get_tagline(e.PARENT),1,3000)) || ''">'' || substr(Core_Obj.get_tagline(e.PARENT),1,25) || case when length(Core_Obj.get_tagline(e.PARENT)) > 25 then ''...'' end || ''</div>'' as "Context",' || 
                      'p.PERSONNEL_NAME as "Recipient",' || 
                      'e.specifics as "Specifics",' || 
                      'Osi_Unit.GET_NAME(e.impacted_unit) as "Unit"';

         --- Fields only Needed for Recent/Recent Unit Filters  ---
         IF FILTER IN ('RECENT','RECENT_UNIT') THEN

           SQLString := SQLString || AddRankingToSelect('N','Y','N',FILTER);
    
         ELSE

           SQLString := SQLString || AddRankingToSelect('Y','Y','N',FILTER);
         
         END IF;
       
         --- From Clause ---
         SQLString := SQLString || 
                      ' from T_OSI_NOTIFICATION n,' || 
                      'T_OSI_NOTIFICATION_EVENT e,' || 
                      'T_OSI_NOTIFICATION_EVENT_TYPE et,' || 
                      'T_CORE_OBJ_TYPE ot,' || 
                      'T_CORE_OBJ o,' || 
                      'V_OSI_PERSONNEL p';
        
         --- From portion  Needed for Recent/Recent Unit Filters  ---
         IF FILTER IN ('RECENT','RECENT_UNIT') THEN
          
           SQLString := SQLString || ',' || 
                        't_osi_personnel_recent_objects r1';
        
         END IF;              
                      
         --- Where Clause  ---
         IF FILTER NOT IN ('NONE') THEN

           SQLString := SQLString || 
                        ' WHERE e.PARENT=o.SID' || 
                        ' AND ot.code=''NOTIFICATIONS''' || 
                        ' AND n.EVENT=e.SID' || 
                        ' AND et.SID=e.EVENT_CODE' || 
                        ' AND n.RECIPIENT=p.SID';
                        
         END IF;

         --- Add the Max Row Number Check ---
         SQLString := SQLString || 
                      ' AND ROWNUM<=' || APXWS_MAX_ROW_CNT;

         --- Add Search Filters ---
         SQLString := SQLString || AddApexSearchFilters(p_OtherSearchCriteria, column_names, p_WorksheetID, p_APP_USER, p_Instance, p_ReportName);

         --- Add Pieces to the Where Clause depending on the Filter ---
         CASE 
             
                              WHEN FILTER='ME' THEN
                                                   SQLString := SQLString ||  
                                                                ' AND RECIPIENT=''' || user_sid || '''';
             
                            WHEN FILTER='UNIT' THEN
                                                   SQLString := SQLString ||  
                                                                ' AND e.impacted_unit=''' || UnitSID ||  '''';

                        WHEN FILTER='SUB_UNIT' THEN
                                                   SQLString := SQLString ||  
                                                                ' AND e.impacted_unit in ' || Get_Subordinate_Units(UnitSID); 
            
                        WHEN FILTER='SUP_UNIT' THEN
                                                   SQLString := SQLString ||  
                                                                ' AND e.impacted_unit IN ' || Get_Supported_Units(UnitSID);
                                                     
                          WHEN FILTER='RECENT' THEN
                                                   SQLString := SQLString ||  
                                                                ' AND r1.obj=o.sid' || 
                                                                ' AND r1.personnel=''' || user_sid ||  '''' || 
                                                                ' ORDER BY "Ranking" DESC,KEEP_ON_TOP DESC';

                     WHEN FILTER='RECENT_UNIT' THEN
                                                   SQLString := SQLString ||  
                                                                ' AND r1.obj=o.sid' || 
                                                                ' AND r1.unit=''' || UnitSID ||  '''' || 
                                                                ' group by e.parent,et.description,n.generation_date,p.personnel_name,e.specifics,e.impacted_unit,r1.keep_on_top' ||
                                                                ' ORDER BY "Ranking" DESC,KEEP_ON_TOP DESC';

             WHEN FILTER='ALL' OR FILTER='OSI' THEN            
                                                   NULL;
                                                   
                            WHEN FILTER='NONE' THEN            
                                                   SQLString := SQLString ||  
                                                                ' WHERE 1=2';
                                                                                                               
         END CASE;
         
         log_error('<<<OSI_DESKTOP.DesktopNotificationsSQL(' || FILTER || ',' || user_sid || ',' || ACTIVE_FILTER || ',' || p_OtherSearchCriteria || ',' || APXWS_MAX_ROW_CNT || ',' || p_WorksheetID || ',' || p_APP_USER || ',' || p_Instance || ')');
         RETURN SQLString;
         
    END DesktopNotificationsSQL;

    /***************************************/ 
    /*  Evidence Management Module Section */   
    /***************************************/ 
    FUNCTION DesktopEvidenceManagementSQL(FILTER IN VARCHAR2, user_sid IN VARCHAR2, ACTIVE_FILTER IN VARCHAR2, p_OtherSearchCriteria IN VARCHAR2 := '', APXWS_MAX_ROW_CNT IN NUMBER := 10000, p_WorksheetID IN VARCHAR2 := NULL, p_APP_USER IN VARCHAR2 := NULL, p_Instance IN VARCHAR2 := NULL, p_ReportName IN VARCHAR2 := '') RETURN VARCHAR2 IS

      SQLString VARCHAR2(32000);
      UnitSID VARCHAR2(20);
   
      column_names assoc_arr;
      
    BEGIN
         log_error('>>>OSI_DESKTOP.DesktopEvidenceManagementSQL(' || FILTER || ',' || user_sid || ',' || ACTIVE_FILTER || ',' || p_OtherSearchCriteria || ',' || APXWS_MAX_ROW_CNT || ',' || p_WorksheetID || ',' || p_APP_USER || ',' || p_Instance || ')');

         column_names('C002'):='osi_unit.get_name(u.sid)';

         UnitSID := Osi_Personnel.get_current_unit(user_sid);
         
         --- Main Select ---
         SQLString := 'SELECT ''javascript:newWindow({page:30700,clear_cache:''''30700'''',name:''''EMM'' || u.sid || '''''',item_names:''''P0_OBJ'''',item_values:'''''' || u.sid || '''''',request:''''OPEN''''});'' as url,' || 
                      '       ''Evidence Management Module for: '' || osi_unit.get_name(u.sid) as "Module Name"';

         --- Fields only Needed for Recent/Recent Unit Filters  ---
         IF FILTER IN ('RECENT','RECENT_UNIT') THEN

           SQLString := SQLString || AddRankingToSelect('N','Y','N',FILTER);
    
         ELSE

           SQLString := SQLString || AddRankingToSelect('Y','Y','N',FILTER);
         
         END IF;
       
         --- From Clause ---
         SQLString := SQLString || 
                      ' from T_OSI_UNIT u,' || 
                      'T_CORE_OBJ o';
        
         --- From portion  Needed for Recent/Recent Unit Filters  ---
         IF FILTER IN ('RECENT','RECENT_UNIT') THEN
          
           SQLString := SQLString || ',' || 
                        't_osi_personnel_recent_objects r1';
        
         END IF;              
                      
         --- Where Clause  ---
         IF FILTER NOT IN ('NONE') THEN

           SQLString := SQLString || 
                        ' WHERE u.sid=o.SID';
                        
         END IF;

         --- Add the Max Row Number Check ---
         SQLString := SQLString || 
                      ' AND ROWNUM<=' || APXWS_MAX_ROW_CNT;

         --- Add Search Filters ---
         SQLString := SQLString || AddApexSearchFilters(p_OtherSearchCriteria, column_names, p_WorksheetID, p_APP_USER, p_Instance, p_ReportName);

         --- Add Pieces to the Where Clause depending on the Filter ---
         CASE 
             
                              WHEN FILTER='ME' THEN
                                                   SQLString := SQLString ||  
                                                                ' AND u.sid=''' || UnitSID || '''' || 
                                                                ' ORDER BY "Module Name"';
             
                            WHEN FILTER='UNIT' THEN
                                                   SQLString := SQLString ||  
                                                                ' AND u.sid=''' || UnitSID ||  '''' || 
                                                                ' ORDER BY "Module Name"';

                        WHEN FILTER='SUB_UNIT' THEN
                                                   SQLString := SQLString ||  
                                                                ' AND u.sid in ' || Get_Subordinate_Units(UnitSID) ||  
                                                                ' ORDER BY "Module Name"';
            
                        WHEN FILTER='SUP_UNIT' THEN
                                                   SQLString := SQLString ||  
                                                                ' AND u.sid IN ' || Get_Supported_Units(UnitSID) || 
                                                                ' ORDER BY "Module Name"';
                                                     
                          WHEN FILTER='RECENT' THEN
                                                   SQLString := SQLString ||  
                                                                ' AND r1.obj=o.sid' || 
                                                                ' AND r1.personnel=''' || user_sid ||  '''' || 
                                                                ' ORDER BY "Ranking" DESC,KEEP_ON_TOP DESC';

                     WHEN FILTER='RECENT_UNIT' THEN
                                                   SQLString := SQLString ||  
                                                                ' AND r1.obj=o.sid' || 
                                                                ' AND r1.unit=''' || UnitSID ||  '''' || 
                                                                ' group by u.sid,r1.keep_on_top ' ||
                                                                ' ORDER BY "Ranking" DESC,KEEP_ON_TOP DESC';

             WHEN FILTER='ALL' OR FILTER='OSI' THEN            
                                                   SQLString := SQLString ||  
                                                                ' ORDER BY "Module Name"';
                                                   
                            WHEN FILTER='NONE' THEN            
                                                   SQLString := SQLString ||  
                                                                ' WHERE 1=2';
                                                                                                               
         END CASE;
         
         log_error('<<<OSI_DESKTOP.DesktopEvidenceManagementSQL(' || FILTER || ',' || user_sid || ',' || ACTIVE_FILTER || ',' || p_OtherSearchCriteria || ',' || APXWS_MAX_ROW_CNT || ',' || p_WorksheetID || ',' || p_APP_USER || ',' || p_Instance || ')');
         RETURN SQLString;
         
    END DesktopEvidenceManagementSQL;
    
    /***********************/ 
    /*  Activities Section */   
    /***********************/ 
    FUNCTION DesktopActivitiesSQL(FILTER IN VARCHAR2, user_sid IN VARCHAR2, p_ReturnPageItemName IN VARCHAR2:='', ACTIVE_FILTER IN VARCHAR2, p_ObjType IN VARCHAR2, p_OtherSearchCriteria IN VARCHAR2 := '', APXWS_MAX_ROW_CNT IN NUMBER := 10000, p_WorksheetID IN VARCHAR2 := NULL, p_APP_USER IN VARCHAR2 := NULL, p_Instance IN VARCHAR2 := NULL, p_ReportName IN VARCHAR2 := '', p_isLocator IN VARCHAR2 := 'N', p_isLocatorMulti IN VARCHAR2 := 'N', p_Exclude IN VARCHAR2 := '', p_isLocateMany IN VARCHAR2 := 'N') RETURN VARCHAR2 IS

      SQLString VARCHAR2(32000);
      UnitSID VARCHAR2(20);
      
      column_names assoc_arr;
      
    BEGIN
         column_names('C002'):='a.id';
         column_names('C003'):='a.activity_type';
         column_names('C004'):='a.title';
         column_names('C005'):='a.lead_agent';
         column_names('C006'):='a.status';
         column_names('C007'):='a.controlling_unit';
         column_names('TO_DATE(C008)'):='a.created_on';

         column_names('C013'):='a.created_by';
         column_names('C014'):='a.Is_Lead';
         column_names('TO_DATE(C015)'):='a.Date_Completed';
         column_names('TO_DATE(C016)'):='a.Suspense_Date';
         column_names('C017'):='decode(a.Leadership_Approved,''Y'',''Yes'',''No'')';
         column_names('C018'):='decode(a.ready_for_review,''Y'',''Yes'',''No'')';
         column_names('C019'):='decode(a.signed_form_40_attached,''Y'',''Yes'',''No'')';
         
         log_error('>>>OSI_DESKTOP.DesktopActivitiesSQL(' || FILTER || ',' || user_sid || ',' || p_ReturnPageItemName || ',' || ACTIVE_FILTER || ',' || p_ObjType || ',' || p_OtherSearchCriteria || ',' || APXWS_MAX_ROW_CNT || ',' || p_WorksheetID || ',' || p_APP_USER || ',' || p_Instance || ',' || p_ReportName || ',' || p_isLocator || ',' || p_isLocatorMulti || ',' || p_Exclude || ')');
         
         UnitSID := Osi_Personnel.get_current_unit(user_sid);
         
         --- Main Select ---
         if p_isLocator = 'Y' then
           
           SQLString := addLocatorReturnLink('a.sid', p_isLocatorMulti, p_ReturnPageItemName, p_isLocateMany);
           
         else

           SQLString := 'SELECT a.url,' || vCRLF;
         
         end if;                  

         SQLString := SQLString || 
                      'a.ID as "ID",' || 
                      'a.Activity_Type as "Activity Type",' || 
                      'a.title as "Title",' || 
                      'a.Lead_Agent as "Lead Agent",' || 
                      'a.Status as "Status",' || 
                      'a.Controlling_Unit as "Controlling Unit",' || 
                      'a.Created_On as "Created On",';

         --- Fields only Needed for Recent/Recent Unit Filters  ---
         IF FILTER IN ('RECENT','RECENT_UNIT') THEN

           SQLString := SQLString || AddRankingToSelect('N','N','Y',FILTER);
         
         ELSE

           SQLString := SQLString || AddRankingToSelect('Y','N','Y',FILTER);
         
         END IF;
         
         --- Add VLT Link ---
         if p_isLocator = 'N' then

           SQLString := SQLString || 
                        'a.VLT as "VLT",';

         else

           SQLString := SQLString || 
                        'NULL as "VLT",';
         end if;

         --- Fields not Shown by Default ---
         SQLString := SQLString || 
                      'a.created_by as "Created By",' || 
                      'a.Is_Lead as "Is a Lead",' || 
                      'a.Date_Completed as "Date Completed",' || 
                      'a.Suspense_Date as "Suspense Date",' ||
                      'decode(a.Leadership_Approved,''Y'',''Yes'',''No'') as "Approved",' ||
                      'decode(a.ready_for_review,''Y'',''<div class="requiredlabel">Yes</div>'',''No'') as "Ready for Review",' ||
                      'decode(a.signed_form_40_attached,''Y'',''Yes'',''No'') as "Signed Form 40 Attached"';
       
         --- From Clause ---
         SQLString := SQLString || 
                      ' from t_osi_activity_lookup a' ;

         --- From portion  Needed for Recent/Recent Unit Filters  ---
         IF FILTER IN ('RECENT','RECENT_UNIT') THEN
          
           SQLString := SQLString || ',' || 
                        't_osi_personnel_recent_objects r1';
        
         END IF;              

         --- Where Clause  ---
         IF FILTER NOT IN ('NONE') THEN

           SQLString := SQLString || 
                        ' WHERE 1=1' || vCRLF;
                        
         END IF;
         
         IF ACTIVE_FILTER='ACTIVE' THEN

           SQLString := SQLString || 
                       ' AND OSI_OBJECT.IS_OBJECT_ACTIVE(a.SID)=''Y''';
                        
         END IF;
         
         --- Add the Max Row Number Check ---
         SQLString := SQLString || 
                      ' AND ROWNUM<=' || APXWS_MAX_ROW_CNT;
         
         --- Add Excludes if Needed ---
         if p_Exclude is not null then
         
           SQLString := SQLString || 
                        ' AND instr(' || '''' || p_Exclude || '''' || ',a.sid) = 0';
         
         end if;
         
         --- Add Search Filters ---
         SQLString := SQLString || AddApexSearchFilters(p_OtherSearchCriteria, column_names, p_WorksheetID, p_APP_USER, p_Instance, p_ReportName);
           
         --- Add Pieces to the Where Clause depending on the Filter ---
         CASE 
             
                              WHEN FILTER='ME' THEN
                                                   SQLString := SQLString ||  
                                                                ' AND a.sid in (select obj from t_osi_assignment where end_date is null and personnel=''' || user_sid || ''')' || 
                                                                ' ORDER BY a.activity_type';
             
                            WHEN FILTER='UNIT' THEN
                                                   SQLString := SQLString ||  
                                                                ' AND a.controlling_unit_sid=''' || UnitSID ||  '''' || 
                                                                ' ORDER BY a.activity_type';

                        WHEN FILTER='SUB_UNIT' THEN
                                                   SQLString := SQLString ||  
                                                                ' AND a.controlling_unit_sid in ' || Get_Subordinate_Units(UnitSID) || 
                                                                ' ORDER BY a.activity_type'; 
                                                                            
                        WHEN FILTER='SUP_UNIT' THEN
                                                   SQLString := SQLString ||  
                                                                ' AND a.controlling_unit_sid IN ' || Get_Supported_Units(UnitSID) || 
                                                                ' ORDER BY a.activity_type';
                                                     
                          WHEN FILTER='RECENT' THEN
                                                   SQLString := SQLString ||   
                                                                ' AND r1.obj=a.sid' || 
                                                                ' AND r1.personnel=''' || user_sid ||  '''' || 
                                                                ' ORDER BY "Ranking" DESC,KEEP_ON_TOP DESC';

                     WHEN FILTER='RECENT_UNIT' THEN
                                                   SQLString := SQLString ||  
                                                                ' AND r1.obj=a.sid' || 
                                                                ' AND r1.unit=''' || UnitSID ||  '''' || 
                                                                ' group by a.sid,a.id,a.activity_type,a.title,a.url,a.lead_agent,a.status,a.controlling_unit,a.vlt,a.is_lead,a.date_completed,a.suspense_date,a.created_on,a.created_by,r1.keep_on_top,a.leadership_approved,a.ready_for_review,a.signed_form_40_attached' ||  
                                                                ' ORDER BY "Ranking" DESC,KEEP_ON_TOP DESC';

             WHEN FILTER='ALL' OR FILTER='OSI' THEN            
                                                   SQLString := SQLString ||  
                                                                ' ORDER BY a.activity_type';                                                                
                            WHEN FILTER='NONE' THEN            
                                                   SQLString := SQLString ||  
                                                                ' WHERE 1=2';
 
         END CASE;
         
         log_error('<<<OSI_DESKTOP.DesktopActivitiesSQL(' || FILTER || ',' || user_sid || ',' || p_ReturnPageItemName || ',' || ACTIVE_FILTER || ',' || p_ObjType || ',' || p_OtherSearchCriteria || ',' || APXWS_MAX_ROW_CNT || ',' || p_WorksheetID || ',' || p_APP_USER || ',' || p_Instance || ',' || p_ReportName || ',' || p_isLocator || ',' || p_isLocatorMulti || ',' || p_Exclude || ')');
         RETURN SQLString;
         
    END DesktopActivitiesSQL;
    
    /******************/ 
    /*  Files Section */   
    /******************/ 
    FUNCTION DesktopFilesSQL(FILTER IN VARCHAR2, user_sid IN VARCHAR2, p_ReturnPageItemName IN VARCHAR2:='', ACTIVE_FILTER IN VARCHAR2, p_ObjType IN VARCHAR2, p_OtherSearchCriteria IN VARCHAR2 := '', APXWS_MAX_ROW_CNT IN NUMBER := 10000, p_WorksheetID IN VARCHAR2 := NULL, p_APP_USER IN VARCHAR2 := NULL, p_Instance IN VARCHAR2 := NULL, p_ReportName IN VARCHAR2 := '', p_isLocator IN VARCHAR2 := 'N', p_isLocatorMulti IN VARCHAR2 := 'N', p_Exclude IN VARCHAR2 := '', p_isLocateMany IN VARCHAR2 := 'N') RETURN VARCHAR2 IS

      SQLString VARCHAR2(32000);
      UnitSID VARCHAR2(20);

      shDateOpenedCode VARCHAR2(100):='DECODE(ot.code,''FILE.SOURCE'',''AC'',''OP'')';
      shDateClosedCode VARCHAR2(100):='DECODE(ot.code,''FILE.SOURCE'',''TM'',''CL'')';
      
      column_names assoc_arr;
      
    BEGIN
         column_names('C002'):='F.ID';
         column_names('C003'):='OT.DESCRIPTION';
         column_names('C004'):='F.TITLE';
         column_names('C006'):='osi_object.get_status(f.sid)';
         column_names('C007'):='osi_unit.get_name(osi_file.get_unit_owner(f.sid))';
         column_names('C012'):='o.create_by';
         column_names('C013'):='osi_status.last_sh_date(f.sid,' || shDateOpenedCode || ')';
         column_names('C014'):='osi_status.last_sh_date(f.sid,' || shDateClosedCode || ')';
         column_names('C015'):='osi_file.get_days_since_opened(f.sid)';
         column_names('C016'):='Osi_Object.get_lead_agent_name(f.SID)';
         
         log_error('>>>OSI_DESKTOP.DesktopFilesSQL(' || FILTER || ',' || user_sid || ',' || ACTIVE_FILTER || ',' || p_ObjType || ',' || p_OtherSearchCriteria || ',' || APXWS_MAX_ROW_CNT || ',' || p_WorksheetID || ',' || p_APP_USER || ',' || p_Instance || ')');

         UnitSID := Osi_Personnel.get_current_unit(user_sid);

         --- Main Select ---
         if p_isLocator = 'Y' then
           
           SQLString := addLocatorReturnLink('f.sid', p_isLocatorMulti, p_ReturnPageItemName, p_isLocateMany);
           
         else

           SQLString := 'select ''javascript:getObjURL('''''' || f.sid || '''''');'' url,';
         
         end if;                  
            
         SQLString := SQLString || 
                      'f.id as "ID",' || 
                      'ot.description as "File Type",' || 
                      'f.title as "Title",' || 
                      'o.create_on as "Created On",' || 
                      'osi_object.get_status(f.sid) as "Status",' || 
                      'osi_unit.get_name(osi_file.get_unit_owner(f.sid)) as "Controlling Unit",';
                      
         --- Fields only Needed for Recent/Recent Unit Filters  ---
         IF FILTER IN ('RECENT','RECENT_UNIT') THEN

           SQLString := SQLString || AddRankingToSelect('N','N','Y',FILTER);
         
         ELSE

           SQLString := SQLString || AddRankingToSelect('Y','N','Y',FILTER);
         
         END IF;
         
         --- Add VLT Link ---
         if p_isLocator = 'N' then

           SQLString := SQLString || 
                        '''javascript:newWindow({page:5550,clear_cache:''''5550'''',name:''''VLT''||f.sid||'''''',item_names:''''P0_OBJ'''',item_values:''||''''||''''''''||f.sid||''''''''||''''||'',request:''''OPEN''''})'' as "VLT",';

         else

           SQLString := SQLString || 
                        'NULL as "VLT",';
         end if;

         --- Fields not Shown by Default ---
         SQLString := SQLString || 
                      'o.create_by as "Created By",' || 
                      'osi_status.last_sh_date(f.sid,' || shDateOpenedCode || ') as "Date Opened",' || 
                      'osi_status.last_sh_date(f.sid,' || shDateClosedCode || ') as "Date Closed",' || 
                      'osi_file.get_days_since_opened(f.sid) as "Days Since Opened",' || 
                      'Osi_Object.get_lead_agent_name(f.SID) as "Lead Agent"';

         --- Fields For Investigative Files Only ---
         IF p_ObjType IN ('FILE.INV','FILE.INV.CASE','FILE.INV.DEV','FILE.INV.INFO') THEN

           column_names('C017'):='mc.description';
           SQLString := SQLString || ',' || 
                        'mc.description as "Mission Area"';
                        
           IF p_ObjType IN ('FILE.INV','FILE.INV.CASE') THEN

             column_names('C018'):='osi_investigation.get_final_roi_date(f.sid)';
             SQLString := SQLString || ',' || 
                          'osi_investigation.get_final_roi_date(f.sid) as "ROI"';
           
           ELSE               

             SQLString := SQLString || ',NULL as "ROI"';

           END IF;

           column_names('C019'):='Primary Offense';
           SQLString := SQLString || ',(select dot.code || '' '' || dot.description from t_osi_f_inv_offense io,t_dibrs_offense_type dot,t_osi_reference r where io.investigation=f.sid and io.priority=r.sid and r.usage=''OFFENSE_PRIORITY'' and r.code=''P'' and io.offense=dot.sid) as "Primary Offense"';
         
         END IF;

         --- Fields For Agent Applicant Files Only ---
         IF p_ObjType IN ('FILE.AAPP') THEN

           column_names('C017'):='aapp.category_desc';
           column_names('C018'):='aapp.applicant_rank';
           column_names('C019'):='aapp.suspense_date';
           column_names('C020'):='aapp.curr_disp';
           column_names('C021'):='aapp.start_date';
           
           SQLString := SQLString || ',' || 
                        'aapp.category_desc as "Category",' || 
                        'aapp.applicant_rank as "Rank",' || 
                        'aapp.suspense_date as "Suspense Date",' || 
                        'aapp.curr_disp as "Current Disposition",' || 
                        'aapp.start_date as "Start Date"';
         
         ELSE

           SQLString := SQLString || ',' || 
                        'NULL as "Category",' || 
                        'NULL as "Rank",' || 
                        'NULL as "Suspense Date",' || 
                        'NULL as "Current Disposition",' || 
                        'NULL as "Start Date"';
         
         END IF;

         --- Fields For POLY Files Only ---
         IF p_ObjType IN ('FILE.POLY_FILE.SEC', 'FILE.POLY_FILE.CRIM') THEN
         
           column_names('C017'):='osi_unit.get_name(csp.requesting_unit)';
           column_names('C018'):='osi_unit.get_name(csp.rpo_unit)';
           SQLString := SQLString || ',' || 
                        'osi_unit.get_name(csp.requesting_unit) as "Requesting Unit",' || 
                        'osi_unit.get_name(csp.rpo_unit) as "RPO"';

         ELSE
         
           SQLString := SQLString || ',' || 
                        'NULL as "Requesting Unit",' || 
                        'NULL as "RPO"';

         END IF;
         
         --- From Clause ---
         SQLString := SQLString || 
                      ' from T_OSI_FILE f,' || 
                      'T_CORE_OBJ_TYPE ot,' || 
                      'T_CORE_OBJ o';

         IF FILTER IN ('UNIT','SUB_UNIT','SUP_UNIT') THEN
                           
           SQLString := SQLString ||  
                        ',T_OSI_F_UNIT fu';

         END IF;
         
         --- Tables For Investigative Files Only ---
         IF p_ObjType in ('FILE.INV','FILE.INV.CASE','FILE.INV.DEV','FILE.INV.INFO') THEN

           SQLString := SQLString || ',' || 
                      'T_OSI_MISSION_CATEGORY mc,' || 
                      'T_OSI_F_INVESTIGATION i';
         
         END IF;

         --- Tables For Agent Applicant Files Only ---
         IF p_ObjType IN ('FILE.AAPP') THEN

           SQLString := SQLString || ',' || 
                        'v_osi_f_aapp_file aapp';
         
         END IF;

         --- Tables For POLY Files Only ---
         IF p_ObjType IN ('FILE.POLY_FILE.SEC', 'FILE.POLY_FILE.CRIM') THEN

           SQLString := SQLString || ',' || 
                        't_osi_f_poly_file csp';
         
         END IF;
                      
         --- From portion  Needed for Recent/Recent Unit Filters  ---
         IF FILTER IN ('RECENT','RECENT_UNIT') THEN
          
           SQLString := SQLString || ',' || 
                        't_osi_personnel_recent_objects r1';
        
         END IF;              

         --- Where Clause  ---
         IF FILTER NOT IN ('NONE') THEN

           SQLString := SQLString || 
                        ' WHERE f.SID=o.SID' || 
                        ' AND o.obj_type=ot.SID';
                        
         END IF;
         
         IF ACTIVE_FILTER='ACTIVE' THEN

           SQLString := SQLString || 
                        '  AND OSI_OBJECT.IS_OBJECT_ACTIVE(f.SID)=''Y''';
                        
         END IF;

         --- WHERE Clause Parts for Investigative Files Only ---
         IF p_ObjType IN ('FILE.INV','FILE.INV.CASE','FILE.INV.DEV','FILE.INV.INFO') THEN

           SQLString := SQLString || 
                        ' AND i.sid=f.sid' || 
                        ' AND mc.sid(+)=i.manage_by';
           
           IF p_ObjType = 'FILE.INV' THEN

             SQLString := SQLString || 
                          ' AND ot.code in (''FILE.INV.CASE'',''FILE.INV.DEV'',''FILE.INV.INFO'',''FILE.INV'')';
           
           ELSE

             SQLString := SQLString || 
                          ' AND ot.code=''' || p_ObjType || '''';

           END IF;
                  
         END IF;
         
         --- WHERE Clause Parts for Service Files Only ---
         IF p_ObjType in ('FILE.SERVICE','FILE.AAPP','FILE.GEN.ANP','FILE.PSO','FILE.POLY_FILE.SEC') THEN
           
           IF p_ObjType='FILE.SERVICE' THEN

             SQLString := SQLString || 
                          ' AND ot.code in (''FILE.AAPP'',''FILE.GEN.ANP'',''FILE.PSO'',''FILE.POLY_FILE.SEC'')';
                          
           ELSE

             SQLString := SQLString || 
                          ' AND ot.code in (''' || p_ObjType || ''')';
           
           END IF;
           
         END IF;

         --- WHERE Clause Parts for Support Files Only ---
         IF p_ObjType in ('FILE.SUPPORT','FILE.GEN.SRCDEV', 'FILE.GEN.UNDRCVROPSUPP', 'FILE.GEN.TECHSURV', 'FILE.POLY_FILE.CRIM','FILE.GEN.TARGETMGMT') THEN
           
           IF p_ObjType='FILE.SUPPORT' THEN

             SQLString := SQLString || 
                          ' AND ot.code in (''FILE.SUPPORT'',''FILE.GEN.SRCDEV'',''FILE.GEN.UNDRCVROPSUPP'',''FILE.GEN.TECHSURV'',''FILE.POLY_FILE.CRIM'')';
                          
           ELSE

             SQLString := SQLString || 
                          ' AND ot.code in (''' || p_ObjType || ''')';
           
           END IF;
           
         END IF;

         --- Where Clause Part For Agent Applicant Files Only ---
         IF p_ObjType IN ('FILE.AAPP') THEN

           SQLString := SQLString || 
                        ' AND aapp.sid=o.sid';
         
         END IF;

         --- Where Clause Part For POLY Files Only ---
         IF p_ObjType IN ('FILE.POLY_FILE.SEC', 'FILE.POLY_FILE.CRIM') THEN

           SQLString := SQLString || 
                        ' AND csp.sid=o.sid';
         
         END IF;

         --- Add the Max Row Number Check ---
         SQLString := SQLString || 
                      ' AND ROWNUM<=' || APXWS_MAX_ROW_CNT;

         --- Add Excludes if Needed ---
         if p_Exclude is not null then
         
           SQLString := SQLString || 
                        ' AND instr(' || '''' || p_Exclude || '''' || ',f.sid) = 0';
         
         end if;

         --- Add Search Filters ---
         SQLString := SQLString || AddApexSearchFilters(p_OtherSearchCriteria, column_names, p_WorksheetID, p_APP_USER, p_Instance, p_ReportName);
                                                  
         --- Add Pieces to the Where Clause depending on the Filter ---
         CASE 
             
                              WHEN FILTER='ME' THEN
                                                   SQLString := SQLString ||  
                                                                ' AND o.sid in (select obj from t_osi_assignment where end_date is null and personnel=''' || user_sid || ''')';
             
                            WHEN FILTER='UNIT' THEN
                                                   SQLString := SQLString ||  
                                                                ' AND fu.file_sid=f.sid' || 
                                                                ' AND fu.unit_sid=''' || UnitSID ||  '''' || 
                                                                ' AND fu.end_date is null';
         
                        WHEN FILTER='SUB_UNIT' THEN
                                                   SQLString := SQLString ||  
                                                                ' AND fu.file_sid=f.sid' || 
                                                                ' AND fu.unit_sid in (select a.sid from t_osi_unit a start with a.sid=''' || UnitSID || '''' || ' connect by prior a.sid=a.unit_parent)' || 
                                                                ' AND fu.end_date is null' || 
                                                                ' AND fu.unit_sid!=''' || UnitSID || '''';
                                                                            
                        WHEN FILTER='SUP_UNIT' THEN
                                                   SQLString := SQLString ||  
                                                                ' AND fu.file_sid=f.sid' || 
                                                                ' AND fu.unit_sid in (select unit from t_osi_unit_sup_units where sup_unit=''' || UnitSID || '''' || ')' || 
                                                                ' AND fu.end_date is null';
                                                     
                          WHEN FILTER='RECENT' THEN
                                                   SQLString := SQLString ||   
                                                                ' AND r1.obj=o.sid' || 
                                                                ' AND r1.personnel=''' || user_sid ||  '''';

                     WHEN FILTER='RECENT_UNIT' THEN
                                                   SQLString := SQLString ||  
                                                                ' AND r1.obj=o.sid' || 
                                                                ' AND r1.unit=''' || UnitSID ||  '''';

             WHEN FILTER='ALL' OR FILTER='OSI' THEN            
                                                   NULL;
                                                                                                                   
                            WHEN FILTER='NONE' THEN            
                                                   SQLString := SQLString ||  
                                                                ' WHERE 1=2';
 
         END CASE;
         
         --- Add the Order By Clause ---
         CASE
             WHEN FILTER IN ('RECENT') THEN
           
                 SQLString := SQLString ||
                              ' ORDER BY "Ranking" DESC,KEEP_ON_TOP DESC';

             WHEN FILTER IN ('RECENT_UNIT') THEN

                 SQLString := SQLString ||
                              ' group by f.sid,f.id,ot.description,f.title,o.create_on,o.create_by,r1.keep_on_top' ||    
                              ' ORDER BY "Ranking" DESC,KEEP_ON_TOP DESC';

             WHEN FILTER='NONE' THEN            

                 NULL;           

             ELSE

               --- Order By Clause for Investigative Files Only ---
               IF p_ObjType IN ('FILE.INV','FILE.INV.CASE','FILE.INV.DEV','FILE.INV.INFO') THEN

                 SQLString := SQLString ||  
                              ' ORDER BY title';
                              
                 IF p_ObjType IN ('FILE.INV','FILE.INV.CASE') THEN

                   SQLString := SQLString || ',ROI DESC';
                   
                 END IF;                              

               --- Order By Clause for Service Files Only ---
               ELSIF p_ObjType in ('FILE.SERVICE','FILE.AAPP','FILE.GEN.ANP','FILE.PSO','FILE.POLY_FILE.SEC') THEN

                    SQLString := SQLString ||  
                                 ' ORDER BY ot.description,title';

               --- Order By Clause for Support Files Only ---
               ELSIF p_ObjType in ('FILE.SUPPORT','FILE.GEN.SRCDEV', 'FILE.GEN.UNDRCVROPSUPP', 'FILE.GEN.TECHSURV', 'FILE.POLY_FILE.CRIM') THEN

                    SQLString := SQLString ||  
                                 ' ORDER BY ot.description,title';
               ELSE

                 SQLString := SQLString ||  
                              ' ORDER BY ot.description,title';

               END IF;
                                                 
         END CASE;
         
         log_error('<<<OSI_DESKTOP.DesktopFilesSQL(' || FILTER || ',' || user_sid || ',' || ACTIVE_FILTER || ',' || p_ObjType || ',' || p_OtherSearchCriteria || ',' || APXWS_MAX_ROW_CNT || ',' || p_WorksheetID || ',' || p_APP_USER || ',' || p_Instance || ')');
         RETURN SQLString;
         
    END DesktopFilesSQL;

    /************************/ 
    /*  Participant Section */   
    /************************/ 
    FUNCTION DesktopParticipantSQL(FILTER IN VARCHAR2, user_sid IN VARCHAR2, p_ReturnPageItemName IN VARCHAR2:='', ACTIVE_FILTER IN VARCHAR2, p_ObjType IN VARCHAR2, p_OtherSearchCriteria IN VARCHAR2 := '', APXWS_MAX_ROW_CNT IN NUMBER := 10000, p_WorksheetID IN VARCHAR2 := NULL, p_APP_USER IN VARCHAR2 := NULL, p_Instance IN VARCHAR2 := NULL, p_ReportName IN VARCHAR2 := '', p_isLocator IN VARCHAR2 := 'N', p_isLocatorMulti IN VARCHAR2 := 'N', p_Exclude IN VARCHAR2 := '', p_isLocateMany IN VARCHAR2 := 'N') RETURN VARCHAR2 IS

      SQLString VARCHAR2(32000);
      UnitSID VARCHAR2(20);
      groupBy VARCHAR2(32000);
      
      column_names assoc_arr;
      
    BEGIN
         log_error('>>>OSI_DESKTOP.DesktopParticipantSQL(' || FILTER || ',' || user_sid || ',' || ACTIVE_FILTER || ',' || p_ObjType || ',' || p_OtherSearchCriteria || ',' || APXWS_MAX_ROW_CNT || ',' || p_WorksheetID || ',' || p_APP_USER || ',' || p_Instance || ',' || p_ReportName || ',' || p_isLocator || ',' || p_isLocatorMulti || ',' || p_Exclude || ')');
         UnitSID := Osi_Personnel.get_current_unit(user_sid);

         --- Main Select ---
         if p_isLocator = 'Y' then
           
           SQLString := addLocatorReturnLink('o.sid', p_isLocatorMulti, p_ReturnPageItemName, p_isLocateMany);
           
         else
                  
           SQLString := 'select ''javascript:getObjURL('''''' || o.sid || '''''');'' url,';
           
         end if;
         
         groupBy := groupBy || 'o.sid,p.sid,o.create_by,o.create_on,r1.keep_on_top';
         
         CASE
             WHEN ACTIVE_FILTER in ('ALL') then

                 column_names('C002'):='osi_participant.get_name(o.sid,''Y'')';
                 column_names('C006'):='osi_participant.get_type(o.sid)';
                 column_names('C007'):='osi_participant.get_subtype(o.sid)';
                 column_names('C009'):='osi_participant.get_confirmation(o.sid)';
                 column_names('C010'):='o.create_by';
                 column_names('C011'):='o.create_on';
                 column_names('C021'):='osi_reference.lookup_ref_desc(ph.sa_service)';
                 column_names('C022'):='osi_reference.lookup_ref_desc(ph.sa_affiliation)';
                 column_names('C023'):='dibrs_reference.lookup_ref_desc(ph.sa_component)';
                 column_names('C024'):='dibrs_reference.lookup_ref_desc(pc.sa_pay_plan)';
                 column_names('C025'):='pg.description';
                 column_names('C026'):='ph.sa_rank';
                 column_names('C027'):='ph.sa_rank_date';
                 column_names('C028'):='ph.sa_specialty_code';

                 groupBy := groupBy || ',ph.sa_service,ph.sa_affiliation,ph.sa_affiliation,ph.sa_component,pc.sa_pay_plan,pg.description,ph.sa_rank,ph.sa_rank_date,ph.sa_specialty_code';
                 
                 SQLString := SQLString || 
                              'osi_participant.get_name(o.sid,''Y'') as "Name",' || 
                              'NULL as "Company",' || 
                              'NULL as "Organization",' || 
                              'NULL as "Program",' || 
                              'osi_participant.get_type(o.sid) as "Type",' || 
                              'osi_participant.get_subtype(o.sid) as "Sub-Type",' || 
                              'NULL as "Type of Name",' || 
                              'osi_participant.get_confirmation(o.sid) as "Confirmed",' || 
                              'o.create_by as "Created By",' || 
                              'o.create_on as "Created On",' || 
                              'NULL as "Sex",' || 
                              'NULL as "Height (in)",' || 
                              'NULL as "Weight (lbs)",' || 
                              'NULL as "Minimum Age (yrs)",' || 
                              'NULL as "Maximum Age (yrs)",' || 
                              'NULL as "Birth Country",' || 
                              'NULL as "Birth State",' || 
                              'NULL as "Birth City",' || 
                              'NULL as "Birth Date",' || 
                              'osi_reference.lookup_ref_desc(ph.sa_service) as "Service",' || 
                              'osi_reference.lookup_ref_desc(ph.sa_affiliation) as "Service Affiliation",' || 
                              'dibrs_reference.lookup_ref_desc(ph.sa_component) as "Service Component",' || 
                              'dibrs_reference.lookup_ref_desc(pc.sa_pay_plan) as "Service Pay Plan",' || 
                              'pg.description as "Service Pay Grade",' || 
                              'ph.sa_rank as "Service Rank",' || 
                              'ph.sa_rank_date as "Service Date of Rank",' || 
                              'ph.sa_specialty_code as "Service Speciality Code",' || 
                              'NULL as "DUNS",' || 
                              'NULL as "Cage Code"';

             WHEN ACTIVE_FILTER in ('PART.INDIV') then

                 column_names('C002'):='osi_participant.get_name(o.sid,''Y'')';
                 column_names('C008'):='osi_participant.get_name_type(o.sid)';
                 column_names('C009'):='osi_participant.get_confirmation(o.sid)';
                 column_names('C010'):='o.create_by';
                 column_names('C011'):='o.create_on';
                 column_names('C012'):='dibrs_reference.lookup_ref_desc(pc.sex)';
                 column_names('C013'):='pc.height';
                 column_names('C014'):='pc.weight';
                 column_names('C015'):='decode(ph.age_low,null,null,''NB'',''0.008'',''NN'',''0.0014'',''BB'',''0.5'',ph.age_low)';
                 column_names('C016'):='ph.age_high';
                 column_names('C017'):='osi_participant.get_birth_country(o.sid)';
                 column_names('C018'):='osi_participant.get_birth_state(o.sid)';
                 column_names('C019'):='osi_participant.get_birth_city(o.sid)';
                 column_names('C020'):='p.dob';
                 column_names('C021'):='osi_reference.lookup_ref_desc(ph.sa_service)';
                 column_names('C022'):='osi_reference.lookup_ref_desc(ph.sa_affiliation)';
                 column_names('C023'):='dibrs_reference.lookup_ref_desc(ph.sa_component)';
                 column_names('C024'):='dibrs_reference.lookup_ref_desc(pc.sa_pay_plan)';
                 column_names('C025'):='pg.description';
                 column_names('C026'):='ph.sa_rank';
                 column_names('C027'):='ph.sa_rank_date';
                 column_names('C028'):='ph.sa_specialty_code';

                 groupBy := groupBy || ',pc.sex,pc.height,pc.weight,ph.age_low,ph.age_high,p.dob,ph.sa_service,ph.sa_affiliation,ph.sa_component,pc.sa_pay_plan,pg.description,ph.sa_rank,ph.sa_rank_date,ph.sa_specialty_code,pv.sid';

                 SQLString := SQLString || 
                              'osi_participant.get_name(o.sid,''Y'') as "Name",' || 
                              'NULL as "Company",' || 
                              'NULL as "Organization",' || 
                              'NULL as "Program",' || 
                              'NULL as "Type",' || 
                              'NULL as "Sub-Type",' || 
                              'osi_participant.get_name_type(o.sid) as "Type of Name",' || 
                              'osi_participant.get_confirmation(o.sid) as "Confirmed",' || 
                              'o.create_by as "Created By",' || 
                              'o.create_on as "Created On",' || 
                              'dibrs_reference.lookup_ref_desc(pc.sex) as "Sex",' || 
                              'pc.height as "Height (in)",' || 
                              'pc.weight as "Weight (lbs)",' || 
                              'decode(ph.age_low, null, null,''NB'',''0.008'',''NN'',''0.0014'',''BB'',''0.5'',ph.age_low) as "Minimum Age (yrs)",' || 
                              'ph.age_high as "Maximum Age (yrs)",' || 
                              'osi_participant.get_birth_country(o.sid) as "Birth Country",' || 
                              'osi_participant.get_birth_state(o.sid) as "Birth State",' || 
                              'osi_participant.get_birth_city(o.sid) as "Birth City",' || 
                              'p.dob as "Birth Date",' || 
                              'osi_reference.lookup_ref_desc(ph.sa_service) as "Service",' || 
                              'osi_reference.lookup_ref_desc(ph.sa_affiliation) as "Service Affiliation",' || 
                              'dibrs_reference.lookup_ref_desc(ph.sa_component) as "Service Component",' || 
                              'dibrs_reference.lookup_ref_desc(pc.sa_pay_plan) as "Service Pay Plan",' || 
                              'pg.description as "Service Pay Grade",' || 
                              'ph.sa_rank as "Service Rank",' || 
                              'ph.sa_rank_date as "Service Date of Rank",' || 
                              'ph.sa_specialty_code as "Service Speciality Code",' || 
                              'NULL as "DUNS",' || 
                              'NULL as "Cage Code"';

             WHEN ACTIVE_FILTER in ('PART.NONINDIV.COMP') then

                 column_names('C003'):='osi_participant.get_name(o.sid,''Y'')';
                 column_names('C007'):='osi_participant.get_subtype(o.sid)';
                 column_names('C009'):='osi_participant.get_confirmation(o.sid)';
                 column_names('C010'):='o.create_by';
                 column_names('C011'):='o.create_on';
                 column_names('C029'):='pnh.co_duns';
                 column_names('C030'):='pnh.co_cage';
                 
                 SQLString := SQLString || 
                              'NULL as "Name",' || 
                              'osi_participant.get_name(o.sid) as "Company",' || 
                              'NULL as "Organization",' || 
                              'NULL as "Program",' || 
                              'NULL as "Type2",' || 
                              'osi_participant.get_subtype(o.sid) as "Type",' || 
                              'NULL as "Type of Name",' || 
                              'osi_participant.get_confirmation(o.sid) as "Confirmed",' || 
                              'o.create_by as "Created By",' || 
                              'o.create_on as "Created On",' || 
                              'NULL as "Sex",' || 
                              'NULL as "Height (in)",' || 
                              'NULL as "Weight (lbs)",' || 
                              'NULL as "Minimum Age (yrs)",' || 
                              'NULL as "Maximum Age (yrs)",' || 
                              'NULL as "Birth Country",' || 
                              'NULL as "Birth State",' || 
                              'NULL as "Birth City",' || 
                              'NULL as "Birth Date",' || 
                              'NULL as "Service",' || 
                              'NULL as "Service Affiliation",' || 
                              'NULL as "Service Component",' || 
                              'NULL as "Service Pay Plan",' || 
                              'NULL as "Service Pay Grade",' || 
                              'NULL as "Service Rank",' || 
                              'NULL as "Service Date of Rank",' || 
                              'NULL as "Service Speciality Code",' || 
                              'pnh.co_duns as "DUNS",' || 
                              'pnh.co_cage as "Cage Code"';

                 groupBy := groupBy || ',pnh.co_duns,pnh.co_cage';  

             WHEN ACTIVE_FILTER in ('PART.NONINDIV.ORG') then

                 column_names('C004'):='osi_participant.get_name(o.sid,''Y'')';
                 column_names('C007'):='osi_participant.get_subtype(o.sid)';
                 column_names('C009'):='osi_participant.get_confirmation(o.sid)';
                 column_names('C010'):='o.create_by';
                 column_names('C011'):='o.create_on';

                 SQLString := SQLString || 
                              'NULL as "Name",' || 
                              'NULL as "Company",' || 
                              'osi_participant.get_name(o.sid) as "Organization",' || 
                              'NULL as "Program",' || 
                              'NULL as "Type2",' || 
                              'osi_participant.get_subtype(o.sid) as "Type",' || 
                              'NULL as "Type of Name",' || 
                              'osi_participant.get_confirmation(o.sid) as "Confirmed",' || 
                              'o.create_by as "Created By",' || 
                              'o.create_on as "Created On",' || 
                              'NULL as "Sex",' || 
                              'NULL as "Height (in)",' || 
                              'NULL as "Weight (lbs)",' || 
                              'NULL as "Minimum Age (yrs)",' || 
                              'NULL as "Maximum Age (yrs)",' || 
                              'NULL as "Birth Country",' || 
                              'NULL as "Birth State",' || 
                              'NULL as "Birth City",' || 
                              'NULL as "Birth Date",' || 
                              'NULL as "Service",' || 
                              'NULL as "Service Affiliation",' || 
                              'NULL as "Service Component",' || 
                              'NULL as "Service Pay Plan",' || 
                              'NULL as "Service Pay Grade",' || 
                              'NULL as "Service Rank",' || 
                              'NULL as "Service Date of Rank",' || 
                              'NULL as "Service Speciality Code",' || 
                              'NULL as "DUNS",' || 
                              'NULL as "Cage Code"';

             WHEN ACTIVE_FILTER in ('PART.NONINDIV.PROG') then

                 column_names('C005'):='osi_participant.get_name(o.sid,''Y'')';
                 column_names('C007'):='osi_participant.get_subtype(o.sid)';
                 column_names('C009'):='osi_participant.get_confirmation(o.sid)';
                 column_names('C010'):='o.create_by';
                 column_names('C011'):='o.create_on';

                 SQLString := SQLString || 
                              'NULL as "Name",' || 
                              'NULL as "Company",' || 
                              'NULL as "Organization",' || 
                              'osi_participant.get_name(o.sid) as "Program",' || 
                              'NULL as "Type",' || 
                              'NULL as "Type2",' || 
                              'NULL as "Type of Name",' || 
                              'osi_participant.get_confirmation(o.sid) as "Confirmed",' || 
                              'o.create_by as "Created By",' || 
                              'o.create_on as "Created On",' || 
                              'NULL as "Sex",' || 
                              'NULL as "Height (in)",' || 
                              'NULL as "Weight (lbs)",' || 
                              'NULL as "Minimum Age (yrs)",' || 
                              'NULL as "Maximum Age (yrs)",' || 
                              'NULL as "Birth Country",' || 
                              'NULL as "Birth State",' || 
                              'NULL as "Birth City",' || 
                              'NULL as "Birth Date",' || 
                              'NULL as "Service",' || 
                              'NULL as "Service Affiliation",' || 
                              'NULL as "Service Component",' || 
                              'NULL as "Service Pay Plan",' || 
                              'NULL as "Service Pay Grade",' || 
                              'NULL as "Service Rank",' || 
                              'NULL as "Service Date of Rank",' || 
                              'NULL as "Service Speciality Code",' || 
                              'NULL as "DUNS",' || 
                              'NULL as "Cage Code"';

         END CASE;

         --- Fields only Needed for Recent/Recent Unit Filters  ---
         IF FILTER IN ('RECENT','RECENT_UNIT') THEN

           SQLString := SQLString || AddRankingToSelect('N','Y','Y',FILTER);
         
         ELSE

           SQLString := SQLString || AddRankingToSelect('Y','Y','Y',FILTER);
         
         END IF;

         --- Add SSN ---
         IF ACTIVE_FILTER in ('PART.INDIV') THEN

           column_names('C034'):='osi_participant.get_number(pv.sid,''SSN'')';
           SQLString := SQLString || 
             'osi_participant.get_number(pv.sid,''SSN'') as "Social Security Number",';

         ELSE

           SQLString := SQLString || 
             'NULL as "Social Security Number",';

         END IF;         
         
         --- Add VLT Link ---
         if p_isLocator = 'N' then

           SQLString := SQLString || 
                        '''javascript:newWindow({page:5550,clear_cache:''''5550'''',name:''''VLT''||p.sid||'''''',item_names:''''P0_OBJ'''',item_values:''||''''||''''''''||p.sid||''''''''||''''||'',request:''''OPEN''''})'' as "VLT"';

         else

           SQLString := SQLString || 
                        'NULL as "VLT"';
         
         end if;
         
         --- From Clause ---
         SQLString := SQLString || 
                      ' from T_CORE_OBJ o,' || 
                      'T_CORE_OBJ_TYPE ot,' || 
                      'T_OSI_PARTICIPANT p,' || 
                      'T_OSI_PARTIC_NAME pn,' || 
                      'T_OSI_PARTICIPANT_VERSION pv,' || 
                      'T_OSI_PARTICIPANT_HUMAN ph,' || 
                      'T_OSI_PARTICIPANT_NONHUMAN pnh,' || 
                      'T_OSI_PERSON_CHARS pc,' || 
                      'T_DIBRS_PAY_GRADE_TYPE pg';

         --- From portion  Needed for Recent/Recent Unit Filters  ---
         IF FILTER IN ('RECENT','RECENT_UNIT') THEN
          
           SQLString := SQLString || ',' || 
                        't_osi_personnel_recent_objects r1';
        
         END IF;              

         --- Where Clause  ---
         IF FILTER NOT IN ('NONE') THEN

           SQLString := SQLString || 
                        ' WHERE p.SID=o.SID' || 
                        ' AND o.obj_type=ot.SID' || 
                        ' AND p.current_version=pv.sid' || 
                        ' AND pn.sid=pv.current_name' || 
                        ' AND ph.sid(+)=pv.sid' || 
                        ' AND pnh.sid(+)=pv.sid' || 
                        ' AND pc.sid(+)=pv.sid' || 
                        ' AND pg.sid(+)=pc.sa_pay_grade';
                        
         END IF;

         IF p_ObjType = 'PARTICIPANT' THEN
           
           IF ACTIVE_FILTER='ALL' THEN
  
             SQLString := SQLString || 
                          ' AND ot.code in (''PART.INDIV'',''PART.NONINDIV.COMP'',''PART.NONINDIV.ORG'',''PART.NONINDIV.PROG'')';
           
           ELSE
  
             SQLString := SQLString || 
                          ' AND ot.code=''' || ACTIVE_FILTER || '''';
           
           END IF;
                  
         ELSE

           SQLString := SQLString || 
                        ' AND ot.code=''' || p_ObjType || '''';

         END IF;

         --- Add the Max Row Number Check ---
         SQLString := SQLString || 
                      ' AND ROWNUM<=' || APXWS_MAX_ROW_CNT;

         --- Add Excludes if Needed ---
         if p_Exclude is not null then
         
           SQLString := SQLString || 
                        ' and instr(' || '''' || p_Exclude || '''' || ',o.sid) = 0' || 
                        ' and not exists(select 1 from t_osi_participant_version pv1 where pv1.participant=o.SID and instr(' || '''' || p_Exclude || '''' || ',pv1.sid)>0)';         

         end if;
         
         --- Add Search Filters ---
         SQLString := SQLString || AddApexSearchFilters(p_OtherSearchCriteria, column_names, p_WorksheetID, p_APP_USER, p_Instance, p_ReportName);

         --- Add Pieces to the Where Clause depending on the Filter ---
         CASE 

                             WHEN FILTER='ABC' THEN
                                                   SQLString := SQLString ||   
                                                                ' AND REGEXP_INSTR(pn.last_name,''[a|b|c][[:alpha:]]'',1,1,0,''i'')=1';
                                                                
                             WHEN FILTER='DEF' THEN
                                                   SQLString := SQLString ||   
                                                                ' AND REGEXP_INSTR(pn.last_name,''[d|e|f][[:alpha:]]'',1,1,0,''i'')=1';

                             WHEN FILTER='GHI' THEN
                                                   SQLString := SQLString ||   
                                                                ' AND REGEXP_INSTR(pn.last_name,''[g|h|i][[:alpha:]]'',1,1,0,''i'')=1';

                             WHEN FILTER='JKL' THEN
                                                   SQLString := SQLString ||   
                                                                ' AND REGEXP_INSTR(pn.last_name,''[j|k|l][[:alpha:]]'',1,1,0,''i'')=1';

                             WHEN FILTER='MNO' THEN
                                                   SQLString := SQLString ||   
                                                                ' AND REGEXP_INSTR(pn.last_name,''[m|n|o][[:alpha:]]'',1,1,0,''i'')=1';

                            WHEN FILTER='PQRS' THEN
                                                   SQLString := SQLString ||   
                                                                ' AND REGEXP_INSTR(pn.last_name,''[p|q|r|s][[:alpha:]]'',1,1,0,''i'')=1';

                             WHEN FILTER='TUV' THEN
                                                   SQLString := SQLString ||   
                                                                ' AND REGEXP_INSTR(pn.last_name,''[t|u|v][[:alpha:]]'',1,1,0,''i'')=1';

                            WHEN FILTER='WXYZ' THEN
                                                   SQLString := SQLString ||   
                                                                ' AND REGEXP_INSTR(pn.last_name,''[w|x|y|z][[:alpha:]]'',1,1,0,''i'')=1';

                         WHEN FILTER='NUMERIC' THEN
                                                   SQLString := SQLString ||   
                                                                ' AND REGEXP_INSTR(pn.last_name,''[0-9]'',1,1,0,''i'')=1';

                           WHEN FILTER='ALPHA' THEN
                                                   SQLString := SQLString ||   
                                                                ' AND REGEXP_INSTR(pn.last_name,''[a-z]'',1,1,0,''i'')=1';
                                                     
                          WHEN FILTER='RECENT' THEN
                                                   SQLString := SQLString ||   
                                                                ' AND r1.obj=o.sid' || 
                                                                ' AND r1.personnel=''' || user_sid ||  '''';

                     WHEN FILTER='RECENT_UNIT' THEN
                                                   SQLString := SQLString ||  
                                                                ' AND r1.obj=o.sid' || 
                                                                ' AND r1.unit=''' || UnitSID ||  '''';

             WHEN FILTER='ALL' OR FILTER='OSI' THEN            
                                                   NULL;
                                                                                                                   
                            WHEN FILTER='NONE' THEN            
                                                   SQLString := SQLString ||  
                                                                ' WHERE 1=2';
 
         END CASE;
         
         --- Add the Order By Clause ---
         CASE
             WHEN FILTER IN ('RECENT_UNIT') THEN
           
                 SQLString := SQLString || ' group by ' || groupBy ||  
                              ' ORDER BY "Ranking" DESC,KEEP_ON_TOP DESC';

             WHEN FILTER IN ('RECENT') THEN
           
                 SQLString := SQLString ||  
                              ' ORDER BY "Ranking" DESC,KEEP_ON_TOP DESC';

             WHEN FILTER='NONE' THEN            

                 NULL;           

             ELSE
               
               CASE
                   WHEN p_ObjType='PARTICIPANT' THEN

                       SQLString := SQLString ||  
                                    ' ORDER BY "Type","Name"';
                                    
                   WHEN p_ObjType='PART.INDIV' THEN

                       SQLString := SQLString ||  
                                    ' ORDER BY "Name"';

                   WHEN p_ObjType='PART.NONINDIV.COMP' THEN

                       SQLString := SQLString ||  
                                    ' ORDER BY "Company"';

                   WHEN p_ObjType='PART.NONINDIV.ORG' THEN

                       SQLString := SQLString ||  
                                    ' ORDER BY "Organization"';

                   WHEN p_ObjType='PART.NONINDIV.PROG' THEN

                       SQLString := SQLString ||  
                                    ' ORDER BY "Program"';

               END CASE;
               
         END CASE;
         
         log_error('<<<OSI_DESKTOP.DesktopParticipantSQL(' || FILTER || ',' || user_sid || ',' || ACTIVE_FILTER || ',' || p_ObjType || ',' || p_OtherSearchCriteria || ',' || APXWS_MAX_ROW_CNT || ',' || p_WorksheetID || ',' || p_APP_USER || ',' || p_Instance || ')');
         RETURN SQLString;

    EXCEPTION WHEN OTHERS THEN

            log_error('>>>OSI_DESKTOP.DesktopParticipantSQL(' || FILTER || ',' || user_sid || ',' || ACTIVE_FILTER || ',' || p_ObjType || ')--->' || SQLERRM);
             
    END DesktopParticipantSQL;
    
    /**********************/ 
    /*  Personnel Section */   
    /**********************/ 
    FUNCTION DesktopPersonnelSQL(FILTER IN VARCHAR2, user_sid IN VARCHAR2, p_ReturnPageItemName IN VARCHAR2:='', ACTIVE_FILTER IN VARCHAR2, p_ObjType IN VARCHAR2, p_OtherSearchCriteria IN VARCHAR2 := '', APXWS_MAX_ROW_CNT IN NUMBER := 10000, p_WorksheetID IN VARCHAR2 := NULL, p_APP_USER IN VARCHAR2 := NULL, p_Instance IN VARCHAR2 := NULL, p_ReportName IN VARCHAR2 := '', p_isLocator IN VARCHAR2 := 'N', p_isLocatorMulti IN VARCHAR2 := 'N', p_Exclude IN VARCHAR2 := '', p_PersonnelType IN VARCHAR2 := 'PERSONNEL', p_isLocateMany IN VARCHAR2 := 'N') RETURN VARCHAR2 IS

      SQLString VARCHAR2(32000);
      UnitSID VARCHAR2(20);
      groupBy VARCHAR2(32000);
      
      EmailDomainAllowed VARCHAR2(4000) := core_util.GET_CONFIG('OSI.NOTIF_EMAIL_ALLOW_ADDRESSES');

      column_names assoc_arr;
   
    BEGIN
         log_error('>>>OSI_DESKTOP.DesktopPersonnelSQL(' || FILTER || ',' || user_sid || ',' || ACTIVE_FILTER || ',' || p_OtherSearchCriteria || ',' || APXWS_MAX_ROW_CNT || ',' || p_WorksheetID || ',' || p_APP_USER || ',' || p_Instance || ')');

         IF p_PersonnelType='EMAIL' THEN

           column_names('C002'):='osi_personnel.get_name(p.sid)';
           column_names('C003'):='cont.value';

         ELSE
         
           column_names('C002'):='p.personnel_num';
           column_names('C003'):='osi_personnel.get_name(p.sid)';
           column_names('C004'):='osi_unit.get_name(osi_personnel.get_current_unit(p.sid))';
           column_names('C005'):='sex.code';
           column_names('C006'):='op.start_date';
           column_names('C007'):='op.ssn';
           column_names('C008'):='op.badge_num';
        
         END IF;
         
         UnitSID := Osi_Personnel.get_current_unit(user_sid);
         
         --- Main Select ---
         if p_isLocator = 'Y' then
           
           SQLString := addLocatorReturnLink('p.sid', p_isLocatorMulti, p_ReturnPageItemName, p_isLocateMany);
           
         else
                  
           SQLString := 'select ''javascript:getObjURL('''''' || p.sid || '''''');'' url,';
           
         end if;
         
         IF p_PersonnelType='EMAIL' THEN

           SQLString := SQLString || 
                        'osi_personnel.get_name(p.sid) as "Name",' || 
                        'cont.value as "Email Address",' ||
                        'NULL as "Unit Name",' || 
                        'NULL as "Sex",' || 
                        'NULL as "Start Date",' || 
                        'NULL as "SSN",' || 
                        'NULL as "Badge Number"';
                        
                        groupBy := 'p.sid,cont.value';
         
         ELSE

           SQLString := SQLString || 
                        'p.personnel_num as "Employee #",' || 
                        'osi_personnel.get_name(p.sid) as "Name",' || 
                        'osi_unit.get_name(osi_personnel.get_current_unit(p.sid)) as "Unit Name",' || 
                        'sex.code as "Sex",' || 
                        'op.start_date as "Start Date",' || 
                        'op.ssn as "SSN",' || 
                        'op.badge_num as "Badge Number"';

                        groupBy := 'p.personnel_num,p.sid,sex.code,op.start_date,op.ssn,op.badge_num';
         
         END IF;
                      
         --- Fields only Needed for Recent/Recent Unit Filters  ---
         IF FILTER IN ('RECENT','RECENT_UNIT') THEN

           SQLString := SQLString || AddRankingToSelect('N','Y','N',FILTER);
         
         ELSE

           SQLString := SQLString || AddRankingToSelect('Y','Y','N',FILTER);
         
         END IF;
         
         --- From Clause ---
         SQLString := SQLString || 
                      ' from t_core_personnel p,' || 
                      't_osi_personnel op,' || 
                      't_osi_person_chars c,' || 
                      't_dibrs_reference sex';
         
         IF p_PersonnelType='EMAIL' THEN

           SQLString := SQLString || ',t_osi_personnel_contact cont,t_osi_reference r';

         END IF;
         
         --- From portion  Needed for Recent/Recent Unit Filters  ---
         IF FILTER IN ('RECENT','RECENT_UNIT') THEN
          
           SQLString := SQLString || ',' || 
                        't_osi_personnel_recent_objects r1';
        
         END IF;              

         --- Where Clause  ---
         IF FILTER NOT IN ('NONE') THEN

           SQLString := SQLString || 
                        ' WHERE p.SID=op.SID' || 
                        ' AND c.SID(+)=p.SID' || 
                        ' AND sex.SID(+)=c.sex';
                        
         END IF;

         IF p_PersonnelType='EMAIL' THEN

           SQLString := SQLString || ' and cont.personnel=p.sid and r.sid=cont.type and r.code=''EMLP''';
           
           IF EmailDomainAllowed is not null THEN
             
             SQLString := SQLString || ' and upper(substr(cont.value,' || -length(EmailDomainAllowed) || '))=''' || upper(EmailDomainAllowed) || ''''; 
             
           END IF;
           
         END IF;
                                         
         --- Add the Max Row Number Check ---
         SQLString := SQLString || 
                      '    AND ROWNUM<=' || APXWS_MAX_ROW_CNT;

         --- Add Excludes if Needed ---
         if p_Exclude is not null then
         
           SQLString := SQLString || 
                        '    AND instr(' || '''' || p_Exclude || '''' || ', p.sid) = 0';
         
         end if;

         --- Add Search Filters ---
         SQLString := SQLString || AddApexSearchFilters(p_OtherSearchCriteria, column_names, p_WorksheetID, p_APP_USER, p_Instance, p_ReportName);

         --- Add Pieces to the Where Clause depending on the Filter ---
         CASE 
             
                              WHEN FILTER='ME' THEN
                                                   SQLString := SQLString ||  
                                                                ' AND p.sid=''' || user_sid || '''' || 
                                                                ' ORDER BY "Name"';
             
                            WHEN FILTER='UNIT' THEN
                                                   SQLString := SQLString ||  
                                                                ' AND osi_personnel.get_current_unit(p.sid)=''' || UnitSID ||  '''' || 
                                                                ' ORDER BY "Name"';

                        WHEN FILTER='SUB_UNIT' THEN
                                                   SQLString := SQLString ||  
                                                                ' AND osi_personnel.get_current_unit(p.sid) in ' || Get_Subordinate_Units(UnitSID) || 
                                                                ' ORDER BY "Name"'; 
                                                                            
                        WHEN FILTER='SUP_UNIT' THEN
                                                   SQLString := SQLString ||  
                                                                ' AND osi_personnel.get_current_unit(p.sid) IN ' || Get_Supported_Units(UnitSID) || 
                                                                ' ORDER BY "Name"';
                                                     
                          WHEN FILTER='RECENT' THEN
                                                   SQLString := SQLString ||   
                                                                ' AND r1.obj=p.sid' || 
                                                                ' AND r1.personnel=''' || user_sid ||  '''' || 
                                                                ' ORDER BY "Ranking" DESC,KEEP_ON_TOP DESC';

                     WHEN FILTER='RECENT_UNIT' THEN
                                                   SQLString := SQLString ||  
                                                                ' AND r1.obj=p.sid' || 
                                                                ' AND r1.unit=''' || UnitSID ||  '''' || 
                                                                ' group by ' || groupBy || ',r1.keep_on_top' ||
                                                                ' ORDER BY "Ranking" DESC,KEEP_ON_TOP DESC';

             WHEN FILTER='ALL' OR FILTER='OSI' THEN            
                                                   SQLString := SQLString ||  
                                                                ' ORDER BY "Name"'; 
                                                                
                            WHEN FILTER='NONE' THEN            
                                                   SQLString := SQLString ||  
                                                                ' WHERE 1=2';
 
         END CASE;
         
         log_error('<<<OSI_DESKTOP.DesktopPersonnelSQL(' || FILTER || ',' || user_sid || ',' || ACTIVE_FILTER || ',' || p_OtherSearchCriteria || ',' || APXWS_MAX_ROW_CNT || ',' || p_WorksheetID || ',' || p_APP_USER || ',' || p_Instance || ')');
         RETURN SQLString;
         
    END DesktopPersonnelSQL;
    
    /********************/ 
    /*  Sources Section */   
    /********************/ 
    FUNCTION DesktopSourcesSQL(FILTER IN VARCHAR2, user_sid IN VARCHAR2, p_ReturnPageItemName IN VARCHAR2:='', ACTIVE_FILTER IN VARCHAR2, p_ObjType IN VARCHAR2, p_OtherSearchCriteria IN VARCHAR2 := '', APXWS_MAX_ROW_CNT IN NUMBER := 10000, p_WorksheetID IN VARCHAR2 := NULL, p_APP_USER IN VARCHAR2 := NULL, p_Instance IN VARCHAR2 := NULL, p_ReportName IN VARCHAR2 := '', p_isLocator IN VARCHAR2 := 'N', p_isLocatorMulti IN VARCHAR2 := 'N', p_Exclude IN VARCHAR2 := '', p_isLocateMany IN VARCHAR2 := 'N') RETURN VARCHAR2 IS

      SQLString VARCHAR2(32000);
      UnitSID VARCHAR2(20);
   
      column_names assoc_arr;
      
    BEGIN
         log_error('>>>OSI_DESKTOP.DesktopSourcesSQL(' || FILTER || ',' || user_sid || ',' || ACTIVE_FILTER || ',' || p_OtherSearchCriteria || ',' || APXWS_MAX_ROW_CNT || ',' || p_WorksheetID || ',' || p_APP_USER || ',' || p_Instance || ')');

         column_names('C002'):='f.id';
         column_names('C003'):='st.description';
         column_names('C004'):='Osi_Object.get_lead_agent_name(s.SID)';
         column_names('C005'):='osi_unit.get_name(osi_object.get_assigned_unit(s.sid))';
         column_names('C006'):='o.create_on';
         column_names('C007'):='osi_object.get_status(s.sid)';
         column_names('C008'):='mc.description';
         column_names('C009'):='f.title';
         column_names('C010'):='osi_status.last_sh_date(f.sid,''AC'')'; 
         column_names('C011'):='osi_status.last_sh_date(f.sid,''TM'')'; 

         UnitSID := Osi_Personnel.get_current_unit(user_sid);
         
         --- Main Select ---
         if p_isLocator = 'Y' then
           
           SQLString := addLocatorReturnLink('s.sid', p_isLocatorMulti, p_ReturnPageItemName, p_isLocateMany);
           
         else
                  
           SQLString := 'select ''javascript:getObjURL('''''' || s.sid || '''''');'' url,';
           
         end if;
         
         SQLString := SQLString || 
                      'f.id as "ID",' || 
                      'st.description as "Source Type",' || 
                      'Osi_Object.get_lead_agent_name(s.SID) as "Lead Agent",' || 
                      'osi_unit.get_name(osi_object.get_assigned_unit(s.sid)) as "Controlling Unit",' || 
                      'o.create_on as "Date Created",' || 
                      'osi_object.get_status(s.sid) as "Status",' || 
                      'mc.description as "Mission Area",' || 
                      'f.title as "Title",' ||
                      'osi_status.last_sh_date(f.sid,''AC'') as "Date Opened",' || 
                      'osi_status.last_sh_date(f.sid,''TM'') as "Date Closed"'; 

                      
         --- Fields only Needed for Recent/Recent Unit Filters  ---
         IF FILTER IN ('RECENT','RECENT_UNIT') THEN

           SQLString := SQLString || AddRankingToSelect('N','Y','N',FILTER);
    
         ELSE

           SQLString := SQLString || AddRankingToSelect('Y','Y','N',FILTER);
         
         END IF;

         --- From Clause ---
         SQLString := SQLString || 
                      ' from T_CORE_OBJ o,' || 
                      'T_OSI_FILE f,' || 
                      'T_OSI_F_SOURCE s,' || 
                      'T_OSI_F_SOURCE_TYPE st,' || 
                      'T_OSI_MISSION_CATEGORY mc';

         --- From portion  Needed for Recent/Recent Unit Filters  ---
         IF FILTER IN ('RECENT','RECENT_UNIT') THEN
          
           SQLString := SQLString || ',' || 
                        't_osi_personnel_recent_objects r1';
        
         END IF;              

         --- Where Clause  ---
         IF FILTER NOT IN ('NONE') THEN

           SQLString := SQLString || 
                        ' WHERE s.SID=o.SID' || 
                        ' AND s.SID=f.SID' || 
                        ' AND s.source_type=st.sid' || 
                        ' AND mc.sid(+) = s.mission_area';
                        
         END IF;

         IF ACTIVE_FILTER='ACTIVE' THEN

           SQLString := SQLString || 
                        ' AND OSI_OBJECT.IS_OBJECT_ACTIVE(s.SID)=''Y''';
         
         ELSIF ACTIVE_FILTER IS NOT NULL AND ACTIVE_FILTER!='ALL' then

              SQLString := SQLString || 
                           ' AND s.source_type=' || '''' || ACTIVE_FILTER || '''';
                            
         END IF;

         --- Add the Max Row Number Check ---
         SQLString := SQLString || 
                      ' AND ROWNUM<=' || APXWS_MAX_ROW_CNT;

         --- Add Excludes if Needed ---
         if p_Exclude is not null then
         
           SQLString := SQLString || 
                        ' AND instr(' || '''' || p_Exclude || '''' || ',s.sid) = 0';
         
         end if;
                                         
         --- Add Search Filters ---
         SQLString := SQLString || AddApexSearchFilters(p_OtherSearchCriteria, column_names, p_WorksheetID, p_APP_USER, p_Instance, p_ReportName);

         --- Add Pieces to the Where Clause depending on the Filter ---
         CASE 
             
                              WHEN FILTER='ME' THEN
                                                   SQLString := SQLString ||  
                                                                ' AND OSI_OBJECT.IS_ASSIGNED(s.sid,''' || user_sid ||  '''' || ')=''Y''' || 
                                                                ' ORDER BY ID'; 
             
                            WHEN FILTER='UNIT' THEN
                                                   SQLString := SQLString ||  
                                                                ' AND osi_object.get_assigned_unit(s.sid)=''' || UnitSID || '''' || 
                                                                ' ORDER BY ID'; 

                        WHEN FILTER='SUB_UNIT' THEN
                                                   SQLString := SQLString ||  
                                                                ' AND osi_object.get_assigned_unit(s.sid) in ' || Get_Subordinate_Units(UnitSID) || 
                                                                ' ORDER BY ID'; 
            
                        WHEN FILTER='SUP_UNIT' THEN
                                                   SQLString := SQLString ||  
                                                                ' AND osi_object.get_assigned_unit(s.sid) IN ' || Get_Supported_Units(UnitSID) || 
                                                                ' ORDER BY ID'; 
                                                     
                          WHEN FILTER='RECENT' THEN
                                                   SQLString := SQLString ||   
                                                                ' AND r1.obj=o.sid' || 
                                                                ' AND r1.personnel=''' || user_sid ||  '''' || 
                                                                ' ORDER BY "Ranking" DESC,KEEP_ON_TOP DESC';

                     WHEN FILTER='RECENT_UNIT' THEN
                                                   SQLString := SQLString ||  
                                                                ' AND r1.obj=o.sid' || 
                                                                ' AND r1.unit=''' || UnitSID ||  '''' ||
                                                                ' group by s.sid,f.id,st.description,o.create_on,mc.description,f.title,r1.keep_on_top' || 
                                                                ' ORDER BY "Ranking" DESC,KEEP_ON_TOP DESC';

             WHEN FILTER='ALL' OR FILTER='OSI' THEN            
                                                   SQLString := SQLString ||  
                                                                ' ORDER BY ID'; 
                                                                
                            WHEN FILTER='NONE' THEN            
                                                   SQLString := SQLString ||  
                                                                ' WHERE 1=2';
 
         END CASE;
         
         log_error('<<<OSI_DESKTOP.DesktopSourcesSQL(' || FILTER || ',' || user_sid || ',' || ACTIVE_FILTER || ',' || p_OtherSearchCriteria || ',' || APXWS_MAX_ROW_CNT || ',' || p_WorksheetID || ',' || p_APP_USER || ',' || p_Instance || ')');
         RETURN SQLString;
         
    END DesktopSourcesSQL;
    
    /*******************************/ 
    /*  Military Locations Section */   
    /*******************************/ 
    FUNCTION DesktopMilitaryLocationsSQL(FILTER IN VARCHAR2, user_sid IN VARCHAR2, p_ReturnPageItemName IN VARCHAR2:='', ACTIVE_FILTER IN VARCHAR2, p_ObjType IN VARCHAR2, p_OtherSearchCriteria IN VARCHAR2 := '', APXWS_MAX_ROW_CNT IN NUMBER := 10000, p_WorksheetID IN VARCHAR2 := NULL, p_APP_USER IN VARCHAR2 := NULL, p_Instance IN VARCHAR2 := NULL, p_ReportName IN VARCHAR2 := '', p_isLocator IN VARCHAR2 := 'N', p_isLocatorMulti IN VARCHAR2 := 'N', p_Exclude IN VARCHAR2 := '', p_isLocateMany IN VARCHAR2 := 'N') RETURN VARCHAR2 IS

      SQLString VARCHAR2(32000);
      UnitSID VARCHAR2(20);
   
      column_names assoc_arr;
      
    BEGIN
         column_names('C003'):='LOCATION_NAME';
         column_names('C004'):='LOCATION_LONG_NAME';
         column_names('C005'):='LOCATION_CITY';
         column_names('C006'):='LOCATION_STATE_COUNTRY';
         
         UnitSID := Osi_Personnel.get_current_unit(user_sid);
         
         --- Main Select ---
         if p_isLocator = 'Y' then
           
           SQLString := addLocatorReturnLink('l.location_code', p_isLocatorMulti, p_ReturnPageItemName, p_isLocateMany);
           
         else

           SQLString := 'select ''javascript:getObjURL('''''' || l.location_code || '''''');'' url,';
         
         end if;                  
            
         SQLString := SQLString || 
                      'LOCATION_NAME as "Location Name",' || 
                      'LOCATION_LONG_NAME as "Location Long Name",' || 
                      'LOCATION_CITY as "City",' || 
                      'LOCATION_STATE_COUNTRY as "State/Country Name",';

         IF FILTER IN ('RECENT','RECENT_UNIT') THEN

           SQLString := SQLString || AddRankingToSelect('N','N','N',FILTER);
         
         ELSE

           SQLString := SQLString || AddRankingToSelect('Y','N','N',FILTER);
         
         END IF;
                      
         --- From Clause ---
         SQLString := SQLString ||  ' from t_sapro_locations l';

         --- From portion  Needed for Recent/Recent Unit Filters  ---
         IF FILTER IN ('RECENT','RECENT_UNIT') THEN
          
           SQLString := SQLString || ',' || 
                        't_osi_personnel_recent_objects r1';
        
         END IF;              

         --- Add the Max Row Number Check ---
         SQLString := SQLString || 
                      ' WHERE ROWNUM<=' || APXWS_MAX_ROW_CNT;

         --- Add Excludes if Needed ---
         if p_Exclude is not null then
         
           SQLString := SQLString || 
                        ' and instr(' || '''' || p_Exclude || '''' || ',l.location_code) = 0';         

         end if;
         
         --- Add Search Filters ---
         SQLString := SQLString || AddApexSearchFilters(p_OtherSearchCriteria, column_names, p_WorksheetID, p_APP_USER, p_Instance, p_ReportName);

         --- Add Pieces to the Where Clause depending on the Filter ---
         CASE 
             
                            WHEN FILTER='ABC' THEN
                                                   SQLString := SQLString ||  
                                                                ' AND REGEXP_INSTR(LOCATION_NAME,''[a|b|c][[:alpha:]]'',1,1,0,''i'')=1' || 
                                                                ' ORDER BY LOCATION_NAME';
                            WHEN FILTER='DEF' THEN
                                                   SQLString := SQLString ||  
                                                                ' AND REGEXP_INSTR(LOCATION_NAME,''[d|e|f][[:alpha:]]'',1,1,0,''i'')=1' || 
                                                                ' ORDER BY LOCATION_NAME';
                            WHEN FILTER='GHI' THEN
                                                   SQLString := SQLString ||  
                                                                ' AND REGEXP_INSTR(LOCATION_NAME,''[g|h|i][[:alpha:]]'',1,1,0,''i'')=1' || 
                                                                ' ORDER BY LOCATION_NAME';
                            WHEN FILTER='JKL' THEN
                                                   SQLString := SQLString ||  
                                                                ' AND REGEXP_INSTR(LOCATION_NAME,''[j|k|l][[:alpha:]]'',1,1,0,''i'')=1' || 
                                                                ' ORDER BY LOCATION_NAME';
                            WHEN FILTER='MNO' THEN
                                                   SQLString := SQLString ||  
                                                                ' AND REGEXP_INSTR(LOCATION_NAME,''[m|n|o][[:alpha:]]'',1,1,0,''i'')=1' || 
                                                                ' ORDER BY LOCATION_NAME';
                           WHEN FILTER='PQRS' THEN
                                                   SQLString := SQLString ||  
                                                                ' AND REGEXP_INSTR(LOCATION_NAME,''[p|q|r|s][[:alpha:]]'',1,1,0,''i'')=1' || 
                                                                ' ORDER BY LOCATION_NAME';
                            WHEN FILTER='TUV' THEN
                                                   SQLString := SQLString ||  
                                                                ' AND REGEXP_INSTR(LOCATION_NAME,''[t|u|v][[:alpha:]]'',1,1,0,''i'')=1' || 
                                                                ' ORDER BY LOCATION_NAME';
                           WHEN FILTER='WXYZ' THEN
                                                   SQLString := SQLString ||  
                                                                ' AND REGEXP_INSTR(LOCATION_NAME,''[w|x|y|z][[:alpha:]]'',1,1,0,''i'')=1' || 
                                                                ' ORDER BY LOCATION_NAME';
                         WHEN FILTER='NUMERIC' THEN
                                                   SQLString := SQLString ||  
                                                                ' AND REGEXP_INSTR(LOCATION_NAME,''[0-9]'',1,1,0,''i'')=1' || 
                                                                ' ORDER BY LOCATION_NAME';

                           WHEN FILTER='ALPHA' THEN
                                                   SQLString := SQLString ||  
                                                                ' AND REGEXP_INSTR(LOCATION_NAME,''[a-z]'',1,1,0,''i'')=1' || 
                                                                ' ORDER BY LOCATION_NAME';

                          WHEN FILTER='RECENT' THEN             
                                                   SQLString := SQLString ||   
                                                                ' AND r1.obj=location_code' || 
                                                                ' AND r1.personnel=''' || user_sid ||  '''' || 
                                                                ' ORDER BY "Ranking" DESC,KEEP_ON_TOP DESC';

                     WHEN FILTER='RECENT_UNIT' THEN             
                                                   SQLString := SQLString ||  
                                                                '   AND r1.obj=location_code' || 
                                                                '   AND r1.unit=''' || UnitSID ||  '''' || 
                                                                '   group by location_name,location_long_name,location_city,location_state_country,r1.keep_on_top ' ||
                                                                '    ORDER BY "Ranking" DESC,KEEP_ON_TOP DESC';

             WHEN FILTER='ALL' OR FILTER='OSI' THEN            
                                                   SQLString := SQLString ||  
                                                                ' ORDER BY LOCATION_NAME';
                                                                
                            WHEN FILTER='NONE' THEN            
                                                   SQLString := SQLString ||  
                                                                ' AND 1=2';
 
         END CASE;

         RETURN SQLString;
         
    END DesktopMilitaryLocationsSQL;

    /****************************/ 
    /*  Briefing Topics Section */   
    /****************************/ 
    FUNCTION DesktopBriefingTopicsSQL(FILTER IN VARCHAR2, user_sid IN VARCHAR2, p_ReturnPageItemName IN VARCHAR2:='', ACTIVE_FILTER IN VARCHAR2, p_ObjType IN VARCHAR2, p_OtherSearchCriteria IN VARCHAR2 := '', APXWS_MAX_ROW_CNT IN NUMBER := 10000, p_WorksheetID IN VARCHAR2 := NULL, p_APP_USER IN VARCHAR2 := NULL, p_Instance IN VARCHAR2 := NULL, p_ReportName IN VARCHAR2 := '', p_isLocator IN VARCHAR2 := 'N', p_isLocatorMulti IN VARCHAR2 := 'N', p_Exclude IN VARCHAR2 := '', p_isLocateMany IN VARCHAR2 := 'N') RETURN VARCHAR2 IS

      SQLString VARCHAR2(32000);
      UnitSID VARCHAR2(20);
   
      column_names assoc_arr;
      
    BEGIN
         column_names('C003'):='tc.topic_desc';
         column_names('C004'):='tc.subtopic_desc';
         
         UnitSID := Osi_Personnel.get_current_unit(user_sid);

         --- Main Select ---
         if p_isLocator = 'Y' then
           
           SQLString := addLocatorReturnLink('tc.sid', p_isLocatorMulti, p_ReturnPageItemName, p_isLocateMany);
           
         else

           SQLString := 'select ''javascript:getObjURL('''''' || tc.sid || '''''');'' url,';
         
         end if;                  
            
         SQLString := SQLString || 
                      'tc.topic_desc as "Topic",' || 
                      'tc.subtopic_desc as "Sub Topic",';

         IF FILTER IN ('RECENT','RECENT_UNIT') THEN

           SQLString := SQLString || AddRankingToSelect('N','N','N',FILTER);
         
         ELSE

           SQLString := SQLString || AddRankingToSelect('Y','N','N',FILTER);
         
         END IF;
                      
         --- From Clause ---
         SQLString := SQLString ||  ' from v_osi_topic_content tc';

         --- From portion  Needed for Recent/Recent Unit Filters  ---
         IF FILTER IN ('RECENT','RECENT_UNIT') THEN
          
           SQLString := SQLString || ',' || 
                        't_osi_personnel_recent_objects r1';
        
         END IF;              

         --- Add the Max Row Number Check ---
         SQLString := SQLString || 
                      ' WHERE ROWNUM<=' || APXWS_MAX_ROW_CNT;

         SQLString := SQLString || 
                      ' and active=''Y''';
                      
         --- Add Excludes if Needed ---
         if p_Exclude is not null then
         
           SQLString := SQLString || 
                        '  and instr(' || '''' || p_Exclude || '''' || ',tc.sid) = 0';         

         end if;

         --- Add Search Filters ---
         SQLString := SQLString || AddApexSearchFilters(p_OtherSearchCriteria, column_names, p_WorksheetID, p_APP_USER, p_Instance, p_ReportName);

         --- Add Pieces to the Where Clause depending on the Filter ---
         CASE 

                          WHEN FILTER='RECENT' THEN             
                                                   SQLString := SQLString ||   
                                                                ' AND r1.obj=location_code' || 
                                                                ' AND r1.personnel=''' || user_sid ||  '''' || 
                                                                '  ORDER BY "Ranking" DESC,KEEP_ON_TOP DESC';

                     WHEN FILTER='RECENT_UNIT' THEN             
                                                   SQLString := SQLString ||  
                                                                ' AND r1.obj=location_code' || 
                                                                ' AND r1.unit=''' || UnitSID ||  '''' || 
                                                                ' ORDER BY "Ranking" DESC,KEEP_ON_TOP DESC';
                                                    
             WHEN FILTER='ALL' OR FILTER='OSI' THEN            
                                                   SQLString := SQLString ||  
                                                                ' ORDER BY tc.topic_desc,tc.subtopic_desc';
                                                                
                            WHEN FILTER='NONE' THEN            
                                                   SQLString := SQLString ||  
                                                                ' AND 1=2';
 
         END CASE;

         RETURN SQLString;
         
    END DesktopBriefingTopicsSQL;
 
    /********************************/ 
    /*  City, State/Country Section */   
    /********************************/ 
    FUNCTION DesktopCityStateCountrySQL(FILTER IN VARCHAR2, user_sid IN VARCHAR2, p_ReturnPageItemName IN VARCHAR2:='', ACTIVE_FILTER IN VARCHAR2, p_ObjType IN VARCHAR2, p_OtherSearchCriteria IN VARCHAR2 := '', APXWS_MAX_ROW_CNT IN NUMBER := 10000, p_WorksheetID IN VARCHAR2 := NULL, p_APP_USER IN VARCHAR2 := NULL, p_Instance IN VARCHAR2 := NULL, p_ReportName IN VARCHAR2 := '', p_isLocator IN VARCHAR2 := 'N', p_isLocatorMulti IN VARCHAR2 := 'N', p_Exclude IN VARCHAR2 := '', p_isLocateMany IN VARCHAR2 := 'N') RETURN VARCHAR2 IS

      SQLString VARCHAR2(32000);
      UnitSID VARCHAR2(20);
   
      column_names assoc_arr;
      
    BEGIN
         column_names('C003'):='CITY';
         column_names('C004'):='STATE';
         column_names('C005'):='COUNTRY';
         column_names('C006'):='STATE_COUNTRY_CODE';
         
         UnitSID := Osi_Personnel.get_current_unit(user_sid);
         
         --- Main Select ---
         if p_isLocator = 'Y' then
           
           SQLString := addLocatorReturnLink('l.sid', p_isLocatorMulti, p_ReturnPageItemName, p_isLocateMany);
           
         else
                  
           SQLString := 'select ''javascript:getObjURL('''''' || l.sid || '''''');'' url,';
           
         end if;

         SQLString := SQLString || 
                      'CITY as "City",' || 
                      'STATE as "State",' || 
                      'DECODE(COUNTRY,''UNITED STATES OF AMERICA'',''USA'',COUNTRY) as "Country",' || 
                      'STATE_COUNTRY_CODE as "State/Country Code",';

         IF FILTER IN ('RECENT','RECENT_UNIT') THEN

           SQLString := SQLString || AddRankingToSelect('N','N','N',FILTER);
         
         ELSE

           SQLString := SQLString || AddRankingToSelect('Y','N','N',FILTER);
         
         END IF;
                      
         --- From Clause ---
         SQLString := SQLString ||  ' from t_sapro_city_state_country l';

         --- From portion  Needed for Recent/Recent Unit Filters  ---
         IF FILTER IN ('RECENT','RECENT_UNIT') THEN
          
           SQLString := SQLString || ',' || 
                        't_osi_personnel_recent_objects r1';
        
         END IF;              

         --- Add the Max Row Number Check ---
         SQLString := SQLString || 
                      ' WHERE ROWNUM<=' || APXWS_MAX_ROW_CNT;
         
         --- Add Excludes if Needed ---
         if p_Exclude is not null then
         
           SQLString := SQLString || 
                        ' and instr(' || '''' || p_Exclude || '''' || ',l.sid) = 0';         

         end if;

         --- Add Search Filters ---
         SQLString := SQLString || AddApexSearchFilters(p_OtherSearchCriteria, column_names, p_WorksheetID, p_APP_USER, p_Instance, p_ReportName);

         --- Add Pieces to the Where Clause depending on the Filter ---
         CASE 
             
                            WHEN FILTER='ABC' THEN
                                                   SQLString := SQLString ||  
                                                                ' AND REGEXP_INSTR(CITY,''[a|b|c][[:alpha:]]'',1,1,0,''i'')=1' || 
                                                                ' ORDER BY CITY,STATE';
                            WHEN FILTER='DEF' THEN
                                                   SQLString := SQLString ||  
                                                                ' AND REGEXP_INSTR(CITY,''[d|e|f][[:alpha:]]'',1,1,0,''i'')=1' || 
                                                                ' ORDER BY CITY,STATE';
                            WHEN FILTER='GHI' THEN
                                                   SQLString := SQLString ||  
                                                                ' AND REGEXP_INSTR(CITY,''[g|h|i][[:alpha:]]'',1,1,0,''i'')=1' || 
                                                                ' ORDER BY CITY,STATE';
                            WHEN FILTER='JKL' THEN
                                                   SQLString := SQLString ||  
                                                                ' AND REGEXP_INSTR(CITY,''[j|k|l][[:alpha:]]'',1,1,0,''i'')=1' || 
                                                                ' ORDER BY CITY,STATE';
                            WHEN FILTER='MNO' THEN
                                                   SQLString := SQLString ||  
                                                                ' AND REGEXP_INSTR(CITY,''[m|n|o][[:alpha:]]'',1,1,0,''i'')=1' || 
                                                                ' ORDER BY CITY,STATE';
                           WHEN FILTER='PQRS' THEN
                                                   SQLString := SQLString ||  
                                                                ' AND REGEXP_INSTR(CITY,''[p|q|r|s][[:alpha:]]'',1,1,0,''i'')=1' || 
                                                                ' ORDER BY CITY,STATE';
                            WHEN FILTER='TUV' THEN
                                                   SQLString := SQLString ||  
                                                                ' AND REGEXP_INSTR(CITY,''[t|u|v][[:alpha:]]'',1,1,0,''i'')=1' || 
                                                                ' ORDER BY CITY,STATE';
                           WHEN FILTER='WXYZ' THEN
                                                   SQLString := SQLString ||  
                                                                ' AND REGEXP_INSTR(CITY,''[w|x|y|z][[:alpha:]]'',1,1,0,''i'')=1' || 
                                                                ' ORDER BY CITY,STATE';
                         WHEN FILTER='NUMERIC' THEN
                                                   SQLString := SQLString ||  
                                                                ' AND REGEXP_INSTR(CITY,''[0-9]'',1,1,0,''i'')=1' || 
                                                                ' ORDER BY CITY,STATE';

                           WHEN FILTER='ALPHA' THEN
                                                   SQLString := SQLString ||  
                                                                ' AND REGEXP_INSTR(CITY,''[a-z]'',1,1,0,''i'')=1' || 
                                                                ' ORDER BY CITY,STATE';

                          WHEN FILTER='RECENT' THEN             
                                                   SQLString := SQLString ||   
                                                                ' AND r1.obj=l.sid' || 
                                                                ' AND r1.personnel=''' || user_sid ||  '''' || 
                                                                ' ORDER BY "Ranking" DESC,KEEP_ON_TOP DESC';

                     WHEN FILTER='RECENT_UNIT' THEN             
                                                   SQLString := SQLString ||  
                                                                ' AND r1.obj=l.sid' || 
                                                                ' AND r1.unit=''' || UnitSID ||  '''' || 
                                                                ' group by city,state,country,state_country_code,r1.keep_on_top ' ||  
                                                                ' ORDER BY "Ranking" DESC,KEEP_ON_TOP DESC';
                                                    
             WHEN FILTER='ALL' OR FILTER='OSI' THEN            
                                                   SQLString := SQLString ||  
                                                                ' ORDER BY CITY,STATE';
                                                                
                            WHEN FILTER='NONE' THEN            
                                                   SQLString := SQLString ||  
                                                                ' AND 1=2';
 
         END CASE;

         RETURN SQLString;
         
    END DesktopCityStateCountrySQL;

    /*********************/ 
    /*  Offenses Section */   
    /*********************/ 
    FUNCTION DesktopOffensesSQL(FILTER IN VARCHAR2, user_sid IN VARCHAR2, p_ReturnPageItemName IN VARCHAR2:='', ACTIVE_FILTER IN VARCHAR2, p_ObjType IN VARCHAR2, p_OtherSearchCriteria IN VARCHAR2 := '', APXWS_MAX_ROW_CNT IN NUMBER := 10000, p_WorksheetID IN VARCHAR2 := NULL, p_APP_USER IN VARCHAR2 := NULL, p_Instance IN VARCHAR2 := NULL, p_ReportName IN VARCHAR2 := '', p_isLocator IN VARCHAR2 := 'N', p_isLocatorMulti IN VARCHAR2 := 'N', p_Exclude IN VARCHAR2 := '', p_isLocateMany IN VARCHAR2 := 'N') RETURN VARCHAR2 IS

      SQLString VARCHAR2(32000);
      UnitSID VARCHAR2(20);
   
      column_names assoc_arr;
      
    BEGIN
         column_names('C003'):='o.code';
         column_names('C004'):='o.description';
         column_names('C005'):='o.crime_against';
         column_names('C006'):='c.category';
         
         UnitSID := Osi_Personnel.get_current_unit(user_sid);

         --- Main Select ---
         if p_isLocator = 'Y' then
           
           SQLString := addLocatorReturnLink('o.sid', p_isLocatorMulti, p_ReturnPageItemName, p_isLocateMany);
           
         else
                  
           SQLString := 'select ''javascript:getObjURL('''''' || o.sid || '''''');'' url,';
           
         end if;
   
            
         --- Main Select ---
         SQLString := SQLString || 
                      'o.code as "Offense ID",' || 
                      'o.description as "Offense Description",' || 
                      'o.crime_against as "Crime Against",' || 
                      'c.category as "Category",';

         IF FILTER IN ('RECENT','RECENT_UNIT') THEN

           SQLString := SQLString || AddRankingToSelect('N','N','N',FILTER);
         
         ELSE

           SQLString := SQLString || AddRankingToSelect('Y','N','N',FILTER);
         
         END IF;
                      
         --- From Clause ---
         SQLString := SQLString ||  ' from t_dibrs_offense_type o,' || 
                                            't_osi_f_offense_category c';

         --- From portion  Needed for Recent/Recent Unit Filters  ---
         IF FILTER IN ('RECENT','RECENT_UNIT') THEN
          
           SQLString := SQLString || ',' || 
                        't_osi_personnel_recent_objects r1';
        
         END IF;              

         --- Add the Max Row Number Check ---
         SQLString := SQLString || 
                      ' WHERE ROWNUM<=' || APXWS_MAX_ROW_CNT;
         
         --- Add where Clause ---
         SQLString := SQLString || 
                      ' AND c.offense(+)=o.sid' ||  
                      ' AND o.active = ''Y''';
         
         --- Add Excludes if Needed ---
         if p_Exclude is not null then

           SQLString := SQLString || 
                        ' AND instr(' || '''' || p_Exclude || '''' || ',o.sid) = 0' || 
                        ' AND not exists(select 1 from t_dibrs_offense_type o1 where o1.sid=o.SID and instr(' || ''''  || p_Exclude || ''''  || ',o1.sid) > 0)';
                        
         end if;
                           
         --- Add Search Filters ---
         SQLString := SQLString || AddApexSearchFilters(p_OtherSearchCriteria, column_names, p_WorksheetID, p_APP_USER, p_Instance, p_ReportName);

         --- Add Pieces to the Where Clause depending on the Filter ---
         CASE 
             WHEN FILTER IN ('Person','Property','Society') THEN                            
                 
                 SQLString := SQLString ||  
                              ' AND o.crime_against=' || '''' || FILTER || '''' || 
                              ' ORDER BY O.CODE';
                            
             WHEN FILTER IN ('Base Level Economic Crimes','Central Systems Economic Crimes','Counterintelligence','Drug Crimes','General Crimes','Sex Crimes') THEN 
             
                 SQLString := SQLString ||  
                              ' AND c.category=' || '''' || FILTER || '''' || 
                              ' ORDER BY O.CODE';
                                                    
             WHEN FILTER='RECENT' THEN             

                 SQLString := SQLString ||   
                              ' AND r1.obj=o.sid' || 
                              ' AND r1.personnel=''' || user_sid ||  '''' || 
                              ' ORDER BY "Ranking" DESC,KEEP_ON_TOP DESC';

             WHEN FILTER='RECENT_UNIT' THEN             

                 SQLString := SQLString ||  
                              ' AND r1.obj=o.sid' || 
                              ' AND r1.unit=''' || UnitSID ||  '''' || 
                              ' group by o.sid,o.code,o.description,o.crime_against,c.category,r1.keep_on_top' ||
                              ' ORDER BY "Ranking" DESC,KEEP_ON_TOP DESC';
                                                    
             WHEN FILTER IN ('ALL','All Offenses','OSI') THEN            
             
                 SQLString := SQLString ||  
                              ' ORDER BY O.CODE';
                                                                
             WHEN FILTER='NONE' THEN            

                 SQLString := SQLString ||  
                              ' AND 1=2';
 
         END CASE;

         RETURN SQLString;
         
    END DesktopOffensesSQL;
    
    /*****************************/ 
    /*  Full Text Search Section */   
    /*****************************/ 
    FUNCTION DesktopFullTextSearchSQL(FILTER IN VARCHAR2, SearchCriteria IN VARCHAR2, ACTIVE_FILTER IN VARCHAR2) RETURN VARCHAR2 IS

      SQLString VARCHAR2(32000);
      UnitSID VARCHAR2(20);
      objTypeFILE VARCHAR2(20);
      objTypeACT VARCHAR2(20);
      objTypePART VARCHAR2(20);
      whereClause VARCHAR2(5000);
      
    BEGIN
         log_error('>>>OSI_DESKTOP.DesktopFullTextSearchSQL(' || FILTER || ',' || SearchCriteria || ',' || ACTIVE_FILTER || ')');

         objTypeFILE := core_obj.lookup_objtype('FILE'); 
         objTypeACT  := core_obj.lookup_objtype('ACT'); 
         objTypePART := core_obj.lookup_objtype('PARTICIPANT'); 
         
         --- Main Select ---
         SQLString := 'SELECT DISTINCT ''javascript:getObjURL(''''''|| o.SID ||'''''');'' as url,' || 
                      'o.sid,' || 
                      'core_obj.get_tagline(o.sid) as "Title",' || 
                      'ot.description as "Object Type",' || 
                      'o.create_on as "Created On",' || 
                      'o.create_by as "Created By",' || 
                      'score(1) as "Score",' || 
                      'osi_vlt.get_vlt_url(o.sid) as "VLT",' || 
                      'null as "Summary"';

         --- From Clause ---
         SQLString := SQLString || 
                      ' from T_CORE_OBJ o,' || 
                      'T_CORE_OBJ_TYPE ot';

         IF ACTIVE_FILTER IN ('INCLUDE','ONLY') THEN

           SQLString := SQLString || ',' || 
                        'T_OSI_ATTACHMENT a';
                        
         END IF;

         --- Where Clause  ---
         SQLString := SQLString || 
                      ' WHERE o.obj_type=ot.sid';

         IF INSTR(FILTER, 'FILE') > 0 THEN

           whereClause := whereClause || '''' || objTypeFILE || '''' || ' member of osi_object.get_objtypes(ot.sid) or ';
                        
         END IF;
         IF INSTR(FILTER, 'ACT') > 0 THEN

           whereClause := whereClause || '''' || objTypeACT || '''' || ' member of osi_object.get_objtypes(ot.sid) or ';
                        
         END IF;
         IF INSTR(FILTER, 'PART') > 0 THEN

           whereClause := whereClause || '''' || objTypePART || '''' || ' member of osi_object.get_objtypes(ot.sid) or ';
                        
         END IF;
         
         IF whereClause is not null THEN
         
           SQLString := SQLString || 
                        ' AND (' || substr(whereClause, 1, length(whereClause)-4) || ')';
                        
         END IF;
         
         IF ACTIVE_FILTER = 'NONE' THEN

           SQLString := SQLString || 
                        ' and contains(o.doc1, nvl(''' || SearchCriteria || ''',''zzz''),1)>0';
         
         ELSIF ACTIVE_FILTER = 'INCLUDE' THEN

               SQLString := SQLString || 
                            ' and o.sid=a.obj(+)' || 
                            ' and (contains(o.doc1, nvl(''' || SearchCriteria || ''',''zzz''),1)>0' || 
                            ' or contains(a.content, nvl(''' || SearchCriteria || ''',''zzz''),2)>0)';


         ELSIF ACTIVE_FILTER = 'ONLY' THEN

               SQLString := SQLString || 
                            ' and o.sid=a.obj(+)' || 
                            ' and contains(a.content, nvl(''' || SearchCriteria || ''',''zzz''),1)>0';
                            
         END IF;
         SQLString := SQLString ||  ' order by score(1) desc';
         
         log_error('<<<OSI_DESKTOP.DesktopFullTextSearchSQL(' || FILTER || ',' || SearchCriteria || ',' || ACTIVE_FILTER || ')');
         RETURN SQLString;
         
   END DesktopFullTextSearchSQL;

    /*****************/ 
    /*  Unit Section */   
    /*****************/ 
    FUNCTION DesktopUnitSQL(FILTER IN VARCHAR2, user_sid IN VARCHAR2, p_ReturnPageItemName IN VARCHAR2:='', ACTIVE_FILTER IN VARCHAR2, p_ObjType IN VARCHAR2, p_OtherSearchCriteria IN VARCHAR2 := '', APXWS_MAX_ROW_CNT IN NUMBER := 10000, p_WorksheetID IN VARCHAR2 := NULL, p_APP_USER IN VARCHAR2 := NULL, p_Instance IN VARCHAR2 := NULL, p_ReportName IN VARCHAR2 := '', p_isLocator IN VARCHAR2 := 'N', p_isLocatorMulti IN VARCHAR2 := 'N', p_Exclude IN VARCHAR2 := '', p_UnitType IN VARCHAR2 := 'UNIT', p_isLocateMany IN VARCHAR2 := 'N') RETURN VARCHAR2 IS

      SQLString VARCHAR2(32000);
      UnitSID VARCHAR2(20);

      column_names assoc_arr;
   
    BEGIN
         log_error('>>>OSI_DESKTOP.DesktopUnitSQL(' || FILTER || ',' || user_sid || ',' || ACTIVE_FILTER || ',' || p_OtherSearchCriteria || ',' || APXWS_MAX_ROW_CNT || ',' || p_WorksheetID || ',' || p_APP_USER || ',' || p_Instance || ')');

         column_names('C002'):='u.unit_code';
         column_names('C003'):='un1.unit_name';
         column_names('C004'):='un2.unit_name';

         UnitSID := Osi_Personnel.get_current_unit(user_sid);
         
         --- Main Select ---
         if p_isLocator = 'Y' then
           
           SQLString := addLocatorReturnLink('u.sid', p_isLocatorMulti, p_ReturnPageItemName, p_isLocateMany);
           
         else
                  
           SQLString := 'select ''javascript:getObjURL('''''' || u.sid || '''''');'' url,';
           
         end if;

         SQLString := SQLString || 
                      'u.unit_code as "Code",' || 
                      'un1.unit_name as "Name",' || 
                      'un2.unit_name as "Parent"';
                      
         --- Fields only Needed for Recent/Recent Unit Filters  ---
         IF FILTER IN ('RECENT','RECENT_UNIT') THEN

           SQLString := SQLString || AddRankingToSelect('N','Y','N',FILTER);
         
         ELSE

           SQLString := SQLString || AddRankingToSelect('Y','Y','N',FILTER);
         
         END IF;
         
         --- From Clause ---
         SQLString := SQLString || 
                      ' from t_osi_unit u,' || 
                      't_osi_unit_name un1,' || 
                      't_osi_unit_name un2';

         --- From portion  Needed for Recent/Recent Unit Filters  ---
         IF FILTER IN ('RECENT','RECENT_UNIT') THEN
          
           SQLString := SQLString || ',' || 
                        't_osi_personnel_recent_objects r1';
        
         END IF;              
         
         --- Add the E-Funds Unit table if needed ---
         IF p_UnitType = 'EFUNDS' THEN
          
           SQLString := SQLString || ',' || 
                        't_cfunds_unit cu';
         END IF;
         
         --- Where Clause  ---
         IF FILTER NOT IN ('NONE') THEN

           SQLString := SQLString || 
                        ' WHERE (u.sid=un1.unit and un1.end_date is null)' || 
                        ' AND (u.unit_parent=un2.unit(+) and un2.end_date is null)';
                        
         END IF;
                                         
         --- Add the Max Row Number Check ---
         SQLString := SQLString || 
                      ' AND ROWNUM<=' || APXWS_MAX_ROW_CNT;

         --- Add Excludes if Needed ---
         if p_Exclude is not null then
         
           SQLString := SQLString || 
                        ' and instr(' || '''' || p_Exclude || '''' || ',u.sid) = 0';         

         end if;
         
         --- Add the RPO Unit check if needed ---
         if (p_UnitType = 'RPO') then

           SQLString := SQLString || 
                        ' and u.sid in (select sup_unit from t_osi_unit_sup_units u,t_osi_mission_category c where u.MISSION=c.sid and c.code=''21'')';         

         end if;
         
         --- Add the E-Funds Unit check if needed ---
         IF p_UnitType = 'EFUNDS' THEN
          
           SQLString := SQLString || 
                        ' and cu.sid = u.sid';
                        
         END IF;
         
         --- Add Search Filters ---
         SQLString := SQLString || AddApexSearchFilters(p_OtherSearchCriteria, column_names, p_WorksheetID, p_APP_USER, p_Instance, p_ReportName);

         --- Add Pieces to the Where Clause depending on the Filter ---
         CASE 
             
                              WHEN FILTER='ME' THEN
                                                   SQLString := SQLString ||  
                                                                ' AND u.sid=''' || UnitSID || '''' || 
                                                                ' ORDER BY un1.unit_name';
             
                            WHEN FILTER='UNIT' THEN
                                                   SQLString := SQLString ||  
                                                                ' AND u.sid=''' || UnitSID || '''' || 
                                                                ' ORDER BY un1.unit_name';

                        WHEN FILTER='SUB_UNIT' THEN
                                                   SQLString := SQLString ||  
                                                                ' AND u.sid in ' || Get_Subordinate_Units(UnitSID) || 
                                                                ' ORDER BY un1.unit_name';
                                                                            
                        WHEN FILTER='SUP_UNIT' THEN
                                                   SQLString := SQLString ||  
                                                                ' AND u.sid IN ' || Get_Supported_Units(UnitSID) || 
                                                                ' ORDER BY un1.unit_name';
                                                     
                          WHEN FILTER='RECENT' THEN
                                                   SQLString := SQLString ||   
                                                                ' AND r1.obj=u.sid' || 
                                                                ' AND r1.personnel=''' || user_sid ||  '''' || 
                                                                ' ORDER BY "Ranking" DESC,KEEP_ON_TOP DESC';

                     WHEN FILTER='RECENT_UNIT' THEN
                                                   SQLString := SQLString ||  
                                                                ' AND r1.obj=u.sid' || 
                                                                ' AND r1.unit=''' || UnitSID ||  '''' || 
                                                                ' group by u.sid,u.unit_code,un1.unit_name,un2.unit_name,r1.keep_on_top' ||
                                                                ' ORDER BY "Ranking" DESC,KEEP_ON_TOP DESC';
                                                                
             WHEN FILTER='ALL' OR FILTER='OSI' THEN            
                                                   SQLString := SQLString ||  
                                                                ' ORDER BY un1.unit_name';
                                                                
                            WHEN FILTER='NONE' THEN            
                                                   SQLString := SQLString ||  
                                                                ' WHERE 1=2';
 
         END CASE;
         
         log_error('<<<OSI_DESKTOP.DesktopUnitSQL(' || FILTER || ',' || user_sid || ',' || ACTIVE_FILTER || ',' || p_OtherSearchCriteria || ',' || APXWS_MAX_ROW_CNT || ',' || p_WorksheetID || ',' || p_APP_USER || ',' || p_Instance || ')');
         RETURN SQLString;
         
    END DesktopUnitSQL;

    /***********************/ 
    /*  Workhours Section  */   
    /***********************/ 
    FUNCTION DesktopWorkHoursSQL(FILTER IN VARCHAR2, user_sid IN VARCHAR2, ACTIVE_FILTER IN VARCHAR2, p_OtherSearchCriteria IN VARCHAR2 := '', APXWS_MAX_ROW_CNT IN NUMBER := 10000, p_WorksheetID IN VARCHAR2 := NULL, p_APP_USER IN VARCHAR2 := NULL, p_Instance IN VARCHAR2 := NULL, p_ReportName IN VARCHAR2 := '') RETURN VARCHAR2 IS

      SQLString VARCHAR2(32000);
      UnitSID VARCHAR2(20);
   
      column_names assoc_arr;
      
    BEGIN
         log_error('>>>OSI_DESKTOP.DesktopWorkHoursSQL(' || FILTER || ',' || user_sid || ',' || ACTIVE_FILTER || ',' || p_OtherSearchCriteria || ',' || APXWS_MAX_ROW_CNT || ',' || p_WorksheetID || ',' || p_APP_USER || ',' || p_Instance || ')');

         column_names('C002'):='osi_personnel.get_name(wh.personnel)';
         column_names('C003'):='to_char(wh.work_date,''dd-Mon-rrrr'')';
         column_names('C004'):='Core_Obj.get_parentinfo(wh.obj)';
         column_names('C005'):='ot.description';
         column_names('C006'):='m.description';
         column_names('C007'):='osi_unit.get_name(osi_personnel.get_current_unit(wh.personnel))';

         UnitSID := Osi_Personnel.get_current_unit(user_sid);
         
         --- Main Select ---
         SQLString := 'SELECT ''javascript:getObjURL(''''''|| wh.obj ||'''''');'' as url,' || 
                      'osi_personnel.get_name(wh.personnel) as "Personnel Name",' || 
                      'wh.work_date as "Date",' || 
                      'Core_Obj.get_parentinfo(wh.obj) as "Context",' || 
                      'wh.hours as "Hours",' || 
                      'ot.description as "Category Description",' || 
                      'm.description as "Mission",' || 
                      'osi_unit.get_name(osi_personnel.get_current_unit(wh.personnel)) as "Unit"';

         --- Fields only Needed for Recent/Recent Unit Filters  ---
         IF FILTER IN ('RECENT','RECENT_UNIT') THEN

           SQLString := SQLString || AddRankingToSelect('N','Y','N',FILTER);
    
         ELSE

           SQLString := SQLString || AddRankingToSelect('Y','Y','N',FILTER);
         
         END IF;
       
         --- From Clause ---
         SQLString := SQLString || 
                      ' from T_OSI_WORK_HOURS wh,' || 
                      'T_OSI_MISSION_CATEGORY m,' || 
                      'T_CORE_OBJ_TYPE ot,' || 
                      'T_CORE_OBJ o';
        
         --- From portion  Needed for Recent/Recent Unit Filters  ---
         IF FILTER IN ('RECENT','RECENT_UNIT') THEN
          
           SQLString := SQLString || ',' || 
                        't_osi_personnel_recent_objects r1';
        
         END IF;              
                      
         --- Where Clause  ---
         IF FILTER NOT IN ('NONE') THEN

           SQLString := SQLString || 
                        ' WHERE wh.obj=o.sid' || 
                        ' AND wh.mission=m.sid(+)' || 
                        ' AND ot.sid=o.obj_type';
                        
         END IF;

         --- Add the Max Row Number Check ---
         SQLString := SQLString || 
                      '    AND ROWNUM <=' || APXWS_MAX_ROW_CNT;

         --- Add Search Filters ---
         SQLString := SQLString || AddApexSearchFilters(p_OtherSearchCriteria, column_names, p_WorksheetID, p_APP_USER, p_Instance, p_ReportName);

         --- Add Pieces to the Where Clause depending on the Filter ---
         CASE 
             
                              WHEN FILTER='ME' THEN
                                                   SQLString := SQLString ||  
                                                                ' AND wh.personnel=''' || user_sid || '''' || 
                                                                ' ORDER BY PERSONNEL';
             
                            WHEN FILTER='UNIT' THEN
                                                   SQLString := SQLString ||  
                                                                ' AND osi_personnel.get_current_unit(wh.personnel)=''' || UnitSID ||  '''' || 
                                                                ' ORDER BY "Personnel Name"';

                        WHEN FILTER='SUB_UNIT' THEN
                                                   SQLString := SQLString ||  
                                                                ' AND osi_personnel.get_current_unit(wh.personnel) in ' || Get_Subordinate_Units(UnitSID) || 
                                                                ' ORDER BY "Personnel Name"';
            
                        WHEN FILTER='SUP_UNIT' THEN
                                                   SQLString := SQLString ||  
                                                                ' AND osi_personnel.get_current_unit(wh.personnel) IN ' || Get_Supported_Units(UnitSID) || 
                                                                ' ORDER BY "Personnel Name"';
                                                     
                          WHEN FILTER='RECENT' THEN
                                                   SQLString := SQLString ||  
                                                                ' AND r1.obj=o.sid' || 
                                                                ' AND r1.personnel=''' || user_sid ||  '''' || 
                                                                ' ORDER BY "Ranking" DESC,KEEP_ON_TOP DESC';

                     WHEN FILTER='RECENT_UNIT' THEN
                                                   SQLString := SQLString ||  
                                                                ' AND r1.obj=o.sid' || 
                                                                ' AND r1.unit=''' || UnitSID ||  '''' || 
                                                                ' group by wh.obj,wh.personnel,wh.work_date,wh.hours,ot.description,m.description,r1.keep_on_top' ||
                                                                ' ORDER BY "Ranking" DESC,KEEP_ON_TOP DESC';

             WHEN FILTER='ALL' OR FILTER='OSI' THEN            
                                                   SQLString := SQLString ||  
                                                                ' ORDER BY "Personnel Name"';
                                                   
                            WHEN FILTER='NONE' THEN            
                                                   SQLString := SQLString ||  
                                                                ' WHERE 1=2';
                                                                                                               
         END CASE;
         
         log_error('<<<OSI_DESKTOP.DesktopWorkHoursSQL(' || FILTER || ',' || user_sid || ',' || ACTIVE_FILTER || ',' || p_OtherSearchCriteria || ',' || APXWS_MAX_ROW_CNT || ',' || p_WorksheetID || ',' || p_APP_USER || ',' || p_Instance || ')');
         RETURN SQLString;
         
    END DesktopWorkHoursSQL;

   procedure AddFilter(P_ORIGINAL in out nocopy Varchar2, P_APPEND in Varchar2, P_SEPARATOR in Varchar2 := ', ', P_EXCLUDE in Varchar2 := '') is
   begin
        if instr(P_EXCLUDE, P_APPEND) <= 0 or P_EXCLUDE is null or P_EXCLUDE='' then

          if P_APPEND is not null then                                   

            if P_ORIGINAL is not null then

              P_ORIGINAL := P_ORIGINAL || P_SEPARATOR;

            end if;

            P_ORIGINAL := P_ORIGINAL || P_APPEND;
          
          end if;
        
        end if;
        
   exception
        when OTHERS then
            log_error('>>>AddFilter Error: ' || sqlerrm);

   end AddFilter;

   FUNCTION get_filter_lov(p_ObjType IN VARCHAR2, p_Filter_Excludes IN VARCHAR2 := '') RETURN VARCHAR2 IS

           v_lov    VARCHAR2(32000) := NULL;
           v_Filter_Excludes VARCHAR2(32000);

   BEGIN
        v_Filter_Excludes := replace(p_Filter_Excludes,'~',',');
        
        log_error('>>>OSI_DESKTOP.get_filter_lov(' || p_ObjType || ')');
        CASE 
            WHEN p_ObjType IN ('ACT','CFUNDS_ADV','CFUNDS_EXP','EMM','FILE', 'FILE.INV', 'FILE.INV.CASE', 'FILE.INV.DEV', 'FILE.INV.INFO',
                               'FILE.SERVICE','FILE.AAPP','FILE.GEN.ANP','FILE.PSO','FILE.POLY_FILE.SEC',
                               'FILE.SUPPORT','FILE.GEN.SRCDEV', 'FILE.GEN.UNDRCVROPSUPP', 'FILE.GEN.TECHSURV', 'FILE.POLY_FILE.CRIM', 'FILE.GEN.TARGETMGMT',
                               'NOTIFICATIONS','PERSONNEL','PERSONNEL_EMAIL','SOURCES','SOURCE','UNITS','UNITS_EFUNDS','WORKHOURS') THEN

                AddFilter(v_lov, 'Me;ME', ',', v_Filter_Excludes);
                AddFilter(v_lov, 'My Unit;UNIT', ',', v_Filter_Excludes);
                AddFilter(v_lov, 'Supported Units;SUP_UNIT', ',', v_Filter_Excludes);
                AddFilter(v_lov, 'Subordinate Units;SUB_UNIT', ',', v_Filter_Excludes);
                AddFilter(v_lov, 'Recent;RECENT', ',', v_Filter_Excludes);
                AddFilter(v_lov, 'Recent My Unit;RECENT_UNIT', ',', v_Filter_Excludes);
                --AddFilter(v_lov, 'Nothing;NONE', ',', v_Filter_Excludes);
                AddFilter(v_lov, 'All OSI;OSI', ',', v_Filter_Excludes);

            WHEN p_ObjType IN ('CITY_STATE_COUNTRY','MILITARY_LOCS',
                               'PARTICIPANT','PART.INDIV','PART.NONINDIV.COMP','PART.NONINDIV.ORG','PART.NONINDIV.PROG') THEN

                AddFilter(v_lov, 'Recent;RECENT', v_Filter_Excludes);	 	 
                AddFilter(v_lov, 'Recent My Unit;RECENT_UNIT', v_Filter_Excludes);	 	 
                --AddFilter(v_lov, 'Nothing;NONE', ',', v_Filter_Excludes);		 
                AddFilter(v_lov, 'ABC;ABC', ',', v_Filter_Excludes);	 	 
                AddFilter(v_lov, 'DEF;DEF', ',', v_Filter_Excludes);	 	 
                AddFilter(v_lov, 'GHI;GHI', ',', v_Filter_Excludes);	 	 
                AddFilter(v_lov, 'JKL;JKL', ',', v_Filter_Excludes);	 	 
                AddFilter(v_lov, 'MNO;MNO', ',', v_Filter_Excludes);	 	 
                AddFilter(v_lov, 'PQRS;PQRS', ',', v_Filter_Excludes);	 	 
                AddFilter(v_lov, 'TUV;TUV', ',', v_Filter_Excludes);	 	 
                AddFilter(v_lov, 'WXYZ;WXYZ', ',', v_Filter_Excludes);	 	 
                AddFilter(v_lov, 'Numeric;NUMERIC', ',', v_Filter_Excludes);	 	 
                AddFilter(v_lov, 'Alphabetic;ALPHA', ',', v_Filter_Excludes);	 	 
                AddFilter(v_lov, 'All OSI;ALL', ',', v_Filter_Excludes);

            WHEN p_ObjType IN ('OFFENSE','OFFENSES','MATTERS INVESTIGATED','MATTERS') THEN
                
                AddFilter(v_lov, 'Recent;RECENT', ',', v_Filter_Excludes);	 	 
                AddFilter(v_lov, 'Recent My Unit;RECENT_UNIT', ',', v_Filter_Excludes);	 	 
                AddFilter(v_lov, 'All Offenses;All Offenses', ',', v_Filter_Excludes);
                for a in (select distinct(category) as category from t_osi_f_offense_category  union
                          select distinct('Crimes against ' || crime_against) as category from t_dibrs_offense_type where active='Y' and crime_against not in ('Not a Crim','Don''t Use') order by category)
                loop
                    if (a.category='Counterintelligence') then

                      AddFilter(v_lov, 'Crimes against ' || a.category || ';' || replace(a.category, 'Crimes against ',''), ',', v_Filter_Excludes);

                    else

                      AddFilter(v_lov, a.category || ';' || replace(a.category, 'Crimes against ',''), ',', v_Filter_Excludes);

                    end if;
                    
                end loop;
                                
            --WHEN p_ObjType='BRIEFING' THEN

            --WHEN p_ObjType='FULLTEXTSEARCH' THEN
            
            ELSE
                v_lov:='';
                
        END CASE;

       log_error('<<<OSI_DESKTOP.get_filter_lov(' || p_ObjType || ')');
       RETURN v_lov;

   EXCEPTION
       WHEN OTHERS THEN
           log_error('<<<osi_desktop.get_filter_lov: ' || SQLERRM);
           RETURN NULL;
   END get_filter_lov;

   FUNCTION get_active_filter_lov(p_ObjType IN VARCHAR2, p_Active_Filter_Excludes IN VARCHAR2 := '') RETURN VARCHAR2 IS

           v_lov    VARCHAR2(32000) := NULL;
           v_Active_Filter_Excludes VARCHAR2(32000);

   BEGIN
        v_Active_Filter_Excludes := replace(p_Active_Filter_Excludes,'~',',');
        log_error('>>>OSI_DESKTOP.get_active_filter_lov(' || p_ObjType || ')');
        CASE 
            WHEN p_ObjType IN ('ACT','CFUNDS_ADV','CFUNDS_EXP',
                               'FILE', 'FILE.INV', 'FILE.INV.CASE', 'FILE.INV.DEV', 'FILE.INV.INFO',
                               'FILE.SERVICE','FILE.AAPP','FILE.GEN.ANP','FILE.PSO','FILE.POLY_FILE.SEC',
                               'FILE.SUPPORT','FILE.GEN.SRCDEV', 'FILE.GEN.UNDRCVROPSUPP', 'FILE.GEN.TECHSURV', 'FILE.POLY_FILE.CRIM', 'FILE.GEN.TARGETMGMT') THEN

                AddFilter(v_lov, 'Active;ACTIVE', ',', v_Active_Filter_Excludes);
                AddFilter(v_lov, 'All;ALL', ',', v_Active_Filter_Excludes);

            WHEN p_ObjType IN ('PARTICIPANT','PART.INDIV','PART.NONINDIV.COMP','PART.NONINDIV.ORG','PART.NONINDIV.PROG') THEN
            
                AddFilter(v_lov, 'All Participant Types;ALL', ',', v_Active_Filter_Excludes);
                AddFilter(v_lov, 'Companies;PART.NONINDIV.COMP', ',', v_Active_Filter_Excludes);
                AddFilter(v_lov, 'Individuals by Name;PART.INDIV', ',', v_Active_Filter_Excludes);
                AddFilter(v_lov, 'Organizations;PART.NONINDIV.ORG', ',', v_Active_Filter_Excludes);
                AddFilter(v_lov, 'Programs;PART.NONINDIV.PROG', ',', v_Active_Filter_Excludes);

            WHEN p_ObjType IN ('SOURCE','SOURCES') THEN

                AddFilter(v_lov, 'Active;ACTIVE', ',', v_Active_Filter_Excludes);
                AddFilter(v_lov, 'All;ALL', ',', v_Active_Filter_Excludes);
                
                for a in (select * from t_osi_f_source_type order by description)
                loop
                    AddFilter(v_lov, a.description || ';' || a.sid, ',', v_Active_Filter_Excludes);
                
                end loop;

            --WHEN p_ObjType='BRIEFING' THEN

            --WHEN p_ObjType='EMM' THEN

            --WHEN p_ObjType='FULLTEXTSEARCH' THEN

            --WHEN p_ObjType='NOTIFICATIONS' THEN

            --WHEN p_ObjType='PERSONNEL' THEN

            --WHEN p_ObjType='MILITARY_LOCS' THEN

            --WHEN p_ObjType='CITY_STATE_COUNTRY' THEN

            --WHEN p_ObjType='UNITS' THEN

            --WHEN p_ObjType='WORKHOURS' THEN

            ELSE
                v_lov:='';
                
        END CASE;

        log_error('<<<OSI_DESKTOP.get_active_filter_lov(' || p_ObjType || ')');
       RETURN v_lov;

   EXCEPTION
       WHEN OTHERS THEN
           log_error('<<<osi_desktop.get_active_filter_lov: ' || SQLERRM);
           RETURN NULL;
   END get_active_filter_lov;
   
   FUNCTION get_participants_lov(p_Comps_Orgs IN VARCHAR2 := '') RETURN VARCHAR2 IS

           v_lov VARCHAR2(32000) := NULL;

   BEGIN
        log_error('>>>OSI_DESKTOP.get_participants_lov(' || p_Comps_Orgs || ')');

        ----for a in (SELECT this_partic_name d, this_partic r, this_partic, that_partic FROM V_OSI_PARTIC_RELATION_2WAY where instr(p_Comps_Orgs,that_partic)>0 order by d)
        for a in (SELECT distinct this_partic_name d, this_partic r, this_partic, that_partic FROM V_OSI_PARTIC_RELATION_2WAY,T_CORE_OBJ O,T_CORE_OBJ_TYPE OT where O.SID=THIS_PARTIC AND O.OBJ_TYPE=OT.SID AND OT.CODE IN ('PART.INDIV') AND instr(p_Comps_Orgs,that_partic)>0 order by d)
        loop
            v_lov := v_lov || '^^' || a.d || ';' || a.r;
            
        end loop;

       log_error('<<<OSI_DESKTOP.get_participants_lov(' || p_Comps_Orgs || ')');
       RETURN v_lov;

   EXCEPTION
       WHEN OTHERS THEN
           log_error('<<<osi_desktop.get_participants_lov: ' || SQLERRM);
           RETURN NULL;
   END get_participants_lov;
    
   FUNCTION DesktopSQL(FILTER IN VARCHAR2, user_sid IN VARCHAR2, p_ObjType IN VARCHAR2, p_ReturnPageItemName IN VARCHAR2:='', ACTIVE_FILTER IN VARCHAR2 := 'ACTIVE', NUM_ROWS IN NUMBER := 15, PAGE_ID IN VARCHAR2 := 'P', p_OtherSearchCriteria IN VARCHAR2 := '', APXWS_MAX_ROW_CNT IN VARCHAR2 := '10000', p_WorksheetID IN VARCHAR2 := NULL, p_APP_USER IN VARCHAR2 := NULL, p_Instance IN VARCHAR2 := NULL, p_ReportName IN VARCHAR2 := '', p_isLocator IN VARCHAR2 := 'N', p_isLocatorMulti IN VARCHAR2 := 'N', p_Exclude IN VARCHAR2 := '', p_isLocateMany IN VARCHAR2 := 'N') RETURN VARCHAR2 IS

      SQLString VARCHAR2(32000);
      NewFilter VARCHAR2(32000);
      NewActiveFilter VARCHAR2(32000);
      v_temp VARCHAR2(32000);
      v_max_num_rows number;
      
    BEGIN
         log_error('>>>OSI_DESKTOP.DesktopSQL(' || FILTER || ',' || user_sid || ',' || p_ObjType || ',' || p_ReturnPageItemName || ',' || ACTIVE_FILTER || ',' || NUM_ROWS || ',' || PAGE_ID || ',' || p_OtherSearchCriteria || ',' || APXWS_MAX_ROW_CNT || ',' || p_WorksheetID || ',' || p_APP_USER || ',' || p_Instance || ',' || p_ReportName || ',' || p_isLocator || ',' || p_isLocatorMulti || ',' || p_Exclude || ',' || p_isLocateMany || ')');
         
         v_max_num_rows := to_number(nvl(APXWS_MAX_ROW_CNT,'10000'));

         NewFilter := FILTER;
         NewActiveFilter := ACTIVE_FILTER;
         IF p_ObjType NOT IN ('FULLTEXTSEARCH') THEN

           IF p_ObjType IN ('OFFENSE','OFFENSES','MATTERS INVESTIGATED','MATTERS') THEN

             IF NewFilter NOT IN ('Person','Property','Society','Base Level Economic Crimes','Central Systems Economic Crimes','Counterintelligence','Drug Crimes','General Crimes','Sex Crimes','RECENT','RECENT_UNIT','ALL','All Offenses','OSI') OR NewFilter IS NULL THEN
 
               log_error('Filter not Supported, Changed to: RECENT');
               NewFilter := 'RECENT';
               
             END IF;
                        
           ELSIF p_ObjType NOT IN ('MILITARY_LOCS','CITY_STATE_COUNTRY','PARTICIPANT','PART.INDIV','PART.NONINDIV.COMP','PART.NONINDIV.ORG','PART.NONINDIV.PROG') THEN
  
                IF NewFilter NOT IN ('ME','UNIT','SUB_UNIT','SUP_UNIT','RECENT','RECENT_UNIT','ALL','OSI','NONE') OR NewFilter IS NULL THEN
           
                  log_error('Filter not Supported, Changed to: RECENT');
                  NewFilter := 'RECENT';
           
                END IF;

           ELSE

             IF NewFilter NOT IN ('ABC','DEF','GHI','JKL','MNO','PQRS','TUV','WXYZ','NUMERIC','ALPHA','ALL','RECENT','RECENT_UNIT','OSI','NONE') OR NewFilter IS NULL THEN
           
               log_error('Filter not Supported, Changed to: RECENT');
               NewFilter := 'RECENT';
           
             END IF;

           END IF;
           
         END IF;
          
         CASE 
             WHEN p_ObjType='ACT' THEN
        
                 SQLString := DesktopActivitiesSQL(NewFilter, user_sid, p_ReturnPageItemName, NewActiveFilter, p_ObjType, p_OtherSearchCriteria, v_max_num_rows, p_WorksheetID, p_APP_USER, p_Instance, p_ReportName, p_isLocator, p_isLocatorMulti, p_Exclude, p_isLocateMany);

             WHEN p_ObjType='BRIEFING' THEN

                 NewFilter := 'ALL';
                 SQLString := DesktopBriefingTopicsSQL(NewFilter, user_sid, p_ReturnPageItemName, NewActiveFilter, p_ObjType, p_OtherSearchCriteria, v_max_num_rows, p_WorksheetID, p_APP_USER, p_Instance, p_ReportName, p_isLocator, p_isLocatorMulti, p_Exclude, p_isLocateMany);

             WHEN p_ObjType IN ('FILE', 'FILE.INV', 'FILE.INV.CASE', 'FILE.INV.DEV', 'FILE.INV.INFO',
                                'FILE.SERVICE','FILE.AAPP','FILE.GEN.ANP','FILE.PSO','FILE.POLY_FILE.SEC',
                                'FILE.SUPPORT','FILE.GEN.SRCDEV', 'FILE.GEN.UNDRCVROPSUPP', 'FILE.GEN.TECHSURV', 'FILE.POLY_FILE.CRIM', 'FILE.GEN.TARGETMGMT') THEN
        
                 SQLString := DesktopFilesSQL(NewFilter, user_sid, p_ReturnPageItemName, NewActiveFilter, p_ObjType, p_OtherSearchCriteria, v_max_num_rows, p_WorksheetID, p_APP_USER, p_Instance, p_ReportName, p_isLocator, p_isLocatorMulti, p_Exclude, p_isLocateMany);

             WHEN p_ObjType IN ('PARTICIPANT','PART.INDIV','PART.NONINDIV.COMP','PART.NONINDIV.ORG','PART.NONINDIV.PROG') THEN
        
                 SQLString := DesktopParticipantSQL(NewFilter, user_sid, p_ReturnPageItemName, NewActiveFilter, p_ObjType, p_OtherSearchCriteria, v_max_num_rows, p_WorksheetID, p_APP_USER, p_Instance, p_ReportName, p_isLocator, p_isLocatorMulti, p_Exclude, p_isLocateMany);
             
             WHEN p_ObjType='EMM' THEN

                 SQLString := DesktopEvidenceManagementSQL(NewFilter, user_sid, NewActiveFilter, p_OtherSearchCriteria, v_max_num_rows, p_WorksheetID, p_APP_USER, p_Instance, p_ReportName);

             WHEN p_ObjType='FULLTEXTSEARCH' THEN

                 SQLString := DesktopFullTextSearchSQL(NewFilter, p_OtherSearchCriteria, NewActiveFilter);
              
             WHEN p_ObjType='CFUNDS_ADV' THEN
        
                 SQLString := DesktopCFundAdvancesSQL(NewFilter, user_sid, NewActiveFilter, p_OtherSearchCriteria, v_max_num_rows, p_WorksheetID, p_APP_USER, p_Instance, p_ReportName);
                 
             WHEN p_ObjType='CFUNDS_EXP' THEN
        
                 SQLString := DesktopCFundExpensesSQL(NewFilter, user_sid, NewActiveFilter, p_OtherSearchCriteria, v_max_num_rows, p_WorksheetID, p_APP_USER, p_Instance, p_ReportName);

             WHEN p_ObjType='NOTIFICATIONS' THEN

                 SQLString := DesktopNotificationsSQL(NewFilter, user_sid, NewActiveFilter, p_OtherSearchCriteria, v_max_num_rows, p_WorksheetID, p_APP_USER, p_Instance, p_ReportName);
             
             WHEN p_ObjType IN ('OFFENSE','OFFENSES','MATTERS INVESTIGATED','MATTERS') THEN
        
                 SQLString := DesktopOffensesSQL(NewFilter, user_sid, p_ReturnPageItemName, NewActiveFilter, p_ObjType, p_OtherSearchCriteria, v_max_num_rows, p_WorksheetID, p_APP_USER, p_Instance, p_ReportName, p_isLocator, p_isLocatorMulti, p_Exclude, p_isLocateMany);

             WHEN p_ObjType='PERSONNEL' THEN

                 SQLString := DesktopPersonnelSQL(NewFilter, user_sid, p_ReturnPageItemName, NewActiveFilter, p_ObjType, p_OtherSearchCriteria, v_max_num_rows, p_WorksheetID, p_APP_USER, p_Instance, p_ReportName, p_isLocator, p_isLocatorMulti, p_Exclude, 'PERSONNEL', p_isLocateMany);

             WHEN p_ObjType='PERSONNEL_EMAIL' THEN

                 SQLString := DesktopPersonnelSQL(NewFilter, user_sid, p_ReturnPageItemName, NewActiveFilter, p_ObjType, p_OtherSearchCriteria, v_max_num_rows, p_WorksheetID, p_APP_USER, p_Instance, p_ReportName, p_isLocator, p_isLocatorMulti, p_Exclude, 'EMAIL', p_isLocateMany);
             
             WHEN p_ObjType IN ('SOURCE','SOURCES') THEN
        
                 SQLString := DesktopSourcesSQL(NewFilter, user_sid, p_ReturnPageItemName, NewActiveFilter, p_ObjType, p_OtherSearchCriteria, v_max_num_rows, p_WorksheetID, p_APP_USER, p_Instance, p_ReportName, p_isLocator, p_isLocatorMulti, p_Exclude, p_isLocateMany);

             WHEN p_ObjType='MILITARY_LOCS' THEN
                              
                 SQLString := DesktopMilitaryLocationsSQL(NewFilter, user_sid, p_ReturnPageItemName, NewActiveFilter, p_ObjType, p_OtherSearchCriteria, v_max_num_rows, p_WorksheetID, p_APP_USER, p_Instance, p_ReportName, p_isLocator, p_isLocatorMulti, p_Exclude, p_isLocateMany);
             
             WHEN p_ObjType='CITY_STATE_COUNTRY' THEN

                 SQLString := DesktopCityStateCountrySQL(NewFilter, user_sid, p_ReturnPageItemName, NewActiveFilter, p_ObjType, p_OtherSearchCriteria, v_max_num_rows, p_WorksheetID, p_APP_USER, p_Instance, p_ReportName, p_isLocator, p_isLocatorMulti, p_Exclude, p_isLocateMany);

             WHEN p_ObjType='UNITS' THEN

                 SQLString := DesktopUnitSQL(NewFilter, user_sid, p_ReturnPageItemName, NewActiveFilter, p_ObjType, p_OtherSearchCriteria, v_max_num_rows, p_WorksheetID, p_APP_USER, p_Instance, p_ReportName, p_isLocator, p_isLocatorMulti, p_Exclude, 'UNITS', p_isLocateMany);

             WHEN p_ObjType='UNITS_RPO' THEN

                 NewFilter := 'ALL';
                 SQLString := DesktopUnitSQL(NewFilter, user_sid, p_ReturnPageItemName, NewActiveFilter, p_ObjType, p_OtherSearchCriteria, v_max_num_rows, p_WorksheetID, p_APP_USER, p_Instance, p_ReportName, p_isLocator, p_isLocatorMulti, p_Exclude, 'RPO', p_isLocateMany);

             WHEN p_ObjType='UNITS_EFUNDS' THEN

                 SQLString := DesktopUnitSQL(NewFilter, user_sid, p_ReturnPageItemName, NewActiveFilter, p_ObjType, p_OtherSearchCriteria, v_max_num_rows, p_WorksheetID, p_APP_USER, p_Instance, p_ReportName, p_isLocator, p_isLocatorMulti, p_Exclude, 'EFUNDS', p_isLocateMany);

             WHEN p_ObjType='WORKHOURS' THEN

                 SQLString := DesktopWorkHoursSQL(NewFilter, user_sid, NewActiveFilter, p_OtherSearchCriteria, v_max_num_rows, p_WorksheetID, p_APP_USER, p_Instance, p_ReportName);
                             
         END CASE;
         
         if PAGE_ID <> 'P' then

           v_temp := osi_personnel.set_user_setting(user_sid,PAGE_ID || '_FILTER.' || p_ObjType, NewFilter);
           v_temp := osi_personnel.set_user_setting(user_sid,PAGE_ID || '_ACTIVE_FILTER.' || p_ObjType, NewActiveFilter);
           v_temp := osi_personnel.set_user_setting(user_sid,PAGE_ID || '_NUM_ROWS.' || p_ObjType, NUM_ROWS);
           
         end if;

         log_error('<<<OSI_DESKTOP.DesktopSQL --Returned--> ' || SQLString);
         RETURN SQLString;
         
    END DesktopSQL;
    
END Osi_Desktop;
/


set define off;

CREATE OR REPLACE package body osi_util as
/******************************************************************************
   Name:     OSI_UTIL
   Purpose:  Provides utility functions.

   Revisions:
    Date        Author          Description
    ----------  --------------  ------------------------------------
    23-APR-2009 T.Whitehead    Created package.
    07-MAY-2009 T.McGuffin     Added Address utilities (GET_ADDR_FIELDS, GET_ADDR_DISPLAY,
                               UPDATE_ADDRESS, INSERT_ADDRESS)
    16-MAY-2009 T.Whitehead    Added PARSE_SIZE from OSI_ATTACHMENT.
    16-MAY-2009 T.McGuffin     Modified get_edit_link to use our &ICON_EDIT. image
    20-MAY-2009 T.McGuffin     Removed get_edit_link.
    21-May-2009 R.Dibble       Modified get_status_buttons to utilize 'ALL' status change types'
    22-May-2009 T.McGuffin     Modified insert_address to remove the obj_context.
    26-May-2009 R.Dibble       Modified get_status_buttons to handle object type 
                               specific status changes correctly and to use SEQ
    10-Jun-2009 R.Dibble       Added get_checklist_buttons
    25-Jun-2009 T.McGuffin     Added new update_single_address procedure which ties together insertion and
                               updating of an address, if either are applicable.
    29-Jul-2009 T.Whitehead    Moved get_mime_icon into this package.
    29-Oct-2009 R.Dibble       Modified get_status_buttons and get_checklist_buttons
                               to handle object type overrides
    30-Nov-2009 T.Whitehead    Added get_report_links.
    29-Dec-2009 T.Whitehead    Added do_title_substitution.
    04-Jan-2010 T.Whitehead    Added procedure aitc that calls core_util.append_info_to_clob.
    16-Feb-2010 T.McGuffin     Added display_precision_date function.
    25-Mar-2010 T.Whitehead    Copied blob_to_clob, blob_to_hex, clob_to_clob, decapxml, encapxml
                               and hex_to_blob from I2MS.
    1-Jun-2010  J.Horne        Updated get_report_links so that if statement compares disabled_status
                               to v_status_codes correctly.
    14-Jun-2010 J.Faris        Added show_tab function.
    12-Jul-2010 R.Dibble       Added encrypt_md5hex (copied from CORE_CONTEXT and made public)
    24-Aug-2010 J.Faris        Updated get_status_buttons, get_checklist_buttons to include status change 
                               overrides tied to a "sub-parent" (like ACT.CHECKLIST).
    15-Nov-2010 R.Dibble       Incorporated Todd Hughsons change to get_report_links() to handle
                                the new report link dropdown architecture                           
    16-Feb-2011 Tim Ward       CR#3697 - Fixed do_title_substitution to not lock up if there is
                                a ~ typed in the Title somewhere.                           
    02-Mar-2011 Tim Ward       CR#3705 - Added an else in the Case of get_report_links to support .txt mime type.
    02-Mar-2011 Tim Ward       CR#3705 - Added WordWrapFunc.
    04-Oct-2011 Tim Ward       CR#3919 - Add Report Printing for Activities from the File/Activity Associations sreen.
                                Added get_report_menu.
    20-Jun-2012 Tim Ward       Added new parameter to get_report_links, get_status_buttons, and get_checklist_buttons.
                                Allows OSI_MENU to get the lists in a more usable way to split them up.
    03-Aug-2012 Tim Ward       Added new parameter to get_report_links so it adds the Report SID id to the return values.
                                Allows OSI_MENU to get the Report SID (this defaults to N).
    13-Aug-2012 Tim Ward       CR#4051, 4055-Add New Report to Menu and Change ROI Format
                                Added a check to OSI_UTIL.get_report_links to open a page if the 
                                 PACKAGE_FUNCTION is just numeric and Autorun=Y.
    28-Nov-2012 Tim Ward       Changed get_report_menu to use jQuery Menu instead of the old dHTML one.

******************************************************************************/
    c_pipe   varchar2(100) := core_util.get_config('CORE.PIPE_PREFIX') || 'OSI_UTIL';

    procedure log_error(p_msg in varchar2) is
    begin
        core_logger.log_it(c_pipe, p_msg);
    end log_error;
    
    procedure aitc(p_clob in out nocopy clob, p_text varchar2) is
    begin
        core_util.append_info_to_clob(p_clob, p_text, '');
    end aitc;
    
    function blob_to_clob(p_blob in blob)
        return clob is
        --Used to convert a Blob to a Clob
        v_clob          clob;
        v_blob_length   integer;
        v_blob_chunk    raw(1024);
        v_blob_byte     raw(1);
        v_chunk_size    integer   := 1024;
    begin
        dbms_lob.createtemporary(v_clob, true, dbms_lob.session);
        v_blob_length := dbms_lob.getlength(p_blob);

        for i in 0 .. floor(v_blob_length / v_chunk_size) - 1
        loop
            v_blob_chunk := dbms_lob.substr(p_blob, v_chunk_size, i * v_chunk_size + 1);
            dbms_lob.append(v_clob, utl_raw.cast_to_varchar2(v_blob_chunk));
        end loop;

        for i in(floor(v_blob_length / v_chunk_size) * v_chunk_size + 1) .. v_blob_length
        loop
            v_blob_byte := dbms_lob.substr(p_blob, 1, i);
            dbms_lob.append(v_clob, utl_raw.cast_to_varchar2(v_blob_byte));
        end loop;

        return v_clob;
    end;
    
    function blob_to_hex(p_blob in blob)
        return clob is
        --Used to convert a Raw Blob into a Hex Clob
        v_clob          clob;
        v_blob_length   integer;
        v_blob_chunk    raw(1024);
        v_blob_byte     raw(1);
        v_chunk_size    integer   := 1024;
    begin
        dbms_lob.createtemporary(v_clob, true, dbms_lob.session);
        v_blob_length := dbms_lob.getlength(p_blob);

        for i in 0 .. floor(v_blob_length / v_chunk_size) - 1
        loop
            v_blob_chunk := dbms_lob.substr(p_blob, v_chunk_size, i * v_chunk_size + 1);
            dbms_lob.append(v_clob, rawtohex(v_blob_chunk));
        end loop;

        for i in(floor(v_blob_length / v_chunk_size) * v_chunk_size + 1) .. v_blob_length
        loop
            v_blob_byte := dbms_lob.substr(p_blob, 1, i);
            dbms_lob.append(v_clob, rawtohex(v_blob_byte));
        end loop;

        return v_clob;
    end;
    
    -- Used to convert a Clob to a Blob. Richard D.
    function clob_to_blob(p_clob in clob)
        return blob
    is
        v_pos       pls_integer    := 1;
        v_buffer    raw(32767);
        v_return    blob;
        v_lob_len   pls_integer    := dbms_lob.getlength(p_clob);
        --WAS pls_integer
        v_err       varchar2(4000);
    begin
        dbms_lob.createtemporary(v_return, true);
        dbms_lob.open(v_return, dbms_lob.lob_readwrite);

        loop
            v_buffer := utl_raw.cast_to_raw(dbms_lob.substr(p_clob, 16000, v_pos));

            if utl_raw.length(v_buffer) > 0 then
                dbms_lob.writeappend(v_return, utl_raw.length(v_buffer), v_buffer);
            end if;

            v_pos := v_pos + 16000;
            exit when v_pos > v_lob_len;
        end loop;

        return v_return;
    exception
        when others then
            v_err := sqlerrm;
            return v_return;
    end clob_to_blob;
    
    function decapxml(p_blob in blob, p_tag in varchar2)
        return blob is
        v_output            blob           := null;
        v_work              blob           := null;
        v_err               varchar2(4000);
        v_length_to_parse   integer;
        v_offset            integer;
        v_pattern           raw(2000);
        --V_RAW               raw (32767);
        v_blob_length       integer;
        v_blob_chunk        raw(1024);
        v_blob_byte         raw(1);
        v_chunk_size        integer        := 1024;
    begin
        --Get LENGTH we need to keep
        v_pattern := utl_raw.cast_to_raw('</' || p_tag || '>');
        v_length_to_parse := dbms_lob.instr(p_blob, v_pattern) -(2 * 1) -(2 * length(p_tag));
        --Get OFFSET point that we need to keep
        v_pattern := utl_raw.cast_to_raw('<' || p_tag || '>');
        v_offset := dbms_lob.instr(p_blob, v_pattern) + length(p_tag) + 3;
        --Capture input
        v_work := p_blob;
        v_blob_length := v_length_to_parse;

        --Create a temporary clob
        if v_output is null then
            dbms_lob.createtemporary(v_output, true);
        end if;

        --Grab the contents in large chunks (currently 1024bytes) and convert it
        --Floor is similiar to RoundDown(x)
        for i in 0 .. floor((v_blob_length) / v_chunk_size) - 1
        loop
            --Get 1K of the lob (After the offset)
            v_blob_chunk := dbms_lob.substr(p_blob, v_chunk_size, v_offset +(i * v_chunk_size) + 1);
            dbms_lob.append(v_output, v_blob_chunk);
        end loop;

        --Anything left after the chunks (the remainder 1023Bytes or <'er)
        --Handle in 1 byte chunks.. Not doing hex/raw conversion here so that is fine
        for i in(floor(v_blob_length / v_chunk_size) * v_chunk_size + 1) .. v_blob_length
        loop
            v_blob_byte := dbms_lob.substr(p_blob, 1, i);
            dbms_lob.append(v_output, v_blob_byte);
        end loop;

        return v_output;
    exception
        when others then
            v_err := sqlerrm;
            return v_output;
    end decapxml;
    
    function encapxml(p_blob in blob)
        return blob is
        v_cr       varchar2(10) := chr(13) || chr(10);
        v_return   clob;
    begin
        --Convert to Clob
        --V_WORK := blob_to_clob(P_BLOB);

        --Opening Tag(s)
        core_util.append_info_to_clob(v_return, '<XML>' || v_cr || '  <ATTACHMENT>' || v_cr);
        --V_RETURN := '<XML>' || V_CR || '  <ATTACHMENT>' || V_CR;

        --Rest of Blob
        v_return := v_return || blob_to_hex(p_blob);
        --Closing Tag(s)
        core_util.append_info_to_clob(v_return, v_cr || '  </ATTACHMENT>' || v_cr || '</XML>' || v_cr, '');
        --V_RETURN := V_RETURN || '<XML>' || V_CR || '  <ATTACHMENT>' || V_CR;
        return clob_to_blob(v_return);
    end encapxml;
    
    function hex_to_blob(p_blob in blob)
        return blob is
    --Used to convert a hex blob into a raw blob
    begin
        return hex_to_blob(blob_to_clob(p_blob));
    end;

    function hex_to_blob(p_clob in clob)
        return blob is
        --Used to convert a Hex Clob into a Raw Blob
        v_blob                         blob;
        v_clob_length                  integer;
        v_clob_chunk                   varchar2(1024);
        v_clob_hex_byte                varchar2(2);
        v_chunk_size                   integer        := 1024;
        v_remaining_characters_start   integer;
    begin
        dbms_lob.createtemporary(v_blob, true, dbms_lob.session);
        v_clob_length := dbms_lob.getlength(p_clob);

        for i in 0 .. floor(v_clob_length / v_chunk_size) - 1
        loop
            v_clob_chunk := dbms_lob.substr(p_clob, v_chunk_size, i * v_chunk_size + 1);
            dbms_lob.append(v_blob, hextoraw(v_clob_chunk));
            dbms_output.put_line('HEX_TO_BLOB - CHUNKS: ' || v_clob_chunk);
        end loop;

        v_remaining_characters_start :=(floor(v_clob_length / v_chunk_size) * v_chunk_size + 1);

        while v_remaining_characters_start < v_clob_length
        loop
            v_clob_hex_byte := dbms_lob.substr(p_clob, 2, v_remaining_characters_start);
            dbms_output.put_line('HEX_TO_BLOB - BYTES: ' || v_clob_hex_byte);
            dbms_lob.append(v_blob, hextoraw(v_clob_hex_byte));
            v_remaining_characters_start := v_remaining_characters_start + 2;
        end loop;

        return v_blob;
    end;
    
    function do_title_substitution(p_obj in varchar2, p_title in varchar2, p_tv_name in varchar2 := null)
        return varchar2 is
        v_caret     integer        := 0;
        v_title     varchar2(4000);
        v_rtn       varchar2(4000);
        v_value     varchar2(1000);
        v_item_og   varchar2(128);
        v_format    varchar2(30);
        v_item      varchar2(4000);
    begin
        v_title := p_title;
        v_rtn := v_title;

        for i in (SELECT column_value FROM TABLE(SPLIT(v_title,'~')) where column_value is not null)
        loop
            v_item := i.column_value;
            
            v_caret := instr(v_item, '^');
            if (v_caret > 0) then

              -- Save the item before separating the date format from the column name. --
              v_item_og := i.column_value;
              v_format := substr(v_item, v_caret + 1, length(v_item) - v_caret);
              v_item := substr(v_item, 1, v_caret - 1);
                  
            end if;

            -- See if the item is activity data. --
            begin
                 execute immediate 'select ' || v_item || ' from v_osi_title_activity '
                                  || ' where sid = ''' || p_obj || ''''
                             into v_value;
            exception
                when others then
                    begin
                        -- See if the item is participant data.
                        execute immediate 'select name from v_osi_title_partic '
                                          || ' where sid = ''' || p_obj || ''''
                                          || ' and upper(code) = upper(''' || v_item || ''')'
                                          || ' and rownum = 1'
                                     into v_value;
                    exception
                        when others then
                            -- If the item was neither see if a table or view name was
                            -- given and check it.
                            if (p_tv_name is not null) then
                               begin
                                    execute immediate 'select ' || v_item || ' from ' || p_tv_name
                                                  || ' where sid = ''' || p_obj || ''''
                                             into v_value;
                                exception
                                    when others then
                                        null; -- No replace will be made.
                                end;
                            end if;
                    end;
            end;

            -- If there was a date format, apply it now.
            if (v_caret > 0) then
 
              v_value := to_char(to_date(v_value, v_format), v_format);
              -- Get the original item for the replacement step.
              v_item := v_item_og;

            end if;
                
            -- Do the actual replacement.
            if (v_value is not null) then

              v_rtn := replace(v_rtn, '~' || v_item || '~', v_value);
              v_value := null;

            end if;

        end loop;

        return v_rtn;

    exception
        when others then
            log_error('do_title_substitution: ' || sqlerrm);
            raise;
    end do_title_substitution;

    function get_mime_icon(p_mime_type in varchar2, p_file_name in varchar2)
        return varchar2 is
        v_temp   varchar2(100) := null;
        v_mime   varchar2(500) := p_mime_type;
        v_file   varchar2(500) := p_file_name;
    begin
        begin
            if v_file is not null then
                while v_file <> regexp_substr(v_file, '[[:alnum:]]*')
                loop
                    v_file := regexp_substr(v_file, '[.].*');
                    v_file := regexp_substr(v_file, '[[:alnum:]].*');
                end loop;

                v_file := '.' || v_file;

                select image
                  into v_temp
                  from t_core_mime_image
                 where upper(mime_or_file_extension) = upper(v_file) and rownum = 1;
            end if;
        exception
            when no_data_found then
                if v_temp is null and v_mime is null then
                    select image
                      into v_temp
                      from t_core_mime_image
                     where upper(mime_or_file_extension) = upper('exe') and rownum = 1;
                end if;
        end;

        begin
            if v_mime is not null then
                select image
                  into v_temp
                  from t_core_mime_image
                 where upper(mime_or_file_extension) = upper(v_mime) and rownum = 1;
            end if;
        exception
            when no_data_found then
                -- Can't find an icon for this type so give it the default.
                --if v_temp is null and v_file is null then
                select image
                  into v_temp
                  from t_core_mime_image
                 where upper(mime_or_file_extension) = upper('exe') and rownum = 1;
        --end if;
        end;

        return v_temp;
    end get_mime_icon;
    
    function get_report_links(p_obj in varchar2, p_delim in varchar2 := '~', pIncludeSID in varchar2 := 'N')
        return varchar2 is
        v_rtn           varchar2(5000);
        v_auto_run      varchar2(1);
        v_status_code   t_osi_status.code%type;
    begin
        v_status_code := osi_object.get_status_code(p_obj);

        for a in (select   rt.description, rt.sid, rt.disabled_status, mt.file_extension, rt.package_function
                      from t_osi_report_type rt, t_osi_report_mime_type mt
                     where (rt.obj_type member of osi_object.get_objtypes(p_obj)
                            or rt.obj_type = core_obj.lookup_objtype('ALL'))
                           and rt.active = 'Y'
                           and rt.mime_type = mt.sid(+)
                  order by rt.seq asc)
        loop
            begin
                select 'N'
                  into v_auto_run
                  from t_osi_report_type
                 where sid = a.sid
                   and active = 'Y'
                   and (   pick_dates = 'Y'
                        or pick_narratives = 'Y'
                        or pick_notes = 'Y'
                        or pick_caveats = 'Y'
                        or pick_dists = 'Y'
                        or pick_classification = 'Y'
                        or pick_attachment = 'Y'
                        or pick_purpose = 'Y'
                        or pick_distribution = 'Y'
                        or pick_igcode = 'Y'
                        or pick_status = 'Y');
            exception
                when no_data_found then
                    v_auto_run := 'Y';
            end;

            v_rtn := v_rtn || p_delim || a.description || '~';

             if (a.disabled_status is not null and a.disabled_status like '%' || v_status_code || '%') then
                v_rtn := v_rtn || 'javascript:alert(''Report unavailable in the current status.'');';
            else
                if(v_auto_run = 'Y')then
                  if isnumeric(a.package_function) then

                    v_rtn := v_rtn || 'javascript:window.open(''' || 'f?p=' || v( 'APP_ID') || ':840:' || v( 'SESSION') || '::' || v( 'DEBUG') || '::P840_OBJ,P0_OBJ:' || p_obj || ',' || p_obj || ''');';
                  else

                    case lower(a.file_extension)
                        when '.rtf' then
                            -- This link will run a report that an application will load outside of the browser.
                            v_rtn := v_rtn || 'javascript:window.open(''' || 'f?p=' || v( 'APP_ID') || ':800:' || v( 'SESSION') || '::'
                                     || v( 'DEBUG') || '::P800_REPORT_TYPE,P0_OBJ:' || a.sid || ',' || p_obj || ''');';
                        when '.html' then
                            -- This javascript creates a new browser window for page 805 to show a report in.
                            v_rtn := v_rtn || 'javascript:launchReportHtml(''' || p_obj || ''');';

                        else
                            -- This link will run a report that an application will load outside of the browser.
                            v_rtn := v_rtn || 'javascript:window.open(''' || 'f?p=' || v( 'APP_ID') || ':800:' || v( 'SESSION') || '::'
                                     || v( 'DEBUG') || '::P800_REPORT_TYPE,P0_OBJ:' || a.sid || ',' || p_obj || ''');';
                    end case;

                  end if;
                      
                else
                    -- This javascript launches a page with an interface to modify the report before creating it.
                    v_rtn := v_rtn || 'javascript:launchReportSpec(''' || a.sid || ''',''' || p_obj || ''');';
                end if;
            end if;
            
            if (pIncludeSID='Y') then

              v_rtn := v_rtn || '~' || a.sid;

            end if;
            
        end loop;

        return v_rtn || '~';
    end get_report_links;

    /*************************************************************************************************************/
    /*  get_report_menu - Build the Reports Dropdown menu just as it appears on every apex page.                 */
    /*************************************************************************************************************/
    function get_report_menu(p_obj in varchar2, p_justTemplate in varchar2 := 'Y') return varchar2 is
        v_links         varchar2(5000);
        v_rtn           varchar2(5000);
        v_cnt           number := 1;
        v_description   varchar2(5000);
        v_msg           varchar2(5000);
    begin
         /*************************************************************************************************************/
         /*  p_JustTemplate - Using 'Y' from Apex Page 10150 for Speed of retrieval.  Then when the user presses      */
         /*                    the down arrow to show reports, we call this with 'N' to get just the list of Reports. */
         /*************************************************************************************************************/
         v_rtn := '';
         if p_justTemplate = 'N' then
           
           if osi_auth.check_access(p_obj)='N' then
  
             v_msg:=osi_auth.check_access(p_obj=>p_obj, p_get_message=>true);
             return '<li>' || v_msg || '</li>';

           end if;

           v_links := get_report_links(p_obj);
           
           for a in (select * from table(split(v_links,'~')) where column_value is not null)
           loop
               if mod(v_cnt, 2) = 0 then

                 v_rtn := v_rtn ||  '<li><a id="report' || trim(to_char(v_cnt/2)) || '" class="reportPopupMenu" href="javascript:void(0)" onClick="' || a.column_value || ' return false;">' || v_description || '</a></li>';
               
               else
               
                 v_description := a.column_value;
                
               end if;
               v_cnt := v_cnt + 1;
             
           end loop;
           return v_rtn;
         
         else

           v_rtn := '<a><img src="/i/themes/OSI/report16.gif" alt="Reports" title="Expand Reports Menu" onclick="GetAndOpenMenu(event, this,' || '''' || 'L' || p_obj || '''' || ',false)" style="cursor: pointer;"/><img src="/i/themes/OSI/menu-open-down.png" alt="Reports" title="Expand Reports Menu" onclick="GetAndOpenMenu(event, this,' || '''' || 'L' || p_obj || '''' || ',false)" style="cursor: pointer;"/></a>';
           
         end if;
         

         return v_rtn;
         
    end get_report_menu;
    
--    This function is used to return a squigly deliminted list (~) of statuses that an
--    object may currently go to
    function get_status_buttons(p_obj in varchar2, p_delim in varchar2 := '~')
        return varchar2 is
        v_rtn           varchar2(1000);
        v_obj_type      varchar2(20);
        v_obj_subtype   varchar2(20);
   
    begin
        --Get the object type
        v_obj_type := core_obj.get_objtype(p_obj);

        --Get distinct list of next possiible TO statuses
        ----Then check to see if there are any checklists tied to them

        --Get the button sids, etc.
        for i in (select osc.button_label, osc.sid, osc.from_status, osc.to_status
                    from v_osi_status_change osc
                   where (   from_status = osi_object.get_status_sid(p_obj)
                          or from_status_code = 'ALL')
                     and (   obj_type member of osi_object.get_objtypes(core_obj.get_objtype(p_obj))
          or obj_type = core_obj.lookup_objtype('ALL')
                     )and button_label is not null
                     and osc.active = 'Y'
                     
                     and osc.code not in(
                
                     select code
                          from v_osi_status_change osc2 
                         where ((obj_type = core_obj.get_objtype(p_obj) and override = 'Y')
                               /* updated 8.24.10 to include status change overrides tied to a "sub-parent" (like ACT.CHECKLIST) */ 
                                or
                               (obj_type member of osi_object.get_objtypes(core_obj.get_objtype(p_obj))
                           and override = 'Y'))  and
                        
                           osc.sid <> osc2.sid
                           )
                           
                     order by SEQ desc)
        loop

            v_rtn := v_rtn || p_delim || i.button_label || '~' || i.sid;

        end loop;

        return v_rtn || p_delim;
    end get_status_buttons;
    
--    This function is used to return a squigly deliminted list (~) of checklists that an
--    object may utilize
    function get_checklist_buttons(p_obj in varchar2, p_delim in varchar2 := '~')
              return varchar2 is
        v_rtn           varchar2(1000);
        v_obj_type      varchar2(20);
        v_obj_subtype   varchar2(20);
             v_cnt   number;
    begin
        --Get the object type
        v_obj_type := core_obj.get_objtype(p_obj);

        --Get the button sids, etc.
        for i in (select osc.checklist_button_label, osc.sid
                    from v_osi_status_change osc
                   where (   from_status = osi_object.get_status_sid(p_obj)
                         or from_status_code = 'ALL')
                     and (   obj_type member of osi_object.get_objtypes(core_obj.get_objtype(p_obj))
          or obj_type = core_obj.lookup_objtype('ALL'))
           and osc.active = 'Y'
          and osc.code not in(
                
                     select code
                          from v_osi_status_change osc2 
                         where ((obj_type = core_obj.get_objtype(p_obj) and override = 'Y')
                               /* updated 8.24.10 to include status change overrides tied to a "sub-parent" (like ACT.CHECKLIST) */ 
                                or
                               (obj_type member of osi_object.get_objtypes(core_obj.get_objtype(p_obj))
                           and override = 'Y'))  and
                        
                           osc.sid <> osc2.sid
                           )
                           
                     order by SEQ desc)
        loop
            select count(sid) 
            into v_cnt 
            from t_osi_checklist_item_type_map 
            where status_change_sid = i.sid;
        
        if (v_cnt >0) then
            v_rtn := v_rtn || p_delim || i.checklist_button_label || '~' || i.sid;
        end if;
            v_cnt := 0;
        end loop;

        return v_rtn || '~';
    end get_checklist_buttons;

    function parse_size(p_size in number)
        return varchar2 is
        v_size   number;
        v_rtn    varchar2(100) := null;
    begin
        if (p_size is null) then
            v_size := 0;
        else
            v_size := p_size;
        end if;

        if v_size >= 1024 then
            v_size := v_size / 1024;
        else
            v_rtn := v_size || ' Bytes';
        end if;

        if v_size >= 1024 then
            v_size := v_size / 1024;
        elsif v_rtn is null then
            v_rtn := v_size;
            v_rtn := substr(v_rtn, 0, instr(v_rtn, '.') + 2);
            v_rtn := v_rtn || ' KB';
        end if;

        if v_size >= 1000 then
            v_size := v_size / 1000;
        elsif v_rtn is null then
            v_rtn := v_size;
            v_rtn := substr(v_rtn, 0, instr(v_rtn, '.') + 2);
            v_rtn := v_rtn || ' MB';
        end if;

        if v_rtn is null then
            v_rtn := v_size;
            v_rtn := substr(v_rtn, 0, instr(v_rtn, '.') + 2);
            v_rtn := v_rtn || ' GB';
        end if;

        return v_rtn;
    end parse_size;

    function display_precision_date(p_date date)
        return varchar2 is
    begin
        case to_char(p_date, 'ss')
            when '00' then
                return to_char(p_date, core_util.get_config('CORE.DATE_FMT_DAY'));
            when '01' then
                return to_char(p_date, core_util.get_config('CORE.DATE_FMT_MONTH'));
            when '02' then
                return to_char(p_date, core_util.get_config('CORE.DATE_FMT_YEAR'));
            when '03' then
                return to_char(p_date,
                               core_util.get_config('CORE.DATE_FMT_DAY') || ' '
                               || core_util.get_config('OSI.DATE_FMT_TIME'));
            else
                return p_date;
        end case;
    exception
        when others then
            log_error('display_precision_date: ' || sqlerrm);
    end display_precision_date;

    /* This function executes any object or object type specific code to show/hide individual tabs */
    function show_tab(p_obj_type_code in varchar2, p_tab in varchar2, p_obj in varchar2 := null, p_context in varchar2 := null)
                return varchar2 is
    v_result varchar2(1);

    begin
         if p_obj_type_code = 'ALL.REPORT_SPEC' then 
            --p_obj is null and p_context is a report_type sid
            v_result := osi_report_spec.show_tab(p_context, p_tab);
            return v_result;
         else
            return 'Y';
         end if;
    exception
         when others then
                log_error('show_tab: ' || sqlerrm);
    end;
    
    /* Used to compare passwords for PASSWORD CHANGE SCREEN ONLY!!! */
    function encrypt_md5hex(p_clear_text in varchar2)
        return varchar2 is
        v_b64   varchar2(16);
        v_b16   varchar2(32);
        i       integer;
        c       integer;
        h       integer;
    begin
        v_b64 := dbms_obfuscation_toolkit.md5(input_string => p_clear_text);

        -- convert result to HEX:
        for i in 1 .. 16
        loop
            c := ascii(substr(v_b64, i, 1));
            h := trunc(c / 16);

            if h >= 10 then
                v_b16 := v_b16 || chr(h + 55);
            else
                v_b16 := v_b16 || chr(h + 48);
            end if;

            h := mod(c, 16);

            if h >= 10 then
                v_b16 := v_b16 || chr(h + 55);
            else
                v_b16 := v_b16 || chr(h + 48);
            end if;
        end loop;

        return lower(v_b16);
    end;

    Function WordWrapFunc(pst$ in clob, pLength in Number, Delimiter in clob) return clob is
  
      Cr$           varchar2(2) := chr(13);
      CrLF$         varchar2(4) := chr(13) || chr(10);
      NextLine$     clob := '';
      Text$         clob := '';
      l             number;
      s             number;
      c             number;
      Comma         number;
      DoneOnce      boolean;
      LineLength    number;
      st$           clob;
      DoneNow       number := 0;
      
    begin
         --- This function converts raw text into "Delimiter" delimited lines. ---
         st$ := ltrim(rtrim(pst$));
         LineLength := pLength + 1;
 
         while DoneNow=0
         loop
             l := nvl(length(NextLine$),0);
             s := InStr(st$, ' ');
             c := InStr(st$, Cr$);
             Comma := InStr(st$, ',');

             If c > 0 Then

               If l + c <= LineLength Then

                 Text$ := Text$ || NextLine$ || substr(st$,1,c);--   Left$(st$, c);
                 NextLine$ := '';
                 st$ := substr(st$, c + 1);-- Mid$(st$, c + 1);
                 GoTo LoopHere;

               End If;

             End If;
        
             If s > 0  Then

               If l + s <= LineLength Then

                 DoneOnce := True;
                 NextLine$ := NextLine$ || substr(st$, 1, s);-- Left$(st$, s);
                 st$ := substr(st$, s + 1);--Mid$(st$, s + 1)
           
               ElsIf s > LineLength Then
           
                    Text$ := Text$ || Delimiter || substr(st$,1,LineLength);-- Left$(st$, LineLength)
                    st$ := substr(st$, LineLength + 1); --Mid$(st$, LineLength + 1)
           
               Else
           
                 Text$ := Text$ || NextLine$ || Delimiter;
                 NextLine$ := '';

               End If;

             ElsIf Comma > 0 Then

                  If l + Comma <= LineLength Then

                    DoneOnce := True;
                    NextLine$ := NextLine$ || substr(st$, 1, Comma);-- Left$(st$, Comma)
                    st$ := substr(st$, Comma + 1); -- Mid$(st$, Comma + 1)

                  ElsIf s > LineLength Then

                        Text$ := Text$ || Delimiter || substr(st$, 1, LineLength);-- Left$(st$, LineLength)
                        st$ := substr(st$, LineLength + 1);-- Mid$(st$, LineLength + 1)
                        
                  Else

                    Text$ := Text$ || NextLine$ || Delimiter;
                    NextLine$ := '';

                  End If;

             Else
 
               If l > 0 Then
            
                 If l + nvl(Length(st$),0) > LineLength Then
            
                   Text$ := Text$ || NextLine$ || Delimiter || st$ || Delimiter;
            
                 Else
            
                   Text$ := Text$ || NextLine$ || st$ || Delimiter;
            
                 End If;

               Else

                 Text$ := Text$ || st$ || Delimiter;

               End If;

               DoneNow:=1;

             End If;

<<LoopHere>>
            null;
        
        end Loop;

        return Text$;

    End WordWrapFunc;
    
end osi_util;
/


CREATE OR REPLACE TRIGGER WEBI2MS.OSI_STATHIST_B_I_AL
BEFORE INSERT
ON WEBI2MS.T_OSI_STATUS_HISTORY 
REFERENCING NEW AS NEW OLD AS OLD
FOR EACH ROW
DECLARE

is_act NUMBER := 0;
F40A varchar2(1) := 'N';
up_on date := sysdate;

BEGIN

select count(a.sid) into is_act from t_osi_activity a where a.sid = :new.obj;

IF is_act > 0 THEN

-- Keep Form 40 attached status  14 Dec 12 wcc
BEGIN
select max(alu.SIGNED_FORM_40_ATTACHED) into F40A from t_osi_activity_lookup alu  where  alu.sid = :new.obj;
EXCEPTION
when NO_DATA_FOUND then
F40A := 'N';
END;

insert into t_osi_activity_lookup
 (SID,URL,ID,Activity_Type,Title,Lead_Agent,Status,Controlling_Unit,Controlling_Unit_Sid,Created_On,VLT,Created_By,Is_Lead,Date_Completed,Suspense_Date,Updated_On,Leadership_Approved,Signed_Form_40_Attached)
 SELECT /*+INDEX(a PK_OSI_ACT) INDEX(o PK_CORE_OBJ) INDEX(ot PK_CORE_OBJTYP) */
         a.SID,
        'javascript:getObjURL('''
         || a.SID
         || ''');'
            AS url,
         a.ID AS ID,
         ot.description AS Activity_Type,
         a.title AS Title,
         Osi_Object.get_lead_agent_name (a.SID) AS Lead_Agent,
         (SELECT description
         FROM T_OSI_STATUS
         WHERE SID = :new.status)  AS Status,
         Osi_Unit.get_name (Osi_Object.get_assigned_unit (a.SID)) as Controlling_Unit,
         Osi_Object.get_assigned_unit (a.SID) as Controlling_Unit_Sid,
         TO_CHAR (o.create_on, 'dd-Mon-rrrr') AS Created_On,
         'javascript:newWindow({page:5550,clear_cache:''5550'',name:''VLT'
         || a.sid
         || ''',item_names:''P0_OBJ'',item_values:'
         || ''
         || ''''
         || a.sid
         || ''''
         || ''
         || ',request:''OPEN''})'  AS VLT,
         o.create_by AS Created_By,
         DECODE (a.assigned_unit, a.aux_unit, 'Yes', NULL) Is_Lead,
         TO_CHAR (a.complete_date, 'dd-Mon-rrrr') Date_Completed,
         TO_CHAR (a.suspense_date, 'dd-Mon-rrrr') Suspense_Date,
         up_on as updated_on,
         a.leadership_approved,
         F40A as Signed_Form_40_Attached
    FROM T_OSI_ACTIVITY a, T_CORE_OBJ_TYPE ot, T_CORE_OBJ o
   WHERE a.SID = o.SID AND o.obj_type = ot.SID
        AND a.SID = :new.obj; 

delete from t_osi_activity_lookup tal where tal.sid= :new.obj and tal.updated_on <> up_on;

END IF;

END;
/



