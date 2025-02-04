SET DEFINE OFF;

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
    30-Aug-2012 Tim Ward       Added support for Evidence Actions and Report Menus.
                               Made Masking and Classify use jQuery Dialog instead of browser pop-up.
                                Changed in getactionsmenuhtml.
    09-Jan-2013 Tim Ward       CR#4224 - Changed addNote to runJQueryPopWin.
                               This change and putting page 700 back in fixes Participant Add Version.
                                Changed in getactionsmenuhtml.
                                       
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
         if (pObjSID is not null and pObjTypeCode!='EVIDENCE') then
       
           SQLString := SQLString || '   <li id="ID_STATUS1"><a href="javascript:void(0);" onclick="javascript:deleteObj(''' || pObjSID || ''',''DELETE_OBJECT'');"><img class="sf-menu-img" src="/i/themes/OSI/delete16.gif">Delete</a></li>';
           
         end if;

         --- Evidence ONLY Related Menu Items ---
         if (pObjTypeCode='EVIDENCE') then
           
           begin
                select status into status from v_osi_evidence where sid=pObjSID;
           exception when others then
           
                    status := null;
           end;

           if (status='New Entry') then         

             SQLString := SQLString || '   <li id="ID_STATUSC1"><a href="javascript:void(0);" onclick="javascript:submitEvidence(''' || pObjSID || ''',''' || 'SUBMIT_TO_CUSTODIAN' || ''',''' || 'Submit to Custodian' || ''');"><img class="sf-menu-img" src="/i/themes/OSI/submitforapproveclose16.gif">Submit Evidence</a></li>';

           end if;

           if (status='Submitted to Custodian') then         

             SQLString := SQLString || '   <li id="ID_STATUSC2"><a href="javascript:void(0);" onclick="javascript:submitEvidence(''' || pObjSID || ''',''' || 'RECALL_FROM_CUSTODIAN' || ''',''' || 'Recall Evidence' || ''');"><img class="sf-menu-img" src="/i/themes/OSI/recallsubmission16.gif">Recall Evidence</a></li>';

           end if;
           
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
         if (CORE_UTIL.GET_CONFIG('OSI.ALLOW_CLASSIFICATIONS')='Y' AND pObjTypeCode NOT IN ('CFUNDS_ADV','CFUNDS_EXP','PERSONNEL','EVIDENCE')) then         

           SQLString := SQLString || '   <li id="ID_STATUS7"><a href="javascript:void(0);" onclick="javascript:runJQueryPopWin(''Classification'',''P0_OBJ,P0_OBJ_CONTEXT,P765_OBJ,P765_CONTEXT'',''' || pObjSID || ',,' || pObjSID || ','',''765'',0,0,''CLASSIFICATION'');"><img class="sf-menu-img" src="/i/themes/OSI/classify16.gif">Classify</a></li>';
           
         end if;
         
         --- Masking Menu Item ---
         if (pObjTypeCode in ('ACT.INTERVIEW.WITNESS','ACT.SOURCE_MEET','ACT.SURVEILLANCE')) then

           SQLString := SQLString || '   <li id="ID_STATUS7"><a href="javascript:void(0);" onclick="javascript:runJQueryPopWin(''Masking'',''P0_OBJ,P0_OBJ_CONTEXT,P760_OBJ'',''' || pObjSID || ',,' || pObjSID || ''',''760'',500,300,''MASK'');"><img class="sf-menu-img" src="/i/themes/OSI/masking16.gif">Masking</a></li>';

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

           SQLString := SQLString || '   <li id="ID_VERSION1" ><a href="javascript:void(0);" onclick="javascript:runJQueryPopWin(''Add Note'',''P700_NOTE_CODE,P700_REQUEST'',''NEW_VERSION,ADD_VERSION'',''700'',500,300,''ADD_VERSION'');"><img class="sf-menu-img" src="/i/themes/OSI/versionadd16.gif">Add</a></li>';
 

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
--   Date and Time:   06:56 Wednesday January 9, 2013
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

PROMPT ...Remove page 700
 
begin
 
wwv_flow_api.remove_page (p_flow_id=>wwv_flow.g_flow_id, p_page_id=>700);
 
end;
/

 
--application/pages/page_00700
prompt  ...PAGE 700: Popup Required Note
--
 
begin
 
declare
    h varchar2(32767) := null;
    ph varchar2(32767) := null;
begin
h := null;
ph:=ph||'<script language="JavaScript">'||chr(10)||
'if ("&REQUEST."=="CREATE")'||chr(10)||
'{'||chr(10)||
' window.parent.doSubmit(''&P700_REQUEST.'');'||chr(10)||
' closeDialog();'||chr(10)||
'}'||chr(10)||
'</script>';

wwv_flow_api.create_page(
  p_id     => 700,
  p_flow_id=> wwv_flow.g_flow_id,
  p_tab_set=> '',
  p_name   => 'Popup Required Note',
  p_step_title=> 'Required Note',
  p_step_sub_title_type => 'TEXT_WITH_SUBSTITUTIONS',
  p_first_item=> 'NO_FIRST_ITEM',
  p_include_apex_css_js_yn=>'Y',
  p_autocomplete_on_off => 'ON',
  p_group_id => 88817126738005514+ wwv_flow_api.g_id_offset,
  p_help_text => '',
  p_html_page_header => ' ',
  p_step_template => 179215770461554476+ wwv_flow_api.g_id_offset,
  p_required_patch=> null + wwv_flow_api.g_id_offset,
  p_last_updated_by => 'TWARD',
  p_last_upd_yyyymmddhh24miss => '20130109065636',
  p_page_is_public_y_n=> 'N',
  p_protection_level=> 'N',
  p_page_comment  => '09-Jan-2013 - Tim Ward - Changed to support jQuery Dialog Window.  This screen'||chr(10)||
'                          is currently only used by Participant Add Version.');
 
wwv_flow_api.set_html_page_header(p_flow_id=>wwv_flow.g_flow_id,p_flow_step_id=>700,p_text=>ph);
end;
 
end;
/

declare
  s varchar2(32767) := null;
  l_clob clob;
  l_length number := 1;
begin
s := null;
wwv_flow_api.create_page_plug (
  p_id=> 17367607386227356 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_page_id=> 700,
  p_plug_name=> 'Access Denied',
  p_region_name=>'',
  p_plug_template=> 179216655889554481+ wwv_flow_api.g_id_offset,
  p_plug_display_sequence=> 20,
  p_plug_display_column=> 1,
  p_plug_display_point=> 'AFTER_SHOW_ITEMS',
  p_plug_source=> s,
  p_plug_source_type=> 'STATIC_TEXT',
  p_translate_title=> 'Y',
  p_plug_display_error_message=> '#SQLERRM#',
  p_plug_query_row_template=> 1,
  p_plug_query_headings_type=> 'QUERY_COLUMNS',
  p_plug_query_num_rows => 15,
  p_plug_query_num_rows_type => 'NEXT_PREVIOUS_LINKS',
  p_plug_query_row_count_max => 500,
  p_plug_query_show_nulls_as => ' - ',
  p_plug_display_condition_type => 'PLSQL_EXPRESSION',
  p_plug_display_when_condition => ':P700_REQUEST = ''ADD_VERSION'''||chr(10)||
