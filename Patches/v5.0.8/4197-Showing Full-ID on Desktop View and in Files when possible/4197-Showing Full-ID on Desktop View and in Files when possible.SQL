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
    29-Nov-2012 Tim Ward        CR#4197 - Changed to get full_id, if null get id for Files.
                                  Changed in DesktopFilesSQL

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
---                      'f.id as "ID",' || 
                      'decode(f.full_id,null,f.id,f.full_id) as "ID",' || 
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

CREATE OR REPLACE PACKAGE BODY Osi_Object AS
/******************************************************************************
   Name:     Osi_Object
   Purpose:  Provides Functionality Common Across Multiple Object Types.

   Revisions:
    Date        Author          Description
    ----------  --------------  ------------------------------------
     17-Apr-2009 T.McGuffin      Created Package
     29-Apr-2009 T.McGuffin      Added Get_Next_Id Function.
     01-May-2009 Richard Dibble  Added Get_Status
     06-May-2009 T.McGuffin      Added Get_Objtype_Desc function.
     11-May-2009 T.Whitehead     Added Get_Address function.
     20-May-2009 R.Dibble        Modified Get_Status to utilize non-core tables
     21-May-2009 R. Dibble       Added Get_Obj_Package Procedure
     22-May-2009 T.McGuffin      Removed Get_Address.  Created Get_Address_Sid and Get_Participant_Sid
     27-May-2009 T.McGuffin      Added Create_Lead_Assignment procedure.
     01-Jun-2009 T.McGuffin      Added Get_Objtypes function.
     01-Jun-2009 T.McGuffin      Added Get_ID function.
     24-Aug-2009 T.McGuffin      Modified get_object_url to include optional parameters for item names and vals.
     13-Oct-2009 J.Faris         Added Delete_Object
     02-Nov-2009 T.Whitehead     Added get/set_special_interest.
     02-Nov-2009 Richard Dibble  Added get_objtype_code
     17-Dec-2009 T.Whitehead     Added get_default_title.
     18-Dec-2009 T.Whitehead     Added do_title_substitution.
     28-Dec-2009 T.Whitehead     Added get_status_code.
     12-Jan-2010 T.Whitehead     Added optional parameter p_text to get_open_link.
     13-Jan-2010 T.McGuffin      Added check_writability function.
     22-Feb-2010 T.McGuffin      Added is_assigned function.
     26-Feb-2010 T.McGuffin      Added get_lead_agent function.
     24-Mar-2010 T.McGuffin      Modified get_assigned_unit function to include cfunds advances.
     27-Apr-2010 J.Horne         Modified get/set_special_interest to include only special Interests
                                 that have been marked 'I.'
     10-May-2010 R.Dibble        Modified delete_object to always reject when the object type is UNIT
     25-May-2010 T.Leighty       Added addicon, append_assoc_activities, append_involved_participants,
                                 append_attachments, append_notes, append_related_files, get_template
                                 and doc_detail
     27-May-2010 T.Leighty       Modified append_involved_participants to use correct view table 
                                 combination in queries.
     08-Jun-2010 T.Leighty       Modified append_involved_participants to fix bug that prevented all
                                 file types to be included.
     15-Jul-2010 J.Faris         Implementing a previous update to error handling in is_assigned function.
     30-Nov-2010 J.Horne         Updated append_attachments; changed format for URL
     30-Nov-2010 Tim Ward        Changed get_next_id incase IDs are gotten in Rapid Succession.
     07-Dec-2010 Tim Ward        Added getStatusBar.
     09-Dec-2010 Richard Dibble  Modified get_object_url to forward user to a dummy page if they do not have access.
     13-Dec-2010 Richard Dibble  Modified get_object_url to supress logging
     18-Jan-2011 Tim Ward        Redid getStatusBar to not use the jixedBar.
     19-Jan-2011 Tim Ward        Added Last DEERS date to a PART.INDIV object's statusbar.
     19-Jan-2011 Tim Ward        Added core_util.get_config('OSI.IMAGE_PREFIX') to getStatusBar so we can get the correct
                                 #IMAGE_DIR# value for the Min/Max.gif buttons.
     16-Feb-2011 Tim Ward        Problem pulling correct DEERS_DATE.
     04-Mar-2011 Tim Ward        CR#3734 - set_special_interest is deleting 'I' and 'A' and it should only delete 'I'.
     18-Mar-2011 Tim Ward        CR#3731 - PERSONNEL should not be deleted.
                                  Also defaulted delete_object to return 'You are not authorized to perform the requested action.'
                                  instead of 'Y'.  Removed the checkForPriv from i2ms.js deleteObj function.
                                  Changed in delete_object.
     07-Oct-2011 Tim Ward        CR#3946 - Add ParentInfo Open Link to Grid and Selected Attachment Detials so the users can get to the
                                  parent quickly (if it is not the same as this file). 
                                  Changed OSI_OBJECT.GET_OPEN_LINK so it returns 32000 instead of 200 in the Link since the parentinfo 
                                  can be as long as the title + a few characters...
     25-Oct-2011 Tim Ward        Now looks up Object Classification, if not found, uses the OSI.DEFAULT_CLASS.
                                  Changed in getstatusbar.
     15-Nov-2011 Tim Ward        CR#3738 - Adding Active/All Flag.
                                  Added is_object_active.
     06-Dec-2011 Tim Ward        CR#3646 - Remove Disallowed/Repaid Expenses from Active Filter.
                                  Changed is_object_active.
     19-Dec-2011 Tim Ward        Added get_lead_agent_name to make desktop selects 8 seconds quicker
                                 by not having to call two functions.
     24-May-2012 Tim Ward        CR#4005 - Add Direct Links into Notes.
                                  Currently does Note only, but could be expanded to other Support Objects when needed.
                                  Changed get_object_url.
                                  Added go_to_tab.  (Moved from the Application Proccess, now that process calls this).
                                  Added get_support_obj_url.
     05-Oct-2012 Tim Ward        CR#4118 - Right Click issues on EMM Desktop.
                                  Changed get_id, get_object_url, and get_tagline_link.
     29-Nov-2012 Tim Ward        CR#4197 - Changed get_id to try to get full_id, if null get id for Files.
                                  
******************************************************************************/
    c_pipe   VARCHAR2(100) := Core_Util.get_config('CORE.PIPE_PREFIX') || 'OSI_OBJECT';

    PROCEDURE log_error(p_msg IN VARCHAR2) IS
    BEGIN
        Core_Logger.log_it(c_pipe, p_msg);
    END log_error;
    
    FUNCTION get_default_title(p_obj_type_sid IN VARCHAR2)
        RETURN VARCHAR2 IS
    BEGIN
        FOR x IN (SELECT default_title
                    FROM T_OSI_OBJ_TYPE
                   WHERE SID = p_obj_type_sid)
        LOOP
            RETURN x.default_title;
        END LOOP;

        RETURN NULL;
    EXCEPTION
        WHEN OTHERS THEN
            log_error('get_default_title: ' || SQLERRM);
    END get_default_title;
    
    PROCEDURE do_title_substitution(p_obj IN VARCHAR2) IS
        v_objcode   T_CORE_OBJ_TYPE.code%TYPE;
        v_updated   VARCHAR2(4000);
        v_sid       T_CORE_OBJ.SID%TYPE;
    BEGIN
        SELECT code
          INTO v_objcode
          FROM T_CORE_OBJ_TYPE
         WHERE SID = Core_Obj.get_objtype(p_obj);

        /*
         * Any object types that need special processing should have a case statement
         * that is above 'ACT%' added for them.
         */
        CASE
            WHEN v_objcode LIKE 'ACT.AAPP%' THEN
                BEGIN
                    SELECT file_sid
                      INTO v_sid
                      FROM T_OSI_ASSOC_FLE_ACT
                    WHERE activity_sid = p_obj;
                    
                    v_updated := Osi_Util.do_title_substitution(v_sid, Osi_Activity.get_title(p_obj));
                    v_updated := Osi_Util.do_title_substitution(p_obj, v_updated);
                    
                    UPDATE T_OSI_ACTIVITY
                       SET title = v_updated
                     WHERE SID = p_obj;
                 EXCEPTION
                    WHEN NO_DATA_FOUND THEN
                        -- This should never happen.
                        log_error('do_title_substitution: - Error in ACT.AAPP% case - ' || SQLERRM);
                 END;
                 
            WHEN v_objcode LIKE 'ACT%' THEN
                v_updated := Osi_Util.do_title_substitution(p_obj, Osi_Activity.get_title(p_obj));

                UPDATE T_OSI_ACTIVITY
                   SET title = v_updated
                 WHERE SID = p_obj;

            WHEN v_objcode LIKE 'FILE%' THEN
                v_updated := Osi_Util.do_title_substitution(p_obj, Osi_File.get_title(p_obj), 'T_OSI_FILE');

                UPDATE T_OSI_FILE
                   SET title = v_updated
                 WHERE SID = p_obj;
        END CASE;
    EXCEPTION
        WHEN OTHERS THEN
            log_error('do_title_substitution: ' || SQLERRM);
    END do_title_substitution;

    FUNCTION get_participant_sid(p_obj IN VARCHAR2, p_usage IN VARCHAR2)
        RETURN VARCHAR2 IS
        v_rtn   T_OSI_PARTICIPANT.SID%TYPE;
    BEGIN
        IF p_obj IS NOT NULL AND p_usage IS NOT NULL THEN
            SELECT i.participant_version
              INTO v_rtn
              FROM T_OSI_PARTIC_INVOLVEMENT i, T_OSI_PARTIC_ROLE_TYPE ir
             WHERE i.involvement_role = ir.SID AND i.obj = p_obj AND ir.USAGE = p_usage;
        END IF;

        RETURN v_rtn;
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            RETURN v_rtn;
        WHEN OTHERS THEN
            log_error('get_participant_sid: ' || SQLERRM);
            RAISE;
    END get_participant_sid;

    FUNCTION get_support_obj_url(p_obj IN VARCHAR2, p_support_obj IN VARCHAR2, p_obj_context IN VARCHAR2, p_item_names IN VARCHAR2 := NULL, p_item_values IN VARCHAR2 := NULL) RETURN VARCHAR2 IS

            v_url            VARCHAR2(1000);
            v_obj_count      NUMBER;
            v_obj_type_sid   VARCHAR2(20);
            v_page_num       VARCHAR2(20);
            v_item_names     VARCHAR2(1000);
            v_item_values    VARCHAR2(1000);
            v_tab_sid        VARCHAR2(20);
            
    BEGIN
         SELECT 'javascript:newWindow({page:' || page_num || ',clear_cache:''' || page_num
                   || ''',name:''' || p_obj || ''',item_names:''P0_OBJ,P0_OBJ_CONTEXT'
                   || DECODE(p_item_names, NULL, NULL, ',' || p_item_names) || ''',item_values:'''
                   || p_obj || ',' || p_obj_context || DECODE(p_item_values, NULL, NULL, ',' || p_item_values)
                   || ''',request:''OPEN''})'
              INTO v_url
              FROM T_CORE_DT_OBJ_TYPE_PAGE WHERE obj_type MEMBER OF Osi_Object.get_objtypes(p_obj) AND page_function = 'OPEN';

         --- Figure out what type of supoprt object this is ---
         v_obj_type_sid := core_obj.get_objtype(p_obj);
         v_item_names := p_item_names;
         if v_item_names is not null then
         
           v_item_names := ',' || v_item_names;
           
         end if;
         v_item_values := p_item_values;
         if v_item_values is not null then
         
           v_item_values := ',' || v_item_values;
           
         end if;
         
         --- Is it A Note? ---
         select count(*) into v_obj_count from t_osi_note where sid=p_support_obj;
         if v_obj_count > 0 then
           
           select page_num,sid into v_page_num,v_tab_sid from t_osi_tab where obj_type member of osi_object.get_objtypes(p_obj) and tab_label='Notes';

           v_url := 'javascript:newWindow({page:' || v_page_num || ',clear_cache:''' || v_page_num
                       || ''',name:''' || p_obj || ''',item_names:''P0_OBJ,P0_OBJ_CONTEXT'
                       || v_item_names || ''',item_values:'''
                       || p_obj || ',' || p_obj_context || v_item_values
                       || ''',request:''DIRECTLINK_' || p_support_obj || '_' || v_tab_sid || '_' || p_obj || '''})';

           return v_url;
           
         end if;

         --- Is it an Assignment? ---
         /*select count(*) into v_obj_count from t_osi_assignment where sid=p_support_obj;
         if v_obj_count > 0 then
           
           select page_num,sid into v_page_num,v_tab_sid from t_osi_tab where obj_type member of osi_object.get_objtypes(p_obj) and tab_label='Assignments';

           v_url := 'javascript:newWindow({page:' || v_page_num || ',clear_cache:''' || v_page_num
                       || ''',name:''' || p_obj || ''',item_names:''P0_OBJ,P0_OBJ_CONTEXT'
                       || v_item_names || ''',item_values:'''
                       || p_obj || ',' || p_obj_context || v_item_values
                       || ''',request:''DIRECTLINK_' || p_support_obj || '''})';

           return v_url;

         end if;

         --- Is it an Attachment/Report? ---
         select count(*) into v_obj_count from t_osi_attachment where sid=p_support_obj;
         if v_obj_count > 0 then
           
           select page_num,sid into v_page_num,v_tab_sid from t_osi_tab where obj_type member of osi_object.get_objtypes(p_obj) and tab_label='Attachments';

           v_url := 'javascript:newWindow({page:' || v_page_num || ',clear_cache:''' || v_page_num
                       || ''',name:''' || p_obj || ''',item_names:''P0_OBJ,P0_OBJ_CONTEXT'
                       || v_item_names || ''',item_values:'''
                       || p_obj || ',' || p_obj_context || v_item_values
                       || ''',request:''DIRECTLINK_' || p_support_obj || '''})';

           return v_url;

         end if;*/

         return v_url;
    
    EXCEPTION WHEN OTHERS THEN
             return v_url;
                               
    END get_support_obj_url;
    
    FUNCTION get_object_url(p_obj IN VARCHAR2, p_item_names IN VARCHAR2 := NULL, p_item_values IN VARCHAR2 := NULL) RETURN VARCHAR2 IS

            v_url            VARCHAR2(200);
            v_obj            T_CORE_OBJ.SID%TYPE;
            v_obj_context    T_OSI_PARTICIPANT_VERSION.SID%TYPE;
            v_support_obj    VARCHAR2(20) := null;
            v_split_counter  NUMBER := 1;

    BEGIN
         v_obj := p_obj;
         
         for a in (select * from table(split(v_obj,'~')))
         loop
             if (v_split_counter = 1) then
             
               v_obj := a.column_value;
               
             elsif (v_split_counter = 2) then
                  
                  v_support_obj := a.column_value;
                  
             end if;
             v_split_counter := v_split_counter+1;
             
         end loop;

         --- Special Handling for Evidence Management Module ---
         IF substr(v_obj,1,3)='EMM' THEN
  
           return 'javascript:newWindow({page:30700,clear_cache:''30700'',name:''' || v_obj || ''',item_names:''P0_OBJ'',item_values:''' || LTRIM(v_obj,'EMM') || ''',request:''OPEN''});';

         END IF;         
         --- See if this person has access first ---
         IF (Osi_Auth.Check_Access(v_obj, p_supress_logging=>TRUE) = 'N') THEN

           --- They do not, so do not give them the URL ---
           v_url := 'javascript:newWindow({page:120,clear_cache:'''',name:'''',item_names:''P120_OBJ'',item_values:''' || v_obj || ','',request:''OPEN''})';
           RETURN v_url;

         END IF;
    
         --- Determine if the given p_obj is an obj sid or a participant version sid. ---
         FOR x IN (SELECT SID, participant FROM v_osi_participant_version WHERE SID = v_obj)
         LOOP
             v_obj := x.participant;
             v_obj_context := x.SID;
             
         END LOOP;
         
         if v_support_obj is null then

           SELECT 'javascript:newWindow({page:' || page_num || ',clear_cache:''' || page_num
                     || ''',name:''' || v_obj || ''',item_names:''P0_OBJ,P0_OBJ_CONTEXT'
                     || DECODE(p_item_names, NULL, NULL, ',' || p_item_names) || ''',item_values:'''
                     || v_obj || ',' || v_obj_context || DECODE(p_item_values, NULL, NULL, ',' || p_item_values)
                     || ''',request:''OPEN''})'
                INTO v_url
                FROM T_CORE_DT_OBJ_TYPE_PAGE WHERE obj_type MEMBER OF Osi_Object.get_objtypes(v_obj) AND page_function = 'OPEN';
         
         else
         
           v_url := get_support_obj_url(v_obj, v_support_obj, v_obj_context, p_item_names, p_item_values);
              
         end if;
         
         RETURN v_url;
    EXCEPTION
        WHEN OTHERS THEN
            log_error('get_object_url: ' || SQLERRM);
            RETURN('get_object_url: Error');
    END get_object_url;

    FUNCTION get_open_link(p_obj IN VARCHAR2, p_text IN VARCHAR2 := NULL)
        RETURN VARCHAR2 IS
        v_rtn VARCHAR2(32000);
    BEGIN
        IF p_obj IS NOT NULL THEN
            v_rtn := '<!--' || p_obj || '--><a href="' || get_object_url(p_obj) || '">';
            IF(p_text IS NULL)THEN
                v_rtn := v_rtn || 'Open</a>';
            ELSE
                v_rtn := v_rtn || p_text || '</a>';
            END IF;
            RETURN v_rtn;
        ELSE
            RETURN NULL;
        END IF;
    EXCEPTION
        WHEN OTHERS THEN
            log_error('get_open_link: ' || SQLERRM);
            RETURN('get_open_link: Error');
    END get_open_link;

    FUNCTION get_tagline_link(p_obj IN VARCHAR2)
        RETURN VARCHAR2 IS
    BEGIN
        IF p_obj IS NOT NULL THEN
          
          IF SUBSTR(p_obj,1,3)='EMM' THEN

            RETURN '<!--' || Core_Obj.get_tagline(p_obj) || '--><a href="' || get_object_url(p_obj) || '">' || Core_Obj.get_tagline(p_obj) || '</a>';

          ELSE

            RETURN '<!--' || Core_Obj.get_tagline(p_obj) || '--><a href="' || get_object_url(p_obj) || '">' || Core_Obj.get_tagline(p_obj) || '</a>';

          END IF;
          
        ELSE
            RETURN NULL;
        END IF;
    EXCEPTION
        WHEN OTHERS THEN
            log_error('get_tagline_link: ' || SQLERRM);
            RETURN('get_tagline_link: Error');
    END get_tagline_link;

    FUNCTION get_next_id
        RETURN VARCHAR2 IS
        v_personnel_num T_CORE_PERSONNEL.personnel_num%TYPE := NVL(Core_Context.personnel_num, '00000');
        v_year          NUMBER                              := TO_NUMBER(TO_CHAR(SYSDATE, 'yy'));
        v_doy           NUMBER                              := TO_NUMBER(TO_CHAR(SYSDATE, 'ddd'));
        v_hours         NUMBER                              := TO_NUMBER(TO_CHAR(SYSDATE, 'hh24'));
        v_minutes       NUMBER                              := TO_NUMBER(TO_CHAR(SYSDATE, 'mi'));
        v_tmp_id        T_OSI_FILE.ID%TYPE                  := NULL;
        v_exists        NUMBER                              := 1;
    BEGIN
         LOOP
             v_tmp_id := LTRIM(RTRIM(TO_CHAR(v_personnel_num,'00000'))) || 
                         LTRIM(RTRIM(TO_CHAR(v_year,'00'))) || 
                         LTRIM(RTRIM(TO_CHAR(v_doy,'000'))) || 
                         LTRIM(RTRIM(TO_CHAR(v_hours,'00'))) || 
                         LTRIM(RTRIM(TO_CHAR(v_minutes,'00')));

             BEGIN
                 SELECT 1
                   INTO v_exists
                   FROM dual
                  WHERE EXISTS(SELECT 1
                                 FROM (SELECT ID
                                         FROM T_OSI_FILE
                                       UNION ALL
                                       SELECT ID
                                         FROM T_OSI_ACTIVITY) o
                                WHERE o.ID = v_tmp_id);
             EXCEPTION
                 WHEN NO_DATA_FOUND THEN
                     EXIT;
             END;

             v_minutes := v_minutes - 1;

             IF v_minutes < 0 THEN
                
               v_hours := v_hours - 1;
                
               IF v_hours < 0 THEN
                  
                 v_doy := v_doy - 1;
                
                 IF v_doy < 0 THEN
                  
                   v_doy := 365;
                  
                 END IF;
                
                 v_hours := 23;
                  
               END IF;
                
               v_minutes := 59;
                
              END IF;
            
          END LOOP;

          RETURN v_tmp_id;
          
    END get_next_id;

    FUNCTION get_special_interest(p_sid IN VARCHAR2)
        RETURN VARCHAR2 IS
        v_array    apex_application_global.vc_arr2;
        v_idx      INTEGER                         := 1;
        v_string   VARCHAR2(4000);
    BEGIN
        FOR i IN (SELECT mission
                    FROM T_OSI_MISSION
                   WHERE obj = p_sid
                    AND obj_context = 'I')
        LOOP
            v_array(v_idx) := i.mission;
            v_idx := v_idx + 1;
        END LOOP;

        v_string := apex_util.table_to_string(v_array, ':');
        RETURN v_string;
    EXCEPTION
        WHEN OTHERS THEN
            log_error('get_special_interest: ' || SQLERRM);
            RAISE;
    END get_special_interest;

    PROCEDURE set_special_interest(p_sid IN VARCHAR2, p_special_interest IN VARCHAR2) IS
        v_array    apex_application_global.vc_arr2;
        v_string   VARCHAR2(4000);
    BEGIN
        v_array := apex_util.string_to_table(p_special_interest, ':');

        FOR i IN 1 .. v_array.COUNT
        LOOP
            INSERT INTO T_OSI_MISSION
                        (obj, mission, obj_context)
                SELECT p_sid, v_array(i), 'I'
                  FROM dual
                 WHERE NOT EXISTS(SELECT 1
                                    FROM T_OSI_MISSION
                                   WHERE obj = p_sid AND mission = v_array(i) AND obj_context = 'I');
        END LOOP;

        DELETE FROM T_OSI_MISSION
              WHERE obj = p_sid AND INSTR(NVL(p_special_interest, 'null'), mission) = 0 and obj_context='I';
    EXCEPTION
        WHEN OTHERS THEN
            log_error('set_special_interest: ' || SQLERRM);
            RAISE;
    END set_special_interest;
    
    /* Gets the status history SID of an object */
    FUNCTION get_status_history_sid(p_obj IN VARCHAR2)
        RETURN VARCHAR2 IS
    BEGIN
        FOR k IN (SELECT SID
                    FROM T_OSI_STATUS_HISTORY
                   WHERE obj = p_obj AND is_current = 'Y')
        LOOP
            RETURN k.SID;
        END LOOP;

        RETURN NULL;
    EXCEPTION
        WHEN OTHERS THEN
            RETURN 'Error in get_status_history_sid function!' || CHR(10) || 'P_OBJ=' || p_obj;
    END get_status_history_sid;
    
    FUNCTION get_status_code(p_obj IN VARCHAR2)
        RETURN VARCHAR2 IS
    BEGIN
        FOR x IN (SELECT s.code
                    FROM T_OSI_STATUS_HISTORY sh, T_OSI_STATUS s
                   WHERE sh.SID = get_status_history_sid(p_obj)
                     AND sh.status = s.SID)
        LOOP
            RETURN x.code;
        END LOOP;

        RETURN NULL;
    EXCEPTION
        WHEN OTHERS THEN
            log_error('get_status_code: ' || SQLERRM);
            RETURN NULL;
    END get_status_code;

    FUNCTION get_status_sid(p_obj IN VARCHAR2)
        RETURN VARCHAR2 IS
    BEGIN
        FOR a IN (SELECT status
                    FROM T_OSI_STATUS_HISTORY
                   WHERE SID = get_status_history_sid(p_obj))
        LOOP
            RETURN a.status;
        END LOOP;

        RETURN NULL;
    EXCEPTION
        WHEN OTHERS THEN
            RETURN 'Error in GET_STATUS function!' || CHR(10) || 'P_OBJ=' || p_obj;
    END get_status_sid;

    FUNCTION get_status(p_obj IN VARCHAR2)
        RETURN VARCHAR2 IS
        v_status   T_OSI_STATUS.description%TYPE;
    BEGIN
        IF p_obj IS NULL THEN
            log_error('get_status: null parameter passed');
            RETURN NULL;
        END IF;

        SELECT description
          INTO v_status
          FROM T_OSI_STATUS
         WHERE SID = get_status_sid(p_obj);

        RETURN v_status;
    EXCEPTION
        WHEN OTHERS THEN
            log_error('get_status: ' || SQLERRM || ' ~ ' || p_obj);
            RETURN NULL;
    END get_status;

    FUNCTION get_objtype_desc(p_obj_type IN VARCHAR2)
        RETURN VARCHAR2 IS
        v_description   T_CORE_OBJ_TYPE.description%TYPE;
    BEGIN
        SELECT description
          INTO v_description
          FROM T_CORE_OBJ_TYPE
         WHERE SID = p_obj_type
            OR code = p_obj_type;

        RETURN v_description;
    EXCEPTION
        WHEN OTHERS THEN
            log_error('get_objtype_desc: ' || SQLERRM);
            RETURN('get_objtype_desc: Error');
    END get_objtype_desc;
    
        FUNCTION get_objtype_code(p_obj_type IN VARCHAR2)
        RETURN VARCHAR2 IS
        v_return   T_CORE_OBJ_TYPE.code%TYPE;
    BEGIN
        SELECT code
          INTO v_return
          FROM T_CORE_OBJ_TYPE
         WHERE SID = p_obj_type;

        RETURN v_return;
    EXCEPTION
        WHEN OTHERS THEN
            log_error('get_objtype_code: ' || SQLERRM);
            RETURN('get_objtype_code: Error');
    END get_objtype_code;

    /* Gets the object specific package to call */
    FUNCTION get_obj_package(p_obj_type IN VARCHAR2)
        RETURN VARCHAR2 IS
        v_package   T_CORE_OBJ_TYPE.method_pkg%TYPE;
    BEGIN
        SELECT method_pkg
          INTO v_package
          FROM T_CORE_OBJ_TYPE
         WHERE SID = p_obj_type;

        RETURN v_package;
    EXCEPTION
        WHEN OTHERS THEN
            log_error('get_obj_package: ' || SQLERRM);
            RAISE;
    END get_obj_package;

    PROCEDURE create_lead_assignment(p_obj IN VARCHAR2, p_personnel IN VARCHAR2 := NULL) IS
        v_personnel   T_CORE_PERSONNEL.SID%TYPE;
    BEGIN
        v_personnel := NVL(p_personnel, Core_Context.personnel_sid);

        IF p_obj IS NOT NULL THEN
            INSERT INTO T_OSI_ASSIGNMENT
                        (obj, personnel, unit, start_date, assign_role)
                 VALUES (p_obj,
                         v_personnel,
                         Osi_Personnel.get_current_unit(v_personnel),
                         SYSDATE,
                         (SELECT SID
                            FROM T_OSI_ASSIGNMENT_ROLE_TYPE
                           WHERE obj_type MEMBER OF get_objtypes(p_obj) AND code = 'LEAD'));
        END IF;
    EXCEPTION
        WHEN OTHERS THEN
            log_error('create_lead_assignment: ' || SQLERRM);
            RAISE;
    END create_lead_assignment;

    /* pipelines records of type t_parent_list one at a time.
       finds the input object type first, including this in the list.
       then it return the parent object type, and the parent's parent, etc.. */
    FUNCTION get_objtypes(p_obj_or_type IN VARCHAR2)
        RETURN t_parent_list pipelined IS
        v_tmp_parent    T_OSI_OBJ_TYPE.PARENT%TYPE;
        v_tmp_objtype   T_OSI_OBJ_TYPE.SID%TYPE;
    BEGIN
        v_tmp_objtype := Core_Obj.get_objtype(p_obj_or_type);

        IF v_tmp_objtype IS NULL THEN
            v_tmp_objtype := p_obj_or_type;
        END IF;

        LOOP
        BEGIN
            pipe ROW(v_tmp_objtype);

            SELECT PARENT
              INTO v_tmp_parent
              FROM T_OSI_OBJ_TYPE
             WHERE SID = v_tmp_objtype;

            EXIT WHEN v_tmp_parent IS NULL;
            v_tmp_objtype := v_tmp_parent;
        EXCEPTION WHEN NO_DATA_FOUND THEN
            EXIT;
        END;
        END LOOP;

        RETURN;
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            log_error('get_objtypes: ' || SQLERRM);
            RETURN;
    END get_objtypes;

    FUNCTION get_id(p_obj IN VARCHAR2, p_obj_context IN VARCHAR2)
        RETURN VARCHAR2 IS
        v_rtn          VARCHAR2(1000)                    := NULL;
        v_type_code    T_CORE_OBJ_TYPE.code%TYPE;
        v_method_pkg   T_CORE_OBJ_TYPE.method_pkg%TYPE;
    BEGIN
         IF SUBSTR(p_obj,1,3)='EMM' THEN
           
           RETURN 'Evidence Management Module for:  ' || core_obj.get_tagline(LTRIM(p_obj,'EMM'));
           
         ELSE

           SELECT method_pkg, code
             INTO v_method_pkg, v_type_code
             FROM T_CORE_OBJ_TYPE
            WHERE SID = Core_Obj.get_objtype(p_obj);
           
           IF v_type_code LIKE 'ACT.%' THEN
             RETURN Osi_Activity.get_id(p_obj);
           ELSIF v_type_code LIKE 'FILE.%' THEN
                select decode(full_id,null,id,full_id) into v_rtn from t_osi_file where sid=p_obj;
                RETURN v_rtn;
           ELSIF v_method_pkg IS NULL THEN
                RETURN NULL;
           ELSE
               BEGIN
                    EXECUTE IMMEDIATE 'begin :rtn := ' || v_method_pkg || '.get_id(:obj,:context); end;'
                            USING OUT v_rtn, IN p_obj, IN p_obj_context;
                    RETURN v_rtn;
               EXCEPTION
                    WHEN OTHERS THEN
                        RETURN NULL;
               END;

           END IF;

         END IF;
          
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            RETURN 'invalid object type';
        WHEN OTHERS THEN
            RETURN 'untrapped error';
    END get_id;
    
    /* Takes and ACTIVITY or FILE sid and return the currently assigned unit */
    FUNCTION get_assigned_unit(p_obj IN VARCHAR2)
        RETURN VARCHAR2 IS
        v_return   VARCHAR2(20);
    --This function is assuming an object will always have an assignment of some type
    BEGIN
        --See if it is an activity
        FOR k IN (SELECT assigned_unit
                    FROM T_OSI_ACTIVITY
                   WHERE SID = p_obj)
        LOOP
            --An activity was found, send back the unit.
            RETURN k.assigned_unit;
        END LOOP;

        FOR k IN (SELECT SID FROM T_OSI_FILE WHERE SID = p_obj)
        LOOP
            RETURN Osi_File.get_unit_owner(p_obj);
        END LOOP;

        FOR k IN (SELECT unit FROM T_CFUNDS_ADVANCE_V2 WHERE SID = p_obj) LOOP
            RETURN k.unit;
        END LOOP;
        
        RETURN '<none>';
    EXCEPTION
        WHEN OTHERS THEN
            log_error(SQLERRM);
            RAISE;
    END get_assigned_unit;
    
    /* Performs deletion operation for all objects */
    FUNCTION delete_object(p_obj IN VARCHAR2) RETURN VARCHAR2 IS

          v_rtn      VARCHAR2(200)             := NULL;
          v_ot       VARCHAR2(20)              := NULL;
          v_ot_cd    VARCHAR2(200)             := NULL;

    BEGIN
         v_ot := Core_Obj.get_objtype(p_obj);

         IF v_ot IS NULL THEN

           log_error('Delete_Object: Error locating Object Type for ' || NVL(v_ot, 'NULL'));
           RETURN 'Invalid Object passed to Delete_Object';

         END IF;

         SELECT code INTO v_ot_cd FROM T_CORE_OBJ_TYPE WHERE SID = v_ot;

         CASE 
             WHEN SUBSTR(v_ot_cd,1,3) = 'ACT' THEN

                 v_rtn := Osi_Activity.can_delete(p_obj);

             WHEN SUBSTR(v_ot_cd,1,4) = 'FILE' THEN

                 v_rtn := Osi_File.can_delete(p_obj);
  
             WHEN SUBSTR(v_ot_cd,1,4) = 'PART' THEN

                 v_rtn := Osi_Participant.can_delete(p_obj);
      
             WHEN v_ot_cd = 'CFUNDS_ADV' THEN

                 v_rtn := Osi_Cfunds_Adv.can_delete(p_obj);
  
             WHEN v_ot_cd = 'CFUNDS_EXP' THEN

                 v_rtn := Osi_Cfunds.can_delete(p_obj);

             WHEN v_ot_cd = 'UNIT' THEN

                 ---Can never delete units, if this changes, will need to make a OSI_UNIT.CAN_DELETE() function---
                 v_rtn := 'You are not authorized to perform the requested action.';

             WHEN v_ot_cd = 'PERSONNEL' THEN

                 ---Can never delete Personnel, if this changes, will need to make a OSI_PERSONNEL.CAN_DELETE() function---
                 v_rtn := 'You are not authorized to perform the requested action.';
             
             WHEN v_ot_cd = 'EVIDENCE' THEN

                 ---Gets here ONLY if the Evidence is NOT Read-ONLY---
                 v_rtn := 'Y';
                      
             ELSE 
                 v_rtn := 'You are not authorized to perform the requested action.';

         END CASE;

         IF v_rtn <> 'Y' THEN

           RETURN v_rtn;

         END IF;
    
         ---execute the delete, all object-specific and child table deletions will cascade---
         DELETE FROM T_CORE_OBJ WHERE SID = p_obj;

         RETURN 'Y';

    EXCEPTION
        WHEN OTHERS THEN
            log_error('Delete_Object: Error encountered using Object ' || NVL(p_obj, 'NULL') || ':' || SQLERRM);
            RETURN 'Untrapped error in Delete_Object using Object: ' || NVL(p_obj, 'NULL');
    END delete_object;

    FUNCTION check_writability(p_obj IN VARCHAR2, p_obj_context IN VARCHAR2)
        RETURN VARCHAR2 IS
        v_rtn          VARCHAR2(1000)                    := NULL;
        v_type_code    T_CORE_OBJ_TYPE.code%TYPE;
        v_method_pkg   T_CORE_OBJ_TYPE.method_pkg%TYPE;
    BEGIN
        
        SELECT method_pkg, code
          INTO v_method_pkg, v_type_code
          FROM T_CORE_OBJ_TYPE
         WHERE SID = Core_Obj.get_objtype(p_obj);

        IF v_type_code LIKE 'ACT.%' THEN
            RETURN Osi_Activity.check_writability(p_obj);
        ELSE
            BEGIN
                EXECUTE IMMEDIATE 'begin :rtn := ' || v_method_pkg || '.check_writability(:obj,:context); end;'
                        USING OUT v_rtn, IN p_obj, IN p_obj_context;
                RETURN v_rtn;
            EXCEPTION
                WHEN OTHERS THEN
                    RETURN 'Y';
            END;
        END IF;
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            log_error('osi_object.check_writability: invalid object type');
        WHEN OTHERS THEN
            log_error('osi_object.check_writablity: ' || SQLERRM);
            RAISE;
    END check_writability;

    FUNCTION is_assigned(p_obj IN VARCHAR2, p_personnel IN VARCHAR2 := NULL)
        RETURN VARCHAR2 IS
        v_personnel   T_CORE_PERSONNEL.SID%TYPE;
    BEGIN
        v_personnel := NVL(p_personnel, Core_Context.personnel_sid);

        FOR x IN (SELECT 'Y' AS result
                    FROM T_OSI_ASSIGNMENT
                   WHERE obj = p_obj
                     AND personnel = v_personnel
                     AND SYSDATE BETWEEN NVL(start_date, TO_DATE('01011901', 'mmddyyyy'))
                                     AND NVL(end_date, TO_DATE('12312999', 'mmddyyyy')))
        LOOP
            RETURN x.result;
        END LOOP;
        
        RETURN 'N';
    EXCEPTION
        WHEN OTHERS THEN
            log_error('osi_object.is_assigned: ' || SQLERRM);
            RAISE;
    END is_assigned;

    FUNCTION get_lead_agent(p_obj IN VARCHAR2)
        RETURN VARCHAR2 IS
    BEGIN
        FOR i IN (SELECT oa.personnel
                    FROM T_OSI_ASSIGNMENT oa, 
                         T_OSI_ASSIGNMENT_ROLE_TYPE oart
                   WHERE oa.obj = p_obj
                     AND oa.assign_role = oart.SID 
                     AND oart.code = 'LEAD'
                ORDER BY oa.end_date DESC)
        LOOP
            RETURN i.personnel;
        END LOOP;

        RETURN NULL;
    EXCEPTION
        WHEN OTHERS THEN
            log_error('osi_object.get_lead_agent: ' || SQLERRM);
            RAISE;
    END get_lead_agent;

    FUNCTION get_lead_agent_name(p_obj IN VARCHAR2)
        RETURN VARCHAR2 IS
    BEGIN
            FOR i IN (SELECT cp.last_name, cp.first_name
                        FROM T_OSI_ASSIGNMENT oa, 
                             T_OSI_ASSIGNMENT_ROLE_TYPE oart,
                             T_CORE_PERSONNEL cp
                       WHERE oa.obj = p_obj
                         AND oa.personnel = cp.SID
                         AND oa.assign_role = oart.SID 
                         AND oart.code = 'LEAD'
                    ORDER BY oa.end_date DESC)
            LOOP
                RETURN  i.last_name || ', ' || i.first_name;
            END LOOP;
            RETURN 'NO LEAD AGENT';
        EXCEPTION
            WHEN OTHERS THEN
                RETURN 'NO LEAD AGENT';
    END get_lead_agent_name;

