-- "Set define off" turns off substitution variables. 
Set define off; 

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
         SQLString := 'SELECT ''javascript:getObjURL(''''''|| e.SID ||'''''');'' AS url,' || vCRLF ||
                      '       to_char(e.incurred_date,''dd-Mon-rrrr'') AS "Date Incurred",' || vCRLF ||
                      '       e.claimant_name AS "Claimant",' || vCRLF ||
                      '       ''<div class="tooltip" tip="Activity: '' || to_clob(htf.escape_sc(osi_activity.get_id(e.parent)) || '' - '' || core_obj.get_tagline(e.parent)) || ''">'' || substr(''Activity: '' || osi_activity.get_id(e.parent) || '' - '' || core_obj.get_tagline(e.parent),1,25) || case when length(''Activity: '' || osi_activity.get_id(e.parent) || '' - '' || core_obj.get_tagline(e.parent)) > 25 then ''...'' end || ''</div>'' AS "Context",' || vCRLF ||
                      '       TO_CHAR(e.total_amount_us, ''FML999G999G999G990D00'') AS "Total Amount",' || vCRLF ||
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
                                                                '    ORDER BY RANKING DESC';

                     WHEN FILTER='RECENT_UNIT' THEN
                                                   SQLString := SQLString || vCRLF || 
                                                                '    AND r1.obj=o.sid' || vCRLF ||
                                                                '    AND r1.unit=''' || UnitSID ||  '''' || vCRLF ||
                                                                '    ORDER BY RANKING DESC';

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
         SQLString := 'SELECT ''javascript:getObjURL(''''''|| a.SID ||'''''');'' AS url,' || vCRLF ||
                      '       to_char(a.request_date,''dd-Mon-rrrr'') AS "Date Requested",' || vCRLF ||
                      '       to_char(a.issue_on+90,''dd-Mon-rrrr'') AS "Suspense Date",' || vCRLF ||
                      '       osi_personnel.get_name(a.claimant) AS "Claimant",' || vCRLF ||
                      '       ''<div class="tooltip" tip="'' || htf.escape_sc(substr(a.narrative,1,3000)) || ''">'' || substr(a.narrative,1,25) || case when length(a.narrative) > 25 then ''...'' end || ''</div>'' AS "Description",' || vCRLF ||
                      '       TO_CHAR(a.amount_requested, ''FML999G999G999G990D00'') AS "Amount Requested",' || vCRLF ||
                      '       cfunds_pkg.get_advance_status(a.submitted_on,a.approved_on,a.rejected_on,a.issue_on,a.close_date) as "Status",' || vCRLF ||
                      '       osi_unit.get_name(a.unit) as "Charge To Unit",' || vCRLF ||
                      '       osi_unit.get_name(osi_personnel.get_current_unit(a.claimant)) as "Claimants Unit"';

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
                      '  FROM t_cfunds_advance_v2 a,' || vCRLF ||
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
                                                                '    ORDER BY RANKING DESC';

                     WHEN FILTER='RECENT_UNIT' THEN
                                                   SQLString := SQLString || vCRLF || 
                                                                '    AND r1.obj=o.sid' || vCRLF ||
                                                                '    AND r1.unit=''' || UnitSID ||  '''' || vCRLF ||
                                                                '    ORDER BY RANKING DESC';

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
         SQLString := 'SELECT ''javascript:getObjURL(''''''|| e.parent ||'''''');'' AS url,' || vCRLF ||
                      '       et.description AS "Event",' || vCRLF ||
                      '       to_char(n.generation_date,''dd-Mon-rrrr'') AS "Event Date",' || vCRLF ||
                      '       ''<div class="tooltip" tip="'' || htf.escape_sc(substr(Core_Obj.get_tagline(e.PARENT),1,3000)) || ''">'' || substr(Core_Obj.get_tagline(e.PARENT),1,25) || case when length(Core_Obj.get_tagline(e.PARENT)) > 25 then ''...'' end || ''</div>'' AS "Context",' || vCRLF ||
                      --'       Core_Obj.get_tagline(e.PARENT) AS "Context",' || vCRLF ||
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
         SQLString := 'SELECT ''javascript:newWindow({page:30700,clear_cache:''''30700'''',name:''''EMM'' || u.sid || '''''',item_names:''''P0_OBJ'''',item_values:'''''' || u.sid || '''''',request:''''OPEN''''});'' AS url,' || vCRLF ||
                      '       ''Evidence Management Module for: '' || osi_unit.get_name(u.sid) as "Module Name"';

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
                      '  FROM T_OSI_UNIT u,' || vCRLF ||
                      '       T_CORE_OBJ o';
        
         --- From portion  Needed for Recent/Recent Unit Filters  ---
         IF FILTER IN ('RECENT','RECENT_UNIT') THEN
          
           SQLString := SQLString || ',' || vCRLF ||
                        '       t_osi_personnel_recent_objects r1';
        
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
                                                                '    ORDER BY RANKING DESC';

                     WHEN FILTER='RECENT_UNIT' THEN
                                                   SQLString := SQLString || vCRLF || 
                                                                '    AND r1.obj=o.sid' || vCRLF ||
                                                                '    AND r1.unit=''' || UnitSID ||  '''' || vCRLF ||
                                                                '    ORDER BY RANKING DESC';

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
    FUNCTION DesktopActivitiesSQL(FILTER IN VARCHAR2, user_sid IN VARCHAR2, ACTIVE_FILTER IN VARCHAR2, p_OtherSearchCriteria IN VARCHAR2 := '', APXWS_MAX_ROW_CNT IN NUMBER := 10000, p_WorksheetID IN VARCHAR2 := NULL, p_APP_USER IN VARCHAR2 := NULL, p_Instance IN VARCHAR2 := NULL, p_ReportName IN VARCHAR2 := '') RETURN VARCHAR2 IS

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
         
         log_error('>>>OSI_DESKTOP.DesktopActivitiesSQL(' || FILTER || ',' || user_sid || ',' || ACTIVE_FILTER || ',' || p_OtherSearchCriteria || ',' || APXWS_MAX_ROW_CNT || ',' || p_WorksheetID || ',' || p_APP_USER || ',' || p_Instance || ',' || p_ReportName || ')');
         UnitSID := Osi_Personnel.get_current_unit(user_sid);
         
         --- Main Select ---
         SQLString := 'SELECT  a.url,' || vCRLF ||
                      '       a.ID ,' || vCRLF ||
                      '       a.Activity_Type as "Activity Type",' || vCRLF ||
                      '       a.title AS "Title",' || vCRLF ||
                      '       a.Lead_Agent AS "Lead Agent",' || vCRLF ||
                      '       a.Status AS "Status",' || vCRLF ||
                      '       a.Controlling_Unit as "Controlling Unit",' || vCRLF ||
                      '       a.Created_On AS "Created On",';

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
                      '       a.VLT AS VLT,';

         --- Fields not Shown by Default ---
         SQLString := SQLString || vCRLF ||
                      '       a.created_by AS "Created By",' || vCRLF ||
                      '       a.Is_Lead as "Is a Lead",' || vCRLF ||
                      '       a.Date_Completed as "Date Completed",' || vCRLF ||
                      '       a.Suspense_Date as  "Suspense Date"';
       
         --- From Clause ---
         SQLString := SQLString || vCRLF ||
                      '  FROM t_osi_activity_lookup a' ;

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
                                                                '    ORDER BY RANKING DESC';

                     WHEN FILTER='RECENT_UNIT' THEN
                                                   SQLString := SQLString || vCRLF || 
                                                                '    AND r1.obj=a.sid' || vCRLF ||
                                                                '    AND r1.unit=''' || UnitSID ||  '''' || vCRLF ||
                                                                '    ORDER BY RANKING DESC';

             WHEN FILTER='ALL' OR FILTER='OSI' THEN            
                                                   SQLString := SQLString || vCRLF || 
                                                                '    ORDER BY a.activity_type';                                                                
                            WHEN FILTER='NONE' THEN            
                                                   SQLString := SQLString || vCRLF || 
                                                                '  WHERE 1=2';
 
         END CASE;
         
         log_error('<<<OSI_DESKTOP.DesktopActivitiesSQL(' || FILTER || ',' || user_sid || ',' || ACTIVE_FILTER || ',' || p_OtherSearchCriteria || ',' || APXWS_MAX_ROW_CNT || ',' || p_WorksheetID || ',' || p_APP_USER || ',' || p_Instance || ',' || p_ReportName || ')');
         RETURN SQLString;
         
    END DesktopActivitiesSQL;
    
    /******************/ 
    /*  Files Section */   
    /******************/ 
    FUNCTION DesktopFilesSQL(FILTER IN VARCHAR2, user_sid IN VARCHAR2, ACTIVE_FILTER IN VARCHAR2, p_ObjType IN VARCHAR2, p_OtherSearchCriteria IN VARCHAR2 := '', APXWS_MAX_ROW_CNT IN NUMBER := 10000, p_WorksheetID IN VARCHAR2 := NULL, p_APP_USER IN VARCHAR2 := NULL, p_Instance IN VARCHAR2 := NULL, p_ReportName IN VARCHAR2 := '') RETURN VARCHAR2 IS

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
         SQLString := 'select ''javascript:getObjURL('''''' || f.sid || '''''');'' url,' || vCRLF ||
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
                        '       to_char(r1.times_accessed / power((sysdate-r1.last_accessed+1),2),''000000.000000'') as Ranking,';
         
         ELSE

           SQLString := SQLString || vCRLF ||
                        '       NULL as "Last Accessed",' || vCRLF ||
                        '       NULL as "Times Accessed",' || vCRLF ||
                        '       NULL as Ranking,';
         
         END IF;
         
         --- Add VLT Link ---
         SQLString := SQLString || vCRLF ||
                      '       ''javascript:newWindow({page:5550,clear_cache:''''5550'''',name:''''VLT''||f.sid||'''''',item_names:''''P0_OBJ'''',item_values:''||''''||''''''''||f.sid||''''''''||''''||'',request:''''OPEN''''})'' AS VLT,';

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
                      '  FROM T_OSI_FILE f,' || vCRLF ||
                      '       T_CORE_OBJ_TYPE ot,' || vCRLF ||
                      '       T_CORE_OBJ o';

         IF FILTER IN ('UNIT','SUB_UNIT','SUP_UNIT') THEN
                           
           SQLString := SQLString || vCRLF || 
                        '    ,T_OSI_F_UNIT fu';

         END IF;

         --- Tables For Investigative Files Only ---
         IF p_ObjType in ('FILE.INV','FILE.INV.CASE','FILE.INV.DEV','FILE.INV.INFO') THEN

           SQLString := SQLString || ',' || vCRLF ||
                      '       T_OSI_MISSION_CATEGORY mc,' || vCRLF ||
                      '       T_OSI_F_INVESTIGATION i';
         
         END IF;

         --- Tables For Agent Applicant Files Only ---
         IF p_ObjType IN ('FILE.AAPP') THEN

           SQLString := SQLString || ',' || vCRLF ||
                        '       v_osi_f_aapp_file aapp';
         
         END IF;

         --- Tables For POLY Files Only ---
         IF p_ObjType IN ('FILE.POLY_FILE.SEC', 'FILE.POLY_FILE.CRIM') THEN

           SQLString := SQLString || ',' || vCRLF ||
                        '       t_osi_f_poly_file csp';
         
         END IF;
                      
         --- From portion  Needed for Recent/Recent Unit Filters  ---
         IF FILTER IN ('RECENT','RECENT_UNIT') THEN
          
           SQLString := SQLString || ',' || vCRLF ||
                        '       t_osi_personnel_recent_objects r1';
        
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
                              '    ORDER BY RANKING DESC';

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
    FUNCTION DesktopParticipantSQL(FILTER IN VARCHAR2, user_sid IN VARCHAR2, ACTIVE_FILTER IN VARCHAR2, p_ObjType IN VARCHAR2, p_OtherSearchCriteria IN VARCHAR2 := '', APXWS_MAX_ROW_CNT IN NUMBER := 10000, p_WorksheetID IN VARCHAR2 := NULL, p_APP_USER IN VARCHAR2 := NULL, p_Instance IN VARCHAR2 := NULL, p_ReportName IN VARCHAR2 := '') RETURN VARCHAR2 IS

      SQLString VARCHAR2(32000);
      UnitSID VARCHAR2(20);
      
      column_names assoc_arr;
      
    BEGIN
         log_error('>>>OSI_DESKTOP.DesktopParticipantSQL(' || FILTER || ',' || user_sid || ',' || ACTIVE_FILTER || ',' || p_ObjType || ',' || p_OtherSearchCriteria || ',' || APXWS_MAX_ROW_CNT || ',' || p_WorksheetID || ',' || p_APP_USER || ',' || p_Instance || ')');
         UnitSID := Osi_Personnel.get_current_unit(user_sid);

         --- Main Select ---
         SQLString := 'select ''javascript:getObjURL('''''' || o.sid || '''''');'' url,';

         CASE
             --WHEN p_ObjType in ('PARTICIPANT') then
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
                              '       osi_participant.get_type(o.sid) as "Type2",' || vCRLF ||
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

             --WHEN p_ObjType in ('PART.INDIV') then
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
                              '       NULL as "Type2",' || vCRLF ||
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

             --WHEN p_ObjType in ('PART.NONINDIV.COMP') then
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
                              '       NULL as "Type",' || vCRLF ||
                              '       osi_participant.get_subtype(o.sid) as "Type2",' || vCRLF ||
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

             ---WHEN p_ObjType in ('PART.NONINDIV.ORG') then
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
                              '       NULL as "Type",' || vCRLF ||
                              '       osi_participant.get_subtype(o.sid) as "Type2",' || vCRLF ||
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

             ---WHEN p_ObjType in ('PART.NONINDIV.PROG') then
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
                        '       to_char(r1.times_accessed / power((sysdate-r1.last_accessed+1),2),''000000.000000'') as Ranking,';
         
         ELSE

           SQLString := SQLString || ',' || vCRLF ||
                        '       NULL as "Last Accessed",' || vCRLF ||
                        '       NULL as "Times Accessed",' || vCRLF ||
                        '       NULL as Ranking,';
         
         END IF;

         --- Add SSN ---
         ---IF p_ObjType in ('PART.INDIV') THEN
         IF ACTIVE_FILTER in ('PART.INDIV') THEN

           column_names('C034'):='osi_participant.get_number(pv.sid, ''SSN'')';
           SQLString := SQLString || vCRLF ||
             '       osi_participant.get_number(pv.sid, ''SSN'') AS "Social Security Number",';

         ELSE

           SQLString := SQLString || vCRLF ||
             '       NULL AS "Social Security Number",';

         END IF;         
         
         --- Add VLT Link ---
         SQLString := SQLString || vCRLF ||
                      '       ''javascript:newWindow({page:5550,clear_cache:''''5550'''',name:''''VLT''||p.sid||'''''',item_names:''''P0_OBJ'''',item_values:''||''''||''''''''||p.sid||''''''''||''''||'',request:''''OPEN''''})'' AS VLT';

         --- From Clause ---
         SQLString := SQLString || vCRLF ||
                      '  FROM T_CORE_OBJ o,' || vCRLF ||
                      '       T_CORE_OBJ_TYPE ot,' || vCRLF ||
                      '       T_OSI_PARTICIPANT p,' || vCRLF ||
                      '       T_OSI_PARTIC_NAME pn,' || vCRLF ||
                      '       T_OSI_PARTICIPANT_VERSION pv,' || vCRLF ||
                      '       T_OSI_PARTICIPANT_HUMAN ph,' || vCRLF ||
                      '       T_OSI_PARTICIPANT_NONHUMAN pnh,' || vCRLF ||
                      '       T_OSI_PERSON_CHARS pc,' || vCRLF ||
                      '       T_DIBRS_PAY_GRADE_TYPE pg';

         --- From portion  Needed for Recent/Recent Unit Filters  ---
         IF FILTER IN ('RECENT','RECENT_UNIT') THEN
          
           SQLString := SQLString || ',' || vCRLF ||
                        '       t_osi_personnel_recent_objects r1';
        
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
                              '    ORDER BY RANKING DESC';

             WHEN FILTER='NONE' THEN            

                 NULL;           

             ELSE
               
               CASE
                   WHEN p_ObjType='PARTICIPANT' THEN

                       SQLString := SQLString || vCRLF || 
                                    '    ORDER BY "Type2","Name"';
                                    
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
    FUNCTION DesktopPersonnelSQL(FILTER IN VARCHAR2, user_sid IN VARCHAR2, ACTIVE_FILTER IN VARCHAR2, p_OtherSearchCriteria IN VARCHAR2 := '', APXWS_MAX_ROW_CNT IN NUMBER := 10000, p_WorksheetID IN VARCHAR2 := NULL, p_APP_USER IN VARCHAR2 := NULL, p_Instance IN VARCHAR2 := NULL, p_ReportName IN VARCHAR2 := '') RETURN VARCHAR2 IS

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
         SQLString := 'SELECT ''javascript:getObjURL(''''''|| p.SID ||'''''');'' AS url,' || vCRLF ||
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
                        '       to_char(r1.times_accessed / power((sysdate-r1.last_accessed+1),2),''000000.000000'') as Ranking';--,';
         
         ELSE

           SQLString := SQLString || ',' || vCRLF ||
                        '       NULL as "Last Accessed",' || vCRLF ||
                        '       NULL as "Times Accessed",' || vCRLF ||
                        '       NULL as Ranking';--,';
         
         END IF;
         
         --- From Clause ---
         SQLString := SQLString || vCRLF ||
                      '  FROM t_core_personnel p,' || vCRLF ||
                      '       t_osi_personnel op,' || vCRLF ||
                      '       t_osi_person_chars c,' || vCRLF ||
                      '       t_dibrs_reference sex';

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
                                                                '    ORDER BY RANKING DESC';

                     WHEN FILTER='RECENT_UNIT' THEN
                                                   SQLString := SQLString || vCRLF || 
                                                                '    AND r1.obj=p.sid' || vCRLF ||
                                                                '    AND r1.unit=''' || UnitSID ||  '''' || vCRLF ||
                                                                '    ORDER BY RANKING DESC';

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
    FUNCTION DesktopSourcesSQL(FILTER IN VARCHAR2, user_sid IN VARCHAR2, ACTIVE_FILTER IN VARCHAR2, p_OtherSearchCriteria IN VARCHAR2 := '', APXWS_MAX_ROW_CNT IN NUMBER := 10000, p_WorksheetID IN VARCHAR2 := NULL, p_APP_USER IN VARCHAR2 := NULL, p_Instance IN VARCHAR2 := NULL, p_ReportName IN VARCHAR2 := '') RETURN VARCHAR2 IS

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
         SQLString := 'SELECT ''javascript:getObjURL(''''''|| s.SID ||'''''');'' AS url,' || vCRLF ||
                      '       f.id as "ID",' || vCRLF ||
                      '       st.description as "Source Type",' || vCRLF ||
                      '       Osi_Object.get_lead_agent_name(s.SID) AS "Lead Agent",' || vCRLF ||
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
                        '       to_char(r1.times_accessed / power((sysdate-r1.last_accessed+1),2),''000000.000000'') as Ranking';
    
         ELSE

           SQLString := SQLString || ',' || vCRLF ||
                        '       NULL as "Last Accessed",' || vCRLF ||
                        '       NULL as "Times Accessed",' || vCRLF ||
                        '       NULL as Ranking';
         
         END IF;

         --- From Clause ---
         SQLString := SQLString || vCRLF ||
                      '  FROM T_CORE_OBJ o,' || vCRLF ||
                      '       T_OSI_FILE f,' || vCRLF ||
                      '       T_OSI_F_SOURCE s,' || vCRLF ||
                      '       T_OSI_F_SOURCE_TYPE st,' || vCRLF ||
                      '       T_OSI_MISSION_CATEGORY mc';

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
                                                                '    ORDER BY RANKING DESC';

                     WHEN FILTER='RECENT_UNIT' THEN
                                                   SQLString := SQLString || vCRLF || 
                                                                '    AND r1.obj=o.sid' || vCRLF ||
                                                                '    AND r1.unit=''' || UnitSID ||  '''' || vCRLF ||
                                                                '    ORDER BY RANKING DESC';

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
    FUNCTION DesktopMilitaryLocationsSQL(FILTER IN VARCHAR2, user_sid IN VARCHAR2, p_ReturnPageItemName IN VARCHAR2:='', ACTIVE_FILTER IN VARCHAR2, p_OtherSearchCriteria IN VARCHAR2 := '', APXWS_MAX_ROW_CNT IN NUMBER := 10000, p_WorksheetID IN VARCHAR2 := NULL, p_APP_USER IN VARCHAR2 := NULL, p_Instance IN VARCHAR2 := NULL, p_ReportName IN VARCHAR2 := '') RETURN VARCHAR2 IS

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

         --- Add the Max Row Number Check ---
         SQLString := SQLString || vCRLF ||
                      ' WHERE ROWNUM <=' || APXWS_MAX_ROW_CNT;
         
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
                                                                ' ORDER BY RANKING DESC';

                     WHEN FILTER='RECENT_UNIT' THEN             
                                                   SQLString := SQLString || vCRLF || 
                                                                '   AND r1.obj=location_code' || vCRLF ||
                                                                '   AND r1.unit=''' || UnitSID ||  '''' || vCRLF ||
                                                                ' ORDER BY RANKING DESC';
                                                    
             WHEN FILTER='ALL' OR FILTER='OSI' THEN            
                                                   SQLString := SQLString || vCRLF || 
                                                                ' ORDER BY LOCATION_NAME';
                                                                
                            WHEN FILTER='NONE' THEN            
                                                   SQLString := SQLString || vCRLF || 
                                                                '   AND 1=2';
 
         END CASE;

         RETURN SQLString;
         
    END DesktopMilitaryLocationsSQL;

    /********************************/ 
    /*  City, State/Country Section */   
    /********************************/ 
    FUNCTION DesktopCityStateCountrySQL(FILTER IN VARCHAR2, user_sid IN VARCHAR2, p_ReturnPageItemName IN VARCHAR2:='', ACTIVE_FILTER IN VARCHAR2, p_OtherSearchCriteria IN VARCHAR2 := '', APXWS_MAX_ROW_CNT IN NUMBER := 10000, p_WorksheetID IN VARCHAR2 := NULL, p_APP_USER IN VARCHAR2 := NULL, p_Instance IN VARCHAR2 := NULL, p_ReportName IN VARCHAR2 := '') RETURN VARCHAR2 IS

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

         --- Add the Max Row Number Check ---
         SQLString := SQLString || vCRLF ||
                      ' WHERE ROWNUM <=' || APXWS_MAX_ROW_CNT;
         
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
                                                                ' ORDER BY RANKING DESC';

                     WHEN FILTER='RECENT_UNIT' THEN             
                                                   SQLString := SQLString || vCRLF || 
                                                                '   AND r1.obj=l.sid' || vCRLF ||
                                                                '   AND r1.unit=''' || UnitSID ||  '''' || vCRLF ||
                                                                ' ORDER BY RANKING DESC';
                                                    
             WHEN FILTER='ALL' OR FILTER='OSI' THEN            
                                                   SQLString := SQLString || vCRLF || 
                                                                ' ORDER BY CITY,STATE';
                                                                
                            WHEN FILTER='NONE' THEN            
                                                   SQLString := SQLString || vCRLF || 
                                                                '   AND 1=2';
 
         END CASE;

         RETURN SQLString;
         
    END DesktopCityStateCountrySQL;

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
         SQLString := 'SELECT DISTINCT ''javascript:getObjURL(''''''|| o.SID ||'''''');'' AS url,' || vCRLF ||
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
                      '  FROM T_CORE_OBJ o,' || vCRLF ||
                      '       T_CORE_OBJ_TYPE ot';

         IF ACTIVE_FILTER IN ('INCLUDE','ONLY') THEN

           SQLString := SQLString || ',' || vCRLF ||
                        '       T_OSI_ATTACHMENT a';
                        
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
    FUNCTION DesktopUnitSQL(FILTER IN VARCHAR2, user_sid IN VARCHAR2, ACTIVE_FILTER IN VARCHAR2, p_OtherSearchCriteria IN VARCHAR2 := '', APXWS_MAX_ROW_CNT IN NUMBER := 10000, p_WorksheetID IN VARCHAR2 := NULL, p_APP_USER IN VARCHAR2 := NULL, p_Instance IN VARCHAR2 := NULL, p_ReportName IN VARCHAR2 := '') RETURN VARCHAR2 IS

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
         SQLString := 'SELECT ''javascript:getObjURL(''''''|| u.SID ||'''''');'' AS url,' || vCRLF ||
                      '       u.unit_code as "Code",' || vCRLF ||
                      '       un1.unit_name as "Name",' || vCRLF ||
                      '       un2.unit_name as "Parent"';
                      
         --- Fields only Needed for Recent/Recent Unit Filters  ---
         IF FILTER IN ('RECENT','RECENT_UNIT') THEN

           SQLString := SQLString || ',' || vCRLF ||
                        '       to_char(r1.last_accessed,''dd-Mon-rrrr'') as "Last Accessed",' || vCRLF ||
                        '       to_char(r1.times_accessed,''00000'') as "Times Accessed",' || vCRLF ||
                        '       to_char(r1.times_accessed / power((sysdate-r1.last_accessed+1),2),''000000.000000'') as Ranking';--,';
         
         ELSE

           SQLString := SQLString || ',' || vCRLF ||
                        '       NULL as "Last Accessed",' || vCRLF ||
                        '       NULL as "Times Accessed",' || vCRLF ||
                        '       NULL as Ranking';--,';
         
         END IF;
         
         --- From Clause ---
         SQLString := SQLString || vCRLF ||
                      '  FROM t_osi_unit u,' || vCRLF ||
                      '       t_osi_unit_name un1,' || vCRLF ||
                      '       t_osi_unit_name un2';

         --- From portion  Needed for Recent/Recent Unit Filters  ---
         IF FILTER IN ('RECENT','RECENT_UNIT') THEN
          
           SQLString := SQLString || ',' || vCRLF ||
                        '       t_osi_personnel_recent_objects r1';
        
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
                                                                '    ORDER BY RANKING DESC';

                     WHEN FILTER='RECENT_UNIT' THEN
                                                   SQLString := SQLString || vCRLF || 
                                                                '    AND r1.obj=u.sid' || vCRLF ||
                                                                '    AND r1.unit=''' || UnitSID ||  '''' || vCRLF ||
                                                                '    ORDER BY RANKING DESC';

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
         SQLString := 'SELECT ''javascript:getObjURL(''''''|| wh.obj ||'''''');'' AS url,' || vCRLF ||
                      '       osi_personnel.get_name(wh.personnel) AS "Personnel Name",' || vCRLF ||
                      '       wh.work_date AS "Date",' || vCRLF ||
                      '       Core_Obj.get_parentinfo(wh.obj) AS "Context",' || vCRLF ||
                      '       wh.hours AS "Hours",' || vCRLF ||
                      '       ot.description AS "Category Description",' || vCRLF ||
                      '       m.description AS "Mission",' || vCRLF ||
                      '       osi_unit.get_name(osi_personnel.get_current_unit(wh.personnel)) AS "Unit"';

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
                      '  FROM T_OSI_WORK_HOURS wh,' || vCRLF ||
                      '       T_OSI_MISSION_CATEGORY m,' || vCRLF ||
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
                                                                '    ORDER BY RANKING DESC';

                     WHEN FILTER='RECENT_UNIT' THEN
                                                   SQLString := SQLString || vCRLF || 
                                                                '    AND r1.obj=o.sid' || vCRLF ||
                                                                '    AND r1.unit=''' || UnitSID ||  '''' || vCRLF ||
                                                                '    ORDER BY RANKING DESC';

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
    
   FUNCTION DesktopSQL(FILTER IN VARCHAR2, user_sid IN VARCHAR2, p_ObjType IN VARCHAR2, p_ReturnPageItemName IN VARCHAR2:='', ACTIVE_FILTER IN VARCHAR2 := 'ACTIVE', NUM_ROWS IN NUMBER := 15, PAGE_ID IN VARCHAR2 := 'P', p_OtherSearchCriteria IN VARCHAR2 := '', APXWS_MAX_ROW_CNT IN VARCHAR2 := '10000', p_WorksheetID IN VARCHAR2 := NULL, p_APP_USER IN VARCHAR2 := NULL, p_Instance IN VARCHAR2 := NULL, p_ReportName IN VARCHAR2 := '') RETURN VARCHAR2 IS

      SQLString VARCHAR2(32000);
      NewFilter VARCHAR2(32000);
      NewActiveFilter VARCHAR2(32000);
      v_temp VARCHAR2(32000);
      v_max_num_rows number;
      
    BEGIN
         log_error('>>>OSI_DESKTOP.DesktopSQL(' || FILTER || ',' || user_sid || ',' || p_ObjType || ',' || p_ReturnPageItemName || ',' || ACTIVE_FILTER || ',' || NUM_ROWS || ',' || PAGE_ID || ',' || p_OtherSearchCriteria || ',' || APXWS_MAX_ROW_CNT || ',' || p_WorksheetID || ',' || p_APP_USER || ',' || p_Instance  || ',' || p_ReportName || ')');
         
         v_max_num_rows := to_number(nvl(APXWS_MAX_ROW_CNT,'10000'));

         NewFilter := FILTER;
         NewActiveFilter := ACTIVE_FILTER;
         IF p_ObjType NOT IN ('FULLTEXTSEARCH') THEN

           IF p_ObjType NOT IN ('MILITARY_LOCS','CITY_STATE_COUNTRY','PARTICIPANT','PART.INDIV','PART.NONINDIV.COMP','PART.NONINDIV.ORG','PART.NONINDIV.PROG') THEN

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
        
                 SQLString := DesktopActivitiesSQL(NewFilter, user_sid, NewActiveFilter, p_OtherSearchCriteria, v_max_num_rows, p_WorksheetID, p_APP_USER, p_Instance, p_ReportName);

             WHEN p_ObjType IN ('FILE', 'FILE.INV', 'FILE.INV.CASE', 'FILE.INV.DEV', 'FILE.INV.INFO',
                                'FILE.SERVICE','FILE.AAPP','FILE.GEN.ANP','FILE.PSO','FILE.POLY_FILE.SEC',
                                'FILE.SUPPORT','FILE.GEN.SRCDEV', 'FILE.GEN.UNDRCVROPSUPP', 'FILE.GEN.TECHSURV', 'FILE.POLY_FILE.CRIM', 'FILE.GEN.TARGETMGMT') THEN
        
                 SQLString := DesktopFilesSQL(NewFilter, user_sid, NewActiveFilter, p_ObjType, p_OtherSearchCriteria, v_max_num_rows, p_WorksheetID, p_APP_USER, p_Instance, p_ReportName);

             WHEN p_ObjType IN ('PARTICIPANT','PART.INDIV','PART.NONINDIV.COMP','PART.NONINDIV.ORG','PART.NONINDIV.PROG') THEN
        
                 SQLString := DesktopParticipantSQL(NewFilter, user_sid, NewActiveFilter, p_ObjType, p_OtherSearchCriteria, v_max_num_rows, p_WorksheetID, p_APP_USER, p_Instance, p_ReportName);
             
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
             
             WHEN p_ObjType='PERSONNEL' THEN

                 SQLString := DesktopPersonnelSQL(NewFilter, user_sid, NewActiveFilter, p_OtherSearchCriteria, v_max_num_rows, p_WorksheetID, p_APP_USER, p_Instance, p_ReportName);
             
             WHEN p_ObjType='SOURCES' THEN
        
                 SQLString := DesktopSourcesSQL(NewFilter, user_sid, NewActiveFilter, p_OtherSearchCriteria, v_max_num_rows, p_WorksheetID, p_APP_USER, p_Instance, p_ReportName);

             WHEN p_ObjType='MILITARY_LOCS' THEN
                              
                 SQLString := DesktopMilitaryLocationsSQL(NewFilter, user_sid, p_ReturnPageItemName, NewActiveFilter, p_OtherSearchCriteria, v_max_num_rows, p_WorksheetID, p_APP_USER, p_Instance, p_ReportName);
             
             WHEN p_ObjType='CITY_STATE_COUNTRY' THEN

                 SQLString := DesktopCityStateCountrySQL(NewFilter, user_sid, p_ReturnPageItemName, NewActiveFilter, p_OtherSearchCriteria, v_max_num_rows, p_WorksheetID, p_APP_USER, p_Instance, p_ReportName);

             WHEN p_ObjType='UNITS' THEN

                 SQLString := DesktopUnitSQL(NewFilter, user_sid, NewActiveFilter, p_OtherSearchCriteria, v_max_num_rows, p_WorksheetID, p_APP_USER, p_Instance, p_ReportName);

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



set define off
set verify off
set serveroutput on size 1000000
set feedback off
WHENEVER SQLERROR EXIT SQL.SQLCODE ROLLBACK
begin wwv_flow.g_import_in_progress := true; end; 
/
 
 
--application/set_environment
prompt  APPLICATION 100 - Web-I2MS
--
-- Application Export:
--   Application:     100
--   Name:            Web-I2MS
--   Date and Time:   07:23 Wednesday April 4, 2012
--   Exported By:     TWARD
--   Flashback:       0
--   Export Type:     Page Export
--   Version: 3.2.0.00.27
 
-- Import:
--   Using application builder
--   or
--   Using SQL*Plus as the Oracle user APEX_030200 or as the owner (parsing schema) of the application.
 
 
--       AAAA       PPPPP   EEEEEE  XX      XX
--      AA  AA      PP  PP  EE       XX    XX
--     AA    AA     PP  PP  EE        XX  XX
--    AAAAAAAAAA    PPPPP   EEEE       XXXX
--   AA        AA   PP      EE        XX  XX
--  AA          AA  PP      EE       XX    XX
--  AA          AA  PP      EEEEEE  XX      XX
prompt  Set Credentials...
 
begin
 
  -- Assumes you are running the script connected to SQL*Plus as the Oracle user APEX_030200 or as the owner (parsing schema) of the application.
  wwv_flow_api.set_security_group_id(p_security_group_id=>apex_util.find_security_group_id(user));
 
end;
/

begin wwv_flow.g_import_in_progress := true; end;
/
begin 

select value into wwv_flow_api.g_nls_numeric_chars from nls_session_parameters where parameter='NLS_NUMERIC_CHARACTERS';

end;

/
begin execute immediate 'alter session set nls_numeric_characters=''.,''';

