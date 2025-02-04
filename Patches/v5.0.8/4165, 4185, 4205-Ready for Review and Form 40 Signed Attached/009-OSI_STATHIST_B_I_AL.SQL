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