--======================================================================================================================
--======================================================================================================================
    FUNCTION addicon(v_template IN CLOB, p_sid IN VARCHAR2)
        RETURN CLOB IS
        v_rtn        CLOB           := NULL;
        v_iconlink   VARCHAR2(1000);
        v_inifile    VARCHAR2(128);
        v_vlturl     VARCHAR2(1000);
    BEGIN

        SELECT setting                                                                       --value
          INTO v_inifile
          FROM T_CORE_CONFIG
         WHERE code = 'DEFAULTINI';

        v_iconlink :=
            '<A HREF="I2MS:://pSid=' || p_sid || ' ' || v_inifile
            || '"><IMG BORDER=0 ALT="Open in I2MS" SRC="\images\I2MS\OBJ_SEARCH\i2ms.gif"></A>&nbsp&nbsp';
        IF    Core_Util.get_config('OSI_VLT_URL_JSP') IS NOT NULL
           OR Core_Util.get_config('OSI_VLT_URL_OWA') IS NOT NULL THEN

        v_iconlink :=
            v_iconlink || '<A HREF="' || v_vlturl
            || '"><IMG BORDER=0 ALT="Launch Visual Link Tool" SRC="\images\I2MS\OBJ_SEARCH\vlt.gif"></A>&nbsp&nbsp';

        END IF;
        IF    v_template = ''
           OR v_template IS NULL THEN
            v_rtn := v_iconlink;
        ELSE
            SELECT REPLACE(v_template, '<h2>', '<h2>' || v_iconlink)
              INTO v_rtn
              FROM dual;
        END IF;

        RETURN v_rtn;
    EXCEPTION
        WHEN OTHERS THEN
            Core_Logger.log_it(c_pipe, 'ODW.AddIcon Error: ' || SQLERRM);
            RETURN v_template;
    END addicon;