end;

/
begin wwv_flow.g_browser_language := 'en-us'; end;
/
prompt  Check Compatibility...
 
begin
 
-- This date identifies the minimum version required to import this file.
wwv_flow_api.set_version(p_version_yyyy_mm_dd=>'2009.01.12');
 
end;
/

prompt  Set Application ID...
 
begin
 
   -- SET APPLICATION ID
   wwv_flow.g_flow_id := 100;
   wwv_flow_api.g_id_offset := 0;
null;
 
end;
/

PROMPT ...Remove page 1110
 
begin
 
wwv_flow_api.remove_page (p_flow_id=>wwv_flow.g_flow_id, p_page_id=>1110);
 
end;
/

 
--application/pages/page_01110
prompt  ...PAGE 1110: Desktop Investigative Files
--
 
begin
 
declare
    h varchar2(32767) := null;
    ph varchar2(32767) := null;
begin
h := null;
ph:=ph||'"JS_DESKTOP_FILTERS_COL_REF"'||chr(10)||
'"JS_DESKTOP_GOTO_FIRST_PAGE"';

wwv_flow_api.create_page(
  p_id     => 1110,
  p_flow_id=> wwv_flow.g_flow_id,
  p_tab_set=> '',
  p_name   => 'Desktop Investigative Files',
  p_step_title=> '&DESKTOP_TITLE.',
  p_step_sub_title_type => 'TEXT_WITH_SUBSTITUTIONS',
  p_first_item=> 'AUTO_FIRST_ITEM',
  p_include_apex_css_js_yn=>'Y',
  p_autocomplete_on_off => 'ON',
  p_group_id => 92115409285163743+ wwv_flow_api.g_id_offset,
  p_help_text => '',
  p_html_page_header => ' ',
  p_step_template => 92011431286949262+ wwv_flow_api.g_id_offset,
  p_required_patch=> null + wwv_flow_api.g_id_offset,
  p_last_updated_by => 'TWARD',
  p_last_upd_yyyymmddhh24miss => '20120404072300',
  p_page_is_public_y_n=> 'N',
  p_protection_level=> 'N',
  p_page_comment  => '13-DEC-2010 J.Faris WCHG0000264 - DT view query updates for performance.'||chr(10)||
''||chr(10)||
'06-Jan-2012 - Tim Ward - CR#3738 - All/Active Filter missing.  '||chr(10)||
'                         CR#3728 - Save Filter and rows values.'||chr(10)||
'                         CR#3742 - Save Filter and rows values.'||chr(10)||
'                         CR#3641 - Default Sort Order for Recent.'||chr(10)||
'                         CR#3635 - Last Accessed inconsistencies.'||chr(10)||
'                         CR#3563 - Default Desktop Views.'||chr(10)||
'                         CR#3446 - Implement speed improvements.'||chr(10)||
'                         CR#3447 - Implement speed improvements.'||chr(10)||
''||chr(10)||
'04-Apr-2012 - Tim Ward - CR#3738 - Added Primary Offense Back into Columns.  '||chr(10)||
'');
 