'and'||chr(10)||
'osi_participant.details_are_editable(:P0_OBJ, :user_sid) <> ''Y''',
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
s := null;
wwv_flow_api.create_page_plug (
  p_id=> 100088719806637464 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_page_id=> 700,
  p_plug_name=> 'Required Note',
  p_region_name=>'',
  p_plug_template=> 179216655889554481+ wwv_flow_api.g_id_offset,
  p_plug_display_sequence=> 10,
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
  p_plug_display_when_condition => '(:P700_REQUEST = ''ADD_VERSION'''||chr(10)||
'and'||chr(10)||
'osi_participant.details_are_editable(:P0_OBJ, :user_sid) = ''Y'')'||chr(10)||
'or'||chr(10)||
':P700_REQUEST <> ''ADD_VERSION''',
  p_pagination_display_position=>'BOTTOM_RIGHT',
  p_plug_customized=>'0',
  p_plug_caching=> 'NOT_CACHED',
  p_plug_comment=> '');
end;
/
 
begin
 
wwv_flow_api.create_page_button(
  p_id             => 100089519244646703 + wwv_flow_api.g_id_offset,
  p_flow_id        => wwv_flow.g_flow_id,
  p_flow_step_id   => 700,
  p_button_sequence=> 10,
  p_button_plug_id => 100088719806637464+wwv_flow_api.g_id_offset,
  p_button_name    => 'CREATE',
  p_button_image   => 'template:'||to_char(179221063608554498+wwv_flow_api.g_id_offset),
  p_button_image_alt=> '&BTN_CREATE.',
  p_button_position=> 'REGION_TEMPLATE_CHANGE',
  p_button_alignment=> 'RIGHT',
  p_button_redirect_url=> '',
  p_required_patch => null + wwv_flow_api.g_id_offset);
 