--======================================================================================================================
--   Retrieve the poper template                                                                                      ==
--======================================================================================================================

    PROCEDURE get_template(p_name IN VARCHAR2, p_template IN OUT NOCOPY CLOB) IS
        v_date              DATE;
        v_ok                VARCHAR2(256);
        v_prefix            VARCHAR2(20) := 'osi_';
        v_mime_type         T_CORE_TEMPLATE.mime_type%TYPE;
        v_mime_disposition  T_CORE_TEMPLATE.mime_disposition%TYPE;
    BEGIN

        v_ok := Core_Template.get_latest(v_prefix || p_name, p_template, v_date, v_mime_type, v_mime_disposition);

        IF v_date IS NULL THEN                                         -- try it without the prefix
            v_ok := Core_Template.get_latest(p_name, p_template, v_date, v_mime_type, v_mime_disposition);

            IF v_date IS NULL THEN

                RAISE_APPLICATION_ERROR(-20200,
                                        'Could not locate template "' || v_prefix || p_name || '"');
            END IF;
        END IF;

    END get_template;

--======================================================================================================================
--======================================================================================================================

    PROCEDURE append_assoc_activities(
        p_doc      IN OUT NOCOPY   CLOB,
        p_parent   IN              VARCHAR2) IS

        v_cnt    NUMBER;
        v_temp   VARCHAR2(5000);

    BEGIN
        v_cnt := 0;

        FOR h IN (SELECT activity_sid, activity_id, activity_title
                    FROM v_osi_assoc_fle_act
                   WHERE file_sid = p_parent)
        LOOP
            IF (   (Core_Classification.has_hi(h.activity_sid, NULL, 'ORCON') = 'Y')
                    OR (Core_Classification.has_hi(h.activity_sid, NULL, 'LIMDIS') = 'Y')) THEN
                Core_Logger.log_it
                    (c_pipe,
                     'ODW.Append_Assoc_Activities: Object is ORCON or LIMDIS - User does not have permission to view document '
                     || 'therefore no link will be generated');
            ELSE
            v_cnt := v_cnt + 1;
            v_temp := '<TR><TD width="100%"><b>' || v_cnt || ': </b>';
            v_temp := v_temp || Osi_Object.get_tagline_link(h.activity_sid);
            v_temp := v_temp || ', ' || h.activity_title || '</TD></TR>';
            Osi_Util.aitc(p_doc, v_temp);
            END IF;
        END LOOP;

        IF v_cnt = 0 THEN
            Osi_Util.aitc(p_doc, '<TR><TD width="100%">No Data Found<br></TD></TR>');
        END IF;
    END append_assoc_activities;