wwv_flow_api.set_html_page_header(p_flow_id=>wwv_flow.g_flow_id,p_flow_step_id=>1110,p_text=>ph);
end;
 
end;
/

declare
  s varchar2(32767) := null;
  l_clob clob;
  l_length number := 1;
begin
s:=s||'You do not have access privileges for this folder.';

wwv_flow_api.create_page_plug (
  p_id=> 6185223542280320 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_page_id=> 1110,
  p_plug_name=> 'Access Restricted',
  p_region_name=>'',
  p_plug_template=> 179216655889554481+ wwv_flow_api.g_id_offset,
  p_plug_display_sequence=> 30,
  p_plug_display_column=> 1,
  p_plug_display_point=> 'AFTER_SHOW_ITEMS',
  p_plug_source=> s,
  p_plug_source_type=> 'STATIC_TEXT',
  p_translate_title=> 'Y',
  p_plug_display_error_message=> '#SQLERRM#',
  p_plug_query_row_template=> 1,
  p_plug_query_headings_type=> 'QUERY_COLUMNS',
  p_plug_query_num_rows_type => 'NEXT_PREVIOUS_LINKS',
  p_plug_query_row_count_max => 500,
  p_plug_query_show_nulls_as => ' - ',
  p_plug_display_condition_type => 'PLSQL_EXPRESSION',
  p_plug_display_when_condition => 'osi_auth.check_for_priv(''DESKTOP'',core_obj.lookup_objtype(''FILE.INV.CASE''))=''N'' or'||chr(10)||
'osi_auth.check_for_priv(''DESKTOP'',core_obj.lookup_objtype(''FILE.INV.DEV''))=''N'' or'||chr(10)||
'osi_auth.check_for_priv(''DESKTOP'',core_obj.lookup_objtype(''FILE.INV.INFO''))=''N''',
  p_pagination_display_position=>'BOTTOM_RIGHT',
  p_plug_customized=>'0',
  p_plug_caching=> 'NOT_CACHED',
  p_plug_comment=> '');
