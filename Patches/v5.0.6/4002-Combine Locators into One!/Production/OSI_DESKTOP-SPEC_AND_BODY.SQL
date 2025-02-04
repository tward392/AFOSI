-- "Set define off" turns off substitution variables. 
Set define off; 

CREATE OR REPLACE PACKAGE "OSI_DESKTOP" AS
/******************************************************************************
   Name:     osi_desktop
   Purpose:  Provides Functionality for OSI Desktop Views

   Revisions:
    Date        Author          Description
    ----------  --------------  ------------------------------------
    18-Oct-2010 Tim Ward        Created Package (WCGH0000264)
    23-Jun-2011 Tim Ward        CR#3868 - Added p_ReturnPageItemName to DesktopSQL 
                                 to support popup locators.
******************************************************************************/
  vCRLF VARCHAR2(4) := CHR(13) || CHR(10);
  
  FUNCTION DesktopSQL(FILTER IN VARCHAR2, user_sid IN VARCHAR2, p_ObjType IN VARCHAR2, p_ReturnPageItemName IN VARCHAR2:='') RETURN VARCHAR2;
   
END Osi_Desktop;
/


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
 
******************************************************************************/
    c_pipe   VARCHAR2(100) := Core_Util.get_config('CORE.PIPE_PREFIX') || 'OSI_DESKTOP';

    PROCEDURE log_error(p_msg IN VARCHAR2) IS
    BEGIN
        Core_Logger.log_it(c_pipe, p_msg);
    END log_error;

    -----------------------------------------------------------------------------------
    ---   RETURN ALL subordinate units TO THE specified unit. THE specified unit IS ---
    ---   included IN THE output (AS THE FIRST ENTRY). THE LIST IS comma separated. ---
    -----------------------------------------------------------------------------------
    FUNCTION Get_Subordinate_Units  (pUnit IN VARCHAR2) RETURN VARCHAR2 IS

      pSubUnits VARCHAR2(4000) := NULL;
  
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

      pSupportedUnits VARCHAR2(4000) := NULL;
  
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
    FUNCTION DesktopCFundExpensesSQL(FILTER IN VARCHAR2, user_sid IN VARCHAR2) RETURN VARCHAR2 IS

      SQLString VARCHAR2(4000);
      UnitSID VARCHAR2(20);
   
    BEGIN
         UnitSID := Osi_Personnel.get_current_unit(user_sid);
         
         --- Main Select ---
         SQLString := 'SELECT ''javascript:getObjURL(''''''|| e.SID ||'''''');'' AS url,' || vCRLF ||
                      '       to_char(e.incurred_date,''dd-Mon-rrrr'') AS "Date Incurred",' || vCRLF ||
                      '       e.claimant_name AS "Claimant",' || vCRLF ||
                      '       ''<div class="tooltip" tip="Activity: '' || to_clob(htf.escape_sc(osi_activity.get_id(e.parent)) || '' - '' || core_obj.get_tagline(e.parent)) || ''">'' || substr(''Activity: '' || osi_activity.get_id(e.parent) || '' - '' || core_obj.get_tagline(e.parent),1,25) || case when length(''Activity: '' || osi_activity.get_id(e.parent) || '' - '' || core_obj.get_tagline(e.parent)) > 25 then ''...'' end || ''</div>'' AS "Context",' || vCRLF ||
                      '       TO_CHAR(e.total_amount_us, ''FML999G999G999G990D00'') AS "Total Amount",' || vCRLF ||
--                      '       to_clob(''<div class="tooltip" tip="'' || to_clob(htf.escape_sc(substr(e.description,1,2000))) || to_clob(htf.escape_sc(substr(e.description,2001,2000))) || ''">'' || to_clob(substr(e.description,1,25)) || case when length(e.description) > 25 then ''...'' end || ''</div>'') AS "Description",' || vCRLF ||
                      '       ''<div class="tooltip" tip="'' || htf.escape_sc(substr(e.description,1,3000)) || ''">'' || substr(e.description,1,25) || case when length(e.description) > 25 then ''...'' end || ''</div>'' AS "Description",' || vCRLF ||
                      '       e.CATEGORY AS "Category",' || vCRLF ||
                      '       e.paragraph_number AS "Paragraph",' || vCRLF ||
                      '       e.modify_on AS "Last Modified",' || vCRLF ||
                      '       e.voucher_no AS "Voucher #",' || vCRLF ||
                      '       e.charge_to_unit_name AS "Charge to Unit",' || vCRLF ||
                      '       e.status AS "Status"';

         --- Fields only Needed for Recent/Recent Unit Filters  ---
         IF FILTER IN ('RECENT','RECENT_UNIT') THEN

           SQLString := SQLString || ',' || vCRLF ||
                        '       to_char(r1.last_accessed,''dd-Mon-rrrr'') as "Last Accessed",' || vCRLF ||
                        '       to_char(r1.times_accessed,''00000'') as "Times Accessed",' || vCRLF ||
                        '       to_char(r1.times_accessed / power((sysdate-r1.last_accessed+1),2),''000000.000000'') as Ranking';
    
         ELSE

           SQLString := SQLString || ',' || vCRLF ||
                        '       NULL as "Last Accessed",' || vCRLF ||
                        '       NULL as "Times Accessed",' || vCRLF ||
                        '       NULL as Ranking';
         
         END IF;

--         SQLString := SQLString || ',''test1'',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,';
--         SQLString := SQLString || '''test2''' || ',to_clob(''test3'') as clob001';--'to_clob(''<div class="tooltip" tip="'' || to_clob(htf.escape_sc(substr(e.description,1,2000))) || to_clob(htf.escape_sc(substr(e.description,2001,2000))) || ''">'' || to_clob(substr(e.description,1,25)) || case when length(e.description) > 25 then ''...'' end || ''</div>'')' || vCRLF;
       
         --- From Clause ---
         SQLString := SQLString || vCRLF ||
                      '  FROM v_cfunds_expense_v3 e,' || vCRLF ||
                      '        T_CORE_OBJ_TYPE ot,' || vCRLF ||
                      '        T_CORE_OBJ o';

         --- From portion  Needed for Recent/Recent Unit Filters  ---
         IF FILTER IN ('RECENT','RECENT_UNIT') THEN
          
           SQLString := SQLString || ',' || vCRLF ||
                        '       t_osi_personnel_recent_objects r1';
        
         END IF;              

         --- Where Clause  ---
         IF FILTER NOT IN ('NONE') THEN

           SQLString := SQLString || vCRLF ||
                        '  WHERE e.SID=o.SID' || vCRLF ||
                        '    AND ot.code=''CFUNDS_EXP''';
                        
         END IF;
                                         
         --- Add Pieces to the Where Clause depending on the Filter ---
         CASE 
             
                              WHEN FILTER='ME' THEN
                                                   SQLString := SQLString || vCRLF || 
                                                                '    AND e.claimant=''' || user_sid ||  '''';
             
                            WHEN FILTER='UNIT' THEN
                                                   SQLString := SQLString || vCRLF || 
                                                                '    AND e.charge_to_unit=''' || UnitSID ||  '''';

                        WHEN FILTER='SUB_UNIT' THEN
                                                   SQLString := SQLString || vCRLF || 
                                                                '    AND e.charge_to_unit in ' || Get_Subordinate_Units(UnitSID); 
            
                        WHEN FILTER='SUP_UNIT' THEN
                                                   SQLString := SQLString || vCRLF || 
                                                                '    AND e.charge_to_unit IN ' || Get_Supported_Units(UnitSID);
                                                     
                          WHEN FILTER='RECENT' THEN
                                                   SQLString := SQLString || vCRLF ||  
                                                                '    AND r1.obj=o.sid' || vCRLF ||
                                                                '    AND r1.personnel=''' || user_sid ||  '''' || vCRLF ||
                                                                '    ORDER BY RANKING DESC';

                     WHEN FILTER='RECENT_UNIT' THEN
                                                   SQLString := SQLString || vCRLF || 
                                                                '    AND r1.obj=o.sid' || vCRLF ||
                                                                '    AND r1.unit=''' || UnitSID ||  '''' || vCRLF ||
                                                                '    ORDER BY RANKING DESC';

             WHEN FILTER='ALL' OR FILTER='OSI' THEN            
                                                   NULL; 
                                                                
                            WHEN FILTER='NONE' THEN            
                                                   SQLString := SQLString || vCRLF || 
                                                                '  WHERE 1=2';
 
         END CASE;
         
         RETURN SQLString;
         
    END DesktopCFundExpensesSQL;
    
    /**************************/ 
    /*  Notifications Section */   
    /**************************/ 
    FUNCTION DesktopNotificationsSQL(FILTER IN VARCHAR2, user_sid IN VARCHAR2) RETURN VARCHAR2 IS

      SQLString VARCHAR2(4000);
      UnitSID VARCHAR2(20);
   
    BEGIN
         UnitSID := Osi_Personnel.get_current_unit(user_sid);
         
         --- Main Select ---
         SQLString := 'SELECT ''javascript:getObjURL(''''''|| e.parent ||'''''');'' AS url,' || vCRLF ||
                      '       et.description AS "Event",' || vCRLF ||
                      '       to_char(n.generation_date,''dd-Mon-rrrr'') AS "Event Date",' || vCRLF ||
                      '       Core_Obj.get_tagline(e.PARENT) AS "Context",' || vCRLF ||
                      '       p.PERSONNEL_NAME AS "Recipient",' || vCRLF ||
                      '       e.specifics AS "Specifics",' || vCRLF ||
                      '       Osi_Unit.GET_NAME(e.impacted_unit) AS "Unit"';

         --- Fields only Needed for Recent/Recent Unit Filters  ---
         IF FILTER IN ('RECENT','RECENT_UNIT') THEN

           SQLString := SQLString || ',' || vCRLF ||
                        '       to_char(r1.last_accessed,''dd-Mon-rrrr'') as "Last Accessed",' || vCRLF ||
                        '       to_char(r1.times_accessed,''00000'') as "Times Accessed",' || vCRLF ||
                        '       to_char(r1.times_accessed / power((sysdate-r1.last_accessed+1),2),''000000.000000'') as Ranking';
    
         ELSE

           SQLString := SQLString || ',' || vCRLF ||
                        '       NULL as "Last Accessed",' || vCRLF ||
                        '       NULL as "Times Accessed",' || vCRLF ||
                        '       NULL as Ranking';
         
         END IF;
       
         --- From Clause ---
         SQLString := SQLString || vCRLF ||
                      '  FROM T_OSI_NOTIFICATION n,' || vCRLF ||
                      '       T_OSI_NOTIFICATION_EVENT e,' || vCRLF ||
                      '       T_OSI_NOTIFICATION_EVENT_TYPE et,' || vCRLF ||
                      '       T_CORE_OBJ_TYPE ot,' || vCRLF ||
                      '       T_CORE_OBJ o,' || vCRLF ||
                      '       V_OSI_PERSONNEL p';
        
         --- From portion  Needed for Recent/Recent Unit Filters  ---
         IF FILTER IN ('RECENT','RECENT_UNIT') THEN
          
           SQLString := SQLString || ',' || vCRLF ||
                        '       t_osi_personnel_recent_objects r1';
        
         END IF;              
                      
         --- Where Clause  ---
         IF FILTER NOT IN ('NONE') THEN

           SQLString := SQLString || vCRLF ||
                        '  WHERE e.PARENT=o.SID' || vCRLF ||
                        '    AND ot.code=''NOTIFICATIONS''' || vCRLF ||
                        '    AND n.EVENT=e.SID' || vCRLF ||
                        '    AND et.SID=e.EVENT_CODE' || vCRLF ||
                        '    AND n.RECIPIENT=p.SID';
                        
         END IF;
                                         
         --- Add Pieces to the Where Clause depending on the Filter ---
         CASE 
             
                              WHEN FILTER='ME' THEN
                                                   SQLString := SQLString ||  vCRLF ||
                                                                '    AND RECIPIENT=''' || user_sid || '''';
             
                            WHEN FILTER='UNIT' THEN
                                                   SQLString := SQLString || vCRLF || 
                                                                '    AND e.impacted_unit=''' || UnitSID ||  '''';

                        WHEN FILTER='SUB_UNIT' THEN
                                                   SQLString := SQLString || vCRLF || 
                                                                '    AND e.impacted_unit in ' || Get_Subordinate_Units(UnitSID); 
            
                        WHEN FILTER='SUP_UNIT' THEN
                                                   SQLString := SQLString || vCRLF || 
                                                                '    AND e.impacted_unit IN ' || Get_Supported_Units(UnitSID);
                                                     
                          WHEN FILTER='RECENT' THEN
                                                   SQLString := SQLString || vCRLF || 
                                                                '    AND r1.obj=o.sid' || vCRLF ||
                                                                '    AND r1.personnel=''' || user_sid ||  '''' || vCRLF ||
                                                                '    ORDER BY RANKING DESC';

                     WHEN FILTER='RECENT_UNIT' THEN
                                                   SQLString := SQLString || vCRLF || 
                                                                '    AND r1.obj=o.sid' || vCRLF ||
                                                                '    AND r1.unit=''' || UnitSID ||  '''' || vCRLF ||
                                                                '    ORDER BY RANKING DESC';

             WHEN FILTER='ALL' OR FILTER='OSI' THEN            
                                                   NULL;
                                                   
                            WHEN FILTER='NONE' THEN            
                                                   SQLString := SQLString || vCRLF || 
                                                                '  WHERE 1=2';
                                                                                                               
         END CASE;
         
         RETURN SQLString;
         
    END DesktopNotificationsSQL;

    /***********************/ 
    /*  Activities Section */   
    /***********************/ 
    FUNCTION DesktopActivitiesSQL(FILTER IN VARCHAR2, user_sid IN VARCHAR2) RETURN VARCHAR2 IS

      SQLString VARCHAR2(4000);
      UnitSID VARCHAR2(20);
   
    BEGIN
         UnitSID := Osi_Personnel.get_current_unit(user_sid);
         
         --- Main Select ---
         SQLString := 'SELECT ''javascript:getObjURL(''''''|| a.SID ||'''''');'' AS url,' || vCRLF ||
                      '       a.ID AS "ID",' || vCRLF ||
                      '       ot.description AS "Activity Type",' || vCRLF ||
                      '       a.title AS "Title",' || vCRLF ||
                      '       DECODE(Osi_Object.get_lead_agent(a.SID), NULL, ''NO LEAD AGENT'', Osi_Personnel.get_name(Osi_Object.get_lead_agent(a.SID))) AS "Lead Agent",' || vCRLF ||
                      '       Osi_Activity.get_status(a.SID) AS "Status",' || vCRLF ||
                      '       Osi_Unit.get_name(Osi_Object.get_assigned_unit(a.SID)) "Controlling Unit",' || vCRLF ||
                      '       to_char(o.create_on,''dd-Mon-rrrr'') AS "Created On",';

         --- Fields only Needed for Recent/Recent Unit Filters  ---
         IF FILTER IN ('RECENT','RECENT_UNIT') THEN

           SQLString := SQLString || vCRLF ||
                        '       to_char(r1.last_accessed,''dd-Mon-rrrr'') as "Last Accessed",' || vCRLF ||
                        '       to_char(r1.times_accessed,''00000'') as "Times Accessed",' || vCRLF ||
                        '       to_char(r1.times_accessed / power((sysdate-r1.last_accessed+1),2),''000000.000000'') as Ranking,';
         
         ELSE

           SQLString := SQLString || vCRLF ||
                        '       NULL as "Last Accessed",' || vCRLF ||
                        '       NULL as "Times Accessed",' || vCRLF ||
                        '       NULL as Ranking,';
         
         END IF;
         
         --- Add VLT Link ---
         SQLString := SQLString || vCRLF ||
                      '       Osi_Vlt.get_vlt_url(o.SID) AS "VLT",';

         --- Fields not Shown by Default ---
         SQLString := SQLString || vCRLF ||
                      '       o.create_by AS "Created By",' || vCRLF ||
                      '       DECODE(a.assigned_unit, a.aux_unit, ''Yes'', NULL) "Is a Lead",' || vCRLF ||
                      '       to_char(a.complete_date,''dd-Mon-rrrr'') "Date Completed",' || vCRLF ||
                      '       to_char(a.suspense_date,''dd-Mon-rrrr'') "Suspense Date"';
       
         --- From Clause ---
         SQLString := SQLString || vCRLF ||
                      '  FROM T_OSI_ACTIVITY a,' || vCRLF ||
                      '       T_CORE_OBJ_TYPE ot,' || vCRLF ||
                      '       T_CORE_OBJ o';

         --- From portion  Needed for Recent/Recent Unit Filters  ---
         IF FILTER IN ('RECENT','RECENT_UNIT') THEN
          
           SQLString := SQLString || ',' || vCRLF ||
                        '       t_osi_personnel_recent_objects r1';
        
         END IF;              

         --- Where Clause  ---
         IF FILTER NOT IN ('NONE') THEN

           SQLString := SQLString || vCRLF ||
                        '  WHERE a.SID=o.SID' || vCRLF ||
                        '    AND o.obj_type=ot.SID';
                        
         END IF;
                                         
         --- Add Pieces to the Where Clause depending on the Filter ---
         CASE 
             
                              WHEN FILTER='ME' THEN
                                                   SQLString := SQLString || vCRLF || 
                                                                '    AND o.sid in (select obj from t_osi_assignment where end_date is null and personnel=''' || user_sid || ''')';
             
                            WHEN FILTER='UNIT' THEN
                                                   SQLString := SQLString || vCRLF || 
                                                                '    AND a.assigned_unit=''' || UnitSID ||  '''';

                        WHEN FILTER='SUB_UNIT' THEN
                                                   SQLString := SQLString || vCRLF || 
                                                                '    AND a.assigned_unit in ' || Get_Subordinate_Units(UnitSID); 
                                                                            
                        WHEN FILTER='SUP_UNIT' THEN
                                                   SQLString := SQLString || vCRLF || 
                                                                '    AND a.assigned_unit IN ' || Get_Supported_Units(UnitSID);
                                                     
                          WHEN FILTER='RECENT' THEN
                                                   SQLString := SQLString || vCRLF ||  
                                                                '    AND r1.obj=o.sid' || vCRLF ||
                                                                '    AND r1.personnel=''' || user_sid ||  '''' || vCRLF ||
                                                                '    ORDER BY RANKING DESC';

                     WHEN FILTER='RECENT_UNIT' THEN
                                                   SQLString := SQLString || vCRLF || 
                                                                '    AND r1.obj=o.sid' || vCRLF ||
                                                                '    AND r1.unit=''' || UnitSID ||  '''' || vCRLF ||
                                                                '    ORDER BY RANKING DESC';

             WHEN FILTER='ALL' OR FILTER='OSI' THEN            
                                                   NULL; 
                                                                
                            WHEN FILTER='NONE' THEN            
                                                   SQLString := SQLString || vCRLF || 
                                                                '  WHERE 1=2';
 
         END CASE;
         
         RETURN SQLString;
         
    END DesktopActivitiesSQL;

    /**********************/ 
    /*  Personnel Section */   
    /**********************/ 
    FUNCTION DesktopPersonnelSQL(FILTER IN VARCHAR2, user_sid IN VARCHAR2) RETURN VARCHAR2 IS

      SQLString VARCHAR2(4000);
      UnitSID VARCHAR2(20);
   
    BEGIN
         UnitSID := Osi_Personnel.get_current_unit(user_sid);


/*select 'javascript:getObjURL(''' || o.sid || ''');' url,
       p.personnel_num as "Employee #",
       op.badge_num as "Badge Number",
       osi_personnel.get_name(p.sid) as "Name",
       osi_unit.get_name(osi_personnel.get_current_unit(o.sid)) as "Unit Name",
       op.start_date as "Start Date",
       op.ssn as "SSN",
       sex.code as "Sex"*/
/*  from        (select   o1.sid, 
                 o1.obj_type,
                 o1.create_by, 
                 o1.create_on, 
                 sum(r1.times_accessed) times_accessed,
                 max(r1.last_accessed) last_accessed
            from t_core_obj o1, t_osi_personnel_recent_objects r1, t_osi_personnel p2
           where r1.obj(+) = o1.sid
             and o1.sid = p2.sid
             and (   (    :p1340_filter = 'RECENT'
                      and r1.personnel = :user_sid)
                  or (    :p1340_filter = 'RECENT_UNIT'
                      and r1.unit = osi_personnel.get_current_unit(:user_sid))
                  or (    :p1340_filter = 'NONE' 
                          and 1 = 2)
                  or (:p1340_filter in ('ALL', 'OSI'))
                  or (    :p1340_filter = 'ME' 
                      and o1.sid=:user_sid)
                  or (    :p1340_filter = 'UNIT'
                      and osi_personnel.get_current_unit(o1.sid) =
                          osi_personnel.get_current_unit(:user_sid))
                  or (    :p1340_filter = 'SUB_UNIT'
                      and osi_unit.is_subordinate(
                          osi_personnel.get_current_unit(:user_sid),
                          osi_personnel.get_current_unit(o1.sid))='Y')
                  or (    :p1340_filter = 'SUP_UNIT'
                      and osi_personnel.get_current_unit(o1.sid) in
                         (select unit
                            from t_osi_unit_sup_units
                           where sup_unit = 
                                 osi_personnel.get_current_unit(:user_sid)
                          )))
        group by o1.sid, o1.obj_type, o1.create_by, o1.create_on) o,
       t_core_personnel p,
       t_osi_personnel op,
       t_osi_person_chars c,
       t_dibrs_reference sex
 where o.sid = p.sid
   and p.sid = op.sid
   and c.sid(+) = p.sid
   and sex.sid(+) = c.sex
*/         
         
         
         



         
         --- Main Select ---
         SQLString := 'SELECT ''javascript:getObjURL(''''''|| o.SID ||'''''');'' AS url,' || vCRLF ||
                      '       p.personnel_num as "Employee #",' || vCRLF ||
                      '       op.badge_num as "Badge Number",' || vCRLF ||
                      '       osi_personnel.get_name(p.sid) as "Name",' || vCRLF ||
                      '       osi_unit.get_name(osi_personnel.get_current_unit(o.sid)) as "Unit Name",' || vCRLF ||
                      '       op.start_date as "Start Date",' || vCRLF ||
                      '       op.ssn as "SSN",' || vCRLF ||
                      '       sex.code as "Sex",' || vCRLF ||
                      '       r.role_desc as "Role",';-- || vCRLF ||
--                      '       v.role_desc as "Role",' || vCRLF ||
                      
         --- Fields only Needed for Recent/Recent Unit Filters  ---
         IF FILTER IN ('RECENT','RECENT_UNIT') THEN

           SQLString := SQLString || vCRLF ||
                        '       to_char(r1.last_accessed,''dd-Mon-rrrr'') as "Last Accessed",' || vCRLF ||
                        '       to_char(r1.times_accessed,''00000'') as "Times Accessed",' || vCRLF ||
                        '       to_char(r1.times_accessed / power((sysdate-r1.last_accessed+1),2),''000000.000000'') as Ranking';--,';
         
         ELSE

           SQLString := SQLString || vCRLF ||
                        '       NULL as "Last Accessed",' || vCRLF ||
                        '       NULL as "Times Accessed",' || vCRLF ||
                        '       NULL as Ranking';--,';
         
         END IF;
         
         --- Add VLT Link ---
         --SQLString := SQLString || vCRLF ||
         --             '       Osi_Vlt.get_vlt_url(o.SID) AS "VLT",';

         --- Fields not Shown by Default ---
         --SQLString := SQLString || vCRLF ||
         --             '       o.create_by AS "Created By",' || vCRLF ||
         --             '       DECODE(a.assigned_unit, a.aux_unit, ''Yes'', NULL) "Is a Lead",' || vCRLF ||
         --             '       to_char(a.complete_date,''dd-Mon-rrrr'') "Date Completed",' || vCRLF ||
         --             '       to_char(a.suspense_date,''dd-Mon-rrrr'') "Suspense Date"';
       
         --- From Clause ---
         SQLString := SQLString || vCRLF ||
                      '  FROM t_core_personnel p,' || vCRLF ||
                      '       t_osi_personnel op,' || vCRLF ||
                      '       t_osi_person_chars c,' || vCRLF ||
                      '       t_dibrs_reference sex,' || vCRLF ||
                      '       T_CORE_OBJ_TYPE ot,' || vCRLF ||
                      '       T_CORE_OBJ o,' || vCRLF ||
                      '       V_OSI_UNIT_ASSIGNMENT r';

         --- From portion  Needed for Recent/Recent Unit Filters  ---
         IF FILTER IN ('RECENT','RECENT_UNIT') THEN
          
           SQLString := SQLString || ',' || vCRLF ||
                        '       t_osi_personnel_recent_objects r1';
        
         END IF;              

         --- Where Clause  ---
         IF FILTER NOT IN ('NONE') THEN

           SQLString := SQLString || vCRLF ||
                        '  WHERE p.SID=o.SID' || vCRLF ||
                        '    AND p.SID = op.SID' || vCRLF ||
                        '    AND c.SID(+)=p.SID' || vCRLF ||
                        '    AND sex.SID(+)=c.sex' || vCRLF ||
                        '    AND o.obj_type=ot.SID' || vCRLF ||
                        '    AND r.personnel=o.sid and r.end_date is null';-- || vCRLF ||
                        --'    AND EXISTS (SELECT x from V_OSI_UNIT_ASSIGNMENT where personnel=o.sid and end_date is null)';
                        
         END IF;
                                         
         --- Add Pieces to the Where Clause depending on the Filter ---
         CASE 
             
                              WHEN FILTER='ME' THEN
                                                   SQLString := SQLString || vCRLF || 
                                                                '    AND o.sid=''' || user_sid || '''';
             
                            WHEN FILTER='UNIT' THEN
                                                   SQLString := SQLString || vCRLF || 
                                                                '    AND osi_personnel.get_current_unit(o.sid)=''' || UnitSID ||  '''';

                        WHEN FILTER='SUB_UNIT' THEN
                                                   SQLString := SQLString || vCRLF || 
                                                                '    AND osi_personnel.get_current_unit(o.sid) in ' || Get_Subordinate_Units(UnitSID); 
                                                                            
                        WHEN FILTER='SUP_UNIT' THEN
                                                   SQLString := SQLString || vCRLF || 
                                                                '    AND osi_personnel.get_current_unit(o.sid) IN ' || Get_Supported_Units(UnitSID);
                                                     
                          WHEN FILTER='RECENT' THEN
                                                   SQLString := SQLString || vCRLF ||  
                                                                '    AND r1.obj=o.sid' || vCRLF ||
                                                                '    AND r1.personnel=''' || user_sid ||  '''' || vCRLF ||
                                                                '    ORDER BY RANKING DESC';

                     WHEN FILTER='RECENT_UNIT' THEN
                                                   SQLString := SQLString || vCRLF || 
                                                                '    AND r1.obj=o.sid' || vCRLF ||
                                                                '    AND r1.unit=''' || UnitSID ||  '''' || vCRLF ||
                                                                '    ORDER BY RANKING DESC';

             WHEN FILTER='ALL' OR FILTER='OSI' THEN            
                                                   NULL; 
                                                                
                            WHEN FILTER='NONE' THEN            
                                                   SQLString := SQLString || vCRLF || 
                                                                '  WHERE 1=2';
 
         END CASE;
         
         RETURN SQLString;
         
    END DesktopPersonnelSQL;

    /*******************************/ 
    /*  Military Locations Section */   
    /*******************************/ 
    FUNCTION DesktopMilitaryLocationsSQL(FILTER IN VARCHAR2, user_sid IN VARCHAR2, p_ReturnPageItemName IN VARCHAR2:='') RETURN VARCHAR2 IS

      SQLString VARCHAR2(4000);
      UnitSID VARCHAR2(20);
   
    BEGIN
         UnitSID := Osi_Personnel.get_current_unit(user_sid);
         
         --- Main Select ---
         SQLString := 'select apex_item.checkbox(1,' || vCRLF ||
                      '                          l.location_code,' || vCRLF ||
                      '                          ' || '''' || 'onchange="toggleCheckbox(this);"' || '''' || ',' || vCRLF ||
                      '                          ' || '''' || ':p0_loc_selections' || '''' || ',' || vCRLF ||
                      '                          ' || '''' || ':' || '''' || ') AS "Include",' || vCRLF ||
                      '                          ' || '''' || '<a href="javascript:passBack(''''' || '''' || ' || l.location_code ' || '|| ''''' || '''' || ',' || '''' || '''' || p_ReturnPageItemName || '''' || '''' || ');">Select</a>' || '''' || ' as "Select",' || vCRLF ||
                      '                          LOCATION_NAME as "Location Name",' || vCRLF ||
                      '                          LOCATION_LONG_NAME as "Location Long Name",' || vCRLF ||
                      '                          LOCATION_CITY as "City",' || vCRLF ||
                      '                          LOCATION_STATE_COUNTRY as "State/Country Name",';

         IF FILTER IN ('RECENT','RECENT_UNIT') THEN

           SQLString := SQLString || vCRLF ||
                        '                          to_char(r1.last_accessed,''dd-Mon-rrrr'') as "Last Accessed",' || vCRLF ||
                        '                          to_char(r1.times_accessed,''00000'') as "Times Accessed",' || vCRLF ||
                        '                          to_char(r1.times_accessed / power((sysdate-r1.last_accessed+1),2),''000000.000000'') as Ranking';
         
         ELSE

           SQLString := SQLString || vCRLF ||
                        '                          NULL as "Last Accessed",' || vCRLF ||
                        '                          NULL as "Times Accessed",' || vCRLF ||
                        '                          NULL as Ranking';
         
         END IF;
                      
         --- From Clause ---
         SQLString := SQLString || vCRLF || '      from t_sapro_locations l';

         --- From portion  Needed for Recent/Recent Unit Filters  ---
         IF FILTER IN ('RECENT','RECENT_UNIT') THEN
          
           SQLString := SQLString || ',' || vCRLF ||
                        '           t_osi_personnel_recent_objects r1';
        
         END IF;              

         --- Add Pieces to the Where Clause depending on the Filter ---
         CASE 
             
                            WHEN FILTER='ABC' THEN
                                                   SQLString := SQLString || vCRLF || 
                                                                ' where REGEXP_INSTR(LOCATION_NAME,''[a|b|c][[:alpha:]]'',1,1,0,''i'') = 1';
                            WHEN FILTER='DEF' THEN
                                                   SQLString := SQLString || vCRLF || 
                                                                ' where REGEXP_INSTR(LOCATION_NAME,''[d|e|f][[:alpha:]]'',1,1,0,''i'') = 1';
                            WHEN FILTER='GHI' THEN
                                                   SQLString := SQLString || vCRLF || 
                                                                ' where REGEXP_INSTR(LOCATION_NAME,''[g|h|i][[:alpha:]]'',1,1,0,''i'') = 1';
                            WHEN FILTER='JKL' THEN
                                                   SQLString := SQLString || vCRLF || 
                                                                ' where REGEXP_INSTR(LOCATION_NAME,''[j|k|l][[:alpha:]]'',1,1,0,''i'') = 1';
                            WHEN FILTER='MNO' THEN
                                                   SQLString := SQLString || vCRLF || 
                                                                ' where REGEXP_INSTR(LOCATION_NAME,''[m|n|o][[:alpha:]]'',1,1,0,''i'') = 1';
                           WHEN FILTER='PQRS' THEN
                                                   SQLString := SQLString || vCRLF || 
                                                                ' where REGEXP_INSTR(LOCATION_NAME,''[p|q|r|s][[:alpha:]]'',1,1,0,''i'') = 1';
                            WHEN FILTER='TUV' THEN
                                                   SQLString := SQLString || vCRLF || 
                                                                ' where REGEXP_INSTR(LOCATION_NAME,''[t|u|v][[:alpha:]]'',1,1,0,''i'') = 1';
                           WHEN FILTER='WXYZ' THEN
                                                   SQLString := SQLString || vCRLF || 
                                                                ' where REGEXP_INSTR(LOCATION_NAME,''[w|x|y|z][[:alpha:]]'',1,1,0,''i'') = 1';
                         WHEN FILTER='NUMERIC' THEN
                                                   SQLString := SQLString || vCRLF || 
                                                                ' where REGEXP_INSTR(LOCATION_NAME,''[0-9]'',1,1,0,''i'') = 1';

                           WHEN FILTER='ALPHA' THEN
                                                   SQLString := SQLString || vCRLF || 
                                                                ' where REGEXP_INSTR(LOCATION_NAME,''[a-z]'',1,1,0,''i'') = 1';

                          WHEN FILTER='RECENT' THEN             
                                                   SQLString := SQLString || vCRLF ||  
                                                                ' where r1.obj=location_code' || vCRLF ||
                                                                '   AND r1.personnel=''' || user_sid ||  '''' || vCRLF ||
                                                                ' ORDER BY RANKING DESC';

                     WHEN FILTER='RECENT_UNIT' THEN             
                                                   SQLString := SQLString || vCRLF || 
                                                                ' where r1.obj=location_code' || vCRLF ||
                                                                '   AND r1.unit=''' || UnitSID ||  '''' || vCRLF ||
                                                                ' ORDER BY RANKING DESC';
                                                    
             WHEN FILTER='ALL' OR FILTER='OSI' THEN            
                                                   NULL; 
                                                                
                            WHEN FILTER='NONE' THEN            
                                                   SQLString := SQLString || vCRLF || 
                                                                ' where 1=2';
 
         END CASE;

         RETURN SQLString;
         
    END DesktopMilitaryLocationsSQL;

    /********************************/ 
    /*  City, State/Country Section */   
    /********************************/ 
    FUNCTION DesktopCityStateCountrySQL(FILTER IN VARCHAR2, user_sid IN VARCHAR2, p_ReturnPageItemName IN VARCHAR2:='') RETURN VARCHAR2 IS

      SQLString VARCHAR2(4000);
      UnitSID VARCHAR2(20);
   
    BEGIN
         UnitSID := Osi_Personnel.get_current_unit(user_sid);
         
         --- Main Select ---
         SQLString := 'select apex_item.checkbox(1,' || vCRLF ||
                      '                          l.sid,' || vCRLF ||
                      '                          ' || '''' || 'onchange="toggleCheckbox(this);"' || '''' || ',' || vCRLF ||
                      '                          ' || '''' || ':p0_loc_selections' || '''' || ',' || vCRLF ||
                      '                          ' || '''' || ':' || '''' || ') AS "Include",' || vCRLF ||
                      '                          ' || '''' || '<a href="javascript:passBack(''''' || '''' || ' || l.sid ' || '|| ''''' || '''' || ',' || '''' || '''' || p_ReturnPageItemName || '''' || '''' || ');">Select</a>' || '''' || ' as "Select",' || vCRLF ||
                      '                          CITY as "City",' || vCRLF ||
                      '                          STATE as "State",' || vCRLF ||
                      '                          DECODE(COUNTRY,''UNITED STATES OF AMERICA'',''USA'',COUNTRY) as "Country",' || vCRLF ||
                      '                          STATE_COUNTRY_CODE as "State/Country Code",';

         IF FILTER IN ('RECENT','RECENT_UNIT') THEN

           SQLString := SQLString || vCRLF ||
                        '                          to_char(r1.last_accessed,''dd-Mon-rrrr'') as "Last Accessed",' || vCRLF ||
                        '                          to_char(r1.times_accessed,''00000'') as "Times Accessed",' || vCRLF ||
                        '                          to_char(r1.times_accessed / power((sysdate-r1.last_accessed+1),2),''000000.000000'') as Ranking';
         
         ELSE

           SQLString := SQLString || vCRLF ||
                        '                          NULL as "Last Accessed",' || vCRLF ||
                        '                          NULL as "Times Accessed",' || vCRLF ||
                        '                          NULL as Ranking';
         
         END IF;
                      
         --- From Clause ---
         SQLString := SQLString || vCRLF || '      from t_sapro_city_state_country l';

         --- From portion  Needed for Recent/Recent Unit Filters  ---
         IF FILTER IN ('RECENT','RECENT_UNIT') THEN
          
           SQLString := SQLString || ',' || vCRLF ||
                        '           t_osi_personnel_recent_objects r1';
        
         END IF;              

         --- Add Pieces to the Where Clause depending on the Filter ---
         CASE 
             
                            WHEN FILTER='ABC' THEN
                                                   SQLString := SQLString || vCRLF || 
                                                                ' where REGEXP_INSTR(CITY,''[a|b|c][[:alpha:]]'',1,1,0,''i'') = 1';
                            WHEN FILTER='DEF' THEN
                                                   SQLString := SQLString || vCRLF || 
                                                                ' where REGEXP_INSTR(CITY,''[d|e|f][[:alpha:]]'',1,1,0,''i'') = 1';
                            WHEN FILTER='GHI' THEN
                                                   SQLString := SQLString || vCRLF || 
                                                                ' where REGEXP_INSTR(CITY,''[g|h|i][[:alpha:]]'',1,1,0,''i'') = 1';
                            WHEN FILTER='JKL' THEN
                                                   SQLString := SQLString || vCRLF || 
                                                                ' where REGEXP_INSTR(CITY,''[j|k|l][[:alpha:]]'',1,1,0,''i'') = 1';
                            WHEN FILTER='MNO' THEN
                                                   SQLString := SQLString || vCRLF || 
                                                                ' where REGEXP_INSTR(CITY,''[m|n|o][[:alpha:]]'',1,1,0,''i'') = 1';
                           WHEN FILTER='PQRS' THEN
                                                   SQLString := SQLString || vCRLF || 
                                                                ' where REGEXP_INSTR(CITY,''[p|q|r|s][[:alpha:]]'',1,1,0,''i'') = 1';
                            WHEN FILTER='TUV' THEN
                                                   SQLString := SQLString || vCRLF || 
                                                                ' where REGEXP_INSTR(CITY,''[t|u|v][[:alpha:]]'',1,1,0,''i'') = 1';
                           WHEN FILTER='WXYZ' THEN
                                                   SQLString := SQLString || vCRLF || 
                                                                ' where REGEXP_INSTR(CITY,''[w|x|y|z][[:alpha:]]'',1,1,0,''i'') = 1';
                         WHEN FILTER='NUMERIC' THEN
                                                   SQLString := SQLString || vCRLF || 
                                                                ' where REGEXP_INSTR(CITY,''[0-9]'',1,1,0,''i'') = 1';

                           WHEN FILTER='ALPHA' THEN
                                                   SQLString := SQLString || vCRLF || 
                                                                ' where REGEXP_INSTR(CITY,''[a-z]'',1,1,0,''i'') = 1';

                          WHEN FILTER='RECENT' THEN             
                                                   SQLString := SQLString || vCRLF ||  
                                                                ' where r1.obj=l.sid' || vCRLF ||
                                                                '   AND r1.personnel=''' || user_sid ||  '''' || vCRLF ||
                                                                ' ORDER BY RANKING DESC';

                     WHEN FILTER='RECENT_UNIT' THEN             
                                                   SQLString := SQLString || vCRLF || 
                                                                ' where r1.obj=l.sid' || vCRLF ||
                                                                '   AND r1.unit=''' || UnitSID ||  '''' || vCRLF ||
                                                                ' ORDER BY RANKING DESC';
                                                    
             WHEN FILTER='ALL' OR FILTER='OSI' THEN            
                                                   NULL; 
                                                                
                            WHEN FILTER='NONE' THEN            
                                                   SQLString := SQLString || vCRLF || 
                                                                ' where 1=2';
 
         END CASE;

         RETURN SQLString;
         
    END DesktopCityStateCountrySQL;
    
   FUNCTION DesktopSQL(FILTER IN VARCHAR2, user_sid IN VARCHAR2, p_ObjType IN VARCHAR2, p_ReturnPageItemName IN VARCHAR2:='') RETURN VARCHAR2 IS

      SQLString VARCHAR2(4000);
      NewFilter VARCHAR2(4000);
      
    BEGIN
    
         Core_Logger.log_it(c_pipe, 'OSI_DESKTOP.DesktopSQL(' || FILTER || ',' || user_sid || ',' || p_ObjType || ')');

         NewFilter := FILTER;
         IF p_ObjType NOT IN ('MILITARY_LOCS','CITY_STATE_COUNTRY') THEN

           IF NewFilter NOT IN ('ME','UNIT','SUB_UNIT','SUP_UNIT','RECENT','RECENT_UNIT','ALL','OSI','NONE') OR NewFilter IS NULL THEN
           
             Core_Logger.log_it(c_pipe, 'Filter not Supported, Changed to: RECENT');
             NewFilter := 'RECENT';
           
           END IF;

         ELSE

           IF NewFilter NOT IN ('ABC','DEF','GHI','JKL','MNO','PQRS','TUV','WXYZ','NUMERIC','ALPHA','ALL','RECENT','RECENT_UNIT','OSI','NONE') OR NewFilter IS NULL THEN
           
             Core_Logger.log_it(c_pipe, 'Filter not Supported, Changed to: RECENT');
             NewFilter := 'RECENT';
           
           END IF;

         END IF;
          
         CASE p_ObjType
       
             WHEN 'ACT' THEN
        
                 SQLString := DesktopActivitiesSQL(NewFilter, user_sid);

             WHEN 'CFUNDS_EXP' THEN
        
                 SQLString := DesktopCFundExpensesSQL(NewFilter, user_sid);
             
             WHEN 'NOTIFICATIONS' THEN

                 SQLString := DesktopNotificationsSQL(NewFilter, user_sid);
             
             WHEN 'PERSONNEL' THEN

                 SQLString := DesktopPersonnelSQL(NewFilter, user_sid);
             
             WHEN 'MILITARY_LOCS' THEN
                              
                 SQLString := DesktopMilitaryLocationsSQL(NewFilter, user_sid, p_ReturnPageItemName);
             
             WHEN 'CITY_STATE_COUNTRY' THEN

                 SQLString := DesktopCityStateCountrySQL(NewFilter, user_sid, p_ReturnPageItemName);
                             
         END CASE;
 
         Core_Logger.log_it(c_pipe, 'OSI_DESKTOP.DesktopSQL --Returned--> ' || SQLString);
         
         RETURN SQLString;
         
    END DesktopSQL;

END Osi_Desktop;
/