--======================================================================================================================
--======================================================================================================================

    PROCEDURE append_attachments(p_doc IN OUT NOCOPY CLOB, p_parent IN VARCHAR2) IS
        v_cnt    NUMBER         := 0;
        v_cnt2   NUMBER         := 0;
        v_temp   VARCHAR2(5000);

    BEGIN

        FOR h IN (SELECT a.SID, 
                           AT.USAGE, 
                           NVL(a.description, AT.description) AS desc_type,
                           NVL(dbms_lob.getlength(a.content), 0) AS blob_length
                      FROM T_OSI_ATTACHMENT a,
                           T_OSI_ATTACHMENT_TYPE AT,
                           T_CORE_OBJ o,
                           T_CORE_OBJ_TYPE ot
                     WHERE a.obj = p_parent
                       AND a.obj = o.SID
                       AND a.TYPE = AT.SID(+)
                       AND o.obj_type = ot.SID
                       AND NVL(AT.USAGE, 'ATTACHMENT') = 'ATTACHMENT'
                  ORDER BY a.modify_on)
        LOOP
            v_cnt := v_cnt + 1;
            v_temp := '<TR><TD><B>' || v_cnt || ':</B> </TD>';
            v_temp := v_temp || '<TD width="100%">';

            IF h.blob_length > 0 THEN
                --v_temp := v_temp || '<a href="docs/' || h.sid || '">';
                v_temp := v_temp || '<a href="f?p=' || v( 'APP_ID') || ':250:' || v( 'SESSION') || ':'
                                || h.SID || ':' || v('DEBUG') || ':250: " target="blank"/>';
            END IF;

            -- If there is no description then put something
            IF h.desc_type IS NULL THEN
                v_temp := v_temp || h.SID;
            ELSE
                v_temp := v_temp || h.desc_type;
            END IF;

            IF h.blob_length > 0 THEN
              v_temp := v_temp || '</a>';
            END IF;

            v_temp := v_temp || '</TD></TR>';
            Osi_Util.aitc(p_doc, v_temp);
        END LOOP;
        IF v_cnt = 0 THEN
            Osi_Util.aitc(p_doc, '<TR><TD width="100%">No Data Found</TD></TR>');
        END IF;

    EXCEPTION                                                   -- handle eception with default info
        WHEN OTHERS THEN
            Core_Logger.log_it(c_pipe, 'ODW.Append_Attachments Error: ' || SQLERRM);
            Osi_Util.aitc(p_doc, '<TR><TD width="100%">No Data Found</TD></TR>');
    END append_attachments;