end;
/
declare
  s varchar2(32767) := null;
  l_clob clob;
  l_length number := 1;
begin
s:=s||'SELECT C001,C002,C003,C004,to_date(C005),C006,C007,to_date(C008),C009,C010,C011,C012,to_date(C013),to_date(C014),to_number(C015),C016,C017,to_date(C018),C019'||chr(10)||
'FROM APEX_COLLECTIONS '||chr(10)||
'WHERE COLLECTION_NAME=''P'' || :APP_PAGE_ID || ''_CURRENT_FILTER'';'||chr(10)||
'';

wwv_flow_api.create_page_plug (
  p_id=> 99822325742591398 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_page_id=> 1110,
  p_plug_name=> '&P1110_TITLE.',
  p_region_name=>'',
  p_plug_template=> 92167138176750921+ wwv_flow_api.g_id_offset,
  p_plug_display_sequence=> 20,
  p_plug_display_column=> 1,
  p_plug_display_point=> 'AFTER_SHOW_ITEMS',
  p_plug_source=> s,
  p_plug_source_type=> 'DYNAMIC_QUERY',
  p_translate_title=> 'Y',
  p_plug_display_error_message=> '#SQLERRM#',
  p_plug_query_row_template=> 1,
  p_plug_query_headings_type=> 'COLON_DELMITED_LIST',
  p_plug_query_row_count_max => 500,
  p_plug_query_show_nulls_as => ' - ',
  p_plug_display_condition_type => 'PLSQL_EXPRESSION',
  p_plug_display_when_condition => 'not '||chr(10)||
'('||chr(10)||
' (:P1110_FILE_TYPE=''FILE.INV'' and '||chr(10)||
'  (osi_auth.check_for_priv(''DESKTOP'',core_obj.lookup_objtype(''FILE.INV.CASE''))=''N'' '||chr(10)||
'   or osi_auth.check_for_priv(''DESKTOP'',core_obj.lookup_objtype(''FILE.INV.DEV''))=''N'' '||chr(10)||
'   or osi_auth.check_for_priv(''DESKTOP'',core_obj.lookup_objtype(''FILE.INV.INFO''))=''N'''||chr(10)||
'  ) '||chr(10)||
' )'||chr(10)||
' or osi_auth.check_for_priv(''DESKTOP'',core_obj.lookup_objtype(:P1110_FILE_TYPE))=''N'''||chr(10)||
')',
  p_pagination_display_position=>'BOTTOM_RIGHT',
  p_plug_customized=>'0',
  p_plug_caching=> 'NOT_CACHED',
  p_plug_comment=> 'select ''javascript:getObjURL('''''' || f.sid || '''''');'' url,'||chr(10)||
'       f.id as "ID",'||chr(10)||
'       ot.description as "File Type",'||chr(10)||
'       f.title as "Title",'||chr(10)||
'       decode(osi_object.get_lead_agent(f.sid),'||chr(10)||
'              null, ''NO LEAD AGENT'','||chr(10)||
'              osi_personnel.get_name(osi_object.get_lead_agent(f.sid))) as "Lead Agent",'||chr(10)||
'       osi_object.get_status(f.sid) as "Status",'||chr(10)||
'       osi_unit.get_name('||chr(10)||
'             osi_file.get_unit_owner(f.sid)) as "Controlling Unit",'||chr(10)||
'       osi_status.last_sh_date(f.sid, ''OP'') "Date Opened",'||chr(10)||
'       osi_status.last_sh_date(f.sid, ''CL'') "Date Closed",'||chr(10)||
'       osi_file.get_days_since_opened(f.sid) "Days Since Opened",'||chr(10)||
'       mc.description as "Mission Area",'||chr(10)||
'       osi_investigation.get_final_roi_date(f.sid) as "ROI",'||chr(10)||
'       o.create_on as "Created On",'||chr(10)||
'       o.create_by as "Created By",'||chr(10)||
'       o.times_accessed as "Times Accessed",'||chr(10)||
'       o.last_accessed as "Last Accessed",'||chr(10)||
'       osi_vlt.get_vlt_url(o.sid) as "VLT",'||chr(10)||
'       (select dot.code || '' '' || dot.description'||chr(10)||
'          from t_osi_f_inv_offense io,'||chr(10)||
'               t_dibrs_offense_type dot,'||chr(10)||
'               t_osi_reference r'||chr(10)||
'         where io.investigation = f.sid'||chr(10)||
'           and io.priority = r.sid'||chr(10)||
'           and r.usage = ''OFFENSE_PRIORITY'''||chr(10)||
'           and r.code = ''P'''||chr(10)||
'           and io.offense = dot.sid'||chr(10)||
'           ) as primary_offense'||chr(10)||
'  from t_osi_file f,'||chr(10)||
'       (select   o1.sid, '||chr(10)||
'                 o1.obj_type,'||chr(10)||
'                 o1.create_by, '||chr(10)||
'                 o1.create_on, '||chr(10)||
'                 sum(r1.times_accessed) times_accessed,'||chr(10)||
'                 max(r1.last_accessed) last_accessed'||chr(10)||
'            from t_core_obj o1, t_osi_personnel_recent_objects r1, t_osi_file f2'||chr(10)||
'           where r1.obj(+) = o1.sid'||chr(10)||
'             and o1.sid = f2.sid'||chr(10)||
'             and (   (    :p1110_filter = ''RECENT'''||chr(10)||
'                      and r1.personnel = :user_sid)'||chr(10)||
'                  or (    :p1110_filter = ''RECENT_UNIT'''||chr(10)||
'                      and r1.unit = osi_personnel.get_current_unit(:user_sid))'||chr(10)||
'                  or (    :p1110_filter = ''NONE'' '||chr(10)||
'                          and 1 = 2)'||chr(10)||
'                  or (:p1110_filter in (''ALL'', ''OSI''))'||chr(10)||
'                  or (    :p1110_filter = ''ME'' '||chr(10)||
'                      and osi_object.is_assigned(o1.sid)=''Y'')'||chr(10)||
'                  or (    :p1110_filter = ''UNIT'''||chr(10)||
'                      and osi_object.get_assigned_unit(o1.sid) ='||chr(10)||
'                          osi_personnel.get_current_unit(:user_sid))'||chr(10)||
'                  or (    :p1110_filter = ''SUB_UNIT'''||chr(10)||
'                      and osi_unit.is_subordinate('||chr(10)||
'                          osi_personnel.get_current_unit(:user_sid),'||chr(10)||
'                          osi_object.get_assigned_unit(o1.sid))=''Y'')'||chr(10)||
'                  or (    :p1110_filter = ''SUP_UNIT'''||chr(10)||
'                      and osi_object.get_assigned_unit(o1.sid) in'||chr(10)||
'                         (select unit'||chr(10)||
'                            from t_osi_unit_sup_units'||chr(10)||
'                           where sup_unit = '||chr(10)||
'                                 osi_personnel.get_current_unit(:user_sid)'||chr(10)||
'                          )))'||chr(10)||
'        group by o1.sid, o1.obj_type, o1.create_by, o1.create_on) o,'||chr(10)||
'       t_osi_mission_category mc,'||chr(10)||
'       t_osi_f_investigation i,'||chr(10)||
'       t_core_obj_type ot'||chr(10)||
' where f.sid = o.sid'||chr(10)||
'   and ot.sid = o.obj_type'||chr(10)||
'   and f.sid = i.sid'||chr(10)||
'   and mc.sid(+) = i.manage_by'||chr(10)||
'   and ot.code=:P1110_FILE_TYPE');
end;
/
declare
 a1 varchar2(32767) := null;
