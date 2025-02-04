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