--======================================================================================================================
--======================================================================================================================

    PROCEDURE append_involved_participants(
        p_clob         IN OUT NOCOPY   CLOB,
        p_parent       IN              VARCHAR2,
        p_leave_blank  IN              BOOLEAN := FALSE) IS

        v_object_type   VARCHAR2(4);

    BEGIN
      SELECT SUBSTR(ot.code, 1, 4)
        INTO v_object_type
        FROM T_CORE_OBJ o,
             T_CORE_OBJ_TYPE ot
       WHERE o.SID = p_parent
         AND o.obj_type = ot.SID;

      CASE v_object_type
      WHEN 'FILE'
        THEN
          Osi_Util.aitc(p_clob, '<tr><td nowrap><b>Role</b></td><td width=100%><b>Name</b></td></tr>');

          FOR p IN (SELECT fi.ROLE,
                           pv.participant
                      FROM v_osi_partic_file_involvement fi,
                           T_OSI_PARTICIPANT_VERSION pv
                     WHERE pv.SID = fi.participant_version
                       AND fi.file_sid = p_parent
                  ORDER BY fi.ROLE)
          LOOP
            Osi_Util.aitc(p_clob,
              '<tr><td nowrap>' || p.ROLE || '</td>' || '<td>'
              || Osi_Object.get_tagline_link(p.participant) || '</td></tr>');
          END LOOP;
      WHEN 'ACT.'
        THEN
          Osi_Util.aitc(p_clob, '<tr><td nowrap><b>Role</b></td><td width=100%><b>Name</b></td></tr>');

          FOR p IN (SELECT ai.ROLE,
                           pv.participant
                      FROM v_osi_partic_act_involvement ai,
                           T_OSI_PARTICIPANT_VERSION pv
                     WHERE pv.SID = ai.participant_version
                       AND ai.activity = p_parent
                 ORDER BY ai.ROLE)
          LOOP
            Osi_Util.aitc(p_clob,
              '<tr><td nowrap>' || p.ROLE || '</td>' || '<td>'
              || Osi_Object.get_tagline_link(p.participant) || '</td></tr>');
          END LOOP;
      ELSE
        IF NOT p_leave_blank 
          THEN
            Osi_Util.aitc(p_clob, '<tr><td>No data found</td></tr>');
        END IF;
      END CASE;
    

    END append_involved_participants;