begin
a1:=a1||'SELECT C001,C002,C003,C004,to_date(C005),C006,C007,to_date(C008),C009,C010,C011,C012,to_date(C013),to_date(C014),to_number(C015),C016,C017,to_date(C018),C019'||chr(10)||
'FROM APEX_COLLECTIONS '||chr(10)||
'WHERE COLLECTION_NAME=''P'' || :APP_PAGE_ID || ''_CURRENT_FILTER'';'||chr(10)||
'';

wwv_flow_api.create_worksheet(
  p_id => 99822516313591406+wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_page_id => 1110,
  p_region_id => 99822325742591398+wwv_flow_api.g_id_offset,
  p_name => 'Activities',
  p_folder_id => null, 
  p_alias => '',
  p_report_id_item => '',
  p_max_row_count => '10000',
  p_max_row_count_message => 'This query returns more then 10,000 rows, please filter your data to ensure complete results.',
  p_no_data_found_message => 'No &P1110_TITLE. found.',
  p_max_rows_per_page    => '',
  p_search_button_label  => '',
  p_page_items_to_submit => 'P1110_FILTER',
  p_sort_asc_image       => '',
  p_sort_asc_image_attr  => '',
  p_sort_desc_image      => '',
  p_sort_desc_image_attr => '',
  p_sql_query => a1,
  p_status                    =>'AVAILABLE_FOR_OWNER',
  p_allow_report_saving       =>'Y',
  p_allow_report_categories   =>'N',
  p_show_nulls_as             =>'-',
  p_pagination_type           =>'ROWS_X_TO_Y_OF_Z',
  p_pagination_display_pos    =>'BOTTOM_RIGHT',
  p_show_finder_drop_down     =>'Y',
  p_show_display_row_count    =>'Y',
  p_show_search_bar           =>'Y',
  p_show_search_textbox       =>'Y',
  p_show_actions_menu         =>'Y',
  p_report_list_mode          =>'TABS',
  p_show_detail_link          =>'C',
  p_show_select_columns       =>'Y',
  p_show_filter               =>'Y',
  p_show_sort                 =>'Y',
  p_show_control_break        =>'Y',
  p_show_highlight            =>'Y',
  p_show_computation          =>'N',
  p_show_aggregate            =>'N',
  p_show_chart                =>'N',
  p_show_calendar             =>'N',
  p_show_flashback            =>'N',
  p_show_reset                =>'N',
  p_show_download             =>'Y',
  p_show_help            =>'Y',
  p_download_formats          =>'CSV',
  p_download_filename         =>'&P1110_EXPORT_NAME.',
  p_detail_link              =>'#C001#',
  p_detail_link_text         =>'<img src="#IMAGE_PREFIX#ws/small_page.gif" alt="" />',
  p_allow_exclude_null_values =>'N',
  p_allow_hide_extra_columns  =>'N',
  p_owner                     =>'THOMAS');
end;
/
begin
wwv_flow_api.create_worksheet_column(
  p_id => 9015321615986784+wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_page_id=> null,
  p_worksheet_id => 99822516313591406+wwv_flow_api.g_id_offset,
  p_db_column_name         =>'C001',
  p_display_order          =>1,
  p_group_id               =>null+wwv_flow_api.g_id_offset,
  p_column_identifier      =>'A',
  p_column_label           =>'&nbsp;',
  p_report_label           =>'&nbsp;',
  p_sync_form_label        =>'Y',
  p_display_in_default_rpt =>'Y',
  p_is_sortable            =>'Y',
  p_allow_sorting          =>'Y',
  p_allow_filtering        =>'Y',
  p_allow_ctrl_breaks      =>'Y',
  p_allow_aggregations     =>'Y',
  p_allow_computations     =>'Y',
  p_allow_charting         =>'Y',
  p_others_may_edit        =>'Y',
  p_others_may_view        =>'Y',
  p_column_type            =>'STRING',
  p_display_as             =>'TEXT',
  p_display_text_as        =>'HIDDEN',
  p_heading_alignment      =>'CENTER',
  p_column_alignment       =>'LEFT',
  p_rpt_distinct_lov       =>'Y',
  p_rpt_show_filter_lov    =>'D',
  p_rpt_filter_date_ranges =>'ALL',
  p_help_text              =>'');
end;
/
begin
wwv_flow_api.create_worksheet_column(
  p_id => 9015407840986784+wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_page_id=> null,
  p_worksheet_id => 99822516313591406+wwv_flow_api.g_id_offset,
  p_db_column_name         =>'C002',
  p_display_order          =>2,
  p_group_id               =>null+wwv_flow_api.g_id_offset,
  p_column_identifier      =>'B',
  p_column_label           =>'ID',
  p_report_label           =>'ID',
  p_sync_form_label        =>'Y',
  p_display_in_default_rpt =>'Y',
  p_is_sortable            =>'Y',
  p_allow_sorting          =>'Y',
  p_allow_filtering        =>'Y',
  p_allow_ctrl_breaks      =>'Y',
  p_allow_aggregations     =>'Y',
  p_allow_computations     =>'Y',
  p_allow_charting         =>'Y',
  p_others_may_edit        =>'Y',
  p_others_may_view        =>'Y',
  p_column_type            =>'STRING',
  p_display_as             =>'TEXT',
  p_display_text_as        =>'ESCAPE_SC',
  p_heading_alignment      =>'CENTER',
  p_column_alignment       =>'LEFT',
  p_rpt_distinct_lov       =>'Y',
  p_rpt_show_filter_lov    =>'D',
  p_rpt_filter_date_ranges =>'ALL',
  p_help_text              =>'');
end;
/
begin
wwv_flow_api.create_worksheet_column(
  p_id => 9015503650986784+wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_page_id=> null,
  p_worksheet_id => 99822516313591406+wwv_flow_api.g_id_offset,
  p_db_column_name         =>'C003',
  p_display_order          =>3,
  p_group_id               =>null+wwv_flow_api.g_id_offset,
  p_column_identifier      =>'C',
  p_column_label           =>'Type',
  p_report_label           =>'Type',
  p_sync_form_label        =>'Y',
  p_display_in_default_rpt =>'Y',
  p_is_sortable            =>'Y',
  p_allow_sorting          =>'Y',
  p_allow_filtering        =>'Y',
  p_allow_ctrl_breaks      =>'Y',
  p_allow_aggregations     =>'Y',
  p_allow_computations     =>'Y',
  p_allow_charting         =>'Y',
  p_others_may_edit        =>'Y',
  p_others_may_view        =>'Y',
  p_column_type            =>'STRING',
  p_display_as             =>'TEXT',
  p_display_text_as        =>'ESCAPE_SC',
  p_heading_alignment      =>'CENTER',
  p_column_alignment       =>'LEFT',
  p_rpt_distinct_lov       =>'Y',
  p_rpt_show_filter_lov    =>'D',
  p_rpt_filter_date_ranges =>'ALL',
  p_help_text              =>'');
end;
/
begin
wwv_flow_api.create_worksheet_column(
  p_id => 9015604729986784+wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_page_id=> null,
  p_worksheet_id => 99822516313591406+wwv_flow_api.g_id_offset,
  p_db_column_name         =>'C004',
  p_display_order          =>4,
  p_group_id               =>null+wwv_flow_api.g_id_offset,
  p_column_identifier      =>'D',
  p_column_label           =>'Title',
  p_report_label           =>'Title',
  p_sync_form_label        =>'Y',
  p_display_in_default_rpt =>'Y',
  p_is_sortable            =>'Y',
  p_allow_sorting          =>'Y',
  p_allow_filtering        =>'Y',
  p_allow_ctrl_breaks      =>'Y',
  p_allow_aggregations     =>'Y',
  p_allow_computations     =>'Y',
  p_allow_charting         =>'Y',
  p_others_may_edit        =>'Y',
  p_others_may_view        =>'Y',
  p_column_type            =>'STRING',
  p_display_as             =>'TEXT',
  p_display_text_as        =>'ESCAPE_SC',
  p_heading_alignment      =>'CENTER',
  p_column_alignment       =>'LEFT',
  p_rpt_distinct_lov       =>'Y',
  p_rpt_show_filter_lov    =>'D',
  p_rpt_filter_date_ranges =>'ALL',
  p_help_text              =>'');
end;
/
begin
wwv_flow_api.create_worksheet_column(
  p_id => 9015702917986786+wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_page_id=> null,
  p_worksheet_id => 99822516313591406+wwv_flow_api.g_id_offset,
  p_db_column_name         =>'TO_DATE(C005)',
  p_display_order          =>5,
  p_group_id               =>null+wwv_flow_api.g_id_offset,
  p_column_identifier      =>'E',
  p_column_label           =>'Date Created',
  p_report_label           =>'Date Created',
  p_sync_form_label        =>'Y',
  p_display_in_default_rpt =>'Y',
  p_is_sortable            =>'Y',
  p_allow_sorting          =>'Y',
  p_allow_filtering        =>'Y',
  p_allow_ctrl_breaks      =>'Y',
  p_allow_aggregations     =>'Y',
  p_allow_computations     =>'Y',
  p_allow_charting         =>'Y',
  p_others_may_edit        =>'Y',
  p_others_may_view        =>'Y',
  p_column_type            =>'DATE',
  p_display_as             =>'TEXT',
  p_display_text_as        =>'ESCAPE_SC',
  p_heading_alignment      =>'CENTER',
  p_column_alignment       =>'LEFT',
  p_format_mask            =>'dd-Mon-rrrr',
  p_rpt_distinct_lov       =>'Y',
  p_rpt_show_filter_lov    =>'D',
  p_rpt_filter_date_ranges =>'ALL',
  p_help_text              =>'');