wwv_flow_api.create_page_button(
  p_id             => 17368006825236642 + wwv_flow_api.g_id_offset,
  p_flow_id        => wwv_flow.g_flow_id,
  p_flow_step_id   => 700,
  p_button_sequence=> 30,
  p_button_plug_id => 17367607386227356+wwv_flow_api.g_id_offset,
  p_button_name    => 'BTN_CANCEL',
  p_button_image   => 'template:'||to_char(179221063608554498+wwv_flow_api.g_id_offset),
  p_button_image_alt=> '&BTN_CANCEL.',
  p_button_position=> 'REGION_TEMPLATE_CREATE',
  p_button_alignment=> 'RIGHT',
  p_button_redirect_url=> 'javascript:closeDialog(); ',
  p_required_patch => null + wwv_flow_api.g_id_offset);
 
wwv_flow_api.create_page_button(
  p_id             => 100089734135651060 + wwv_flow_api.g_id_offset,
  p_flow_id        => wwv_flow.g_flow_id,
  p_flow_step_id   => 700,
  p_button_sequence=> 20,
  p_button_plug_id => 100088719806637464+wwv_flow_api.g_id_offset,
  p_button_name    => 'CANCEL',
  p_button_image   => 'template:'||to_char(179221063608554498+wwv_flow_api.g_id_offset),
  p_button_image_alt=> '&BTN_CANCEL.',
  p_button_position=> 'REGION_TEMPLATE_PREVIOUS',
  p_button_alignment=> 'RIGHT',
  p_button_redirect_url=> 'javascript:closeDialog();',
  p_required_patch => null + wwv_flow_api.g_id_offset);
 
 
end;
/

 
begin
 
wwv_flow_api.create_page_branch(
  p_id=>100120228275576695 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 700,
  p_branch_action=> 'f?p=&APP_ID.:700:&SESSION.:&REQUEST.:&DEBUG.:::',
  p_branch_point=> 'AFTER_PROCESSING',
  p_branch_type=> 'REDIRECT_URL',
  p_branch_sequence=> 10,
  p_save_state_before_branch_yn=>'N',
  p_branch_comment=> 'Created 12-OCT-2009 15:22 by THOMAS');
 
 
end;
/

declare
    h varchar2(32767) := null;
begin
wwv_flow_api.create_page_item(
  p_id=>17367923316231896 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 700,
  p_name=>'P700_ACCESS_DENIED',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 115,
  p_item_plug_id => 17367607386227356+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'YES',
  p_item_default_type => 'STATIC_TEXT_WITH_SUBSTITUTIONS',
  p_prompt=>'Access Denied',
  p_source=>'You do not have permission to add a new version to this participant.',
  p_source_type=> 'STATIC',
  p_display_as=> 'DISPLAY_ONLY_HTML',
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
  p_field_template => 179220853378554498+wwv_flow_api.g_id_offset,
  p_is_persistent=> 'Y',
  p_item_comment => '');
 
 
end;
/

declare
    h varchar2(32767) := null;