--======================================================================================================================
--======================================================================================================================

    PROCEDURE append_notes(p_doc IN OUT NOCOPY CLOB, p_parent IN VARCHAR2) IS
        v_cnt   NUMBER := 0;
    BEGIN

        v_cnt := 0;

        FOR n IN (SELECT n.modify_on, 
                      nt.description,
                      n.note_text
                 FROM T_OSI_NOTE n,
                      T_OSI_NOTE_TYPE nt
                WHERE n.obj = p_parent
                  AND n.note_type = nt.SID
             ORDER BY n.modify_on DESC)
        LOOP
            v_cnt := v_cnt + 1;
            Osi_Util.aitc(p_doc,
                 '<TR><TD width="100%"><B>' || v_cnt || ': NOTE (' || n.description || ', '
                 || TO_CHAR(n.modify_on, 'dd-Mon-YY hh24:mi:ss') || ')</B><BR>');
            dbms_lob.append(p_doc, Core_Util.html_ize(n.note_text));
            Osi_Util.aitc(p_doc, CHR(13) || CHR(10) || '</TD></TR>');
        END LOOP;

        IF v_cnt = 0 THEN
          Osi_Util.aitc(p_doc, '<TR><TD>No Data Found</TD></TR>');
        END IF;

    EXCEPTION                                                   -- handle eception with default info
        WHEN OTHERS THEN
            Core_Util.append_info_to_clob(p_doc,
                                '<TR><TD width="100%">No Data Found</TD></TR>' || CHR(13) || CHR(10)
                                || '</table></body>' || CHR(13) || CHR(10),
                                '');
    END append_notes;


--======================================================================================================================
--======================================================================================================================

    PROCEDURE append_related_files(p_doc IN OUT NOCOPY CLOB, p_parent IN VARCHAR2) IS
        v_cnt    NUMBER         := 0;
        v_temp   VARCHAR2(5000);
    BEGIN

        FOR h IN (SELECT af.file_a AS related_file,
                        (SELECT ID
                           FROM T_OSI_FILE
                          WHERE SID = af.file_a) AS ID,
                        (SELECT title
                           FROM T_OSI_FILE
                          WHERE SID = af.file_a) AS title,
                        (SELECT sot.description
                           FROM T_CORE_OBJ so,
                                T_CORE_OBJ_TYPE sot
                          WHERE so.SID = af.file_a
                            AND so.obj_type = sot.SID) AS description
                   FROM T_OSI_FILE f,
                        T_OSI_ASSOC_FLE_FLE af,
                        T_CORE_OBJ o,
                        T_CORE_OBJ_TYPE ot
                  WHERE f.SID = p_parent
                    AND f.SID = o.SID
                    AND f.SID = af.file_b
                    AND o.obj_type = ot.SID 
                  UNION 
                 SELECT af.file_b AS related_file,
                       (SELECT ID
                          FROM T_OSI_FILE
                         WHERE SID = af.file_b) AS ID,
                       (SELECT title
                          FROM T_OSI_FILE
                         WHERE SID = af.file_b) AS title,
                       (SELECT sot.description
                          FROM T_CORE_OBJ so,
                               T_CORE_OBJ_TYPE sot
                         WHERE so.SID = af.file_b
                           AND so.obj_type = sot.SID) AS description
                  FROM T_OSI_FILE f,
                       T_OSI_ASSOC_FLE_FLE af,
                       T_CORE_OBJ o,
                       T_CORE_OBJ_TYPE ot
                 WHERE f.SID = p_parent
                   AND f.SID = o.SID
                   AND f.SID = af.file_a
                   AND o.obj_type = ot.SID 
              ORDER BY ID)
        LOOP
            IF ((Core_Classification.has_hi(h.related_file, NULL, 'ORCON') = 'Y')
                    OR (Core_Classification.has_hi(h.related_file, NULL, 'LIMDIS') = 'Y')) THEN
                Core_Logger.log_it
                    (c_pipe,
                     'ODW.Append_Related_Files: Object is ORCON or LIMDIS - User does not have permission to view document therefore no link will be generated');
            ELSE
                v_cnt := v_cnt + 1;
                v_temp := '<TR><TD width="100%"><b>' || v_cnt || ': </b>';
                v_temp := v_temp || Osi_Object.get_tagline_link(h.related_file) || ', ';
                v_temp := v_temp || h.title || ', ' || h.description;
                v_temp := v_temp || '</TD></TR>';
                Osi_Util.aitc(p_doc, v_temp);
            END IF;
        END LOOP;

        IF v_cnt = 0 THEN
          Osi_Util.aitc(p_doc, '<TR><TD width="100%">No Data Found<br></TD></TR>');
        END IF;

    END append_related_files;