end;
/
begin
wwv_flow_api.create_worksheet_column(
  p_id => 9015829048986786+wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_page_id=> null,
  p_worksheet_id => 99822516313591406+wwv_flow_api.g_id_offset,
  p_db_column_name         =>'C006',
  p_display_order          =>6,
  p_group_id               =>null+wwv_flow_api.g_id_offset,
  p_column_identifier      =>'F',
  p_column_label           =>'Status',
  p_report_label           =>'Status',
  p_sync_form_label        =>'Y',
  p_display_in_default_rpt =>'Y',
  p_is_sortable            =>'Y',
  p_allow_sorting          =>'Y',
  p_allow_filtering        =>'Y',
  p_allow_ctrl_breaks      =>'Y',
  p_allow_aggregations     =>'Y',
  p_allow_computations     =>'Y',
  p_allow_charting         =>'Y',
  p_others_may_edit        =>'Y',
  p_others_may_view        =>'Y',
  p_column_type            =>'STRING',
  p_display_as             =>'TEXT',
  p_display_text_as        =>'ESCAPE_SC',
  p_heading_alignment      =>'CENTER',
  p_column_alignment       =>'LEFT',
  p_rpt_distinct_lov       =>'Y',
  p_rpt_show_filter_lov    =>'D',
  p_rpt_filter_date_ranges =>'ALL',
  p_help_text              =>'');
end;
/
begin
wwv_flow_api.create_worksheet_column(
  p_id => 9015924587986786+wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_page_id=> null,
  p_worksheet_id => 99822516313591406+wwv_flow_api.g_id_offset,
  p_db_column_name         =>'C007',
  p_display_order          =>7,
  p_group_id               =>null+wwv_flow_api.g_id_offset,
  p_column_identifier      =>'G',
  p_column_label           =>'Controlling Unit',
  p_report_label           =>'Controlling Unit',
  p_sync_form_label        =>'Y',
  p_display_in_default_rpt =>'Y',
  p_is_sortable            =>'Y',
  p_allow_sorting          =>'Y',
  p_allow_filtering        =>'Y',
  p_allow_ctrl_breaks      =>'Y',
  p_allow_aggregations     =>'Y',
  p_allow_computations     =>'Y',
  p_allow_charting         =>'Y',
  p_others_may_edit        =>'Y',
  p_others_may_view        =>'Y',
  p_column_type            =>'STRING',
  p_display_as             =>'TEXT',
  p_display_text_as        =>'ESCAPE_SC',
  p_heading_alignment      =>'CENTER',
  p_column_alignment       =>'LEFT',
  p_rpt_distinct_lov       =>'Y',
  p_rpt_show_filter_lov    =>'D',
  p_rpt_filter_date_ranges =>'ALL',
  p_help_text              =>'');
end;
/
begin
wwv_flow_api.create_worksheet_column(
  p_id => 9016005180986786+wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_page_id=> null,
  p_worksheet_id => 99822516313591406+wwv_flow_api.g_id_offset,
  p_db_column_name         =>'TO_DATE(C008)',
  p_display_order          =>8,
  p_group_id               =>null+wwv_flow_api.g_id_offset,
  p_column_identifier      =>'H',
  p_column_label           =>'Last Accessed',
  p_report_label           =>'Last Accessed',
  p_sync_form_label        =>'Y',
  p_display_in_default_rpt =>'Y',
  p_is_sortable            =>'Y',
  p_allow_sorting          =>'Y',
  p_allow_filtering        =>'Y',
  p_allow_ctrl_breaks      =>'Y',
  p_allow_aggregations     =>'Y',
  p_allow_computations     =>'Y',
  p_allow_charting         =>'Y',
  p_others_may_edit        =>'Y',
  p_others_may_view        =>'Y',
  p_column_type            =>'DATE',
  p_display_as             =>'TEXT',
  p_display_text_as        =>'ESCAPE_SC',
  p_heading_alignment      =>'CENTER',
  p_column_alignment       =>'LEFT',
  p_format_mask            =>'dd-Mon-rrrr',
  p_rpt_distinct_lov       =>'Y',
  p_rpt_show_filter_lov    =>'D',
  p_rpt_filter_date_ranges =>'ALL',
  p_display_condition_type =>'EXISTS',
  p_display_condition      =>'SELECT 1 FROM APEX_COLLECTIONS WHERE TO_DATE(C008) IS NOT NULL AND COLLECTION_NAME=''P1110_CURRENT_FILTER''',
  p_help_text              =>'');
end;
/
begin
wwv_flow_api.create_worksheet_column(
  p_id => 9016121578986786+wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_page_id=> null,
  p_worksheet_id => 99822516313591406+wwv_flow_api.g_id_offset,
  p_db_column_name         =>'C009',
  p_display_order          =>9,
  p_group_id               =>null+wwv_flow_api.g_id_offset,
  p_column_identifier      =>'I',
  p_column_label           =>'Times Accessed',
  p_report_label           =>'Times Accessed',
  p_sync_form_label        =>'Y',
  p_display_in_default_rpt =>'Y',
  p_is_sortable            =>'Y',
  p_allow_sorting          =>'Y',
  p_allow_filtering        =>'Y',
  p_allow_ctrl_breaks      =>'Y',
  p_allow_aggregations     =>'Y',
  p_allow_computations     =>'Y',
  p_allow_charting         =>'Y',
  p_others_may_edit        =>'Y',
  p_others_may_view        =>'Y',
  p_column_type            =>'STRING',
  p_display_as             =>'TEXT',
  p_display_text_as        =>'ESCAPE_SC',
  p_heading_alignment      =>'CENTER',
  p_column_alignment       =>'LEFT',
  p_rpt_distinct_lov       =>'Y',
  p_rpt_show_filter_lov    =>'D',
  p_rpt_filter_date_ranges =>'ALL',
  p_display_condition_type =>'EXISTS',
  p_display_condition      =>'SELECT 1 FROM APEX_COLLECTIONS WHERE C009 IS NOT NULL AND COLLECTION_NAME=''P1110_CURRENT_FILTER''',
  p_help_text              =>'');
end;
/
begin
wwv_flow_api.create_worksheet_column(
  p_id => 9016230626986786+wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_page_id=> null,
  p_worksheet_id => 99822516313591406+wwv_flow_api.g_id_offset,
  p_db_column_name         =>'C010',
  p_display_order          =>10,
  p_group_id               =>null+wwv_flow_api.g_id_offset,
  p_column_identifier      =>'J',
  p_column_label           =>'Ranking',
  p_report_label           =>'Ranking',
  p_sync_form_label        =>'Y',
  p_display_in_default_rpt =>'Y',
  p_is_sortable            =>'Y',
  p_allow_sorting          =>'Y',
  p_allow_filtering        =>'Y',
  p_allow_ctrl_breaks      =>'Y',
  p_allow_aggregations     =>'Y',
  p_allow_computations     =>'Y',
  p_allow_charting         =>'Y',
  p_others_may_edit        =>'Y',
  p_others_may_view        =>'Y',
  p_column_type            =>'STRING',
  p_display_as             =>'TEXT',
  p_display_text_as        =>'ESCAPE_SC',
  p_heading_alignment      =>'CENTER',
  p_column_alignment       =>'LEFT',
  p_rpt_distinct_lov       =>'Y',
  p_rpt_show_filter_lov    =>'D',
  p_rpt_filter_date_ranges =>'ALL',
  p_display_condition_type =>'EXISTS',
  p_display_condition      =>'SELECT 1 FROM APEX_COLLECTIONS WHERE C010 IS NOT NULL AND COLLECTION_NAME=''P1110_CURRENT_FILTER''',
  p_help_text              =>'');
end;
/
begin
wwv_flow_api.create_worksheet_column(
  p_id => 9016328459986786+wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_page_id=> null,
  p_worksheet_id => 99822516313591406+wwv_flow_api.g_id_offset,
  p_db_column_name         =>'C011',
  p_display_order          =>11,
  p_group_id               =>null+wwv_flow_api.g_id_offset,
  p_column_identifier      =>'K',
  p_column_label           =>' ',
  p_report_label           =>' ',
  p_sync_form_label        =>'Y',
  p_display_in_default_rpt =>'Y',
  p_column_link            =>'#C011#',
  p_column_linktext        =>'&ICON_VLT.',
  p_is_sortable            =>'Y',
  p_allow_sorting          =>'Y',
  p_allow_filtering        =>'Y',
  p_allow_ctrl_breaks      =>'Y',
  p_allow_aggregations     =>'Y',
  p_allow_computations     =>'Y',
  p_allow_charting         =>'Y',
  p_others_may_edit        =>'Y',
  p_others_may_view        =>'Y',
  p_column_type            =>'STRING',
  p_display_as             =>'TEXT',
  p_display_text_as        =>'ESCAPE_SC',
  p_heading_alignment      =>'CENTER',
  p_column_alignment       =>'LEFT',
  p_rpt_distinct_lov       =>'Y',
  p_rpt_show_filter_lov    =>'D',
  p_rpt_filter_date_ranges =>'ALL',
  p_help_text              =>'');
end;
/
begin
wwv_flow_api.create_worksheet_column(
  p_id => 9016401166986786+wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_page_id=> null,
  p_worksheet_id => 99822516313591406+wwv_flow_api.g_id_offset,
  p_db_column_name         =>'C012',
  p_display_order          =>12,
  p_group_id               =>null+wwv_flow_api.g_id_offset,
  p_column_identifier      =>'L',
  p_column_label           =>'Created By',
  p_report_label           =>'Created By',
  p_sync_form_label        =>'Y',
  p_display_in_default_rpt =>'Y',
  p_is_sortable            =>'Y',
  p_allow_sorting          =>'Y',
  p_allow_filtering        =>'Y',
  p_allow_ctrl_breaks      =>'Y',
  p_allow_aggregations     =>'Y',
  p_allow_computations     =>'Y',
  p_allow_charting         =>'Y',
  p_others_may_edit        =>'Y',
  p_others_may_view        =>'Y',
  p_column_type            =>'STRING',
  p_display_as             =>'TEXT',
  p_display_text_as        =>'ESCAPE_SC',
  p_heading_alignment      =>'CENTER',
  p_column_alignment       =>'LEFT',
  p_rpt_distinct_lov       =>'Y',
  p_rpt_show_filter_lov    =>'D',
  p_rpt_filter_date_ranges =>'ALL',
  p_help_text              =>'');
