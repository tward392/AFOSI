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