--======================================================================================================================
--  Initial parsing routine to determine appropriate report to generate.  Once the the proper report is determined    ==
--  the coorisponding report procedure is called.                                                                     ==
--======================================================================================================================
    PROCEDURE doc_detail(p_sid IN VARCHAR2 := NULL) IS

        v_ok           VARCHAR2(1000);
        v_doc          CLOB;
        v_obj_type     T_CORE_OBJ_TYPE.code%TYPE;
        v_authorized   VARCHAR2(10);                             -- can the user run a search
        v_restrict     VARCHAR2(10);                             -- For checking restricted objects
        v_cookie       VARCHAR2(100)   := NULL;

    BEGIN

        BEGIN
            -- restricted files and activities should not be displayed
            v_obj_type := NULL;
            v_restrict := NULL;

            SELECT SUBSTR(ot.code, 1, 3)
              INTO v_obj_type
              FROM T_CORE_OBJ o,
                   T_CORE_OBJ_TYPE ot
             WHERE o.SID = p_sid
               AND o.obj_type = ot.SID;

            IF v_obj_type = 'ACT' THEN

                SELECT r.code AS restriction
                  INTO v_restrict
                  FROM T_OSI_ACTIVITY a,
                       T_OSI_REFERENCE r
                 WHERE a.SID = p_sid
                   AND a.restriction = r.SID;

                IF v_restrict <> 'NONE' AND v_restrict IS NOT NULL THEN
                    htp.print('This activity is restricted.');
                    RETURN;
                END IF;
            END IF;

            SELECT SUBSTR(ot.code, 1, 4)
              INTO v_obj_type
              FROM T_CORE_OBJ o,
                   T_CORE_OBJ_TYPE ot
             WHERE o.SID = p_sid
               AND o.obj_type = ot.SID;

            IF v_obj_type = 'FILE' THEN
                SELECT r.code AS restriction
                  INTO v_restrict
                  FROM T_OSI_FILE f,
                       T_OSI_REFERENCE r
                 WHERE f.SID = p_sid
                   AND f.restriction = r.SID;

                IF v_restrict <> 'NONE' AND v_restrict IS NOT NULL THEN
                    htp.print('This file is restricted.');
                    RETURN;
                END IF;
            END IF;
        EXCEPTION
            WHEN NO_DATA_FOUND THEN
                NULL;                                                 -- Continue processing
        END;

        -- there are calls from other procedures that do not set up the links to pass obj_type.
        -- therefore the need to make sure there is one. Hopefully.
        SELECT ot.code
          INTO v_obj_type
          FROM T_CORE_OBJ o,
               T_CORE_OBJ_TYPE ot
         WHERE o.SID = p_sid
           AND o.obj_type = ot.SID;

        Core_Util.append_info_to_clob(v_doc, CHR(10), '');

        IF SUBSTR(v_obj_type, 1, 3) = 'ACT'
          THEN Osi_Activity.make_doc_act(p_sid, v_doc);   -- Activity Report
          ELSE
            IF SUBSTR(v_obj_type, 1, 4) = 'PART'
              THEN Osi_Participant.run_report_details(p_sid); -- Participant Report
              ELSE
                IF SUBSTR(v_obj_type, 1, 8) = 'FILE.INV'
                  THEN Osi_Investigation.make_doc_investigative_file(p_sid, v_doc); -- Investigative File Report
                  ELSE Osi_File.make_doc_misc_file(p_sid, v_doc); -- General File Report
                END IF;
            END IF;
        END IF;


        IF dbms_lob.getlength(v_doc) > 10 
          THEN
            v_ok := Core_Util.serve_clob(v_doc);
          ELSE
            IF SUBSTR(v_obj_type, 1, 4) = 'PART' 
              THEN NULL;
              ELSE htp.print('<html><head><title>No Document Exists</title></head>'
                      || '<body>No document currently exists for this object.</body></html>');
           END IF;
        END IF;

        Core_Util.cleanup_temp_clob(v_doc);
    END doc_detail;
 
    FUNCTION getStatusBar(p_obj_sid IN VARCHAR2) RETURN VARCHAR2 IS

        v_return VARCHAR2(4000);
        v_type_descr VARCHAR2(200);
        v_create_on VARCHAR2(200);
        v_status VARCHAR2(200);
        v_type_code VARCHAR2(200);
        v_tag VARCHAR2(200);
        v_obtained_by VARCHAR2(200);
        v_personnel_name VARCHAR2(200);
        v_unit_name VARCHAR2(200);
        v_suffix VARCHAR2(200);
        v_obj_type_sid VARCHAR2(200);
        v_obj_act_type_sid VARCHAR2(200);
        v_obj_fle_type_sid VARCHAR2(200);
        v_photo_count VARCHAR2(200);
        v_photo_size VARCHAR2(200);
        v_photo_tab_sid VARCHAR2(200);
        v_deers_date date;
        v_deers_date_string varchar2(200);
        v_classification varchar2(4000);
        
    BEGIN
         IF p_obj_sid IS NULL OR p_obj_sid='' THEN
    
           RETURN '';
     
         END IF;
   
         --- Get the Object Type Sid for ALL Activities ---
         BEGIN
              SELECT SID INTO v_obj_act_type_sid FROM T_CORE_OBJ_TYPE T WHERE CODE='ACT';
     
         EXCEPTION WHEN OTHERS THEN
            
                  v_obj_act_type_sid := '*unknown*';
      
         END;

         --- Get the Object Type Sid for ALL Files ---
         BEGIN
              SELECT SID INTO v_obj_fle_type_sid FROM T_CORE_OBJ_TYPE T WHERE CODE='FILE';
     
         EXCEPTION WHEN OTHERS THEN
            
                  v_obj_fle_type_sid := '*unknown*';
      
         END;

         --- Get the Type Code and Sid for the Current Object (p_obj_sid) ---
         BEGIN
              SELECT CODE,T.SID INTO v_type_code,v_obj_type_sid FROM T_CORE_OBJ O,T_CORE_OBJ_TYPE T WHERE O.OBJ_TYPE=T.SID AND O.SID=p_obj_sid;
     
         EXCEPTION WHEN OTHERS THEN
            
                  v_type_code := '*unknown*';
      
         END;

         IF v_type_code IN ('EMM','UNIT','*unknown*') THEN
       
           RETURN '';
     
         END IF;
      
         --- Get Status for C-Funds Expense Objects ---
         IF v_type_code = 'CFUNDS_EXP' THEN

           BEGIN
                SELECT status INTO v_status FROM v_cfunds_expense_v3 WHERE SID=p_obj_sid;
     
           EXCEPTION WHEN OTHERS THEN
            
                    v_status := '*unknown*';
      
           END;

         --- Get Status for C-Funds Advance Objects ---
         ELSIF v_type_code = 'CFUNDS_ADV' THEN

           BEGIN
                SELECT status INTO v_status FROM v_cfunds_advance_v2 WHERE SID=p_obj_sid;
     
           EXCEPTION WHEN OTHERS THEN
            
                    v_status := '*unknown*';
      
           END;

         --- Get Status for All Other Objects ---
         ELSE
   
           BEGIN
                SELECT Osi_Object.get_status(p_obj_sid) INTO v_status FROM dual;
     
           EXCEPTION WHEN OTHERS THEN
            
                    v_status := '*unknown*';
      
           END;
     
         END IF;
   
         --- Fix the Working for Pariticpant Confirmed/Unconfirmed ---
         IF v_status IN ('Confirm','Unconfirm') THEN
      
           v_status := v_status || 'ed';
     
         END IF;
   
         --- Get Object Type Description ---
         BEGIN
              SELECT description INTO v_type_descr FROM T_CORE_OBJ O,T_CORE_OBJ_TYPE T WHERE O.OBJ_TYPE=T.SID AND O.SID=p_obj_sid;
     
         EXCEPTION WHEN OTHERS THEN
            
                  v_type_descr := '*unknown*';
      
         END;

         --- Get Create On Date ---
         BEGIN
              SELECT TO_CHAR(create_on,'dd-Mon-yyyy') INTO v_create_on FROM T_CORE_OBJ WHERE SID=p_obj_sid;
     
         EXCEPTION WHEN OTHERS THEN
            
                  v_create_on := '*unknown*';
      
         END;

         --- Get Activity Or File Suffix so we will say "Search Activity" instead of just "Search" ---
         BEGIN
              SELECT ' Activity' INTO v_suffix FROM dual WHERE v_obj_act_type_sid MEMBER OF Osi_Object.get_objtypes(v_obj_type_sid);
     
         EXCEPTION WHEN OTHERS THEN
            
            v_suffix := '';
      
         END;
   
         --- Get Activity Or File Suffix so we will say "Case File" instead of just "Case" ---
         IF v_suffix = '' OR v_suffix IS NULL THEN

           BEGIN
                SELECT ' File' INTO v_suffix FROM dual WHERE v_obj_fle_type_sid MEMBER OF Osi_Object.get_objtypes(v_obj_type_sid);
     
           EXCEPTION WHEN OTHERS THEN
            
                         v_suffix := '';
      
           END;
     
         END IF;
   
         --- Make sure we don't say "Security Polygrpah File File" ---
         IF SUBSTR(v_type_descr,LENGTH(v_type_descr)-4,5) = ' File' THEN
     
           v_suffix := '';
     
         END IF;

         --- Make sure we don't say "Agent Application Activity - Education Activity Activity" ---
         IF SUBSTR(v_type_descr,LENGTH(v_type_descr)-8,9) = ' Activity' THEN
     
           v_suffix := '';
     
         END IF;
   
         IF v_type_code = 'EVIDENCE' THEN
           
           BEGIN
                SELECT SUBSTR(DESCRIPTION,1,50),TO_CHAR(OBTAINED_DATE,'dd-Mon-yyyy'),STATUS,TAG_NUMBER,OBTAINED_BY
                      INTO v_type_descr,v_create_on,v_status,v_tag,v_obtained_by FROM v_osi_evidence WHERE SID=p_obj_sid;
     
           EXCEPTION WHEN OTHERS THEN
              
                    RETURN '';
     
           END;

           v_return := '<div ID="footpanel">' || CHR(10) || CHR(13);
           v_return := v_return || ' <ul ID="mainpanel">' || CHR(10) || CHR(13);
           v_return := v_return || '  <li>' || v_type_descr || ' <small>Description</small></li>' || CHR(10) || CHR(13);
           v_return := v_return || '  <li>' || v_create_on || ' <small>Obtained on</small></li>' || CHR(10) || CHR(13);
           v_return := v_return || '  <li>' || v_tag || ' <small>Tag #</small></li>' || CHR(10) || CHR(13);
           v_return := v_return || '  <li>' || v_status || ' <small>Status</small></li>' || CHR(10) || CHR(13);
           v_return := v_return || '  <li>' || v_obtained_by || ' <small>Obtained By</small></li>' || CHR(10) || CHR(13);

         ELSIF v_type_code = 'PERSONNEL' THEN
           
              BEGIN
                   SELECT DECODE(PERSONNEL_STATUS,'CL','Closed','OP','Open','SU','Suspended','Unknown'),TO_CHAR(STATUS_DATE,'dd-Mon-yyyy'),PERSONNEL_NAME,UNIT_NAME
                         INTO v_type_descr,v_create_on,v_personnel_name,v_unit_name FROM v_osi_personnel WHERE SID=p_obj_sid;
     
              EXCEPTION WHEN OTHERS THEN
              
                       RETURN '';
     
              END;  
      
              v_return := '<div ID="footpanel">' || CHR(10) || CHR(13);
              v_return := v_return || ' <ul ID="mainpanel">' || CHR(10) || CHR(13);
              v_return := v_return || '  <li>Status: ' || v_type_descr || ' <small>Status</small></li>' || CHR(10) || CHR(13);
              v_return := v_return || '  <li>Effective: ' || v_create_on || ' <small>Effective</small></li>' || CHR(10) || CHR(13);
              v_return := v_return || '  <li>Agent: ' || v_personnel_name || ' <small>Agent Name</small></li>' || CHR(10) || CHR(13);
              v_return := v_return || '  <li>Unit: ' || v_unit_name || ' <small>Assigned To</small></li>' || CHR(10) || CHR(13);

         ELSE
  
           v_return := '<div ID="footpanel">' || CHR(10) || CHR(13);
           v_return := v_return || ' <ul ID="mainpanel">' || CHR(10) || CHR(13);
           v_return := v_return || '  <li>' || v_type_descr || v_suffix || ' <small>Object Type</small></li>' || CHR(10) || CHR(13);
           v_return := v_return || '  <li>Created on ' || v_create_on || ' <small>Create Date</small></li>' || CHR(10) || CHR(13);
           v_return := v_return || '  <li>Status is ' || v_status || ' <small>Status</small></li>' || CHR(10) || CHR(13);
     
           IF v_type_code = 'PART.INDIV' THEN
             
             BEGIN
                  SELECT COUNT(*),Osi_Util.parse_size(SUM(DBMS_LOB.GETLENGTH(CONTENT))) INTO v_photo_count,v_photo_size FROM T_OSI_ATTACHMENT A,T_OSI_ATTACHMENT_TYPE T WHERE A.TYPE=T.SID AND T.USAGE='MUGSHOT' AND A.OBJ=p_obj_sid;

                  IF v_photo_count = '1' THEN
        
                    v_photo_count := v_photo_count || ' Photo';
      
                  ELSE

                    v_photo_count := v_photo_count || ' Photos';
         
                  END IF;
            
             EXCEPTION WHEN OTHERS THEN
    
                      v_photo_count := '0';
                      v_photo_size := '0 KB';
    
             END;
             
             BEGIN
                  SELECT SID INTO v_photo_tab_sid FROM T_OSI_TAB WHERE tab_label='Photo/Image';

             EXCEPTION WHEN OTHERS THEN

                      v_photo_tab_sid := '2220000077I';

             END;
    
             v_return := v_return || '  <li><a href=javascript:goToTab(''' || v_photo_tab_sid || '''); return false;>' || v_photo_count || '/' || v_photo_size || '</a> <small>Photos/Size</small></li>' || CHR(10) || CHR(13);

             BEGIN
                  SELECT max(DEERS_DATE) INTO v_deers_date FROM T_OSI_PARTICIPANT_HUMAN H,T_OSI_PARTICIPANT_VERSION V WHERE V.PARTICIPANT=p_obj_sid AND V.SID=H.SID;

                  if v_deers_date is null then
                    
                    v_deers_date_string := 'Never';

                  else

                    v_deers_date_string := to_char(v_deers_date,'dd-Mon-YYYY HH:MI:SS PM');
                  
                  end if;
                  
             EXCEPTION WHEN OTHERS THEN

                      v_deers_date := 'Never';

             END;
             v_return := v_return || '  <li>' || v_deers_date_string || '<small>Last DEERS</small></li>' || CHR(10) || CHR(13);
    
           END IF;
           
           v_classification := core_classification.FULL_MARKING(p_obj_sid);
           
           if v_classification is null or v_classification='' then
  
             v_classification := core_util.GET_CONFIG('OSI.DEFAULT_CLASS');
             
             if length(v_classification)<2 then
               
               begin
                    select description into v_classification from t_core_classification_level where code=v_classification;
               
               exception when others then

                             v_classification := core_util.GET_CONFIG('OSI.DEFAULT_CLASS');
               
               end;
               
             end if;
  
           end if;
           v_return := v_return || '  <li>This OBJECT IS Classified:  ' || v_classification || '<small>Classification</small></li>' || CHR(10) || CHR(13);
     
         END IF;
         
         v_return := v_return || ' </ul>' || CHR(10) || CHR(13);
         v_return := v_return || '</div>' || CHR(10) || CHR(13);

         v_return := v_return || '<div ID="minbuttononly">' || CHR(10) || CHR(13);
         v_return := v_return || ' <ul ID="minbuttonpanel">' || CHR(10) || CHR(13);
         v_return := v_return || '  <li CLASS="minbutton" onclick="javascript:hideStatusBar()"><img src="/' || core_util.get_config('OSI.IMAGE_PREFIX') || '/javascript/min.gif" align=bottom><small>Minimize</small></li>' || CHR(10) || CHR(13);
         v_return := v_return || ' </ul">' || CHR(10) || CHR(13);
         v_return := v_return || '</div>' || CHR(10) || CHR(13);

         v_return := v_return || '<div ID="maxbuttononly">' || CHR(10) || CHR(13);
         v_return := v_return || ' <ul ID="maxbuttonpanel">' || CHR(10) || CHR(13);
         v_return := v_return || '  <li CLASS="maxbutton" onclick="javascript:showStatusBar()"><img src="/' || core_util.get_config('OSI.IMAGE_PREFIX') || '/javascript/max.gif" align=bottom><small>Maximize</small></li>' || CHR(10) || CHR(13);
         v_return := v_return || ' </ul>' || CHR(10) || CHR(13);
         v_return := v_return || '</div>' || CHR(10) || CHR(13);
   
         RETURN v_return;
   
    END getStatusBar;

    FUNCTION is_object_active (p_obj in varchar2) return varchar2 is 
  
            p_Active varchar2(1) := 'Y';
            p_Status varchar2(4000);
            p_StatusDate date;
            p_ObjType varchar2(100);
    
    begin
         begin
              select t.code into p_ObjType from t_core_obj c, t_core_obj_type t where c.obj_type=t.sid and c.sid=p_obj;

         exception when others then
              
                  return p_Active;
              
         end;
         
         if p_ObjType in ('CFUNDS_ADV','CFUNDS_EXP') then
           
           begin
                select upper(status),sysdate-120 into p_Status,p_StatusDate from v_cfunds_expense_v3 where sid=p_obj;
                
           exception when others then

                    return p_Active;
                    
           end;
           
         else

           begin
                select upper(s.description),h.effective_on into p_Status,p_StatusDate from t_osi_status_history h, t_osi_status s
                  where h.obj=p_obj
                    and h.status=s.sid
                    and h.is_current='Y';
                    
           exception when others then

                    return p_Active;
                    
           end;
                   
         end if;
         
         If p_Status in ('CLOSED', 'ADMIN CLOSURE', 'TERMINATED', 'DISALLOWED', 'REPAID') then

           --- has it been 30 days ---
           If p_StatusDate + 30 < sysdate then

             --- inactive ---
             p_Active := 'N';

           end if;

         end if;

         If p_Status in ('ARCHIVED','SUBMITTED TO ARCHIVE','SENT TO ARCHIVE','RECEIVED AT ARCHIVE') then --instantly inactive once archived

           --- inactive ---
           p_Active := 'N';

         end if; 
   
         return p_Active;
  
    end is_object_active;

    function Go_To_Tab(pRequest in varchar2,pAuditing in varchar2,p_obj in varchar2,p0_obj_type_sid in varchar2,p0_tabs in out varchar2,tab_params in out varchar2,tab_page in out varchar2, tab_page_obj in out varchar2) return varchar2 is

            v_tab varchar2(20);
            v_tmp varchar2(100);
            v_cnt number := 0;
            
            procedure traverse_tab_parents(p_tab varchar2) is

                     v_parent t_osi_tab.parent_tab%type;
                     v_result boolean;
                     
            begin
                 v_result := core_list.add_item_to_list_front(p_tab, p0_tabs);
          
                 select parent_tab into v_parent from t_osi_tab where sid = p_tab;
          
                 if v_parent is not null then
     
                   traverse_tab_parents(v_parent);

                 end if;
            end traverse_tab_parents;

            procedure set_tab_info(p_tab varchar2) is

                     v_cur_tab t_osi_tab.sid%type;
                     v_result boolean;
                     v_caption t_osi_tab.tab_label%type;
                     
            begin  
                 select page_num, tab_params, tab_label into tab_page, tab_params, v_caption from t_osi_tab where sid = p_tab;

                 if pAuditing = 'ON' then

                   log_info('TabShown:' || p_obj || ' - ' || v_caption);
         
                 end if;

                 if tab_page is null then

                   select x.sid into v_cur_tab from (select sid from t_osi_tab where parent_tab = p_tab and obj_type member of osi_object.get_objtypes(p0_obj_type_sid) order by is_default desc, seq asc) x where rownum = 1;
                   v_result := core_list.add_item_to_list(v_cur_tab, p0_tabs);
                   set_tab_info(v_cur_tab);
                   
                end if;
                
            end set_tab_info;
    begin
         if pRequest like 'TAB_%' then

           if pRequest like 'TAB_%_%' then
      
             v_tmp := substr(pRequest, 5);
      
             for a in (select * from table(split(v_tmp,'_')))
             loop
                 v_cnt := v_cnt + 1;

                 if v_cnt=1 then
            
                   v_tab := a.column_value;
                   v_cnt:=1;

                 end if;

                 if v_cnt=2 then
            
                   tab_page_obj := a.column_value;

                 end if;

             end loop;

            p0_tabs := null;
            traverse_tab_parents(v_tab);
            set_tab_info(v_tab);

          else 

            p0_tabs := null;
            v_tab := substr(pRequest, 5);
            traverse_tab_parents(v_tab);
            set_tab_info(v_tab);

          end if;

        else

          tab_page := null;
  
         end if;

       return p_obj;
       
    end Go_To_Tab;
     
END Osi_Object;
/




