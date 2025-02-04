set define off;

CREATE OR REPLACE PACKAGE BODY "OSI_MENU" AS
/******************************************************************************
   Name:     osi_menu
   Purpose:  Provides Functionality for OSI Menu Creation

   Revisions:
    Date        Author          Description
    ----------  --------------  ------------------------------------
    11-May-2012 Tim Ward        Created Package.
    20-Jun-2012 Tim Ward        Added GetObjectMenusHTML to allow building
                                 Lifecycle, Checklist, IAFIS, Versions, Reports,
                                 and E-Fund Menus from here......
                                 Added GetActionsMenuHTML, GetChecklistImage, GetChecklistMenuHTML, 
                                  GetIAFISMenuHTML, GetObjectsMenusHTML, GetReportMenuHTML, 
                                  GetReportImage, GetStatusImage, and GetVersionsMenuHTML.
    12-Jul-2012 Tim Ward        CR#3460 - Delete Version is never displayed.
                                 Changed in GetVersionsMenuHTML.                                  
    03-Aug-2012 Tim Ward       Changed GetReportMenuHTML to call OSI_UTIL.get_report_links with the
                                new 3rd parameter set to 'Y' to get the Report SID so we can get the
                                correct image.
                                       
******************************************************************************/
    c_pipe   VARCHAR2(100) := Core_Util.get_config('CORE.PIPE_PREFIX') || 'OSI_MENU';

    PROCEDURE log_error(p_msg IN VARCHAR2) IS
    BEGIN
        Core_Logger.log_it(c_pipe, p_msg);
    END log_error;

    FUNCTION childrenCount(pMenuID in varchar2) return number is
            
            childCount number := 0;
    BEGIN
         select count(*) into childCount from t_osi_menu where parent_id=pMenuID and active='Y';

         return childCount;
    
    EXCEPTION WHEN OTHERS THEN
             
             return childCount;
                      
    END childrenCount;
    
    FUNCTION GetMenuHTML(pMenuID in varchar2, pTopLevelDescriptionReplace in varchar2 := NULL, pOtherNames in varchar2 := NULL, pOtherVals in varchar2 := NULL) return CLOB is
      
      SQLString     CLOB;
      topLevelClass varchar2(100) := ' class="sf-with-ul-top" ';
      topLevelli    varchar2(100) := ' class="sf-li-top" ';

    BEGIN
         SQLString := '<ul class="sf-menu">' || vCRLF;

         for m in (SELECT * from t_osi_menu where active='Y' START WITH id=pMenuId CONNECT BY prior id=parent_id order by seq)
         loop
             if(pOtherNames is not null and pOtherVals is not null) then
               
               if(m.command is null) then

                 SQLString := SQLString || '<li id="' || m.id || '"' || toplevelli || '><a' || toplevelclass || 'href="#">';
               
               else
                 
                 SQLString := SQLString || '<li id="' || m.id || '"' || toplevelli || '><a' || toplevelclass || 'href="' || replace(m.command,');',',' || '''' || pOtherNames || '''' || ',' || '''' || pOtherVals || '''' || ');') || '">';
               
               end if;

             else
  
               SQLString := SQLString || '<li id="' || m.id || '"' || toplevelli || '><a' || toplevelclass || 'href="' || nvl(m.command,'#') || '">';
               
             end if;
             
             if(m.icon is not null) then
  
               SQLString := SQLString || '<img class="sf-menu-img" src="' || m.icon || '">';
  
             end if;
             
             if(m.id=pMenuId and pTopLevelDescriptionReplace is not null) then

               SQLString := SQLString || pTopLevelDescriptionReplace || '</a>';

             else

               SQLString := SQLString || m.description || '</a>';

             end if;
             
             if(childrenCount(m.id)>0) then

               SQLString := SQLString  || vCRLF || '<ul id="' || m.id || '_MAIN">' || vCRLF;
             
             else

               SQLString := SQLString || '</li>' || vCRLF;
             
             end if;
             if(m.last_child)='Y' then

               SQLString:=SQLString || '</ul>' || vCRLF;

             end if;             
             if(m.double_close)='Y' then

               SQLString:=SQLString || '</ul>' || vCRLF;

             end if;
             topLevelClass:=' ';
             topLevelli:=' ';
             
         end loop;
         SQLString := SQLString || '</ul>' || vCRLF;

         return SQLString;
         
    END GetMenuHTML;

    FUNCTION GetReportImage(preportLabel in varchar2 ,preportSID in varchar2) return varchar2 is
      
      statusImage varchar2(100) := '/i/themes/OSI/report16.gif';
      
    BEGIN
         begin
              select '/i/themes/OSI/' || decode(image,null,'report16.gif',image) into statusImage from t_osi_report_type where sid=preportSID;
              
         exception when others then
                  
                  statusImage:='/i/themes/OSI/report16.gif';
                  
         end;

         return statusImage;
         
    END GetReportImage;

    FUNCTION GetChecklistImage(pchecklistLabel in varchar2 ,pstatusSID in varchar2) return varchar2 is
      
      statusImage varchar2(100) := '/i/themes/OSI/checklist16.gif';
      
    BEGIN
         begin
              select '/i/themes/OSI/' || decode(checklist_image,null,'checklist16.gif',image) into statusImage from t_osi_status_change where sid=pstatusSID;
              
         exception when others then
                  
                  statusImage:='/i/themes/OSI/checklist16.gif';
                  
         end;
         
         return statusImage;
         
    END GetChecklistImage;
    
    FUNCTION GetStatusImage(pstatusLabel in varchar2 ,pstatusSID in varchar2) return varchar2 is
      
      statusImage varchar2(100) := '/i/themes/OSI/blank16.gif';
      
    BEGIN
         begin
              select '/i/themes/OSI/' || decode(image,null,'blank16.gif',image) into statusImage from t_osi_status_change where sid=pstatusSID;
              
         exception when others then
                  
                  statusImage:='/i/themes/OSI/blank16.gif';
                  
         end;
         
         return statusImage;
         
    END GetStatusImage;
    
    FUNCTION GetActionsMenuHTML(pObjSID in varchar2, pObjTypeCode in varchar2, pObjTypeSID in varchar2) RETURN CLOB is    

      SQLString     CLOB;
      statusButtons CLOB;
      listCount     NUMBER;
      statusLabel   varchar2(1000);
      statusSID     varchar2(1000);
      statusImage   varchar2(1000);
      statusCount   NUMBER := 8;
      status        varchar2(1000);
      submitted_on  date;
                  
    BEGIN
         SQLString := '<ul class="sf-menu">';
         SQLString := SQLString || ' <li id="ID_ACTIONS" class="sf-li-top"><a class="sf-with-ul-top" href="#"><img class="sf-menu-img" src="/i/themes/OSI/blank16.gif">Actions</a>';
         SQLString := SQLString || '  <ul id="ID_ACTIONS_MAIN">';
         
         --- Delete Object Menu Item ---
         if (pObjSID is not null) then
         
           SQLString := SQLString || '   <li id="ID_STATUS1"><a href="javascript:void(0);" onclick="javascript:deleteObj(''' || pObjSID || ''',''DELETE_OBJECT'');"><img class="sf-menu-img" src="/i/themes/OSI/delete16.gif">Delete</a></li>';

         end if;
         
         --- E-Fund Expenses ONLY Related Menu Items ---
         if (pObjTypeCode='CFUNDS_EXP') then
           
           begin
                select status into status from v_cfunds_expense_v3 where sid=pObjSID;
           exception when others then
           
                    status := null;
           end;

           if (status='' or status='New') and cfunds_test_cfp('EXP_CRE_PROXY',pObjTypeSID,core_context.personnel_sid,osi_personnel.get_current_unit(core_context.personnel_sid)) = 'Y' then         

             SQLString := SQLString || '   <li id="ID_STATUSC1"><a href="javascript:void(0);" onclick="javascript:openLocator(''301'',''P30505_CLAIMANT'',''N'','''',''OPEN'','''','''',''Choose New Claimant...'',''PERSONNEL'',''' || pObjSID || ''');"><img class="sf-menu-img" src="/i/themes/OSI/ChangeClaimant16.gif">Change Claimant</a></li>';

           end if;

           if (status='Disallowed' or status='New') then         

             SQLString := SQLString || '   <li id="ID_STATUSC2"><a href="javascript:void(0);" onclick="javascript:doSubmit(''SUBMIT_FOR_APPROVAL'');"><img class="sf-menu-img" src="/i/themes/OSI/submitforapproveclose16.gif">Submit for Approval</a></li>';

           end if;
           
           if (status='Submitted') then         

             SQLString := SQLString || '   <li id="ID_STATUSC3"><a href="javascript:void(0);" onclick="javascript:popupCommentsWindow();"><img class="sf-menu-img" src="/i/themes/OSI/RejectAdvanceExpense16.gif">Disallow Expense</a></li>';
             SQLString := SQLString || '   <li id="ID_STATUSC4"><a href="javascript:void(0);" onclick="javascript:doSubmit(''APPROVE_EXPENSE'');"><img class="sf-menu-img" src="/i/themes/OSI/ApproveAdvanceExpense16.gif">Approve Expense</a></li>';

           end if;
                      
           if (status='Rejected') then         

             SQLString := SQLString || '   <li id="ID_STATUSC5"><a href="javascript:void(0);" onclick="javascript:doSubmit(''FIX_EXPENSE'');"><img class="sf-menu-img" src="/i/themes/OSI/ResubmitFixedExpense16.gif">Fix Expense</a></li>';

           end if;
           
           if (status='Disallowed') then         

             SQLString := SQLString || '   <li id="ID_STATUSC6"><a href="javascript:void(0);" onclick="javascript:popupCommentsWindow();"><img class="sf-menu-img" src="/i/themes/OSI/ViewDisallowedExpenseComments16.gif">View Disallowed Expense Comments</a></li>';

           end if;
           
         end if;

         --- E-Fund Advances ONLY Related Menu Items ---
         if (pObjTypeCode='CFUNDS_ADV') then

           begin
                select status,submitted_on into status,submitted_on from v_cfunds_advance_v2 where sid=pObjSID;
           exception when others then
           
                    status := null;
                    submitted_on := null;
                    
           end;

           --SQLString := SQLString || '   <li id="ID_STATUSC1"><a href="javascript:void(0);" onclick="javascript:doSubmit(''ISSUE_ADVANCE'');"><img class="sf-menu-img" src="/i/themes/OSI/blank16.gif">Issue Advance</a></li>';

           if (submitted_on is null) then           

             SQLString := SQLString || '   <li id="ID_STATUSC2"><a href="javascript:void(0);" onclick="javascript:openLocator(''301'',''P30600_CLAIMANT_SID'',''N'','''',''OPEN'','''','''',''Choose New Claimant...'',''PERSONNEL'',''' || pObjSID || ''');"><img class="sf-menu-img" src="/i/themes/OSI/ChangeClaimant16.gif">Change Claimant</a></li>';

           end if;
           
           if (submitted_on is null or status='Disallowed') then           

             SQLString := SQLString || '   <li id="ID_STATUSC3"><a href="javascript:void(0);" onclick="javascript:doSubmit(''SUBMIT_FOR_APPROVAL'');"><img class="sf-menu-img" src="/i/themes/OSI/submitforapproveclose16.gif">Submit for Approval</a></li>';

           end if;

           if (status='Submitted') then           

             SQLString := SQLString || '   <li id="ID_STATUSC4"><a href="javascript:void(0);" onclick="javascript:doSubmit(''APPROVE_ADVANCE'');"><img class="sf-menu-img" src="/i/themes/OSI/ApproveAdvanceExpense16.gif">Approve Advance</a></li>';

           end if;
                    
           if (status='Submitted') then           

             SQLString := SQLString || '   <li id="ID_STATUSC5"><a href="javascript:void(0);" onclick="javascript:doSubmit(''REJECT_ADVANCE'');"><img class="sf-menu-img" src="/i/themes/OSI/RejectAdvanceExpense16.gif">Reject Advance</a></li>';

           end if;

         end if;

         --- DEERS Check Menu Item ---
         if (pObjTypeCode='PART.INDIV') then -- and (:p0_obj_context is null or :p0_obj_context = osi_participant.get_current_version(:p0_obj))
         
           SQLString := SQLString || '   <li id="ID_STATUS2"><a href="javascript:void(0);" onclick="javascript:checkDeers(''' || pObjSID || ''');" onclick="javascript:runDirtyTest(''Action''); return !(checkDirty());"><img class="sf-menu-img" src="/i/themes/OSI/deers16.gif">Check DEERS</a></li>';

         end if;         
         
         --- Generate Narrative for Initial Notification Activities Menu Item ---
         if (pObjTypeCode='ACT.INIT_NOTIF') then

           SQLString := SQLString || '   <li id="ID_STATUS3"><a href="javascript:void(0)" onclick="javascript:runJQueryPopWin(''Generate Narrative'',''' || pObjSID || ''',''22010'');return false;"><img class="sf-menu-img" src="/i/themes/OSI/generatenarrative16.gif">Generate Narrative</a></li>';

         end if;
         
         --- Duplicate Legacy I2MS Source Search Menu Item ---
         if (pObjTypeCode='FILE.SOURCE') then

           SQLString := SQLString || '   <li id="ID_STATUS4"><a href="javascript:void(0);" onclick="javascript:newWindow({page:11330,clear_cache:''11330'',name:''' || pObjSID || '_SRCSRCH'',item_names:''P0_OBJ,P0_OBJ_CONTEXT,P11330_OBJ'',item_values:''' || pObjSID || ',,' || pObjSID || ''',request:''SRCH''});"><img class="sf-menu-img" src="/i/themes/OSI/duplicatelegacyi2mssourcesearch16.gif">Duplicate Legacy I2MS Source Search</a></li>';
         
         end if;

         --- Legacy I2MS Relationship Search Menu Item ---
         if (pObjTypeCode like ('PART.%') and osi_participant.get_imp_relations_flag(pObjSID) = 'N') then

           SQLString := SQLString || '   <li id="ID_STATUS5"><a href="javascript:void(0);" onclick="javascript:importRelations(''' || pObjSID || ''',''IMPORT_RELATIONS'');"><img class="sf-menu-img" src="/i/themes/OSI/legacyi2msrelationshipsearch16.gif">Legacy I2MS Relationship Search</a></li>';
         
         end if;
         
         --- Status Change Menu Items ---
         statusButtons := osi_util.get_status_buttons(pObjSID, '^~');
         if (statusButtons!='~') then
         
           for a in (select column_value from table(split(statusButtons,'^~')) where column_value is not null)
           loop

               listCount:=1;
               for b in (select column_value from table(split(a.column_value,'~')))
               loop
                   if (listCount=1) then
                 
                     statusLabel := replace(b.column_value,'''','''''');

                   elsif (listCount=2) then

                        statusSID := replace(b.column_value,'''','''''');

                   end if;
                   listCount:=listCount+1;
                 
               end loop;
               statusImage := GetStatusImage(statusLabel,statusSID);
               SQLString := SQLString || '   <li id="ID_STATUS"' || statusCount || '><a href="javascript:void(0);" onclick="javascript:runJQueryPopWin(''Status'',''' || pObjSID || ''',''' || statusSID || ''');"><img class="sf-menu-img" src="' || statusImage || '">' || statusLabel || '</a></li>';
               statusCount := statusCount + 1;
               
           end loop;

         end if;
         
         --- Classify Menu Item ---
         if (CORE_UTIL.GET_CONFIG('OSI.ALLOW_CLASSIFICATIONS')='Y' AND pObjTypeCode NOT IN ('CFUNDS_ADV','CFUNDS_EXP','PERSONNEL')) then         

           SQLString := SQLString || '   <li id="ID_STATUS6"><a href="javascript:void(0);" onclick="javascript:newWindow({page:765,clear_cache:''765'',name:''' || pObjSID || '_CLASSIFICATION'',item_names:''P0_OBJ,P0_OBJ_CONTEXT,P765_OBJ,P765_CONTEXT'',item_values:''' || pObjSID || ',,' || pObjSID || ','',request:''CLASSIFICATION''});"><img class="sf-menu-img" src="/i/themes/OSI/classify16.gif">Classify</a></li>';
           
         end if;
         
         --- Masking Menu Item ---
         if (pObjTypeCode in ('ACT.INTERVIEW.WITNESS','ACT.SOURCE_MEET','ACT.SURVEILLANCE')) then

           SQLString := SQLString || '   <li id="ID_STATUS7"><a href="javascript:void(0);" onclick="javascript:newWindow({page:760,clear_cache:''760'',name:''' || pObjSID || '_MASK'',item_names:''P0_OBJ,P0_OBJ_CONTEXT,P760_OBJ'',item_values:''' || pObjSID || ',,' || pObjSID || ''',request:''MASK''});"><img class="sf-menu-img" src="/i/themes/OSI/masking16.gif">Masking</a></li>';

         end if;
                  
         SQLString := SQLString || '  </ul>';
         SQLString := SQLString || ' </li>';
         SQLString := SQLString || '</ul>';

         return SQLString;

    END GetActionsMenuHTML;    

    FUNCTION GetChecklistMenuHTML(pObjSID in varchar2, pObjTypeCode in varchar2) RETURN CLOB is    

      SQLString        CLOB;
      checklistButtons CLOB;
      listCount        NUMBER;
      checklistLabel   varchar2(1000);
      checklistSID     varchar2(1000);
      checklistImage   varchar2(1000);
      checklistCount   NUMBER := 1;
            
    BEGIN
         SQLString := '<ul class="sf-menu">';
         SQLString := SQLString || ' <li id="ID_CHECKLIST" class="sf-li-top" ><a class="sf-with-ul-top" href="#"><img class="sf-menu-img" src="/i/themes/OSI/checklist16.gif">Checklists</a>';
         SQLString := SQLString || '  <ul id="ID_CHECKLISTS_MAIN">';
         
         --- Checklist Menu Items ---
         checklistButtons := osi_util.get_checklist_buttons(pObjSID, '^~');
         if (checklistButtons='~') then
         
           SQLString := '';
           
         else

           for a in (select column_value from table(split(checklistButtons,'^~')) where column_value is not null)
           loop

               listCount:=1;
               for b in (select column_value from table(split(a.column_value,'~')))
               loop
                   if (listCount=1) then
                  
                     checklistLabel := replace(b.column_value,'''','''''');

                   elsif (listCount=2) then

                        checklistSID := replace(b.column_value,'''','''''');

                   end if;
                   listCount:=listCount+1;
                 
               end loop;
               checklistImage := GetChecklistImage(checklistLabel,checklistSID);
               SQLString := SQLString || '   <li id="ID_STATUS"' || checklistCount || '><a href="javascript:void(0);" onclick="javascript:runJQueryPopWin(''Checklist'',''' || pObjSID || ''',''' || checklistSID || ''');"><img class="sf-menu-img" src="' || checklistImage || '">' || checklistLabel || '</a></li>';
               checklistCount := checklistCount + 1;
               
           end loop;

           SQLString := SQLString || '  </ul>';
           SQLString := SQLString || ' </li>';
           SQLString := SQLString || '</ul>';
           
         end if;
         
         return SQLString;

    END GetChecklistMenuHTML;    

    FUNCTION GetIAFISMenuHTML(pObjSID in varchar2, pObjTypeCode in varchar2) RETURN CLOB is    

      SQLString     CLOB;
            
    BEGIN
         SQLString := '<ul class="sf-menu">';
         SQLString := SQLString || ' <li id="ID_IAFIS" class="sf-li-top" ><a class="sf-with-ul-top" href="#"><img class="sf-menu-img" src="/i/themes/OSI/emailIAFIS_Package.gif">Email IAFIS Package</a>';
         SQLString := SQLString || '  <ul id="ID_IAFIS_MAIN">';
         
         SQLString := SQLString || '   <li id="ID_IAFIS1" ><a href="javascript:void(0);" onclick="javascript:sendRequest(''' || pObjSID || ''',''Criminal Inquiry'');"><img class="sf-menu-img" src="/i/themes/OSI/CriminalInquiry.gif">Criminal Inquiry</a></li>';
         SQLString := SQLString || '   <li id="ID_IAFIS2" ><a href="javascript:void(0);" onclick="javascript:sendRequest(''' || pObjSID || ''',''Criminal/Booking Submission'');"><img class="sf-menu-img" src="/i/themes/OSI/CriminalSubmission.gif">Criminal/Booking Submission</a></li>';
         SQLString := SQLString || '   <li id="ID_IAFIS3" ><a href="javascript:void(0);" onclick="javascript:sendRequest(''' || pObjSID || ''',''Criminal History'');"><img class="sf-menu-img" src="/i/themes/OSI/CriminalHistory.gif">Criminal History</a></li>';
         SQLString := SQLString || '   <li id="ID_IAFIS4" ><a href="javascript:void(0);" onclick="javascript:sendRequest(''' || pObjSID || ''',''Criminal/Booking History Update'');"><img class="sf-menu-img" src="/i/themes/OSI/CriminalHistoryUpdate.gif">Criminal/Booking History Update</a></li>';
         SQLString := SQLString || '   <li id="ID_IAFIS5" ><a href="javascript:void(0);" onclick="javascript:sendRequest(''' || pObjSID || ''',''Latent'');"><img class="sf-menu-img" src="/i/themes/OSI/Latent.gif">Latent</a></li>';
         SQLString := SQLString || '   <li id="ID_IAFIS6" ><a href="javascript:void(0);" onclick="javascript:sendRequest(''' || pObjSID || ''',''Search'');"><img class="sf-menu-img" src="/i/themes/OSI/Search.gif">Search</a></li>';
                  
         SQLString := SQLString || '  </ul>';
         SQLString := SQLString || ' </li>';
         SQLString := SQLString || '</ul>';

         return SQLString;

    END GetIAFISMenuHTML;    

    FUNCTION GetVersionsMenuHTML(pObjSID in varchar2, pObjTypeCode in varchar2, pObjContext in varchar2) RETURN CLOB is    

      SQLString     CLOB;
            
    BEGIN
         SQLString := '<ul class="sf-menu">';
         SQLString := SQLString || ' <li id="ID_VERSIONS" class="sf-li-top" ><a class="sf-with-ul-top" href="#"><img class="sf-menu-img" src="/i/themes/OSI/version16.gif">Versions</a>';
         SQLString := SQLString || '  <ul id="ID_VERSIONS_MAIN">';

         if (pObjContext = osi_participant.get_current_version(pObjSID) and osi_participant.is_confirmed(pObjSID) is not null) then         

           SQLString := SQLString || '   <li id="ID_VERSION1" ><a href="javascript:void(0);" onclick="javascript:addNote(''NEW_VERSION'',''ADD_VERSION'');"><img class="sf-menu-img" src="/i/themes/OSI/versionadd16.gif">Add</a></li>';

         end if;

         if (pObjContext = osi_participant.get_current_version(pObjSID) and osi_participant.get_previous_version(pObjContext) is not null) then         

           SQLString := SQLString || '   <li id="ID_VERSION2" ><a href="javascript:void(0);" onclick="javascript:doSubmit(''DELETE_VERSION'');"><img class="sf-menu-img" src="/i/themes/OSI/versiondelete16.gif">Delete</a></li>';
           
         end if;
         
         if osi_participant.get_next_version(pObjContext) is not null then

           SQLString := SQLString || '   <li id="ID_VERSION3" ><a href="javascript:void(0);" onclick="javascript:doSubmit(''NEXT_VERSION'');"><img class="sf-menu-img" src="/i/themes/OSI/versionnext16.gif">Next</a></li>';

         end if;
         
         if osi_participant.get_previous_version(pObjContext) is not null then
  
           SQLString := SQLString || '   <li id="ID_VERSION4" ><a href="javascript:void(0);" onclick="javascript:doSubmit(''PREVIOUS_VERSION'');"><img class="sf-menu-img" src="/i/themes/OSI/versionprevious16.gif">Previous</a></li>';

         end if;
         
         if (osi_participant.get_current_version(pObjSID) != pObjContext) then

           SQLString := SQLString || '   <li id="ID_VERSION5" ><a href="javascript:void(0);" onclick="javascript:doSubmit(''CURRENT_VERSION'');"><img class="sf-menu-img" src="/i/themes/OSI/version16.gif">Current</a></li>';

         end if;
                  
         SQLString := SQLString || '  </ul>';
         SQLString := SQLString || ' </li>';
         SQLString := SQLString || '</ul>';

         return SQLString;

    END GetVersionsMenuHTML;    
    
    FUNCTION GetReportMenuHTML(pObjSID in varchar2, pObjTypeCode in varchar2) RETURN CLOB is    

      SQLString        CLOB;
      reportButtons    CLOB;
      listCount        NUMBER;
      reportLabel      varchar2(1000);
      reportLink       varchar2(1000);
      reportImage      varchar2(1000);
      reportSID        varchar2(1000);
      reportCount      NUMBER := 1;
            
    BEGIN
         SQLString := '<ul class="sf-menu">';
         SQLString := SQLString || ' <li id="ID_REPORT" class="sf-li-top" ><a class="sf-with-ul-top" href="#"><img class="sf-menu-img" src="/i/themes/OSI/report16.gif">Reports</a>';
         SQLString := SQLString || '  <ul id="ID_REPORTS_MAIN">';
         
         --- Report Menu Items ---
         reportButtons := osi_util.get_report_links(pObjSID, '^~', 'Y');
         if (reportButtons='~') then
         
           SQLString := '';
           
         else

           for a in (select column_value from table(split(reportButtons,'^~')) where column_value is not null)
           loop

               listCount:=1;
               for b in (select column_value from table(split(a.column_value,'~')))
               loop
                   if (listCount=1) then
                 
                     --reportLabel := replace(b.column_value,'''','''''');
                     reportLabel := b.column_value;
                     
                   elsif (listCount=2) then

                        --reportLink := replace(b.column_value,'''','''''');
                        reportLink := b.column_value;

                   elsif (listCount=3) then

                        reportSID := b.column_value;
                        
                   end if;
                   listCount:=listCount+1;
                 
               end loop;
               reportImage := GetReportImage(reportLabel,reportSID);
               SQLString := SQLString || '   <li id="ID_STATUS"' || reportCount || '><a href="javascript:void(0);" onclick="' || reportLink || '"><img class="sf-menu-img" src="' || reportImage || '">' || reportLabel || '</a></li>';
               reportCount := reportCount + 1;
               
           end loop;

           SQLString := SQLString || '  </ul>';
           SQLString := SQLString || ' </li>';
           SQLString := SQLString || '</ul>';
           
         end if;
         
         return SQLString;

    END GetReportMenuHTML;    
    
    FUNCTION GetObjectMenusHTML(pObjSID in varchar2, pMenuToGet in varchar2, pObjContext in varchar2 := NULL) RETURN CLOB is    

      SQLString     CLOB;
      vObjTypeSID   varchar2(100);
      vObjTypeCode  varchar2(100);
            
    BEGIN
         vObjTypeSID := core_obj.get_objtype(pObjSID);
         vObjTypeCode := osi_object.get_objtype_code(vObjTypeSID);
         
         CASE UPPER(pMenuToGet)
         
                WHEN 'ACTIONS' THEN
                                   SQLString := GetActionsMenuHTML(pObjSid, vObjTypeCode, vObjTypeSID);

              WHEN 'CHECKLIST' THEN
                                   SQLString := GetChecklistMenuHTML(pObjSid, vObjTypeCode);

                  WHEN 'IAFIS' THEN
                                   SQLString := GetIAFISMenuHTML(pObjSid, vObjTypeCode);

                 WHEN 'REPORT' THEN
                                   SQLString := GetReportMenuHTML(pObjSid, vObjTypeCode);

                 WHEN 'STATUS' THEN
                                   SQLString := GetActionsMenuHTML(pObjSid, vObjTypeCode, vObjTypeSID);
         
               WHEN 'VERSIONS' THEN
                                   SQLString := GetVersionsMenuHTML(pObjSid, vObjTypeCode, pObjContext);

         END CASE; 
         
         return SQLString;

    END GetObjectMenusHTML;
        
END Osi_Menu;
/