end;
/
begin
wwv_flow_api.create_worksheet_column(
  p_id => 9016511026986786+wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_page_id=> null,
  p_worksheet_id => 99822516313591406+wwv_flow_api.g_id_offset,
  p_db_column_name         =>'TO_DATE(C013)',
  p_display_order          =>13,
  p_group_id               =>null+wwv_flow_api.g_id_offset,
  p_column_identifier      =>'M',
  p_column_label           =>'Date Opened',
  p_report_label           =>'Date Opened',
  p_sync_form_label        =>'Y',
  p_display_in_default_rpt =>'Y',
  p_is_sortable            =>'Y',
  p_allow_sorting          =>'Y',
  p_allow_filtering        =>'Y',
  p_allow_ctrl_breaks      =>'Y',
  p_allow_aggregations     =>'Y',
  p_allow_computations     =>'Y',
  p_allow_charting         =>'Y',
  p_others_may_edit        =>'Y',
  p_others_may_view        =>'Y',
  p_column_type            =>'DATE',
  p_display_as             =>'TEXT',
  p_display_text_as        =>'ESCAPE_SC',
  p_heading_alignment      =>'CENTER',
  p_column_alignment       =>'LEFT',
  p_format_mask            =>'dd-Mon-rrrr',
  p_rpt_distinct_lov       =>'Y',
  p_rpt_show_filter_lov    =>'D',
  p_rpt_filter_date_ranges =>'ALL',
  p_help_text              =>'');
end;
/
begin
wwv_flow_api.create_worksheet_column(
  p_id => 9016612185986787+wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_page_id=> null,
  p_worksheet_id => 99822516313591406+wwv_flow_api.g_id_offset,
  p_db_column_name         =>'TO_DATE(C014)',
  p_display_order          =>14,
  p_group_id               =>null+wwv_flow_api.g_id_offset,
  p_column_identifier      =>'N',
  p_column_label           =>'Date Closed',
  p_report_label           =>'Date Closed',
  p_sync_form_label        =>'Y',
  p_display_in_default_rpt =>'Y',
  p_is_sortable            =>'Y',
  p_allow_sorting          =>'Y',
  p_allow_filtering        =>'Y',
  p_allow_ctrl_breaks      =>'Y',
  p_allow_aggregations     =>'Y',
  p_allow_computations     =>'Y',
  p_allow_charting         =>'Y',
  p_others_may_edit        =>'Y',
  p_others_may_view        =>'Y',
  p_column_type            =>'DATE',
  p_display_as             =>'TEXT',
  p_display_text_as        =>'ESCAPE_SC',
  p_heading_alignment      =>'CENTER',
  p_column_alignment       =>'LEFT',
  p_format_mask            =>'dd-Mon-rrrr',
  p_rpt_distinct_lov       =>'Y',
  p_rpt_show_filter_lov    =>'D',
  p_rpt_filter_date_ranges =>'ALL',
  p_help_text              =>'');
end;
/
begin
wwv_flow_api.create_worksheet_column(
  p_id => 9016723403986787+wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_page_id=> null,
  p_worksheet_id => 99822516313591406+wwv_flow_api.g_id_offset,
  p_db_column_name         =>'TO_NUMBER(C015)',
  p_display_order          =>15,
  p_group_id               =>null+wwv_flow_api.g_id_offset,
  p_column_identifier      =>'O',
  p_column_label           =>'Days Since Opened',
  p_report_label           =>'Days Since Opened',
  p_sync_form_label        =>'Y',
  p_display_in_default_rpt =>'Y',
  p_is_sortable            =>'Y',
  p_allow_sorting          =>'Y',
  p_allow_filtering        =>'Y',
  p_allow_ctrl_breaks      =>'Y',
  p_allow_aggregations     =>'Y',
  p_allow_computations     =>'Y',
  p_allow_charting         =>'Y',
  p_others_may_edit        =>'Y',
  p_others_may_view        =>'Y',
  p_column_type            =>'NUMBER',
  p_display_as             =>'TEXT',
  p_display_text_as        =>'ESCAPE_SC',
  p_heading_alignment      =>'CENTER',
  p_column_alignment       =>'RIGHT',
  p_rpt_distinct_lov       =>'Y',
  p_rpt_show_filter_lov    =>'D',
  p_rpt_filter_date_ranges =>'ALL',
  p_help_text              =>'');
end;
/
begin
wwv_flow_api.create_worksheet_column(
  p_id => 9016824673986787+wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_page_id=> null,
  p_worksheet_id => 99822516313591406+wwv_flow_api.g_id_offset,
  p_db_column_name         =>'C016',
  p_display_order          =>16,
  p_group_id               =>null+wwv_flow_api.g_id_offset,
  p_column_identifier      =>'P',
  p_column_label           =>'Lead Agent',
  p_report_label           =>'Lead Agent',
  p_sync_form_label        =>'Y',
  p_display_in_default_rpt =>'Y',
  p_is_sortable            =>'Y',
  p_allow_sorting          =>'Y',
  p_allow_filtering        =>'Y',
  p_allow_ctrl_breaks      =>'Y',
  p_allow_aggregations     =>'Y',
  p_allow_computations     =>'Y',
  p_allow_charting         =>'Y',
  p_others_may_edit        =>'Y',
  p_others_may_view        =>'Y',
  p_column_type            =>'STRING',
  p_display_as             =>'TEXT',
  p_display_text_as        =>'ESCAPE_SC',
  p_heading_alignment      =>'CENTER',
  p_column_alignment       =>'LEFT',
  p_rpt_distinct_lov       =>'Y',
  p_rpt_show_filter_lov    =>'D',
  p_rpt_filter_date_ranges =>'ALL',
  p_help_text              =>'');
end;
/
begin
wwv_flow_api.create_worksheet_column(
  p_id => 9021030703670599+wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_page_id=> null,
  p_worksheet_id => 99822516313591406+wwv_flow_api.g_id_offset,
  p_db_column_name         =>'C017',
  p_display_order          =>17,
  p_group_id               =>null+wwv_flow_api.g_id_offset,
  p_column_identifier      =>'Q',
  p_column_label           =>'Mission Area',
  p_report_label           =>'Mission Area',
  p_sync_form_label        =>'Y',
  p_display_in_default_rpt =>'Y',
  p_is_sortable            =>'Y',
  p_allow_sorting          =>'Y',
  p_allow_filtering        =>'Y',
  p_allow_ctrl_breaks      =>'Y',
  p_allow_aggregations     =>'Y',
  p_allow_computations     =>'Y',
  p_allow_charting         =>'Y',
  p_others_may_edit        =>'Y',
  p_others_may_view        =>'Y',
  p_column_type            =>'STRING',
  p_display_as             =>'TEXT',
  p_display_text_as        =>'ESCAPE_SC',
  p_heading_alignment      =>'CENTER',
  p_column_alignment       =>'LEFT',
  p_rpt_distinct_lov       =>'Y',
  p_rpt_show_filter_lov    =>'D',
  p_rpt_filter_date_ranges =>'ALL',
  p_help_text              =>'');
end;
/
begin
wwv_flow_api.create_worksheet_column(
  p_id => 9021107500670599+wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_page_id=> null,
  p_worksheet_id => 99822516313591406+wwv_flow_api.g_id_offset,
  p_db_column_name         =>'TO_DATE(C018)',
  p_display_order          =>18,
  p_group_id               =>null+wwv_flow_api.g_id_offset,
  p_column_identifier      =>'R',
  p_column_label           =>'&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;ROI?&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;',
  p_report_label           =>'&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;ROI?&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;',
  p_sync_form_label        =>'Y',
  p_display_in_default_rpt =>'Y',
  p_is_sortable            =>'Y',
  p_allow_sorting          =>'Y',
  p_allow_filtering        =>'Y',
  p_allow_ctrl_breaks      =>'Y',
  p_allow_aggregations     =>'Y',
  p_allow_computations     =>'Y',
  p_allow_charting         =>'Y',
  p_others_may_edit        =>'Y',
  p_others_may_view        =>'Y',
  p_column_type            =>'DATE',
  p_display_as             =>'TEXT',
  p_display_text_as        =>'ESCAPE_SC',
  p_heading_alignment      =>'CENTER',
  p_column_alignment       =>'LEFT',
  p_format_mask            =>'dd-Mon-rrrr',
  p_rpt_distinct_lov       =>'Y',
  p_rpt_show_filter_lov    =>'D',
  p_rpt_filter_date_ranges =>'ALL',
  p_display_condition_type =>'EXISTS',
  p_display_condition      =>'SELECT 1 FROM APEX_COLLECTIONS WHERE TO_DATE(C018) IS NOT NULL AND COLLECTION_NAME=''P1110_CURRENT_FILTER''',
  p_help_text              =>'');
end;
/
begin
wwv_flow_api.create_worksheet_column(
  p_id => 12781113486152126+wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_page_id=> null,
  p_worksheet_id => 99822516313591406+wwv_flow_api.g_id_offset,
  p_db_column_name         =>'C019',
  p_display_order          =>19,
  p_group_id               =>null+wwv_flow_api.g_id_offset,
  p_column_identifier      =>'S',
  p_column_label           =>'Primary Offense',
  p_report_label           =>'Primary Offense',
  p_sync_form_label        =>'Y',
  p_display_in_default_rpt =>'Y',
  p_is_sortable            =>'Y',
  p_allow_sorting          =>'Y',
  p_allow_filtering        =>'Y',
  p_allow_ctrl_breaks      =>'Y',
  p_allow_aggregations     =>'Y',
  p_allow_computations     =>'Y',
  p_allow_charting         =>'Y',
  p_others_may_edit        =>'Y',
  p_others_may_view        =>'Y',
  p_column_type            =>'STRING',
  p_display_as             =>'TEXT',
  p_display_text_as        =>'ESCAPE_SC',
  p_heading_alignment      =>'CENTER',
  p_column_alignment       =>'LEFT',
  p_rpt_distinct_lov       =>'Y',
  p_rpt_show_filter_lov    =>'D',
  p_rpt_filter_date_ranges =>'ALL',
  p_display_condition_type =>'EXISTS',
  p_display_condition      =>'SELECT 1 FROM APEX_COLLECTIONS WHERE C019 IS NOT NULL AND COLLECTION_NAME=''P1110_CURRENT_FILTER''',
  p_help_text              =>'');
end;
/
begin
wwv_flow_api.create_worksheet_rpt(
  p_id => 99823233706591420+wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_page_id=> 1110,
  p_worksheet_id => 99822516313591406+wwv_flow_api.g_id_offset,
  p_session_id  => null,
  p_base_report_id  => null+wwv_flow_api.g_id_offset,
  p_application_user => 'APXWS_DEFAULT',
  p_report_seq              =>10,
  p_status                  =>'PRIVATE',
  p_category_id             =>null+wwv_flow_api.g_id_offset,
  p_is_default              =>'Y',
  p_display_rows            =>15,
  p_report_columns          =>'C002:C003:C004:C016:C006:C007:TO_DATE(C005):C017:TO_DATE(C018):TO_DATE(C008):C009:C010:C011',
  p_flashback_enabled       =>'N',
  p_calendar_display_column =>'');
end;
/
 
begin
 
wwv_flow_api.create_page_button(
  p_id             => 15458702895299604 + wwv_flow_api.g_id_offset,
  p_flow_id        => wwv_flow.g_flow_id,
  p_flow_step_id   => 1110,
  p_button_sequence=> 10,
  p_button_plug_id => 99822325742591398+wwv_flow_api.g_id_offset,
  p_button_name    => 'EXPORT',
  p_button_image   => 'template:'||to_char(15353513871475325+wwv_flow_api.g_id_offset),
  p_button_image_alt=> '&BTN_EXPORT.',
  p_button_position=> 'RIGHT_OF_IR_SEARCH_BAR',
  p_button_alignment=> 'LEFT',
  p_button_redirect_url=> 'javascript:void(0);',
  p_button_cattributes=>'onClick="javascript:getIRCSV(null, this, 1110);"',
  p_required_patch => null + wwv_flow_api.g_id_offset);
 
 
