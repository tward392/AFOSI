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
    28-Nov-2011 Tim Ward        CR#3738 - Adding Active/All Flag.
                                CR#3623 - Active/All Filters Missing.
                                 Added ACTIVE_FILTER, NUM_ROWS, and PAGE_ID 
                                 parameters to DesktopSQL
    05-Dec-2011 Tim Ward        CR#3639 - Full Text Search added/optimized.
                                 Added DesktopFullTextSearchSQL and added p_OtherSearchCriteria to DesktopSQL.
    27-Feb-2012 Tim Ward        CR#4002 - Combining Locators and Adding Active/All filters with Optimization.
                                 Added p_isLocator, p_Exclude, and p_isLocateMany to DesktopSQL parameters.
                                 Added Get_Filter_LOV, Get_Active_Filter_LOV, and Get_Participants_LOV.

******************************************************************************/
  vCRLF VARCHAR2(4) := CHR(13) || CHR(10);
  
  FUNCTION DesktopSQL(FILTER IN VARCHAR2, 
                      user_sid IN VARCHAR2, 
                      p_ObjType IN VARCHAR2, 
                      p_ReturnPageItemName IN VARCHAR2:='', 
                      ACTIVE_FILTER IN VARCHAR2 := 'ACTIVE', 
                      NUM_ROWS IN NUMBER := 15, 
                      PAGE_ID IN VARCHAR2 := 'P', 
                      p_OtherSearchCriteria IN VARCHAR2 := '',
                      APXWS_MAX_ROW_CNT IN VARCHAR2 := '10000',
                      p_WorksheetID IN VARCHAR2 := NULL,
                      p_APP_USER IN VARCHAR2 := NULL,
                      p_Instance IN VARCHAR2 := NULL,
                      p_ReportName IN VARCHAR2 := '',
                      p_isLocator IN VARCHAR2 := 'N',
                      p_isLocatorMulti IN VARCHAR2 := 'N',
                      p_Exclude IN VARCHAR2 := '',
                      p_isLocateMany IN VARCHAR2 := 'N') RETURN VARCHAR2;

  FUNCTION Get_Filter_LOV(p_ObjType IN VARCHAR2, p_Filter_Excludes IN VARCHAR2 := '') RETURN VARCHAR2; 
  FUNCTION Get_Active_Filter_LOV(p_ObjType IN VARCHAR2, p_Active_Filter_Excludes IN VARCHAR2 := '') RETURN VARCHAR2;
  FUNCTION Get_Participants_LOV(p_Comps_Orgs IN VARCHAR2 := '') RETURN VARCHAR2;
   
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
    04-Apr-2012 Tim Ward        CR#3738 - Added Primary Offense Back into Columns.
                                 Changed DesktopFilesSQL.
                                  
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
           
             SQLString := 'select apex_item.checkbox(1,' || vCRLF ||
                          '                          ' || ReturnValue || ',' || vCRLF ||
                          '                          ' || '''' || 'onclick="toggleCheckbox(this); loadIndividuals();"' || '''' || ',' || vCRLF ||
                          '                          ' || '''' || ':p0_loc_selections' || '''' || ',' || vCRLF ||
                          '                          ' || '''' || ':' || '''' || ') as "Include",';
           
           else
  
             SQLString := 'select apex_item.checkbox(1,' || vCRLF ||
                          '                          ' || ReturnValue || ',' || vCRLF ||
                          '                          ' || '''' || 'onclick="toggleCheckbox(this);"' || '''' || ',' || vCRLF ||
                          '                          ' || '''' || ':p0_loc_selections' || '''' || ',' || vCRLF ||
                          '                          ' || '''' || ':' || '''' || ') as "Include",';
           
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
        
    FUNCTION ApexProcessRowTextContains(RowTextContains in varchar2, column_names in assoc_arr) return varchar2 is

      CurrentColumn VARCHAR2(255);
      ColumnCount NUMBER;
      SQLString VARCHAR2(32000);

    BEGIN
         log_error('>>>ApexProcessRowTextContains(' || RowTextContains || ',column_names' || ')');
         IF RowTextContains is not null THEN
                 
           IF length(RowTextContains)>0 THEN

             SQLString := SQLString || vCRLF ||
                              '    AND (';
                 
             CurrentColumn := column_names.first;
             ColumnCount := 0;
             loop
                 exit when CurrentColumn is null;
                 ColumnCount := ColumnCount + 1;
                     
                 IF ColumnCount > 1 THEN
  
                   SQLString := SQLString || vCRLF || 
                                    '        or ';
                                  
                 END IF;
                     
                 SQLString := SQLString ||
                              'instr(upper(' || column_names(CurrentColumn) || '),upper(' || '''' || RowTextContains || '''' || '))> 0';
                                
                 CurrentColumn := column_names.next(CurrentColumn);
                                          
             end loop;
                 
             SQLString := SQLString || ')';
  
           END IF;
                              
         END IF;
         return SQLString;
         log_error('<<<ApexProcessRowTextContains(' || RowTextContains || ',column_names' || ')');
         
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
                 
             SQLString := SQLString || vCRLF ||
                          '     AND (upper(' || column_names(substr(p_OtherSearchCriteria,1,strPOS-1)) || ') like upper(''%' || replace(substr(p_OtherSearchCriteria,strPOS+3), chr(39), chr(39) || chr(39)) || '%' || '''' || '))';
                              
           END IF;

         END IF;

         --- Build the APEX FILTER SEARCH ---
         mySelect := 'select c.name,c.column_name,c.operator,c.expr,c.expr2' || vCRLF || 
                     '      from apex_030200.wwv_flow_worksheet_conditions c,apex_030200.wwv_flow_worksheet_rpts r' || vCRLF || 
                     '          where c.enabled=''Y''' || vCRLF ||
                     '            and c.REPORT_ID=r.ID' || vCRLF ||
                     '            and r.session_id=' || p_Instance || vCRLF ||
                     '            and r.application_user=' || '''' || p_APP_USER || '''' || vCRLF ||
                     '            and r.worksheet_id=' || p_WorksheetID;
        
        if p_ReportName is null or p_ReportName='' then

          mySelect := mySelect || '            and (r.name='''' or r.name is null)';
        
        else

          mySelect := mySelect || '            and r.name=' || '''' || replace(p_ReportName, chr(39), chr(39) || chr(39)) || '''';
                
        end if;
        
        log_error('AddApexSearchFilters - ' || mySelect);
          
         OPEN P_CURSOR FOR mySelect;
                        
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

                       SQLString := SQLString || vCRLF ||
                                    '     AND (upper(' || column_names(ColumnName) || ') like upper(''%' || EXPR || '%' || '''' || '))';

                  ELSIF instr(Operator,'does not contain') > 0 THEN

                       SQLString := SQLString || vCRLF ||
                                    '     AND (upper(' || column_names(ColumnName) || ') not like upper(''%' || EXPR || '%' || '''' || '))';
                       
                  ELSIF Operator in ('like','not like') THEN

                       SQLString := SQLString || vCRLF ||
                                    '     AND (' || column_names(ColumnName) || ' ' || Operator || '''' || EXPR || '''' || ')';

                  ELSIF Operator in ('in','not in') THEN

                       SQLString := SQLString || vCRLF ||
                                    '     AND (' || column_names(ColumnName) || ' ' || Operator || ' (''' || replace(EXPR, ',', chr(39) || ',' || chr(39)) || '''' || '))';

                  ELSIF instr(Operator,'between') > 0 THEN
                  
                       IF instr(ColumnName,'TO_DATE(') > 0 THEN

                         SQLString := SQLString || vCRLF ||
                                      '     AND (' || column_names(ColumnName) || ' between ' || 'TO_DATE(' || '''' || EXPR || '''' || ',''YYYYMMDDHH24MISS'')' || ' AND ' || 'TO_DATE(' || '''' || EXPR2 || '''' || ',''YYYYMMDDHH24MISS'')' || ')';

                       ELSE     

                         SQLString := SQLString || vCRLF ||
                                      '     AND (' || column_names(ColumnName) || ' between ' || '''' || EXPR || '''' || ' AND ' || '''' || EXPR2 || '''' || ')';

                       END IF;
                  
                  ELSIF instr(Operator,'>') > 0 or instr(Operator,'<') > 0 THEN
                  
                       IF instr(ColumnName,'TO_DATE(') > 0 THEN
                    
                         SQLString := SQLString || vCRLF ||
                                      '     AND (' || column_names(ColumnName) || ' ' || Operator || ' TO_DATE(' || '''' || EXPR || '''' || ',''YYYYMMDDHH24MISS''))';

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
                    
                           SQLString := SQLString || vCRLF ||
                                        '     AND (' || column_names(ColumnName) || ' between ' || MultiPlier || ' and systimestamp)';
                    
                         else
                     
                           SQLString := SQLString || vCRLF ||
                                        '     AND (' || column_names(ColumnName) || ' between systimestamp-' || MultiPlier || ' and systimestamp)';
                    
                         end if;
                    
                       elsif instr(Operator,'is not in the last') > 0 then
                    
                         if upper(EXPR2) in ('MONTHS','YEARS') then
                    
                           SQLString := SQLString || vCRLF ||
                                        '     AND (' || column_names(ColumnName) || ' not between ' || MultiPlier || ' and systimestamp)';
                    
                         else
                    
                           SQLString := SQLString || vCRLF ||
                                        '     AND (' || column_names(ColumnName) || ' not between systimestamp-' || MultiPlier || ' and systimestamp)';

                         end if;

                       elsif instr(Operator,'is in the next') > 0 then

                            if upper(EXPR2) in ('MONTHS','YEARS') then
                    
                              SQLString := SQLString || vCRLF ||
                                           '     AND (' || column_names(ColumnName) || ' between systimestamp and ' || replace(MultiPlier,'-','') || ')';
                       
                            else
                       
                              SQLString := SQLString || vCRLF ||
                                           '     AND (' || column_names(ColumnName) || ' between systimestamp and systimestamp+' || MultiPlier || ')';
                            end if;
                    
                       elsif instr(Operator,'is not in the next') > 0 then

                            if upper(EXPR2) in ('MONTHS','YEARS') then
                    
                              SQLString := SQLString || vCRLF ||
                                           '     AND (' || column_names(ColumnName) || ' not between systimestamp and ' || replace(MultiPlier,'-','') || ')';
                       
                            else
                       
                              SQLString := SQLString || vCRLF ||
                                           '     AND (' || column_names(ColumnName) || ' not between systimestamp and systimestamp+' || MultiPlier || ')';

                            end if;
                            
                       end if;

                  ELSIF length(Operator) > 0 and length(EXPR) > 0 and length(ColumnName) > 0 then
                       
                       SQLString := SQLString || vCRLF ||
                                    '     AND (' || column_names(ColumnName) || ' ' || Operator || ' ' || '''' || EXPR || '''' || ')';

                  END IF;
             
              end loop;
         END;
         log_error('<<<AddApexSearchFilters');
         RETURN SQLString;
  
    EXCEPTION WHEN OTHERS THEN
             log_error('Error in AddApexSearchFilters - ' || sqlerrm);
             return '';
           
    END AddApexSearchFilters;
/*     
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
      
--      CurrentColumn VARCHAR2(255);
--      ColumnCount NUMBER;
            
    BEGIN
         log_error('>>>AddApexSearchFilters(' || p_OtherSearchCriteria || ',column_names' || ',' || p_WorksheetID  || ',' || p_APP_USER  || ',' || p_Instance || ',' || p_ReportName || ')');
         
         --- Handle Current Search Criteria ---
         IF instr(p_OtherSearchCriteria, '^~^') > 0 THEN
                 
           IF instr(p_OtherSearchCriteria, 'Row text contains ') > 0 THEN
                   
             RowTextContains := replace(replace(p_OtherSearchCriteria,'Row text contains ^~^',''), chr(39), chr(39) || chr(39));
             SQLString := SQLString || ApexProcessRowTextContains(RowTextContains, column_names);
               
           ELSE
                 
             strPOS := instr(p_OtherSearchCriteria, '^~^');
                 
             SQLString := SQLString || vCRLF ||
                          '     AND (upper(' || column_names(substr(p_OtherSearchCriteria,1,strPOS-1)) || ') like upper(''%' || replace(substr(p_OtherSearchCriteria,strPOS+3), chr(39), chr(39) || chr(39)) || '%' || '''' || '))';
                              
           END IF;

         END IF;
                        
         --- Get any Previous APEX Filters for the Report ---
         for a in (select c.name,c.column_name,c.operator,c.expr,c.expr2 
                     from apex_030200.wwv_flow_worksheet_conditions c,apex_030200.wwv_flow_worksheet_rpts r 
                         where c.enabled='Y'
                           and c.REPORT_ID=r.ID
                           and r.session_id=p_Instance
                           and r.application_user=p_APP_USER
                           and r.worksheet_id=p_WorksheetID
                           and r.name=p_ReportName)
         loop
             RowTextContains := a.name;
             ColumnName := a.column_name;
             Operator := a.operator;
             EXPR := replace(a.expr, chr(39), chr(39) || chr(39));
             EXPR2 := replace(a.expr2, chr(39), chr(39) || chr(39));

             IF instr(RowTextContains, 'Row text contains ') > 0 THEN
                   
               RowTextContains := replace(RowTextContains,'Row text contains ' || chr(39), '');
               RowTextContains := substr(RowTextContains, 1, length(RowTextContains)-1);
               RowTextContains := replace(RowTextContains, chr(39), chr(39) || chr(39));
               SQLString := SQLString || ApexProcessRowTextContains(RowTextContains, column_names);
                       
             ELSIF instr(Operator,'contains') > 0 THEN

                  SQLString := SQLString || vCRLF ||
                               '     AND (upper(' || column_names(ColumnName) || ') like upper(''%' || EXPR || '%' || '''' || '))';

             ELSIF instr(Operator,'does not contain') > 0 THEN

                  SQLString := SQLString || vCRLF ||
                               '     AND (upper(' || column_names(ColumnName) || ') not like upper(''%' || EXPR || '%' || '''' || '))';
                       
             ELSIF Operator in ('like','not like') THEN

                  SQLString := SQLString || vCRLF ||
                               '     AND (' || column_names(ColumnName) || ' ' || Operator || '''' || EXPR || '''' || ')';

             ELSIF Operator in ('in','not in') THEN

                  SQLString := SQLString || vCRLF ||
                               '     AND (' || column_names(ColumnName) || ' ' || Operator || ' (''' || replace(EXPR, ',', chr(39) || ',' || chr(39)) || '''' || '))';

             ELSIF instr(Operator,'between') > 0 THEN
                  
                  IF instr(ColumnName,'TO_DATE(') > 0 THEN

                    SQLString := SQLString || vCRLF ||
                                 '     AND (' || column_names(ColumnName) || ' between ' || 'TO_DATE(' || '''' || EXPR || '''' || ',''YYYYMMDDHH24MISS'')' || ' AND ' || 'TO_DATE(' || '''' || EXPR2 || '''' || ',''YYYYMMDDHH24MISS'')' || ')';

                  ELSE     

                    SQLString := SQLString || vCRLF ||
                                 '     AND (' || column_names(ColumnName) || ' between ' || '''' || EXPR || '''' || ' AND ' || '''' || EXPR2 || '''' || ')';

                  END IF;
                  
             ELSIF instr(Operator,'>') > 0 or instr(Operator,'<') > 0 THEN
                  
                  IF instr(ColumnName,'TO_DATE(') > 0 THEN
                    
                    SQLString := SQLString || vCRLF ||
                                 '     AND (' || column_names(ColumnName) || ' ' || Operator || ' TO_DATE(' || '''' || EXPR || '''' || ',''YYYYMMDDHH24MISS''))';

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
                    
                      SQLString := SQLString || vCRLF ||
                                   '     AND (' || column_names(ColumnName) || ' between ' || MultiPlier || ' and systimestamp)';
                    
                    else
                     
                      SQLString := SQLString || vCRLF ||
                                   '     AND (' || column_names(ColumnName) || ' between systimestamp-' || MultiPlier || ' and systimestamp)';
                    
                    end if;
                    
                  elsif instr(Operator,'is not in the last') > 0 then
                    
                    if upper(EXPR2) in ('MONTHS','YEARS') then
                    
                      SQLString := SQLString || vCRLF ||
                                   '     AND (' || column_names(ColumnName) || ' not between ' || MultiPlier || ' and systimestamp)';
                    
                    else
                    
                      SQLString := SQLString || vCRLF ||
                                   '     AND (' || column_names(ColumnName) || ' not between systimestamp-' || MultiPlier || ' and systimestamp)';

                    end if;

                  elsif instr(Operator,'is in the next') > 0 then

                       if upper(EXPR2) in ('MONTHS','YEARS') then
                    
                         SQLString := SQLString || vCRLF ||
                                      '     AND (' || column_names(ColumnName) || ' between systimestamp and ' || replace(MultiPlier,'-','') || ')';
                       
                       else
                       
                         SQLString := SQLString || vCRLF ||
                                      '     AND (' || column_names(ColumnName) || ' between systimestamp and systimestamp+' || MultiPlier || ')';
                       end if;
                    
                  elsif instr(Operator,'is not in the next') > 0 then

                       if upper(EXPR2) in ('MONTHS','YEARS') then
                    
                         SQLString := SQLString || vCRLF ||
                                      '     AND (' || column_names(ColumnName) || ' not between systimestamp and ' || replace(MultiPlier,'-','') || ')';
                       
                       else
                       
                         SQLString := SQLString || vCRLF ||
                                      '     AND (' || column_names(ColumnName) || ' not between systimestamp and systimestamp+' || MultiPlier || ')';

                       end if;
                       
                  end if;

             ELSIF length(Operator) > 0 and length(EXPR) > 0 and length(ColumnName) > 0 then
                       
                  SQLString := SQLString || vCRLF ||
                               '     AND (' || column_names(ColumnName) || ' ' || Operator || ' ' || '''' || EXPR || '''' || ')';

             END IF;
             
         end loop;

         log_error('<<<AddApexSearchFilters');
         RETURN SQLString;
  
    EXCEPTION WHEN OTHERS THEN
             log_error('Error in AddApexSearchFilters - ' || sqlerrm);
             return '';
           
    END AddApexSearchFilters;
*/
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
         column_names('C005'):='TO_CHAR(e.total_amount_us, ''FML999G999G999G990D00'')';
         column_names('C006'):='e.CATEGORY';
         column_names('C007'):='e.paragraph_number';
         column_names('C008'):='e.modify_on';
         column_names('C009'):='e.voucher_no';
         column_names('C010'):='e.charge_to_unit_name';
         column_names('C011'):='e.status';

         UnitSID := Osi_Personnel.get_current_unit(user_sid);
         
         --- Main Select ---
         SQLString := 'SELECT ''javascript:getObjURL(''''''|| e.SID ||'''''');'' as url,' || vCRLF ||
                      '       to_char(e.incurred_date,''dd-Mon-rrrr'') as "Date Incurred",' || vCRLF ||
                      '       e.claimant_name as "Claimant",' || vCRLF ||
                      '       ''<div class="tooltip" tip="Activity: '' || to_clob(htf.escape_sc(osi_activity.get_id(e.parent)) || '' - '' || core_obj.get_tagline(e.parent)) || ''">'' || substr(''Activity: '' || osi_activity.get_id(e.parent) || '' - '' || core_obj.get_tagline(e.parent),1,25) || case when length(''Activity: '' || osi_activity.get_id(e.parent) || '' - '' || core_obj.get_tagline(e.parent)) > 25 then ''...'' end || ''</div>'' as "Context",' || vCRLF ||
                      '       TO_CHAR(e.total_amount_us, ''FML999G999G999G990D00'') as "Total Amount",' || vCRLF ||
                      '       ''<div class="tooltip" tip="'' || htf.escape_sc(substr(e.description,1,3000)) || ''">'' || substr(e.description,1,25) || case when length(e.description) > 25 then ''...'' end || ''</div>'' as "Description",' || vCRLF ||
                      '       e.CATEGORY as "Category",' || vCRLF ||
                      '       e.paragraph_number as "Paragraph",' || vCRLF ||
                      '       e.modify_on as "Last Modified",' || vCRLF ||
                      '       e.voucher_no as "Voucher #",' || vCRLF ||
                      '       e.charge_to_unit_name as "Charge to Unit",' || vCRLF ||
                      '       e.status as "Status"';

         --- Fields only Needed for Recent/Recent Unit Filters  ---
         IF FILTER IN ('RECENT','RECENT_UNIT') THEN

           SQLString := SQLString || ',' || vCRLF ||
                        '       to_char(r1.last_accessed,''dd-Mon-rrrr'') as "Last Accessed",' || vCRLF ||
                        '       to_char(r1.times_accessed,''00000'') as "Times Accessed",' || vCRLF ||
                        '       to_char(r1.times_accessed / power((sysdate-r1.last_accessed+1),2),''000000.000000'') as "Ranking"';
    
         ELSE

           SQLString := SQLString || ',' || vCRLF ||
                        '       NULL as "Last Accessed",' || vCRLF ||
                        '       NULL as "Times Accessed",' || vCRLF ||
                        '       NULL as "Ranking"';
         
         END IF;

         --- From Clause ---
         SQLString := SQLString || vCRLF ||
                      '      from v_cfunds_expense_v3 e,' || vCRLF ||
                      '           T_CORE_OBJ_TYPE ot,' || vCRLF ||
                      '           T_CORE_OBJ o';

         --- From portion  Needed for Recent/Recent Unit Filters  ---
         IF FILTER IN ('RECENT','RECENT_UNIT') THEN
          
           SQLString := SQLString || ',' || vCRLF ||
                        '         t_osi_personnel_recent_objects r1';
        
         END IF;              

         --- Where Clause  ---
         IF FILTER NOT IN ('NONE') THEN

           SQLString := SQLString || vCRLF ||
                        '  WHERE e.SID=o.SID' || vCRLF ||
                        '    AND ot.code=''CFUNDS_EXP''';
                        
         END IF;

         IF ACTIVE_FILTER='ACTIVE' THEN

           SQLString := SQLString || vCRLF ||
                        '    AND OSI_OBJECT.IS_OBJECT_ACTIVE(e.SID)=''Y''';
                        
         END IF;

         --- Add the Max Row Number Check ---
         SQLString := SQLString || vCRLF ||
                      '    AND ROWNUM <=' || APXWS_MAX_ROW_CNT;
                                         
         --- Add Search Filters ---
         SQLString := SQLString || AddApexSearchFilters(p_OtherSearchCriteria, column_names, p_WorksheetID, p_APP_USER, p_Instance, p_ReportName);

         --- Add Pieces to the Where Clause depending on the Filter ---
         CASE 
             
                              WHEN FILTER='ME' THEN
                                                   SQLString := SQLString || vCRLF || 
                                                                '    AND e.claimant=''' || user_sid ||  '''' || vCRLF ||
                                                                '    ORDER BY ' || '''' || 'Activity: ' || '''' || ' || osi_activity.get_id(e.parent) || ' || '''' || ' - ' || '''' || ' || core_obj.get_tagline(e.parent)'; 
             
                            WHEN FILTER='UNIT' THEN
                                                   SQLString := SQLString || vCRLF || 
                                                                '    AND e.charge_to_unit=''' || UnitSID ||  '''' || vCRLF ||
                                                                '    ORDER BY ' || '''' || 'Activity: ' || '''' || ' || osi_activity.get_id(e.parent) || ' || '''' || ' - ' || '''' || ' || core_obj.get_tagline(e.parent)'; 

                        WHEN FILTER='SUB_UNIT' THEN
                                                   SQLString := SQLString || vCRLF || 
                                                                '    AND e.charge_to_unit in ' || Get_Subordinate_Units(UnitSID) || vCRLF ||
                                                                '    ORDER BY ' || '''' || 'Activity: ' || '''' || ' || osi_activity.get_id(e.parent) || ' || '''' || ' - ' || '''' || ' || core_obj.get_tagline(e.parent)'; 
            
                        WHEN FILTER='SUP_UNIT' THEN
                                                   SQLString := SQLString || vCRLF || 
                                                                '    AND e.charge_to_unit IN ' || Get_Supported_Units(UnitSID) || vCRLF ||
                                                                '    ORDER BY ' || '''' || 'Activity: ' || '''' || ' || osi_activity.get_id(e.parent) || ' || '''' || ' - ' || '''' || ' || core_obj.get_tagline(e.parent)'; 
                                                     
                          WHEN FILTER='RECENT' THEN
                                                   SQLString := SQLString || vCRLF ||  
                                                                '    AND r1.obj=o.sid' || vCRLF ||
                                                                '    AND r1.personnel=''' || user_sid ||  '''' || vCRLF ||
                                                                '    ORDER BY "Ranking" DESC';

                     WHEN FILTER='RECENT_UNIT' THEN
                                                   SQLString := SQLString || vCRLF || 
                                                                '    AND r1.obj=o.sid' || vCRLF ||
                                                                '    AND r1.unit=''' || UnitSID ||  '''' || vCRLF ||
                                                                '    ORDER BY "Ranking" DESC';

             WHEN FILTER='ALL' OR FILTER='OSI' THEN            
                                                   SQLString := SQLString || vCRLF || 
                                                                '    ORDER BY ' || '''' || 'Activity: ' || '''' || ' || osi_activity.get_id(e.parent) || ' || '''' || ' - ' || '''' || ' || core_obj.get_tagline(e.parent)'; 
                                                                
                            WHEN FILTER='NONE' THEN            
                                                   SQLString := SQLString || vCRLF || 
                                                                '  WHERE 1=2';
 
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
         column_names('C006'):='TO_CHAR(a.amount_requested, ''FML999G999G999G990D00'')';
         column_names('C007'):='cfunds_pkg.get_advance_status(a.submitted_on,a.approved_on,a.rejected_on,a.issue_on,a.close_date)';
         column_names('C008'):='osi_unit.get_name(a.unit)';
         column_names('C009'):='osi_unit.get_name(osi_personnel.get_current_unit(a.claimant))';

         UnitSID := Osi_Personnel.get_current_unit(user_sid);

         --- Main Select ---
         SQLString := 'SELECT ''javascript:getObjURL(''''''|| a.SID ||'''''');'' as url,' || vCRLF ||
                      '       to_char(a.request_date,''dd-Mon-rrrr'') as "Date Requested",' || vCRLF ||
                      '       to_char(a.issue_on+90,''dd-Mon-rrrr'') as "Suspense Date",' || vCRLF ||
                      '       osi_personnel.get_name(a.claimant) as "Claimant",' || vCRLF ||
                      '       ''<div class="tooltip" tip="'' || htf.escape_sc(substr(a.narrative,1,3000)) || ''">'' || substr(a.narrative,1,25) || case when length(a.narrative) > 25 then ''...'' end || ''</div>'' as "Description",' || vCRLF ||
                      '       TO_CHAR(a.amount_requested, ''FML999G999G999G990D00'') as "Amount Requested",' || vCRLF ||
                      '       cfunds_pkg.get_advance_status(a.submitted_on,a.approved_on,a.rejected_on,a.issue_on,a.close_date) as "Status",' || vCRLF ||
                      '       osi_unit.get_name(a.unit) as "Charge To Unit",' || vCRLF ||
                      '       osi_unit.get_name(osi_personnel.get_current_unit(a.claimant)) as "Claimants Unit"';

         --- Fields only Needed for Recent/Recent Unit Filters  ---
         IF FILTER IN ('RECENT','RECENT_UNIT') THEN

           SQLString := SQLString || ',' || vCRLF ||
                        '       to_char(r1.last_accessed,''dd-Mon-rrrr'') as "Last Accessed",' || vCRLF ||
                        '       to_char(r1.times_accessed,''00000'') as "Times Accessed",' || vCRLF ||
                        '       to_char(r1.times_accessed / power((sysdate-r1.last_accessed+1),2),''000000.000000'') as "Ranking"';
    
         ELSE

           SQLString := SQLString || ',' || vCRLF ||
                        '       NULL as "Last Accessed",' || vCRLF ||
                        '       NULL as "Times Accessed",' || vCRLF ||
                        '       NULL as "Ranking"';
         
         END IF;

         --- From Clause ---
         SQLString := SQLString || vCRLF ||
                      '      from t_cfunds_advance_v2 a,' || vCRLF ||
                      '           T_CORE_OBJ_TYPE ot,' || vCRLF ||
                      '           T_CORE_OBJ o';

         --- From portion  Needed for Recent/Recent Unit Filters  ---
         IF FILTER IN ('RECENT','RECENT_UNIT') THEN
          
           SQLString := SQLString || ',' || vCRLF ||
                        '          t_osi_personnel_recent_objects r1';
        
         END IF;              

         --- Where Clause  ---
         IF FILTER NOT IN ('NONE') THEN

           SQLString := SQLString || vCRLF ||
                        '  WHERE a.SID=o.SID' || vCRLF ||
                        '    AND ot.sid=o.obj_type' || vCRLF ||
                        '    AND ot.code=''CFUNDS_ADV''';
                        
         END IF;

         IF ACTIVE_FILTER='ACTIVE' THEN

           SQLString := SQLString || vCRLF ||
                        '    AND DECODE(Cfunds_Pkg.Get_Advance_Status(A.SUBMITTED_ON,A.APPROVED_ON,A.REJECTED_ON,A.ISSUE_ON,A.CLOSE_DATE),''Closed'',0,1)=1';
                        
         END IF;

         --- Add the Max Row Number Check ---
         SQLString := SQLString || vCRLF ||
                      '    AND ROWNUM <=' || APXWS_MAX_ROW_CNT;
                                         
         --- Add Search Filters ---
         SQLString := SQLString || AddApexSearchFilters(p_OtherSearchCriteria, column_names, p_WorksheetID, p_APP_USER, p_Instance, p_ReportName);

         --- Add Pieces to the Where Clause depending on the Filter ---
         CASE 
             
                              WHEN FILTER='ME' THEN
                                                   SQLString := SQLString || vCRLF || 
                                                                '    AND a.claimant=''' || user_sid ||  '''' || vCRLF ||
                                                                '    ORDER BY a.request_date desc,"Suspense Date" asc'; 
             
                            WHEN FILTER='UNIT' THEN
                                                   SQLString := SQLString || vCRLF || 
                                                                '    AND a.unit=''' || UnitSID ||  '''' || vCRLF ||
                                                                '    ORDER BY a.request_date desc,"Suspense Date" asc'; 

                        WHEN FILTER='SUB_UNIT' THEN
                                                   SQLString := SQLString || vCRLF || 
                                                                '    AND a.unit in ' || Get_Subordinate_Units(UnitSID) || vCRLF ||
                                                                '    ORDER BY a.request_date desc,"Suspense Date" asc'; 
            
                        WHEN FILTER='SUP_UNIT' THEN
                                                   SQLString := SQLString || vCRLF || 
                                                                '    AND a.unit IN ' || Get_Supported_Units(UnitSID) || vCRLF ||
                                                                '    ORDER BY a.request_date desc,"Suspense Date" asc'; 
                                                     
                          WHEN FILTER='RECENT' THEN
                                                   SQLString := SQLString || vCRLF ||  
                                                                '    AND r1.obj=o.sid' || vCRLF ||
                                                                '    AND r1.personnel=''' || user_sid ||  '''' || vCRLF ||
                                                                '    ORDER BY "Ranking" DESC';

                     WHEN FILTER='RECENT_UNIT' THEN
                                                   SQLString := SQLString || vCRLF || 
                                                                '    AND r1.obj=o.sid' || vCRLF ||
                                                                '    AND r1.unit=''' || UnitSID ||  '''' || vCRLF ||
                                                                '    ORDER BY "Ranking" DESC';

             WHEN FILTER='ALL' OR FILTER='OSI' THEN            
                                                   SQLString := SQLString || vCRLF || 
                                                                '    ORDER BY a.request_date desc,"Suspense Date" asc'; 
                                                                
                            WHEN FILTER='NONE' THEN            
                                                   SQLString := SQLString || vCRLF || 
                                                                '  WHERE 1=2';
 
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
         SQLString := 'SELECT ''javascript:getObjURL(''''''|| e.parent ||'''''');'' as url,' || vCRLF ||
                      '       et.description as "Event",' || vCRLF ||
                      '       to_char(n.generation_date,''dd-Mon-rrrr'') as "Event Date",' || vCRLF ||
                      '       ''<div class="tooltip" tip="'' || htf.escape_sc(substr(Core_Obj.get_tagline(e.PARENT),1,3000)) || ''">'' || substr(Core_Obj.get_tagline(e.PARENT),1,25) || case when length(Core_Obj.get_tagline(e.PARENT)) > 25 then ''...'' end || ''</div>'' as "Context",' || vCRLF ||
                      --'       Core_Obj.get_tagline(e.PARENT) as "Context",' || vCRLF ||
                      '       p.PERSONNEL_NAME as "Recipient",' || vCRLF ||
                      '       e.specifics as "Specifics",' || vCRLF ||
                      '       Osi_Unit.GET_NAME(e.impacted_unit) as "Unit"';

         --- Fields only Needed for Recent/Recent Unit Filters  ---
         IF FILTER IN ('RECENT','RECENT_UNIT') THEN

           SQLString := SQLString || ',' || vCRLF ||
                        '       to_char(r1.last_accessed,''dd-Mon-rrrr'') as "Last Accessed",' || vCRLF ||
                        '       to_char(r1.times_accessed,''00000'') as "Times Accessed",' || vCRLF ||
                        '       to_char(r1.times_accessed / power((sysdate-r1.last_accessed+1),2),''000000.000000'') as "Ranking"';
    
         ELSE

           SQLString := SQLString || ',' || vCRLF ||
                        '       NULL as "Last Accessed",' || vCRLF ||
                        '       NULL as "Times Accessed",' || vCRLF ||
                        '       NULL as "Ranking"';
         
         END IF;
       
         --- From Clause ---
         SQLString := SQLString || vCRLF ||
                      '      from T_OSI_NOTIFICATION n,' || vCRLF ||
                      '           T_OSI_NOTIFICATION_EVENT e,' || vCRLF ||
                      '           T_OSI_NOTIFICATION_EVENT_TYPE et,' || vCRLF ||
                      '           T_CORE_OBJ_TYPE ot,' || vCRLF ||
                      '           T_CORE_OBJ o,' || vCRLF ||
                      '           V_OSI_PERSONNEL p';
        
         --- From portion  Needed for Recent/Recent Unit Filters  ---
         IF FILTER IN ('RECENT','RECENT_UNIT') THEN
          
           SQLString := SQLString || ',' || vCRLF ||
                        '           t_osi_personnel_recent_objects r1';
        
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

         --- Add the Max Row Number Check ---
         SQLString := SQLString || vCRLF ||
                      '    AND ROWNUM <=' || APXWS_MAX_ROW_CNT;

         --- Add Search Filters ---
         SQLString := SQLString || AddApexSearchFilters(p_OtherSearchCriteria, column_names, p_WorksheetID, p_APP_USER, p_Instance, p_ReportName);

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
                                                                '    ORDER BY "Ranking" DESC';

                     WHEN FILTER='RECENT_UNIT' THEN
                                                   SQLString := SQLString || vCRLF || 
                                                                '    AND r1.obj=o.sid' || vCRLF ||
                                                                '    AND r1.unit=''' || UnitSID ||  '''' || vCRLF ||
                                                                '    ORDER BY "Ranking" DESC';

             WHEN FILTER='ALL' OR FILTER='OSI' THEN            
                                                   NULL;
                                                   
                            WHEN FILTER='NONE' THEN            
                                                   SQLString := SQLString || vCRLF || 
                                                                '  WHERE 1=2';
                                                                                                               
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
         SQLString := 'SELECT ''javascript:newWindow({page:30700,clear_cache:''''30700'''',name:''''EMM'' || u.sid || '''''',item_names:''''P0_OBJ'''',item_values:'''''' || u.sid || '''''',request:''''OPEN''''});'' as url,' || vCRLF ||
                      '       ''Evidence Management Module for: '' || osi_unit.get_name(u.sid) as "Module Name"';

         --- Fields only Needed for Recent/Recent Unit Filters  ---
         IF FILTER IN ('RECENT','RECENT_UNIT') THEN

           SQLString := SQLString || ',' || vCRLF ||
                        '       to_char(r1.last_accessed,''dd-Mon-rrrr'') as "Last Accessed",' || vCRLF ||
                        '       to_char(r1.times_accessed,''00000'') as "Times Accessed",' || vCRLF ||
                        '       to_char(r1.times_accessed / power((sysdate-r1.last_accessed+1),2),''000000.000000'') as "Ranking"';
    
         ELSE

           SQLString := SQLString || ',' || vCRLF ||
                        '       NULL as "Last Accessed",' || vCRLF ||
                        '       NULL as "Times Accessed",' || vCRLF ||
                        '       NULL as "Ranking"';
         
         END IF;
       
         --- From Clause ---
         SQLString := SQLString || vCRLF ||
                      '      from T_OSI_UNIT u,' || vCRLF ||
                      '           T_CORE_OBJ o';
        
         --- From portion  Needed for Recent/Recent Unit Filters  ---
         IF FILTER IN ('RECENT','RECENT_UNIT') THEN
          
           SQLString := SQLString || ',' || vCRLF ||
                        '           t_osi_personnel_recent_objects r1';
        
         END IF;              
                      
         --- Where Clause  ---
         IF FILTER NOT IN ('NONE') THEN

           SQLString := SQLString || vCRLF ||
                        '  WHERE u.sid=o.SID';
                        
         END IF;

         --- Add the Max Row Number Check ---
         SQLString := SQLString || vCRLF ||
                      '    AND ROWNUM <=' || APXWS_MAX_ROW_CNT;

         --- Add Search Filters ---
         SQLString := SQLString || AddApexSearchFilters(p_OtherSearchCriteria, column_names, p_WorksheetID, p_APP_USER, p_Instance, p_ReportName);

         --- Add Pieces to the Where Clause depending on the Filter ---
         CASE 
             
                              WHEN FILTER='ME' THEN
                                                   SQLString := SQLString ||  vCRLF ||
                                                                '    AND u.sid=''' || UnitSID || '''' || vCRLF ||
                                                                '    ORDER BY "Module Name"';
             
                            WHEN FILTER='UNIT' THEN
                                                   SQLString := SQLString || vCRLF || 
                                                                '    AND u.sid=''' || UnitSID ||  '''' || vCRLF ||
                                                                '    ORDER BY "Module Name"';

                        WHEN FILTER='SUB_UNIT' THEN
                                                   SQLString := SQLString || vCRLF || 
                                                                '    AND u.sid in ' || Get_Subordinate_Units(UnitSID) || vCRLF || 
                                                                '    ORDER BY "Module Name"';
            
                        WHEN FILTER='SUP_UNIT' THEN
                                                   SQLString := SQLString || vCRLF || 
                                                                '    AND u.sid IN ' || Get_Supported_Units(UnitSID) || vCRLF ||
                                                                '    ORDER BY "Module Name"';
                                                     
                          WHEN FILTER='RECENT' THEN
                                                   SQLString := SQLString || vCRLF || 
                                                                '    AND r1.obj=o.sid' || vCRLF ||
                                                                '    AND r1.personnel=''' || user_sid ||  '''' || vCRLF ||
                                                                '    ORDER BY "Ranking" DESC';

                     WHEN FILTER='RECENT_UNIT' THEN
                                                   SQLString := SQLString || vCRLF || 
                                                                '    AND r1.obj=o.sid' || vCRLF ||
                                                                '    AND r1.unit=''' || UnitSID ||  '''' || vCRLF ||
                                                                '    ORDER BY "Ranking" DESC';

             WHEN FILTER='ALL' OR FILTER='OSI' THEN            
                                                   SQLString := SQLString || vCRLF || 
                                                                '    ORDER BY "Module Name"';
                                                   
                            WHEN FILTER='NONE' THEN            
                                                   SQLString := SQLString || vCRLF || 
                                                                '  WHERE 1=2';
                                                                                                               
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

         log_error('>>>OSI_DESKTOP.DesktopActivitiesSQL(' || FILTER || ',' || user_sid || ',' || p_ReturnPageItemName || ',' || ACTIVE_FILTER || ',' || p_ObjType || ',' || p_OtherSearchCriteria || ',' || APXWS_MAX_ROW_CNT || ',' || p_WorksheetID || ',' || p_APP_USER || ',' || p_Instance || ',' || p_ReportName || ',' || p_isLocator || ',' || p_isLocatorMulti || ',' || p_Exclude || ')');
         
         UnitSID := Osi_Personnel.get_current_unit(user_sid);
         
         --- Main Select ---
         if p_isLocator = 'Y' then
           
           SQLString := addLocatorReturnLink('a.sid', p_isLocatorMulti, p_ReturnPageItemName, p_isLocateMany);
           
         else

           SQLString := 'SELECT  a.url,' || vCRLF;
         
         end if;                  

         SQLString := SQLString || vCRLF ||
                      '       a.ID as "ID",' || vCRLF ||
                      '       a.Activity_Type as "Activity Type",' || vCRLF ||
                      '       a.title as "Title",' || vCRLF ||
                      '       a.Lead_Agent as "Lead Agent",' || vCRLF ||
                      '       a.Status as "Status",' || vCRLF ||
                      '       a.Controlling_Unit as "Controlling Unit",' || vCRLF ||
                      '       a.Created_On as "Created On",';

         --- Fields only Needed for Recent/Recent Unit Filters  ---
         IF FILTER IN ('RECENT','RECENT_UNIT') THEN

           SQLString := SQLString || vCRLF ||
                        '       to_char(r1.last_accessed,''dd-Mon-rrrr'') as "Last Accessed",' || vCRLF ||
                        '       to_char(r1.times_accessed,''00000'') as "Times Accessed",' || vCRLF ||
                        '       to_char(r1.times_accessed / power((sysdate-r1.last_accessed+1),2),''000000.000000'') as "Ranking",';
         
         ELSE

           SQLString := SQLString || vCRLF ||
                        '       NULL as "Last Accessed",' || vCRLF ||
                        '       NULL as "Times Accessed",' || vCRLF ||
                        '       NULL as "Ranking",';
         
         END IF;
         
         --- Add VLT Link ---
         if p_isLocator = 'N' then

           SQLString := SQLString || vCRLF ||
                        '       a.VLT as "VLT",';

         else

           SQLString := SQLString || vCRLF ||
                        '       NULL as "VLT",';
         end if;

         --- Fields not Shown by Default ---
         SQLString := SQLString || vCRLF ||
                      '       a.created_by as "Created By",' || vCRLF ||
                      '       a.Is_Lead as "Is a Lead",' || vCRLF ||
                      '       a.Date_Completed as "Date Completed",' || vCRLF ||
                      '       a.Suspense_Date as "Suspense Date"';
       
         --- From Clause ---
         SQLString := SQLString || vCRLF ||
                      '      from t_osi_activity_lookup a' ;

         --- From portion  Needed for Recent/Recent Unit Filters  ---
         IF FILTER IN ('RECENT','RECENT_UNIT') THEN
          
           SQLString := SQLString || ',' || vCRLF ||
                        '       t_osi_personnel_recent_objects r1';
        
         END IF;              

         --- Where Clause  ---
         IF FILTER NOT IN ('NONE') THEN

           SQLString := SQLString || vCRLF ||
                        '  WHERE 1=1' || vCRLF;
                        
         END IF;
         
         IF ACTIVE_FILTER='ACTIVE' THEN

           SQLString := SQLString || vCRLF ||
                       -- '    AND (A.CLOSE_DATE > sysdate-30 or A.CLOSE_DATE is NULL)'; 
                       '    AND OSI_OBJECT.IS_OBJECT_ACTIVE(a.SID)=''Y''';
                        
         END IF;
         
         --- Add the Max Row Number Check ---
         SQLString := SQLString || vCRLF ||
                      '    AND ROWNUM <=' || APXWS_MAX_ROW_CNT;
         
         --- Add Excludes if Needed ---
         if p_Exclude is not null then
         
           SQLString := SQLString || vCRLF ||
                        '    AND instr(' || '''' || p_Exclude || '''' || ', a.sid) = 0';
         
         end if;
         
         --- Add Search Filters ---
         SQLString := SQLString || AddApexSearchFilters(p_OtherSearchCriteria, column_names, p_WorksheetID, p_APP_USER, p_Instance, p_ReportName);
           
         --- Add Pieces to the Where Clause depending on the Filter ---
         CASE 
             
                              WHEN FILTER='ME' THEN
                                                   SQLString := SQLString || vCRLF || 
                                                                '    AND a.sid in (select obj from t_osi_assignment where end_date is null and personnel=''' || user_sid || ''')' || vCRLF ||
                                                                '    ORDER BY a.activity_type';
             
                            WHEN FILTER='UNIT' THEN
                                                   SQLString := SQLString || vCRLF || 
                                                                '    AND a.controlling_unit_sid=''' || UnitSID ||  '''' || vCRLF ||
                                                                '    ORDER BY a.activity_type';

                        WHEN FILTER='SUB_UNIT' THEN
                                                   SQLString := SQLString || vCRLF || 
                                                                '    AND a.controlling_unit_sid in ' || Get_Subordinate_Units(UnitSID) || vCRLF ||
                                                                '    ORDER BY a.activity_type'; 
                                                                            
                        WHEN FILTER='SUP_UNIT' THEN
                                                   SQLString := SQLString || vCRLF || 
                                                                '    AND a.controlling_unit_sid IN ' || Get_Supported_Units(UnitSID) || vCRLF ||
                                                                '    ORDER BY a.activity_type';
                                                     
                          WHEN FILTER='RECENT' THEN
                                                   SQLString := SQLString || vCRLF ||  
                                                                '    AND r1.obj=a.sid' || vCRLF ||
                                                                '    AND r1.personnel=''' || user_sid ||  '''' || vCRLF ||
                                                                '    ORDER BY "Ranking" DESC';

                     WHEN FILTER='RECENT_UNIT' THEN
                                                   SQLString := SQLString || vCRLF || 
                                                                '    AND r1.obj=a.sid' || vCRLF ||
                                                                '    AND r1.unit=''' || UnitSID ||  '''' || vCRLF ||
                                                                '    ORDER BY "Ranking" DESC';

             WHEN FILTER='ALL' OR FILTER='OSI' THEN            
                                                   SQLString := SQLString || vCRLF || 
                                                                '    ORDER BY a.activity_type';                                                                
                            WHEN FILTER='NONE' THEN            
                                                   SQLString := SQLString || vCRLF || 
                                                                '  WHERE 1=2';
 
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
      
      column_names assoc_arr;
      
    BEGIN
         column_names('C002'):='F.ID';
         column_names('C003'):='OT.DESCRIPTION';
         column_names('C004'):='F.TITLE';
         column_names('C006'):='osi_object.get_status(f.sid)';
         column_names('C007'):='osi_unit.get_name(osi_file.get_unit_owner(f.sid))';
         column_names('C012'):='o.create_by';
         column_names('C013'):='osi_status.last_sh_date(f.sid, ''OP'')';
         column_names('C014'):='osi_status.last_sh_date(f.sid, ''CL'')';
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
            
         SQLString := SQLString || vCRLF ||
                      '       f.id as "ID",' || vCRLF ||
                      '       ot.description as "File Type",' || vCRLF ||
                      '       f.title as "Title",' || vCRLF ||
                      '       o.create_on as "Created On",' || vCRLF ||
                      '       osi_object.get_status(f.sid) as "Status",' || vCRLF ||
                      '       osi_unit.get_name(osi_file.get_unit_owner(f.sid)) as "Controlling Unit",';
                      
         --- Fields only Needed for Recent/Recent Unit Filters  ---
         IF FILTER IN ('RECENT','RECENT_UNIT') THEN

           SQLString := SQLString || vCRLF ||
                        '       to_char(r1.last_accessed,''dd-Mon-rrrr'') as "Last Accessed",' || vCRLF ||
                        '       to_char(r1.times_accessed,''00000'') as "Times Accessed",' || vCRLF ||
                        '       to_char(r1.times_accessed / power((sysdate-r1.last_accessed+1),2),''000000.000000'') as "Ranking",';
         
         ELSE

           SQLString := SQLString || vCRLF ||
                        '       NULL as "Last Accessed",' || vCRLF ||
                        '       NULL as "Times Accessed",' || vCRLF ||
                        '       NULL as "Ranking",';
         
         END IF;
         
         --- Add VLT Link ---
         if p_isLocator = 'N' then

           SQLString := SQLString || vCRLF ||
                        '       ''javascript:newWindow({page:5550,clear_cache:''''5550'''',name:''''VLT''||f.sid||'''''',item_names:''''P0_OBJ'''',item_values:''||''''||''''''''||f.sid||''''''''||''''||'',request:''''OPEN''''})'' as "VLT",';

         else

           SQLString := SQLString || vCRLF ||
                        '       NULL as "VLT",';
         end if;

         --- Fields not Shown by Default ---
         SQLString := SQLString || vCRLF ||
                      '       o.create_by as "Created By",' || vCRLF ||
                      '       osi_status.last_sh_date(f.sid, ''OP'') as "Date Opened",' || vCRLF ||
                      '       osi_status.last_sh_date(f.sid, ''CL'') as "Date Closed",' || vCRLF ||
                      '       osi_file.get_days_since_opened(f.sid) as "Days Since Opened",' || vCRLF ||
                      '       Osi_Object.get_lead_agent_name(f.SID) as "Lead Agent"';

         --- Fields For Investigative Files Only ---
         IF p_ObjType IN ('FILE.INV','FILE.INV.CASE','FILE.INV.DEV','FILE.INV.INFO') THEN

           column_names('C017'):='mc.description';
           SQLString := SQLString || ',' || vCRLF ||
                        '       mc.description as "Mission Area"';
                        
           IF p_ObjType IN ('FILE.INV','FILE.INV.CASE') THEN

             column_names('C018'):='osi_investigation.get_final_roi_date(f.sid)';
             SQLString := SQLString || ',' || vCRLF ||
                          '       osi_investigation.get_final_roi_date(f.sid) as "ROI"';
                          
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
           
           SQLString := SQLString || ',' || vCRLF ||
                        '       aapp.category_desc as "Category",' || vCRLF ||
                        '       aapp.applicant_rank as "Rank",' || vCRLF ||
                        '       aapp.suspense_date as "Suspense Date",' || vCRLF ||
                        '       aapp.curr_disp as "Current Disposition",' || vCRLF ||
                        '       aapp.start_date as "Start Date"';
         
         ELSE

           SQLString := SQLString || ',' || vCRLF ||
                        '       NULL as "Category",' || vCRLF ||
                        '       NULL as "Rank",' || vCRLF ||
                        '       NULL as "Suspense Date",' || vCRLF ||
                        '       NULL as "Current Disposition",' || vCRLF ||
                        '       NULL as "Start Date"';
         
         END IF;

         --- Fields For POLY Files Only ---
         IF p_ObjType IN ('FILE.POLY_FILE.SEC', 'FILE.POLY_FILE.CRIM') THEN
         
           column_names('C017'):='osi_unit.get_name(csp.requesting_unit)';
           column_names('C018'):='osi_unit.get_name(csp.rpo_unit)';
           SQLString := SQLString || ',' || vCRLF ||
                        '       osi_unit.get_name(csp.requesting_unit) as "Requesting Unit",' || vCRLF ||
                        '       osi_unit.get_name(csp.rpo_unit) as "RPO"';

         ELSE
         
           SQLString := SQLString || ',' || vCRLF ||
                        '       NULL as "Requesting Unit",' || vCRLF ||
                        '       NULL as "RPO"';

         END IF;
         
         --- From Clause ---
         SQLString := SQLString || vCRLF ||
                      '      from T_OSI_FILE f,' || vCRLF ||
                      '           T_CORE_OBJ_TYPE ot,' || vCRLF ||
                      '           T_CORE_OBJ o';

         IF FILTER IN ('UNIT','SUB_UNIT','SUP_UNIT') THEN
                            
           SQLString := SQLString || vCRLF || 
                         '    ,T_OSI_F_UNIT fu';

         END IF;

         --- Tables For Investigative Files Only ---
         IF p_ObjType in ('FILE.INV','FILE.INV.CASE','FILE.INV.DEV','FILE.INV.INFO') THEN

           SQLString := SQLString || ',' || vCRLF ||
                      '           T_OSI_MISSION_CATEGORY mc,' || vCRLF ||
                      '           T_OSI_F_INVESTIGATION i';
         
         END IF;

         --- Tables For Agent Applicant Files Only ---
         IF p_ObjType IN ('FILE.AAPP') THEN

           SQLString := SQLString || ',' || vCRLF ||
                        '           v_osi_f_aapp_file aapp';
         
         END IF;

         --- Tables For POLY Files Only ---
         IF p_ObjType IN ('FILE.POLY_FILE.SEC', 'FILE.POLY_FILE.CRIM') THEN

           SQLString := SQLString || ',' || vCRLF ||
                        '           t_osi_f_poly_file csp';
         
         END IF;
                      
         --- From portion  Needed for Recent/Recent Unit Filters  ---
         IF FILTER IN ('RECENT','RECENT_UNIT') THEN
          
           SQLString := SQLString || ',' || vCRLF ||
                        '           t_osi_personnel_recent_objects r1';
        
         END IF;              

         --- Where Clause  ---
         IF FILTER NOT IN ('NONE') THEN

           SQLString := SQLString || vCRLF ||
                        '  WHERE f.SID=o.SID' || vCRLF ||
                        '    AND o.obj_type=ot.SID';
                        
         END IF;
         
         IF ACTIVE_FILTER='ACTIVE' THEN

           SQLString := SQLString || vCRLF ||
                        '    AND OSI_OBJECT.IS_OBJECT_ACTIVE(f.SID)=''Y''';
                        
         END IF;

         --- WHERE Clause Parts for Investigative Files Only ---
         IF p_ObjType IN ('FILE.INV','FILE.INV.CASE','FILE.INV.DEV','FILE.INV.INFO') THEN

           SQLString := SQLString || vCRLF ||
                        '    AND i.sid=f.sid' || vCRLF ||
                        '    AND mc.sid(+)=i.manage_by';
           
           IF p_ObjType = 'FILE.INV' THEN

             SQLString := SQLString || vCRLF ||
                          '    AND ot.code in (''FILE.INV.CASE'',''FILE.INV.DEV'',''FILE.INV.INFO'',''FILE.INV'')';
           
           ELSE

             SQLString := SQLString || vCRLF ||
                          '    AND ot.code=''' || p_ObjType || '''';

           END IF;
                  
         END IF;
         
         --- WHERE Clause Parts for Service Files Only ---
         IF p_ObjType in ('FILE.SERVICE','FILE.AAPP','FILE.GEN.ANP','FILE.PSO','FILE.POLY_FILE.SEC') THEN
           
           IF p_ObjType='FILE.SERVICE' THEN

             SQLString := SQLString || vCRLF ||
                          '    AND ot.code in (''FILE.AAPP'',''FILE.GEN.ANP'',''FILE.PSO'',''FILE.POLY_FILE.SEC'')';
                          
           ELSE

             SQLString := SQLString || vCRLF ||
                          '    AND ot.code in (''' || p_ObjType || ''')';
           
           END IF;
           
         END IF;

         --- WHERE Clause Parts for Support Files Only ---
         IF p_ObjType in ('FILE.SUPPORT','FILE.GEN.SRCDEV', 'FILE.GEN.UNDRCVROPSUPP', 'FILE.GEN.TECHSURV', 'FILE.POLY_FILE.CRIM','FILE.GEN.TARGETMGMT') THEN
           
           IF p_ObjType='FILE.SUPPORT' THEN

             SQLString := SQLString || vCRLF ||
                          '    AND ot.code in (''FILE.SUPPORT'',''FILE.GEN.SRCDEV'', ''FILE.GEN.UNDRCVROPSUPP'', ''FILE.GEN.TECHSURV'', ''FILE.POLY_FILE.CRIM'')';
                          
           ELSE

             SQLString := SQLString || vCRLF ||
                          '    AND ot.code in (''' || p_ObjType || ''')';
           
           END IF;
           
         END IF;

         --- Where Clause Part For Agent Applicant Files Only ---
         IF p_ObjType IN ('FILE.AAPP') THEN

           SQLString := SQLString || vCRLF ||
                        '    AND aapp.sid=o.sid';
         
         END IF;

         --- Where Clause Part For POLY Files Only ---
         IF p_ObjType IN ('FILE.POLY_FILE.SEC', 'FILE.POLY_FILE.CRIM') THEN

           SQLString := SQLString || vCRLF ||
                        '    AND csp.sid=o.sid';
         
         END IF;

         --- Add the Max Row Number Check ---
         SQLString := SQLString || vCRLF ||
                      '    AND ROWNUM <=' || APXWS_MAX_ROW_CNT;

         --- Add Excludes if Needed ---
         if p_Exclude is not null then
         
           SQLString := SQLString || vCRLF ||
                        '    AND instr(' || '''' || p_Exclude || '''' || ', f.sid) = 0';
         
         end if;

         --- Add Search Filters ---
         SQLString := SQLString || AddApexSearchFilters(p_OtherSearchCriteria, column_names, p_WorksheetID, p_APP_USER, p_Instance, p_ReportName);
                                                  
         --- Add Pieces to the Where Clause depending on the Filter ---
         CASE 
             
                              WHEN FILTER='ME' THEN
                                                   SQLString := SQLString || vCRLF || 
                                                                '    AND o.sid in (select obj from t_osi_assignment where end_date is null and personnel=''' || user_sid || ''')';
             
                            WHEN FILTER='UNIT' THEN
                                                   SQLString := SQLString || vCRLF || 
                                                                ---'    AND osi_object.get_assigned_unit(o.sid)=''' || UnitSID ||  '''';
                                                                '    AND fu.file_sid=f.sid' || vCRLF ||
                                                                '    AND fu.unit_sid=''' || UnitSID ||  '''' || vCRLF ||
                                                                '    AND fu.end_date is null';

                        WHEN FILTER='SUB_UNIT' THEN
                                                   SQLString := SQLString || vCRLF || 
                                                                ---'    AND osi_unit.is_subordinate(''' || UnitSID || '''' || ',osi_object.get_assigned_unit(o.sid))=''Y''';
                                                                '    AND fu.file_sid=f.sid' || vCRLF ||
                                                                '    AND fu.unit_sid in (select a.sid from t_osi_unit a start with a.sid=''' || UnitSID || '''' || ' connect by prior a.sid=a.unit_parent)' || vCRLF ||
                                                                '    AND fu.end_date is null' || vCRLF ||
                                                                '    AND fu.unit_sid!=''' || UnitSID || '''';
                                                                            
                        WHEN FILTER='SUP_UNIT' THEN
                                                   SQLString := SQLString || vCRLF || 
                                                                ---'    AND osi_object.get_assigned_unit(o.sid) in (select sup_unit from t_osi_unit_sup_units where unit=''' || UnitSID || '''' || ')';
                                                                '    AND fu.file_sid=f.sid' || vCRLF ||
                                                                '    AND fu.unit_sid in (select unit from t_osi_unit_sup_units where sup_unit=''' || UnitSID || '''' || ')' || vCRLF ||
                                                                '    AND fu.end_date is null';
                                                     
                          WHEN FILTER='RECENT' THEN
                                                   SQLString := SQLString || vCRLF ||  
                                                                '    AND r1.obj=o.sid' || vCRLF ||
                                                                '    AND r1.personnel=''' || user_sid ||  '''';

                     WHEN FILTER='RECENT_UNIT' THEN
                                                   SQLString := SQLString || vCRLF || 
                                                                '    AND r1.obj=o.sid' || vCRLF ||
                                                                '    AND r1.unit=''' || UnitSID ||  '''';

             WHEN FILTER='ALL' OR FILTER='OSI' THEN            
                                                   NULL;
                                                                                                                   
                            WHEN FILTER='NONE' THEN            
                                                   SQLString := SQLString || vCRLF || 
                                                                '  WHERE 1=2';
 
         END CASE;
         
         --- Add the Order By Clause ---
         CASE
             WHEN FILTER IN ('RECENT','RECENT_UNIT') THEN
           
                 SQLString := SQLString || vCRLF || 
                              '    ORDER BY "Ranking" DESC';

             WHEN FILTER='NONE' THEN            

                 NULL;           

             ELSE

               --- Order By Clause for Investigative Files Only ---
               IF p_ObjType IN ('FILE.INV','FILE.INV.CASE','FILE.INV.DEV','FILE.INV.INFO') THEN

                 SQLString := SQLString || vCRLF || 
                              '    ORDER BY title';
                              
                 IF p_ObjType IN ('FILE.INV','FILE.INV.CASE') THEN

                   SQLString := SQLString || ',ROI DESC';
                   
                 END IF;                              

               --- Order By Clause for Service Files Only ---
               ELSIF p_ObjType in ('FILE.SERVICE','FILE.AAPP','FILE.GEN.ANP','FILE.PSO','FILE.POLY_FILE.SEC') THEN

                    SQLString := SQLString || vCRLF || 
                                 '    ORDER BY ot.description,title';

               --- Order By Clause for Support Files Only ---
               ELSIF p_ObjType in ('FILE.SUPPORT','FILE.GEN.SRCDEV', 'FILE.GEN.UNDRCVROPSUPP', 'FILE.GEN.TECHSURV', 'FILE.POLY_FILE.CRIM') THEN

                    SQLString := SQLString || vCRLF || 
                                 '    ORDER BY ot.description,title';
               ELSE

                 SQLString := SQLString || vCRLF || 
                              '    ORDER BY ot.description,title';

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

         CASE
             WHEN ACTIVE_FILTER in ('ALL') then

                 column_names('C002'):='osi_participant.get_name(o.sid, ''Y'')';
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
                 
                 SQLString := SQLString || vCRLF ||
                              '       osi_participant.get_name(o.sid, ''Y'') as "Name",' || vCRLF ||
                              '       NULL as "Company",' || vCRLF ||
                              '       NULL as "Organization",' || vCRLF ||
                              '       NULL as "Program",' || vCRLF ||
--                              '       osi_participant.get_type(o.sid) as "Type2",' || vCRLF ||
                              '       osi_participant.get_type(o.sid) as "Type",' || vCRLF ||
                              '       osi_participant.get_subtype(o.sid) as "Sub-Type",' || vCRLF ||
                              '       NULL as "Type of Name",' || vCRLF ||
                              '       osi_participant.get_confirmation(o.sid) as "Confirmed",' || vCRLF ||
                              '       o.create_by as "Created By",' || vCRLF ||
                              '       o.create_on as "Created On",' || vCRLF ||
                              '       NULL as "Sex",' || vCRLF ||
                              '       NULL as "Height (in)",' || vCRLF ||
                              '       NULL as "Weight (lbs)",' || vCRLF ||
                              '       NULL as "Minimum Age (yrs)",' || vCRLF ||
                              '       NULL as "Maximum Age (yrs)",' || vCRLF ||
                              '       NULL as "Birth Country",' || vCRLF ||
                              '       NULL as "Birth State",' || vCRLF ||
                              '       NULL as "Birth City",' || vCRLF ||
                              '       NULL as "Birth Date",' || vCRLF ||
                              '       osi_reference.lookup_ref_desc(ph.sa_service) as "Service",' || vCRLF ||
                              '       osi_reference.lookup_ref_desc(ph.sa_affiliation) as "Service Affiliation",' || vCRLF ||
                              '       dibrs_reference.lookup_ref_desc(ph.sa_component) as "Service Component",' || vCRLF ||
                              '       dibrs_reference.lookup_ref_desc(pc.sa_pay_plan) as "Service Pay Plan",' || vCRLF ||
                              '       pg.description as "Service Pay Grade",' || vCRLF ||
                              '       ph.sa_rank as "Service Rank",' || vCRLF ||
                              '       ph.sa_rank_date as "Service Date of Rank",' || vCRLF ||
                              '       ph.sa_specialty_code as "Service Speciality Code",' || vCRLF ||
                              '       NULL as "DUNS",' || vCRLF ||
                              '       NULL as "Cage Code"';

             WHEN ACTIVE_FILTER in ('PART.INDIV') then

                 column_names('C002'):='osi_participant.get_name(o.sid, ''Y'')';
                 column_names('C008'):='osi_participant.get_name_type(o.sid)';
                 column_names('C009'):='osi_participant.get_confirmation(o.sid)';
                 column_names('C010'):='o.create_by';
                 column_names('C011'):='o.create_on';
                 column_names('C012'):='dibrs_reference.lookup_ref_desc(pc.sex)';
                 column_names('C013'):='pc.height';
                 column_names('C014'):='pc.weight';
                 column_names('C015'):='decode(ph.age_low, null, null, ''NB'', ''0.008'', ''NN'', ''0.0014'', ''BB'', ''0.5'', ph.age_low)';
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

                 SQLString := SQLString || vCRLF ||
                              '       osi_participant.get_name(o.sid, ''Y'') as "Name",' || vCRLF ||
                              '       NULL as "Company",' || vCRLF ||
                              '       NULL as "Organization",' || vCRLF ||
                              '       NULL as "Program",' || vCRLF ||
--                              '       NULL as "Type2",' || vCRLF ||
                              '       NULL as "Type",' || vCRLF ||
                              '       NULL as "Sub-Type",' || vCRLF ||
                              '       osi_participant.get_name_type(o.sid) as "Type of Name",' || vCRLF ||
                              '       osi_participant.get_confirmation(o.sid) as "Confirmed",' || vCRLF ||
                              '       o.create_by as "Created By",' || vCRLF ||
                              '       o.create_on as "Created On",' || vCRLF ||
                              '       dibrs_reference.lookup_ref_desc(pc.sex) as "Sex",' || vCRLF ||
                              '       pc.height as "Height (in)",' || vCRLF ||
                              '       pc.weight as "Weight (lbs)",' || vCRLF ||
                              '       decode(ph.age_low, null, null, ''NB'', ''0.008'', ''NN'', ''0.0014'', ''BB'', ''0.5'', ph.age_low) as "Minimum Age (yrs)",' || vCRLF ||
                              '       ph.age_high as "Maximum Age (yrs)",' || vCRLF ||
                              '       osi_participant.get_birth_country(o.sid) as "Birth Country",' || vCRLF ||
                              '       osi_participant.get_birth_state(o.sid) as "Birth State",' || vCRLF ||
                              '       osi_participant.get_birth_city(o.sid) as "Birth City",' || vCRLF ||
                              '       p.dob as "Birth Date",' || vCRLF ||
                              '       osi_reference.lookup_ref_desc(ph.sa_service) as "Service",' || vCRLF ||
                              '       osi_reference.lookup_ref_desc(ph.sa_affiliation) as "Service Affiliation",' || vCRLF ||
                              '       dibrs_reference.lookup_ref_desc(ph.sa_component) as "Service Component",' || vCRLF ||
                              '       dibrs_reference.lookup_ref_desc(pc.sa_pay_plan) as "Service Pay Plan",' || vCRLF ||
                              '       pg.description as "Service Pay Grade",' || vCRLF ||
                              '       ph.sa_rank as "Service Rank",' || vCRLF ||
                              '       ph.sa_rank_date as "Service Date of Rank",' || vCRLF ||
                              '       ph.sa_specialty_code as "Service Speciality Code",' || vCRLF ||
                              '       NULL as "DUNS",' || vCRLF ||
                              '       NULL as "Cage Code"';

             WHEN ACTIVE_FILTER in ('PART.NONINDIV.COMP') then

                 column_names('C003'):='osi_participant.get_name(o.sid, ''Y'')';
                 column_names('C007'):='osi_participant.get_subtype(o.sid)';
                 column_names('C009'):='osi_participant.get_confirmation(o.sid)';
                 column_names('C010'):='o.create_by';
                 column_names('C011'):='o.create_on';
                 column_names('C029'):='pnh.co_duns';
                 column_names('C030'):='pnh.co_cage';
                 
                 SQLString := SQLString || vCRLF ||
                              '       NULL as "Name",' || vCRLF ||
                              '       osi_participant.get_name(o.sid) as "Company",' || vCRLF ||
                              '       NULL as "Organization",' || vCRLF ||
                              '       NULL as "Program",' || vCRLF ||
--                              '       NULL as "Type",' || vCRLF ||
--                              '       osi_participant.get_subtype(o.sid) as "Type2",' || vCRLF ||
                              '       NULL as "Type2",' || vCRLF ||
                              '       osi_participant.get_subtype(o.sid) as "Type",' || vCRLF ||
                              '       NULL as "Type of Name",' || vCRLF ||
                              '       osi_participant.get_confirmation(o.sid) as "Confirmed",' || vCRLF ||
                              '       o.create_by as "Created By",' || vCRLF ||
                              '       o.create_on as "Created On",' || vCRLF ||
                              '       NULL as "Sex",' || vCRLF ||
                              '       NULL as "Height (in)",' || vCRLF ||
                              '       NULL as "Weight (lbs)",' || vCRLF ||
                              '       NULL as "Minimum Age (yrs)",' || vCRLF ||
                              '       NULL as "Maximum Age (yrs)",' || vCRLF ||
                              '       NULL as "Birth Country",' || vCRLF ||
                              '       NULL as "Birth State",' || vCRLF ||
                              '       NULL as "Birth City",' || vCRLF ||
                              '       NULL as "Birth Date",' || vCRLF ||
                              '       NULL as "Service",' || vCRLF ||
                              '       NULL as "Service Affiliation",' || vCRLF ||
                              '       NULL as "Service Component",' || vCRLF ||
                              '       NULL as "Service Pay Plan",' || vCRLF ||
                              '       NULL as "Service Pay Grade",' || vCRLF ||
                              '       NULL as "Service Rank",' || vCRLF ||
                              '       NULL as "Service Date of Rank",' || vCRLF ||
                              '       NULL as "Service Speciality Code",' || vCRLF ||
                              '       pnh.co_duns as "DUNS",' || vCRLF ||
                              '       pnh.co_cage as "Cage Code"';

             WHEN ACTIVE_FILTER in ('PART.NONINDIV.ORG') then

                 column_names('C004'):='osi_participant.get_name(o.sid, ''Y'')';
                 column_names('C007'):='osi_participant.get_subtype(o.sid)';
                 column_names('C009'):='osi_participant.get_confirmation(o.sid)';
                 column_names('C010'):='o.create_by';
                 column_names('C011'):='o.create_on';

                 SQLString := SQLString || vCRLF ||
                              '       NULL as "Name",' || vCRLF ||
                              '       NULL as "Company",' || vCRLF ||
                              '       osi_participant.get_name(o.sid) as "Organization",' || vCRLF ||
                              '       NULL as "Program",' || vCRLF ||
--                              '       NULL as "Type",' || vCRLF ||
--                              '       osi_participant.get_subtype(o.sid) as "Type2",' || vCRLF ||
                              '       NULL as "Type2",' || vCRLF ||
                              '       osi_participant.get_subtype(o.sid) as "Type",' || vCRLF ||
                              '       NULL as "Type of Name",' || vCRLF ||
                              '       osi_participant.get_confirmation(o.sid) as "Confirmed",' || vCRLF ||
                              '       o.create_by as "Created By",' || vCRLF ||
                              '       o.create_on as "Created On",' || vCRLF ||
                              '       NULL as "Sex",' || vCRLF ||
                              '       NULL as "Height (in)",' || vCRLF ||
                              '       NULL as "Weight (lbs)",' || vCRLF ||
                              '       NULL as "Minimum Age (yrs)",' || vCRLF ||
                              '       NULL as "Maximum Age (yrs)",' || vCRLF ||
                              '       NULL as "Birth Country",' || vCRLF ||
                              '       NULL as "Birth State",' || vCRLF ||
                              '       NULL as "Birth City",' || vCRLF ||
                              '       NULL as "Birth Date",' || vCRLF ||
                              '       NULL as "Service",' || vCRLF ||
                              '       NULL as "Service Affiliation",' || vCRLF ||
                              '       NULL as "Service Component",' || vCRLF ||
                              '       NULL as "Service Pay Plan",' || vCRLF ||
                              '       NULL as "Service Pay Grade",' || vCRLF ||
                              '       NULL as "Service Rank",' || vCRLF ||
                              '       NULL as "Service Date of Rank",' || vCRLF ||
                              '       NULL as "Service Speciality Code",' || vCRLF ||
                              '       NULL as "DUNS",' || vCRLF ||
                              '       NULL as "Cage Code"';

             WHEN ACTIVE_FILTER in ('PART.NONINDIV.PROG') then

                 column_names('C005'):='osi_participant.get_name(o.sid, ''Y'')';
                 column_names('C007'):='osi_participant.get_subtype(o.sid)';
                 column_names('C009'):='osi_participant.get_confirmation(o.sid)';
                 column_names('C010'):='o.create_by';
                 column_names('C011'):='o.create_on';

                 SQLString := SQLString || vCRLF ||
                              '       NULL as "Name",' || vCRLF ||
                              '       NULL as "Company",' || vCRLF ||
                              '       NULL as "Organization",' || vCRLF ||
                              '       osi_participant.get_name(o.sid) as "Program",' || vCRLF ||
                              '       NULL as "Type",' || vCRLF ||
                              '       NULL as "Type2",' || vCRLF ||
                              '       NULL as "Type of Name",' || vCRLF ||
                              '       osi_participant.get_confirmation(o.sid) as "Confirmed",' || vCRLF ||
                              '       o.create_by as "Created By",' || vCRLF ||
                              '       o.create_on as "Created On",' || vCRLF ||
                              '       NULL as "Sex",' || vCRLF ||
                              '       NULL as "Height (in)",' || vCRLF ||
                              '       NULL as "Weight (lbs)",' || vCRLF ||
                              '       NULL as "Minimum Age (yrs)",' || vCRLF ||
                              '       NULL as "Maximum Age (yrs)",' || vCRLF ||
                              '       NULL as "Birth Country",' || vCRLF ||
                              '       NULL as "Birth State",' || vCRLF ||
                              '       NULL as "Birth City",' || vCRLF ||
                              '       NULL as "Birth Date",' || vCRLF ||
                              '       NULL as "Service",' || vCRLF ||
                              '       NULL as "Service Affiliation",' || vCRLF ||
                              '       NULL as "Service Component",' || vCRLF ||
                              '       NULL as "Service Pay Plan",' || vCRLF ||
                              '       NULL as "Service Pay Grade",' || vCRLF ||
                              '       NULL as "Service Rank",' || vCRLF ||
                              '       NULL as "Service Date of Rank",' || vCRLF ||
                              '       NULL as "Service Speciality Code",' || vCRLF ||
                              '       NULL as "DUNS",' || vCRLF ||
                              '       NULL as "Cage Code"';

         END CASE;

         --- Fields only Needed for Recent/Recent Unit Filters  ---
         IF FILTER IN ('RECENT','RECENT_UNIT') THEN

           SQLString := SQLString || ',' || vCRLF ||
                        '       to_char(r1.last_accessed,''dd-Mon-rrrr'') as "Last Accessed",' || vCRLF ||
                        '       to_char(r1.times_accessed,''00000'') as "Times Accessed",' || vCRLF ||
                        '       to_char(r1.times_accessed / power((sysdate-r1.last_accessed+1),2),''000000.000000'') as "Ranking",';
         
         ELSE

           SQLString := SQLString || ',' || vCRLF ||
                        '       NULL as "Last Accessed",' || vCRLF ||
                        '       NULL as "Times Accessed",' || vCRLF ||
                        '       NULL as "Ranking",';
         
         END IF;

         --- Add SSN ---
         IF ACTIVE_FILTER in ('PART.INDIV') THEN

           column_names('C034'):='osi_participant.get_number(pv.sid, ''SSN'')';
           SQLString := SQLString || vCRLF ||
             '       osi_participant.get_number(pv.sid, ''SSN'') as "Social Security Number",';

         ELSE

           SQLString := SQLString || vCRLF ||
             '       NULL as "Social Security Number",';

         END IF;         
         
         --- Add VLT Link ---
         if p_isLocator = 'N' then

           SQLString := SQLString || vCRLF ||
                        '       ''javascript:newWindow({page:5550,clear_cache:''''5550'''',name:''''VLT''||p.sid||'''''',item_names:''''P0_OBJ'''',item_values:''||''''||''''''''||p.sid||''''''''||''''||'',request:''''OPEN''''})'' as "VLT"';

         else

           SQLString := SQLString || vCRLF ||
                        '       NULL as "VLT"';
         
         end if;
         
         --- From Clause ---
         SQLString := SQLString || vCRLF ||
                      '      from T_CORE_OBJ o,' || vCRLF ||
                      '           T_CORE_OBJ_TYPE ot,' || vCRLF ||
                      '           T_OSI_PARTICIPANT p,' || vCRLF ||
                      '           T_OSI_PARTIC_NAME pn,' || vCRLF ||
                      '           T_OSI_PARTICIPANT_VERSION pv,' || vCRLF ||
                      '           T_OSI_PARTICIPANT_HUMAN ph,' || vCRLF ||
                      '           T_OSI_PARTICIPANT_NONHUMAN pnh,' || vCRLF ||
                      '           T_OSI_PERSON_CHARS pc,' || vCRLF ||
                      '           T_DIBRS_PAY_GRADE_TYPE pg';

         --- From portion  Needed for Recent/Recent Unit Filters  ---
         IF FILTER IN ('RECENT','RECENT_UNIT') THEN
          
           SQLString := SQLString || ',' || vCRLF ||
                        '           t_osi_personnel_recent_objects r1';
        
         END IF;              

         --- Where Clause  ---
         IF FILTER NOT IN ('NONE') THEN

           SQLString := SQLString || vCRLF ||
                        '  WHERE p.SID=o.SID' || vCRLF ||
                        '    AND o.obj_type=ot.SID' || vCRLF ||
                        '    AND p.current_version=pv.sid' || vCRLF ||
                        '    AND pn.sid=pv.current_name' || vCRLF ||
                        '    AND ph.sid(+)=pv.sid' || vCRLF ||
                        '    AND pnh.sid(+)=pv.sid' || vCRLF ||
                        '    AND pc.sid(+)=pv.sid' || vCRLF ||
                        '    AND pg.sid(+)=pc.sa_pay_grade';
                        
         END IF;

         IF p_ObjType = 'PARTICIPANT' THEN
           
           IF ACTIVE_FILTER='ALL' THEN
  
             SQLString := SQLString || vCRLF ||
                          '    AND ot.code in (''PART.INDIV'',''PART.NONINDIV.COMP'',''PART.NONINDIV.ORG'',''PART.NONINDIV.PROG'')';
           
           ELSE
  
             SQLString := SQLString || vCRLF ||
                          '    AND ot.code=''' || ACTIVE_FILTER || '''';
           
           END IF;
                  
         ELSE

           SQLString := SQLString || vCRLF ||
                        '    AND ot.code=''' || p_ObjType || '''';

         END IF;

         --- Add the Max Row Number Check ---
         SQLString := SQLString || vCRLF ||
                      '    AND ROWNUM <=' || APXWS_MAX_ROW_CNT;

         --- Add Excludes if Needed ---
         if p_Exclude is not null then
         
           SQLString := SQLString || vCRLF ||
                        '    and instr(' || '''' || p_Exclude || '''' || ', o.sid) = 0' || vCRLF ||
                        '    and not exists(select 1 from t_osi_participant_version pv1 where pv1.participant=o.SID and instr(' || '''' || p_Exclude || '''' || ', pv1.sid) > 0)';         

         end if;
         
         --- Add Search Filters ---
         SQLString := SQLString || AddApexSearchFilters(p_OtherSearchCriteria, column_names, p_WorksheetID, p_APP_USER, p_Instance, p_ReportName);

         --- Add Pieces to the Where Clause depending on the Filter ---
         CASE 

                             WHEN FILTER='ABC' THEN
                                                   SQLString := SQLString || vCRLF ||  
                                                                '    AND REGEXP_INSTR(pn.last_name,''[a|b|c][[:alpha:]]'',1,1,0,''i'') = 1';
                                                                
                             WHEN FILTER='DEF' THEN
                                                   SQLString := SQLString || vCRLF ||  
                                                                '    AND REGEXP_INSTR(pn.last_name,''[d|e|f][[:alpha:]]'',1,1,0,''i'') = 1';

                             WHEN FILTER='GHI' THEN
                                                   SQLString := SQLString || vCRLF ||  
                                                                '    AND REGEXP_INSTR(pn.last_name,''[g|h|i][[:alpha:]]'',1,1,0,''i'') = 1';

                             WHEN FILTER='JKL' THEN
                                                   SQLString := SQLString || vCRLF ||  
                                                                '    AND REGEXP_INSTR(pn.last_name,''[j|k|l][[:alpha:]]'',1,1,0,''i'') = 1';

                             WHEN FILTER='MNO' THEN
                                                   SQLString := SQLString || vCRLF ||  
                                                                '    AND REGEXP_INSTR(pn.last_name,''[m|n|o][[:alpha:]]'',1,1,0,''i'') = 1';

                            WHEN FILTER='PQRS' THEN
                                                   SQLString := SQLString || vCRLF ||  
                                                                '    AND REGEXP_INSTR(pn.last_name,''[p|q|r|s][[:alpha:]]'',1,1,0,''i'') = 1';

                             WHEN FILTER='TUV' THEN
                                                   SQLString := SQLString || vCRLF ||  
                                                                '    AND REGEXP_INSTR(pn.last_name,''[t|u|v][[:alpha:]]'',1,1,0,''i'') = 1';

                            WHEN FILTER='WXYZ' THEN
                                                   SQLString := SQLString || vCRLF ||  
                                                                '    AND REGEXP_INSTR(pn.last_name,''[w|x|y|z][[:alpha:]]'',1,1,0,''i'') = 1';

                         WHEN FILTER='NUMERIC' THEN
                                                   SQLString := SQLString || vCRLF ||  
                                                                '    AND REGEXP_INSTR(pn.last_name,''[0-9]'',1,1,0,''i'') = 1';

                           WHEN FILTER='ALPHA' THEN
                                                   SQLString := SQLString || vCRLF ||  
                                                                '    AND REGEXP_INSTR(pn.last_name,''[a-z]'',1,1,0,''i'') = 1';
                                                     
                          WHEN FILTER='RECENT' THEN
                                                   SQLString := SQLString || vCRLF ||  
                                                                '    AND r1.obj=o.sid' || vCRLF ||
                                                                '    AND r1.personnel=''' || user_sid ||  '''';

                     WHEN FILTER='RECENT_UNIT' THEN
                                                   SQLString := SQLString || vCRLF || 
                                                                '    AND r1.obj=o.sid' || vCRLF ||
                                                                '    AND r1.unit=''' || UnitSID ||  '''';

             WHEN FILTER='ALL' OR FILTER='OSI' THEN            
                                                   NULL;
                                                                                                                   
                            WHEN FILTER='NONE' THEN            
                                                   SQLString := SQLString || vCRLF || 
                                                                '  WHERE 1=2';
 
         END CASE;
         
         --- Add the Order By Clause ---
         CASE
             WHEN FILTER IN ('RECENT','RECENT_UNIT') THEN
           
                 SQLString := SQLString || vCRLF || 
                              '    ORDER BY "Ranking" DESC';

             WHEN FILTER='NONE' THEN            

                 NULL;           

             ELSE
               
               CASE
                   WHEN p_ObjType='PARTICIPANT' THEN

                       SQLString := SQLString || vCRLF || 
                                    '    ORDER BY "Type","Name"';
--                                    '    ORDER BY "Type2","Name"';
                                    
                   WHEN p_ObjType='PART.INDIV' THEN

                       SQLString := SQLString || vCRLF || 
                                    '    ORDER BY "Name"';

                   WHEN p_ObjType='PART.NONINDIV.COMP' THEN

                       SQLString := SQLString || vCRLF || 
                                    '    ORDER BY "Company"';

                   WHEN p_ObjType='PART.NONINDIV.ORG' THEN

                       SQLString := SQLString || vCRLF || 
                                    '    ORDER BY "Organization"';

                   WHEN p_ObjType='PART.NONINDIV.PROG' THEN

                       SQLString := SQLString || vCRLF || 
                                    '    ORDER BY "Program"';

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
    FUNCTION DesktopPersonnelSQL(FILTER IN VARCHAR2, user_sid IN VARCHAR2, p_ReturnPageItemName IN VARCHAR2:='', ACTIVE_FILTER IN VARCHAR2, p_ObjType IN VARCHAR2, p_OtherSearchCriteria IN VARCHAR2 := '', APXWS_MAX_ROW_CNT IN NUMBER := 10000, p_WorksheetID IN VARCHAR2 := NULL, p_APP_USER IN VARCHAR2 := NULL, p_Instance IN VARCHAR2 := NULL, p_ReportName IN VARCHAR2 := '', p_isLocator IN VARCHAR2 := 'N', p_isLocatorMulti IN VARCHAR2 := 'N', p_Exclude IN VARCHAR2 := '', p_isLocateMany IN VARCHAR2 := 'N') RETURN VARCHAR2 IS

      SQLString VARCHAR2(32000);
      UnitSID VARCHAR2(20);

      column_names assoc_arr;
   
    BEGIN
         log_error('>>>OSI_DESKTOP.DesktopPersonnelSQL(' || FILTER || ',' || user_sid || ',' || ACTIVE_FILTER || ',' || p_OtherSearchCriteria || ',' || APXWS_MAX_ROW_CNT || ',' || p_WorksheetID || ',' || p_APP_USER || ',' || p_Instance || ')');

         column_names('C002'):='p.personnel_num';
         column_names('C003'):='osi_personnel.get_name(p.sid)';
         column_names('C004'):='osi_unit.get_name(osi_personnel.get_current_unit(p.sid))';
         column_names('C005'):='sex.code';
         column_names('C006'):='op.start_date';
         column_names('C007'):='op.ssn';
         column_names('C008'):='op.badge_num';

         UnitSID := Osi_Personnel.get_current_unit(user_sid);
         
         --- Main Select ---
         if p_isLocator = 'Y' then
           
           SQLString := addLocatorReturnLink('p.sid', p_isLocatorMulti, p_ReturnPageItemName, p_isLocateMany);
           
         else
                  
           SQLString := 'select ''javascript:getObjURL('''''' || p.sid || '''''');'' url,';
           
         end if;
         
         SQLString := SQLString || vCRLF ||
                      '       p.personnel_num as "Employee #",' || vCRLF ||
                      '       osi_personnel.get_name(p.sid) as "Name",' || vCRLF ||
                      '       osi_unit.get_name(osi_personnel.get_current_unit(p.sid)) as "Unit Name",' || vCRLF ||
                      '       sex.code as "Sex",' || vCRLF ||
                      '       op.start_date as "Start Date",' || vCRLF ||
                      '       op.ssn as "SSN",' || vCRLF ||
                      '       op.badge_num as "Badge Number"';
                      
         --- Fields only Needed for Recent/Recent Unit Filters  ---
         IF FILTER IN ('RECENT','RECENT_UNIT') THEN

           SQLString := SQLString || ',' || vCRLF ||
                        '       to_char(r1.last_accessed,''dd-Mon-rrrr'') as "Last Accessed",' || vCRLF ||
                        '       to_char(r1.times_accessed,''00000'') as "Times Accessed",' || vCRLF ||
                        '       to_char(r1.times_accessed / power((sysdate-r1.last_accessed+1),2),''000000.000000'') as "Ranking"';
         
         ELSE

           SQLString := SQLString || ',' || vCRLF ||
                        '       NULL as "Last Accessed",' || vCRLF ||
                        '       NULL as "Times Accessed",' || vCRLF ||
                        '       NULL as "Ranking"';
         
         END IF;
         
         --- From Clause ---
         SQLString := SQLString || vCRLF ||
                      '      from t_core_personnel p,' || vCRLF ||
                      '           t_osi_personnel op,' || vCRLF ||
                      '           t_osi_person_chars c,' || vCRLF ||
                      '           t_dibrs_reference sex';

         --- From portion  Needed for Recent/Recent Unit Filters  ---
         IF FILTER IN ('RECENT','RECENT_UNIT') THEN
          
           SQLString := SQLString || ',' || vCRLF ||
                        '       t_osi_personnel_recent_objects r1';
        
         END IF;              

         --- Where Clause  ---
         IF FILTER NOT IN ('NONE') THEN

           SQLString := SQLString || vCRLF ||
                        '  WHERE p.SID=op.SID' || vCRLF ||
                        '    AND c.SID(+)=p.SID' || vCRLF ||
                        '    AND sex.SID(+)=c.sex';
                        
         END IF;
                                         
         --- Add the Max Row Number Check ---
         SQLString := SQLString || vCRLF ||
                      '    AND ROWNUM <=' || APXWS_MAX_ROW_CNT;

         --- Add Excludes if Needed ---
         if p_Exclude is not null then
         
           SQLString := SQLString || vCRLF ||
                        '    AND instr(' || '''' || p_Exclude || '''' || ', p.sid) = 0';
         
         end if;

         --- Add Search Filters ---
         SQLString := SQLString || AddApexSearchFilters(p_OtherSearchCriteria, column_names, p_WorksheetID, p_APP_USER, p_Instance, p_ReportName);

         --- Add Pieces to the Where Clause depending on the Filter ---
         CASE 
             
                              WHEN FILTER='ME' THEN
                                                   SQLString := SQLString || vCRLF || 
                                                                '    AND p.sid=''' || user_sid || '''' || vCRLF ||
                                                                '    ORDER BY "Name"';
             
                            WHEN FILTER='UNIT' THEN
                                                   SQLString := SQLString || vCRLF || 
                                                                '    AND osi_personnel.get_current_unit(p.sid)=''' || UnitSID ||  '''' || vCRLF ||
                                                                '    ORDER BY "Name"';

                        WHEN FILTER='SUB_UNIT' THEN
                                                   SQLString := SQLString || vCRLF || 
                                                                '    AND osi_personnel.get_current_unit(p.sid) in ' || Get_Subordinate_Units(UnitSID) || vCRLF ||
                                                                '    ORDER BY "Name"'; 
                                                                            
                        WHEN FILTER='SUP_UNIT' THEN
                                                   SQLString := SQLString || vCRLF || 
                                                                '    AND osi_personnel.get_current_unit(p.sid) IN ' || Get_Supported_Units(UnitSID) || vCRLF ||
                                                                '    ORDER BY "Name"';
                                                     
                          WHEN FILTER='RECENT' THEN
                                                   SQLString := SQLString || vCRLF ||  
                                                                '    AND r1.obj=p.sid' || vCRLF ||
                                                                '    AND r1.personnel=''' || user_sid ||  '''' || vCRLF ||
                                                                '    ORDER BY "Ranking" DESC';

                     WHEN FILTER='RECENT_UNIT' THEN
                                                   SQLString := SQLString || vCRLF || 
                                                                '    AND r1.obj=p.sid' || vCRLF ||
                                                                '    AND r1.unit=''' || UnitSID ||  '''' || vCRLF ||
                                                                '    ORDER BY "Ranking" DESC';

             WHEN FILTER='ALL' OR FILTER='OSI' THEN            
                                                   SQLString := SQLString || vCRLF || 
                                                                '    ORDER BY "Name"'; 
                                                                
                            WHEN FILTER='NONE' THEN            
                                                   SQLString := SQLString || vCRLF || 
                                                                '  WHERE 1=2';
 
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

         UnitSID := Osi_Personnel.get_current_unit(user_sid);
         
         --- Main Select ---
         if p_isLocator = 'Y' then
           
           SQLString := addLocatorReturnLink('s.sid', p_isLocatorMulti, p_ReturnPageItemName, p_isLocateMany);
           
         else
                  
           SQLString := 'select ''javascript:getObjURL('''''' || s.sid || '''''');'' url,';
           
         end if;
         
         SQLString := SQLString || vCRLF ||
                      '       f.id as "ID",' || vCRLF ||
                      '       st.description as "Source Type",' || vCRLF ||
                      '       Osi_Object.get_lead_agent_name(s.SID) as "Lead Agent",' || vCRLF ||
                      '       osi_unit.get_name(osi_object.get_assigned_unit(s.sid)) as "Controlling Unit",' || vCRLF ||
                      '       o.create_on as "Date Created",' || vCRLF ||
                      '       osi_object.get_status(s.sid) as "Status",' || vCRLF ||
                      '       mc.description as "Mission Area",' || vCRLF ||
                      '       f.title as "Title"';
                      
         --- Fields only Needed for Recent/Recent Unit Filters  ---
         IF FILTER IN ('RECENT','RECENT_UNIT') THEN

           SQLString := SQLString || ',' || vCRLF ||
                        '       to_char(r1.last_accessed,''dd-Mon-rrrr'') as "Last Accessed",' || vCRLF ||
                        '       to_char(r1.times_accessed,''00000'') as "Times Accessed",' || vCRLF ||
                        '       to_char(r1.times_accessed / power((sysdate-r1.last_accessed+1),2),''000000.000000'') as "Ranking"';
    
         ELSE

           SQLString := SQLString || ',' || vCRLF ||
                        '       NULL as "Last Accessed",' || vCRLF ||
                        '       NULL as "Times Accessed",' || vCRLF ||
                        '       NULL as "Ranking"';
         
         END IF;

         --- From Clause ---
         SQLString := SQLString || vCRLF ||
                      '      from T_CORE_OBJ o,' || vCRLF ||
                      '           T_OSI_FILE f,' || vCRLF ||
                      '           T_OSI_F_SOURCE s,' || vCRLF ||
                      '           T_OSI_F_SOURCE_TYPE st,' || vCRLF ||
                      '           T_OSI_MISSION_CATEGORY mc';

         --- From portion  Needed for Recent/Recent Unit Filters  ---
         IF FILTER IN ('RECENT','RECENT_UNIT') THEN
          
           SQLString := SQLString || ',' || vCRLF ||
                        '       t_osi_personnel_recent_objects r1';
        
         END IF;              

         --- Where Clause  ---
         IF FILTER NOT IN ('NONE') THEN

           SQLString := SQLString || vCRLF ||
                        '  WHERE s.SID=o.SID' || vCRLF ||
                        '    AND s.SID=f.SID' || vCRLF ||
                        '    AND s.source_type=st.sid' || vCRLF ||
                        '    AND mc.sid(+) = s.mission_area';
                        
         END IF;

         IF ACTIVE_FILTER='ACTIVE' THEN

           SQLString := SQLString || vCRLF ||
                        '    AND OSI_OBJECT.IS_OBJECT_ACTIVE(s.SID)=''Y''';
         
         ELSIF ACTIVE_FILTER IS NOT NULL AND ACTIVE_FILTER!='ALL' then

              SQLString := SQLString || vCRLF ||
                           '    AND s.source_type=' || '''' || ACTIVE_FILTER || '''';
                            
         END IF;

         --- Add the Max Row Number Check ---
         SQLString := SQLString || vCRLF ||
                      '    AND ROWNUM <=' || APXWS_MAX_ROW_CNT;

         --- Add Excludes if Needed ---
         if p_Exclude is not null then
         
           SQLString := SQLString || vCRLF ||
                        '    AND instr(' || '''' || p_Exclude || '''' || ', s.sid) = 0';
         
         end if;
                                         
         --- Add Search Filters ---
         SQLString := SQLString || AddApexSearchFilters(p_OtherSearchCriteria, column_names, p_WorksheetID, p_APP_USER, p_Instance, p_ReportName);

         --- Add Pieces to the Where Clause depending on the Filter ---
         CASE 
             
                              WHEN FILTER='ME' THEN
                                                   SQLString := SQLString || vCRLF || 
                                                                '    AND OSI_OBJECT.IS_ASSIGNED(s.sid,''' || user_sid ||  '''' || ')=''Y''' || vCRLF ||
                                                                '    ORDER BY ID'; 
             
                            WHEN FILTER='UNIT' THEN
                                                   SQLString := SQLString || vCRLF || 
                                                                '    AND osi_object.get_assigned_unit(s.sid)=''' || UnitSID || '''' || vCRLF ||
                                                                '    ORDER BY ID'; 

                        WHEN FILTER='SUB_UNIT' THEN
                                                   SQLString := SQLString || vCRLF || 
                                                                '    AND osi_object.get_assigned_unit(s.sid) in ' || Get_Subordinate_Units(UnitSID) || vCRLF ||
                                                                '    ORDER BY ID'; 
            
                        WHEN FILTER='SUP_UNIT' THEN
                                                   SQLString := SQLString || vCRLF || 
                                                                '    AND osi_object.get_assigned_unit(s.sid) IN ' || Get_Supported_Units(UnitSID) || vCRLF ||
                                                                '    ORDER BY ID'; 
                                                     
                          WHEN FILTER='RECENT' THEN
                                                   SQLString := SQLString || vCRLF ||  
                                                                '    AND r1.obj=o.sid' || vCRLF ||
                                                                '    AND r1.personnel=''' || user_sid ||  '''' || vCRLF ||
                                                                '    ORDER BY "Ranking" DESC';

                     WHEN FILTER='RECENT_UNIT' THEN
                                                   SQLString := SQLString || vCRLF || 
                                                                '    AND r1.obj=o.sid' || vCRLF ||
                                                                '    AND r1.unit=''' || UnitSID ||  '''' || vCRLF ||
                                                                '    ORDER BY "Ranking" DESC';

             WHEN FILTER='ALL' OR FILTER='OSI' THEN            
                                                   SQLString := SQLString || vCRLF || 
                                                                '    ORDER BY ID'; 
                                                                
                            WHEN FILTER='NONE' THEN            
                                                   SQLString := SQLString || vCRLF || 
                                                                '  WHERE 1=2';
 
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
            
         SQLString := SQLString || vCRLF ||
                      '                          LOCATION_NAME as "Location Name",' || vCRLF ||
                      '                          LOCATION_LONG_NAME as "Location Long Name",' || vCRLF ||
                      '                          LOCATION_CITY as "City",' || vCRLF ||
                      '                          LOCATION_STATE_COUNTRY as "State/Country Name",';

         IF FILTER IN ('RECENT','RECENT_UNIT') THEN

           SQLString := SQLString || vCRLF ||
                        '                          to_char(r1.last_accessed,''dd-Mon-rrrr'') as "Last Accessed",' || vCRLF ||
                        '                          to_char(r1.times_accessed,''00000'') as "Times Accessed",' || vCRLF ||
                        '                          to_char(r1.times_accessed / power((sysdate-r1.last_accessed+1),2),''000000.000000'') as "Ranking"';
         
         ELSE

           SQLString := SQLString || vCRLF ||
                        '                          NULL as "Last Accessed",' || vCRLF ||
                        '                          NULL as "Times Accessed",' || vCRLF ||
                        '                          NULL as "Ranking"';
         
         END IF;
                      
         --- From Clause ---
         SQLString := SQLString || vCRLF || '      from t_sapro_locations l';

         --- From portion  Needed for Recent/Recent Unit Filters  ---
         IF FILTER IN ('RECENT','RECENT_UNIT') THEN
          
           SQLString := SQLString || ',' || vCRLF ||
                        '           t_osi_personnel_recent_objects r1';
        
         END IF;              

         --- Add the Max Row Number Check ---
         SQLString := SQLString || vCRLF ||
                      ' WHERE ROWNUM <=' || APXWS_MAX_ROW_CNT;

         --- Add Excludes if Needed ---
         if p_Exclude is not null then
         
           SQLString := SQLString || vCRLF ||
                        '    and instr(' || '''' || p_Exclude || '''' || ', l.location_code) = 0';         

         end if;
         
         --- Add Search Filters ---
         SQLString := SQLString || AddApexSearchFilters(p_OtherSearchCriteria, column_names, p_WorksheetID, p_APP_USER, p_Instance, p_ReportName);

         --- Add Pieces to the Where Clause depending on the Filter ---
         CASE 
             
                            WHEN FILTER='ABC' THEN
                                                   SQLString := SQLString || vCRLF || 
                                                                '   AND REGEXP_INSTR(LOCATION_NAME,''[a|b|c][[:alpha:]]'',1,1,0,''i'') = 1' || vCRLF ||
                                                                ' ORDER BY LOCATION_NAME';
                            WHEN FILTER='DEF' THEN
                                                   SQLString := SQLString || vCRLF || 
                                                                '   AND REGEXP_INSTR(LOCATION_NAME,''[d|e|f][[:alpha:]]'',1,1,0,''i'') = 1' || vCRLF ||
                                                                ' ORDER BY LOCATION_NAME';
                            WHEN FILTER='GHI' THEN
                                                   SQLString := SQLString || vCRLF || 
                                                                '   AND REGEXP_INSTR(LOCATION_NAME,''[g|h|i][[:alpha:]]'',1,1,0,''i'') = 1' || vCRLF ||
                                                                ' ORDER BY LOCATION_NAME';
                            WHEN FILTER='JKL' THEN
                                                   SQLString := SQLString || vCRLF || 
                                                                '   AND REGEXP_INSTR(LOCATION_NAME,''[j|k|l][[:alpha:]]'',1,1,0,''i'') = 1' || vCRLF ||
                                                                ' ORDER BY LOCATION_NAME';
                            WHEN FILTER='MNO' THEN
                                                   SQLString := SQLString || vCRLF || 
                                                                '   AND REGEXP_INSTR(LOCATION_NAME,''[m|n|o][[:alpha:]]'',1,1,0,''i'') = 1' || vCRLF ||
                                                                ' ORDER BY LOCATION_NAME';
                           WHEN FILTER='PQRS' THEN
                                                   SQLString := SQLString || vCRLF || 
                                                                '   AND REGEXP_INSTR(LOCATION_NAME,''[p|q|r|s][[:alpha:]]'',1,1,0,''i'') = 1' || vCRLF ||
                                                                ' ORDER BY LOCATION_NAME';
                            WHEN FILTER='TUV' THEN
                                                   SQLString := SQLString || vCRLF || 
                                                                '   AND REGEXP_INSTR(LOCATION_NAME,''[t|u|v][[:alpha:]]'',1,1,0,''i'') = 1' || vCRLF ||
                                                                ' ORDER BY LOCATION_NAME';
                           WHEN FILTER='WXYZ' THEN
                                                   SQLString := SQLString || vCRLF || 
                                                                '   AND REGEXP_INSTR(LOCATION_NAME,''[w|x|y|z][[:alpha:]]'',1,1,0,''i'') = 1' || vCRLF ||
                                                                ' ORDER BY LOCATION_NAME';
                         WHEN FILTER='NUMERIC' THEN
                                                   SQLString := SQLString || vCRLF || 
                                                                '   AND REGEXP_INSTR(LOCATION_NAME,''[0-9]'',1,1,0,''i'') = 1' || vCRLF ||
                                                                ' ORDER BY LOCATION_NAME';

                           WHEN FILTER='ALPHA' THEN
                                                   SQLString := SQLString || vCRLF || 
                                                                '   AND REGEXP_INSTR(LOCATION_NAME,''[a-z]'',1,1,0,''i'') = 1' || vCRLF ||
                                                                ' ORDER BY LOCATION_NAME';

                          WHEN FILTER='RECENT' THEN             
                                                   SQLString := SQLString || vCRLF ||  
                                                                '   AND r1.obj=location_code' || vCRLF ||
                                                                '   AND r1.personnel=''' || user_sid ||  '''' || vCRLF ||
                                                                ' ORDER BY "Ranking" DESC';

                     WHEN FILTER='RECENT_UNIT' THEN             
                                                   SQLString := SQLString || vCRLF || 
                                                                '   AND r1.obj=location_code' || vCRLF ||
                                                                '   AND r1.unit=''' || UnitSID ||  '''' || vCRLF ||
                                                                ' ORDER BY "Ranking" DESC';
                                                    
             WHEN FILTER='ALL' OR FILTER='OSI' THEN            
                                                   SQLString := SQLString || vCRLF || 
                                                                ' ORDER BY LOCATION_NAME';
                                                                
                            WHEN FILTER='NONE' THEN            
                                                   SQLString := SQLString || vCRLF || 
                                                                '   AND 1=2';
 
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
            
         SQLString := SQLString || vCRLF ||
                      '                          tc.topic_desc as "Topic",' || vCRLF ||
                      '                          tc.subtopic_desc as "Sub Topic",';

         IF FILTER IN ('RECENT','RECENT_UNIT') THEN

           SQLString := SQLString || vCRLF ||
                        '                          to_char(r1.last_accessed,''dd-Mon-rrrr'') as "Last Accessed",' || vCRLF ||
                        '                          to_char(r1.times_accessed,''00000'') as "Times Accessed",' || vCRLF ||
                        '                          to_char(r1.times_accessed / power((sysdate-r1.last_accessed+1),2),''000000.000000'') as "Ranking"';
         
         ELSE

           SQLString := SQLString || vCRLF ||
                        '                          NULL as "Last Accessed",' || vCRLF ||
                        '                          NULL as "Times Accessed",' || vCRLF ||
                        '                          NULL as "Ranking"';
         
         END IF;
                      
         --- From Clause ---
         SQLString := SQLString || vCRLF || '      from v_osi_topic_content tc';

         --- From portion  Needed for Recent/Recent Unit Filters  ---
         IF FILTER IN ('RECENT','RECENT_UNIT') THEN
          
           SQLString := SQLString || ',' || vCRLF ||
                        '           t_osi_personnel_recent_objects r1';
        
         END IF;              

         --- Add the Max Row Number Check ---
         SQLString := SQLString || vCRLF ||
                      ' WHERE ROWNUM <=' || APXWS_MAX_ROW_CNT;

         SQLString := SQLString || vCRLF ||
                      '   and active=''Y''';
                      
         --- Add Excludes if Needed ---
         if p_Exclude is not null then
         
           SQLString := SQLString || vCRLF ||
                        '    and instr(' || '''' || p_Exclude || '''' || ', tc.sid) = 0';         

         end if;

         --- Add Search Filters ---
         SQLString := SQLString || AddApexSearchFilters(p_OtherSearchCriteria, column_names, p_WorksheetID, p_APP_USER, p_Instance, p_ReportName);

         --- Add Pieces to the Where Clause depending on the Filter ---
         CASE 

                          WHEN FILTER='RECENT' THEN             
                                                   SQLString := SQLString || vCRLF ||  
                                                                '   AND r1.obj=location_code' || vCRLF ||
                                                                '   AND r1.personnel=''' || user_sid ||  '''' || vCRLF ||
                                                                ' ORDER BY "Ranking" DESC';

                     WHEN FILTER='RECENT_UNIT' THEN             
                                                   SQLString := SQLString || vCRLF || 
                                                                '   AND r1.obj=location_code' || vCRLF ||
                                                                '   AND r1.unit=''' || UnitSID ||  '''' || vCRLF ||
                                                                ' ORDER BY "Ranking" DESC';
                                                    
             WHEN FILTER='ALL' OR FILTER='OSI' THEN            
                                                   SQLString := SQLString || vCRLF || 
                                                                ' ORDER BY tc.topic_desc,tc.subtopic_desc';
                                                                
                            WHEN FILTER='NONE' THEN            
                                                   SQLString := SQLString || vCRLF || 
                                                                '   AND 1=2';
 
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

         SQLString := SQLString || vCRLF ||
                      '                          CITY as "City",' || vCRLF ||
                      '                          STATE as "State",' || vCRLF ||
                      '                          DECODE(COUNTRY,''UNITED STATES OF AMERICA'',''USA'',COUNTRY) as "Country",' || vCRLF ||
                      '                          STATE_COUNTRY_CODE as "State/Country Code",';

         IF FILTER IN ('RECENT','RECENT_UNIT') THEN

           SQLString := SQLString || vCRLF ||
                        '                          to_char(r1.last_accessed,''dd-Mon-rrrr'') as "Last Accessed",' || vCRLF ||
                        '                          to_char(r1.times_accessed,''00000'') as "Times Accessed",' || vCRLF ||
                        '                          to_char(r1.times_accessed / power((sysdate-r1.last_accessed+1),2),''000000.000000'') as "Ranking"';
         
         ELSE

           SQLString := SQLString || vCRLF ||
                        '                          NULL as "Last Accessed",' || vCRLF ||
                        '                          NULL as "Times Accessed",' || vCRLF ||
                        '                          NULL as "Ranking"';
         
         END IF;
                      
         --- From Clause ---
         SQLString := SQLString || vCRLF || '      from t_sapro_city_state_country l';

         --- From portion  Needed for Recent/Recent Unit Filters  ---
         IF FILTER IN ('RECENT','RECENT_UNIT') THEN
          
           SQLString := SQLString || ',' || vCRLF ||
                        '           t_osi_personnel_recent_objects r1';
        
         END IF;              

         --- Add the Max Row Number Check ---
         SQLString := SQLString || vCRLF ||
                      ' WHERE ROWNUM <=' || APXWS_MAX_ROW_CNT;
         
         --- Add Excludes if Needed ---
         if p_Exclude is not null then
         
           SQLString := SQLString || vCRLF ||
                        '    and instr(' || '''' || p_Exclude || '''' || ', l.sid) = 0';         

         end if;

         --- Add Search Filters ---
         SQLString := SQLString || AddApexSearchFilters(p_OtherSearchCriteria, column_names, p_WorksheetID, p_APP_USER, p_Instance, p_ReportName);

         --- Add Pieces to the Where Clause depending on the Filter ---
         CASE 
             
                            WHEN FILTER='ABC' THEN
                                                   SQLString := SQLString || vCRLF || 
                                                                '   AND REGEXP_INSTR(CITY,''[a|b|c][[:alpha:]]'',1,1,0,''i'') = 1' || vCRLF ||
                                                                ' ORDER BY CITY,STATE';
                            WHEN FILTER='DEF' THEN
                                                   SQLString := SQLString || vCRLF || 
                                                                '   AND REGEXP_INSTR(CITY,''[d|e|f][[:alpha:]]'',1,1,0,''i'') = 1' || vCRLF ||
                                                                ' ORDER BY CITY,STATE';
                            WHEN FILTER='GHI' THEN
                                                   SQLString := SQLString || vCRLF || 
                                                                '   AND REGEXP_INSTR(CITY,''[g|h|i][[:alpha:]]'',1,1,0,''i'') = 1' || vCRLF ||
                                                                ' ORDER BY CITY,STATE';
                            WHEN FILTER='JKL' THEN
                                                   SQLString := SQLString || vCRLF || 
                                                                '   AND REGEXP_INSTR(CITY,''[j|k|l][[:alpha:]]'',1,1,0,''i'') = 1' || vCRLF ||
                                                                ' ORDER BY CITY,STATE';
                            WHEN FILTER='MNO' THEN
                                                   SQLString := SQLString || vCRLF || 
                                                                '   AND REGEXP_INSTR(CITY,''[m|n|o][[:alpha:]]'',1,1,0,''i'') = 1' || vCRLF ||
                                                                ' ORDER BY CITY,STATE';
                           WHEN FILTER='PQRS' THEN
                                                   SQLString := SQLString || vCRLF || 
                                                                '   AND REGEXP_INSTR(CITY,''[p|q|r|s][[:alpha:]]'',1,1,0,''i'') = 1' || vCRLF ||
                                                                ' ORDER BY CITY,STATE';
                            WHEN FILTER='TUV' THEN
                                                   SQLString := SQLString || vCRLF || 
                                                                '   AND REGEXP_INSTR(CITY,''[t|u|v][[:alpha:]]'',1,1,0,''i'') = 1' || vCRLF ||
                                                                ' ORDER BY CITY,STATE';
                           WHEN FILTER='WXYZ' THEN
                                                   SQLString := SQLString || vCRLF || 
                                                                '   AND REGEXP_INSTR(CITY,''[w|x|y|z][[:alpha:]]'',1,1,0,''i'') = 1' || vCRLF ||
                                                                ' ORDER BY CITY,STATE';
                         WHEN FILTER='NUMERIC' THEN
                                                   SQLString := SQLString || vCRLF || 
                                                                '   AND REGEXP_INSTR(CITY,''[0-9]'',1,1,0,''i'') = 1' || vCRLF ||
                                                                ' ORDER BY CITY,STATE';

                           WHEN FILTER='ALPHA' THEN
                                                   SQLString := SQLString || vCRLF || 
                                                                '   AND REGEXP_INSTR(CITY,''[a-z]'',1,1,0,''i'') = 1' || vCRLF ||
                                                                ' ORDER BY CITY,STATE';

                          WHEN FILTER='RECENT' THEN             
                                                   SQLString := SQLString || vCRLF ||  
                                                                '   AND r1.obj=l.sid' || vCRLF ||
                                                                '   AND r1.personnel=''' || user_sid ||  '''' || vCRLF ||
                                                                ' ORDER BY "Ranking" DESC';

                     WHEN FILTER='RECENT_UNIT' THEN             
                                                   SQLString := SQLString || vCRLF || 
                                                                '   AND r1.obj=l.sid' || vCRLF ||
                                                                '   AND r1.unit=''' || UnitSID ||  '''' || vCRLF ||
                                                                ' ORDER BY "Ranking" DESC';
                                                    
             WHEN FILTER='ALL' OR FILTER='OSI' THEN            
                                                   SQLString := SQLString || vCRLF || 
                                                                ' ORDER BY CITY,STATE';
                                                                
                            WHEN FILTER='NONE' THEN            
                                                   SQLString := SQLString || vCRLF || 
                                                                '   AND 1=2';
 
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
         SQLString := SQLString || vCRLF ||
                      '                          o.code as "Offense ID",' || vCRLF ||
                      '                          o.description as "Offense Description",' || vCRLF ||
                      '                          o.crime_against as "Crime Against",' || vCRLF ||
                      '                          c.category as "Category",';

         IF FILTER IN ('RECENT','RECENT_UNIT') THEN

           SQLString := SQLString || vCRLF ||
                        '                          to_char(r1.last_accessed,''dd-Mon-rrrr'') as "Last Accessed",' || vCRLF ||
                        '                          to_char(r1.times_accessed,''00000'') as "Times Accessed",' || vCRLF ||
                        '                          to_char(r1.times_accessed / power((sysdate-r1.last_accessed+1),2),''000000.000000'') as "Ranking"';
         
         ELSE

           SQLString := SQLString || vCRLF ||
                        '                          NULL as "Last Accessed",' || vCRLF ||
                        '                          NULL as "Times Accessed",' || vCRLF ||
                        '                          NULL as "Ranking"';
         
         END IF;
                      
         --- From Clause ---
         SQLString := SQLString || vCRLF || '      from t_dibrs_offense_type o,' || vCRLF ||
                                            '           t_osi_f_offense_category c';

         --- From portion  Needed for Recent/Recent Unit Filters  ---
         IF FILTER IN ('RECENT','RECENT_UNIT') THEN
          
           SQLString := SQLString || ',' || vCRLF ||
                        '           t_osi_personnel_recent_objects r1';
        
         END IF;              

         --- Add the Max Row Number Check ---
         SQLString := SQLString || vCRLF ||
                      ' WHERE ROWNUM <=' || APXWS_MAX_ROW_CNT;
         
         --- Add where Clause ---
         SQLString := SQLString || vCRLF ||
                      '   AND c.offense(+)=o.sid' || vCRLF || 
                      '   AND o.active = ''Y''';
         
         --- Add Excludes if Needed ---
         if p_Exclude is not null then

           SQLString := SQLString || vCRLF ||
                        '   AND instr(' || '''' || p_Exclude || '''' || ', o.sid) = 0' || vCRLF ||
                        '   AND not exists(select 1 from t_dibrs_offense_type o1 where o1.sid = o.SID and instr(' || ''''  || p_Exclude || ''''  || ', o1.sid) > 0)';
                        
         end if;
                           
         --- Add Search Filters ---
         SQLString := SQLString || AddApexSearchFilters(p_OtherSearchCriteria, column_names, p_WorksheetID, p_APP_USER, p_Instance, p_ReportName);

         --- Add Pieces to the Where Clause depending on the Filter ---
         CASE 
             WHEN FILTER IN ('Person','Property','Society') THEN                            
                 
                 SQLString := SQLString || vCRLF || 
                              '   AND o.crime_against=' || '''' || FILTER || '''' || vCRLF ||
                              ' ORDER BY O.CODE';
                            
             WHEN FILTER IN ('Base Level Economic Crimes','Central Systems Economic Crimes','Counterintelligence','Drug Crimes','General Crimes','Sex Crimes') THEN 
             
                 SQLString := SQLString || vCRLF || 
                              '   AND c.category=' || '''' || FILTER || '''' || vCRLF ||
                              ' ORDER BY O.CODE';
                                                    
             WHEN FILTER='RECENT' THEN             

                 SQLString := SQLString || vCRLF ||  
                              '   AND r1.obj=o.sid' || vCRLF ||
                              '   AND r1.personnel=''' || user_sid ||  '''' || vCRLF ||
                              ' ORDER BY "Ranking" DESC';

             WHEN FILTER='RECENT_UNIT' THEN             

                 SQLString := SQLString || vCRLF || 
                              '   AND r1.obj=o.sid' || vCRLF ||
                              '   AND r1.unit=''' || UnitSID ||  '''' || vCRLF ||
                              ' ORDER BY "Ranking" DESC';
                                                    
             WHEN FILTER IN ('ALL','All Offenses','OSI') THEN            
             
                 SQLString := SQLString || vCRLF || 
                              ' ORDER BY O.CODE';
                                                                
             WHEN FILTER='NONE' THEN            

                 SQLString := SQLString || vCRLF || 
                              '   AND 1=2';
 
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
         SQLString := 'SELECT DISTINCT ''javascript:getObjURL(''''''|| o.SID ||'''''');'' as url,' || vCRLF ||
                      '       o.sid,' || vCRLF ||
                      '       core_obj.get_tagline(o.sid) as "Title",' || vCRLF ||
                      '       ot.description as "Object Type",' || vCRLF ||
                      '       o.create_on as "Created On",' || vCRLF ||
                      '       o.create_by as "Created By",' || vCRLF ||
                      '       score(1) as "Score",' || vCRLF ||
                      '       osi_vlt.get_vlt_url(o.sid) as "VLT",' || vCRLF ||
                      '       null as "Summary"';

         --- From Clause ---
         SQLString := SQLString || vCRLF ||
                      '    from T_CORE_OBJ o,' || vCRLF ||
                      '         T_CORE_OBJ_TYPE ot';

         IF ACTIVE_FILTER IN ('INCLUDE','ONLY') THEN

           SQLString := SQLString || ',' || vCRLF ||
                        '         T_OSI_ATTACHMENT a';
                        
         END IF;

         --- Where Clause  ---
         SQLString := SQLString || vCRLF ||
                      '  WHERE o.obj_type=ot.sid';

         IF INSTR(FILTER, 'FILE') > 0 THEN

           whereClause := whereClause || vCRLF ||
                          '        ' || '''' || objTypeFILE || '''' || ' member of osi_object.get_objtypes(ot.sid) or ';
                        
         END IF;
         IF INSTR(FILTER, 'ACT') > 0 THEN

           whereClause := whereClause || vCRLF ||
                          '        ' || '''' || objTypeACT || '''' || ' member of osi_object.get_objtypes(ot.sid) or ';
                        
         END IF;
         IF INSTR(FILTER, 'PART') > 0 THEN

           whereClause := whereClause || vCRLF ||
                          '        ' || '''' || objTypePART || '''' || ' member of osi_object.get_objtypes(ot.sid) or ';
                        
         END IF;
         
         IF whereClause is not null THEN
         
           SQLString := SQLString || vCRLF ||
                        '    AND (' || substr(whereClause, 1, length(whereClause)-4) || ')';
                        
         END IF;
         
         IF ACTIVE_FILTER = 'NONE' THEN

           SQLString := SQLString || vCRLF ||
                        'and contains(o.doc1, nvl(''' || SearchCriteria || ''',''zzz''), 1)>0';
         
         ELSIF ACTIVE_FILTER = 'INCLUDE' THEN

               SQLString := SQLString || vCRLF ||
                            'and o.sid=a.obj(+)' || vCRLF ||
                            'and (contains(o.doc1, nvl(''' || SearchCriteria || ''',''zzz''), 1)>0' || vCRLF ||
                            '     or contains(a.content, nvl(''' || SearchCriteria || ''',''zzz''), 2)>0)';


         ELSIF ACTIVE_FILTER = 'ONLY' THEN

               SQLString := SQLString || vCRLF ||
                            'and o.sid=a.obj(+)' || vCRLF ||
                            'and contains(a.content, nvl(''' || SearchCriteria || ''',''zzz''), 1)>0';
                            
         END IF;
         SQLString := SQLString || vCRLF || ' order by score(1) desc';
         
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

         SQLString := SQLString || vCRLF ||
                      '       u.unit_code as "Code",' || vCRLF ||
                      '       un1.unit_name as "Name",' || vCRLF ||
                      '       un2.unit_name as "Parent"';
                      
         --- Fields only Needed for Recent/Recent Unit Filters  ---
         IF FILTER IN ('RECENT','RECENT_UNIT') THEN

           SQLString := SQLString || ',' || vCRLF ||
                        '       to_char(r1.last_accessed,''dd-Mon-rrrr'') as "Last Accessed",' || vCRLF ||
                        '       to_char(r1.times_accessed,''00000'') as "Times Accessed",' || vCRLF ||
                        '       to_char(r1.times_accessed / power((sysdate-r1.last_accessed+1),2),''000000.000000'') as "Ranking"';
         
         ELSE

           SQLString := SQLString || ',' || vCRLF ||
                        '       NULL as "Last Accessed",' || vCRLF ||
                        '       NULL as "Times Accessed",' || vCRLF ||
                        '       NULL as "Ranking"';
         
         END IF;
         
         --- From Clause ---
         SQLString := SQLString || vCRLF ||
                      '      from t_osi_unit u,' || vCRLF ||
                      '           t_osi_unit_name un1,' || vCRLF ||
                      '           t_osi_unit_name un2';

         --- From portion  Needed for Recent/Recent Unit Filters  ---
         IF FILTER IN ('RECENT','RECENT_UNIT') THEN
          
           SQLString := SQLString || ',' || vCRLF ||
                        '       t_osi_personnel_recent_objects r1';
        
         END IF;              
         
         --- Add the E-Funds Unit table if needed ---
         IF p_UnitType = 'EFUNDS' THEN
          
           SQLString := SQLString || ',' || vCRLF ||
                        '       t_cfunds_unit cu';
         END IF;
         
         --- Where Clause  ---
         IF FILTER NOT IN ('NONE') THEN

           SQLString := SQLString || vCRLF ||
                        '  WHERE (u.sid=un1.unit and un1.end_date is null)' || vCRLF ||
                        '    AND (u.unit_parent=un2.unit and un2.end_date is null)';
                        
         END IF;
                                         
         --- Add the Max Row Number Check ---
         SQLString := SQLString || vCRLF ||
                      '    AND ROWNUM <=' || APXWS_MAX_ROW_CNT;

         --- Add Excludes if Needed ---
         if p_Exclude is not null then
         
           SQLString := SQLString || vCRLF ||
                        '    and instr(' || '''' || p_Exclude || '''' || ', u.sid) = 0';         

         end if;
         
         --- Add the RPO Unit check if needed ---
         if (p_UnitType = 'RPO') then

           SQLString := SQLString || vCRLF ||
                        '    and u.sid in (select sup_unit from t_osi_unit_sup_units u,t_osi_mission_category c where u.MISSION=c.sid and c.code=''21'')';         

         end if;
         
         --- Add the E-Funds Unit check if needed ---
         IF p_UnitType = 'EFUNDS' THEN
          
           SQLString := SQLString || vCRLF ||
                        '     and cu.sid = u.sid';
                        
         END IF;
         
         --- Add Search Filters ---
         SQLString := SQLString || AddApexSearchFilters(p_OtherSearchCriteria, column_names, p_WorksheetID, p_APP_USER, p_Instance, p_ReportName);

         --- Add Pieces to the Where Clause depending on the Filter ---
         CASE 
             
                              WHEN FILTER='ME' THEN
                                                   SQLString := SQLString || vCRLF || 
                                                                '    AND u.sid=''' || UnitSID || '''' || vCRLF ||
                                                                '    ORDER BY un1.unit_name';
             
                            WHEN FILTER='UNIT' THEN
                                                   SQLString := SQLString || vCRLF || 
                                                                '    AND u.sid=''' || UnitSID || '''' || vCRLF ||
                                                                '    ORDER BY un1.unit_name';

                        WHEN FILTER='SUB_UNIT' THEN
                                                   SQLString := SQLString || vCRLF || 
                                                                '    AND u.sid in ' || Get_Subordinate_Units(UnitSID) || vCRLF ||
                                                                '    ORDER BY un1.unit_name';
                                                                            
                        WHEN FILTER='SUP_UNIT' THEN
                                                   SQLString := SQLString || vCRLF || 
                                                                '    AND u.sid IN ' || Get_Supported_Units(UnitSID) || vCRLF ||
                                                                '    ORDER BY un1.unit_name';
                                                     
                          WHEN FILTER='RECENT' THEN
                                                   SQLString := SQLString || vCRLF ||  
                                                                '    AND r1.obj=u.sid' || vCRLF ||
                                                                '    AND r1.personnel=''' || user_sid ||  '''' || vCRLF ||
                                                                '    ORDER BY "Ranking" DESC';

                     WHEN FILTER='RECENT_UNIT' THEN
                                                   SQLString := SQLString || vCRLF || 
                                                                '    AND r1.obj=u.sid' || vCRLF ||
                                                                '    AND r1.unit=''' || UnitSID ||  '''' || vCRLF ||
                                                                '    ORDER BY "Ranking" DESC';

             WHEN FILTER='ALL' OR FILTER='OSI' THEN            
                                                   SQLString := SQLString || vCRLF || 
                                                                '    ORDER BY un1.unit_name';
                                                                
                            WHEN FILTER='NONE' THEN            
                                                   SQLString := SQLString || vCRLF || 
                                                                '  WHERE 1=2';
 
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
         SQLString := 'SELECT ''javascript:getObjURL(''''''|| wh.obj ||'''''');'' as url,' || vCRLF ||
                      '       osi_personnel.get_name(wh.personnel) as "Personnel Name",' || vCRLF ||
                      '       wh.work_date as "Date",' || vCRLF ||
                      '       Core_Obj.get_parentinfo(wh.obj) as "Context",' || vCRLF ||
                      '       wh.hours as "Hours",' || vCRLF ||
                      '       ot.description as "Category Description",' || vCRLF ||
                      '       m.description as "Mission",' || vCRLF ||
                      '       osi_unit.get_name(osi_personnel.get_current_unit(wh.personnel)) as "Unit"';

         --- Fields only Needed for Recent/Recent Unit Filters  ---
         IF FILTER IN ('RECENT','RECENT_UNIT') THEN

           SQLString := SQLString || ',' || vCRLF ||
                        '       to_char(r1.last_accessed,''dd-Mon-rrrr'') as "Last Accessed",' || vCRLF ||
                        '       to_char(r1.times_accessed,''00000'') as "Times Accessed",' || vCRLF ||
                        '       to_char(r1.times_accessed / power((sysdate-r1.last_accessed+1),2),''000000.000000'') as "Ranking"';
    
         ELSE

           SQLString := SQLString || ',' || vCRLF ||
                        '       NULL as "Last Accessed",' || vCRLF ||
                        '       NULL as "Times Accessed",' || vCRLF ||
                        '       NULL as "Ranking"';
         
         END IF;
       
         --- From Clause ---
         SQLString := SQLString || vCRLF ||
                      '      from T_OSI_WORK_HOURS wh,' || vCRLF ||
                      '           T_OSI_MISSION_CATEGORY m,' || vCRLF ||
                      '           T_CORE_OBJ_TYPE ot,' || vCRLF ||
                      '           T_CORE_OBJ o';
        
         --- From portion  Needed for Recent/Recent Unit Filters  ---
         IF FILTER IN ('RECENT','RECENT_UNIT') THEN
          
           SQLString := SQLString || ',' || vCRLF ||
                        '           t_osi_personnel_recent_objects r1';
        
         END IF;              
                      
         --- Where Clause  ---
         IF FILTER NOT IN ('NONE') THEN

           SQLString := SQLString || vCRLF ||
                        '  WHERE wh.obj=o.sid' || vCRLF ||
                        '    AND wh.mission=m.sid(+)' || vCRLF ||
                        '    AND ot.sid=o.obj_type';
                        
         END IF;

         --- Add the Max Row Number Check ---
         SQLString := SQLString || vCRLF ||
                      '    AND ROWNUM <=' || APXWS_MAX_ROW_CNT;

         --- Add Search Filters ---
         SQLString := SQLString || AddApexSearchFilters(p_OtherSearchCriteria, column_names, p_WorksheetID, p_APP_USER, p_Instance, p_ReportName);

         --- Add Pieces to the Where Clause depending on the Filter ---
         CASE 
             
                              WHEN FILTER='ME' THEN
                                                   SQLString := SQLString ||  vCRLF ||
                                                                '    AND wh.personnel=''' || user_sid || '''' || vCRLF ||
                                                                '    ORDER BY PERSONNEL';
             
                            WHEN FILTER='UNIT' THEN
                                                   SQLString := SQLString || vCRLF || 
                                                                '    AND osi_personnel.get_current_unit(wh.personnel)=''' || UnitSID ||  '''' || vCRLF ||
                                                                '    ORDER BY "Personnel Name"';

                        WHEN FILTER='SUB_UNIT' THEN
                                                   SQLString := SQLString || vCRLF || 
                                                                '    AND osi_personnel.get_current_unit(wh.personnel) in ' || Get_Subordinate_Units(UnitSID) || vCRLF ||
                                                                '    ORDER BY "Personnel Name"';
            
                        WHEN FILTER='SUP_UNIT' THEN
                                                   SQLString := SQLString || vCRLF || 
                                                                '    AND osi_personnel.get_current_unit(wh.personnel) IN ' || Get_Supported_Units(UnitSID) || vCRLF ||
                                                                '    ORDER BY "Personnel Name"';
                                                     
                          WHEN FILTER='RECENT' THEN
                                                   SQLString := SQLString || vCRLF || 
                                                                '    AND r1.obj=o.sid' || vCRLF ||
                                                                '    AND r1.personnel=''' || user_sid ||  '''' || vCRLF ||
                                                                '    ORDER BY "Ranking" DESC';

                     WHEN FILTER='RECENT_UNIT' THEN
                                                   SQLString := SQLString || vCRLF || 
                                                                '    AND r1.obj=o.sid' || vCRLF ||
                                                                '    AND r1.unit=''' || UnitSID ||  '''' || vCRLF ||
                                                                '    ORDER BY "Ranking" DESC';

             WHEN FILTER='ALL' OR FILTER='OSI' THEN            
                                                   SQLString := SQLString || vCRLF || 
                                                                '    ORDER BY "Personnel Name"';
                                                   
                            WHEN FILTER='NONE' THEN            
                                                   SQLString := SQLString || vCRLF || 
                                                                '  WHERE 1=2';
                                                                                                               
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
                               'NOTIFICATIONS','PERSONNEL','SOURCES','SOURCE','UNITS','UNITS_EFUNDS','WORKHOURS') THEN

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

                 SQLString := DesktopPersonnelSQL(NewFilter, user_sid, p_ReturnPageItemName, NewActiveFilter, p_ObjType, p_OtherSearchCriteria, v_max_num_rows, p_WorksheetID, p_APP_USER, p_Instance, p_ReportName, p_isLocator, p_isLocatorMulti, p_Exclude, p_isLocateMany);
             
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
         
         ---log_error('<<<OSI_DESKTOP.DesktopSQL --Returned--> ' || SQLString);
         
         RETURN SQLString;
         
    END DesktopSQL;
    
END Osi_Desktop;
/






CREATE OR REPLACE VIEW V_OSI_GI_INVOLVEMENT_PART
(SID, GI, PARTICIPANT_VERSION, RE_INTERVIEW, COMMENTS, 
 INTERVIEW_DATE, DD2701, INTERVIEW_ADDR, ADDRESS_1, ADDRESS_2, 
 CITY, PROVINCE, STATE, POSTAL_CODE, COUNTRY, 
 GEO_COORDS)
AS 
select gii.sid, gii.gi, gii.participant_version, gii.re_interview, 
           gii.comments, gii.interview_date, gii.dd2701,
           osi_address.get_addr_fields(gii.interview_addr) as interview_addr,
           a.address_1, a.address_2, a.city, a.province, a.state, 
           a.postal_code, a.country, a.geo_coords
      from T_OSI_A_GI_INVOLVEMENT gii, T_OSI_ADDRESS a
     where gii.interview_addr = a.sid(+)
/


CREATE OR REPLACE TRIGGER "OSI_GIINVOLV_PART_IO_IUD_01" 
    instead of insert or update or delete
    ON V_OSI_GI_INVOLVEMENT_PART     for each row
declare
   v_new_sid   varchar2(20);
   v_addr_sid  varchar2(20);
begin 
  if inserting then
    insert into t_osi_a_gi_involvement(gi,participant_version,re_interview,comments,interview_date,dd2701)
           values(:new.gi,
                  :new.participant_version,
                  :new.re_interview,
                  :new.comments,
                  :new.interview_date,
                  :new.dd2701)
    returning sid
         into v_new_sid;           

    --insert interview address
    insert into t_osi_address
                        (obj,
                         address_type,
                         address_1,
                         address_2,
                         city,
                         province,
                         state,
                         postal_code,
                         country,
                         geo_coords)
                 values (:new.gi,
                         osi_address.GET_ADDR_TYPE(core_obj.lookup_objtype('ACT.INTERVIEW.GROUP'), 
                                                                            'PART_LOCATION', 'PART_LOC'),
                         :new.address_1,
                         :new.address_2,
                         :new.city,
                         :new.province,
                         :new.state,
                         :new.postal_code,
                         :new.country,
                         :new.geo_coords)
              returning sid
                   into v_addr_sid;

    update t_osi_a_gi_involvement set interview_addr = v_addr_sid where sid = v_new_sid;
  
  elsif updating then

     begin
         select interview_addr
           into v_addr_sid
           from t_osi_a_gi_involvement
          where sid =  :new.sid;
     exception
          when NO_DATA_FOUND then
               v_addr_sid := null;
     end;

     update t_osi_a_gi_involvement
           set participant_version = :new.participant_version,
               re_interview = :new.re_interview,
               comments = :new.comments,
               interview_date = :new.interview_date,
               dd2701 = :new.dd2701
         where SID = :new.SID
           and (   nvl(participant_version, 'x') <> nvl(:new.participant_version, 'x')
                or nvl(re_interview, 'x') <> nvl(:new.re_interview, 'x')
                or nvl(comments, 'x') <> nvl(:new.comments, 'x')
                or nvl(interview_date, sysdate) <> nvl(:new.interview_date, sysdate)
                or nvl(dd2701, 'x') <> nvl(:new.dd2701, 'x')
                );

        --update (or insert) interview address
        if v_addr_sid is null then
            --insert interview address
            insert into t_osi_address
                    (obj,
                     address_type,
                     address_1,
                     address_2,
                     city,
                     province,
                     state,
                     postal_code,
                     country,
                     geo_coords)
             values (:new.gi,
                     osi_address.GET_ADDR_TYPE(core_obj.lookup_objtype('ACT.INTERVIEW.GROUP'), 
                                                                        'PART_LOCATION', 'PART_LOC'),
                     :new.address_1,
                     :new.address_2,
                     :new.city,
                     :new.province,
                     :new.state,
                     :new.postal_code,
                     :new.country,
                     :new.geo_coords)
               returning sid
               into v_addr_sid;

             update t_osi_a_gi_involvement set interview_addr = v_addr_sid where sid = :new.sid;
        else
             update t_osi_address 
                set address_1 = :new.address_1,
                    address_2 = :new.address_2,
                    city = :new.city,
                    province = :new.province,
                    state = :new.state,
                    postal_code = :new.postal_code,
                    country = :new.country,
                    geo_coords = :new.geo_coords
              where sid = v_addr_sid
                and (    nvl(address_1, 'x') <> nvl(:new.address_1, 'x')
                      or nvl(address_2, 'x') <> nvl(:new.address_2, 'x')
                      or nvl(city, 'x') <> nvl(:new.city, 'x')
                      or nvl(province, 'x') <> nvl(:new.province, 'x')
                      or nvl(state, 'x') <> nvl(:new.state, 'x')
                      or nvl(postal_code, 'x') <> nvl(:new.postal_code, 'x')
                      or nvl(country, 'x') <> nvl(:new.country, 'x')
                      or nvl(geo_coords, 'x') <> nvl(:new.geo_coords, 'x')
                     );
        end if;
  else --must be deleting

       begin
         select interview_addr
           into v_addr_sid
           from t_osi_a_gi_involvement
          where sid =  :old.sid;
       exception
          when NO_DATA_FOUND then
               v_addr_sid := null;
       end;

       delete from t_osi_address where sid = v_addr_sid;
       -- > will cascade delete the t_osi_a_gi_involvement record
       -- > delete from t_osi_a_gi_involvement where sid = :old.sid;
  end if;

  core_obj.bump(:new.SID);
end;
/