begin
wwv_flow_api.create_page_item(
  p_id=>100088034566632229 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 700,
  p_name=>'P700_OBJ_TYPE',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 10,
  p_item_plug_id => 100088719806637464+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'YES',
  p_item_default_type => 'STATIC_TEXT_WITH_SUBSTITUTIONS',
  p_source_type=> 'STATIC',
  p_display_as=> 'HIDDEN',
  p_lov_columns=> 1,
  p_lov_display_null=> 'NO',
  p_lov_translated=> 'N',
  p_cSize=> 30,
  p_cMaxlength=> 4000,
  p_cHeight=> 1,
  p_cAttributes=> 'nowrap',
  p_begin_on_new_line => 'NO',
  p_begin_on_new_field=> 'NO',
  p_colspan => 1,
  p_rowspan => 1,
  p_label_alignment  => 'RIGHT',
  p_field_alignment  => 'LEFT',
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
  p_id=>100088228673632229 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 700,
  p_name=>'P700_NOTE_TYPE',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 15,
  p_item_plug_id => 100088719806637464+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'YES',
  p_item_default_type => 'STATIC_TEXT_WITH_SUBSTITUTIONS',
  p_source=>'NOTE_TYPE',
  p_source_type=> 'DB_COLUMN',
  p_display_as=> 'HIDDEN',
  p_lov_columns=> 1,
  p_lov_display_null=> 'NO',
  p_lov_translated=> 'N',
  p_cSize=> 30,
  p_cMaxlength=> 4000,
  p_cHeight=> 1,
  p_cAttributes=> 'nowrap',
  p_begin_on_new_line => 'NO',
  p_begin_on_new_field=> 'NO',
  p_colspan => 1,
  p_rowspan => 1,
  p_label_alignment  => 'RIGHT',
  p_field_alignment  => 'LEFT',
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
  p_id=>100088426849632231 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 700,
  p_name=>'P700_TEXT_LABEL',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 100,
  p_item_plug_id => 100088719806637464+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'YES',
  p_item_default_type => 'STATIC_TEXT_WITH_SUBSTITUTIONS',
  p_source=>'select description from t_osi_note_type where sid = :p700_note_type',
  p_source_type=> 'QUERY',
  p_display_as=> 'DISPLAY_ONLY_HTML',
  p_lov_columns=> 1,
  p_lov_display_null=> 'NO',
  p_lov_translated=> 'N',
  p_cSize=> 30,
  p_cMaxlength=> 4000,
  p_cHeight=> 1,
  p_cAttributes=> 'nowrap',
  p_begin_on_new_line => 'YES',
  p_begin_on_new_field=> 'YES',
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

declare
    h varchar2(32767) := null;
begin
wwv_flow_api.create_page_item(
  p_id=>100088628469632232 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 700,
  p_name=>'P700_TEXT',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 105,
  p_item_plug_id => 100088719806637464+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'YES',
  p_item_default_type => 'STATIC_TEXT_WITH_SUBSTITUTIONS',
  p_source=>'NOTE_TEXT',
  p_source_type=> 'DB_COLUMN',
  p_display_as=> 'TEXTAREA_CHAR_COUNT',
  p_lov_columns=> 1,
  p_lov_display_null=> 'NO',
  p_lov_translated=> 'N',
  p_cSize=> 60,
  p_cMaxlength=> 30000,
  p_cHeight=> 5,
  p_cAttributes=> 'nowrap',
  p_begin_on_new_line => 'YES',
  p_begin_on_new_field=> 'YES',
  p_colspan => 1,
  p_rowspan => 1,
  p_label_alignment  => 'LEFT-TOP',
  p_field_alignment  => 'LEFT',
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
  p_id=>100090631972669278 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 700,
  p_name=>'P700_REQUEST',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 20,
  p_item_plug_id => 100088719806637464+wwv_flow_api.g_id_offset,
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

declare
    h varchar2(32767) := null;
begin
wwv_flow_api.create_page_item(
  p_id=>100095627807942542 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 700,
  p_name=>'P700_OBJ',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 5,
  p_item_plug_id => 100088719806637464+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'YES',
  p_item_default_type => 'STATIC_TEXT_WITH_SUBSTITUTIONS',
  p_source=>'OBJ',
  p_source_type=> 'DB_COLUMN',
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

declare
    h varchar2(32767) := null;
begin
wwv_flow_api.create_page_item(
  p_id=>100103038374983465 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 700,
  p_name=>'P700_NOTE_CODE',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 25,
  p_item_plug_id => 100088719806637464+wwv_flow_api.g_id_offset,
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

declare
    h varchar2(32767) := null;
begin
wwv_flow_api.create_page_item(
  p_id=>100120816285582668 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 700,
  p_name=>'P700_SID',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 1,
  p_item_plug_id => 100088719806637464+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'NO',
  p_item_default_type => 'STATIC_TEXT_WITH_SUBSTITUTIONS',
  p_source=>'SID',
  p_source_type=> 'DB_COLUMN',
  p_display_as=> 'HIDDEN',
  p_lov_columns=> 1,
  p_lov_display_null=> 'NO',
  p_lov_translated=> 'N',
  p_cSize=> null,
  p_cMaxlength=> 2000,
  p_cHeight=> null,
  p_cAttributes=> 'nowrap="nowrap"',
  p_begin_on_new_line => 'NO',
  p_begin_on_new_field=> 'NO',
  p_colspan => 1,
  p_rowspan => 1,
  p_label_alignment  => 'LEFT',
  p_field_alignment  => 'LEFT',
  p_is_persistent=> 'Y',
  p_item_comment => '');
 
 
end;
/

 
begin
 
wwv_flow_api.create_page_validation(
  p_id => 100117232899511778 + wwv_flow_api.g_id_offset,
  p_flow_id => wwv_flow.g_flow_id,
  p_flow_step_id => 700,
  p_validation_name => 'P700_TEXT',
  p_validation_sequence=> 10,
  p_validation => 'P700_TEXT',
  p_validation_type => 'ITEM_NOT_NULL',
  p_error_message => 'Note text must be specified.',
  p_validation_condition=> 'CREATE',
  p_validation_condition_type=> 'REQUEST_EQUALS_CONDITION',
  p_associated_item=> 100088628469632232 + wwv_flow_api.g_id_offset,
  p_error_display_location=>'INLINE_IN_NOTIFICATION',
  p_validation_comment=> '');
 
null;
 
end;
/

 
begin
 
wwv_flow_api.create_page_validation(
  p_id => 100124809630675356 + wwv_flow_api.g_id_offset,
  p_flow_id => wwv_flow.g_flow_id,
  p_flow_step_id => 700,
  p_validation_name => 'Note length',
  p_validation_sequence=> 20,
  p_validation => 'length(:p700_text) > 6',
  p_validation_type => 'PLSQL_EXPRESSION',
  p_error_message => 'Note text must be longer than six characters.',
  p_validation_condition=> 'CREATE',
  p_validation_condition_type=> 'REQUEST_EQUALS_CONDITION',
  p_associated_item=> 100088628469632232 + wwv_flow_api.g_id_offset,
  p_error_display_location=>'INLINE_IN_NOTIFICATION',
  p_validation_comment=> '');
 
null;
 
end;
/

 
begin
 
declare
  p varchar2(32767) := null;
  l_clob clob;
  l_length number := 1;
begin
p:=p||'#OWNER#:T_OSI_NOTE:P700_SID:SID|I';

wwv_flow_api.create_page_process(
  p_id     => 100119919964574228 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id => 700,
  p_process_sequence=> 10,
  p_process_point=> 'AFTER_SUBMIT',
  p_process_type=> 'DML_PROCESS_ROW',
  p_process_name=> 'Save T_OSI_NOTE',
  p_process_sql_clob => p, 
  p_process_error_message=> '',
  p_process_when=>'CREATE',
  p_process_when_type=>'REQUEST_EQUALS_CONDITION',
  p_process_success_message=> '',
  p_process_is_stateful_y_n=>'N',
  p_return_key_into_item1=>'P700_SID',
  p_process_comment=>'');
end;
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
'    :p700_obj := :p0_obj;'||chr(10)||
'    :p700_obj_type := :p0_obj_type_sid;'||chr(10)||
''||chr(10)||
'    select sid'||chr(10)||
'      into :p700_note_type'||chr(10)||
'      from t_osi_note_type'||chr(10)||
'     where obj_type member of osi_object.get_objtypes(:p700_obj_type)'||chr(10)||
'       and code = :p700_note_code'||chr(10)||
'       and usage = ''NOTELIST'';'||chr(10)||
'end;';

wwv_flow_api.create_page_process(
  p_id     => 100103428116989967 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id => 700,
  p_process_sequence=> 10,
  p_process_point=> 'BEFORE_HEADER',
  p_process_type=> 'PLSQL',
  p_process_name=> 'Setup',
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
-- ...updatable report columns for page 700
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