end;
/

 
begin
 
wwv_flow_api.create_page_branch(
  p_id=>1547417997581231 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 1110,
  p_branch_action=> 'f?p=&APP_ID.:1110:&SESSION.::&DEBUG.:::',
  p_branch_point=> 'AFTER_PROCESSING',
  p_branch_type=> 'REDIRECT_URL',
  p_branch_sequence=> 10,
  p_save_state_before_branch_yn=>'N',
  p_branch_comment=> 'Created 25-MAR-2010 10:02 by TIM');
 
 
end;
/

declare
    h varchar2(32767) := null;
begin
wwv_flow_api.create_page_item(
  p_id=>1547007954578242 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 1110,
  p_name=>'P1110_FILTER',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 10,
  p_item_plug_id => 99822325742591398+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'YES',
  p_item_default_type => 'STATIC_TEXT_WITH_SUBSTITUTIONS',
  p_source_type=> 'STATIC',
  p_display_as=> 'COMBOBOX',
  p_named_lov=> 'DESKTOP_FILTER',
  p_lov => '.'||to_char(6129207658248740 + wwv_flow_api.g_id_offset)||'.',
  p_lov_columns=> 1,
  p_lov_display_null=> 'NO',
  p_lov_translated=> 'N',
  p_cSize=> 30,
  p_cMaxlength=> 2000,
  p_cHeight=> 5,
  p_cAttributes=> 'nowrap',
  p_begin_on_new_line => 'YES',
  p_begin_on_new_field=> 'YES',
  p_colspan => 1,
  p_rowspan => 1,
  p_label_alignment  => 'LEFT',
  p_field_alignment  => 'LEFT',
  p_field_template => 179220564785554493+wwv_flow_api.g_id_offset,
  p_is_persistent=> 'Y',
  p_lov_display_extra=>'NO',
  p_item_comment => '');
 
 
end;
/

declare
    h varchar2(32767) := null;
begin
wwv_flow_api.create_page_item(
  p_id=>9001104929751807 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 1110,
  p_name=>'P1110_FILE_TYPE',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 40,
  p_item_plug_id => 99822325742591398+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'YES',
  p_item_default_type => 'STATIC_TEXT_WITH_SUBSTITUTIONS',
  p_source_type=> 'STATIC',
  p_display_as=> 'HIDDEN',
  p_lov_columns=> 1,
  p_lov_display_null=> 'NO',
  p_lov_translated=> 'N',
  p_cSize=> null,
  p_cMaxlength=> 2000,
  p_cHeight=> null,
  p_cAttributes=> 'nowrap="nowrap"',
  p_begin_on_new_line => 'NO',
  p_begin_on_new_field=> 'YES',
  p_colspan => 1,
  p_rowspan => 1,
  p_label_alignment  => 'LEFT',
  p_field_alignment  => 'LEFT',
  p_is_persistent=> 'Y',
  p_item_comment => '');
 
 
end;
/

declare
    h varchar2(32767) := null;
begin
wwv_flow_api.create_page_item(
  p_id=>9005922674088123 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 1110,
  p_name=>'P1110_TITLE',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 50,
  p_item_plug_id => 99822325742591398+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'YES',
  p_item_default_type => 'STATIC_TEXT_WITH_SUBSTITUTIONS',
  p_source_type=> 'STATIC',
  p_display_as=> 'HIDDEN',
  p_lov_columns=> 1,
  p_lov_display_null=> 'NO',
  p_lov_translated=> 'N',
  p_cSize=> null,
  p_cMaxlength=> 2000,
  p_cHeight=> null,
  p_cAttributes=> 'nowrap="nowrap"',
  p_begin_on_new_line => 'NO',
  p_begin_on_new_field=> 'YES',
  p_colspan => 1,
  p_rowspan => 1,
  p_label_alignment  => 'LEFT',
  p_field_alignment  => 'LEFT',
  p_is_persistent=> 'Y',
  p_item_comment => '');
 
 
end;
/

declare
    h varchar2(32767) := null;
begin
wwv_flow_api.create_page_item(
  p_id=>9017017591995019 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 1110,
  p_name=>'P1110_ACTIVE_FILTER',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 60,
  p_item_plug_id => 99822325742591398+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'YES',
  p_item_default_type => 'STATIC_TEXT_WITH_SUBSTITUTIONS',
  p_source_type=> 'STATIC',
  p_display_as=> 'COMBOBOX',
  p_named_lov=> 'DESKTOP_FILTER_ACTIVE',
  p_lov => '.'||to_char(8788412414956145 + wwv_flow_api.g_id_offset)||'.',
  p_lov_columns=> 1,
  p_lov_display_null=> 'NO',
  p_lov_translated=> 'N',
  p_cSize=> 30,
  p_cMaxlength=> 2000,
  p_cHeight=> 5,
  p_cAttributes=> 'nowrap',
  p_begin_on_new_line => 'NO',
  p_begin_on_new_field=> 'YES',
  p_colspan => 1,
  p_rowspan => 1,
  p_label_alignment  => 'RIGHT',
  p_field_alignment  => 'LEFT',
  p_field_template => 179220564785554493+wwv_flow_api.g_id_offset,
  p_is_persistent=> 'Y',
  p_lov_display_extra=>'NO',
  p_protection_level => 'N',
  p_item_comment => '');
 
 
end;
/

declare
    h varchar2(32767) := null;
begin
wwv_flow_api.create_page_item(
  p_id=>9017231789999102 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 1110,
  p_name=>'P1110_NUM_ROWS',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 70,
  p_item_plug_id => 99822325742591398+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'YES',
  p_item_default_type => 'STATIC_TEXT_WITH_SUBSTITUTIONS',
  p_source_type=> 'STATIC',
  p_display_as=> 'HIDDEN',
  p_lov_columns=> 1,
  p_lov_display_null=> 'NO',
  p_lov_translated=> 'N',
  p_cSize=> null,
  p_cMaxlength=> 2000,
  p_cHeight=> null,
  p_cAttributes=> 'nowrap="nowrap"',
  p_begin_on_new_line => 'NO',
  p_begin_on_new_field=> 'YES',
  p_colspan => 1,
  p_rowspan => 1,
  p_label_alignment  => 'LEFT',
  p_field_alignment  => 'LEFT',
  p_is_persistent=> 'Y',
  p_item_comment => '');
 
 
end;
/

declare
    h varchar2(32767) := null;
begin
wwv_flow_api.create_page_item(
  p_id=>15458914323302881 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 1110,
  p_name=>'P1110_EXPORT_NAME',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 30,
  p_item_plug_id => 99822325742591398+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'YES',
  p_item_default_type => 'STATIC_TEXT_WITH_SUBSTITUTIONS',
  p_source_type=> 'STATIC',
  p_display_as=> 'HIDDEN',
  p_lov_columns=> 1,
  p_lov_display_null=> 'NO',
  p_lov_translated=> 'N',
  p_cSize=> 30,
  p_cMaxlength=> 2000,
  p_cHeight=> 1,
  p_cAttributes=> 'nowrap',
  p_begin_on_new_line => 'NO',
  p_begin_on_new_field=> 'NO',
  p_colspan => 1,
  p_rowspan => 1,
  p_label_alignment  => 'LEFT',
  p_field_alignment  => 'LEFT',
  p_is_persistent=> 'Y',
  p_lov_display_extra=>'NO',
  p_protection_level => 'N',
  p_item_comment => '');
 
 
end;
/

 
begin
 
wwv_flow_api.create_page_computation(
  p_id=> 9017722570005958 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 1110,
  p_computation_sequence => 40,
  p_computation_item=> 'P1110_NUM_ROWS',
  p_computation_point=> 'BEFORE_BOX_BODY',
  p_computation_type=> 'PLSQL_EXPRESSION',
  p_computation_processed=> 'REPLACE_EXISTING',
  p_computation=> 'osi_personnel.get_user_setting(:user_sid,'||chr(10)||
'                               ''P'' || :APP_PAGE_ID || ''_NUM_ROWS.'' || :P1110_FILE_TYPE,'||chr(10)||
'                               ''25'');'||chr(10)||
'',
  p_compute_when => '',
  p_compute_when_type=>'');
 
null;
 
end;
/

 
begin
 
wwv_flow_api.create_page_computation(
  p_id=> 1547113149579750 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 1110,
  p_computation_sequence => 10,
  p_computation_item=> 'P1110_FILTER',
  p_computation_point=> 'BEFORE_HEADER',
  p_computation_type=> 'STATIC_ASSIGNMENT',
  p_computation_processed=> 'REPLACE_EXISTING',
  p_computation=> 'RECENT',
  p_compute_when => 'P1110_FILTER',
  p_compute_when_type=>'ITEM_IS_NULL');
 
null;
 
end;
/

 
begin
 
wwv_flow_api.create_page_computation(
  p_id=> 9017518414004702 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 1110,
  p_computation_sequence => 40,
  p_computation_item=> 'P1110_ACTIVE_FILTER',
  p_computation_point=> 'BEFORE_HEADER',
  p_computation_type=> 'STATIC_ASSIGNMENT',
  p_computation_processed=> 'REPLACE_EXISTING',
  p_computation=> 'ACTIVE',
  p_compute_when => 'P1110_ACTIVE_FILTER',
  p_compute_when_type=>'ITEM_IS_NULL');
 
null;
 
end;
/

 
begin
 
declare
  p varchar2(32767) := null;
  l_clob clob;
  l_length number := 1;
begin
p:=p||'begin'||chr(10)||
'   :P1110_FILTER := osi_personnel.get_user_setting(:user_sid,'||chr(10)||
'                                                   ''P'' || :APP_PAGE_ID || ''_FILTER.'' || :P1110_FILE_TYPE,'||chr(10)||
'                                                   ''RECENT'');'||chr(10)||
''||chr(10)||
'   :P1110_ACTIVE_FILTER := osi_personnel.get_user_setting(:user_sid,'||chr(10)||
'                                                          ''P'' || :APP_PAGE_ID || ''_ACTIVE_FILT';

p:=p||'ER.'' || :P1110_FILE_TYPE,'||chr(10)||
'                                                          ''ACTIVE'');'||chr(10)||
''||chr(10)||
'End;';

wwv_flow_api.create_page_process(
  p_id     => 9018107810011098 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id => 1110,
  p_process_sequence=> 40,
  p_process_point=> 'BEFORE_HEADER',
  p_process_type=> 'PLSQL',
  p_process_name=> 'DESKTOP FILTERS DEFAULT',
  p_process_sql_clob => p, 
  p_process_error_message=> '',
  p_process_success_message=> '',
  p_process_is_stateful_y_n=>'N',
  p_process_comment=>'');
end;
null;
 
end;
/

 
begin
 
---------------------------------------
-- ...updatable report columns for page 1110
--
 
begin
 
null;
end;
null;
 
end;
/

commit;
begin 
execute immediate 'alter session set nls_numeric_characters='''||wwv_flow_api.g_nls_numeric_chars||'''';
end;
/
set verify on
set feedback on
prompt  ...done

