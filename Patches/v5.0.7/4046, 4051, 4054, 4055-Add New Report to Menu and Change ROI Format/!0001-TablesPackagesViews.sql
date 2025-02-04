update t_osi_report_type set active='N' where sid='222011CF';
COMMIT;


update t_osi_report_type set description='ROI (previous version)' where sid='22200000ZLJ';
COMMIT;


INSERT INTO T_OSI_REPORT_TYPE ( SID, OBJ_TYPE, DESCRIPTION, PICK_DATES, PICK_NARRATIVES, PICK_NOTES, PICK_CAVEATS, PICK_DISTS, PICK_CLASSIFICATION, PICK_ATTACHMENT, PICK_PURPOSE, PICK_DISTRIBUTION, PICK_IGCODE, PICK_STATUS, SPECIAL_PROCESSING, ACTIVE, SEQ, CREATE_BY, CREATE_ON, MODIFY_BY, MODIFY_ON, PACKAGE_FUNCTION, DISABLED_STATUS, MIME_TYPE, IMAGE ) VALUES ( '33318UYA', '22200000AJI', 'ROI', 'N', 'N', 'N', 'N', 'N', 'N', 'N', 'N', 'N', 'N', 'N', NULL, 'Y', 4.9, 'timothy.ward',  TO_Date( '08/03/2012 11:07:20 AM', 'MM/DD/YYYY HH:MI:SS AM'), 'timothy.ward',  TO_Date( '08/13/2012 08:19:20 AM', 'MM/DD/YYYY HH:MI:SS AM'), '840', NULL, '22200000P36', 'th_new2_e0.gif'); 
INSERT INTO T_OSI_REPORT_TYPE ( SID, OBJ_TYPE, DESCRIPTION, PICK_DATES, PICK_NARRATIVES, PICK_NOTES, PICK_CAVEATS, PICK_DISTS, PICK_CLASSIFICATION, PICK_ATTACHMENT, PICK_PURPOSE, PICK_DISTRIBUTION, PICK_IGCODE, PICK_STATUS, SPECIAL_PROCESSING, ACTIVE, SEQ, CREATE_BY, CREATE_ON, MODIFY_BY, MODIFY_ON, PACKAGE_FUNCTION, DISABLED_STATUS, MIME_TYPE, IMAGE ) VALUES ( '33318VSP', '22200000AJI', 'ROI_NEW - HIDDEN FROM REPORTS MENU', 'N', 'N', 'N', 'N', 'N', 'N', 'N', 'N', 'N', 'N', 'N', NULL, 'N', 4.9, 'timothy.ward',  TO_Date( '08/13/2012 09:23:08 AM', 'MM/DD/YYYY HH:MI:SS AM'), 'timothy.ward',  TO_Date( '08/13/2012 09:23:55 AM', 'MM/DD/YYYY HH:MI:SS AM'), 'OSI_INVESTIGATION.CASE_ROI_NEW', NULL, '22200000P36', 'th_new2_e0.gif'); 
COMMIT;
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
INSERT INTO T_CORE_TEMPLATE ( SID, TEMPLATE_NAME, TEMPLATE_INFO, MIME_TYPE, MIME_DISPOSITION, CREATE_BY, CREATE_ON, MODIFY_BY, MODIFY_ON ) VALUES ( '33318VEM', 'ROI_NEW', NULL, NULL, 'ATTACHMENT', 'timothy.ward',  TO_Date( '08/08/2012 07:04:54 AM', 'MM/DD/YYYY HH:MI:SS AM'), 'timothy.ward',  TO_Date( '08/08/2012 07:04:54 AM', 'MM/DD/YYYY HH:MI:SS AM')); 
COMMIT;

-- "Set define off" turns off substitution variables. 
Set define off; 

CREATE OR REPLACE PACKAGE "OSI_INVESTIGATION" as
/******************************************************************************
   name:     osi_investigation
   purpose:  provides functionality for investigative case file objects.

   revisions:
    date        author          description
    ----------  --------------  ------------------------------------
     7-apr-2009 t.mcguffin      created package
    30-jun-2009 t.mcguffin      added create_instance function.
    30-jul-2009 t.mcguffin      added next_incident_id function.
    13-Aug-2009 t.mcguffin      added get_aah_circumstances, get_ajh_circumstances, get_crim_activity,
                                get_vic_injuries, set_aah_circumstances, set_ajh_circumstances,
                                set_crim_activity and set_vic_injuries proc/functions.
    17-Sep-2009 t.mcguffin      added get_inv_dispositions and set_inv_dispositions.
    30-Sep-2009 t.mcguffin      added get_special_interest and set_special_interest proc/functions.
    30-Sep-2009 t.mcguffin      added get_notify_units and set_notify_units proc/functions.
    30-Sep-2009 t.mcguffin      added get_primary_offense, get_days_to_run and get_timeliness_date functions.
     2-Oct-2009 t.mcguffin      added get_full_id function
     7-Oct-2009 t.mcguffin      added clone_to_case function

     2-Nov-2009 t.whitehead     Moved get/set_special_interest to osi_object.
    20-Jan-2010 t.mcguffin      added check_writability
    31-Mar-2010 t.mcguffin      added get_final_roi_date.
    09-Apr-2010 J.Horne         Changed name of get_full_id to generate_full_id to better identify
                                what the function does.
    13-May-2010 J.Horne         Updated create_instance so that it will allow a user to add an offense,
                                subject, victim and summary when creating a new investigation. When offense,
                                subject and victim are all present, an incident and specification will also be created.
    19-May-2010 J.Horne         Updated create_instance to put in default background (summary allegation) info.
    25-May-2010 T.Leighty       Added make_doc_investigative_file.
    28-May-2010 J.Horne         Added summary_complaint_rpt, get_basic_info, participantname, getsubjectofactivity,
                                load_activity, get_assignments, get_f40_place, get_f40_date, roi_toc_interview, roi_toc_docreview,
                                roi_toc_consultation, roi_toc_search, roi_toc_sourcemeet, roi_toc, roi_header_interview,
                                roi_header_docreview, roi_header_consultation, roi_header_search, roi_header_sourcemeet,
                                roi_header_incidental_int, roi_header_default, roi_header, cleanup_temp_clob
    07-Jun-2010 J.Horne         Added roi_group, roi_group_header, roi_toc_order, roi_group, roi_group_order
    09-Jun-2010 J.Horne         Added case_roi, get_subject_list, get_victim_list, roi_block, get_owning_unit_cdr, get_cavaets_list,
                                get_sel_activity, get_evidence_list, get_idp_notes, get_act_exhibit
    11-Jun-2010 J.Horne         Added case_status_report
    14-Jun-2010 J.Horne         Added letter_of_notifcation, case_subjectvictimwitnesslist, getpersonnelphone, getunitphone, idp_notes_report,
                                form_40_roi, getparticipantphone
    24-Jun-2010 J.Faris         Added genericfile_report, get_attachment_list, get_objectives_list; Generic File report functions included
                                in this package because of common support functions and private variables
    25-Jun-2010 J.Horne         Fixed issue with case_subjectwitnessvictimlist; SSNs were duplicating.
    01-Jul-2010 J.Horne         Removed links from summary_complaint_rpt.
    18-Aug-2010 Tim Ward        CR#299 - WebI2MS Missing Narrative Preview.
                                 Added activity_narrative_preview.
    07-Jan-2011 Tim Ward        Moved get_assignments from here to OSI_REPORT.
    30-Jun-2011  Tim Ward       CR#3566 - Allow Picking of Subjects when Creating Case from Developmental.
                                  Changed clone_to_case.
    07-Jul-2011  Tim Ward       CR#3571 - Add Matters Investigated (Offenses) to Initial Notification.
                                  Added auto_load_specs.
    07-Nov-2011 Tim Ward        CR#3918 - Check for Valid Offense Combinations when adding specs.
                                 Changed auto_load_specs.
    02-Apr-2012 Tim Ward        CR#3923 - Name displaying LN, FN MN instead of FN MN LN on ROI and SCR.
                                 Added parameter get_basic_info that gets passed to get_name.
    13-Aug-2012 Tim Ward        CR#4055 - New Form 40 ROI Changes.
                                 Added case_roi_new and roi_get_print_html functions.
                                 
******************************************************************************/
    function get_tagline(p_obj in varchar2)
        return varchar2;

    function get_summary(p_obj in varchar2, p_variant in varchar2 := null)
        return clob;

    procedure index1(p_obj in varchar2, p_clob in out nocopy clob);

    function get_status(p_obj in varchar2)
        return varchar2;

    function create_instance(
        p_obj_type      in   varchar2,
        p_title         in   varchar2,
        p_restriction   in   varchar2,
        p_offense       in   varchar2,
        p_subject       in   varchar2,
        p_victim        in   varchar2,
        p_sum_inv       in   clob)
        return varchar2;

    -- gets the next available incident id from a sequence
    function next_incident_id
        return varchar2;

    -- builds a colon-delimited list of aah_circumstances (sids) for a given specification.
    function get_aah_circumstances(p_spec_sid in varchar2)
        return varchar2;

    -- builds a colon-delimited list of ajh_circumstances (sids) for a given specification.
    function get_ajh_circumstances(p_spec_sid in varchar2)
        return varchar2;

    -- builds a colon-delimited list of criminal activities (sids) for a given specification.
    function get_crim_activity(p_spec_sid in varchar2)
        return varchar2;

    -- builds a colon-delimited list of victim injuries (sids) for a given specification.
    function get_vic_injuries(p_spec_sid in varchar2)
        return varchar2;

    -- takes in a colon-delimited list of aah circumstances (sids) for a given specification
    -- and parses through inserting/updating/deleting the updates into the database;
    procedure set_aah_circumstances(p_spec_sid in varchar2, p_aah in varchar2);

    -- takes in a colon-delimited list of ajh circumstances (sids) for a given specification
    -- and parses through inserting/updating/deleting the updates into the database;
    procedure set_ajh_circumstances(p_spec_sid in varchar2, p_ajh in varchar2);

    -- takes in a colon-delimited list of criminal activities (sids) for a given specification
    -- and parses through inserting/updating/deleting the updates into the database;
    procedure set_crim_activity(p_spec_sid in varchar2, p_crim_act in varchar2);

    -- takes in a colon-delimited list of victim injuries (sids) for a given specification
    -- and parses through inserting/updating/deleting the updates into the database;
    procedure set_vic_injuries(p_spec_sid in varchar2, p_injuries in varchar2);

    -- builds a colon-delimited list of dispositions (sids) for the given investigation.
    function get_inv_dispositions(p_sid in varchar2)
        return varchar2;

    -- takes in a colon-delimited list of dispositions (sids) for a given investigation
    -- and parses through inserting/updating/deleting the updates into the database;
    procedure set_inv_dispositions(p_sid in varchar2, p_dispositions in varchar2);

    -- builds a colon-delimited list of units to notify (sids) for a given investigation.
    function get_notify_units(p_sid in varchar2)
        return varchar2;

    -- takes in a colon-delimited list of units to notify (sids) for a given investigation
    -- and parses through inserting/updating/deleting the updates into the database;
    procedure set_notify_units(p_sid in varchar2, p_notify_units in varchar2);

    -- returns the primary offense sid for an investigation
    function get_primary_offense(p_sid in varchar2)
        return varchar2;

    -- returns the number of days to run (used to calc timeliness date) for an investigation.
    function get_days_to_run(p_sid in varchar2)
        return number;

    -- returns the suspense or timeliness date for an investigation.
    function get_timeliness_date(p_sid in varchar2)
        return date;

    -- used to populate the full_id field in t_osi_file when appropriate.
    function generate_full_id(p_sid in varchar2)
        return varchar2;

    -- creates clone case file from another type of investigation
    function clone_to_case(p_sid in varchar2, p_parameter1 in varchar2 := null, p_parameter2 in varchar2 := null)
        return varchar2;

    --called when user changes the investigative subtype.  deletes case-specific data.
    procedure change_inv_type(p_sid in varchar2, p_new_type in varchar2);

    -- returns Y if the input object is writable (not read-only)
    function check_writability(p_obj in varchar2, p_obj_context in varchar2)
        return varchar2;

    -- if the input investigation has a Final ROI attached, will return the create_on date.
    function get_final_roi_date(p_obj varchar2)
        return date;

-- function summary_complaint_report(psid in varchar2)
--        return clob;

    --  Produces the html document for the investigative file report.
    procedure make_doc_investigative_file(p_sid in varchar2, p_doc in out nocopy clob);

    function summary_complaint_rpt(psid in varchar2)
        return clob;

    procedure get_basic_info(
        ppopv            in       varchar2,
        presult          out      varchar2,
        psaa             out      varchar2,
        pper             out      varchar2,
        pincludename     in       boolean := true,
        pnameonly        in       boolean := false,
        pincludemaiden   in       boolean := true,
        pincludeaka      in       boolean := true,
        plnfirst         in       varchar2 := 'Y');

    function get_org_info(ppopv in varchar2, preplacenullwithunk in boolean := false)
        return varchar2;

    procedure load_activity(psid in varchar2);

    function get_f40_place(p_obj in varchar2)
        return varchar2;

    function get_f40_date(psid in varchar2)
        return date;

    function roi_toc_interview
        return varchar2;

    function roi_toc_docreview
        return varchar2;

    function roi_toc_consultation
        return varchar2;

    function roi_toc_sourcemeet
        return varchar2;

    function roi_toc_search
        return varchar2;

    function roi_toc(psid in varchar2)
        return varchar2;

    function roi_header_interview(preturntable in varchar2 := 'N')
        return clob;

    function roi_header_incidental_int(preturntable in varchar2 := 'N')
        return clob;

    function roi_header_docreview(preturntable in varchar2 := 'N')
        return clob;

    function roi_header_consultation(preturntable in varchar2 := 'N')
        return clob;

    function roi_header_sourcemeet(preturntable in varchar2 := 'N')
        return clob;

    function roi_header_search(preturntable in varchar2 := 'N')
        return clob;

    function roi_header_default(preturntable in varchar2 := 'N')
        return clob;

    function roi_group(psid in varchar2)
        return varchar2;

    function roi_group_order(psid in varchar2)
        return varchar2;

    function roi_toc_order(psid in varchar2)
        return varchar2;

    function roi_narrative(psid in varchar2)
        return clob;

    function roi_block(ppopv in varchar2)
        return varchar2;

    function roi_header(psid in varchar2, preturntable in varchar2 := 'N')
        return clob;

    function case_roi(psid in varchar2)
        return clob;

    function case_roi_new(psid in varchar2)
        return clob;

    function get_subject_list
        return varchar2;

    function get_victim_list
        return varchar2;

    function get_owning_unit_cdr
        return varchar2;

    function get_caveats_list
        return varchar2;

    procedure get_sel_activity(pspecsid in varchar2);

    procedure get_evidence_list(pparentsid in varchar2, pspecsid in varchar2);

    procedure get_idp_notes(pspecsid in varchar2, pfontsize in varchar2 := '20');

    function get_act_exhibit(pactivitysid in varchar2)
        return varchar2;

    function case_status_report(psid in varchar2)
        return clob;

    function letter_of_notification(psid in varchar2)
        return clob;

    function getpersonnelphone(psid in varchar2, onlygetthistype in varchar2 := null)
        return varchar2;

    function getparticipantphone(psid in varchar2, onlygetthistype in varchar2 := null)
        return varchar2;

    function getunitphone(psid in varchar2, onlygetthistype in varchar2 := null)
        return varchar2;

    function case_subjectvictimwitnesslist(psid in varchar2)
        return clob;

    function idp_notes_report(psid in varchar2)
        return clob;

    function form_40_roi(psid in varchar2)
        return clob;

    /* Generic File report functions, included in this package because of common support functions and private variables */
    function genericfile_report(p_obj in varchar2)
        return clob;

    function get_attachment_list(p_obj in varchar2)
        return varchar2;

    procedure get_objectives_list(p_obj in varchar2);

    function Activity_Narrative_Preview(pSID in Varchar2, htmlorrtf IN VARCHAR2 := 'HTML')
        return Clob;

    procedure auto_load_specs(p_obj in varchar2, p_list out varchar2, p_send_first_back varchar2 := 'N');

    function roi_get_print_html(p_obj in varchar2, pHTML1 out clob, pHTML2 out clob, pHTML3 out clob, pHTML4 out clob, pHTML5 out clob, pHTML6 out clob, pHTML7 out clob, pHTML8 out clob, pHTML9 out clob, pHTML10 out clob) return varchar2;
            
end osi_investigation;
/


CREATE OR REPLACE package body osi_investigation as
/******************************************************************************
   name:     osi_investigation
   purpose:  provides functionality for investigative case file objects.

   revisions:
    date        author          description
    ----------  --------------  ------------------------------------
     7-apr-2009 t.mcguffin      created package
    30-jun-2009 t.mcguffin      added create_instance function.
    30-jul-2009 t.mcguffin      added next_incident_id function.
    13-Aug-2009 t.mcguffin      added get_aah_circumstances, get_ajh_circumstances, get_crim_activity,
                                get_vic_injuries, set_aah_circumstances, set_ajh_circumstances,
                                set_crim_activity and set_vic_injuries proc/functions.
    17-Sep-2009 t.mcguffin      added get_inv_dispositions and set_inv_dispositions.
    30-Sep-2009 t.mcguffin      added get_special_interest and set_special_interest proc/functions.
    30-Sep-2009 t.mcguffin      added get_notify_units and set_notify_units proc/functions.
    30-Sep-2009 t.mcguffin      added get_primary_offense, get_days_to_run and get_timeliness_date functions.
     2-Oct-2009 t.mcguffin      added get_full_id function
     7-Oct-2009 t.mcguffin      added clone_to_case function and clone_specifications procedure
     9-Oct-2009 t.mcguffin      added change_inv_type function
     2-Nov-2009 t.whitehead     Moved get/set_special_interest to osi_object.
    20-Jan-2010 t.mcguffin      added check_writability;
    17-Feb-2010 t.mcguffin      modified clone_to_case for changes to add_note (changed to function)
    31-Mar-2010 t.mcguffin      added get_final_roi_date.
    09-Apr-2010 J.Horne         Changed name of get_full_id to generate_full_id to better identify
                                what the function does.
    13-May-2010 J.Horne         Updated create_instance to that it will allow a user to add an offense,
                                subject, victim and summary when creating a new investigation. When offense,
                                subject and victim are all present, an incident and specification will also be created.
    19-May-2010 J.Horne         Updated create_instance to put in default background (summary allegation) info.
    25-May-2010 T.Leighty       Added make_doc_investigative_file.
    28-May-2010 J.Horne         Added summary_complaint_rpt, get_basic_info, participantname, getsubjectofactivity,
                                load_activity, get_assignments, get_f40_place, get_f40_date, roi_toc_interview, roi_toc_docreview,
                                roi_toc_consultation, roi_toc_search, roi_toc_sourcemeet, roi_toc, roi_header_interview,
                                roi_header_docreview, roi_header_consultation, roi_header_search, roi_header_sourcemeet,
                                roi_header_incidental_int, roi_header_default, roi_header, cleanup_temp_clob
    07-Jun-2010 J.Horne         Added roi_group, roi_group_header, roi_toc_order, roi_group, roi_group_order
    08-Jun-2010 J.Horne         Removed references to util.logger
    09-Jun-2010 J.Horne         Added case_roi, get_subject_list, get_victim_list, roi_block, get_owning_unit_cdr, get_cavaets_list,
                                get_sel_activity, get_evidence_list, get_idp_notes, get_act_exhibit
    11-Jun-2010 J.Horne         Added case_status_report
    14-Jun-2010 J.Horne         Added letter_of_notifcation, case_subjectvictimwitnesslist, getpersonnelphone, getunitphone, idp_notes_report,
                                form_40_roi, getparticipantphone
    24-Jun-2010 J.Faris         Added genericfile_report, get_attachment_list, get_objectives_list; Generic File report functions included
                                in this package because of common support functions and private variables
    25-Jun-2010 J.Horne         Fixed issue with case_subjectwitnessvictimlist; SSNs were duplicating.
    01-Jul-2010 J.Horne         Removed links from summary_complaint_rpt.
    18-Aug-2010 Tim Ward        CR#299 - WebI2MS Missing Narrative Preview.
                                 Added v_obj_type_sid and v_obj_type_code variables.
                                 Added activity_narrative_preview.
                                 Changed load_activity, roi_group.
    07-Sep-2010 T.Whitehead     CHG0003170 - Added Program Data section to form_40_roi.
    20-Sep-2010 Richard Dibble  CR#3277 - Removed IDP Page code from Summary_Complaint_Report() and Case_ROI()
    27-Sep-2010 Richard Dibble  WCHG0000338 - Added build_agent_names() and load_agents_assigned() modified get_assignments()
                                and case_roi() to use them accordingly
    12-Oct-2010 J.Faris         CHG0003170 - Reinstated Thomas W. changes from 07-Sep after inadvertently removing the code during Andrews
                                integration of CR#299.
    12-Oct-2010 Tim Ward        CR#299 - WCH0000338 change to get_assignments broke activity_narrative_preview
                                 Changed activity_narrative_preview.
    26-Oct-2010 Richard Dibble  Fixed roi_group() to properly handle interview activities
    06-Jan-2010 Tim Ward        Added load_agents_assigned to summary_complaint_rpt and moved the function above it so
                                 it could call it without adding it to the spec.
                                 This fixes the <<Error during ROI_Header_Default>> - ORA-01403: no data found. error messages.
                                Changed the Approval Authority section of summary_complaint_rpt to get the correct approval authority name.
                                Changed the Units To Notify to not display Specialty Support when there is no Units to Notify.
    07-Jan-2011 Tim Ward        Moved load_agents_assigned from here to OSI_REPORT.
    07-Jan-2011 Tim Ward        Moved get_assignments from here to OSI_REPORT.
    07-Jan-2011 Tim Ward        Moved build_agent_name from here to OSI_REPORT.
    25-Jan-2011 Tim Ward        Changed check_writability to use APPROVE/CLOSE instead
                                 of APPROVE_OP/APPROVE_CL to allow COMMANDER to edit before Approval/Closure.
    25-Feb-2011 Carl Grunert    CHG0003506 - fixed ROI Reports Footer missing the "Unclassified" word
    03-Mar-2011 Tim Ward        CR#3730 - Changed clone_to_case to NOT clone Status History, but save the starting status.
    04-Mar-2011 Tim Ward        CR#3733 - Changed clone_to_case to copy only obj_context='I' and include the obj_context
                                 when copying Special Interests (fixing the WEBI2MS.UK_OSI_MISS_ACTMISSION error).
    07-Mar-2011 Tim Ward        CR#3736 - Wrong Unit Name getting Pulled.  Fixed to use end_date is null in case_roi,
                                 summary_complaint_rpt, case_status_report, and letter_of_notification.
    25-Mar-2011 Jason Faris     Fixed summary_complaint_rpt formatting from stripping the last name when subjects or victims > 1.
    28-Mar-2011 Tim Ward        CR#3774 - Last Name of Subjects/Victims missing.
                                 Other Agencies works sometimes, not all the time.
                                 Changed in summary_complaint_rpt and a few other '\par' changed to '\par '.
    04-Apr-2011 Tim Ward        Summary Complaint Report showing mostly [TOKEN@....] starting with Subject List.
                                 Changed v_ppg from varchar2(100) to varchar2(400) in get_basic_info.
    14-Apr-2011 Tim Ward        CR#3818 - ROI shows all attachments selected or not.
                                 Changed get_act_exhibit.
    02-May-2011 Tim Ward        CR#3833 - ROI Date doesn't show on Desktop View.
                                 Changed 'ROISFS' to 'ROIFP' in get_final_roi_date.
    19-May-2011 Tim Ward        CR#3828 - Unit Address wrong in the Letter of Notification Report.
                                 Changed letter_of_notification.
    09-Jun-2011 Tim Ward        CR#3363 - Letter Of Notification Typo APD should be AFPD.
                                 Changed letter_of_notification.
    09-Jun-2011 Tim Ward        CR#3215 - Letter Of Notification Modifications
                                 Changed letter_of_notification.
    30-Jun-2011  Tim Ward       CR#3566 - Allow Picking of Subjects when Creating Case from Developmental.
                                  Changed clone_to_case and clone_specifications.
                                  Added SAPRO fields to clone_specifications for CR#3680 and CR#3868.
    07-Jul-2011  Tim Ward       CR#3571 - Add Matters Investigated (Offenses) to Initial Notification.
                                  Added auto_load_specs.
    13-Jul-2011  Tim Ward       CR#3870 - Letter Of Notification Privacy Act Information.
                                  New Variable v_privacyActInfo, changed letter_of_notification.
    22-Jul-2011  Tim Ward       CR#3880 - ROI Narrative Sort Order issues.
                                  Changed in ROI_GROUP_ORDER.
    15-Sep-2011  Tim Ward       CR#3940 - Error happening when trying to Create an ROI 
                                (calling replace_special_chars and need to call replace_special_chars_clob.)
                                 Changed roi_narrative.
                                Also found problem if there are HTML type characters in the Narrative, the 
                                 preview gets messed up.  And there is a 32K Limit to the HTML which had
                                 to be fixed in the Activity_Narrative_Preview Application Express Process.
                                 Changed activity_narrative_preview.
                                 Added escape_the_html.
    21-Sep-2011  Tim Ward       CR#3931 - ROI Date Format should be DD Mon YY not DD-Mon-YYYY. 
                                 Changed v_date_fmt to use new T_CORE_CONFIG entry 
                                 'CORE.DATE_FMT_REPORTS'=FMDD Mon FMFXYY instead of 'CORE.DATE_FMT_DAY'=dd-Mon-rrrr'.
    21-Sep-2011  Tim Ward       CR#3929 - Incorrect Paragraph referenced in the Letter Of Notification. 
                                 Changed 'AFI 36-3208' to 'AFI 36-2110, Table 2.1, Rule 10, Code 17' in letter_of_notification. 
    17-Oct-2011  Tim Ward       CR#3933 - Form 40 ROI fails if more than one spouse exists for a defendant in the relationships.
                                 Changed form_40_roi.
    20-Oct-2011  Tim Ward       CR#3932 - Classification on Reports is wrong.
                                  Changed all classification calls to:
                                   v_class := osi_classification.get_report_class(v_obj_sid);
    25-Oct-2011  Tim Ward       CR#3304 - Letter of Notification Report shows incorrect SSN.
                                 Fixed in Legacy I2MS 30-Sep-2009 but not carried over to WebI2MS.
                                 Changed in Letter_Of_Notification.        
    27-Oct-2011  Tim Ward       CR#3915 - Include Associated Files and Inherited Activities IDP Notes report in IDP NOTES REPORT.
                                CR#3961 - IDP Notes are now in CREATE_ON (Chronological Order).
                                        - Now gets Parentinfo as a HyperLink so you know where the note is from.
                                CR#3932 - Added Classification to IDP NOTES REPORT (forgot to do this on 20-Oct-2011).
                                 Changed in idp_notes_report.        
    01-Nov-2011  Tim Ward       CR#3848 - Unit Name, Address, and MAJCOMM missing from Subject and Victim Title Block of ROI and SCR.
                                 Changed in get_org_info.
    01-Nov-2011  Tim Ward       CR#3847 - AKA and NEE missing from Subject and Victim Title Block of ROI.
                                 Changed Get_Basic_Info.
    01-Nov-2011  Tim Ward       CR#3923 - Pay Plan, Grade and Affiliation not showing in ROI title block.
                                 Changed Get_Basic_Info.
                                Participant Information not showing for Interview Activities.
                                 Changed getparticipantname, roi_toc_interview, form_40_roi, genericfile_report, 
                                  summary_complaint_report, case_roi, and activity_narrative_preview.
    07-Nov-2011 Tim Ward        CR#3918 - Check for Valid Offense Combinations when adding specs.
                                 Changed auto_load_specs.
    12-Jan-2012 Tim Ward        CR#3985 - Still problems with getsubjectofactivity.  Document Review usage is not "SUBJECT".
                                 Legacy never checked usage, just role in 'Subject of Activity' or 'Subject'.
                                 Changed getsubjectofactivity.
    20-Jan-2012 Tim Ward        CR#3848 - Added Paremeter in call to Get_Name, 'N'.
                                 Changed get_org_info.
    19-Mar-2012 Wayne Combs     Undid changes for CR#3915 - Include Associated Files and Inherited Activities IDP Notes report in IDP NOTES REPORT.
    02-Apr-2012 Tim Ward        CR#3923 - Name displaying LN, FN MN instead of FN MN LN on ROI and SCR.
                                 Added parameter get_basic_info that gets passed to get_name.
                                 Changed summary_complaint_rpt, roi_block, get_victim_list.
    06-Apr-2012 Tim Ward        CR#4029 - ROI Failing due to Group Interview with a lot of participants.
                                 Changed roi_header_incidental_int and get_sel_activity.
    16-Apr-2012 Tim Ward        CR#4004 - Summary Complaint Report missing Links.
                                 Changed summary_complaint_rpt.
    24-May-2012 Tim Ward        CR#4005 - Allow direct links into notes from IDP Notes Report, add Create by/on.
                                 Changed idp_notes_report.
    04-Jun-2012 Tim Ward        CR#4047 - Changed Background to Summary of Investigation (Background removed from Inv Files).
                                 Changed summary_complaint_rpt.
    13-Aug-2012 Tim Ward        CR#4055 - New Form 40 ROI Changes.
                                 Added case_roi_new, roi_get_attachments, roi_get_form40_link, roi_get_offense_table, 
                                  roi_get_toc, roi_get_print_html, and get_evidence_list_new functions.
                                 Changed get_basic_info (error if more than one birth address which should really never happen).
    06-Sep-2012 Tim Ward        CR#4055 - New Form 40 ROI Changes.
                                 Added get_report_period to default the period of report differently.
    11-Sep-2012 Tim Ward        CR#4055 - Made changes for the Distribution on the ROI.
                                 Changed case_roi_new and get_sel_activity.
    13-Sep-2012 Tim Ward        CR#4055 - Making sure case_roi still works.
                                 Changed case_roi.
                                                                  
******************************************************************************/
    c_pipe              varchar2(100) := core_util.get_config('CORE.PIPE_PREFIX') || 'OSI_INVESTIGATION';
    v_syn_error         varchar2(4000)                      := null;
    v_obj_sid           varchar(20)                         := null;
    v_spec_sid          varchar(20)                         := null;
    v_act_title         t_osi_activity.title%type;
    v_act_desc          t_core_obj_type.description%type;
    v_act_sid           t_osi_activity.SID%type;
    v_act_date          t_osi_activity.activity_date%type;
    v_act_complt_date   t_osi_activity.complete_date%type;
    v_act_narrative     t_osi_activity.narrative%type;
    v_obj_type_sid      t_core_obj_type.SID%type;
    v_obj_type_code     t_core_obj_type.code%type;
    v_nl                varchar2(100)                       := chr(10);
    v_newline           varchar2(10)                        := chr(13) || chr(10);
    v_mask              varchar2(50);
    v_date_fmt          varchar2(15)                        := core_util.get_config('CORE.DATE_FMT_REPORTS');
    v_privacyActInfo    varchar2(500) := 'This report contains FOR OFFICIAL USE ONLY (FOUO) information which must be protected under the Privacy Act and AFI 33-332.';
        
--------------------------------------
--- ROI Specific Private variables ---
--------------------------------------
    v_unit_sid          varchar2(20);
    v_act_toc_list      clob                                := null;
    v_act_narr_list     clob                                := null;
    v_exhibits_list     clob                                := null;
    v_exhibit_cnt       number                              := 0;
    v_evidence_list     clob                                := null;
    v_idp_list          clob                                := null;
    -- v_equipment_list    clob           := null;
    c_blockparaoff      varchar2(100)
            := '}\pard \ql \li0\ri0\widctlpar\aspalpha\aspnum\faauto\adjustright\rin0\lin0\itap0 {';
    c_hdr_linebreak     varchar2(30)                        := '\ql\fi-720\li720\ \line ';
    c_blockhalfinch     varchar2(250)
        := '}\pard\plain \ql \li0\ri0\widctlpar\tx360\aspalpha\aspnum\faauto\adjustright\rin0\lin0\itap0 \fs20\lang1033\langfe1033\cgrid\langnp1033\langfenp1033 {';
    v_paraoffset        number                              := 0;
    v_exhibit_covers    clob                                := null;
    v_exhibit_table     clob                                := null;
    v_horz_line         varchar2(1000)
        := '{\shp{\*\shpinst\shpleft0\shptop84\shpright10000\shpbottom84\shpfhdr0\shpbxcolumn\shpbxignore\shpbypara\shpbyignore\shpwr3\shpwrk0\shpfblwtxt0\shpz0\shplid1030{\sp{\sn shapeType}{\sv 20}}{\sp{\sn fFlipH}{\sv 0}}{\sp{\sn fFlipV}{\sv 0}}{\sp{\sn shapePath}{\sv 4}}{\sp{\sn fFillOK}{\sv 0}}{\sp{\sn fFilled}{\sv 0}}{\sp{\sn fArrowheadsOK}{\sv 1}}{\sp{\sn fLayoutInCell}{\sv 1}}}{\shprslt{\*\do\dobxcolumn\dobypara\dodhgt8192\dpline\dpptx0\dppty0\dpptx10680\dppty0\dpx0\dpxsize10000\dpysize0\dplinew15\dplinecor0\dplinecog0\dplinecob0}}} \par ';
---------------------------------------------
--- Generic File Report Private Variables ---
---------------------------------------------
    v_narr_toc_list     clob                                := null;
    c_blockpara         varchar2(150)
        := '}\pard \ql \li0\ri0\widctlpar\tx0\tx720\tx2160\aspalpha\aspnum\faauto\adjustright\rin0\lin0\itap0 {';

    procedure log_error(p_msg in varchar2) is
    begin
        core_logger.log_it(c_pipe, p_msg);
    end log_error;

    function get_tagline(p_obj in varchar2)
        return varchar2 is
    begin
        return osi_file.get_tagline(p_obj);
    end get_tagline;

    function get_summary(p_obj in varchar2, p_variant in varchar2 := null)
        return clob is
    begin
        return osi_file.get_summary(p_obj, p_variant);
    end get_summary;

    procedure index1(p_obj in varchar2, p_clob in out nocopy clob) is
    begin
        osi_file.index1(p_obj, p_clob);
    end index1;

    function get_status(p_obj in varchar2)
        return varchar2 is
    begin
        return osi_file.get_status(p_obj);
    end get_status;

    function create_instance(
        p_obj_type      in   varchar2,
        p_title         in   varchar2,
        p_restriction   in   varchar2,
        p_offense       in   varchar2,
        p_subject       in   varchar2,
        p_victim        in   varchar2,
        p_sum_inv       in   clob)
        return varchar2 is
        v_sid           t_core_obj.SID%type;
        v_background    clob;
        v_incidentsid   varchar(20);
    begin
        -- Common file creation,
        -- handles t_core_obj, t_osi_file, starting status, lead assignment, unit owner
        v_sid := osi_file.create_instance(p_obj_type, p_title, p_restriction);
        v_background := core_util.get_config('OSI.INV_DEFAULT_BACKGROUND');

        insert into t_osi_f_investigation
                    (SID, summary_allegation)
             values (v_sid, v_background);

        if p_offense is not null and p_subject is not null and p_victim is not null then
            --Create incident
            insert into t_osi_f_inv_incident
                        (start_date)
                 values (null);

            v_incidentsid := core_sidgen.last_sid;

            --Create incident Map
            insert into t_osi_f_inv_incident_map
                        (investigation, incident)
                 values (v_sid, v_incidentsid);

            --Create offense, assign priority of 'Primary'
            insert into t_osi_f_inv_offense
                        (investigation, offense, priority)
                 values (v_sid, p_offense, (select SID
                                              from t_osi_reference
                                             where usage = 'OFFENSE_PRIORITY' and code = 'P'));

            --Create specification
            insert into t_osi_f_inv_spec
                        (investigation, offense, subject, victim, incident)
                 values (v_sid, p_offense, p_subject, p_victim, v_incidentsid);

            --Create subject involvement
            insert into t_osi_partic_involvement
                        (obj, participant_version, involvement_role)
                 values (v_sid,
                         p_subject,
                         (select SID
                            from t_osi_partic_role_type
                           where role = 'Subject'
                             and usage = 'SUBJECT'
                             and obj_type = core_obj.lookup_objtype('FILE.INV')));

            --Create victim involvement
            insert into t_osi_partic_involvement
                        (obj, participant_version, involvement_role)
                 values (v_sid,
                         p_victim,
                         (select SID
                            from t_osi_partic_role_type
                           where role = 'Victim'
                             and usage = 'VICTIM'
                             and obj_type = core_obj.lookup_objtype('FILE.INV')));

            update t_osi_f_investigation
               set summary_investigation = p_sum_inv
             where SID = v_sid;

            return v_sid;
        end if;

        if p_offense is not null then
            --Create offense, assign priority of 'Primary'
            insert into t_osi_f_inv_offense
                        (investigation, offense, priority)
                 values (v_sid, p_offense, (select SID
                                              from t_osi_reference
                                             where usage = 'OFFENSE_PRIORITY' and code = 'P'));
        end if;

        if p_subject is not null then
            --Create subject involvement
            insert into t_osi_partic_involvement
                        (obj, participant_version, involvement_role)
                 values (v_sid,
                         p_subject,
                         (select SID
                            from t_osi_partic_role_type
                           where role = 'Subject'
                             and usage = 'SUBJECT'
                             and obj_type = core_obj.lookup_objtype('FILE.INV')));
        end if;

        if p_victim is not null then
            --Create victim involvement
            insert into t_osi_partic_involvement
                        (obj, participant_version, involvement_role)
                 values (v_sid,
                         p_victim,
                         (select SID
                            from t_osi_partic_role_type
                           where role = 'Victim'
                             and usage = 'VICTIM'
                             and obj_type = core_obj.lookup_objtype('FILE.INV')));
        end if;

        if p_sum_inv is not null then
            update t_osi_f_investigation
               set summary_investigation = p_sum_inv
             where SID = v_sid;
        end if;

        return v_sid;
    exception
        when others then
            log_error('create_instance: ' || sqlerrm);
    end create_instance;

    function next_incident_id
        return varchar2 is
        v_sid_dom   varchar2(3);
        v_nxtseq    number;
        v_nxtval    varchar2(20);
    begin
        v_sid_dom := '2M2';

        select s_incident_id.nextval
          into v_nxtseq
          from dual;

        v_nxtval := v_sid_dom || lpad(core_edit.base(36, v_nxtseq), 5, '0');
        return(v_nxtval);
    end next_incident_id;

    /* get_aah_circumstances, get_ajh_circumstances, get_crim_activity and get_vic_injuries:
       Builds an array of the data associated to the specification, and
       convert that array to an apex-friendly colon-delimited list */
    function get_aah_circumstances(p_spec_sid in varchar2)
        return varchar2 is
        v_array    apex_application_global.vc_arr2;
        v_idx      integer                         := 1;
        v_string   varchar2(4000);
    begin
        for i in (select aah
                    from t_osi_f_inv_spec_aah
                   where specification = p_spec_sid)
        loop
            v_array(v_idx) := i.aah;
            v_idx := v_idx + 1;
        end loop;

        v_string := apex_util.table_to_string(v_array, ':');
        return v_string;
    exception
        when others then
            log_error('get_aah_circumstances: ' || sqlerrm);
            raise;
    end get_aah_circumstances;

    function get_ajh_circumstances(p_spec_sid in varchar2)
        return varchar2 is
        v_array    apex_application_global.vc_arr2;
        v_idx      integer                         := 1;
        v_string   varchar2(4000);
    begin
        for i in (select ajh
                    from t_osi_f_inv_spec_ajh
                   where specification = p_spec_sid)
        loop
            v_array(v_idx) := i.ajh;
            v_idx := v_idx + 1;
        end loop;

        v_string := apex_util.table_to_string(v_array, ':');
        return v_string;
    exception
        when others then
            log_error('get_ajh_circumstances: ' || sqlerrm);
            raise;
    end get_ajh_circumstances;

    function get_crim_activity(p_spec_sid in varchar2)
        return varchar2 is
        v_array    apex_application_global.vc_arr2;
        v_idx      integer                         := 1;
        v_string   varchar2(4000);
    begin
        for i in (select crim_act_type
                    from t_osi_f_inv_spec_crim_act
                   where specification = p_spec_sid)
        loop
            v_array(v_idx) := i.crim_act_type;
            v_idx := v_idx + 1;
        end loop;

        v_string := apex_util.table_to_string(v_array, ':');
        return v_string;
    exception
        when others then
            log_error('get_crim_activity: ' || sqlerrm);
            raise;
    end get_crim_activity;

    function get_vic_injuries(p_spec_sid in varchar2)
        return varchar2 is
        v_array    apex_application_global.vc_arr2;
        v_idx      integer                         := 1;
        v_string   varchar2(4000);
    begin
        for i in (select injury_type
                    from t_osi_f_inv_spec_vic_injury
                   where specification = p_spec_sid)
        loop
            v_array(v_idx) := i.injury_type;
            v_idx := v_idx + 1;
        end loop;

        v_string := apex_util.table_to_string(v_array, ':');
        return v_string;
    exception
        when others then
            log_error('get_vic_injuries: ' || sqlerrm);
            raise;
    end get_vic_injuries;

    /* set_aah_circumstances, set_ajh_circumstances, set_crim_activity and set_vic_injuries:
       Translate colon-delimited list of sids into an array, then
       loops through and adds those that don't exist already.  Deletes those that no longer
       appear in the list */
    procedure set_aah_circumstances(p_spec_sid in varchar2, p_aah in varchar2) is
        v_array    apex_application_global.vc_arr2;
        v_string   varchar2(4000);
    begin
        v_array := apex_util.string_to_table(p_aah, ':');

        for i in 1 .. v_array.count
        loop
            insert into t_osi_f_inv_spec_aah
                        (specification, aah)
                select p_spec_sid, v_array(i)
                  from dual
                 where not exists(select 1
                                    from t_osi_f_inv_spec_aah
                                   where specification = p_spec_sid and aah = v_array(i));
        end loop;

        delete from t_osi_f_inv_spec_aah
              where specification = p_spec_sid and instr(nvl(p_aah, 'null'), aah) = 0;
    exception
        when others then
            log_error('set_aah_circumstances: ' || sqlerrm);
            raise;
    end set_aah_circumstances;

    procedure set_ajh_circumstances(p_spec_sid in varchar2, p_ajh in varchar2) is
        v_array    apex_application_global.vc_arr2;
        v_string   varchar2(4000);
    begin
        v_array := apex_util.string_to_table(p_ajh, ':');

        for i in 1 .. v_array.count
        loop
            insert into t_osi_f_inv_spec_ajh
                        (specification, ajh)
                select p_spec_sid, v_array(i)
                  from dual
                 where not exists(select 1
                                    from t_osi_f_inv_spec_ajh
                                   where specification = p_spec_sid and ajh = v_array(i));
        end loop;

        delete from t_osi_f_inv_spec_ajh
              where specification = p_spec_sid and instr(nvl(p_ajh, 'null'), ajh) = 0;
    exception
        when others then
            log_error('set_ajh_circumstances: ' || sqlerrm);
            raise;
    end set_ajh_circumstances;

    procedure set_crim_activity(p_spec_sid in varchar2, p_crim_act in varchar2) is
        v_array    apex_application_global.vc_arr2;
        v_string   varchar2(4000);
    begin
        v_array := apex_util.string_to_table(p_crim_act, ':');

        for i in 1 .. v_array.count
        loop
            insert into t_osi_f_inv_spec_crim_act
                        (specification, crim_act_type)
                select p_spec_sid, v_array(i)
                  from dual
                 where not exists(select 1
                                    from t_osi_f_inv_spec_crim_act
                                   where specification = p_spec_sid and crim_act_type = v_array(i));
        end loop;

        delete from t_osi_f_inv_spec_crim_act
              where specification = p_spec_sid and instr(nvl(p_crim_act, 'null'), crim_act_type) = 0;
    exception
        when others then
            log_error('set_crim_activity: ' || sqlerrm);
            raise;
    end set_crim_activity;

    procedure set_vic_injuries(p_spec_sid in varchar2, p_injuries in varchar2) is
        v_array    apex_application_global.vc_arr2;
        v_string   varchar2(4000);
    begin
        v_array := apex_util.string_to_table(p_injuries, ':');

        for i in 1 .. v_array.count
        loop
            insert into t_osi_f_inv_spec_vic_injury
                        (specification, injury_type)
                select p_spec_sid, v_array(i)
                  from dual
                 where not exists(select 1
                                    from t_osi_f_inv_spec_vic_injury
                                   where specification = p_spec_sid and injury_type = v_array(i));
        end loop;

        delete from t_osi_f_inv_spec_vic_injury
              where specification = p_spec_sid and instr(nvl(p_injuries, 'null'), injury_type) = 0;
    exception
        when others then
            log_error('set_vic_injuries: ' || sqlerrm);
            raise;
    end set_vic_injuries;

    function get_inv_dispositions(p_sid in varchar2)
        return varchar2 is
        v_array    apex_application_global.vc_arr2;
        v_idx      integer                         := 1;
        v_string   varchar2(4000);
    begin
        for i in (select disposition
                    from t_osi_f_inv_disposition
                   where investigation = p_sid)
        loop
            v_array(v_idx) := i.disposition;
            v_idx := v_idx + 1;
        end loop;

        v_string := apex_util.table_to_string(v_array, ':');
        return v_string;
    exception
        when others then
            log_error('get_inv_dispositions: ' || sqlerrm);
            raise;
    end get_inv_dispositions;

    procedure set_inv_dispositions(p_sid in varchar2, p_dispositions in varchar2) is
        v_array    apex_application_global.vc_arr2;
        v_string   varchar2(4000);
    begin
        v_array := apex_util.string_to_table(p_dispositions, ':');

        for i in 1 .. v_array.count
        loop
            insert into t_osi_f_inv_disposition
                        (investigation, disposition)
                select p_sid, v_array(i)
                  from dual
                 where not exists(select 1
                                    from t_osi_f_inv_disposition
                                   where investigation = p_sid and disposition = v_array(i));
        end loop;

        delete from t_osi_f_inv_disposition
              where investigation = p_sid and instr(nvl(p_dispositions, 'null'), disposition) = 0;
    exception
        when others then
            log_error('set_inv_dispositions: ' || sqlerrm);
            raise;
    end set_inv_dispositions;

    function get_notify_units(p_sid in varchar2)
        return varchar2 is
        v_array    apex_application_global.vc_arr2;
        v_idx      integer                         := 1;
        v_string   varchar2(4000);
    begin
        for i in (select unit_sid
                    from t_osi_f_notify_unit
                   where file_sid = p_sid)
        loop
            v_array(v_idx) := i.unit_sid;
            v_idx := v_idx + 1;
        end loop;

        v_string := apex_util.table_to_string(v_array, ':');
        return v_string;
    exception
        when others then
            log_error('get_notify_units: ' || sqlerrm);
            raise;
    end get_notify_units;

    procedure set_notify_units(p_sid in varchar2, p_notify_units in varchar2) is
        v_array    apex_application_global.vc_arr2;
        v_string   varchar2(4000);
    begin
        v_array := apex_util.string_to_table(p_notify_units, ':');

        for i in 1 .. v_array.count
        loop
            if v_array(i) is not null then
                insert into t_osi_f_notify_unit
                            (file_sid, unit_sid)
                    select p_sid, v_array(i)
                      from dual
                     where not exists(select 1
                                        from t_osi_f_notify_unit
                                       where file_sid = p_sid and unit_sid = v_array(i));
            end if;
        end loop;

        delete from t_osi_f_notify_unit
              where file_sid = p_sid and instr(nvl(p_notify_units, 'null'), unit_sid) = 0;
    exception
        when others then
            log_error('set_notify_units: ' || sqlerrm);
            raise;
    end set_notify_units;

    function get_primary_offense(p_sid in varchar2)
        return varchar2 is
        v_offense   varchar2(20);
    begin
        select o.offense
          into v_offense
          from t_osi_f_inv_offense o, t_osi_reference p
         where o.investigation = p_sid and o.priority = p.SID and p.code = 'P' and rownum = 1;

        return v_offense;
    exception
        when no_data_found then
            return null;
        when others then
            log_error('get_primary_offense: ' || sqlerrm);
            raise;
    end get_primary_offense;

    function get_days_to_run(p_sid in varchar2)
        return number is
        v_days_to_run       number;
        v_primary_offense   varchar2(20);
    begin
        v_primary_offense := get_primary_offense(p_sid);

        if v_primary_offense is not null then
            begin
                select max(dtr.days)
                  into v_days_to_run
                  from t_osi_f_inv_daystorun dtr, t_osi_f_investigation i
                 where i.SID = p_sid and dtr.area = i.manage_by and dtr.offense = v_primary_offense;
            exception
                when others then
                    null;
            end;

            if v_days_to_run is null then
                begin
                    select days
                      into v_days_to_run
                      from t_osi_f_inv_daystorun
                     where offense = v_primary_offense and area is null;
                exception
                    when others then
                        null;
                end;
            end if;
        end if;

        return nvl(v_days_to_run, 100);
    end get_days_to_run;

    function get_timeliness_date(p_sid in varchar2)
        return date is
        v_days_to_run   number;
    begin
        return trunc(osi_status.last_sh_create_on(p_sid, 'NW') + get_days_to_run(p_sid));
    exception
        when others then
            log_error('get_timeliness_date: ' || sqlerrm);
            raise;
    end get_timeliness_date;

    function generate_full_id(p_sid in varchar2)
        return varchar2 is
        v_inv_type               t_core_obj_type.code%type;
        v_primary_offense_code   t_dibrs_offense_type.code%type;
        v_full_id                t_osi_file.full_id%type;
        v_id                     t_osi_file.id%type;
    begin
        begin
            select ot.code, f.full_id, f.id
              into v_inv_type, v_full_id, v_id
              from t_core_obj o, t_osi_file f, t_core_obj_type ot
             where o.SID = p_sid and f.SID = o.SID and ot.SID = o.obj_type;
        exception
            when no_data_found then
                null;
        end;

        if v_full_id is not null then
            return v_full_id;
        end if;

        select unit_code || '-'
          into v_full_id
          from t_osi_unit
         where SID = osi_file.get_unit_owner(p_sid);

        case v_inv_type
            when 'FILE.INV.CASE' then
                v_full_id := v_full_id || 'C-';
            when 'FILE.INV.DEV' then
                v_full_id := v_full_id || 'D-';
            when 'FILE.INV.INFO' then
                v_full_id := v_full_id || 'I-';
            else
                v_full_id := v_full_id || '?-';
        end case;

        begin
            select code
              into v_primary_offense_code
              from t_dibrs_offense_type
             where SID = get_primary_offense(p_sid);
        exception
            when no_data_found then
                v_full_id := v_full_id || 'INVSTGTV-' || v_id;
                return v_full_id;
        end;

        if v_primary_offense_code is not null then
            v_full_id := v_full_id || v_primary_offense_code || '-' || v_id;
        end if;

        return v_full_id;
    exception
        when others then
            log_error('get_full_id: ' || sqlerrm);
            raise;
    end generate_full_id;

procedure clone_specifications(p_old_sid in varchar2, p_new_sid in varchar2, p_parameter1 in varchar2 := null, p_parameter2 in varchar2 := null) is

         v_new_spec_sid   t_osi_f_inv_spec.SID%type;

begin
     for i in (select * from t_osi_f_inv_spec where investigation=p_old_sid and subject in  (select * from table(split(p_parameter1,'~')) where column_value is not null))
     loop
         --- clone main spec record ---
         insert into t_osi_f_inv_spec
                    (investigation,
                     offense,
                     subject,
                     victim,
                     incident,
                     off_result,
                     off_loc,
                     off_on_usi,
                     off_us_state,
                     off_country,
                     off_involvement,
                     off_committed_on,
                     sub_susp_alcohol,
                     sub_susp_drugs,
                     sub_susp_computer,
                     vic_rel_to_offender,
                     num_prem_entered,
                     entry_method,
                     bias_motivation,
                     sexual_harassment_related,
                     vic_susp_alcohol,
                     vic_susp_drugs,
                     sapro_incident_location_code,
                     sapro_incident_location_csc)
             values (p_new_sid,
                     i.offense,
                     i.subject,
                     i.victim,
                     i.incident,
                     i.off_result,
                     i.off_loc,
                     i.off_on_usi,
                     i.off_us_state,
                     i.off_country,
                     i.off_involvement,
                     i.off_committed_on,
                     i.sub_susp_alcohol,
                     i.sub_susp_drugs,
                     i.sub_susp_computer,
                     i.vic_rel_to_offender,
                     i.num_prem_entered,
                     i.entry_method,
                     i.bias_motivation,
                     i.sexual_harassment_related,
                     i.vic_susp_alcohol,
                     i.vic_susp_drugs,
                     i.sapro_incident_location_code,
                     i.sapro_incident_location_csc)
          returning SID
               into v_new_spec_sid;

        --- clone aah list ---
        insert into t_osi_f_inv_spec_aah (specification, aah)
            select v_new_spec_sid, aah from t_osi_f_inv_spec_aah
             where specification = i.SID;

         --- clone ajh list ---
         insert into t_osi_f_inv_spec_ajh (specification, ajh)
            select v_new_spec_sid, ajh from t_osi_f_inv_spec_ajh
             where specification = i.SID;

        --- clone weapon force used list ---
        insert into t_osi_f_inv_spec_arm (specification, armed_with, gun_category)
            select v_new_spec_sid, armed_with, gun_category from t_osi_f_inv_spec_arm
             where specification = i.SID;

        --- clone criminal activities list ---
        insert into t_osi_f_inv_spec_crim_act (specification, crim_act_type)
            select v_new_spec_sid, crim_act_type from t_osi_f_inv_spec_crim_act
             where specification = i.SID;

        --- clone victim injuries list ---
        insert into t_osi_f_inv_spec_vic_injury (specification, injury_type)
            select v_new_spec_sid, injury_type from t_osi_f_inv_spec_vic_injury
             where specification = i.SID;
    end loop;

exception when others then

        log_error('clone_specifications: ' || sqlerrm);
        raise;

end clone_specifications;
    
/* p_parameter1 is a list of Subjects to Create the Case with (separated with a ~) */
function clone_to_case(p_sid in varchar2, p_parameter1 in varchar2 := null, p_parameter2 in varchar2 := null) return varchar2 is

        v_new_sid        t_core_obj.SID%type;
        v_old_id         t_osi_file.id%type;
        v_new_id         t_osi_file.id%type;
        v_close_status   t_osi_status.SID%type;
        v_note_sid       t_osi_note.SID%type;
        v_starting_status  t_osi_status.sid%type;

begin
     --- clone object ---
     insert into t_core_obj (obj_type)
             values (core_obj.lookup_objtype('FILE.INV.CASE')) returning SID into v_new_sid;

     v_new_id := osi_object.get_next_id;

     --- clone basic file info ---
     insert into t_osi_file (SID, id, title, closed_short, restriction)
           select v_new_sid, v_new_id, title, closed_short, restriction from t_osi_file where SID = p_sid;

     --- clone investigation ---
     insert into t_osi_f_investigation
                (SID,
                 manage_by,
                 manage_by_appv,
                 memo_5,
                 resolution,
                 summary_allegation,
                 summary_investigation,
                 afrc)
        select v_new_sid, manage_by, manage_by_appv, memo_5, resolution, summary_allegation,
               summary_investigation, afrc
          from t_osi_f_investigation
         where SID = p_sid;

    --- clone offenses ---
    insert into t_osi_f_inv_offense
                (investigation, offense, priority)
        select v_new_sid, offense, priority
          from t_osi_f_inv_offense
         where investigation = p_sid;

    clone_specifications(p_sid, v_new_sid, p_parameter1, p_parameter2);

    --- clone ONLY subjects that were selected by the user ---
    insert into t_osi_partic_involvement
               (obj,
                participant_version,
                involvement_role,
                num_briefed,
                action_date,
                response,
                response_date,
                agency_file_num,
                report_to_dibrs,
                report_to_nibrs,
                reason)
        select v_new_sid, participant_version, involvement_role, num_briefed, action_date,
               response, response_date, agency_file_num, report_to_dibrs, report_to_nibrs,
               reason
          from t_osi_partic_involvement
         where obj=p_sid and involvement_role in (select sid from t_osi_partic_role_type where role='Subject') and participant_version in  (select * from table(split(p_parameter1,'~')) where column_value is not null);

    --- clone victims and agencies ---
    insert into t_osi_partic_involvement
               (obj,
                participant_version,
                involvement_role,
                num_briefed,
                action_date,
                response,
                response_date,
                agency_file_num,
                report_to_dibrs,
                report_to_nibrs,
                reason)
        select v_new_sid, participant_version, involvement_role, num_briefed, action_date,
               response, response_date, agency_file_num, report_to_dibrs, report_to_nibrs,
               reason
          from t_osi_partic_involvement
         where obj=p_sid and involvement_role in (select sid from t_osi_partic_role_type where role not in 'Subject');

    --- map incidents to this file ---
    insert into t_osi_f_inv_incident_map (investigation, incident)
        select v_new_sid, incident from t_osi_f_inv_incident_map
         where investigation = p_sid;

    --- clone special interest mission areas ---
    insert into t_osi_mission (obj, mission, obj_context)
        select v_new_sid, mission, obj_context from t_osi_mission
         where obj = p_sid and obj_context='I';

    --- clone units to notify ---
    insert into t_osi_f_notify_unit (file_sid, unit_sid)
        select v_new_sid, unit_sid
          from t_osi_f_notify_unit
         where file_sid = p_sid;

    --- clone activity associations ---
    insert into t_osi_assoc_fle_act (file_sid, activity_sid, resource_allocation)
        select v_new_sid, activity_sid, resource_allocation
          from t_osi_assoc_fle_act
         where file_sid = p_sid;

    --- clone file associations ---
    insert into t_osi_assoc_fle_fle (file_a, file_b)
        select v_new_sid, file_b
          from t_osi_assoc_fle_fle
         where file_a = p_sid;

    insert into t_osi_assoc_fle_fle (file_a, file_b)
        select file_a, v_new_sid
          from t_osi_assoc_fle_fle
         where file_b = p_sid;

    --- associate to current file ---
    insert into t_osi_assoc_fle_fle (file_a, file_b) values (v_new_sid, p_sid);

    --- clone assignments ---
    insert into t_osi_assignment (obj, personnel, assign_role, start_date, end_date, unit)
        select v_new_sid, personnel, assign_role, start_date, end_date, unit from t_osi_assignment
         where obj = p_sid;

    --- set unit ownership to current user's unit ---
    osi_file.set_unit_owner(v_new_sid);

    --- save status ---
    select starting_status into v_starting_status from t_osi_obj_type ot, t_core_obj_type ct
         where ot.sid=ct.sid and ct.code='FILE.INV.CASE';
        
    insert into t_osi_status_history
                (obj, status, effective_on, transition_comment, is_current) values
                (v_new_sid, v_starting_status, sysdate, 'Created', 'Y');

    --- close old file if informational ---
    if core_obj.get_objtype(p_sid) = core_obj.lookup_objtype('FILE.INV.INFO') then

      select SID into v_close_status from t_osi_status where code = 'CL';

      osi_status.change_status_brute(p_sid, v_close_status, 'Closed (Short) with Case Creation');

      v_note_sid := osi_note.add_note (p_sid, osi_note.get_note_type(core_obj.lookup_objtype('FILE.INV.INFO'), 'CLOSURE'), 'Original documents are contained in the associated case file:  ' || v_new_id || '.');

    end if;

    select id into v_old_id from t_osi_file where SID = p_sid;

    --- Add Note ---
    v_note_sid := osi_note.add_note(v_new_sid, osi_note.get_note_type(core_obj.lookup_objtype('FILE.INV.CASE'), 'CREATE'), 'This Case File was created using the following File:  ' || v_old_id || '.');
    return v_new_sid;

exception when others then

    log_error('clone_to_case: ' || sqlerrm);
    raise;
        
end clone_to_case;

    procedure change_inv_type(p_sid in varchar2, p_new_type in varchar2) is
    begin
        --change object type
        update t_core_obj
           set obj_type = p_new_type,
               acl = null
         where SID = p_sid and obj_type <> p_new_type;

        --delete property records
        delete from t_osi_f_inv_property
              where specification in(select SID
                                       from t_osi_f_inv_spec
                                      where investigation = p_sid);

        --delete subject disposition records (cascades children)
        delete from t_osi_f_inv_subj_disposition
              where investigation = p_sid;

        --delete investigation dispositions
        delete from t_osi_f_inv_disposition
              where investigation = p_sid;

        --delete incident dispositions
        update t_osi_f_inv_incident
           set clearance_reason = null
         where SID in(select incident
                        from t_osi_f_inv_incident_map
                       where investigation = p_sid);

        --clear overall investigative disposition
        update t_osi_f_investigation
           set resolution = null
         where SID = p_sid;
    exception
        when others then
            log_error('change_inv_type: ' || sqlerrm);
            raise;
    end change_inv_type;

    function check_writability(p_obj in varchar2, p_obj_context in varchar2)
        return varchar2 is
        v_obj_type   t_core_obj_type.SID%type;
    begin
        v_obj_type := core_obj.get_objtype(p_obj);

        case osi_object.get_status_code(p_obj)
            when 'NW' then
                return 'Y';
            when 'AA' then
                --return osi_auth.check_for_priv('APPROVE_OP', v_obj_type);
                return osi_auth.check_for_priv('APPROVE', v_obj_type);
            when 'OP' then
                return 'Y';
            when 'AC' then
                --return osi_auth.check_for_priv('APPROVE_CL', v_obj_type);
                return osi_auth.check_for_priv('CLOSE', v_obj_type);
            when 'CL' then
                return 'N';
            when 'SV' then
                return 'N';
            when 'RV' then
                return 'N';
            when 'AV' then
                return 'N';
            else
                return 'Y';
        end case;
    exception
        when others then
            log_error('check_writability: ' || sqlerrm);
            raise;
    end check_writability;

    function get_final_roi_date(p_obj varchar2)
        return date is
        v_return   date;
    begin
        select max(a.create_on)
          into v_return
          from t_osi_attachment a, t_osi_attachment_type at
         where a.obj = p_obj and at.SID = a.type and at.code = 'ROIFP';--'ROISFS';

        return v_return;
    exception
        when no_data_found then
            return null;
        when others then
            log_error('get_final_roi_date: ' || sqlerrm);
            raise;
    end get_final_roi_date;

--======================================================================================================================
--  Produces the html document for the investigative file report.
--======================================================================================================================
    procedure make_doc_investigative_file(p_sid in varchar2, p_doc in out nocopy clob) is
        v_temp           varchar2(30000);
        v_temp_clob      clob;
        v_template       clob;
        v_fle_rec        t_osi_file%rowtype;
        v_inv_rec        t_osi_f_investigation%rowtype;
        v_ok             varchar2(1000);                     -- flag indicating success or failure.
        v_cnt            number;
        dispositions     varchar2(2000);
        resdescription   varchar2(100);
    begin
        core_logger.log_it(c_pipe, '--> make_doc_fle');

        -- main program
        if core_classification.has_hi(p_sid, null, 'ORCON') = 'Y' then
            core_logger.log_it
                      (c_pipe,
                       'ODW.Make_Doc_FLE: Investigation is ORCON - no document will be synthesized');
            return;
        end if;

        if core_classification.has_hi(p_sid, null, 'LIMDIS') = 'Y' then
            core_logger.log_it
                     (c_pipe,
                      'ODW.Make_Doc_FLE: Investigation is LIMDIS - no document will be synthesized');
            return;
        end if;

        select *
          into v_fle_rec
          from t_osi_file
         where SID = p_sid;

        select *
          into v_inv_rec
          from t_osi_f_investigation
         where SID = p_sid;

        osi_object.get_template('OSI_ODW_DETAIL_FLE', v_template);
        v_template := osi_object.addicon(v_template, p_sid);
        -- Put in summary fields
        v_ok := core_template.replace_tag(v_template, 'ID', v_fle_rec.id);
        v_ok := core_template.replace_tag(v_template, 'TITLE', v_fle_rec.title);
        v_ok :=
            core_template.replace_tag(v_template,
                                      'SUMMARY_ALLEGATION',
                                      core_util.html_ize(v_inv_rec.summary_allegation));
        v_ok :=
            core_template.replace_tag(v_template,
                                      'SUMMARY_INVESTIGATION',
                                      core_util.html_ize(v_inv_rec.summary_investigation));
        -- get participants involved
        osi_object.append_involved_participants(v_temp_clob, p_sid);
        v_ok := core_template.replace_tag(v_template, 'PAR_INVOLVED', v_temp_clob);
        core_util.cleanup_temp_clob(v_temp_clob);

        -- get offenses
        select count(*)
          into v_cnt
          from v_osi_f_inv_offense
         where investigation = p_sid;

        if v_cnt > 0 then
            v_temp :=
                '<TR><TD nowrap><b>Priority</b></TD>' || '<TD nowrap><b>Code</b></TD>'
                || '<TD width="100%"><b>Description</b></TD></TR>';
            osi_util.aitc(v_temp_clob, v_temp);
            v_cnt := 0;

            for h in (select   o.priority_desc, ot.code, o.offense_desc
                          from v_osi_f_inv_offense o, t_dibrs_offense_type ot
                         where o.investigation = p_sid and o.offense = ot.SID
                      order by decode(o.priority_desc, 'Primary', 1, 'Reportable', 2, 3), ot.code)
            loop
                v_cnt := v_cnt + 1;
                v_temp :=
                    '<TR>' || '<TD nowrap><b>' || v_cnt || ': </b>' || h.priority_desc || '</TD>'
                    || '<TD nowrap>' || h.code || '</TD>' || '<TD width="100%">' || h.offense_desc
                    || '</TD>' || '</TR>';
                osi_util.aitc(v_temp_clob, v_temp);
            end loop;
        else
            osi_util.aitc(v_temp_clob, '<TR><TD width="100%">No Data Found<br></TD></TR>');
        end if;

        v_ok := core_template.replace_tag(v_template, 'OFFENSES', v_temp_clob);
        core_util.cleanup_temp_clob(v_temp_clob);

        -- Subject Disposition List --
        select count(*)
          into v_cnt
          from t_osi_f_inv_subj_disposition sd,
               t_osi_f_inv_court_action_type c,
               t_osi_participant_version s,
               t_osi_partic_name sn,
               (select code
                  from t_dibrs_reference
                 where usage = 'STATUTORY_BASIS') dr,
               (select code
                  from t_osi_reference
                 where usage = 'INV_DISPOSITION_TYPE') osir
         where c.code = osir.code
           and s.SID = sd.subject
           and sn.SID(+) = s.current_name
           and dr.code(+) = sd.jurisdiction
           and sd.investigation = p_sid;

        if v_cnt > 0 then
            v_temp :=
                '<TR><TD nowrap><b>Subject Name</b></TD>'
                || '<TD nowrap><b>Disposition Description</b></TD>'
                || '<TD nowrap><b>Jurisdiction</b></TD>' || '<TD nowrap><b>Rendered</b></TD>'
                || '<TD nowrap><b>Notified</b></TD></TR>';
            osi_util.aitc(v_temp_clob, v_temp);
            v_cnt := 0;

            for h in (select sd.SID, sd.investigation, sd.subject, osir.code, sd.jurisdiction,
                             sd.rendered_on, sd.notified_on, sd.comments, sd.create_by,
                             sd.create_on, sd.modify_by, sd.modify_on, c.description as disp_desc,
                             nvl(sn.last_name || ' ' || sn.first_name || ' ' || sn.middle_name,
                                 'None Specified') as subject_name,
                             dr.description as jurisdiction_desc
                        from t_osi_f_inv_subj_disposition sd,
                             t_osi_f_inv_court_action_type c,
                             t_osi_participant_version s,
                             t_osi_partic_name sn,
                             (select code, description
                                from t_dibrs_reference
                               where usage = 'STATUTORY_BASIS') dr,
                             (select code
                                from t_osi_reference
                               where usage = 'INV_DISPOSITION_TYPE') osir
                       where c.code = osir.code
                         and s.SID = sd.subject
                         and sn.SID(+) = s.current_name
                         and dr.code(+) = sd.jurisdiction
                         and sd.investigation = p_sid)
            loop
                v_cnt := v_cnt + 1;

                if v_cnt > 1 then
                    v_temp := '<TR BGCOLOR=#C0C0C0><TD colspan=8>&nbsp;</TD><TR>';
                else
                    v_temp := '';
                end if;

                v_temp :=
                    v_temp || '<TR>' || '<TD nowrap><b>' || v_cnt || ': </b>' || h.subject_name
                    || '&nbsp;</TD>' || '<TD nowrap>' || h.disp_desc || '&nbsp;</TD>'
                    || '<TD nowrap>' || h.jurisdiction_desc || '&nbsp;</TD>' || '<TD nowrap>'
                    || h.rendered_on || '&nbsp;</TD>' || '<TD nowrap>' || h.notified_on
                    || '&nbsp;</TD></TR>';

                if    h.comments <> ''
                   or h.comments is not null then
                    v_temp :=
                        v_temp
                        || '<TR><TD>&nbsp;</TD><TD colspan=4 width="100%"><CENTER><B>Comments</B></CENTER></TD></TR>'
                        || '<TR><TD>&nbsp;</TD><TD colspan=4 width="100%">' || h.comments
                        || '</TD></TR>';
                end if;

                osi_util.aitc(v_temp_clob, v_temp);
            end loop;
        else
            osi_util.aitc(v_temp_clob, '<TR><TD width="100%">No Data Found<br></TD></TR>');
        end if;

        v_ok := core_template.replace_tag(v_template, 'SUBJECTDISPO', v_temp_clob);
        core_util.cleanup_temp_clob(v_temp_clob);

        -- Incident/Investigation Disposition List --
        select count(*)
          into v_cnt
          from (select d.SID
                  from t_osi_f_inv_incident d, t_dibrs_clearance_reason_type dcr
                 where dcr.SID(+) = d.clearance_reason
                       and d.stat_basis in(select SID
                                             from t_dibrs_reference
                                            where usage = 'STATUTORY_BASIS')) a,
               (select im.incident
                  from t_osi_f_inv_incident c, t_osi_f_inv_incident_map im
                 where im.investigation = p_sid and c.SID = im.incident) i
         where a.SID = i.incident;

        if v_cnt > 0 then
            v_temp :=
                '<TR><TD nowrap><b>Incident ID</b></TD>' || '<TD nowrap><b>Description</b></TD>'
                || '<TD nowrap><b>Clearance Reason</b></TD></TR>';
            osi_util.aitc(v_temp_clob, v_temp);
            v_cnt := 0;

            for h in (select a.incident_num, a.description, a.clearance_reason_desc
                        from (select i.SID as incident_num, dr.description,
                                     dc.description as clearance_reason_desc
                                from t_osi_f_inv_incident i,
                                     t_dibrs_clearance_reason_type dc,
                                     t_dibrs_reference dr
                               where dc.code(+) = i.clearance_reason and dr.SID(+) = i.stat_basis) a,
                             (select im.incident
                                from t_osi_f_inv_incident c, t_osi_f_inv_incident_map im
                               where im.investigation = p_sid and c.SID = im.incident) b
                       where a.incident_num = b.incident)
            loop
                v_cnt := v_cnt + 1;
                v_temp :=
                    '<TR>' || '<TD nowrap><b>' || v_cnt || ': </b>' || h.incident_num
                    || '&nbsp;</TD>' || '<TD nowrap>' || h.description || '&nbsp;</TD>'
                    || '<TD nowrap>' || h.clearance_reason_desc || '&nbsp;</TD></TR>';
                osi_util.aitc(v_temp_clob, v_temp);
            end loop;
        else
            osi_util.aitc(v_temp_clob, '<TR><TD width="100%">No Data Found<br></TD></TR>');
        end if;

        -- Investigation Dispositions List and Resolution --
        select count(*)
          into v_cnt
          from t_osi_f_inv_subj_disposition id,
               (select SID
                  from t_osi_reference
                 where usage = 'INV_DISPOSITION_TYPE') idt
         where id.investigation = p_sid and id.disposition = idt.SID;

        if v_cnt > 0 then
            dispositions := '';

            for h in (select   idt.description
                          from t_osi_f_inv_subj_disposition id,
                               (select SID, description
                                  from t_osi_reference
                                 where usage = 'INV_DISPOSITION_TYPE') idt
                         where id.investigation = p_sid and id.disposition = idt.SID
                      order by idt.description)
            loop
                dispositions := dispositions || h.description || ', ';
            end loop;

            dispositions := substr(dispositions, 1, length(dispositions) - 2);
            v_temp :=
                '</TABLE><TABLE><TR><TD nowrap><b>Investigation Dispositions</b></TD>'
                || '<TD nowrap><b>Investigation Resolution</b></TD></TR>';

            select description
              into resdescription
              from t_osi_f_investigation inv,
                   (select SID, description
                      from t_osi_reference
                     where usage = 'INV_RESOLUTION_TYPE') ir
             where inv.SID = p_sid and inv.resolution = ir.SID(+);

            if    dispositions = ''
               or dispositions is null then
                dispositions := 'No Data Found';
            end if;

            v_temp :=
                v_temp || '<TR>' || '<TD width=100%>' || dispositions || '&nbsp;</TD>'
                || '<TD nowrap>' || resdescription || '&nbsp;</TD></TR>';
            osi_util.aitc(v_temp_clob, v_temp);
        else
            osi_util.aitc(v_temp_clob, '</TABLE><TABLE>');
        end if;

        v_ok := core_template.replace_tag(v_template, 'INVDISPO', v_temp_clob);
        core_util.cleanup_temp_clob(v_temp_clob);
        -- get Associated Activities.
        osi_object.append_assoc_activities(v_temp_clob, p_sid);
        v_ok := core_template.replace_tag(v_template, 'ASSOCIATED_ACTIVITIES', v_temp_clob);
        core_util.cleanup_temp_clob(v_temp_clob);
        -- get Related Files.
        osi_object.append_related_files(v_temp_clob, p_sid);
        v_ok := core_template.replace_tag(v_template, 'ASSOCIATED_FILES', v_temp_clob);
        core_util.cleanup_temp_clob(v_temp_clob);
        -- get Attachment Descriptions
        osi_object.append_attachments(v_temp_clob, p_sid);
        v_ok := core_template.replace_tag(v_template, 'ATTACHMENT_DESC', v_temp_clob);
        core_util.cleanup_temp_clob(v_temp_clob);
        -- get Notes
        osi_object.append_notes(v_temp_clob, p_sid);
        v_ok := core_template.replace_tag(v_template, 'NOTES', v_temp_clob);
        core_util.cleanup_temp_clob(v_temp_clob);
        -- return the completed template
        dbms_lob.append(p_doc, v_template);
        core_util.cleanup_temp_clob(v_template);
        core_logger.log_it(c_pipe, '<-- make_doc_fle');
    exception
        when no_data_found then
            core_logger.log_it(c_pipe, 'ODW.Make_Doc_FLE Error: Non Investigative File SID Error');
        when others then
            v_syn_error := sqlerrm;
            core_logger.log_it(c_pipe, 'ODW.Make_Doc_FLE Error: ' || v_syn_error);
    end make_doc_investigative_file;

    function summary_complaint_rpt(psid in varchar2) return clob is

        v_ok                   varchar2(1000);
        v_template             clob                                    := null;
        v_template_date        date;
        v_mime_type            t_core_template.mime_type%type;
        v_mime_disp            t_core_template.mime_disposition%type;
        htmlorrtf              varchar2(4)                             := 'RTF';
        v_tempstring           clob;
        v_recordcounter        number;
        v_crlfpos              number;
        v_personnel_sid        varchar2(20);
        v_not_approved         varchar2(25)                            := 'FILE NOT YET APPROVED';
        v_approval_authority   varchar2(400)                           := null;
        v_approval_unitname    varchar2(400)                           := null;
        v_approval_date        date;
        v_name                 varchar2(1000);
        v_maiden               varchar2(1000);
        v_akas                 varchar2(1000);
        v_sex                  varchar2(400);
        v_dob                  varchar2(400);
        v_pob                  varchar2(400);
        v_pp                   varchar2(400);
        v_pg                   varchar2(400);
        v_ppg                  varchar2(400);
        v_saa                  varchar2(400);
        v_per                  varchar2(400);
        v_pt                   varchar2(400);
        v_ssn                  varchar2(400);
        v_org                  varchar2(400);
        v_org_name             varchar2(400);
        v_org_majcom           varchar2(400);
        v_base                 varchar2(400);
        v_base_loc             varchar2(400);
        v_relatedper           varchar2(400);
        v_lastunitname         varchar2(100);
        v_sig_block            varchar2(500);
        v_agent_name           varchar2(500);
        v_result               varchar2(4000);
        v_class                varchar2(100);
        v_base_url             varchar2(4000)                          := core_util.GET_CONFIG('CORE.BASE_URL');

    begin
        log_error('>>> Summary_Complaint_Report');

        osi_report.load_participants(psid);
        osi_report.load_agents_assigned(psid);

        v_ok := core_template.get_latest('SUMMARY_COMPLAINT_RPT', v_template, v_template_date, v_mime_type, v_mime_disp);

        --- Replace File SID for Links that can be clicked on ---
        v_ok := core_template.replace_tag(v_template, 'FILE_SID', osi_report.replace_special_chars(psid, htmlorrtf), 'TOKEN@', true);

        v_class := osi_classification.get_report_class(v_obj_sid);

        v_ok := core_template.replace_tag(v_template, 'CLASSIFICATION', osi_report.replace_special_chars(v_class, htmlorrtf), 'TOKEN@', true);

        --- Get Parts we can get from the Main Tables ---
        v_recordcounter := 1;

        for a in (select * from v_osi_rpt_complaint_summary where SID = psid)
        loop
            if v_recordcounter = 1 then

              v_ok := core_template.replace_tag(v_template, 'SUMMARY_OF_ALLEGATION', osi_report.replace_special_chars_clob(a.summary_investigation, htmlorrtf));

              if a.summary_allegation = a.summary_investigation then

                v_ok := core_template.replace_tag(v_template, 'SUMMARY_OF_INVESTIGATION_HEADER', '');
                v_ok := core_template.replace_tag(v_template, 'SUMMARY_OF_INVESTIGATION', '');

              else

                v_ok := core_template.replace_tag(v_template, 'SUMMARY_OF_INVESTIGATION_HEADER', '\par ' || osi_report.replace_special_chars_clob('SUMMARY OF INVESTIGATION', htmlorrtf) || '\par ');
                v_ok := core_template.replace_tag(v_template, 'SUMMARY_OF_INVESTIGATION', '\par ' || osi_report.replace_special_chars_clob (a.summary_investigation, htmlorrtf) || '\par ');

              end if;

              v_tempstring := '{\field\fldedit{\*\fldinst HYPERLINK "' || v_base_url || psid || '" }';
              v_tempstring := v_tempstring || '{\fldrslt'; 
              v_tempstring := v_tempstring || '\cs16\ul\cf2 ' || osi_report.replace_special_chars(NVL(a.FULL_ID,a.FILE_ID), htmlorrtf) || '}} ' || v_result;
              v_ok := core_template.replace_tag(v_template,'FULL_ID',v_tempstring,'TOKEN@',true);
                
              v_ok := core_template.replace_tag(v_template, 'FILE_ID', osi_report.replace_special_chars(a.file_id, htmlorrtf), 'TOKEN@', true);
              v_ok := core_template.replace_tag(v_template, 'TITLE', osi_report.replace_special_chars(a.title, htmlorrtf), 'TOKEN@', true);
              v_ok := core_template.replace_tag(v_template, 'FILE_TYPE', osi_report.replace_special_chars(a.file_type, htmlorrtf), 'TOKEN@', true);
              v_ok := core_template.replace_tag (v_template, 'EFF_DATE', osi_report.replace_special_chars(to_char(a.effective_date, v_date_fmt), htmlorrtf), 'TOKEN@', true);
              v_ok := core_template.replace_tag(v_template, 'MISSION', osi_report.replace_special_chars(a.mission_area, htmlorrtf), 'TOKEN@', true);

              v_tempstring := a.special_interest;

              if a.status <> 'OP' then
 
                v_approval_authority := v_not_approved;
 
              end if;
 
            else

              --- There can be More than One Special Interest ---
              if v_tempstring is not null then

                v_tempstring := v_tempstring || '\par ';

              end if;

              v_tempstring := v_tempstring || osi_report.replace_special_chars(a.special_interest, htmlorrtf);

            end if;

            v_recordcounter := v_recordcounter + 1;

        end loop;

        --- Replace Special Interest ---
        if v_tempstring is null then

          v_ok := core_template.replace_tag(v_template, 'SI', 'None', 'TOKEN@', true);

        else

          v_ok := core_template.replace_tag(v_template, 'SI', v_tempstring, 'TOKEN@', true);

        end if;

        --- Offenses List ---
        v_tempstring := null;

        for a in (select   r.description as priority,
                           ot.description || ', ' || ot.code offense_desc
                      from t_osi_f_inv_offense o, t_osi_reference r, t_dibrs_offense_type ot
                     where o.investigation = psid and o.priority = r.SID and o.offense = ot.SID
                  order by priority, offense_desc)
        loop
            if v_tempstring is not null then

              v_tempstring := v_tempstring || '\par ';

            end if;

            v_tempstring := v_tempstring || a.offense_desc;

        end loop;

        v_ok := core_template.replace_tag(v_template, 'OFFENSES', v_tempstring);

        --- Subject List ---
        v_tempstring := null;

        for a in (select participant_version
                    from t_osi_partic_involvement pi,
                         t_osi_participant_version pv,
                         t_osi_partic_role_type prt
                   where pi.obj = psid
                     and pi.participant_version = pv.SID
                     and pi.involvement_role = prt.SID
                     and prt.role = 'Subject'
                     and prt.usage = 'SUBJECT')
        loop
            --- Get Names ONLY ---
            get_basic_info(a.participant_version, v_name, v_saa, v_per, true, true, false, false, 'N');

            --- Get All other needed information ---
            get_basic_info(a.participant_version, v_result, v_saa, v_per, false, false, false, false, 'N');

            if v_saa = 'ME' then                                      --- military (or employee) ---

              v_result := v_result || nvl(get_org_info(a.participant_version), 'UNK');

            end if;

            if v_tempstring is not null then

              v_tempstring := v_tempstring || '\par\par ';

            end if;

            v_tempstring := v_tempstring || '{\field\fldedit{\*\fldinst HYPERLINK "' || v_base_url || a.PARTICIPANT_VERSION || '" }';
            v_tempstring := v_tempstring || '{\fldrslt'; 
            v_tempstring := v_tempstring || '\cs16\ul\cf2 ' || v_name || '}} ' || v_result;
            --v_tempstring := v_tempstring || v_name || v_result;

        end loop;

        v_ok := core_template.replace_tag(v_template, 'SUBJECTS', v_tempstring, 'TOKEN@', true);

        --- Victim List ---
        v_tempstring := null;

        for a in (select participant_version
                    from t_osi_partic_involvement pi,
                         t_osi_participant_version pv,
                         t_osi_partic_role_type prt
                   where pi.obj = psid
                     and pi.participant_version = pv.SID
                     and pi.involvement_role = prt.SID
                     and prt.role = 'Victim'
                     and prt.usage = 'VICTIM')
        loop
            --- Get Names ONLY ---
            get_basic_info(a.participant_version, v_name, v_saa, v_per, true, true, false, false, 'N');

            --- Get All other needed information ---
            get_basic_info(a.participant_version, v_result, v_saa, v_per, false, false, false, false, 'N');

            if v_saa = 'ME' then                                      --- military (or employee) ---

              v_result := v_result || nvl(get_org_info(a.participant_version), 'UNK');

            end if;

            if v_tempstring is not null then

              v_tempstring := v_tempstring || '\par\par ';

            end if;

            v_tempstring := v_tempstring || '{\field\fldedit{\*\fldinst HYPERLINK "' || v_base_url || a.PARTICIPANT_VERSION || '" }';
            v_tempstring := v_tempstring || '{\fldrslt'; 
            v_tempstring := v_tempstring || '\cs16\ul\cf2 ' || v_name || '}} ' || v_result;

        end loop;

        v_ok := core_template.replace_tag(v_template, 'VICTIMS', v_tempstring, 'TOKEN@', true);

        --- Lead Agent ---
        for a in (select personnel, first_name || ' ' || last_name as personnel_name, un.unit_name
                    from v_osi_obj_assignments oa, t_osi_unit_name un
                   where obj = psid and un.unit = oa.current_unit and role = 'LEAD' and un.end_date is null)
        loop
            select 'SA ' || first_name || ' '
                   || decode(length(middle_name),
                             1, middle_name || '. ',
                             0, ' ',
                             null, ' ',
                             substr(middle_name, 1, 1) || '. ')
                   || last_name,
                   first_name || ' '
                   || decode(length(middle_name),
                             1, middle_name || '. ',
                             0, ' ',
                             null, ' ',
                             substr(middle_name, 1, 1) || '. ')
                   || last_name || ', SA, '
                   || decode(op.pay_category, '03', 'DAF', '04', 'DAF', 'USAF')
              into v_agent_name,
                   v_sig_block
              from t_core_personnel cp, t_osi_personnel op
             where cp.SID = a.personnel and cp.SID = op.SID;

            v_ok := core_template.replace_tag(v_template, 'LEADAGENTNAME', v_agent_name, 'TOKEN@', false);
            v_ok := core_template.replace_tag(v_template, 'LEADAGENTNAME', v_sig_block, 'TOKEN@', false);
            v_ok := core_template.replace_tag(v_template, 'UNITNAME', osi_report.replace_special_chars(a.unit_name, htmlorrtf), 'TOKEN@', true);
            v_personnel_sid := a.personnel;
            exit;

        end loop;

        --- Submitted for Approval Date ---
        begin
            select to_char(osi_status.first_sh_date(psid, 'AA'), v_date_fmt)
              into v_approval_date
              from dual;
        exception
            when no_data_found then
                null;
        end;

        if v_approval_date is null then

          v_ok := core_template.replace_tag(v_template, 'SUBMIT_FOR_APPROVAL_DATE', 'FILE NOT YET SUBMITTED FOR APPROVAL');

        else

          v_ok := core_template.replace_tag(v_template, 'SUBMIT_FOR_APPROVAL_DATE', v_approval_date);

        end if;

        --- Approval Date ---
        begin
             select to_char(osi_status.first_sh_date(psid, 'OP'), v_date_fmt) into v_tempstring from dual;
        exception
            when no_data_found then
                null;
        end;

        if v_tempstring is null then

          v_ok := core_template.replace_tag(v_template, 'APPROVAL_DATE', 'FILE NOT YET APPROVED');

        else

          v_ok := core_template.replace_tag(v_template, 'APPROVAL_DATE', v_tempstring);

        end if;
        
        --- Approval Authority ---
--        for a in (select personnel, first_name || ' ' || last_name as personnel_name, un.unit_name
--                    from v_osi_obj_assignments oa, t_osi_unit_name un
--                   where obj = psid and un.unit = oa.current_unit and role = 'LEAD')
--        loop
        for a in (select SID as personnel, personnel_name, unit_name
                    from v_osi_personnel
                   where SID = core_context.PERSONNEL_SID)
        loop
            if v_approval_authority is null then
                select first_name || ' '
                       || decode(length(middle_name),
                                 1, middle_name || '. ',
                                 0, ' ',
                                 null, ' ',
                                 substr(middle_name, 1, 1) || '. ')
                       || last_name || ', SA, '
                       || decode(pay_category, '03', 'DAF', '04', 'DAF', 'USAF')
                  into v_approval_authority
                  from t_core_personnel cp, t_osi_personnel op
                 where cp.SID = a.personnel and cp.SID = op.SID;
            end if;

            v_approval_unitname := a.unit_name;
            v_personnel_sid := a.personnel;
            exit;
        end loop;

        v_ok := core_template.replace_tag (v_template, 'APPROVALAUTHORITY', osi_report.replace_special_chars(nvl(v_approval_authority, 'Approval Authority not assigned'), htmlorrtf), 'TOKEN@', true);
        v_ok := core_template.replace_tag(v_template, 'APPROVALAUTHORITYUNIT', osi_report.replace_special_chars(v_approval_unitname, htmlorrtf), 'TOKEN@', true);

        --- Related Activities ---
        v_tempstring := null;        
        v_recordcounter := 0;
        log_error('Starting related Activities');

        for a in (select   a.SID as activity, a.narrative as activity_narrative,
                           replace(roi_header(a.SID), ' \line', '') as header
                      from t_osi_assoc_fle_act afa, t_osi_activity a
                     where afa.file_sid = psid and afa.activity_sid = a.SID
                  order by activity)
        loop
            v_recordcounter := v_recordcounter + 1;

            select instr(a.header, chr(13) || chr(10))
              into v_crlfpos
              from dual;

            v_tempstring := v_tempstring || '\trowd \irow0\irowband0\ts15\trgaph108\trleft-108\trftsWidth1\trftsWidthB3\trftsWidthA3\trpaddl108\trpaddr108\trpaddfl3\trpaddft3\trpaddfb3\trpaddfr3\tblrsid11419280\tbllkhdrrows\tbllklastrow\tbllkhdrcols\tbllklastcol \clvertalt';
            v_tempstring := v_tempstring || '\clbrdrt\brdrtbl \clbrdrl\brdrtbl \clbrdrb\brdrtbl \clbrdrr\brdrtbl \cltxlrtb\clftsWidth3\clwWidth468\clshdrawnil \cellx360\clvertalt\clbrdrt\brdrtbl \clbrdrl\brdrtbl \clbrdrb\brdrtbl \clbrdrr\brdrtbl \cltxlrtb\clftsWidth3\clwWidth9108\clshdrawnil';
            v_tempstring := v_tempstring || '\cellx9468\pard\plain \ql \li0\ri0\widctlpar\intbl\aspalpha\faauto\adjustright\rin0\lin0\pararsid11419280\yts15 \fs20\lang1033\langfe1033\cgrid\langnp1033\langfenp1033 \b ' || ltrim(rtrim(to_char(v_recordcounter))) || '.\cell \pard';
            v_tempstring := v_tempstring || '\ql \li44\ri0\widctlpar\intbl\aspalpha\aspnum\faauto\adjustright\rin0\lin44\pararsid11419280\yts15 {\field\fldedit{\*\fldinst HYPERLINK "' || v_base_url || a.ACTIVITY || '" }{\fldrslt {';

            if v_crlfpos > 0 then

              v_tempstring := v_tempstring || '\cs16\ul\cf2 ' || replace(osi_report.replace_special_chars(substr(a.header, 1, v_crlfpos - 1), htmlorrtf), '\\tab', '\tab') || '}}}\b \line ' || replace(osi_report.replace_special_chars(substr(a.header, v_crlfpos + 2, length(a.header) - v_crlfpos + 1), htmlorrtf), '\\tab', '\tab');

            else

              v_tempstring := v_tempstring || '\cs16\ul\cf2 ' || replace(osi_report.replace_special_chars(a.header, htmlorrtf), '\\tab', '\tab') || '}}}\b';

            end if;

            v_tempstring := v_tempstring || '\par \cell \pard\plain \ql \li0\ri0\widctlpar\intbl\aspalpha\aspnum\faauto\adjustright\rin0\lin0 \fs20\lang1033\langfe1033\cgrid\langnp1033\langfenp1033 \b \trowd \irow0\irowband0';
            v_tempstring := v_tempstring || '\ts15\trgaph108\trleft-108\trftsWidth1\trftsWidthB3\trftsWidthA3\trpaddl108\trpaddr108\trpaddfl3\trpaddft3\trpaddfb3\trpaddfr3\tblrsid11419280\tbllkhdrrows\tbllklastrow\tbllkhdrcols\tbllklastcol \clvertalt\clbrdrt\brdrtbl \clbrdrl\brdrtbl \clbrdrb';
            v_tempstring := v_tempstring || '\brdrtbl \clbrdrr\brdrtbl \cltxlrtb\clftsWidth3\clwWidth468\clshdrawnil \cellx360\clvertalt\clbrdrt\brdrtbl \clbrdrl\brdrtbl \clbrdrb\brdrtbl \clbrdrr\brdrtbl \cltxlrtb\clftsWidth3\clwWidth9108\clshdrawnil \cellx9468\row \trowd \irow1\irowband1\lastrow';
            v_tempstring := v_tempstring || '\ts15\trgaph108\trleft-108\trftsWidth1\trftsWidthB3\trftsWidthA3\trpaddl108\trpaddr108\trpaddfl3\trpaddft3\trpaddfb3\trpaddfr3\tblrsid11419280\tbllkhdrrows\tbllklastrow\tbllkhdrcols\tbllklastcol \clvertalt\clbrdrt\brdrtbl \clbrdrl\brdrtbl \clbrdrb';
            v_tempstring := v_tempstring || '\brdrtbl \clbrdrr\brdrtbl \cltxlrtb\clftsWidth3\clwWidth9576\clshdrawnil \cellx9468\pard\plain \ql \li0\ri0\widctlpar\intbl\aspalpha\faauto\adjustright\rin0\lin0\pararsid11419280\yts15 \fs20\lang1033\langfe1033\cgrid\langnp1033\langfenp1033 ';
            v_tempstring := v_tempstring || osi_report.replace_special_chars(a.activity_narrative, htmlorrtf) || '\b \cell \pard\plain \ql \li0\ri0\widctlpar\intbl\aspalpha\aspnum\faauto\adjustright\rin0\lin0 \fs20\lang1033\langfe1033\cgrid\langnp1033\langfenp1033 \b';
            v_tempstring := v_tempstring || '\trowd \irow1\irowband1\lastrow \ts15\trgaph108\trleft-108\trftsWidth1\trftsWidthB3\trftsWidthA3\trpaddl108\trpaddr108\trpaddfl3\trpaddft3\trpaddfb3\trpaddfr3\tblrsid11419280\tbllkhdrrows\tbllklastrow\tbllkhdrcols\tbllklastcol \clvertalt\clbrdrt\brdrtbl';
            v_tempstring := v_tempstring || '\clbrdrl\brdrtbl \clbrdrb\brdrtbl \clbrdrr\brdrtbl \cltxlrtb\clftsWidth3\clwWidth9576\clshdrawnil \cellx9468\row \pard \ql \li0\ri0\widctlpar\faauto\rin0\lin0\itap0 \par ';

        end loop;

        v_ok := core_template.replace_tag(v_template, 'ASSOCIATED_ACTIVITIES', v_tempstring);

        --- Related Files ---
        v_tempstring := null;

        for a in (select   that_file_full_id, that_file_id, that_file, that_file_title,
                           that_file_type_desc,
                           (select description
                              from t_osi_status_history sh, t_osi_status s
                             where sh.obj = psid
                               and s.SID = sh.status
                               and sh.is_current = 'Y') as that_status_desc
                      from v_osi_assoc_fle_fle
                     where this_file = psid
                  order by that_file_id)
        loop
            v_tempstring := v_tempstring || '\trowd \irow0\irowband0\lastrow \ts11\trgaph108\trleft0\trbrdrt\brdrs\brdrw10 \trbrdrl\brdrs\brdrw10 \trbrdrb\brdrs\brdrw10 \trbrdrr\brdrs\brdrw10';
            v_tempstring := v_tempstring || '\trftsWidth1\trftsWidthB3\trftsWidthA3\trpaddl108\trpaddr108\trpaddfl3\trpaddft3\trpaddfb3\trpaddfr3 \clvertalt\clbrdrt\brdrs\brdrw10 \clbrdrl\brdrs\brdrw10 \clbrdrb\brdrs\brdrw10 \clbrdrr\brdrs\brdrw10 \cltxlrtb\clftsWidth3\clwWidth1890\clshdrawnil';
            v_tempstring := v_tempstring || '\cellx1890\clvertalt\clbrdrt\brdrs\brdrw10 \clbrdrl\brdrs\brdrw10 \clbrdrb\brdrs\brdrw10 \clbrdrr\brdrs\brdrw10 \cltxlrtb\clftsWidth3\clwWidth4410\clshdrawnil \cellx6300\clvertalt\clbrdrt\brdrs\brdrw10 \clbrdrl\brdrs\brdrw10 \clbrdrb\brdrs\brdrw10';
            v_tempstring := v_tempstring || '\clbrdrr\brdrs\brdrw10 \cltxlrtb\clftsWidth3\clwWidth1530\clshdrawnil \cellx7830\clvertalt\clbrdrt\brdrs\brdrw10 \clbrdrl\brdrs\brdrw10 \clbrdrb\brdrs\brdrw10 \clbrdrr\brdrs\brdrw10 \cltxlrtb\clftsWidth3\clwWidth1530\clshdrawnil \cellx9360\pard\plain';
            v_tempstring := v_tempstring || '\ql \li0\ri0\widctlpar\intbl\faauto\rin0\lin0\pararsid12283215 \fs20\lang1033\langfe1033\cgrid\langnp1033\langfenp1033 ' || nvl(a.that_file_full_id, a.that_file_id) || ' \cell {\field\flddirty{\*\fldinst ';
            v_tempstring := v_tempstring || ' HYPERLINK "' || v_base_url || a.THAT_FILE || '" }{\fldrslt {';
            v_tempstring := v_tempstring || '\cs15\ul\cf2 ' || a.that_file_title || '}}} \cell ' || a.that_file_type_desc || ' \cell ';
            v_tempstring := v_tempstring || a.that_status_desc || ' \cell \pard \ql \li0\ri0\widctlpar\intbl\aspalpha\aspnum\faauto\adjustright\rin0\lin0 \trowd \irow0\irowband0\lastrow \ts11\trgaph108\trleft0\trbrdrt\brdrs\brdrw10 \trbrdrl';
            v_tempstring := v_tempstring || '\brdrs\brdrw10 \trbrdrb\brdrs\brdrw10 \trbrdrr\brdrs\brdrw10 \trftsWidth1\trftsWidthB3\trftsWidthA3\trpaddl108\trpaddr108\trpaddfl3\trpaddft3\trpaddfb3\trpaddfr3 \clvertalt\clbrdrt\brdrs\brdrw10 \clbrdrl\brdrs\brdrw10 \clbrdrb\brdrs\brdrw10 \clbrdrr';
            v_tempstring := v_tempstring || '\brdrs\brdrw10 \cltxlrtb\clftsWidth3\clwWidth1890\clshdrawnil \cellx1890\clvertalt\clbrdrt\brdrs\brdrw10 \clbrdrl\brdrs\brdrw10 \clbrdrb\brdrs\brdrw10 \clbrdrr\brdrs\brdrw10 \cltxlrtb\clftsWidth3\clwWidth4410\clshdrawnil \cellx6300\clvertalt\clbrdrt';
            v_tempstring := v_tempstring || '\brdrs\brdrw10 \clbrdrl\brdrs\brdrw10 \clbrdrb\brdrs\brdrw10 \clbrdrr\brdrs\brdrw10 \cltxlrtb\clftsWidth3\clwWidth1530\clshdrawnil \cellx7830\clvertalt\clbrdrt\brdrs\brdrw10 \clbrdrl\brdrs\brdrw10 \clbrdrb\brdrs\brdrw10 \clbrdrr\brdrs\brdrw10';
            v_tempstring := v_tempstring || '\cltxlrtb\clftsWidth3\clwWidth1530\clshdrawnil \cellx9360\row \pard \ql \li0\ri0\widctlpar\faauto\rin0\lin0\itap0 ';

        end loop;

        v_ok := core_template.replace_tag(v_template, 'ASSOCIATED_FILES', v_tempstring, 'TOKEN@', true);

        --- OSI Assignments ---
        v_tempstring := null;

        for a in (select   cp.first_name || ' ' || last_name as personnel_name,
                           art.description as assign_role, un.unit_name
                      from t_osi_assignment a,
                           t_osi_assignment_role_type art,
                           t_core_personnel cp,
                           t_osi_unit u,
                           t_osi_unit_name un
                     where a.personnel = cp.SID
                       and a.unit = u.SID
                       and u.SID = un.unit
                       and a.assign_role = art.SID
                       and obj = psid
                       and art.description <> 'Administrative'
                       and un.end_date is null
                  order by a.assign_role, a.start_date)
        loop
            v_tempstring := v_tempstring || '\trowd \irow0\irowband0\lastrow \ts11\trgaph108\trleft0\trbrdrt\brdrs\brdrw10 \trbrdrl\brdrs\brdrw10 \trbrdrb\brdrs\brdrw10 \trbrdrr\brdrs\brdrw10';
            v_tempstring := v_tempstring || '\trftsWidth1\trftsWidthB3\trftsWidthA3\trpaddl108\trpaddr108\trpaddfl3\trpaddft3\trpaddfb3\trpaddfr3\tblrsid13590504 \clvertalt\clbrdrt\brdrs\brdrw10 \clbrdrl\brdrs\brdrw10 \clbrdrb\brdrs\brdrw10 \clbrdrr\brdrs\brdrw10';
            v_tempstring := v_tempstring || '\cltxlrtb\clftsWidth3\clwWidth1620\clshdrawnil \cellx1620\clvertalt\clbrdrt\brdrs\brdrw10 \clbrdrl\brdrs\brdrw10 \clbrdrb\brdrs\brdrw10 \clbrdrr\brdrs\brdrw10 \cltxlrtb\clftsWidth3\clwWidth4500\clshdrawnil \cellx6120\clvertalt\clbrdrt\brdrs\brdrw10';
            v_tempstring := v_tempstring || '\clbrdrl\brdrs\brdrw10 \clbrdrb\brdrs\brdrw10 \clbrdrr\brdrs\brdrw10 \cltxlrtb\clftsWidth3\clwWidth3240\clshdrawnil \cellx9360\pard\plain \ql \li0\ri0\widctlpar\intbl\faauto\rin0\lin0\pararsid13590504';
            v_tempstring := v_tempstring || '\fs20\lang1033\langfe1033\cgrid\langnp1033\langfenp1033 ' || a.unit_name || '\fs24 \cell ' || a.personnel_name || '\fs24 \cell  ' || a.assign_role || '\fs24 \cell \pard';
            v_tempstring := v_tempstring || '\ql \li0\ri0\widctlpar\intbl\aspalpha\aspnum\faauto\adjustright\rin0\lin0 \trowd \irow0\irowband0\lastrow \ts11\trgaph108\trleft0\trbrdrt\brdrs\brdrw10 \trbrdrl\brdrs\brdrw10 \trbrdrb\brdrs\brdrw10 \trbrdrr\brdrs\brdrw10';
            v_tempstring := v_tempstring || '\trftsWidth1\trftsWidthB3\trftsWidthA3\trpaddl108\trpaddr108\trpaddfl3\trpaddft3\trpaddfb3\trpaddfr3\tblrsid13590504 \clvertalt\clbrdrt\brdrs\brdrw10 \clbrdrl\brdrs\brdrw10 \clbrdrb\brdrs\brdrw10 \clbrdrr\brdrs\brdrw10';
            v_tempstring := v_tempstring || '\cltxlrtb\clftsWidth3\clwWidth1620\clshdrawnil \cellx1620\clvertalt\clbrdrt\brdrs\brdrw10 \clbrdrl\brdrs\brdrw10 \clbrdrb\brdrs\brdrw10 \clbrdrr\brdrs\brdrw10 \cltxlrtb\clftsWidth3\clwWidth4500\clshdrawnil \cellx6120\clvertalt\clbrdrt\brdrs\brdrw10';
            v_tempstring := v_tempstring || '\clbrdrl\brdrs\brdrw10 \clbrdrb\brdrs\brdrw10 \clbrdrr\brdrs\brdrw10 \cltxlrtb\clftsWidth3\clwWidth3240\clshdrawnil \cellx9360\row \pard \ql \li0\ri0\widctlpar\faauto\rin0\lin0\itap0 ';

        end loop;

        v_ok := core_template.replace_tag(v_template, 'ASSIGNED', v_tempstring);

        --- Specialty Support Requested ---
        v_tempstring := null;
        v_recordcounter := 1;

        for a in (select   mc.description as specialty
                      from t_osi_mission_category mc, t_osi_mission m
                     where m.obj = psid and mc.SID = m.mission and m.obj_context = 'I'
                  order by specialty)
        loop
            if mod(v_recordcounter, 2) = 0 then

              v_tempstring := v_tempstring || '\trowd \irow0\irowband0\lastrow \ts11\trgaph108\trleft0\trbrdrt\brdrs\brdrw10 \trbrdrl\brdrs\brdrw10 \trbrdrb\brdrs\brdrw10 \trbrdrr\brdrs\brdrw10';
              v_tempstring := v_tempstring || '\trftsWidth1\trpaddl108\trpaddr108\trpaddfl3\trpaddft3\trpaddfb3\trpaddfr3\tblrsid14292103 \clvertalt\clbrdrt\brdrs\brdrw10 \clbrdrl\brdrs\brdrw10 \clbrdrb\brdrs\brdrw10 \clbrdrr\brdrs\brdrw10 \cltxlrtb\clftsWidth3\clwWidth4680\clshdrawnil \cellx4680';
              v_tempstring := v_tempstring || '\clvertalt\clbrdrt\brdrs\brdrw10 \clbrdrl\brdrs\brdrw10 \clbrdrb\brdrs\brdrw10 \clbrdrr\brdrs\brdrw10 \cltxlrtb\clftsWidth3\clwWidth4680\clshdrawnil \cellx9360\pard\plain \ql \li0\ri0\widctlpar\intbl\faauto\rin0\lin0\pararsid14292103';
              v_tempstring := v_tempstring || '\fs20\lang1033\langfe1033\cgrid\langnp1033\langfenp1033 ' || v_lastunitname || '\cell ' || a.specialty || '\cell \pard \ql \li0\ri0\widctlpar\intbl\aspalpha\aspnum\faauto\adjustright\rin0\lin0 \trowd \irow0\irowband0\lastrow \ts11\trgaph108\trleft0';
              v_tempstring := v_tempstring || '\trbrdrt\brdrs\brdrw10 \trbrdrl\brdrs\brdrw10 \trbrdrb\brdrs\brdrw10 \trbrdrr\brdrs\brdrw10 \trftsWidth1\trpaddl108\trpaddr108\trpaddfl3\trpaddft3\trpaddfb3\trpaddfr3\tblrsid14292103 \clvertalt\clbrdrt\brdrs\brdrw10 \clbrdrl\brdrs\brdrw10 \clbrdrb';
              v_tempstring := v_tempstring || '\brdrs\brdrw10 \clbrdrr\brdrs\brdrw10 \cltxlrtb\clftsWidth3\clwWidth4680\clshdrawnil \cellx4680\clvertalt\clbrdrt\brdrs\brdrw10 \clbrdrl\brdrs\brdrw10 \clbrdrb\brdrs\brdrw10 \clbrdrr\brdrs\brdrw10 \cltxlrtb\clftsWidth3\clwWidth4680\clshdrawnil \cellx9360';
              v_tempstring := v_tempstring || '\row \pard \ql \li0\ri0\widctlpar\faauto\rin0\lin0\itap0 ';
              v_lastunitname := null;

            else

              v_lastunitname := a.specialty;

            end if;

            v_recordcounter := v_recordcounter + 1;

        end loop;

        if v_lastunitname is not null then

          v_tempstring := v_tempstring || '\trowd \irow0\irowband0\lastrow \ts11\trgaph108\trleft0\trbrdrt\brdrs\brdrw10 \trbrdrl\brdrs\brdrw10 \trbrdrb\brdrs\brdrw10 \trbrdrr\brdrs\brdrw10';
          v_tempstring := v_tempstring || '\trftsWidth1\trpaddl108\trpaddr108\trpaddfl3\trpaddft3\trpaddfb3\trpaddfr3\tblrsid14292103 \clvertalt\clbrdrt\brdrs\brdrw10 \clbrdrl\brdrs\brdrw10 \clbrdrb\brdrs\brdrw10 \clbrdrr\brdrs\brdrw10 \cltxlrtb\clftsWidth3\clwWidth4680\clshdrawnil \cellx4680';
          v_tempstring := v_tempstring || '\clvertalt\clbrdrt\brdrs\brdrw10 \clbrdrl\brdrs\brdrw10 \clbrdrb\brdrs\brdrw10 \clbrdrr\brdrs\brdrw10 \cltxlrtb\clftsWidth3\clwWidth4680\clshdrawnil \cellx9360\pard\plain \ql \li0\ri0\widctlpar\intbl\faauto\rin0\lin0\pararsid14292103';
          v_tempstring := v_tempstring || '\fs20\lang1033\langfe1033\cgrid\langnp1033\langfenp1033 ' || v_lastunitname || '\cell \cell \pard \ql \li0\ri0\widctlpar\intbl\aspalpha\aspnum\faauto\adjustright\rin0\lin0 \trowd \irow0\irowband0\lastrow \ts11\trgaph108\trleft0';
          v_tempstring := v_tempstring || '\trbrdrt\brdrs\brdrw10 \trbrdrl\brdrs\brdrw10 \trbrdrb\brdrs\brdrw10 \trbrdrr\brdrs\brdrw10 \trftsWidth1\trpaddl108\trpaddr108\trpaddfl3\trpaddft3\trpaddfb3\trpaddfr3\tblrsid14292103 \clvertalt\clbrdrt\brdrs\brdrw10 \clbrdrl\brdrs\brdrw10 \clbrdrb';
          v_tempstring := v_tempstring || '\brdrs\brdrw10 \clbrdrr\brdrs\brdrw10 \cltxlrtb\clftsWidth3\clwWidth4680\clshdrawnil \cellx4680\clvertalt\clbrdrt\brdrs\brdrw10 \clbrdrl\brdrs\brdrw10 \clbrdrb\brdrs\brdrw10 \clbrdrr\brdrs\brdrw10 \cltxlrtb\clftsWidth3\clwWidth4680\clshdrawnil \cellx9360';
          v_tempstring := v_tempstring || '\row \pard \ql \li0\ri0\widctlpar\faauto\rin0\lin0\itap0 ';

        end if;

        v_ok := core_template.replace_tag(v_template, 'SPECIALTY', v_tempstring);

        --- Other AFOSI Units Notified ---
        v_tempstring := null;
        v_lastunitname := null;
        v_recordcounter := 1;

        for a in (select   u.unit_name
                      from t_osi_f_notify_unit nu, v_osi_unit u
                     where file_sid = psid and nu.unit_sid = u.SID
                  order by unit_name)
        loop
            if mod(v_recordcounter, 2) = 0 then

              v_tempstring := v_tempstring || '\trowd \irow0\irowband0\lastrow \ts11\trgaph108\trleft0\trbrdrt\brdrs\brdrw10 \trbrdrl\brdrs\brdrw10 \trbrdrb\brdrs\brdrw10 \trbrdrr\brdrs\brdrw10';
              v_tempstring := v_tempstring || '\trftsWidth1\trpaddl108\trpaddr108\trpaddfl3\trpaddft3\trpaddfb3\trpaddfr3\tblrsid14292103 \clvertalt\clbrdrt\brdrs\brdrw10 \clbrdrl\brdrs\brdrw10 \clbrdrb\brdrs\brdrw10 \clbrdrr\brdrs\brdrw10 \cltxlrtb\clftsWidth3\clwWidth4680\clshdrawnil \cellx4680';
              v_tempstring := v_tempstring || '\clvertalt\clbrdrt\brdrs\brdrw10 \clbrdrl\brdrs\brdrw10 \clbrdrb\brdrs\brdrw10 \clbrdrr\brdrs\brdrw10 \cltxlrtb\clftsWidth3\clwWidth4680\clshdrawnil \cellx9360\pard\plain \ql \li0\ri0\widctlpar\intbl\faauto\rin0\lin0\pararsid14292103';
              v_tempstring := v_tempstring || '\fs20\lang1033\langfe1033\cgrid\langnp1033\langfenp1033 ' || v_lastunitname || '\cell ' || a.unit_name || '\cell \pard \ql \li0\ri0\widctlpar\intbl\aspalpha\aspnum\faauto\adjustright\rin0\lin0 \trowd \irow0\irowband0\lastrow \ts11\trgaph108\trleft0';
              v_tempstring := v_tempstring || '\trbrdrt\brdrs\brdrw10 \trbrdrl\brdrs\brdrw10 \trbrdrb\brdrs\brdrw10 \trbrdrr\brdrs\brdrw10 \trftsWidth1\trpaddl108\trpaddr108\trpaddfl3\trpaddft3\trpaddfb3\trpaddfr3\tblrsid14292103 \clvertalt\clbrdrt\brdrs\brdrw10 \clbrdrl\brdrs\brdrw10 \clbrdrb';
              v_tempstring := v_tempstring || '\brdrs\brdrw10 \clbrdrr\brdrs\brdrw10 \cltxlrtb\clftsWidth3\clwWidth4680\clshdrawnil \cellx4680\clvertalt\clbrdrt\brdrs\brdrw10 \clbrdrl\brdrs\brdrw10 \clbrdrb\brdrs\brdrw10 \clbrdrr\brdrs\brdrw10 \cltxlrtb\clftsWidth3\clwWidth4680\clshdrawnil \cellx9360';
              v_tempstring := v_tempstring || '\row \pard \ql \li0\ri0\widctlpar\faauto\rin0\lin0\itap0 ';
              v_lastunitname := null;

            else

              v_lastunitname := a.unit_name;

            end if;

            v_recordcounter := v_recordcounter + 1;

        end loop;

        if v_lastunitname is not null then

          v_tempstring := v_tempstring || '\trowd \irow0\irowband0\lastrow \ts11\trgaph108\trleft0\trbrdrt\brdrs\brdrw10 \trbrdrl\brdrs\brdrw10 \trbrdrb\brdrs\brdrw10 \trbrdrr\brdrs\brdrw10';
          v_tempstring := v_tempstring || '\trftsWidth1\trpaddl108\trpaddr108\trpaddfl3\trpaddft3\trpaddfb3\trpaddfr3\tblrsid14292103 \clvertalt\clbrdrt\brdrs\brdrw10 \clbrdrl\brdrs\brdrw10 \clbrdrb\brdrs\brdrw10 \clbrdrr\brdrs\brdrw10 \cltxlrtb\clftsWidth3\clwWidth4680\clshdrawnil \cellx4680';
          v_tempstring := v_tempstring || '\clvertalt\clbrdrt\brdrs\brdrw10 \clbrdrl\brdrs\brdrw10 \clbrdrb\brdrs\brdrw10 \clbrdrr\brdrs\brdrw10 \cltxlrtb\clftsWidth3\clwWidth4680\clshdrawnil \cellx9360\pard\plain \ql \li0\ri0\widctlpar\intbl\faauto\rin0\lin0\pararsid14292103';
          v_tempstring := v_tempstring || '\fs20\lang1033\langfe1033\cgrid\langnp1033\langfenp1033 ' || v_lastunitname || '\cell \cell \pard \ql \li0\ri0\widctlpar\intbl\aspalpha\aspnum\faauto\adjustright\rin0\lin0 \trowd \irow0\irowband0\lastrow \ts11\trgaph108\trleft0';
          v_tempstring := v_tempstring || '\trbrdrt\brdrs\brdrw10 \trbrdrl\brdrs\brdrw10 \trbrdrb\brdrs\brdrw10 \trbrdrr\brdrs\brdrw10 \trftsWidth1\trpaddl108\trpaddr108\trpaddfl3\trpaddft3\trpaddfb3\trpaddfr3\tblrsid14292103 \clvertalt\clbrdrt\brdrs\brdrw10 \clbrdrl\brdrs\brdrw10 \clbrdrb';
          v_tempstring := v_tempstring || '\brdrs\brdrw10 \clbrdrr\brdrs\brdrw10 \cltxlrtb\clftsWidth3\clwWidth4680\clshdrawnil \cellx4680\clvertalt\clbrdrt\brdrs\brdrw10 \clbrdrl\brdrs\brdrw10 \clbrdrb\brdrs\brdrw10 \clbrdrr\brdrs\brdrw10 \cltxlrtb\clftsWidth3\clwWidth4680\clshdrawnil \cellx9360';
          v_tempstring := v_tempstring || '\row \pard \ql \li0\ri0\widctlpar\faauto\rin0\lin0\itap0 ';

        end if;

        v_ok := core_template.replace_tag(v_template, 'NOTIFY', v_tempstring);

        --- Other Agency Involvement ---
        v_tempstring := null;

        for a in (select   first_name || ' ' || last_name as name, prt.role as involvement_role,
                           r.description as response, pi.response_date, pi.agency_file_num,
                           pi.action_date
                      from t_osi_partic_involvement pi,
                           t_osi_partic_name pn,
                           t_osi_participant_version pv,
                           t_osi_partic_role_type prt,
                           t_osi_reference r
                     where pi.obj = psid
                       and pi.participant_version = pn.participant_version
                       and pv.current_name = pn.SID
                       and pi.involvement_role = prt.SID
                       and prt.usage='OTHER AGENCIES' --prt.role = 'Referred to Other Agency'
                       and pi.response = r.SID(+)
                       and prt.obj_type = core_obj.lookup_objtype('FILE.INV')
                  order by action_date, response_date)
        loop
            --- Action ---
            v_tempstring := v_tempstring || a.involvement_role || ' ' || a.name || ' on ' || to_char(a.action_date, v_date_fmt) || '.';

            --- Response ---
            if a.response is not null then

              v_tempstring := v_tempstring || ' ' || a.response || ' on ' || to_char(a.response_date, v_date_fmt) || '.';

            end if;

            if a.agency_file_num is not null then

              v_tempstring := v_tempstring || '  Other agency file number: ' || a.agency_file_num || '.';

            end if;

            v_tempstring := v_tempstring || '\par \par ';

        end loop;

        v_ok := core_template.replace_tag(v_template, 'OTHERAGENCY', v_tempstring);
/*
--Commented out per CHG0003277
        --- Get Notes ---
        v_tempstring := null;
        v_recordcounter := 1;

        for a in (select   note_text
                      from t_osi_note
                     where obj = psid
                        or obj in(select activity_sid
                                    from t_osi_assoc_fle_act
                                   where file_sid = psid)
                        or obj in(select that_file
                                    from v_osi_assoc_fle_fle
                                   where this_file = psid)
                  order by create_on)
        loop
            v_tempstring := v_tempstring || v_recordcounter || '.  ' || a.note_text || '\par\par ';
            v_recordcounter := v_recordcounter + 1;
        end loop;

        v_ok := core_template.replace_tag(v_template, 'NOTES', v_tempstring);
*/
        log_error('<<< Summary_Complaint_Report');
        return v_template;
        core_util.cleanup_temp_clob(v_template);
    exception
        when others then
            log_error('Error: ' || sqlerrm);
            log_error('<<< Summary_Complaint_Report');
            return v_template;
    end summary_complaint_rpt;

    procedure get_basic_info(ppopv in varchar2, presult out varchar2, psaa out varchar2, pper out varchar2, pincludename in boolean := true, pnameonly in boolean := false, pincludemaiden in boolean := true, pincludeaka in boolean := true, plnfirst in varchar2 := 'Y') is

         v_result   varchar2(4000);
         v_temp     varchar2(2000);
         v_sex      varchar2(100);
         v_dob      date;
         v_pob      varchar2(100);
         v_pp       varchar2(100);
         v_pg       varchar2(100);
         v_ppg      varchar2(400);
         v_saa      varchar2(100);
         v_per      varchar2(20);
         v_pt       varchar2(50);
         v_ssn      varchar2(11);

    begin
         v_result := '';
         log_error('start get_basic_info');

         if pincludename = true then

           --- Get Names ---
           v_result := v_result || osi_participant.get_name(ppopv, plnfirst) || ', ';

           if pincludemaiden = true then
             
             v_temp := osi_participant.name_set(ppopv,'M');
             if v_temp is not null then

               v_result := v_result || 'NEE: ' || v_temp || ', ';

             end if;

           end if;

           if pincludeaka = true then
           
             v_temp := osi_participant.name_set(ppopv,'AKA');
             if v_temp is not null then

               v_result := v_result || 'AKA: ' || v_temp || ', ';

             end if;
           end if;

           v_result := rtrim(replace(v_result, '; ', ', '), ', ') || '; ';
           
        end if;

        if pnameonly = false then

          --- Get Sex, Birthdate, Birth State or Country, Pay Grade ---
          for b in (select sex_desc, dob, nvl(pa.state_desc, pa.country_desc) as pob, 
                 ---sa_pay_plan_desc, sa_pay_grade_desc, sa_affiliation_code,
                 DECODE(pv.SA_PAY_PLAN_CODE, 'GS', 'GS', 'ES', 'ES', NULL, '', SUBSTR(pv.SA_PAY_PLAN_CODE,1,1)) as pp,
                 LTRIM(pv.SA_PAY_GRADE_CODE, '0') as pg,
                 NVL(pv.SA_AFFILIATION_CODE,'none') as saa, 
                 pv.participant as per, 
                 pv.obj_type_desc as pt
              from v_osi_participant_version pv, v_osi_partic_address pa
             where pv.SID = ppopv 
               and pv.current_version = pa.participant_version(+)
               and pa.type_code(+) = 'BIRTH')
          loop
              v_sex := b.sex_desc;
              v_dob := b.dob;
              v_pob := b.pob;
              v_pp := b.pp;
              v_pg := b.pg;
              v_saa := b.saa;
              v_per := b.per;
              v_pt := b.pt;

              exit;          
          
          end loop;

          if v_pt = 'Individual' then

            --- Sex Born:  DOB ---
            v_result := v_result || nvl(v_sex, 'UNK') || ' Born: ' || nvl(to_char(v_dob, v_date_fmt), 'UNK') || '; ';

            --- Place of Birth ---
            v_result := v_result || nvl(v_pob, 'UNK') || '; ';

            --- If Civilian, put in "CIV" keyword, else Paygrade ---
            v_ppg := v_pp || '-' || v_pg;

            if v_ppg = '-' then

              v_ppg := 'Civ';

            end if;

            v_result := v_result || v_ppg || '; ';

            --- SSN ---
            v_ssn := osi_participant.get_number(ppopv, 'SSN');
            v_ssn := substr(v_ssn, 1, 3) || '-' || substr(v_ssn, 4, 2) || '-' || substr(v_ssn, 6, 4);

            if v_ssn = null or length(v_ssn) = 0 or v_ssn = '--' then

              v_ssn := 'UNK';

            end if;

            v_result := v_result || 'SSN: ' || v_ssn || '; ';

          else

            null;

          end if;

        end if;

        presult := v_result;
        psaa := v_saa;
        pper := v_per;
        return;
    exception
        when no_data_found then
            presult := null;
            core_logger.log_it(c_pipe, 'end get_basic_info');
            return;
    end get_basic_info;

    function get_org_info(ppopv in varchar2, preplacenullwithunk in boolean := false) return varchar2 is

         v_result     varchar2(4000) := NULL;
         v_org        varchar2(20);
         v_org_name   varchar2(100);
         v_base       varchar2(100);
         v_base_loc   varchar2(100);
         v_pv_sid     varchar2(20);

    begin
         log_error('--->OSI_INVESTIGATION.Get_Org_Info(' || ppopv || ') - ' || sysdate);

         --- Get Participant SID ---
         v_org := osi_participant.Latest_Org(ppopv);
         
         --- Get Current Version SID ---
         v_pv_sid := osi_participant.get_current_version(v_org);
         
         log_error('OSI_INVESTIGATION.Get_Org_Info - v_org = ' || v_org);

         if v_org is not null then

           select osi_participant.get_name(v_org, 'N'), pa.city, nvl(pa.state_desc, pa.country_desc) into v_org_name, v_base, v_base_loc
              from t_osi_participant_version pv, v_osi_partic_address pa
             where pv.sid=v_pv_sid and pa.participant_version(+) = pv.SID and pa.is_current(+) = 'Y';    

           if preplacenullwithunk = true then
           
             v_result := nvl(v_org_name, 'UNK') || ', ' || nvl(v_base, 'UNK') || ', ' || nvl(v_base_loc, 'UNK');
           
           else
           
             v_result := v_org_name || ', ' || v_base || ', ' || v_base_loc;
           
           end if;
           
         end if;

         log_error('<---OSI_INVESTIGATION.Get_Org_Info return:  ' || v_result || ' - ' || sysdate);
         return(v_result);
         
    exception
         when no_data_found then
             return(null);
    end get_org_info;

    function getparticipantname(ppersonversionsid in varchar2, pshortname in boolean := true) return varchar2 is
         v_tmp   varchar2(1000) := null;
    begin
         log_error('--->GetParticipantName(' || ppersonversionsid || ')-' || sysdate);
         
         if pshortname = true then

           log_error('GetParticipantName-True');
         
         else
           
           log_error('GetParticipantName-False');
         
         end if;

         if pshortname = true then

           for s in (select short from t_osi_reports_partic_used where person_version = ppersonversionsid order by rowid)
           loop
               v_tmp := s.short;

           end loop;

           if v_tmp is null then

             v_tmp := '';

           end if;

         else

           for s in (select osi_participant.get_name(pv.SID) as pname, 
                            pv.sa_rank as rank,
                            decode(pv.sa_pay_plan_code, 'GS', 'GS', 'ES', 'ES', null, '', substr(pv.sa_pay_plan_code, 1, 1)) || '-' || ltrim(pv.sa_pay_grade_code, '0') as grade,
                            pv.sa_affiliation_code as saa, 
                            pv.ind_title as title, 
                            pv.SID as pvsid
                       from v_osi_participant_version pv
                      where pv.SID = ppersonversionsid)
           loop
               if s.saa = 'ME' then                                 

                 --- military (or employee) ---
                 v_tmp := v_tmp || s.pname || ', ' || nvl(s.title, nvl(s.rank, 'UNK') || ', ' || nvl(s.grade, 'UNK')) || ', ' || nvl(get_org_info(s.pvsid, true), 'UNK');

               else                                         

                 --- civilian or military dependent  ---
                 v_tmp := v_tmp || s.pname || ', ' || nvl(osi_participant.get_address_data(s.pvsid, 'CURRENT', 'DISPLAY'), 'UNK');
 
               end if;
 
           end loop;

         end if;

         log_error('<---GetParticipantName return: ' || v_tmp || ' - ' || sysdate);
         return v_tmp;

    end getparticipantname;

    function getsubjectofactivity(pshortname in boolean := false)
        return varchar2 is
        vtmp   varchar2(10000) := null;
    begin
        vtmp := null;

        for s in (select pv.SID
                    from t_osi_partic_involvement pi,
                         t_osi_participant_version pv,
                         t_osi_partic_role_type prt
                   where pi.involvement_role = prt.SID
                     --and prt.usage = 'SUBJECT'
                     and upper(prt.role) in ('SUBJECT OF ACTIVITY','SUBJECT')
                     and pv.SID = pi.participant_version
                     and pi.obj = v_act_sid)
        loop
            vtmp := getparticipantname(s.SID, pshortname);
        end loop;

        return rtrim(vtmp, ', ');
    exception
        when others then
            raise;
            return '<<GetSubjectOfActivity>>';
    end getsubjectofactivity;

    procedure load_activity(psid in varchar2) is
/*
    Loads information about the specified activity (and it's type)
    into package variables.
*/
        lead_prefix   varchar2(100) := null;
    begin
        select a.SID, a.title, cot.description, a.activity_date, a.complete_date, a.narrative,
               cot.SID, cot.code
          into v_act_sid, v_act_title, v_act_desc, v_act_date, v_act_complt_date, v_act_narrative,
               v_obj_type_sid, v_obj_type_code
          from t_osi_activity a, t_core_obj o, t_core_obj_type cot
         where a.SID = psid and a.SID = o.SID and o.obj_type = cot.SID;

        lead_prefix := core_util.get_config('OSI.LEAD_PREFIX');

        if substr(v_act_title, 1, length(lead_prefix)) = lead_prefix then
            v_act_title :=
                substr(v_act_title,
                       length(lead_prefix) + 1,
                       length(v_act_title) - length(lead_prefix));
        end if;

        --- Get the Activity's Masking Value ---
        begin
            select mt.mask
              into v_mask
              from t_osi_obj_mask m, t_osi_obj_mask_type mt
             where m.obj = psid and m.mask_type = mt.SID;
        exception
            when others then
                v_mask := null;
        end;

        if upper(v_mask) = 'NONE' then
            v_mask := null;
        end if;
    end load_activity;

    function get_f40_place(p_obj in varchar2)
        return varchar2 is
        v_return           varchar2(1000) := null;
        v_create_by_unit   varchar2(20);
        v_name             varchar2(100);
        v_obj_type_code    varchar2(200);
    begin
        --Note: This was originally added here for the Consultation/Coordination activity
        --If you need to add other activities, this will need to be modified.
        select creating_unit
          into v_create_by_unit
          from t_osi_activity
         where SID = p_obj;

        --Get object type code
        v_obj_type_code := osi_object.get_objtype_code(core_obj.get_objtype(p_obj));

        if v_obj_type_code like 'ACT.INTERVIEW%' then                               -- interviews --
            log_error('f40 place for interviews');
            v_return := osi_address.get_addr_display(osi_address.get_address_sid(p_obj));
        elsif v_obj_type_code like 'ACT.BRIEFING%' then                              -- briefings --
            select location
              into v_return
              from t_osi_a_briefing
             where SID = p_obj;
        elsif v_obj_type_code like 'ACT.SOURCE%' then                             -- source meets --
            v_return := osi_address.get_addr_display(osi_address.get_address_sid(p_obj));
        elsif v_obj_type_code like 'ACT.SEARCH%' then                                 -- searches --
            v_return := osi_address.get_addr_display(osi_address.get_address_sid(p_obj));
        elsif v_obj_type_code like 'ACT.POLY%' then                                 -- polygraphs --
            v_return := osi_address.get_addr_display(osi_address.get_address_sid(p_obj));
--                select location
--                  into v_return
--                  from t_act_poly_exam
--                 where sid = psid;
        elsif v_obj_type_code like 'ACT.SURV%' then                                 -- polygraphs --
            v_return := osi_address.get_addr_display(osi_address.get_address_sid(p_obj));
        else
            --This is the displayed text for all other types
            v_name := osi_unit.get_name(osi_object.get_assigned_unit(p_obj));
            v_return :=
                v_name || ', '
                || osi_address.get_addr_display
                                  (osi_address.get_address_sid(osi_object.get_assigned_unit(p_obj)));
        end if;

        v_return := replace(v_return, chr(13) || chr(10), ' ');                            -- CRLF's
        v_return := replace(v_return, chr(10), ' ');                                         -- LF's
        v_return := rtrim(v_return, ', ');
        return v_return;
    exception
        when no_data_found then
            raise;
            return null;
    end get_f40_place;

    function get_f40_date(psid in varchar2)
        return date is
    begin
        load_activity(psid);
        return nvl(v_act_date, v_act_complt_date);
    exception
        when no_data_found then
            return null;
    end get_f40_date;

    function roi_toc_interview
        return varchar2 is
        vtmp   varchar2(3000);
    begin
        log_error('>>>ROI_TOC_Interview-' || v_act_sid);
        vtmp := getsubjectofactivity(true);

        if v_mask is not null then
            vtmp := v_mask;
        end if;

        log_error('<<<ROI_TOC_Interview-' || v_act_sid);
        return vtmp;
    exception
        when others then
            return '<<Error during ROI_TOC_Interview>> - ' || sqlerrm;
    end roi_toc_interview;

    function roi_toc_docreview
        return varchar2 is
        v_doc_type      varchar2(1000);
        v_explanation   varchar2(1000);
        v_participant   varchar2(1000);
    begin
        log_error('>>>ROI_TOC_DocReview-' || v_act_sid);

        select r.description, dr.explanation
          into v_doc_type, v_explanation
          from t_osi_a_document_review dr, t_osi_reference r
         where dr.SID = v_act_sid and dr.doc_type = r.SID;

        v_participant := getsubjectofactivity(true);

        if v_doc_type = 'Other' then
            if v_explanation is not null then
                v_doc_type := v_explanation;
            end if;
        end if;

        if    v_participant is null
           or v_participant = '' then
            v_doc_type := v_doc_type || v_newline;
        else
            v_doc_type := v_doc_type || ', ' || v_participant || v_newline;
        end if;

        log_error('<<<ROI_TOC_DocReview-' || v_act_sid);
        return v_doc_type;
    exception
        when no_data_found then
            return v_act_title;
        when others then
            return '<<Error during ROI_TOC_DocReview>> - ' || sqlerrm;
    end roi_toc_docreview;

    function roi_toc_consultation
        return varchar2 is
        vtmp   varchar2(1000);
    begin
        log_error('>>>ROI_TOC_Consultation-' || v_act_sid);
        vtmp :=
               ltrim(rtrim(replace(replace(v_act_desc, 'Coordination,', ''), 'Consultation,', '')));

        if vtmp = 'Other' then
            vtmp := v_act_title;
        end if;

        log_error('<<<ROI_TOC_Consultation-' || v_act_sid);
        return vtmp;
    exception
        when others then
            return '<<Error during ROI_TOC_Consultation>> - ' || sqlerrm;
    end roi_toc_consultation;

    function roi_toc_sourcemeet
        return varchar2 is
        v_meet_date   t_osi_a_source_meet.next_meet_date%type;
    begin
        log_error('>>>ROI_TOC_SourceMeet-' || v_act_sid);
        v_meet_date := get_f40_date(v_act_sid);
        log_error('<<<ROI_TOC_SourceMeet-' || v_act_sid);
        return 'CS Information';
    exception
        when no_data_found then
            return 'CS Information; Date not determined';
        when others then
            return '<<Error during ROI_TOC_SourceMeet>> - ' || sqlerrm;
    end roi_toc_sourcemeet;

    function roi_toc_search
        return varchar2 is
        vtmp           varchar2(3000);
        vexplanation   varchar2(200);
    begin
        log_error('>>>ROI_TOC_Search-' || v_act_sid);

        --- Search of Person ---
        if v_act_desc = 'Search of Person' then
            vtmp := 'Person ' || getsubjectofactivity(true);
        --- Search of Place/Property '30', '40' ---
        else
            select decode(explanation, null, '*Not Specified*', '', '*Not Specified*', explanation)
              into vexplanation
              from t_osi_a_search
             where SID = v_act_sid;

            if v_act_desc = 'Search of Place' then
                vtmp := 'Place ' || vexplanation;
            elsif v_act_desc = 'Search of Property' then
                vtmp := 'Property ' || vexplanation;
            end if;
        end if;

        log_error('<<<ROI_TOC_Search-' || v_act_sid);
        return vtmp;
    exception
        when others then
            return '<<Error during ROI_TOC_Search>> - ' || sqlerrm;
    end roi_toc_search;

    function roi_toc(psid in varchar2)
        return varchar2 is
/*
    Returns the TOC (Table of Contents) string for the specified activity.
*/
    begin
        load_activity(psid);

        if v_mask is not null then
            return roi_toc_interview;
        else
            if v_act_desc = 'Group Interview' then
                return 'Group Interview';
            elsif v_act_desc like 'Interview%' then
                return roi_toc_interview;
            elsif v_act_desc like 'Document Review' then
                return roi_toc_docreview;
            elsif    v_act_desc like 'Consultation%'
                  or v_act_desc like 'Coordination%' then
                return roi_toc_consultation;
            elsif v_act_desc like 'Source Meet' then
                return roi_toc_sourcemeet;
            elsif v_act_desc like 'Search%' then
                return roi_toc_search;
            elsif v_act_desc = 'Law Enforcement Records Check' then
                return roi_toc_docreview;
            elsif v_act_desc = 'Exception' then
                return v_act_title;
            else
                return v_act_desc;
            end if;
        end if;
    exception
        when no_data_found then
            return null;
    end roi_toc;

    function roi_header_interview(preturntable in varchar2 := 'N')
        return clob is
        v_tmp   clob := null;
    begin
        log_error('>>>ROI_Header_Interview-' || v_act_sid);

        if v_act_desc = 'Interview, Witness' then
            if v_mask is not null then
                v_tmp := v_tmp || v_mask;
            else
                --- Witness Interview ---
                v_tmp := v_tmp || getsubjectofactivity;
            end if;
        else
            --- Subject/Victim Interviews ---
            v_tmp := roi_toc_interview;
        end if;

        if preturntable = 'Y' then
            v_tmp := v_tmp || '\pard\par ';
            v_tmp :=
                v_tmp
                || '\trowd \irow0\irowband0\lastrow \ts18\trgaph108\trleft-108\trftsWidth3\trwWidth9576\trftsWidthB3\trftsWidthA3\trautofit1\trpaddl108\trpaddr108\trpaddfl3\trpaddft3\trpaddfb3\trpaddfr3\tblrsid15077147\tbllkhdrrows\tbllklastrow\tbllkhdrcols\tbllklastcol';
            v_tmp :=
                v_tmp
                || '\clvertalt\clbrdrt\brdrtbl \clbrdrl\brdrtbl \clbrdrb\brdrtbl \clbrdrr\brdrtbl \cltxlrtb\clftsWidth3\clwWidth2397\clshdrawnil \cellx2289\clvertalt\clbrdrt\brdrtbl \clbrdrl\brdrtbl \clbrdrb\brdrtbl \clbrdrr\brdrtbl';
            v_tmp :=
                v_tmp
                || '\cltxlrtb\clftsWidth3\clwWidth7179\clshdrawnil \cellx9468\pard\plain \ql \li0\ri0\widctlpar\intbl\aspalpha\aspnum\faauto\adjustright\rin0\lin0\yts18 \fs22\lang1033\langfe1033\cgrid\langnp1033\langfenp1033 \tab Date/Place:';
            v_tmp :=
                v_tmp || '\cell ' || to_char(v_act_date, v_date_fmt) || '/'
                || get_f40_place(v_act_sid)
                || ' \cell \pard\plain \ql \li0\ri0\widctlpar\intbl\aspalpha\aspnum\faauto\adjustright\rin0\lin0 \fs22\lang1033\langfe1033\cgrid\langnp1033\langfenp1033';
            v_tmp :=
                v_tmp
                || '\trowd \irow0\irowband0\lastrow \ts18\trgaph108\trleft-108\trftsWidth3\trwWidth9576\trftsWidthB3\trftsWidthA3\trautofit1\trpaddl108\trpaddr108\trpaddfl3\trpaddft3\trpaddfb3\trpaddfr3\tblrsid15077147\tbllkhdrrows\tbllklastrow\tbllkhdrcols\tbllklastcol';
            v_tmp :=
                v_tmp
                || '\clvertalt\clbrdrt\brdrtbl \clbrdrl\brdrtbl \clbrdrb\brdrtbl \clbrdrr\brdrtbl \cltxlrtb\clftsWidth3\clwWidth2397\clshdrawnil \cellx2289\clvertalt\clbrdrt\brdrtbl \clbrdrl\brdrtbl \clbrdrb\brdrtbl \clbrdrr\brdrtbl';
            v_tmp :=
                v_tmp
                || '\cltxlrtb\clftsWidth3\clwWidth7179\clshdrawnil \cellx9468\row \pard \ql \li0\ri0\widctlpar\faauto\rin0\lin0\itap0';
            v_tmp :=
                v_tmp
                || '\trowd \irow0\irowband0\lastrow \ts18\trgaph108\trleft-108\trftsWidth3\trwWidth9576\trftsWidthB3\trftsWidthA3\trautofit1\trpaddl108\trpaddr108\trpaddfl3\trpaddft3\trpaddfb3\trpaddfr3\tblrsid15077147\tbllkhdrrows\tbllklastrow\tbllkhdrcols\tbllklastcol';
            v_tmp :=
                v_tmp
                || '\clvertalt\clbrdrt\brdrtbl \clbrdrl\brdrtbl \clbrdrb\brdrtbl \clbrdrr\brdrtbl \cltxlrtb\clftsWidth3\clwWidth2397\clshdrawnil \cellx2289\clvertalt\clbrdrt\brdrtbl \clbrdrl\brdrtbl \clbrdrb\brdrtbl \clbrdrr\brdrtbl';
            v_tmp :=
                v_tmp
                || '\cltxlrtb\clftsWidth3\clwWidth7179\clshdrawnil \cellx9468\pard\plain \ql \li0\ri0\widctlpar\intbl\aspalpha\aspnum\faauto\adjustright\rin0\lin0\yts18 \fs22\lang1033\langfe1033\cgrid\langnp1033\langfenp1033 \tab Agent(s):';
            v_tmp :=
                v_tmp || '\cell ' || osi_report.get_assignments(v_act_sid, null, '; ')
                || ' \cell \pard\plain \ql \li0\ri0\widctlpar\intbl\aspalpha\aspnum\faauto\adjustright\rin0\lin0 \fs22\lang1033\langfe1033\cgrid\langnp1033\langfenp1033';
            v_tmp :=
                v_tmp
                || '\trowd \irow0\irowband0\lastrow \ts18\trgaph108\trleft-108\trftsWidth3\trwWidth9576\trftsWidthB3\trftsWidthA3\trautofit1\trpaddl108\trpaddr108\trpaddfl3\trpaddft3\trpaddfb3\trpaddfr3\tblrsid15077147\tbllkhdrrows\tbllklastrow\tbllkhdrcols\tbllklastcol';
            v_tmp :=
                v_tmp
                || '\clvertalt\clbrdrt\brdrtbl \clbrdrl\brdrtbl \clbrdrb\brdrtbl \clbrdrr\brdrtbl \cltxlrtb\clftsWidth3\clwWidth2397\clshdrawnil \cellx2289\clvertalt\clbrdrt\brdrtbl \clbrdrl\brdrtbl \clbrdrb\brdrtbl \clbrdrr\brdrtbl';
            v_tmp :=
                v_tmp
                || '\cltxlrtb\clftsWidth3\clwWidth7179\clshdrawnil \cellx9468\row \pard \ql \li0\ri0\widctlpar\faauto\rin0\lin0\itap0';
        else
            v_tmp := v_tmp || v_newline;
            v_tmp :=
                v_tmp || 'Date/Place: ' || to_char(v_act_date, v_date_fmt) || '/'
                || get_f40_place(v_act_sid) || v_newline;
            v_tmp := v_tmp || 'Agent(s): ' || osi_report.get_assignments(v_act_sid, null, '; ');
        end if;

        log_error('<<<ROI_Header_Interview-' || v_act_sid);
        return v_tmp;
    exception
        when no_data_found then
            return '<<Error during ROI_Header_Interview>> - ' || sqlerrm;
    end roi_header_interview;

-- Incidental/Group Interview --
    function roi_header_incidental_int(preturntable in varchar2 := 'N') return clob is
        v_tmp                clob          := null;
        vcount               number;
        vdatestring          varchar2(100);
        vmindate             date;
        vmaxdate             date;
        vprinteachdate       boolean;
        vlastaddr1           varchar2(100);
        vlastaddr2           varchar2(100);
        vlastcity            varchar2(30);
        vlaststate           varchar2(10);
        vlastprovince        varchar2(30);
        vlastzip             varchar2(30);
        vlastcountry         varchar2(100);
        vaddressstring       varchar2(500);
        vmultiplelocations   varchar2(20);
    begin
        log_error('>>>ROI_Header_Incidental_Int-' || v_act_sid);

        begin
            select min(t_g.interview_date), max(t_g.interview_date)
              into vmindate, vmaxdate
              from t_osi_a_gi_involvement t_g
             where t_g.gi = v_act_sid;

            if vmindate = vmaxdate then
                vdatestring := to_char(vmindate, v_date_fmt);
                vprinteachdate := false;
            else
                vdatestring :=
                             to_char(vmindate, v_date_fmt) || ' - '
                             || to_char(vmaxdate, v_date_fmt);
                vprinteachdate := true;
            end if;
        exception
            when others then
                vdatestring := to_char(get_f40_date(v_act_sid), v_date_fmt);
        end;

        vcount := 1;

        for a in (select a.address_1, a.address_2, a.city, a.province, s.code as state,
                         a.postal_code, c.description as country
                    from t_osi_address a,
                         t_osi_partic_address pa,
                         t_osi_addr_type t,
                         t_dibrs_country c,
                         t_dibrs_state s
                   where (pa.participant_version in(select participant_version
                                                      from t_osi_a_gi_involvement
                                                     where gi = v_act_sid))
                     and a.SID = pa.address(+)
                     and a.address_type = t.SID
                     and a.state = s.SID(+)
                     and a.country = c.SID(+))
        loop
            vaddressstring := '';

            if vcount = 1 then
                vlastaddr1 := a.address_1;
                vlastaddr2 := a.address_2;
                vlastcity := a.city;
                vlaststate := a.state;
                vlastprovince := a.province;
                vlastzip := a.postal_code;
                vlastcountry := a.country;
            else
                log_error(vcount || ':  ' || vlastaddr1 || '--' || a.address_1);

                if vlastaddr1 <> a.address_1 and vlastaddr1 <> '~~DU~~' then
                    vmultiplelocations := 'Multiple Locations, ';
                    vlastaddr1 := '~~DU~~';
                end if;

                log_error(vlastaddr2 || '--' || a.address_2);

                if vlastaddr2 <> a.address_2 and vlastaddr2 <> '~~DU~~' then
                    vmultiplelocations := 'Multiple Locations, ';
                    vlastaddr2 := '~~DU~~';
                end if;

                log_error(vlastcity || '--' || a.city);

                if vlastcity <> a.city and vlastcity <> '~~DU~~' then
                    vmultiplelocations := 'Multiple Locations, ';
                    vlastcity := '~~DU~~';
                end if;

                log_error(vlaststate || '--' || a.state);

                if vlaststate <> a.state and vlaststate <> '~~DU~~' then
                    vmultiplelocations := 'Multiple Locations, ';
                    vlaststate := '~~DU~~';
                end if;

                log_error(vlastprovince || '--' || a.province);

                if vlastprovince <> a.province and vlastprovince <> '~~DU~~' then
                    vmultiplelocations := 'Multiple Locations, ';
                    vlastprovince := '~~DU~~';
                end if;

                log_error(vlastzip || '--' || a.postal_code);

                if vlastzip <> a.postal_code and vlastzip <> '~~DU~~' then
                    vmultiplelocations := 'Multiple Locations, ';
                    vlastzip := '~~DU~~';
                end if;

                log_error(vlastcountry || '--' || a.country);

                if vlastcountry <> a.country and vlastcountry <> '~~DU~~' then
                    vmultiplelocations := 'Multiple Locations, ';
                    vlastcountry := '~~DU~~';
                end if;
            end if;

            vcount := vcount + 1;
        end loop;

        vaddressstring := vmultiplelocations;

        if vlastaddr1 <> '~~DU~~' then
            vaddressstring := vaddressstring || vlastaddr1 || ', ';
        end if;

        if vlastaddr2 <> '~~DU~~' then
            vaddressstring := vaddressstring || vlastaddr2 || ', ';
        end if;

        if vlastcity <> '~~DU~~' then
            vaddressstring := vaddressstring || vlastcity || ', ';
        end if;

        if vlaststate <> '~~DU~~' then
            vaddressstring := vaddressstring || vlaststate || ', ';
        end if;

        if vlastprovince <> '~~DU~~' then
            vaddressstring := vaddressstring || vlastprovince || ', ';
        end if;

        if vlastzip <> '~~DU~~' then
            vaddressstring := vaddressstring || vlastzip || ', ';
        end if;

        if vlastcountry <> '~~DU~~' then
            if vlastcountry <> 'United States of America' then
                vaddressstring := vaddressstring || vlastcountry;
            end if;
        end if;

        vaddressstring := rtrim(vaddressstring, ', ');

        if    vaddressstring = ''
           or vaddressstring is null then
            vaddressstring := '**Not Specified**';
            vaddressstring := osi_address.get_addr_display(osi_address.get_address_sid(v_act_sid));
        /* for a in (select   display_string_line
                      from v_address_v2
                     where parent = v_act_sid
                  order by selected asc)
        loop
            vaddressstring := a.display_string_line;
        end loop; */
        end if;

        v_tmp := roi_toc(v_act_sid);

        if preturntable = 'Y' then
            v_tmp :=
                v_tmp
                || '\pard\par \trowd \irow0\irowband0\lastrow \ts18\trgaph108\trleft-108\trftsWidth3\trwWidth9576\trftsWidthB3\trftsWidthA3\trautofit1\trpaddl108\trpaddr108\trpaddfl3\trpaddft3\trpaddfb3\trpaddfr3\tblrsid15077147\tbllkhdrrows\tbllklastrow\tbllkhdrcols\tbllklastcol';
            v_tmp :=
                v_tmp
                || '\clvertalt\clbrdrt\brdrtbl \clbrdrl\brdrtbl \clbrdrb\brdrtbl \clbrdrr\brdrtbl \cltxlrtb\clftsWidth3\clwWidth2397\clshdrawnil \cellx2289\clvertalt\clbrdrt\brdrtbl \clbrdrl\brdrtbl \clbrdrb\brdrtbl \clbrdrr\brdrtbl';
            v_tmp :=
                v_tmp
                || '\cltxlrtb\clftsWidth3\clwWidth7179\clshdrawnil \cellx9468\pard\plain \ql \li0\ri0\widctlpar\intbl\aspalpha\aspnum\faauto\adjustright\rin0\lin0\yts18 \fs22\lang1033\langfe1033\cgrid\langnp1033\langfenp1033 \tab Date/Place:';
            v_tmp :=
                v_tmp || '\cell ' || vdatestring || '/' || vaddressstring
                || ' \cell \pard\plain \ql \li0\ri0\widctlpar\intbl\aspalpha\aspnum\faauto\adjustright\rin0\lin0 \fs22\lang1033\langfe1033\cgrid\langnp1033\langfenp1033';
            v_tmp :=
                v_tmp
                || '\trowd \irow0\irowband0\lastrow \ts18\trgaph108\trleft-108\trftsWidth3\trwWidth9576\trftsWidthB3\trftsWidthA3\trautofit1\trpaddl108\trpaddr108\trpaddfl3\trpaddft3\trpaddfb3\trpaddfr3\tblrsid15077147\tbllkhdrrows\tbllklastrow\tbllkhdrcols\tbllklastcol';
            v_tmp :=
                v_tmp
                || '\clvertalt\clbrdrt\brdrtbl \clbrdrl\brdrtbl \clbrdrb\brdrtbl \clbrdrr\brdrtbl \cltxlrtb\clftsWidth3\clwWidth2397\clshdrawnil \cellx2289\clvertalt\clbrdrt\brdrtbl \clbrdrl\brdrtbl \clbrdrb\brdrtbl \clbrdrr\brdrtbl';
            v_tmp :=
                v_tmp
                || '\cltxlrtb\clftsWidth3\clwWidth7179\clshdrawnil \cellx9468\row \pard \ql \li0\ri0\widctlpar\faauto\rin0\lin0\itap0';
            v_tmp :=
                v_tmp
                || '\trowd \irow0\irowband0\lastrow \ts18\trgaph108\trleft-108\trftsWidth3\trwWidth9576\trftsWidthB3\trftsWidthA3\trautofit1\trpaddl108\trpaddr108\trpaddfl3\trpaddft3\trpaddfb3\trpaddfr3\tblrsid15077147\tbllkhdrrows\tbllklastrow\tbllkhdrcols\tbllklastcol';
            v_tmp :=
                v_tmp
                || '\clvertalt\clbrdrt\brdrtbl \clbrdrl\brdrtbl \clbrdrb\brdrtbl \clbrdrr\brdrtbl \cltxlrtb\clftsWidth3\clwWidth2397\clshdrawnil \cellx2289\clvertalt\clbrdrt\brdrtbl \clbrdrl\brdrtbl \clbrdrb\brdrtbl \clbrdrr\brdrtbl';
            v_tmp :=
                v_tmp
                || '\cltxlrtb\clftsWidth3\clwWidth7179\clshdrawnil \cellx9468\pard\plain \ql \li0\ri0\widctlpar\intbl\aspalpha\aspnum\faauto\adjustright\rin0\lin0\yts18 \fs22\lang1033\langfe1033\cgrid\langnp1033\langfenp1033 \tab Agent(s):';
            v_tmp :=
                v_tmp || '\cell ' || osi_report.get_assignments(v_act_sid, null, '; ')
                || ' \cell \pard\plain \ql \li0\ri0\widctlpar\intbl\aspalpha\aspnum\faauto\adjustright\rin0\lin0 \fs22\lang1033\langfe1033\cgrid\langnp1033\langfenp1033';
            v_tmp :=
                v_tmp
                || '\trowd \irow0\irowband0\lastrow \ts18\trgaph108\trleft-108\trftsWidth3\trwWidth9576\trftsWidthB3\trftsWidthA3\trautofit1\trpaddl108\trpaddr108\trpaddfl3\trpaddft3\trpaddfb3\trpaddfr3\tblrsid15077147\tbllkhdrrows\tbllklastrow\tbllkhdrcols\tbllklastcol';
            v_tmp :=
                v_tmp
                || '\clvertalt\clbrdrt\brdrtbl \clbrdrl\brdrtbl \clbrdrb\brdrtbl \clbrdrr\brdrtbl \cltxlrtb\clftsWidth3\clwWidth2397\clshdrawnil \cellx2289\clvertalt\clbrdrt\brdrtbl \clbrdrl\brdrtbl \clbrdrb\brdrtbl \clbrdrr\brdrtbl';
            v_tmp :=
                v_tmp
                || '\cltxlrtb\clftsWidth3\clwWidth7179\clshdrawnil \cellx9468\row \pard \ql \li0\ri0\widctlpar\faauto\rin0\lin0\itap0';
            v_tmp :=
                v_tmp
                || '\trowd \irow0\irowband0\lastrow \ts18\trgaph108\trleft-108\trftsWidth3\trwWidth9576\trftsWidthB3\trftsWidthA3\trautofit1\trpaddl108\trpaddr108\trpaddfl3\trpaddft3\trpaddfb3\trpaddfr3\tblrsid15077147\tbllkhdrrows\tbllklastrow\tbllkhdrcols\tbllklastcol';
            v_tmp :=
                v_tmp
                || '\clvertalt\clbrdrt\brdrtbl \clbrdrl\brdrtbl \clbrdrb\brdrtbl \clbrdrr\brdrtbl \cltxlrtb\clftsWidth3\clwWidth2397\clshdrawnil \cellx2289\clvertalt\clbrdrt\brdrtbl \clbrdrl\brdrtbl \clbrdrb\brdrtbl \clbrdrr\brdrtbl';
            v_tmp :=
                v_tmp
                || '\cltxlrtb\clftsWidth3\clwWidth7179\clshdrawnil \cellx9468\pard\plain \ql \li0\ri0\widctlpar\intbl\aspalpha\aspnum\faauto\adjustright\rin0\lin0\yts18 \fs22\lang1033\langfe1033\cgrid\langnp1033\langfenp1033 \tab Interviewees:';
            v_tmp :=
                v_tmp
                || '\cell \cell \pard\plain \ql \li0\ri0\widctlpar\intbl\aspalpha\aspnum\faauto\adjustright\rin0\lin0 \fs22\lang1033\langfe1033\cgrid\langnp1033\langfenp1033';
            v_tmp :=
                v_tmp
                || '\trowd \irow0\irowband0\lastrow \ts18\trgaph108\trleft-108\trftsWidth3\trwWidth9576\trftsWidthB3\trftsWidthA3\trautofit1\trpaddl108\trpaddr108\trpaddfl3\trpaddft3\trpaddfb3\trpaddfr3\tblrsid15077147\tbllkhdrrows\tbllklastrow\tbllkhdrcols\tbllklastcol';
            v_tmp :=
                v_tmp
                || '\clvertalt\clbrdrt\brdrtbl \clbrdrl\brdrtbl \clbrdrb\brdrtbl \clbrdrr\brdrtbl \cltxlrtb\clftsWidth3\clwWidth2397\clshdrawnil \cellx2289\clvertalt\clbrdrt\brdrtbl \clbrdrl\brdrtbl \clbrdrb\brdrtbl \clbrdrr\brdrtbl';
            v_tmp :=
                v_tmp
                || '\cltxlrtb\clftsWidth3\clwWidth7179\clshdrawnil \cellx9468\row \pard \ql \li0\ri0\widctlpar\faauto\rin0\lin0\itap0';
        else
            v_tmp := v_tmp || v_newline;
            v_tmp := v_tmp || 'Date/Place: ' || vdatestring || '/' || vaddressstring || v_newline;
            v_tmp :=
                v_tmp || 'Agent(s): '
                || osi_report.get_assignments(v_act_sid, null, v_newline || '\tab  ') || v_newline;
            v_tmp := v_tmp || 'Interviewees: ';
        end if;

        if preturntable = 'N' then
            v_tmp := v_tmp || v_newline;
        end if;

        vcount := 1;

        for s in (select   pv.SID as participant_version,
                           nvl(to_char(gi.interview_date, 'FMDD Mon FMFXYY'),
                               'Not Interviewed') as datetouse
                      from t_osi_activity a,
                           t_osi_a_gi_involvement gi,
                           t_osi_participant_version pv,
                           t_osi_partic_name pn
                     where (a.SID = gi.gi)
                       and (pv.SID = gi.participant_version)
                       and (pn.SID = pv.current_name)
                       and a.SID = v_act_sid
                  order by gi.interview_date, pn.last_name)
        loop
            if preturntable = 'Y' then
                v_tmp := v_tmp || '\trowd \irow0\irowband0\lastrow \ts18\trgaph108\trleft-108\trftsWidth3\trwWidth9576\trftsWidthB3\trftsWidthA3\trautofit1\trpaddl108\trpaddr108\trpaddfl3\trpaddft3\trpaddfb3\trpaddfr3\tblrsid15077147\tbllkhdrrows\tbllklastrow\tbllkhdrcols\tbllklastcol';
                v_tmp := v_tmp || '\clvertalt\clbrdrt\brdrtbl \clbrdrl\brdrtbl \clbrdrb\brdrtbl \clbrdrr\brdrtbl \cltxlrtb\clftsWidth3\clwWidth2397\clshdrawnil \cellx2289\clvertalt\clbrdrt\brdrtbl \clbrdrl\brdrtbl \clbrdrb\brdrtbl \clbrdrr\brdrtbl';
                v_tmp := v_tmp || '\cltxlrtb\clftsWidth3\clwWidth7179\clshdrawnil \cellx9468\pard\plain \ql \li0\ri0\widctlpar\intbl\aspalpha\aspnum\faauto\adjustright\rin0\lin0\yts18 \fs22\lang1033\langfe1033\cgrid\langnp1033\langfenp1033 \qr ' || trim(to_char(vcount)) || '.';

                v_tmp := v_tmp || '\cell \ql ' || getparticipantname(s.participant_version, false);

                if vprinteachdate = true then

                  v_tmp := v_tmp || ',    ' || s.datetouse;

                end if;

                v_tmp := v_tmp || '\cell \pard\plain \ql \li0\ri0\widctlpar\intbl\aspalpha\aspnum\faauto\adjustright\rin0\lin0 \fs22\lang1033\langfe1033\cgrid\langnp1033\langfenp1033';
                v_tmp := v_tmp || '\trowd \irow0\irowband0\lastrow \ts18\trgaph108\trleft-108\trftsWidth3\trwWidth9576\trftsWidthB3\trftsWidthA3\trautofit1\trpaddl108\trpaddr108\trpaddfl3\trpaddft3\trpaddfb3\trpaddfr3\tblrsid15077147\tbllkhdrrows\tbllklastrow\tbllkhdrcols\tbllklastcol';
                v_tmp := v_tmp || '\clvertalt\clbrdrt\brdrtbl \clbrdrl\brdrtbl \clbrdrb\brdrtbl \clbrdrr\brdrtbl \cltxlrtb\clftsWidth3\clwWidth2397\clshdrawnil \cellx2289\clvertalt\clbrdrt\brdrtbl \clbrdrl\brdrtbl \clbrdrb\brdrtbl \clbrdrr\brdrtbl';
                v_tmp := v_tmp || '\cltxlrtb\clftsWidth3\clwWidth7179\clshdrawnil \cellx9468\row \pard \ql \li0\ri0\widctlpar\faauto\rin0\lin0\itap0';

            else
                if vcount > 1 then
                    v_tmp := v_tmp || v_newline;
                end if;

                v_tmp :=
                    v_tmp || '\tab        ' || vcount || '.  '
                    || getparticipantname(s.participant_version, false);

                if vprinteachdate = true then
                    v_tmp := v_tmp || ',    ' || s.datetouse;
                end if;
            end if;

            vcount := vcount + 1;
        end loop;

        log_error('<<<ROI_Header_Incidental_Int-' || v_act_sid);
        return v_tmp;
    exception when others then
             log_error('<<Error during ROI_Header_Incidental_int>> - ' || sqlerrm);
             return v_tmp;
    end roi_header_incidental_int;

    function roi_header_docreview(preturntable in varchar2 := 'N')
        return clob is
        v_tmp   clob;
    begin
        v_tmp := roi_toc_docreview;

        if preturntable = 'Y' then
            v_tmp := rtrim(v_tmp, v_newline);
            v_tmp := v_tmp || '\pard\par';
            v_tmp :=
                v_tmp
                || '\trowd \irow0\irowband0\lastrow \ts18\trgaph108\trleft-108\trftsWidth3\trwWidth9576\trftsWidthB3\trftsWidthA3\trautofit1\trpaddl108\trpaddr108\trpaddfl3\trpaddft3\trpaddfb3\trpaddfr3\tblrsid15077147\tbllkhdrrows\tbllklastrow\tbllkhdrcols\tbllklastcol';
            v_tmp :=
                v_tmp
                || '\clvertalt\clbrdrt\brdrtbl \clbrdrl\brdrtbl \clbrdrb\brdrtbl \clbrdrr\brdrtbl \cltxlrtb\clftsWidth3\clwWidth2397\clshdrawnil \cellx2289\clvertalt\clbrdrt\brdrtbl \clbrdrl\brdrtbl \clbrdrb\brdrtbl \clbrdrr\brdrtbl';
            v_tmp :=
                v_tmp
                || '\cltxlrtb\clftsWidth3\clwWidth7179\clshdrawnil \cellx9468\pard\plain \ql \li0\ri0\widctlpar\intbl\aspalpha\aspnum\faauto\adjustright\rin0\lin0\yts18 \fs22\lang1033\langfe1033\cgrid\langnp1033\langfenp1033 \tab Date:';
            v_tmp :=
                v_tmp || '\cell ' || to_char(v_act_date, v_date_fmt)
                || ' \cell \pard\plain \ql \li0\ri0\widctlpar\intbl\aspalpha\aspnum\faauto\adjustright\rin0\lin0 \fs22\lang1033\langfe1033\cgrid\langnp1033\langfenp1033';
            v_tmp :=
                v_tmp
                || '\trowd \irow0\irowband0\lastrow \ts18\trgaph108\trleft-108\trftsWidth3\trwWidth9576\trftsWidthB3\trftsWidthA3\trautofit1\trpaddl108\trpaddr108\trpaddfl3\trpaddft3\trpaddfb3\trpaddfr3\tblrsid15077147\tbllkhdrrows\tbllklastrow\tbllkhdrcols\tbllklastcol';
            v_tmp :=
                v_tmp
                || '\clvertalt\clbrdrt\brdrtbl \clbrdrl\brdrtbl \clbrdrb\brdrtbl \clbrdrr\brdrtbl \cltxlrtb\clftsWidth3\clwWidth2397\clshdrawnil \cellx2289\clvertalt\clbrdrt\brdrtbl \clbrdrl\brdrtbl \clbrdrb\brdrtbl \clbrdrr\brdrtbl';
            v_tmp :=
                v_tmp
                || '\cltxlrtb\clftsWidth3\clwWidth7179\clshdrawnil \cellx9468\row \pard \ql \li0\ri0\widctlpar\faauto\rin0\lin0\itap0';
            v_tmp :=
                v_tmp
                || '\trowd \irow0\irowband0\lastrow \ts18\trgaph108\trleft-108\trftsWidth3\trwWidth9576\trftsWidthB3\trftsWidthA3\trautofit1\trpaddl108\trpaddr108\trpaddfl3\trpaddft3\trpaddfb3\trpaddfr3\tblrsid15077147\tbllkhdrrows\tbllklastrow\tbllkhdrcols\tbllklastcol';
            v_tmp :=
                v_tmp
                || '\clvertalt\clbrdrt\brdrtbl \clbrdrl\brdrtbl \clbrdrb\brdrtbl \clbrdrr\brdrtbl \cltxlrtb\clftsWidth3\clwWidth2397\clshdrawnil \cellx2289\clvertalt\clbrdrt\brdrtbl \clbrdrl\brdrtbl \clbrdrb\brdrtbl \clbrdrr\brdrtbl';
            v_tmp :=
                v_tmp
                || '\cltxlrtb\clftsWidth3\clwWidth7179\clshdrawnil \cellx9468\pard\plain \ql \li0\ri0\widctlpar\intbl\aspalpha\aspnum\faauto\adjustright\rin0\lin0\yts18 \fs22\lang1033\langfe1033\cgrid\langnp1033\langfenp1033 \tab Agent(s):';
            v_tmp :=
                v_tmp || '\cell ' || osi_report.get_assignments(v_act_sid, null, '; ')
                || ' \cell \pard\plain \ql \li0\ri0\widctlpar\intbl\aspalpha\aspnum\faauto\adjustright\rin0\lin0 \fs22\lang1033\langfe1033\cgrid\langnp1033\langfenp1033';
            v_tmp :=
                v_tmp
                || '\trowd \irow0\irowband0\lastrow \ts18\trgaph108\trleft-108\trftsWidth3\trwWidth9576\trftsWidthB3\trftsWidthA3\trautofit1\trpaddl108\trpaddr108\trpaddfl3\trpaddft3\trpaddfb3\trpaddfr3\tblrsid15077147\tbllkhdrrows\tbllklastrow\tbllkhdrcols\tbllklastcol';
            v_tmp :=
                v_tmp
                || '\clvertalt\clbrdrt\brdrtbl \clbrdrl\brdrtbl \clbrdrb\brdrtbl \clbrdrr\brdrtbl \cltxlrtb\clftsWidth3\clwWidth2397\clshdrawnil \cellx2289\clvertalt\clbrdrt\brdrtbl \clbrdrl\brdrtbl \clbrdrb\brdrtbl \clbrdrr\brdrtbl';
            v_tmp :=
                v_tmp
                || '\cltxlrtb\clftsWidth3\clwWidth7179\clshdrawnil \cellx9468\row \pard \ql \li0\ri0\widctlpar\faauto\rin0\lin0\itap0';
        else
            v_tmp := v_tmp || 'Date: ' || to_char(v_act_date, v_date_fmt) || v_newline;
            v_tmp := v_tmp || 'Agent(s): ' || osi_report.get_assignments(v_act_sid, null, '; ');
        end if;

        return v_tmp;
    exception
        when others then
            return '<<Error during ROI_Header_DocReview>> - ' || sqlerrm;
    end roi_header_docreview;

    function roi_header_consultation(preturntable in varchar2 := 'N')
        return clob is
        v_tmp              clob          := null;
        v_consult_method   varchar(1000);
    begin
        log_error('>>>ROI_Header_Consultation-' || v_act_sid);

        if preturntable = 'Y' then
            v_tmp := roi_toc_consultation || '\pard\par';
        else
            v_tmp := roi_toc_consultation || v_newline;
        end if;

        begin
            select nvl(description, 'UNK')
              into v_consult_method
              from t_osi_a_consult_coord c, t_osi_reference r
             where c.cc_method = r.SID and c.SID = v_act_sid;
        exception
            when no_data_found then
                v_consult_method := 'UNK';
        end;

        if preturntable = 'Y' then
            v_tmp :=
                v_tmp
                || '\trowd \irow0\irowband0\lastrow \ts18\trgaph108\trleft-108\trftsWidth3\trwWidth9576\trftsWidthB3\trftsWidthA3\trautofit1\trpaddl108\trpaddr108\trpaddfl3\trpaddft3\trpaddfb3\trpaddfr3\tblrsid15077147\tbllkhdrrows\tbllklastrow\tbllkhdrcols\tbllklastcol';
            v_tmp :=
                v_tmp
                || '\clvertalt\clbrdrt\brdrtbl \clbrdrl\brdrtbl \clbrdrb\brdrtbl \clbrdrr\brdrtbl \cltxlrtb\clftsWidth3\clwWidth2397\clshdrawnil \cellx2289\clvertalt\clbrdrt\brdrtbl \clbrdrl\brdrtbl \clbrdrb\brdrtbl \clbrdrr\brdrtbl';
            v_tmp :=
                v_tmp
                || '\cltxlrtb\clftsWidth3\clwWidth7179\clshdrawnil \cellx9468\pard\plain \ql \li0\ri0\widctlpar\intbl\aspalpha\aspnum\faauto\adjustright\rin0\lin0\yts18 \fs22\lang1033\langfe1033\cgrid\langnp1033\langfenp1033 \tab Date/Method:';
            v_tmp :=
                v_tmp || '\cell ' || to_char(v_act_date, v_date_fmt) || '/' || v_consult_method
                || ' \cell \pard\plain \ql \li0\ri0\widctlpar\intbl\aspalpha\aspnum\faauto\adjustright\rin0\lin0 \fs22\lang1033\langfe1033\cgrid\langnp1033\langfenp1033';
            v_tmp :=
                v_tmp
                || '\trowd \irow0\irowband0\lastrow \ts18\trgaph108\trleft-108\trftsWidth3\trwWidth9576\trftsWidthB3\trftsWidthA3\trautofit1\trpaddl108\trpaddr108\trpaddfl3\trpaddft3\trpaddfb3\trpaddfr3\tblrsid15077147\tbllkhdrrows\tbllklastrow\tbllkhdrcols\tbllklastcol';
            v_tmp :=
                v_tmp
                || '\clvertalt\clbrdrt\brdrtbl \clbrdrl\brdrtbl \clbrdrb\brdrtbl \clbrdrr\brdrtbl \cltxlrtb\clftsWidth3\clwWidth2397\clshdrawnil \cellx2289\clvertalt\clbrdrt\brdrtbl \clbrdrl\brdrtbl \clbrdrb\brdrtbl \clbrdrr\brdrtbl';
            v_tmp :=
                v_tmp
                || '\cltxlrtb\clftsWidth3\clwWidth7179\clshdrawnil \cellx9468\row \pard \ql \li0\ri0\widctlpar\faauto\rin0\lin0\itap0';
        else
            v_tmp :=
                v_tmp || 'Date/Method: ' || to_char(v_act_date, v_date_fmt) || '/'
                || v_consult_method || v_newline;
        end if;

        if v_act_desc = 'Consultation' then
            if preturntable = 'Y' then
                v_tmp :=
                    v_tmp
                    || '\trowd \irow0\irowband0\lastrow \ts18\trgaph108\trleft-108\trftsWidth3\trwWidth9576\trftsWidthB3\trftsWidthA3\trautofit1\trpaddl108\trpaddr108\trpaddfl3\trpaddft3\trpaddfb3\trpaddfr3\tblrsid15077147\tbllkhdrrows\tbllklastrow\tbllkhdrcols\tbllklastcol';
                v_tmp :=
                    v_tmp
                    || '\clvertalt\clbrdrt\brdrtbl \clbrdrl\brdrtbl \clbrdrb\brdrtbl \clbrdrr\brdrtbl \cltxlrtb\clftsWidth3\clwWidth2397\clshdrawnil \cellx2289\clvertalt\clbrdrt\brdrtbl \clbrdrl\brdrtbl \clbrdrb\brdrtbl \clbrdrr\brdrtbl';
                v_tmp :=
                    v_tmp
                    || '\cltxlrtb\clftsWidth3\clwWidth7179\clshdrawnil \cellx9468\pard\plain \ql \li0\ri0\widctlpar\intbl\aspalpha\aspnum\faauto\adjustright\rin0\lin0\yts18 \fs22\lang1033\langfe1033\cgrid\langnp1033\langfenp1033 \tab Specialist(s):';
                v_tmp :=
                    v_tmp || '\cell ' || osi_report.get_assignments(v_act_sid, null, '; ')
                    || ' \cell \pard\plain \ql \li0\ri0\widctlpar\intbl\aspalpha\aspnum\faauto\adjustright\rin0\lin0 \fs22\lang1033\langfe1033\cgrid\langnp1033\langfenp1033';
                v_tmp :=
                    v_tmp
                    || '\trowd \irow0\irowband0\lastrow \ts18\trgaph108\trleft-108\trftsWidth3\trwWidth9576\trftsWidthB3\trftsWidthA3\trautofit1\trpaddl108\trpaddr108\trpaddfl3\trpaddft3\trpaddfb3\trpaddfr3\tblrsid15077147\tbllkhdrrows\tbllklastrow\tbllkhdrcols\tbllklastcol';
                v_tmp :=
                    v_tmp
                    || '\clvertalt\clbrdrt\brdrtbl \clbrdrl\brdrtbl \clbrdrb\brdrtbl \clbrdrr\brdrtbl \cltxlrtb\clftsWidth3\clwWidth2397\clshdrawnil \cellx2289\clvertalt\clbrdrt\brdrtbl \clbrdrl\brdrtbl \clbrdrb\brdrtbl \clbrdrr\brdrtbl';
                v_tmp :=
                    v_tmp
                    || '\cltxlrtb\clftsWidth3\clwWidth7179\clshdrawnil \cellx9468\row \pard \ql \li0\ri0\widctlpar\faauto\rin0\lin0\itap0';
            else
                v_tmp :=
                    v_tmp || 'Specialist(s): ' || osi_report.get_assignments(v_act_sid, null, '; ');
            end if;
        else
            if preturntable = 'Y' then
                v_tmp :=
                    v_tmp
                    || '\trowd \irow0\irowband0\lastrow \ts18\trgaph108\trleft-108\trftsWidth3\trwWidth9576\trftsWidthB3\trftsWidthA3\trautofit1\trpaddl108\trpaddr108\trpaddfl3\trpaddft3\trpaddfb3\trpaddfr3\tblrsid15077147\tbllkhdrrows\tbllklastrow\tbllkhdrcols\tbllklastcol';
                v_tmp :=
                    v_tmp
                    || '\clvertalt\clbrdrt\brdrtbl \clbrdrl\brdrtbl \clbrdrb\brdrtbl \clbrdrr\brdrtbl \cltxlrtb\clftsWidth3\clwWidth2397\clshdrawnil \cellx2289\clvertalt\clbrdrt\brdrtbl \clbrdrl\brdrtbl \clbrdrb\brdrtbl \clbrdrr\brdrtbl';
                v_tmp :=
                    v_tmp
                    || '\cltxlrtb\clftsWidth3\clwWidth7179\clshdrawnil \cellx9468\pard\plain \ql \li0\ri0\widctlpar\intbl\aspalpha\aspnum\faauto\adjustright\rin0\lin0\yts18 \fs22\lang1033\langfe1033\cgrid\langnp1033\langfenp1033 \tab Agent(s):';
                v_tmp :=
                    v_tmp || '\cell ' || osi_report.get_assignments(v_act_sid, null, '; ')
                    || ' \cell \pard\plain \ql \li0\ri0\widctlpar\intbl\aspalpha\aspnum\faauto\adjustright\rin0\lin0 \fs22\lang1033\langfe1033\cgrid\langnp1033\langfenp1033';
                v_tmp :=
                    v_tmp
                    || '\trowd \irow0\irowband0\lastrow \ts18\trgaph108\trleft-108\trftsWidth3\trwWidth9576\trftsWidthB3\trftsWidthA3\trautofit1\trpaddl108\trpaddr108\trpaddfl3\trpaddft3\trpaddfb3\trpaddfr3\tblrsid15077147\tbllkhdrrows\tbllklastrow\tbllkhdrcols\tbllklastcol';
                v_tmp :=
                    v_tmp
                    || '\clvertalt\clbrdrt\brdrtbl \clbrdrl\brdrtbl \clbrdrb\brdrtbl \clbrdrr\brdrtbl \cltxlrtb\clftsWidth3\clwWidth2397\clshdrawnil \cellx2289\clvertalt\clbrdrt\brdrtbl \clbrdrl\brdrtbl \clbrdrb\brdrtbl \clbrdrr\brdrtbl';
                v_tmp :=
                    v_tmp
                    || '\cltxlrtb\clftsWidth3\clwWidth7179\clshdrawnil \cellx9468\row \pard \ql \li0\ri0\widctlpar\faauto\rin0\lin0\itap0';
            else
                v_tmp := v_tmp || 'Agent(s): ' || osi_report.get_assignments(v_act_sid, null, '; ');
            end if;
        end if;

        log_error('<<<ROI_Header_Consultation-' || v_act_sid);
        return v_tmp;
    exception
        when others then
            return '<<Error during ROI_Header_Consultation>> - ' || sqlerrm;
    end roi_header_consultation;

    function roi_header_sourcemeet(preturntable in varchar2 := 'N')
        return clob is
        v_meet_date   t_osi_a_source_meet.next_meet_date%type;
        v_tmp         clob;
    begin
        log_error('>>>ROI_Header_SourceMeet-' || v_act_sid);

        if preturntable = 'Y' then
            v_tmp := v_tmp || v_act_title || ' \pard\par ';
            v_tmp :=
                v_tmp
                || '\trowd \irow0\irowband0\lastrow \ts18\trgaph108\trleft-108\trftsWidth3\trwWidth9576\trftsWidthB3\trftsWidthA3\trautofit1\trpaddl108\trpaddr108\trpaddfl3\trpaddft3\trpaddfb3\trpaddfr3\tblrsid15077147\tbllkhdrrows\tbllklastrow\tbllkhdrcols\tbllklastcol';
            v_tmp :=
                v_tmp
                || '\clvertalt\clbrdrt\brdrtbl \clbrdrl\brdrtbl \clbrdrb\brdrtbl \clbrdrr\brdrtbl \cltxlrtb\clftsWidth3\clwWidth2397\clshdrawnil \cellx2289\clvertalt\clbrdrt\brdrtbl \clbrdrl\brdrtbl \clbrdrb\brdrtbl \clbrdrr\brdrtbl';
            v_tmp :=
                v_tmp
                || '\cltxlrtb\clftsWidth3\clwWidth7179\clshdrawnil \cellx9468\pard\plain \ql \li0\ri0\widctlpar\intbl\aspalpha\aspnum\faauto\adjustright\rin0\lin0\yts18 \fs22\lang1033\langfe1033\cgrid\langnp1033\langfenp1033 \tab Date:';
            v_tmp :=
                v_tmp || '\cell ' || to_char(v_act_date, v_date_fmt)
                || ' \cell \pard\plain \ql \li0\ri0\widctlpar\intbl\aspalpha\aspnum\faauto\adjustright\rin0\lin0 \fs22\lang1033\langfe1033\cgrid\langnp1033\langfenp1033';
            v_tmp :=
                v_tmp
                || '\trowd \irow0\irowband0\lastrow \ts18\trgaph108\trleft-108\trftsWidth3\trwWidth9576\trftsWidthB3\trftsWidthA3\trautofit1\trpaddl108\trpaddr108\trpaddfl3\trpaddft3\trpaddfb3\trpaddfr3\tblrsid15077147\tbllkhdrrows\tbllklastrow\tbllkhdrcols\tbllklastcol';
            v_tmp :=
                v_tmp
                || '\clvertalt\clbrdrt\brdrtbl \clbrdrl\brdrtbl \clbrdrb\brdrtbl \clbrdrr\brdrtbl \cltxlrtb\clftsWidth3\clwWidth2397\clshdrawnil \cellx2289\clvertalt\clbrdrt\brdrtbl \clbrdrl\brdrtbl \clbrdrb\brdrtbl \clbrdrr\brdrtbl';
            v_tmp :=
                v_tmp
                || '\cltxlrtb\clftsWidth3\clwWidth7179\clshdrawnil \cellx9468\row \pard \ql \li0\ri0\widctlpar\faauto\rin0\lin0\itap0';
            v_tmp :=
                v_tmp
                || '\trowd \irow0\irowband0\lastrow \ts18\trgaph108\trleft-108\trftsWidth3\trwWidth9576\trftsWidthB3\trftsWidthA3\trautofit1\trpaddl108\trpaddr108\trpaddfl3\trpaddft3\trpaddfb3\trpaddfr3\tblrsid15077147\tbllkhdrrows\tbllklastrow\tbllkhdrcols\tbllklastcol';
            v_tmp :=
                v_tmp
                || '\clvertalt\clbrdrt\brdrtbl \clbrdrl\brdrtbl \clbrdrb\brdrtbl \clbrdrr\brdrtbl \cltxlrtb\clftsWidth3\clwWidth2397\clshdrawnil \cellx2289\clvertalt\clbrdrt\brdrtbl \clbrdrl\brdrtbl \clbrdrb\brdrtbl \clbrdrr\brdrtbl';
            v_tmp :=
                v_tmp
                || '\cltxlrtb\clftsWidth3\clwWidth7179\clshdrawnil \cellx9468\pard\plain \ql \li0\ri0\widctlpar\intbl\aspalpha\aspnum\faauto\adjustright\rin0\lin0\yts18 \fs22\lang1033\langfe1033\cgrid\langnp1033\langfenp1033 \tab Agent(s):';
            v_tmp :=
                v_tmp || '\cell ' || osi_report.get_assignments(v_act_sid, null, '; ')
                || ' \cell \pard\plain \ql \li0\ri0\widctlpar\intbl\aspalpha\aspnum\faauto\adjustright\rin0\lin0 \fs22\lang1033\langfe1033\cgrid\langnp1033\langfenp1033';
            v_tmp :=
                v_tmp
                || '\trowd \irow0\irowband0\lastrow \ts18\trgaph108\trleft-108\trftsWidth3\trwWidth9576\trftsWidthB3\trftsWidthA3\trautofit1\trpaddl108\trpaddr108\trpaddfl3\trpaddft3\trpaddfb3\trpaddfr3\tblrsid15077147\tbllkhdrrows\tbllklastrow\tbllkhdrcols\tbllklastcol';
            v_tmp :=
                v_tmp
                || '\clvertalt\clbrdrt\brdrtbl \clbrdrl\brdrtbl \clbrdrb\brdrtbl \clbrdrr\brdrtbl \cltxlrtb\clftsWidth3\clwWidth2397\clshdrawnil \cellx2289\clvertalt\clbrdrt\brdrtbl \clbrdrl\brdrtbl \clbrdrb\brdrtbl \clbrdrr\brdrtbl';
            v_tmp :=
                v_tmp
                || '\cltxlrtb\clftsWidth3\clwWidth7179\clshdrawnil \cellx9468\row \pard \ql \li0\ri0\widctlpar\faauto\rin0\lin0\itap0';
        else
            v_tmp := v_tmp || v_act_title || v_newline;
            v_tmp := v_tmp || 'Date: ' || to_char(v_act_date, v_date_fmt) || v_newline;
            v_tmp := v_tmp || 'Agent(s): ' || osi_report.get_assignments(v_act_sid, null, '; ');
        end if;

        log_error('<<<ROI_Header_SourceMeet-' || v_act_sid);
        return v_tmp;
    exception
        when others then
            return '<<Error during ROI_Header_SourceMeet>> - ' || sqlerrm;
    end roi_header_sourcemeet;

    function roi_header_search(preturntable in varchar2 := 'N')
        return clob is
        v_tmp          clob                     := null;
        v_act_search   t_osi_a_search%rowtype;
    begin
        log_error('>>>ROI_Header_Search-' || v_act_sid);
        v_tmp := roi_toc_search || v_newline;

        if preturntable = 'Y' then
            v_tmp := roi_toc_search || ' \pard\par ';
            v_tmp :=
                v_tmp
                || '\trowd \irow0\irowband0\lastrow \ts18\trgaph108\trleft-108\trftsWidth3\trwWidth9576\trftsWidthB3\trftsWidthA3\trautofit1\trpaddl108\trpaddr108\trpaddfl3\trpaddft3\trpaddfb3\trpaddfr3\tblrsid15077147\tbllkhdrrows\tbllklastrow\tbllkhdrcols\tbllklastcol';
            v_tmp :=
                v_tmp
                || '\clvertalt\clbrdrt\brdrtbl \clbrdrl\brdrtbl \clbrdrb\brdrtbl \clbrdrr\brdrtbl \cltxlrtb\clftsWidth3\clwWidth2397\clshdrawnil \cellx2289\clvertalt\clbrdrt\brdrtbl \clbrdrl\brdrtbl \clbrdrb\brdrtbl \clbrdrr\brdrtbl';
            v_tmp :=
                v_tmp
                || '\cltxlrtb\clftsWidth3\clwWidth7179\clshdrawnil \cellx9468\pard\plain \ql \li0\ri0\widctlpar\intbl\aspalpha\aspnum\faauto\adjustright\rin0\lin0\yts18 \fs22\lang1033\langfe1033\cgrid\langnp1033\langfenp1033 \tab Date/Place:';
            v_tmp :=
                v_tmp || '\cell ' || to_char(v_act_date, v_date_fmt) || '/'
                || osi_address.get_addr_display(osi_address.get_address_sid(v_act_sid))
                || ' \cell \pard\plain \ql \li0\ri0\widctlpar\intbl\aspalpha\aspnum\faauto\adjustright\rin0\lin0 \fs22\lang1033\langfe1033\cgrid\langnp1033\langfenp1033';
            v_tmp :=
                v_tmp
                || '\trowd \irow0\irowband0\lastrow \ts18\trgaph108\trleft-108\trftsWidth3\trwWidth9576\trftsWidthB3\trftsWidthA3\trautofit1\trpaddl108\trpaddr108\trpaddfl3\trpaddft3\trpaddfb3\trpaddfr3\tblrsid15077147\tbllkhdrrows\tbllklastrow\tbllkhdrcols\tbllklastcol';
            v_tmp :=
                v_tmp
                || '\clvertalt\clbrdrt\brdrtbl \clbrdrl\brdrtbl \clbrdrb\brdrtbl \clbrdrr\brdrtbl \cltxlrtb\clftsWidth3\clwWidth2397\clshdrawnil \cellx2289\clvertalt\clbrdrt\brdrtbl \clbrdrl\brdrtbl \clbrdrb\brdrtbl \clbrdrr\brdrtbl';
            v_tmp :=
                v_tmp
                || '\cltxlrtb\clftsWidth3\clwWidth7179\clshdrawnil \cellx9468\row \pard \ql \li0\ri0\widctlpar\faauto\rin0\lin0\itap0';
            v_tmp :=
                v_tmp
                || '\trowd \irow0\irowband0\lastrow \ts18\trgaph108\trleft-108\trftsWidth3\trwWidth9576\trftsWidthB3\trftsWidthA3\trautofit1\trpaddl108\trpaddr108\trpaddfl3\trpaddft3\trpaddfb3\trpaddfr3\tblrsid15077147\tbllkhdrrows\tbllklastrow\tbllkhdrcols\tbllklastcol';
            v_tmp :=
                v_tmp
                || '\clvertalt\clbrdrt\brdrtbl \clbrdrl\brdrtbl \clbrdrb\brdrtbl \clbrdrr\brdrtbl \cltxlrtb\clftsWidth3\clwWidth2397\clshdrawnil \cellx2289\clvertalt\clbrdrt\brdrtbl \clbrdrl\brdrtbl \clbrdrb\brdrtbl \clbrdrr\brdrtbl';
            v_tmp :=
                v_tmp
                || '\cltxlrtb\clftsWidth3\clwWidth7179\clshdrawnil \cellx9468\pard\plain \ql \li0\ri0\widctlpar\intbl\aspalpha\aspnum\faauto\adjustright\rin0\lin0\yts18 \fs22\lang1033\langfe1033\cgrid\langnp1033\langfenp1033 \tab Agent(s):';
            v_tmp :=
                v_tmp || '\cell ' || osi_report.get_assignments(v_act_sid, null, '; ')
                || ' \cell \pard\plain \ql \li0\ri0\widctlpar\intbl\aspalpha\aspnum\faauto\adjustright\rin0\lin0 \fs22\lang1033\langfe1033\cgrid\langnp1033\langfenp1033';
            v_tmp :=
                v_tmp
                || '\trowd \irow0\irowband0\lastrow \ts18\trgaph108\trleft-108\trftsWidth3\trwWidth9576\trftsWidthB3\trftsWidthA3\trautofit1\trpaddl108\trpaddr108\trpaddfl3\trpaddft3\trpaddfb3\trpaddfr3\tblrsid15077147\tbllkhdrrows\tbllklastrow\tbllkhdrcols\tbllklastcol';
            v_tmp :=
                v_tmp
                || '\clvertalt\clbrdrt\brdrtbl \clbrdrl\brdrtbl \clbrdrb\brdrtbl \clbrdrr\brdrtbl \cltxlrtb\clftsWidth3\clwWidth2397\clshdrawnil \cellx2289\clvertalt\clbrdrt\brdrtbl \clbrdrl\brdrtbl \clbrdrb\brdrtbl \clbrdrr\brdrtbl';
            v_tmp :=
                v_tmp
                || '\cltxlrtb\clftsWidth3\clwWidth7179\clshdrawnil \cellx9468\row \pard \ql \li0\ri0\widctlpar\faauto\rin0\lin0\itap0';
        else
            v_tmp :=
                v_tmp || 'Date/Place: ' || to_char(v_act_date, v_date_fmt) || '/'
                || osi_address.get_addr_display(osi_address.get_address_sid(v_act_sid))
                || v_newline;
            v_tmp := v_tmp || 'Agents(s): ' || osi_report.get_assignments(v_act_sid, null, '; ');
        end if;

        return v_tmp;
    exception
        when others then
            return '<<Error during ROI_Header_Search>> - ' || sqlerrm;
    end roi_header_search;

    function roi_header_default(preturntable in varchar2 := 'N')
        return clob is
        v_tmp   clob := null;
    begin
        log_error('>>>ROI_Header_DEFAULT-' || v_act_sid);

        if preturntable = 'Y' then
            v_tmp := v_tmp || v_act_desc;
            v_tmp :=
                v_tmp
                || '\pard\par \trowd \irow0\irowband0\lastrow \ts18\trgaph108\trleft-108\trftsWidth3\trwWidth9576\trftsWidthB3\trftsWidthA3\trautofit1\trpaddl108\trpaddr108\trpaddfl3\trpaddft3\trpaddfb3\trpaddfr3\tblrsid15077147\tbllkhdrrows\tbllklastrow\tbllkhdrcols\tbllklastcol';
            v_tmp :=
                v_tmp
                || '\clvertalt\clbrdrt\brdrtbl \clbrdrl\brdrtbl \clbrdrb\brdrtbl \clbrdrr\brdrtbl \cltxlrtb\clftsWidth3\clwWidth2397\clshdrawnil \cellx2289\clvertalt\clbrdrt\brdrtbl \clbrdrl\brdrtbl \clbrdrb\brdrtbl \clbrdrr\brdrtbl';
            v_tmp :=
                v_tmp
                || '\cltxlrtb\clftsWidth3\clwWidth7179\clshdrawnil \cellx9468\pard\plain \ql \li0\ri0\widctlpar\intbl\aspalpha\aspnum\faauto\adjustright\rin0\lin0\yts18 \fs22\lang1033\langfe1033\cgrid\langnp1033\langfenp1033 \tab Date:';
            v_tmp :=
                v_tmp || '\cell ' || to_char(v_act_date, v_date_fmt)
                || ' \cell \pard\plain \ql \li0\ri0\widctlpar\intbl\aspalpha\aspnum\faauto\adjustright\rin0\lin0 \fs22\lang1033\langfe1033\cgrid\langnp1033\langfenp1033';
            v_tmp :=
                v_tmp
                || '\trowd \irow0\irowband0\lastrow \ts18\trgaph108\trleft-108\trftsWidth3\trwWidth9576\trftsWidthB3\trftsWidthA3\trautofit1\trpaddl108\trpaddr108\trpaddfl3\trpaddft3\trpaddfb3\trpaddfr3\tblrsid15077147\tbllkhdrrows\tbllklastrow\tbllkhdrcols\tbllklastcol';
            v_tmp :=
                v_tmp
                || '\clvertalt\clbrdrt\brdrtbl \clbrdrl\brdrtbl \clbrdrb\brdrtbl \clbrdrr\brdrtbl \cltxlrtb\clftsWidth3\clwWidth2397\clshdrawnil \cellx2289\clvertalt\clbrdrt\brdrtbl \clbrdrl\brdrtbl \clbrdrb\brdrtbl \clbrdrr\brdrtbl';
            v_tmp :=
                v_tmp
                || '\cltxlrtb\clftsWidth3\clwWidth7179\clshdrawnil \cellx9468\row \pard \ql \li0\ri0\widctlpar\faauto\rin0\lin0\itap0';
            v_tmp :=
                v_tmp
                || '\trowd \irow0\irowband0\lastrow \ts18\trgaph108\trleft-108\trftsWidth3\trwWidth9576\trftsWidthB3\trftsWidthA3\trautofit1\trpaddl108\trpaddr108\trpaddfl3\trpaddft3\trpaddfb3\trpaddfr3\tblrsid15077147\tbllkhdrrows\tbllklastrow\tbllkhdrcols\tbllklastcol';
            v_tmp :=
                v_tmp
                || '\clvertalt\clbrdrt\brdrtbl \clbrdrl\brdrtbl \clbrdrb\brdrtbl \clbrdrr\brdrtbl \cltxlrtb\clftsWidth3\clwWidth2397\clshdrawnil \cellx2289\clvertalt\clbrdrt\brdrtbl \clbrdrl\brdrtbl \clbrdrb\brdrtbl \clbrdrr\brdrtbl';
            v_tmp :=
                v_tmp
                || '\cltxlrtb\clftsWidth3\clwWidth7179\clshdrawnil \cellx9468\pard\plain \ql \li0\ri0\widctlpar\intbl\aspalpha\aspnum\faauto\adjustright\rin0\lin0\yts18 \fs22\lang1033\langfe1033\cgrid\langnp1033\langfenp1033 \tab Agent(s):';
            v_tmp :=
                v_tmp || '\cell ' || osi_report.get_assignments(v_act_sid, null, '; ')
                || ' \cell \pard\plain \ql \li0\ri0\widctlpar\intbl\aspalpha\aspnum\faauto\adjustright\rin0\lin0 \fs22\lang1033\langfe1033\cgrid\langnp1033\langfenp1033';
            v_tmp :=
                v_tmp
                || '\trowd \irow0\irowband0\lastrow \ts18\trgaph108\trleft-108\trftsWidth3\trwWidth9576\trftsWidthB3\trftsWidthA3\trautofit1\trpaddl108\trpaddr108\trpaddfl3\trpaddft3\trpaddfb3\trpaddfr3\tblrsid15077147\tbllkhdrrows\tbllklastrow\tbllkhdrcols\tbllklastcol';
            v_tmp :=
                v_tmp
                || '\clvertalt\clbrdrt\brdrtbl \clbrdrl\brdrtbl \clbrdrb\brdrtbl \clbrdrr\brdrtbl \cltxlrtb\clftsWidth3\clwWidth2397\clshdrawnil \cellx2289\clvertalt\clbrdrt\brdrtbl \clbrdrl\brdrtbl \clbrdrb\brdrtbl \clbrdrr\brdrtbl';
            v_tmp :=
                v_tmp
                || '\cltxlrtb\clftsWidth3\clwWidth7179\clshdrawnil \cellx9468\row \pard \ql \li0\ri0\widctlpar\faauto\rin0\lin0\itap0';
        else
            v_tmp := v_tmp || v_act_desc || v_newline;
            v_tmp := v_tmp || 'Date: ' || to_char(v_act_date, v_date_fmt) || v_newline;
            v_tmp := v_tmp || 'Agent(s): ' || osi_report.get_assignments(v_act_sid, null, '; ');
        end if;

        log_error('<<<ROI_Header_DEFAULT-' || v_act_sid);
        return v_tmp;
    exception
        when others then
            return '<<Error during ROI_Header_Default>> - ' || sqlerrm;
    end roi_header_default;

    function roi_group(psid in varchar2)
        return varchar2 is
/*
    Returns the TOC (Table of Contents) Group string for the specified activity.
*/
        v_tempstring      varchar2(300)               := null;
        v_obj_type_code   t_core_obj_type.code%type;
    begin
        load_activity(psid);
        v_obj_type_code := osi_object.get_objtype_code(core_obj.get_objtype(psid));

        if (   (v_obj_type_code like 'ACT.INTERVIEW%' and v_obj_type_code <> 'ACT.INTERVIEW.GROUP')
            or v_mask is not null) then
            if v_mask = 'Investigative Activity' then
                return 'Other Investigative Aspects';
            else
                return 'Interviews';
            end if;
        elsif v_act_desc = 'Document Review' then
            return 'Document Reviews';
        elsif v_act_desc like 'Coordination%' then
            return 'Coordinations';
        elsif v_act_desc like 'Consultation%' then
            return 'Consultations';
        elsif v_act_desc like 'Search%' then
            return 'Searches';
        elsif v_act_desc = 'Law Enforcement Records Check' then
            return 'Law Enforcement Records Checks';
        elsif v_act_desc like 'Agent Application Activity%' then
            begin
                select t.description
                  into v_tempstring
                  from t_osi_f_aapp_file_obj_act a,
                       t_osi_f_aapp_file_obj o,
                       t_osi_f_aapp_file_obj_type t
                 where a.obj = psid and a.objective = o.SID and o.obj_type = t.SID;
            exception
                when no_data_found then
                    return '#-# Objective Title';
            end;

            return v_tempstring;
        else
            return 'Other Investigative Aspects';
        end if;
    exception
        when no_data_found then
            return null;
    end roi_group;

    function roi_group_order(psid in varchar2) return varchar2 is
/*
    Returns a string used to sort the TOC Groups.
*/
    begin
         load_activity(psid);
         
         --- Maskings show up as Other Investigative Aspects ---
         if v_mask is not null then
           
           return 'Z';
           
         end if;
         
         case
         
             --- Interviews ---
             when v_obj_type_code in ('ACT.INTERVIEW.SUBJECT','ACT.INTERVIEW.WITNESS','ACT.INTERVIEW.VICTIM') THEN
                 
                 return 'A';
             
             --- Searches ---
             when v_obj_type_code like 'ACT.SEARCH%' THEN
                 
                 return 'B';
             
             --- Document Reviews ---    
             when v_obj_type_code in ('ACT.DOCUMENT_REVIEW') THEN
                 
                 return 'D';
             
             --- Records Checks ---
             when v_obj_type_code in ('ACT.RECORDS_CHECK') THEN
                 
                 return 'E';
             
             --- Coordinations ---    
             when v_obj_type_code like 'ACT.COORDINATION%' THEN
                 
                 return 'G';
             
             --- Consultations ---    
             when v_obj_type_code like 'ACT.CONSULTATION%' THEN
                  
                 return 'H';
             
             -- Other Investigative Aspects --
             else
               
               return 'Z';
               
         end case; 

    exception
        when no_data_found then
            return null;
    end roi_group_order;

    function roi_toc_order(psid in varchar2)
        return varchar2 is
/*
    Returns a string that can be used to sort activities within
    an ROI Group.
*/
    begin
        return nvl(to_char(get_f40_date(psid), 'yyyymmddhh24miss'), 'z-none');
    exception
        when no_data_found then
            return null;
    end roi_toc_order;

    function roi_narrative(psid in varchar2)
        return clob is
/*
    Returns the Narrative (text) for the specified activity.
*/
    begin
        load_activity(psid);
        return osi_report.replace_special_chars_clob(v_act_narrative, 'RTF');
    exception
        when no_data_found then
            return null;
    end roi_narrative;

    function roi_header(psid in varchar2, preturntable in varchar2 := 'N')
        return clob is
        /*Returns the Narrative header for the specified activity. */
        v_tmp   clob;
    begin
        load_activity(psid);

        if v_mask is not null then
            v_tmp := roi_header_interview(preturntable);
        else
            if v_act_desc = 'Group Interview' then
                v_tmp := roi_header_incidental_int(preturntable);
            elsif v_act_desc like 'Interview%' then
                v_tmp := roi_header_interview(preturntable);
            elsif v_act_desc like 'Document Review' then
                v_tmp := roi_header_docreview(preturntable);
            elsif    v_act_desc like 'Consultation%'
                  or v_act_desc like 'Coordination%' then
                v_tmp := roi_header_consultation(preturntable);
            elsif v_act_desc like 'Source Meet' then
                v_tmp := roi_header_sourcemeet(preturntable);
            elsif v_act_desc like 'Search%' then
                v_tmp := roi_header_search(preturntable);
            elsif v_act_desc = 'Law Enforcement Records Check' then
                v_tmp := roi_header_docreview(preturntable);
            elsif v_act_desc = 'Exception' then
                --- Exception Activities ---
                return v_act_title;
            else
                v_tmp := roi_header_default(preturntable);
            end if;
        end if;

        return v_tmp;                                           --|| getotherspresent(preturntable);
    exception
        when no_data_found then
            return null;
    end roi_header;

    function get_subject_list
        return varchar2 is
        v_subject_list   varchar2(30000) := null;
        v_cnt            number          := 0;
    begin
        log_error('Starting Get_subject_list');

        for a in (select pi.participant_version, pi.obj, prt.role,
                         roi_block(pi.participant_version) as title_block
                    from t_osi_partic_involvement pi, t_osi_partic_role_type prt
                   where pi.obj = v_obj_sid
                     and pi.involvement_role = prt.SID
                     and prt.role = 'Subject'
                     and prt.usage = 'SUBJECT')
        loop
            if v_cnt = 0 then
                v_subject_list := a.title_block;
            else
                v_subject_list := v_subject_list || '\par\par \tab ' || a.title_block;
            end if;

            v_cnt := v_cnt + 1;
        end loop;

        return v_subject_list;
    exception
        when others then
            log_error('Get_Subject_List>>> - ' || sqlerrm);
            return null;
    end get_subject_list;

    function get_victim_list
        return varchar2 is
        v_victim_list   varchar2(30000) := null;
        v_cnt           number          := 0;
    begin
        for a in (select pi.participant_version, pi.obj, prt.role,
                         roi_block(pi.participant_version) as title_block
                    from t_osi_partic_involvement pi, t_osi_partic_role_type prt
                   where pi.obj = v_obj_sid
                     and pi.involvement_role = prt.SID
                     and prt.role = 'Victim'
                     and prt.usage = 'VICTIM')
        loop
            if v_cnt = 0 then
                v_victim_list := a.title_block;
            else
                v_victim_list := v_victim_list || '\par\par \tab ' || a.title_block;
            end if;

            v_cnt := v_cnt + 1;
        end loop;

        return v_victim_list;
    exception
        when others then
            log_error('Get_Victim_List>>> - ' || sqlerrm);
            return null;
    end get_victim_list;

    function roi_block(ppopv in varchar2) return varchar2 is

         v_result   varchar2(4000);
         v_temp     varchar2(2000);
         v_saa      varchar2(100);
         v_per      varchar2(20);

    begin
         ---get_basic_info(ppopv, v_result, v_saa, v_per);------, true, false, false, false);
         get_basic_info(ppopv, v_result, v_saa, v_per, true, false, true, true, 'N');

         if v_saa = 'ME' then                                         --- military (or employee) ---

           v_result := v_result || nvl(get_org_info(ppopv), 'UNK');

         else                                                         --- civilian or military dependent  ---
             v_temp := null;

             for r in (select vpr.related_to as that_version,
                              ltrim(vpr.description, 'is ') as rel_type
                           from v_osi_partic_relation vpr, t_osi_partic_relation pr
                          where vpr.this_participant = v_per
                            and vpr.SID = pr.SID
                            and description in('is Spouse of', 'is Child of')
                            and (pr.end_date is null or pr.end_date > sysdate)
                      order by nvl(pr.start_date, modify_on) desc)
             loop
                 ---get_basic_info(r.that_version, v_temp, v_saa, v_per);
                 get_basic_info(r.that_version, v_temp, v_saa, v_per, true, false, true, true, 'N');
         
                v_result := v_result || nvl(get_org_info(r.that_version), 'UNK') || ', ';
                 exit;                                                     --- only need 1st row ---
             end loop;

             v_result := v_result || nvl(osi_address.get_addr_display(osi_address.get_address_sid(ppopv)), 'UNK');--CR#2728 || '.';
         end if;

         v_result := rtrim(v_result, '; ');
         return(v_result);

    end roi_block;

    function get_owning_unit_cdr
        return varchar2 is
        v_cdr_name   varchar2(500) := null;
        v_cdr_sid    varchar(20);
        v_pay_cat    varchar(4);
    begin
        begin
            log_error('Starting get_owning_unit_cdr');

            select a.personnel
              into v_cdr_sid
              from t_osi_assignment a, t_osi_assignment_role_type art
             where a.unit = v_unit_sid and a.assign_role = art.SID and art.description = 'Commander';
        exception
            when no_data_found then
                v_cdr_name := 'XXXXXXXXXXXXXXXXXX';
        end;

        begin
            select first_name || ' '
                   || decode(length(middle_name),
                             1, middle_name || '. ',
                             0, ' ',
                             null, ' ',
                             substr(middle_name, 1, 1) || '. ')
                   || last_name,
                   decode(op.pay_category, '03', 'DAF', '04', 'DAF', 'USAF')
              into v_cdr_name,
                   v_pay_cat
              from t_core_personnel p, t_osi_personnel op
             where p.SID = v_cdr_sid and p.SID = op.SID;
        exception
            when no_data_found then
                v_pay_cat := 'USAF';
        end;

        v_cdr_name := v_cdr_name || ', SA, ' || v_pay_cat;
        return v_cdr_name;
    exception
        when others then
            return 'XXXXXXXXXXXXXXXXXX, SA, USAF';
    end get_owning_unit_cdr;

    function get_caveats_list
        return varchar2 is
        v_caveats_list   varchar2(30000) := null;
        v_cnt            number          := 0;
    begin
        log_error('Start get_caveats_list');

        for a in (select   c.description
                      from t_osi_report_caveat_type c, t_osi_report_caveat r
                     where c.SID = r.caveat and r.spec = v_spec_sid and r.selected = 'Y'
                  order by description)
        loop
            if v_cnt = 0 then
                v_caveats_list := a.description;
            else
                v_caveats_list := v_caveats_list || '\par\par ' || a.description;
            end if;

            v_cnt := v_cnt + 1;
        end loop;

        return v_caveats_list;
    exception
        when others then
            return null;
    end get_caveats_list;

    procedure get_sel_activity(pspecsid in varchar2) is
        v_current_group   varchar2(200)   := null;
        v_narr_header     clob            := null;
        v_narr_title      clob            := null;
        v_exhibits        clob            := null;
        v_init_notif      clob            := null;
        v_tmp_exhibits    clob            := null;
        v_ok              boolean;
    begin
         log_error('<<<get_sel_activity(' || pspecsid || ')');
         v_paraoffset := 0;

         begin
              select summary_allegation into v_init_notif from t_osi_f_investigation where SID=v_obj_sid;

              if v_init_notif is not null then

                v_paraoffset := 1;
                v_current_group := 'Background';

                --- TOC Entry ---
                v_act_toc_list := v_act_toc_list || '\tx0\b ' || v_current_group || '\b0\tx7920\tab 2-1';

                --- Narrative Header  ---
                v_act_narr_list := v_act_narr_list || '\b ' || v_current_group || '\b0';

                --- Initial Notification Text ---
                v_act_narr_list := v_act_narr_list || '\par\par 2-1\tab\fi0\li0 ' || v_init_notif; --|| osi_report.replace_special_chars_clob(v_init_notif, 'RTF');

              end if;

         exception
             when no_data_found then

                 null;

         end;

         for a in (select * from v_osi_rpt_roi_rtf where spec = pspecsid and selected = 'Y' order by seq asc, roi_combined_order asc, roi_group)
         loop
             if v_current_group is null then
             
               -- First TOC Group Header
               v_act_toc_list := v_act_toc_list || '\tx0\b ' || a.roi_group || '\b0';
             
               -- First Narrative Group Header
               v_act_narr_list := v_act_narr_list || '\b ' || a.roi_group || '\b0';

             else

               if v_current_group <> a.roi_group then

                 -- TOC Group Header
                 v_act_toc_list := v_act_toc_list || '\par\par\tx0\b ' || a.roi_group || '\b0';

                 -- Narrative Group Header
                 v_act_narr_list := v_act_narr_list || '\par\par\b ' || a.roi_group || '\b0';
               
               end if;

             end if;

             v_current_group := a.roi_group;
             -- Table of Contents listing --
             v_act_toc_list := v_act_toc_list || '\par\par\fi-720\li720\tab ' || a.roi_toc || '\tx7920\tab 2-' || to_char(a.seq + v_paraoffset);
 
             -- Narrative Header --
             v_narr_header := '\par\par 2-' || to_char(a.seq + v_paraoffset) || '\tab\fi-720\li720 ' || replace(roi_header(a.activity, 'Y'), v_newline, c_hdr_linebreak);
             v_act_narr_list := v_act_narr_list || v_narr_header;

             -- Exhibits --
             v_exhibits := get_act_exhibit(a.activity);

             if v_exhibits is not null then
  
               v_act_narr_list := v_act_narr_list || '\line ' || v_exhibits;
  
             end if;

             v_exhibits := null;

             -- Narrative Text --
             if v_act_desc = 'Document Review' then

                 v_act_narr_list := v_act_narr_list || replace(osi_document_review.get_narrative(v_act_sid),CHR(13) || CHR(10),'\line ');
                 v_act_narr_list := v_act_narr_list || '{\info {\comment ~~NARRATIVE_END~~' || v_act_sid || '}}';

             elsif v_act_desc = 'Law Enforcement Records Check' then

                  v_act_narr_list := v_act_narr_list || replace(osi_records_check.get_narrative(v_act_sid),CHR(13) || CHR(10),'\line ');
                  v_act_narr_list := v_act_narr_list || '{\info {\comment ~~NARRATIVE_END~~' || v_act_sid || '}}';

             else

               if a.roi_narrative is not null then

                 v_act_narr_list := v_act_narr_list || '{\info {\comment ~~NARRATIVE_BEGIN~~' || v_act_sid || '}}';

                 if v_act_desc = 'Group Interview' then

                   v_act_narr_list := v_act_narr_list || '\par ' || c_blockparaoff;

                 else

                   v_act_narr_list := v_act_narr_list || '\par\par ' || c_blockparaoff;
 
                 end if;

                 v_act_narr_list := v_act_narr_list || a.roi_narrative;
                 v_act_narr_list := v_act_narr_list || '{\info {\comment ~~NARRATIVE_END~~' || v_act_sid || '}}';

               else

                 v_act_narr_list := v_act_narr_list || '\par ' || c_blockparaoff;

               end if;

             end if;
             
             v_narr_header := null;

         end loop;

         log_error('>>>get_sel_activity(' || pspecsid || ')');

         exception when others then

                  log_error('>>>get_sel_activity(' || pspecsid || ') - ' || sqlerrm);
        
    end get_sel_activity;

    procedure get_evidence_list(pparentsid in varchar2, pspecsid in varchar2) is
        lastaddress        varchar2(1000)  := '~`~`~`~`~`~`~`~`~`~';
        lastdate           date            := '01-JAN-1900';
        lastact            varchar2(20)    := '~`~`~`~`~`~`~`~`~`~';
        lastowner          varchar2(1000)  := '~`~`~`~`~`~`~`~`~`~';
        lastobtainedby     varchar2(1000)  := '~`~`~`~`~`~`~`~`~`~';
        lastreceivedfrom   varchar2(1000)  := '~`~`~`~`~`~`~`~`~`~';
        printnewline       boolean;
        currentagents      varchar2(32000) := '~`~`~`~`~`~`~`~`~`~';
        lastagents         varchar2(1000)  := '~`~`~`~`~`~`~`~`~`~';
        tempstring         varchar2(1000)  := '~`~`~`~`~`~`~`~`~`~';
        sortorder          number;
    begin
        log_error('--->Get_Evidence_List' || sysdate);

        for a in
            (select   e.SID, e.obj as activity, e.tag_number, e.obtained_by, e.obtained_date,
                      osi_address.get_addr_display
                                     (osi_address.get_address_sid(e.SID))
                                                                        as obtained_address_string,
                      e.description,
                      '(para. 2-' || trim(to_char(ra.seq + v_paraoffset, '999')) || ')' as para_no
                 from v_osi_evidence e, t_osi_report_activity ra
                where e.obj = ra.activity
                  and e.obj in(select activity
                                 from v_osi_rpt_roi_rtf
                                where selected = 'Y' and spec = pspecsid)
                  and spec = pspecsid
             order by ra.seq, e.tag_number)
        loop
            printnewline := false;

            if    lastact <> a.activity
               or lastaddress <> a.obtained_address_string then
                if lastact <> '~`~`~`~`~`~`~`~`~`~' then
                    osi_util.aitc(v_evidence_list, v_horz_line);
                end if;

                osi_util.aitc(v_evidence_list,
                              'Obtained at: \tab \fi-1440\li1440\ '
                              || osi_report.replace_special_chars(a.obtained_address_string || ' '
                                                                  || a.para_no,
                                                                  'RTF')
                              || ' \par ');
                printnewline := true;
                lastact := a.activity;
                lastaddress := a.obtained_address_string;
            end if;

            if lastdate <> a.obtained_date then
                osi_util.aitc(v_evidence_list,
                              'Obtained on: \tab \fi-1440\li1440\ '
                              || to_char(a.obtained_date, v_date_fmt) || ' \par ');
                printnewline := true;
                lastdate := a.obtained_date;
            end if;

            if lastobtainedby <> a.obtained_by then
                sortorder := 99;

                for n in (select a.personnel,
                                 decode(art.description, 'Lead Agent', 1, 99) as sortorder
                            from t_osi_assignment a,
                                 t_osi_assignment_role_type art,
                                 t_core_personnel p
                           where a.obj = a.activity
                             and a.assign_role = art.SID
                             and p.SID = a.obtained_by)
                loop
                    sortorder := n.sortorder;
                end loop;

                osi_util.aitc(v_evidence_list,
                              'Obtained by: \tab \fi-1440\li1440\ ' || a.obtained_by || ' \par ');
                printnewline := true;
                lastobtainedby := a.obtained_by;
            end if;

            currentagents := osi_report.get_assignments(a.activity);

            if lastagents <> currentagents then
                osi_util.aitc(v_evidence_list,
                              'Agent(s): \tab \fi-1440\li1440\ ' || currentagents || ' \par ');
                printnewline := true;
                lastagents := currentagents;
            end if;

            for p in (select participant_version
                        from t_osi_partic_involvement i, t_osi_partic_role_type rt
                       where i.obj = a.SID and i.involvement_role = rt.SID and rt.role = 'Owner')
            loop
                tempstring := getparticipantname(p.participant_version, true);

                if lastowner <> tempstring then
                    osi_util.aitc(v_evidence_list,
                                  'Owner: \tab \fi-1440\li1440\ ' || tempstring || ' \par ');
                    printnewline := true;
                    lastowner := tempstring;
                end if;
            end loop;

            tempstring := '~`~`~`~`~`~`~`~`~`~';

            for p in (select participant_version
                        from t_osi_partic_involvement i, t_osi_partic_role_type rt
                       where i.obj = a.SID
                         and i.involvement_role = rt.SID
                         and rt.role in('Received From Participant', 'Siezed From Participant'))
            loop
                tempstring := getparticipantname(p.participant_version, true);

                if lastreceivedfrom <> tempstring then
                    osi_util.aitc(v_evidence_list,
                                  'RCVD From: \tab \fi-1440\li1440\ ' || tempstring || ' \par ');
                    printnewline := true;
                    lastreceivedfrom := tempstring;
                end if;
            end loop;

            if printnewline = true then
                osi_util.aitc(v_evidence_list, ' \par ');
            end if;

            osi_util.aitc(v_evidence_list,
                          ' \tab ' || a.tag_number || ': \tab \fi-1440\li1440\ '
                          || osi_report.replace_special_chars(a.description, 'RTF') || ' \par ');
        end loop;

        log_error('<---Get_Evidence_List' || sysdate);
    end get_evidence_list;

procedure get_evidence_list_new(pparentsid in varchar2, pspecsid in varchar2) is

      lastaddress        varchar2(1000)  := '~`~`~`~`~`~`~`~`~`~';
      lastdate           date            := '01-JAN-1900';
      lastact            varchar2(20)    := '~`~`~`~`~`~`~`~`~`~';
      lastowner          varchar2(1000)  := '~`~`~`~`~`~`~`~`~`~';
      lastobtainedby     varchar2(1000)  := '~`~`~`~`~`~`~`~`~`~';
      lastreceivedfrom   varchar2(1000)  := '~`~`~`~`~`~`~`~`~`~';
      printnewline       boolean;
      currentagents      varchar2(32000) := '~`~`~`~`~`~`~`~`~`~';
      lastagents         varchar2(1000)  := '~`~`~`~`~`~`~`~`~`~';
      tempstring         varchar2(1000)  := '~`~`~`~`~`~`~`~`~`~';
      sortorder          number;

begin
     log_error('--->Get_Evidence_List_New' || sysdate);

     for a in (select e.SID,e.obj as activity,e.tag_number,e.obtained_by,e.obtained_date,osi_address.get_addr_display(osi_address.get_address_sid(e.SID)) as obtained_address_string,
                      e.description,/*'(para. 2-' || trim(to_char(ra.seq + v_paraoffset, '999')) || ')'*/ rownum as para_no
                from v_osi_evidence e, t_osi_assoc_fle_act ra
                where e.obj = ra.activity_sid 
                  and ra.file_sid=pparentsid
                order by e.tag_number)
        loop
            printnewline := false;

            if    lastact <> a.activity
               or lastaddress <> a.obtained_address_string then
                if lastact <> '~`~`~`~`~`~`~`~`~`~' then
                    osi_util.aitc(v_evidence_list, v_horz_line);
                end if;

                osi_util.aitc(v_evidence_list,
                              'Obtained at: \tab \fi-1440\li1440\ '
                              || osi_report.replace_special_chars(a.obtained_address_string || ' '
                                                                  || a.para_no,
                                                                  'RTF')
                              || ' \par ');
                printnewline := true;
                lastact := a.activity;
                lastaddress := a.obtained_address_string;
            end if;

            if lastdate <> a.obtained_date then
                osi_util.aitc(v_evidence_list,
                              'Obtained on: \tab \fi-1440\li1440\ '
                              || to_char(a.obtained_date, v_date_fmt) || ' \par ');
                printnewline := true;
                lastdate := a.obtained_date;
            end if;

            if lastobtainedby <> a.obtained_by then
                sortorder := 99;

                for n in (select a.personnel,
                                 decode(art.description, 'Lead Agent', 1, 99) as sortorder
                            from t_osi_assignment a,
                                 t_osi_assignment_role_type art,
                                 t_core_personnel p
                           where a.obj = a.activity
                             and a.assign_role = art.SID
                             and p.SID = a.obtained_by)
                loop
                    sortorder := n.sortorder;
                end loop;

                osi_util.aitc(v_evidence_list,
                              'Obtained by: \tab \fi-1440\li1440\ ' || a.obtained_by || ' \par ');
                printnewline := true;
                lastobtainedby := a.obtained_by;
            end if;

            currentagents := osi_report.get_assignments(a.activity);

            if lastagents <> currentagents then
                osi_util.aitc(v_evidence_list,
                              'Agent(s): \tab \fi-1440\li1440\ ' || currentagents || ' \par ');
                printnewline := true;
                lastagents := currentagents;
            end if;

            for p in (select participant_version
                        from t_osi_partic_involvement i, t_osi_partic_role_type rt
                       where i.obj = a.SID and i.involvement_role = rt.SID and rt.role = 'Owner')
            loop
                tempstring := getparticipantname(p.participant_version, true);

                if lastowner <> tempstring then
                    osi_util.aitc(v_evidence_list,
                                  'Owner: \tab \fi-1440\li1440\ ' || tempstring || ' \par ');
                    printnewline := true;
                    lastowner := tempstring;
                end if;
            end loop;

            tempstring := '~`~`~`~`~`~`~`~`~`~';

            for p in (select participant_version
                        from t_osi_partic_involvement i, t_osi_partic_role_type rt
                       where i.obj = a.SID
                         and i.involvement_role = rt.SID
                         and rt.role in('Received From Participant', 'Siezed From Participant'))
            loop
                tempstring := getparticipantname(p.participant_version, true);

                if lastreceivedfrom <> tempstring then
                    osi_util.aitc(v_evidence_list,
                                  'RCVD From: \tab \fi-1440\li1440\ ' || tempstring || ' \par ');
                    printnewline := true;
                    lastreceivedfrom := tempstring;
                end if;
            end loop;

            if printnewline = true then
                osi_util.aitc(v_evidence_list, ' \par ');
            end if;

            osi_util.aitc(v_evidence_list,
                          ' \tab ' || a.tag_number || ': \tab \fi-1440\li1440\ '
                          || osi_report.replace_special_chars(a.description, 'RTF') || ' \par ');
        end loop;

        log_error('<---Get_Evidence_List_New' || sysdate);
    end get_evidence_list_new;

    procedure get_idp_notes(pspecsid in varchar2, pfontsize in varchar2 := '20') is
        v_cnt   number := 0;
    begin
        for a in (select   note, seq, timestamp
                      from v_osi_rpt_avail_note
                     where spec = pspecsid
                       and (   selected = 'Y'
                            or category = 'Curtailed Content Report Note')
                  order by seq, timestamp)
        loop
            v_cnt := v_cnt + 1;

            if v_cnt = 1 then
                osi_util.aitc(v_idp_list,
                              replace(c_blockhalfinch, '\fs20', '\fs' || pfontsize) || v_cnt
                              || '\tab ');
            else
                osi_util.aitc(v_idp_list, '\par\par ' || v_cnt || '\tab ');
            end if;

            dbms_lob.append(v_idp_list, osi_report.replace_special_chars_clob(a.note, 'RTF'));
        end loop;
    end get_idp_notes;

    function get_act_exhibit(pactivitysid in varchar2)
        return varchar2 is
        v_tmp_narr_exhibits   varchar2(30000) := null;
        v_cnt                 number          := 0;
        v_ok                  boolean;
    begin
        log_error('>>>Get_Act_Exhibit-' || pactivitysid);
        v_exhibit_table :=
            '\trowd \irow0\irowband0\ts18\trgaph108\trrh1900\trleft-108\trbrdrh\brdrs\brdrw10 \trbrdrv\brdrs\brdrw10';
        v_exhibit_table :=
            v_exhibit_table
            || '\trftsWidth2\trwWidth5000\trftsWidthB3\trftsWidthA3\trautofit1\trpaddl108\trpaddr108\trpaddfl3\trpaddft3\trpaddfb3\trpaddfr3\tblrsid14035271\tbllkhdrrows\tbllklastrow\tbllkhdrcols\tbllklastcol \clvertalc\clbrdrt\brdrtbl \clbrdrl\brdrtbl \clbrdrb';
        v_exhibit_table :=
            v_exhibit_table
            || '\brdrs\brdrw10 \clbrdrr\brdrtbl \cltxlrtb\clftsWidth2\clwWidth5000\clshdrawnil \cellx9468\pard\plain \qc \li0\ri0\widctlpar\intbl\faauto\rin0\lin0\pararsid2117219\yts18 \fs22\lang1033\langfe1033\cgrid\langnp1033\langfenp1033 ';
        v_exhibit_table :=
            v_exhibit_table
            || '\b\fs36 Exhibit #\b\fs36 [TOKEN@EXHIBIT_NUMBER]\b\fs36 \cell \pard\plain \ql \li0\ri0\widctlpar\intbl\aspalpha\aspnum\faauto\adjustright\rin0\lin0';
        v_exhibit_table :=
            v_exhibit_table
            || '\fs22\lang1033\langfe1033\cgrid\langnp1033\langfenp1033  \trowd \irow0\irowband0\ts18\trgaph108\trrh1900\trleft-108\trbrdrh\brdrs\brdrw10 \trbrdrv\brdrs\brdrw10';
        v_exhibit_table :=
            v_exhibit_table
            || '\trftsWidth2\trwWidth5000\trftsWidthB3\trftsWidthA3\trautofit1\trpaddl108\trpaddr108\trpaddfl3\trpaddft3\trpaddfb3\trpaddfr3\tblrsid14035271\tbllkhdrrows\tbllklastrow\tbllkhdrcols\tbllklastcol \clvertalc\clbrdrt\brdrtbl \clbrdrl\brdrtbl \clbrdrb';
        v_exhibit_table :=
            v_exhibit_table
            || '\brdrs\brdrw10 \clbrdrr\brdrtbl \cltxlrtb\clftsWidth2\clwWidth5000\clshdrawnil \cellx9468\row \trowd \irow1\irowband1\lastrow \ts18\trgaph108\trrh7964\trleft-108\trbrdrh\brdrs\brdrw10 \trbrdrv\brdrs\brdrw10';
        v_exhibit_table :=
            v_exhibit_table
            || '\trftsWidth2\trwWidth5000\trftsWidthB3\trftsWidthA3\trautofit1\trpaddl108\trpaddr108\trpaddfl3\trpaddft3\trpaddfb3\trpaddfr3\tblrsid14035271\tbllkhdrrows\tbllklastrow\tbllkhdrcols\tbllklastcol \clvertalc\clbrdrt\brdrs\brdrw10 \clbrdrl\brdrtbl \clbrdrb';
        v_exhibit_table :=
            v_exhibit_table
            || '\brdrtbl \clbrdrr\brdrtbl \cltxlrtb\clftsWidth2\clwWidth5000\clshdrawnil \cellx9468\pard\plain \qc \li0\ri0\widctlpar\intbl\faauto\rin0\lin0\pararsid2117219\yts18 \fs36\lang1033\langfe1033\cgrid\langnp1033\langfenp1033 ';
        v_exhibit_table :=
            v_exhibit_table
            || '[TOKEN@EXHIBIT_NAME]\cell \pard\plain \ql \li0\ri0\widctlpar\intbl\aspalpha\aspnum\faauto\adjustright\rin0\lin0 \fs22\lang1033\langfe1033\cgrid\langnp1033\langfenp1033 \trowd \irow1\irowband1\lastrow \ts18\trgaph108\trrh7964\trleft-108';
        v_exhibit_table :=
            v_exhibit_table
            || '\trbrdrh\brdrs\brdrw10 \trbrdrv\brdrs\brdrw10 \trftsWidth2\trwWidth5000\trftsWidthB3\trftsWidthA3\trautofit1\trpaddl108\trpaddr108\trpaddfl3\trpaddft3\trpaddfb3\trpaddfr3\tblrsid14035271\tbllkhdrrows\tbllklastrow\tbllkhdrcols\tbllklastcol \clvertalc';
        v_exhibit_table :=
            v_exhibit_table
            || '\clbrdrt\brdrs\brdrw10 \clbrdrl\brdrtbl \clbrdrb\brdrtbl \clbrdrr\brdrtbl \cltxlrtb\clftsWidth2\clwWidth5000\clshdrawnil \cellx9468\row \pard\plain \ql \li0\ri0\widctlpar\aspalpha\aspnum\faauto\adjustright\rin0\lin0\itap0\yts18';
        v_exhibit_table :=
                      v_exhibit_table || '\fs22\lang1033\langfe1033\cgrid\langnp1033\langfenp1033 ';
        v_exhibit_table :=
            v_exhibit_table
            || '\trowd \irow0\irowband0\ts18\trgaph108\trrh1900\trleft-108\trbrdrh\brdrs\brdrw10 \trbrdrv\brdrs\brdrw10';
        v_exhibit_table :=
            v_exhibit_table
            || '\trftsWidth2\trwWidth5000\trftsWidthB3\trftsWidthA3\trautofit1\trpaddl108\trpaddr108\trpaddfl3\trpaddft3\trpaddfb3\trpaddfr3\tblrsid14035271\tbllkhdrrows\tbllklastrow\tbllkhdrcols\tbllklastcol \clvertalc\clbrdrt\brdrtbl \clbrdrl\brdrtbl \clbrdrb';
        v_exhibit_table :=
            v_exhibit_table
            || '\brdrs\brdrw10 \clbrdrr\brdrtbl \cltxlrtb\clftsWidth2\clwWidth5000\clshdrawnil \cellx9468\pard\plain \qc \li0\ri0\widctlpar\intbl\faauto\rin0\lin0\pararsid2117219\yts18 \fs22\lang1033\langfe1033\cgrid\langnp1033\langfenp1033 ';
        v_exhibit_table :=
            v_exhibit_table || '\b\fs36 Exhibit #\b\fs36 [TOKEN@EXHIBIT_NUMBER]\b\fs36 \par '
            || osi_classification.get_report_class(pactivitysid)
            || ' \cell \pard\plain \ql \li0\ri0\widctlpar\intbl\aspalpha\aspnum\faauto\adjustright\rin0\lin0';
        v_exhibit_table :=
            v_exhibit_table
            || '\fs22\lang1033\langfe1033\cgrid\langnp1033\langfenp1033  \trowd \irow0\irowband0\ts18\trgaph108\trrh1900\trleft-108\trbrdrh\brdrs\brdrw10 \trbrdrv\brdrs\brdrw10';
        v_exhibit_table :=
            v_exhibit_table
            || '\trftsWidth2\trwWidth5000\trftsWidthB3\trftsWidthA3\trautofit1\trpaddl108\trpaddr108\trpaddfl3\trpaddft3\trpaddfb3\trpaddfr3\tblrsid14035271\tbllkhdrrows\tbllklastrow\tbllkhdrcols\tbllklastcol \clvertalc\clbrdrt\brdrtbl \clbrdrl\brdrtbl \clbrdrb';
        v_exhibit_table :=
            v_exhibit_table
            || '\brdrs\brdrw10 \clbrdrr\brdrtbl \cltxlrtb\clftsWidth2\clwWidth5000\clshdrawnil \cellx9468\row ';

        for a in (select   a.description, ra.activity, ra.seq,
                           '(para. 2-' || trim(to_char(ra.seq + v_paraoffset, '999'))
                           || ')' as para_no
                      from t_osi_report_activity ra,
                           t_osi_attachment a,
                           t_osi_report_attachment rat
                     where (ra.activity = a.obj and rat.attachment = a.SID)
                       and ra.spec = v_spec_sid
                       and ra.spec = rat.spec
                       and ra.activity = pactivitysid
                       and ra.selected='Y'
                       and rat.selected = 'Y'
                  order by ra.seq)
        loop
            v_exhibit_cnt := v_exhibit_cnt + 1;
            v_cnt := v_cnt + 1;
            osi_util.aitc(v_exhibits_list,
                          ' \tab ' || v_exhibit_cnt || ' \tab '
                          || osi_report.replace_special_chars_clob(a.description, 'RTF') || ' '
                          || osi_report.replace_special_chars_clob(a.para_no, 'RTF') || '\par\par ');

            if v_cnt = 1 then
                v_tmp_narr_exhibits := v_exhibit_cnt;
            else
                v_tmp_narr_exhibits := v_tmp_narr_exhibits || ', ' || v_exhibit_cnt;
            end if;

            v_exhibit_covers :=
                v_exhibit_covers
                || replace(replace(v_exhibit_table,
                                   '[TOKEN@EXHIBIT_NUMBER]',
                                   v_exhibit_cnt || '\par ' || a.para_no),
                           '[TOKEN@EXHIBIT_NAME]',
                           osi_report.replace_special_chars_clob(a.description, 'RTF'));
        end loop;

        log_error('<<<Get_Act_Exhibit-Exhibits for ' || pactivitysid || '=' || v_cnt
                  || ', Total Exhibits=' || v_exhibit_cnt);

        if v_cnt > 0 then
            if v_cnt = 1 then
                return 'Exhibit: ' || v_tmp_narr_exhibits;
            else
                return 'Exhibits: ' || v_tmp_narr_exhibits;
            end if;
        else
            return v_tmp_narr_exhibits;
        end if;
    exception
        when others then
            return '';
    end get_act_exhibit;

    function case_status_report(psid in varchar2)
        return clob is
        v_ok              varchar2(1000);
        v_template        clob                                    := null;
        v_template_date   date;
        v_mime_type       t_core_template.mime_type%type;
        v_mime_disp       t_core_template.mime_disposition%type;
        v_full_id         varchar2(100)                           := null;
        v_file_id         varchar2(100)                           := null;
        v_summary         clob                                    := null;
        v_report_by       varchar2(500);
        v_unit_address    varchar2(500);
        v_unit_name       varchar2(100);
        v_file_offense    varchar2(1000);
        v_distributions   varchar2(3000);
        v_updates         clob                                    := null;
        v_class           varchar2(100);
    begin
        log_error('Case_Status_Report<<< - Start ' || sysdate());
        v_obj_sid := psid;
        /* Grab template and assign to v_template  */
        v_ok :=
            core_template.get_latest('CASE_STATUS_REPORT',
                                     v_template,
                                     v_template_date,
                                     v_mime_type,
                                     v_mime_disp);

        /* ----------------- Cover Page ------------------ */
        for a in (select s.SID, s.obj, pt.purpose, it.ig_code, st.status
                    from t_osi_report_spec s,
                         t_osi_report_igcode_type it,
                         t_osi_report_status_type st,
                         t_osi_report_purpose_type pt,
                         t_osi_report_type rt
                   where obj = v_obj_sid
                     and s.report_type = rt.SID
                     and rt.description = 'Case Status Report'
                     and s.ig_code = it.SID
                     and s.status = st.SID
                     and s.purpose = pt.SID)
        loop
            v_spec_sid := a.SID;
            v_ok :=
                core_template.replace_tag(v_template,
                                          'DATE',
                                          to_char(sysdate, v_date_fmt),
                                          'TOKEN@',
                                          true);
            --- First Page Footer Information ---
            v_ok :=
                core_template.replace_tag(v_template,
                                          'PURPOSE',
                                          osi_report.replace_special_chars(a.purpose, 'RTF'),
                                          'TOKEN@',
                                          true);
            v_ok :=
                core_template.replace_tag(v_template,
                                          'IGCODES',
                                          osi_report.replace_special_chars(a.ig_code, 'RTF'),
                                          'TOKEN@',
                                          true);
            v_ok :=
                core_template.replace_tag(v_template,
                                          'STATUS',
                                          osi_report.replace_special_chars(a.status, 'RTF'),
                                          'TOKEN@',
                                          true);
        end loop;

        for b in (select i.summary_investigation, f.id, f.full_id,
                         ot.description || ', ' || ot.code as file_offense
                    from t_osi_f_investigation i,
                         t_osi_file f,
                         t_osi_f_inv_offense o,
                         t_osi_reference r,
                         t_dibrs_offense_type ot
                   where i.SID = v_obj_sid
                     and i.SID(+) = f.SID
                     and i.SID = o.investigation
                     and o.priority = r.SID
                     and (r.code = 'P' and r.usage = 'OFFENSE_PRIORITY')
                     and o.offense = ot.SID)
        loop
            v_full_id := b.full_id;
            v_file_id := b.id;
            v_file_offense := b.file_offense;
            v_summary := b.summary_investigation;
        end loop;

        v_ok := core_template.replace_tag(v_template, 'FILE_ID', v_file_id, 'TOKEN@', true);
        v_ok := core_template.replace_tag(v_template, 'FILE_NUM', v_full_id, 'TOKEN@', true);
        v_ok := core_template.replace_tag(v_template, 'SUBJECT', get_subject_list);
        v_ok :=
            core_template.replace_tag(v_template,
                                      'OFFENSES',
                                      osi_report.replace_special_chars_clob(v_file_offense, 'RTF'));
        v_ok :=
            core_template.replace_tag(v_template,
                                      'BACKGROUND',
                                      osi_report.replace_special_chars_clob(v_summary, 'RTF'));

        v_class := osi_classification.get_report_class(v_obj_sid);

        v_ok :=
            core_template.replace_tag(v_template,
                                      'CLASSIFICATION',
                                      osi_report.replace_special_chars(v_class, 'RTF'),
                                      'TOKEN@',
                                      true);

        --- More First Page Footer Information ---
        for a in (select distribution
                    from t_osi_report_distribution
                   where spec = v_spec_sid)
        loop
            v_distributions := v_distributions || a.distribution || '; ';
        end loop;

        v_distributions := rtrim(v_distributions, '; ');
        v_ok :=
            core_template.replace_tag(v_template,
                                      'DISTRIBUTION',
                                      osi_report.replace_special_chars(v_distributions, 'RTF'));
        v_ok := core_template.replace_tag(v_template, 'REV', '');

        --- Report By ---
        begin
            select unit_name,
                   osi_address.get_addr_display(osi_address.get_address_sid(ua.unit), null, ' ')
                                                                                         as address
              into v_unit_name,
                   v_unit_address
              from t_osi_personnel_unit_assign ua, t_osi_unit_name un
             where ua.unit = un.unit
               and ua.unit = osi_personnel.get_current_unit(core_context.personnel_sid)
               and ua.personnel = core_context.personnel_sid
               and un.end_date is null;
          /*  select unit_name,
                   osi_address.get_addr_display(osi_address.get_address_sid(unit)) as address
              into v_unit_name,
                   v_unit_address
              from v_osi_obj_assignments oa, t_osi_unit_name un
             where obj = v_obj_sid and un.unit = oa.current_unit;
        select display_string_line
          into v_unit_address
          from v_address_v2
         where parent = context_pkg.unit_sid; */
        exception
            when no_data_found then
                v_unit_address := '<unknown>';
        end;

        v_ok :=
            core_template.replace_tag
                                  (v_template,
                                   'REPORT_BY',
                                   osi_report.replace_special_chars(core_context.personnel_name,
                                                                    'RTF')
                                   || ', ' || osi_report.replace_special_chars(v_unit_name, 'RTF')
                                   || ', ' || v_unit_address,
                                   'TOKEN@',
                                   false);

        --- Update via 'Case Status Report - Update' Note Type ---
        for a in (select note_text
                    from t_osi_note n, t_osi_note_type nt
                   where n.obj = v_obj_sid
                     and n.note_type = nt.SID
                     and nt.description = 'Case Status Report - Update'
                     and obj_type = core_obj.get_objtype(v_obj_sid))
        loop
            v_updates :=
                v_updates || osi_report.replace_special_chars_clob(a.note_text, 'RTF')
                || ' \par\par ';
        end loop;

        v_updates := rtrim(v_updates, ' \par\par ');
        v_ok := core_template.replace_tag(v_template, 'UPDATES', v_updates, 'TOKEN@', false);
        log_error('Case_Status_Report - End ' || sysdate());
        return v_template;
    exception
        when others then
            log_error('Case_Status_Report - Error -->' || sqlerrm);
            return v_template;
    end case_status_report;

    function letter_of_notification(psid in varchar2)
        return clob is
        v_ok                  varchar2(1000);
        v_template            clob                                    := null;
        v_template_date       date;
        v_mime_type           t_core_template.mime_type%type;
        v_mime_disp           t_core_template.mime_disposition%type;
        v_full_id             varchar2(100)                           := null;
        v_file_id             varchar2(100)                           := null;
        v_letters             clob                                    := null;
        v_unit_from_address   varchar2(1000);
        v_unit_sid            varchar2(20);
        v_unit_name           varchar2(1000);
        v_memorandum_to       varchar2(1000);
        v_lead_agent          varchar2(1000);
        v_lead_agent_phone    varchar2(100);
        v_lead_agent_sid      varchar2(20);
        v_subject_name        varchar2(1000);
        v_subject_ssn         varchar2(20);
        v_subject_lastname    varchar2(1000);
        v_signature_line      varchar2(5000);
        v_fax_number          varchar2(100);
        v_sig_phone           varchar2(100);
        v_class               varchar2(100);
    begin
        log_error('Letter_Of_Notification<<< - Start ' || sysdate());
        v_obj_sid := psid;
        /* Grab template and assign to v_template  */
        v_ok :=
            core_template.get_latest('LETTER_OF_NOTIFICATION',
                                     v_template,
                                     v_template_date,
                                     v_mime_type,
                                     v_mime_disp);

        --- Get Actual SID of Object ---
        for a in (select SID
                    from t_osi_report_spec
                   where obj = v_obj_sid)
        loop
            v_spec_sid := a.SID;
        end loop;

        --- Get the Lead Agents Sid and Name ---
        v_lead_agent_sid := osi_object.get_lead_agent(v_obj_sid);

        begin
            select decode(badge_num, null, '', 'SA ') || nls_initcap(first_name || ' ' || last_name)
              into v_lead_agent
              from t_core_personnel cp, t_osi_personnel op
             where cp.SID = v_lead_agent_sid and op.SID = cp.SID;
        exception
            when others then
                v_lead_agent := core_context.personnel_name;
        end;

        v_lead_agent_phone := getpersonnelphone(v_lead_agent_sid);

        --- Get the Full and File ID's ---
        begin
            select full_id, id
              into v_full_id, v_file_id
              from t_osi_file
             where SID = v_obj_sid;
        exception
            when others then
                v_full_id := '<Case Number Not Found>';
                v_file_id := '<Case Number Not Found>';
        end;

        --- Get the Owning Units SID and Name ---
        begin
            select unit, unit_name
              into v_unit_sid, v_unit_name
              from t_osi_f_unit f, t_osi_unit_name un
             where f.file_sid= v_obj_sid and un.unit = f.UNIT_SID and f.end_date is null and un.end_date is null;
        exception
            when others then
                v_unit_sid := osi_object.get_assigned_unit(v_obj_sid);
                v_unit_name := osi_unit.get_name(v_unit_sid);
        end;

        --- Get the Owning Unit's Address ---
        begin
            select unit_name,
                   osi_address.get_addr_display(osi_address.get_address_sid(v_unit_sid), null, ' ')
                                                                                         as address
              into v_unit_name,
                   v_unit_from_address
              from t_osi_f_unit f, t_osi_unit_name un
             where f.file_sid= v_obj_sid and un.unit = f.UNIT_SID and f.end_date is null and un.end_date is null;
        exception
            when others then
                v_unit_from_address := '<<Unit Address not Entered in UMM>>';
        end;

        if v_full_id is null then
            v_full_id := v_file_id;
        end if;

        v_fax_number := getunitphone(v_unit_sid, 'Office - Fax');

        --- Build the Signature Line ---
        begin
            select 'FOR THE COMMANDER \par\par\par\par\par ' || first_name || ' ' || last_name
                   || decode(badge_num, null, '', ', Special Agent')
                   || decode(pay_category, '03', ', DAF', '04', ', DAF', ', USAF')
              into v_signature_line
              from t_core_personnel cp, t_osi_personnel op
             where cp.SID = core_context.personnel_sid and cp.SID = op.SID;
        exception
            when others then
                v_signature_line :=
                          'FOR THE COMMANDER \par\par\par\par\par<Agent Name>, Special Agent, USAF';
        end;

        v_signature_line :=
            v_signature_line || '\par Superintendent, AFOSI '
            || replace(v_unit_name, 'DET', 'Detachment');
        v_sig_phone := getpersonnelphone(core_context.personnel_sid);

        --- One Page Letters for Each Subject associated to the Case ---
        for a in (select pi.participant_version, sa_rank, ssn
                    from v_osi_participant_version pv,
                         t_osi_partic_involvement pi,
                         t_osi_partic_role_type prt
                   where pi.obj = v_obj_sid
                     and pv.SID = pi.participant_version
                     and pi.involvement_role = prt.SID
                     and (prt.role = 'Subject' and prt.usage = 'SUBJECT'))
        loop
            if v_letters is not null then
                v_letters := v_letters || ' \page \par ';
            end if;

            --- Get The Subjects Military Organization Name ---
            for p in (select related_name as that_name
                        from v_osi_partic_relation, t_osi_participant_version pv
                       where this_participant = pv.participant and pv.SID = a.participant_version)
                 --and that_person_subtype_code = 'M'
                -- and end_date is null
            --order by start_date)
            loop
                v_memorandum_to := p.that_name;
            end loop;

            if v_memorandum_to is null then
                v_memorandum_to := '<<Military Organization NOT FOUND>>';
            end if;

            v_subject_name := null;
            v_subject_lastname := null;

            --- Get the Subjects RANK FIRST_NAME LAST_NAME ---
            for n in (select nls_initcap(first_name) as first_name,
                             nls_initcap(last_name) as last_name, nt.description as name_type
                        from t_osi_partic_name pn, t_osi_partic_name_type nt
                       where participant_version = a.participant_version and pn.name_type = nt.SID)
            loop
                if    n.name_type = 'Legal'
                   or v_subject_name is null then
                    v_subject_name := n.first_name || ' ' || n.last_name;
                    v_subject_lastname := n.last_name;
                end if;
            end loop;

            if a.sa_rank is not null then
                v_subject_name := a.sa_rank || ' ' || v_subject_name;
                v_subject_lastname := a.sa_rank || ' ' || v_subject_lastname;
            end if;

            if a.sa_rank is null then
                v_subject_lastname := v_subject_name;
            end if;

            --- Get the Subjects SSN ---
            if a.ssn is not null then

              v_Subject_SSN := Replace(a.ssn,'-','');
              v_Subject_SSN := ' (' || substr(v_Subject_SSN,1,3) || '-' || substr(v_Subject_SSN,4,2) || '-' || substr(v_Subject_SSN,6,4) || ')';

            end if;

            v_letters := v_letters || '\ltrrow\trowd \irow0\irowband0\ltrrow';
            v_letters := v_letters || '\ts16\trrh193\trleft0\trftsWidth2\trwWidth5000\trftsWidthB3\trftsWidthA3\trpaddfl3\trpaddft3\trpaddfb3\trpaddfr3\tblrsid9313373\tbllkhdrrows\tbllklastrow\tbllkhdrcols\tbllklastcol\tblind0\tblindtype3 \clvertalt\clbrdrt\brdrtbl \clbrdrl\brdrtbl \clbrdrb';
            v_letters := v_letters || '\brdrtbl \clbrdrr\brdrtbl \cltxlrtb\clNoWrap\clftsWidth2\clwWidth5000\clpadt0\clpadr0\clpadft3\clpadfr3\clshdrawnil \cellx9360\pard\plain \ltrpar\qr \li0\ri0\widctlpar\intbl\wrapdefault\aspalpha\aspnum\faauto\adjustright\rin0\lin0\pararsid9313373'; 
            v_letters := v_letters || '\rtlch\fcs1 \af0\afs24\alang1025 \ltrch\fcs0 \fs24\lang1033\langfe1033\cgrid\langnp1033\langfenp1033 {\rtlch\fcs1 \af0 \ltrch\fcs0 \insrsid2702642\charrsid2903220 ' || to_char(sysdate, v_date_fmt) || '}{\rtlch\fcs1 \af0 \ltrch\fcs0 \insrsid2702642';
            v_letters := v_letters || '\par }{\rtlch\fcs1 \af0 \ltrch\fcs0 \lang2070\langfe1033\langnp2070\insrsid2702642\charrsid2903220 \cell }\pard \ltrpar\ql \li0\ri0\sa200\sl276\slmult1\widctlpar\intbl\wrapdefault\aspalpha\aspnum\faauto\adjustright\rin0\lin0 {\rtlch\fcs1 \af0 \ltrch\fcs0'; 
            v_letters := v_letters || '\insrsid2702642 \trowd \irow0\irowband0\ltrrow\ts16\trrh193\trleft0\trftsWidth2\trwWidth5000\trftsWidthB3\trftsWidthA3\trpaddfl3\trpaddft3\trpaddfb3\trpaddfr3\tblrsid9313373\tbllkhdrrows\tbllklastrow\tbllkhdrcols\tbllklastcol\tblind0\tblindtype3'; 
            v_letters := v_letters || '\clvertalt\clbrdrt\brdrtbl \clbrdrl\brdrtbl \clbrdrb\brdrtbl \clbrdrr\brdrtbl \cltxlrtb\clNoWrap\clftsWidth2\clwWidth5000\clpadt0\clpadr0\clpadft3\clpadfr3\clshdrawnil \cellx9360\row \ltrrow}\trowd \irow1\irowband1\ltrrow';
            v_letters := v_letters || '\ts16\trrh193\trleft0\trftsWidth2\trwWidth5000\trftsWidthB3\trftsWidthA3\trpaddfl3\trpaddft3\trpaddfb3\trpaddfr3\tblrsid9313373\tbllkhdrrows\tbllklastrow\tbllkhdrcols\tbllklastcol\tblind0\tblindtype3 \clvertalt\clbrdrt\brdrtbl \clbrdrl\brdrtbl \clbrdrb';
            v_letters := v_letters || '\brdrtbl \clbrdrr\brdrtbl \cltxlrtb\clNoWrap\clftsWidth2\clwWidth1298\clpadt0\clpadr0\clpadft3\clpadfr3\clshdrawnil \cellx2430\clvertalt\clbrdrt\brdrtbl \clbrdrl\brdrtbl \clbrdrb\brdrtbl \clbrdrr\brdrtbl'; 
            v_letters := v_letters || '\cltxlrtb\clNoWrap\clftsWidth2\clwWidth3702\clpadt0\clpadr0\clpadft3\clpadfr3\clshdrawnil \cellx9360\pard \ltrpar\ql \li0\ri0\widctlpar\intbl\wrapdefault\aspalpha\aspnum\faauto\adjustright\rin0\lin0\pararsid9313373 {\rtlch\fcs1 \af0 \ltrch\fcs0'; 
            v_letters := v_letters || '\lang2070\langfe1033\langnp2070\insrsid2702642\charrsid2903220 MEMORANDUM FOR \cell }{\rtlch\fcs1 \af0 \ltrch\fcs0 \insrsid2702642   ' || osi_report.replace_special_chars(nls_initcap(v_memorandum_to), 'RTF') || '}{\rtlch\fcs1 \af0 \ltrch\fcs0'; 
            v_letters := v_letters || '\lang2070\langfe1033\langnp2070\insrsid2702642\charrsid2903220'; 
            v_letters := v_letters || '\par }\pard \ltrpar\qr \li0\ri0\widctlpar\intbl\wrapdefault\aspalpha\aspnum\faauto\adjustright\rin0\lin0\pararsid9313373 {\rtlch\fcs1 \af0 \ltrch\fcs0 \lang2070\langfe1033\langnp2070\insrsid2702642\charrsid2903220  }{\rtlch\fcs1 \af0 \ltrch\fcs0'; 
            v_letters := v_letters || '\insrsid2702642\charrsid11272613 \cell }\pard \ltrpar\ql \li0\ri0\sa200\sl276\slmult1\widctlpar\intbl\wrapdefault\aspalpha\aspnum\faauto\adjustright\rin0\lin0 {\rtlch\fcs1 \af0 \ltrch\fcs0 \insrsid2702642 \trowd \irow1\irowband1\ltrrow';
            v_letters := v_letters || '\ts16\trrh193\trleft0\trftsWidth2\trwWidth5000\trftsWidthB3\trftsWidthA3\trpaddfl3\trpaddft3\trpaddfb3\trpaddfr3\tblrsid9313373\tbllkhdrrows\tbllklastrow\tbllkhdrcols\tbllklastcol\tblind0\tblindtype3 \clvertalt\clbrdrt\brdrtbl \clbrdrl\brdrtbl \clbrdrb';
            v_letters := v_letters || '\brdrtbl \clbrdrr\brdrtbl \cltxlrtb\clNoWrap\clftsWidth2\clwWidth1298\clpadt0\clpadr0\clpadft3\clpadfr3\clshdrawnil \cellx2430\clvertalt\clbrdrt\brdrtbl \clbrdrl\brdrtbl \clbrdrb\brdrtbl \clbrdrr\brdrtbl'; 
            v_letters := v_letters || '\cltxlrtb\clNoWrap\clftsWidth2\clwWidth3702\clpadt0\clpadr0\clpadft3\clpadfr3\clshdrawnil \cellx9360\row \ltrrow}\trowd \irow2\irowband2\ltrrow';
            v_letters := v_letters || '\ts16\trrh193\trleft0\trftsWidth2\trwWidth5000\trftsWidthB3\trftsWidthA3\trpaddfl3\trpaddft3\trpaddfb3\trpaddfr3\tblrsid9313373\tbllkhdrrows\tbllklastrow\tbllkhdrcols\tbllklastcol\tblind0\tblindtype3 \clvertalt\clbrdrt\brdrtbl \clbrdrl\brdrtbl \clbrdrb';
            v_letters := v_letters || '\brdrtbl \clbrdrr\brdrtbl \cltxlrtb\clNoWrap\clftsWidth2\clwWidth5000\clshdrawnil \cellx9360\pard\plain \ltrpar\s17\qc \li0\ri0\widctlpar\intbl\wrapdefault\aspalpha\aspnum\faauto\adjustright\rin0\lin0\pararsid9313373 \rtlch\fcs1 \af0\afs20\alang1025'; 
            v_letters := v_letters || '\ltrch\fcs0 \fs20\lang1033\langfe1033\cgrid\langnp1033\langfenp1033 {\rtlch\fcs1 \af0\afs24 \ltrch\fcs0 \b\fs24\insrsid2702642 \cell }\pard\plain \ltrpar\ql \li0\ri0\sa200\sl276\slmult1';
            v_letters := v_letters || '\widctlpar\intbl\wrapdefault\aspalpha\aspnum\faauto\adjustright\rin0\lin0 \rtlch\fcs1 \af0\afs24\alang1025 \ltrch\fcs0 \fs24\lang1033\langfe1033\cgrid\langnp1033\langfenp1033 {\rtlch\fcs1 \af0 \ltrch\fcs0 \insrsid2702642 \trowd \irow2\irowband2\ltrrow';
            v_letters := v_letters || '\ts16\trrh193\trleft0\trftsWidth2\trwWidth5000\trftsWidthB3\trftsWidthA3\trpaddfl3\trpaddft3\trpaddfb3\trpaddfr3\tblrsid9313373\tbllkhdrrows\tbllklastrow\tbllkhdrcols\tbllklastcol\tblind0\tblindtype3 \clvertalt\clbrdrt\brdrtbl \clbrdrl\brdrtbl \clbrdrb';
            v_letters := v_letters || '\brdrtbl \clbrdrr\brdrtbl \cltxlrtb\clNoWrap\clftsWidth2\clwWidth5000\clshdrawnil \cellx9360\row \ltrrow}\trowd \irow3\irowband3\ltrrow';
            v_letters := v_letters || '\ts16\trrh193\trleft0\trftsWidth2\trwWidth5000\trftsWidthB3\trftsWidthA3\trpaddfl3\trpaddft3\trpaddfb3\trpaddfr3\tblrsid9313373\tbllkhdrrows\tbllklastrow\tbllkhdrcols\tbllklastcol\tblind0\tblindtype3 \clvertalt\clbrdrt\brdrtbl \clbrdrl\brdrtbl \clbrdrb';
            v_letters := v_letters || '\brdrtbl \clbrdrr\brdrtbl \cltxlrtb\clNoWrap\clftsWidth2\clwWidth433\clpadt0\clpadr0\clpadft3\clpadfr3\clshdrawnil \cellx811\clvertalt\clbrdrt\brdrtbl \clbrdrl\brdrtbl \clbrdrb\brdrtbl \clbrdrr\brdrtbl'; 
            v_letters := v_letters || '\cltxlrtb\clNoWrap\clftsWidth2\clwWidth4567\clshdrawnil \cellx9360\pard \ltrpar\ql \li0\ri0\widctlpar\intbl\wrapdefault\aspalpha\aspnum\faauto\adjustright\rin0\lin0\pararsid9313373 {\rtlch\fcs1 \af0 \ltrch\fcs0 \insrsid2702642 FROM:    }{\rtlch\fcs1 \af0'; 
            v_letters := v_letters || '\ltrch\fcs0 \insrsid2702642\charrsid2903220 \cell }{\rtlch\fcs1 \af0 \ltrch\fcs0 \insrsid2702642 ' || replace(v_unit_name, 'DET', 'Detachment') || '}{\rtlch\fcs1 \af0 \ltrch\fcs0 \insrsid2702642\charrsid2903220 \cell }\pard \ltrpar\ql \li0\ri0\sa200\sl276\slmult1';
            v_letters := v_letters || '\widctlpar\intbl\wrapdefault\aspalpha\aspnum\faauto\adjustright\rin0\lin0 {\rtlch\fcs1 \af0 \ltrch\fcs0 \b\insrsid2702642 \trowd \irow3\irowband3\ltrrow';
            v_letters := v_letters || '\ts16\trrh193\trleft0\trftsWidth2\trwWidth5000\trftsWidthB3\trftsWidthA3\trpaddfl3\trpaddft3\trpaddfb3\trpaddfr3\tblrsid9313373\tbllkhdrrows\tbllklastrow\tbllkhdrcols\tbllklastcol\tblind0\tblindtype3 \clvertalt\clbrdrt\brdrtbl \clbrdrl\brdrtbl \clbrdrb';
            v_letters := v_letters || '\brdrtbl \clbrdrr\brdrtbl \cltxlrtb\clNoWrap\clftsWidth2\clwWidth433\clpadt0\clpadr0\clpadft3\clpadfr3\clshdrawnil \cellx811\clvertalt\clbrdrt\brdrtbl \clbrdrl\brdrtbl \clbrdrb\brdrtbl \clbrdrr\brdrtbl'; 
            v_letters := v_letters || '\cltxlrtb\clNoWrap\clftsWidth2\clwWidth4567\clshdrawnil \cellx9360\row \ltrrow}\trowd \irow4\irowband4\ltrrow';
            v_letters := v_letters || '\ts16\trrh193\trleft0\trftsWidth2\trwWidth5000\trftsWidthB3\trftsWidthA3\trpaddfl3\trpaddft3\trpaddfb3\trpaddfr3\tblrsid9313373\tbllkhdrrows\tbllklastrow\tbllkhdrcols\tbllklastcol\tblind0\tblindtype3 \clvertalt\clbrdrt\brdrtbl \clbrdrl\brdrtbl \clbrdrb';
            v_letters := v_letters || '\brdrtbl \clbrdrr\brdrtbl \cltxlrtb\clNoWrap\clftsWidth2\clwWidth433\clshdrawnil \cellx811\clvertalt\clbrdrt\brdrtbl \clbrdrl\brdrtbl \clbrdrb\brdrtbl \clbrdrr\brdrtbl \cltxlrtb\clftsWidth2\clwWidth4567\clshdrawnil \cellx9360\pard \ltrpar';
            v_letters := v_letters || '\ql \li0\ri0\widctlpar\intbl\wrapdefault\aspalpha\aspnum\faauto\adjustright\rin0\lin0\pararsid9313373 {\rtlch\fcs1 \af0 \ltrch\fcs0 \b\insrsid2702642 \cell }{\rtlch\fcs1 \af0 \ltrch\fcs0 \insrsid2702642 ' || osi_report.replace_special_chars(v_unit_from_address, 'RTF') || '}{';
            v_letters := v_letters || '\rtlch\fcs1 \af0 \ltrch\fcs0 \b\insrsid2702642 \cell }\pard \ltrpar\ql \li0\ri0\sa200\sl276\slmult1\widctlpar\intbl\wrapdefault\aspalpha\aspnum\faauto\adjustright\rin0\lin0 {\rtlch\fcs1 \af0 \ltrch\fcs0 \b\insrsid2702642 \trowd \irow4\irowband4\ltrrow';
            v_letters := v_letters || '\ts16\trrh193\trleft0\trftsWidth2\trwWidth5000\trftsWidthB3\trftsWidthA3\trpaddfl3\trpaddft3\trpaddfb3\trpaddfr3\tblrsid9313373\tbllkhdrrows\tbllklastrow\tbllkhdrcols\tbllklastcol\tblind0\tblindtype3 \clvertalt\clbrdrt\brdrtbl \clbrdrl\brdrtbl \clbrdrb';
            v_letters := v_letters || '\brdrtbl \clbrdrr\brdrtbl \cltxlrtb\clNoWrap\clftsWidth2\clwWidth433\clshdrawnil \cellx811\clvertalt\clbrdrt\brdrtbl \clbrdrl\brdrtbl \clbrdrb\brdrtbl \clbrdrr\brdrtbl \cltxlrtb\clftsWidth2\clwWidth4567\clshdrawnil \cellx9360\row \ltrrow';
            v_letters := v_letters || '}\trowd \irow5\irowband5\ltrrow\ts16\trrh193\trleft0\trftsWidth2\trwWidth5000\trftsWidthB3\trftsWidthA3\trpaddfl3\trpaddft3\trpaddfb3\trpaddfr3\tblrsid9313373\tbllkhdrrows\tbllklastrow\tbllkhdrcols\tbllklastcol\tblind0\tblindtype3 \clvertalt\clbrdrt';
            v_letters := v_letters || '\brdrtbl \clbrdrl\brdrtbl \clbrdrb\brdrtbl \clbrdrr\brdrtbl \cltxlrtb\clNoWrap\clftsWidth2\clwWidth5000\clshdrawnil \cellx9360\pard \ltrpar\ql \li0\ri0\widctlpar\intbl\wrapdefault\aspalpha\aspnum\faauto\adjustright\rin0\lin0\pararsid9313373 {\rtlch\fcs1'; 
            v_letters := v_letters || '\af0 \ltrch\fcs0 \insrsid2702642 \cell }\pard \ltrpar\ql \li0\ri0\sa200\sl276\slmult1\widctlpar\intbl\wrapdefault\aspalpha\aspnum\faauto\adjustright\rin0\lin0 {\rtlch\fcs1 \af0 \ltrch\fcs0 \b\insrsid2702642 \trowd \irow5\irowband5\ltrrow';
            v_letters := v_letters || '\ts16\trrh193\trleft0\trftsWidth2\trwWidth5000\trftsWidthB3\trftsWidthA3\trpaddfl3\trpaddft3\trpaddfb3\trpaddfr3\tblrsid9313373\tbllkhdrrows\tbllklastrow\tbllkhdrcols\tbllklastcol\tblind0\tblindtype3 \clvertalt\clbrdrt\brdrtbl \clbrdrl\brdrtbl \clbrdrb';
            v_letters := v_letters || '\brdrtbl \clbrdrr\brdrtbl \cltxlrtb\clNoWrap\clftsWidth2\clwWidth5000\clshdrawnil \cellx9360\row \ltrrow}\pard \ltrpar\ql \li0\ri0\widctlpar\intbl\wrapdefault\aspalpha\aspnum\faauto\adjustright\rin0\lin0\pararsid9313373 {\rtlch\fcs1 \af0 \ltrch\fcs0';
            v_letters := v_letters || '\insrsid2702642 ' || 'SUBJECT:  ' || 'Notification of AFOSI Investigation involving ' || v_Subject_Name || v_Subject_SSN || ' case number ' || v_full_id || '.' || '}{\rtlch\fcs1 \af0 \ltrch\fcs0 \insrsid2702642\charrsid1525579 \cell }\pard \ltrpar\ql \li0\ri0\sa200\sl276\slmult1';
            v_letters := v_letters || '\widctlpar\intbl\wrapdefault\aspalpha\aspnum\faauto\adjustright\rin0\lin0 {\rtlch\fcs1 \af0 \ltrch\fcs0 \b\insrsid2702642 \trowd \irow6\irowband6\ltrrow';
            v_letters := v_letters || '\ts16\trrh193\trleft0\trftsWidth2\trwWidth5000\trftsWidthB3\trftsWidthA3\trpaddfl3\trpaddft3\trpaddfb3\trpaddfr3\tblrsid9313373\tbllkhdrrows\tbllklastrow\tbllkhdrcols\tbllklastcol\tblind0\tblindtype3 \clvertalt\clbrdrt\brdrtbl \clbrdrl\brdrtbl \clbrdrb';
            v_letters := v_letters || '\brdrtbl \clbrdrr\brdrtbl \cltxlrtb\clNoWrap\clftsWidth2\clwWidth5000\clshdrawnil \cellx9360\row \ltrrow}\pard \ltrpar\ql \li0\ri0\widctlpar\intbl\wrapdefault\aspalpha\aspnum\faauto\adjustright\rin0\lin0\pararsid9313373 {\rtlch\fcs1 \af0 \ltrch\fcs0'; 
            v_letters := v_letters || '\insrsid2702642\charrsid7890914 \cell }\pard \ltrpar\ql \li0\ri0\sa200\sl276\slmult1\widctlpar\intbl\wrapdefault\aspalpha\aspnum\faauto\adjustright\rin0\lin0 {\rtlch\fcs1 \af0 \ltrch\fcs0 \b\insrsid2702642 \trowd \irow7\irowband7\ltrrow';
            v_letters := v_letters || '\ts16\trrh193\trleft0\trftsWidth2\trwWidth5000\trftsWidthB3\trftsWidthA3\trpaddfl3\trpaddft3\trpaddfb3\trpaddfr3\tblrsid9313373\tbllkhdrrows\tbllklastrow\tbllkhdrcols\tbllklastcol\tblind0\tblindtype3 \clvertalt\clbrdrt\brdrtbl \clbrdrl\brdrtbl \clbrdrb';
            v_letters := v_letters || '\brdrtbl \clbrdrr\brdrtbl \cltxlrtb\clNoWrap\clftsWidth2\clwWidth5000\clshdrawnil \cellx9360\row \ltrrow}\pard \ltrpar\ql \li0\ri0\widctlpar\intbl\wrapdefault\aspalpha\aspnum\faauto\adjustright\rin0\lin0\pararsid9313373 {\rtlch\fcs1 \af0 \ltrch\fcs0'; 
            v_letters := v_letters || '\insrsid2702642 '; 
            v_letters := v_letters || '1.  This is to inform you there is an on-going AFOSI investigation involving ' || v_Subject_LastName || ' from the ' || v_Memorandum_To || '.  IAW AFPD 71-1, Criminal Investigations and Counterintelligence, paragraph 7.5.3., Air Force Commanders: "Do not reass';
            v_letters := v_letters || 'ign order or permit any type of investigation, or take any other official action against someone undergoing an AFOSI investigation before coordinating with AFOSI and the servicing SJA."  We recommend you place this individual on administrative hold IAW AFI 36-2110, Table 2.1, Rule 10, Code 17';
            v_letters := v_letters || ' to prevent PCS and/or retirement pending completion of the investigation, and command action if appropriate.  Please coordinate any TDY or leave requests concerning this individual with AFOSI prior to approval.}{\rtlch\fcs1 \af0 \ltrch\fcs0'; 
            v_letters := v_letters || '\b\insrsid2702642 \cell }\pard \ltrpar\ql \li0\ri0\sa200\sl276\slmult1\widctlpar\intbl\wrapdefault\aspalpha\aspnum\faauto\adjustright\rin0\lin0 {\rtlch\fcs1 \af0 \ltrch\fcs0 \b\insrsid2702642 \trowd \irow8\irowband8\ltrrow';
            v_letters := v_letters || '\ts16\trrh193\trleft0\trftsWidth2\trwWidth5000\trftsWidthB3\trftsWidthA3\trpaddfl3\trpaddft3\trpaddfb3\trpaddfr3\tblrsid9313373\tbllkhdrrows\tbllklastrow\tbllkhdrcols\tbllklastcol\tblind0\tblindtype3 \clvertalt\clbrdrt\brdrtbl \clbrdrl\brdrtbl \clbrdrb';
            v_letters := v_letters || '\brdrtbl \clbrdrr\brdrtbl \cltxlrtb\clNoWrap\clftsWidth2\clwWidth5000\clshdrawnil \cellx9360\row \ltrrow}\trowd \irow9\irowband9\ltrrow';
            v_letters := v_letters || '\ts16\trrh135\trleft0\trftsWidth2\trwWidth5000\trftsWidthB3\trftsWidthA3\trpaddfl3\trpaddft3\trpaddfb3\trpaddfr3\tblrsid9313373\tbllkhdrrows\tbllklastrow\tbllkhdrcols\tbllklastcol\tblind0\tblindtype3 \clvertalt\clbrdrt\brdrtbl \clbrdrl\brdrtbl \clbrdrb';
            v_letters := v_letters || '\brdrtbl \clbrdrr\brdrtbl \cltxlrtb\clNoWrap\clftsWidth2\clwWidth5000\clshdrawnil \cellx9360\pard \ltrpar\ql \li0\ri0\widctlpar\intbl\wrapdefault\aspalpha\aspnum\faauto\adjustright\rin0\lin0\pararsid9313373 {\rtlch\fcs1 \af0 \ltrch\fcs0'; 
            v_letters := v_letters || '\insrsid2702642\charrsid268333 \cell }\pard \ltrpar\ql \li0\ri0\sa200\sl276\slmult1\widctlpar\intbl\wrapdefault\aspalpha\aspnum\faauto\adjustright\rin0\lin0 {\rtlch\fcs1 \af0 \ltrch\fcs0 \b\insrsid2702642 \trowd \irow9\irowband9\ltrrow';
            v_letters := v_letters || '\ts16\trrh135\trleft0\trftsWidth2\trwWidth5000\trftsWidthB3\trftsWidthA3\trpaddfl3\trpaddft3\trpaddfb3\trpaddfr3\tblrsid9313373\tbllkhdrrows\tbllklastrow\tbllkhdrcols\tbllklastcol\tblind0\tblindtype3 \clvertalt\clbrdrt\brdrtbl \clbrdrl\brdrtbl \clbrdrb';
            v_letters := v_letters || '\brdrtbl \clbrdrr\brdrtbl \cltxlrtb\clNoWrap\clftsWidth2\clwWidth5000\clshdrawnil \cellx9360\row \ltrrow}\pard \ltrpar\ql \li0\ri0\widctlpar\intbl\wrapdefault\aspalpha\aspnum\faauto\adjustright\rin0\lin0\pararsid9313373 {\rtlch\fcs1 \af0 \ltrch\fcs0\insrsid2702642 ';
            v_letters := v_letters || '2.  Please endorse this letter and fax it to ' || v_Unit_Name || ', at ' || v_Fax_Number || '.  The case agent assigned to this investigation is ' || v_Lead_Agent || '.  If you have any questions concerning the investigation please contact the case agent first at ' || v_Lead_Agent_Phone || '.  If the case agent is unavailable, I can be reac';
            v_letters := v_letters || 'hed at ' || v_Sig_Phone || '.}{\rtlch\fcs1 \af0 \ltrch\fcs0 \insrsid2702642\charrsid268333 \cell }\pard \ltrpar\ql \li0\ri0\sa200\sl276\slmult1\widctlpar\intbl\wrapdefault\aspalpha\aspnum\faauto\adjustright\rin0\lin0 {\rtlch\fcs1 \af0 \ltrch\fcs0 \b\insrsid2702642'; 
            v_letters := v_letters || '\trowd \irow10\irowband10\ltrrow\ts16\trrh135\trleft0\trftsWidth2\trwWidth5000\trftsWidthB3\trftsWidthA3\trpaddfl3\trpaddft3\trpaddfb3\trpaddfr3\tblrsid9313373\tbllkhdrrows\tbllklastrow\tbllkhdrcols\tbllklastcol\tblind0\tblindtype3 \clvertalt\clbrdrt';
            v_letters := v_letters || '\brdrtbl \clbrdrl\brdrtbl \clbrdrb\brdrtbl \clbrdrr\brdrtbl \cltxlrtb\clNoWrap\clftsWidth2\clwWidth5000\clshdrawnil \cellx9360\row \ltrrow}\trowd \irow11\irowband11\ltrrow';
            v_letters := v_letters || '\ts16\trrh576\trleft0\trftsWidth2\trwWidth5000\trftsWidthB3\trftsWidthA3\trpaddfl3\trpaddft3\trpaddfb3\trpaddfr3\tblrsid9313373\tbllkhdrrows\tbllklastrow\tbllkhdrcols\tbllklastcol\tblind0\tblindtype3 \clvertalt\clbrdrt\brdrtbl \clbrdrl\brdrtbl \clbrdrb';
            v_letters := v_letters || '\brdrtbl \clbrdrr\brdrtbl \cltxlrtb\clNoWrap\clftsWidth2\clwWidth5000\clshdrawnil \cellx9360\pard \ltrpar\ql \li0\ri0\widctlpar\intbl\wrapdefault\aspalpha\aspnum\faauto\adjustright\rin0\lin0\pararsid9313373 {\rtlch\fcs1 \af0 \ltrch\fcs0 \insrsid2702642'; 
            v_letters := v_letters || '\cell }\pard \ltrpar\ql \li0\ri0\sa200\sl276\slmult1\widctlpar\intbl\wrapdefault\aspalpha\aspnum\faauto\adjustright\rin0\lin0 {\rtlch\fcs1 \af0 \ltrch\fcs0 \b\insrsid2702642 \trowd \irow11\irowband11\ltrrow';
            v_letters := v_letters || '\ts16\trrh576\trleft0\trftsWidth2\trwWidth5000\trftsWidthB3\trftsWidthA3\trpaddfl3\trpaddft3\trpaddfb3\trpaddfr3\tblrsid9313373\tbllkhdrrows\tbllklastrow\tbllkhdrcols\tbllklastcol\tblind0\tblindtype3 \clvertalt\clbrdrt\brdrtbl \clbrdrl\brdrtbl \clbrdrb';
            v_letters := v_letters || '\brdrtbl \clbrdrr\brdrtbl \cltxlrtb\clNoWrap\clftsWidth2\clwWidth5000\clshdrawnil \cellx9360\row \ltrrow}\trowd \irow12\irowband12\lastrow \ltrrow';
            v_letters := v_letters || '\ts16\trrh1269\trleft0\trftsWidth2\trwWidth5000\trftsWidthB3\trftsWidthA3\trpaddfl3\trpaddft3\trpaddfb3\trpaddfr3\tblrsid9313373\tbllkhdrrows\tbllklastrow\tbllkhdrcols\tbllklastcol\tblind0\tblindtype3 \clvertalb\clbrdrt\brdrtbl \clbrdrl\brdrtbl \clbrdrb';
            v_letters := v_letters || '\brdrtbl \clbrdrr\brdrtbl \cltxlrtb\clNoWrap\clftsWidth2\clwWidth2868\clshdrawnil \cellx5369\clvertalb\clbrdrt\brdrtbl \clbrdrl\brdrtbl \clbrdrb\brdrtbl \clbrdrr\brdrtbl \cltxlrtb\clftsWidth2\clwWidth2132\clshdrawnil \cellx9360\pard \ltrpar';
            v_letters := v_letters || '\qr \li0\ri0\widctlpar\intbl\wrapdefault\aspalpha\aspnum\faauto\adjustright\rin0\lin0\pararsid9313373 {\rtlch\fcs1 \af0 \ltrch\fcs0 \insrsid2702642 \cell }\pard \ltrpar';
            v_letters := v_letters || '\ql \li0\ri0\widctlpar\intbl\wrapdefault\aspalpha\aspnum\faauto\adjustright\rin0\lin0\pararsid9313373 {\rtlch\fcs1 \af0 \ltrch\fcs0 \insrsid2702642 ' || v_Signature_Line; 
            v_letters := v_letters || '\cell }\pard \ltrpar\ql \li0\ri0\sa200\sl276\slmult1\widctlpar\intbl\wrapdefault\aspalpha\aspnum\faauto\adjustright\rin0\lin0 {\rtlch\fcs1 \af0 \ltrch\fcs0 \b\insrsid2702642 \trowd \irow12\irowband12\lastrow \ltrrow';
            v_letters := v_letters || '\ts16\trrh1269\trleft0\trftsWidth2\trwWidth5000\trftsWidthB3\trftsWidthA3\trpaddfl3\trpaddft3\trpaddfb3\trpaddfr3\tblrsid9313373\tbllkhdrrows\tbllklastrow\tbllkhdrcols\tbllklastcol\tblind0\tblindtype3 \clvertalb\clbrdrt\brdrtbl \clbrdrl\brdrtbl \clbrdrb';
            v_letters := v_letters || '\brdrtbl \clbrdrr\brdrtbl \cltxlrtb\clNoWrap\clftsWidth2\clwWidth2868\clshdrawnil \cellx5369\clvertalb\clbrdrt\brdrtbl \clbrdrl\brdrtbl \clbrdrb\brdrtbl \clbrdrr\brdrtbl \cltxlrtb\clftsWidth2\clwWidth2132\clshdrawnil \cellx9360\row }\pard \ltrpar';
            v_letters := v_letters || '\ql \li0\ri0\widctlpar\wrapdefault\aspalpha\aspnum\faauto\adjustright\rin0\lin0\itap0';

        end loop;

        v_ok := core_template.replace_tag(v_template, 'FILE_ID', v_file_id, 'TOKEN@', true);
        v_ok := core_template.replace_tag(v_template, 'LETTERS', v_letters);

        v_class := osi_classification.get_report_class(v_obj_sid);

        v_ok :=
            core_template.replace_tag(v_template,
                                      'CLASSIFICATION',
                                      osi_report.replace_special_chars(v_class || v_newline || v_privacyActInfo, 'RTF'));
        log_error('Letter_Of_Notification - End ' || sysdate());
        return v_template;
    exception
        when others then
            log_error('Letter_Of_Notification - Error -->' || sqlerrm);
            return v_template;
    end letter_of_notification;

    function getpersonnelphone(psid in varchar2, onlygetthistype in varchar2 := null)
        return varchar2 is
        v_phone_number   varchar2(100) := null;
    begin
        if onlygetthistype is not null then
            for m in (select value
                        into v_phone_number
                        from t_osi_personnel_contact pc, t_osi_reference r
                       where pc.personnel = psid
                         and pc.type = r.SID
                         and r.code = onlygetthistype
                         and r.usage = 'CONTACT_TYPE')
            loop
                v_phone_number := m.value;
            end loop;

            return v_phone_number;
        end if;

        for m in (select value
                    into v_phone_number
                    from t_osi_personnel_contact pc, t_osi_reference r
                   where pc.personnel = psid
                     and pc.type = r.SID
                     and r.code = 'OFFP'
                     and r.usage = 'CONTACT_TYPE')
        loop
            v_phone_number := m.value;
        end loop;

        if v_phone_number is null then
            for m in (select value
                        into v_phone_number
                        from t_osi_personnel_contact pc, t_osi_reference r
                       where pc.personnel = psid
                         and pc.type = r.SID
                         and r.code = 'OFFA'
                         and r.usage = 'CONTACT_TYPE')
            loop
                v_phone_number := m.value;
            end loop;
        end if;

        if v_phone_number is null then
            for m in (select value
                        into v_phone_number
                        from t_osi_personnel_contact pc, t_osi_reference r
                       where pc.personnel = psid
                         and pc.type = r.SID
                         and r.code = 'DSNP'
                         and r.usage = 'CONTACT_TYPE')
            loop
                v_phone_number := m.value;
            end loop;
        end if;

        if v_phone_number is null then
            for m in (select value
                        into v_phone_number
                        from t_osi_personnel_contact pc, t_osi_reference r
                       where pc.personnel = psid
                         and pc.type = r.SID
                         and r.code = 'DSNA'
                         and r.usage = 'CONTACT_TYPE')
            loop
                v_phone_number := m.value;
            end loop;
        end if;

        if v_phone_number is null then
            for m in (select value
                        into v_phone_number
                        from t_osi_personnel_contact pc, t_osi_reference r
                       where pc.personnel = psid
                         and pc.type = r.SID
                         and r.code = 'MOBP'
                         and r.usage = 'CONTACT_TYPE')
            loop
                v_phone_number := m.value;
            end loop;
        end if;

        if v_phone_number is null then
            for m in (select value
                        into v_phone_number
                        from t_osi_personnel_contact pc, t_osi_reference r
                       where pc.personnel = psid
                         and pc.type = r.SID
                         and r.code = 'MOBA'
                         and r.usage = 'CONTACT_TYPE')
            loop
                v_phone_number := m.value;
            end loop;
        end if;

        return v_phone_number;
    end getpersonnelphone;

    function getparticipantphone(psid in varchar2, onlygetthistype in varchar2 := null)
        return varchar2 is
        v_phone_number   varchar2(100) := null;
    begin
        if onlygetthistype is not null then
            v_phone_number := osi_participant.get_contact_value(psid, onlygetthistype);
            return v_phone_number;
        end if;

        v_phone_number := osi_participant.get_contact_value(psid, 'OFFP');

        if v_phone_number is null then
            v_phone_number := osi_participant.get_contact_value(psid, 'OFFA');
        end if;

        if v_phone_number is null then
            v_phone_number := osi_participant.get_contact_value(psid, 'DSNP');
        end if;

        if v_phone_number is null then
            v_phone_number := osi_participant.get_contact_value(psid, 'DSNA');
        end if;

        if v_phone_number is null then
            v_phone_number := osi_participant.get_contact_value(psid, 'MOBP');
        end if;

        if v_phone_number is null then
            v_phone_number := osi_participant.get_contact_value(psid, 'MOBA');
        end if;

        return v_phone_number;
    end getparticipantphone;

    function getunitphone(psid in varchar2, onlygetthistype in varchar2 := null)
        return varchar2 is
        v_phone_number   varchar2(100) := null;
    begin
        if onlygetthistype is not null then
            for m in (select value
                        into v_phone_number
                        from t_osi_unit_contact uc, t_osi_reference r
                       where uc.unit = psid
                         and uc.type = r.SID
                         and r.description = onlygetthistype
                         and r.usage = 'CONTACT_TYPE')
            loop
                v_phone_number := m.value;
            end loop;

            return v_phone_number;
        end if;
    end getunitphone;

    function case_subjectvictimwitnesslist(psid in varchar2)
        return clob is
        v_ok              varchar2(1000);
        v_template        clob                                    := null;
        v_template_date   date;
        v_mime_type       t_core_template.mime_type%type;
        v_mime_disp       t_core_template.mime_disposition%type;
        v_full_id         varchar2(100)                           := null;
        v_file_id         varchar2(100)                           := null;
        v_list            clob                                    := null;
        v_subject_name    varchar2(1000);
        v_subject_ssn     varchar2(20);
        v_office_phone    varchar2(100)                           := null;
        v_home_phone      varchar2(100)                           := null;
        v_email           varchar2(100)                           := null;
        v_last_role       varchar2(1000)                 := '~~FIRST_TIME_THROUGH~~UNIQUE~~HERE~~~';
    begin
        log_error('CASE_SubjectVictimWitnessList <<< - Start ' || sysdate());
        v_obj_sid := psid;
        /* Grab template and assign to v_template  */
        v_ok :=
            core_template.get_latest('SUBJECT_VICTIM_WITNESS_LIST',
                                     v_template,
                                     v_template_date,
                                     v_mime_type,
                                     v_mime_disp);

        --- Get Actual SID of Object ---
        for a in (select SID
                    from t_osi_report_spec
                   where obj = v_obj_sid)
        loop
            v_spec_sid := a.SID;
        end loop;

        --- Get the Full and File ID's ---
        begin
            select full_id, id
              into v_full_id, v_file_id
              from t_osi_file
             where SID = v_obj_sid;
        exception
            when others then
                v_full_id := '<Case Number Not Found>';
                v_file_id := '<Case Number Not Found>';
        end;

        if v_full_id is null then
            v_full_id := v_file_id;
        end if;

        --- List Subjects ---
        for a in (select   pi.participant_version, pi.obj,
                           decode(prt.role,
                                  'Subject of Activity', 'Witness',
                                  'Primary', 'Witness',
                                  prt.role) as involvement_role,
                           osi_participant.get_name(pv.SID) as name,
                           osi_participant.get_org_member_name(pv.SID) as org_name,
                           osi_participant.get_org_member_addr(pv.SID) as org_addr,
                           pv.current_address_desc as curr_addr_line, pv.ssn,
                           pv.sa_service_desc as sa_service, pv.sa_rank
                      from v_osi_participant_version pv,
                           t_osi_partic_involvement pi,
                           t_osi_partic_role_type prt
                     where pi.obj = v_obj_sid
                       and pv.SID = pi.participant_version
                       and pi.involvement_role = prt.SID
                       and prt.role in('Subject', 'Victim')
                  union all
                  select   pi.participant_version, pi.obj,
                           decode(prt.role,
                                  'Subject of Activity', 'Witness',
                                  'Primary', 'Witness',
                                  prt.role) as involvement_role,
                           osi_participant.get_name(pv.SID) as name,
                           osi_participant.get_org_member_name(pv.SID) as org_name,
                           osi_participant.get_org_member_addr(pv.SID) as org_addr,
                           pv.current_address_desc as curr_addr_line, pv.ssn,
                           pv.sa_service_desc as sa_service, pv.sa_rank
                      from v_osi_participant_version pv,
                           t_osi_partic_involvement pi,
                           t_osi_partic_role_type prt
                     where pi.obj in(
                               select fa.activity_sid
                                 from t_osi_activity a,
                                      t_osi_assoc_fle_act fa,
                                      t_core_obj o,
                                      t_core_obj_type cot
                                where fa.file_sid = v_obj_sid
                                  and a.SID = fa.activity_sid
                                  and a.SID = o.SID
                                  and o.obj_type = cot.SID
                                  and (   cot.description = 'Interview, Witness'
                                       or cot.description = 'Group Interview'))
                       and pv.SID = pi.participant_version
                       and pi.involvement_role = prt.SID
                       and prt.role in('Subject of Activity', 'Witness', 'Primary')
                  order by 3, 4)
        loop
            if v_last_role <> a.involvement_role then
                v_last_role := a.involvement_role;
                v_list :=
                    v_list
                    || ' \par \trowd \irow0\irowband0\lastrow \ts15\trgaph108\trleft-108\trbrdrt\brdrs\brdrw10 \trbrdrh\brdrs\brdrw10 \trbrdrv\brdrs\brdrw10';
                v_list :=
                    v_list
                    || '\trftsWidth2\trwWidth5000\trftsWidthB3\trftsWidthA3\trautofit1\trpaddl108\trpaddr108\trpaddfl3\trpaddft3\trpaddfb3\trpaddfr3\tblrsid2975115\tbllkhdrrows\tbllklastrow\tbllkhdrcols\tbllklastcol \clvertalt\clbrdrt\brdrs\brdrw10 \clbrdrl\brdrtbl \clbrdrb';
                v_list :=
                    v_list
                    || '\brdrtbl \clbrdrr\brdrtbl \cltxlrtb\clftsWidth2\clwWidth5000\clshdrawnil \cellx11196\pard \ql \li0\ri0\widctlpar\intbl\aspalpha\aspnum\faauto\adjustright\rin0\lin0 \fs1 \cell \pard';
                v_list :=
                    v_list
                    || '\ql \li0\ri0\widctlpar\intbl\aspalpha\aspnum\faauto\adjustright\rin0\lin0 \trowd \irow0\irowband0\lastrow \ts15\trgaph108\trleft-108\trbrdrt\brdrs\brdrw10 \trbrdrh\brdrs\brdrw10 \trbrdrv\brdrs\brdrw10';
                v_list :=
                    v_list
                    || '\trftsWidth2\trwWidth5000\trftsWidthB3\trftsWidthA3\trautofit1\trpaddl108\trpaddr108\trpaddfl3\trpaddft3\trpaddfb3\trpaddfr3\tblrsid2975115\tbllkhdrrows\tbllklastrow\tbllkhdrcols\tbllklastcol \clvertalt\clbrdrt\brdrs\brdrw10 \clbrdrl\brdrtbl \clbrdrb';
                v_list :=
                    v_list
                    || '\brdrtbl \clbrdrr\brdrtbl \cltxlrtb\clftsWidth2\clwWidth5000\clshdrawnil \cellx11196\row \pard \ql \li0\ri0\widctlpar\aspalpha\aspnum\faauto\adjustright\rin0\lin0\itap0 \fs24 ';
                v_list := v_list || '\qc\b ' || a.involvement_role || '(s) \b0';
            end if;

            v_list :=
                v_list
                || ' \par \trowd \irow0\irowband0\lastrow \ts15\trgaph108\trleft-108\trbrdrt\brdrs\brdrw10 \trbrdrh\brdrs\brdrw10 \trbrdrv\brdrs\brdrw10';
            v_list :=
                v_list
                || '\trftsWidth2\trwWidth5000\trftsWidthB3\trftsWidthA3\trautofit1\trpaddl108\trpaddr108\trpaddfl3\trpaddft3\trpaddfb3\trpaddfr3\tblrsid2975115\tbllkhdrrows\tbllklastrow\tbllkhdrcols\tbllklastcol \clvertalt\clbrdrt\brdrs\brdrw10 \clbrdrl\brdrtbl \clbrdrb';
            v_list :=
                v_list
                || '\brdrtbl \clbrdrr\brdrtbl \cltxlrtb\clftsWidth2\clwWidth5000\clshdrawnil \cellx11196\pard \ql \li0\ri0\widctlpar\intbl\aspalpha\aspnum\faauto\adjustright\rin0\lin0 \fs1 \cell \pard';
            v_list :=
                v_list
                || '\ql \li0\ri0\widctlpar\intbl\aspalpha\aspnum\faauto\adjustright\rin0\lin0 \trowd \irow0\irowband0\lastrow \ts15\trgaph108\trleft-108\trbrdrt\brdrs\brdrw10 \trbrdrh\brdrs\brdrw10 \trbrdrv\brdrs\brdrw10';
            v_list :=
                v_list
                || '\trftsWidth2\trwWidth5000\trftsWidthB3\trftsWidthA3\trautofit1\trpaddl108\trpaddr108\trpaddfl3\trpaddft3\trpaddfb3\trpaddfr3\tblrsid2975115\tbllkhdrrows\tbllklastrow\tbllkhdrcols\tbllklastcol \clvertalt\clbrdrt\brdrs\brdrw10 \clbrdrl\brdrtbl \clbrdrb';
            v_list :=
                v_list
                || '\brdrtbl \clbrdrr\brdrtbl \cltxlrtb\clftsWidth2\clwWidth5000\clshdrawnil \cellx11196\row \pard \ql \li0\ri0\widctlpar\aspalpha\aspnum\faauto\adjustright\rin0\lin0\itap0 \fs24 \par ';
            v_subject_name := null;
            v_subject_ssn := null;

            --- Get the Subjects RANK FIRST_NAME MIDDLE_NAME LAST_NAME, CADENCY ---
            for n in (select nls_initcap(first_name) as first_name,
                             nls_initcap(middle_name) as middle_name,
                             nls_initcap(last_name) as last_name, pnt.description as name_type,
                             cadency
                        from t_osi_partic_name pn, t_osi_partic_name_type pnt
                       where participant_version = a.participant_version and pn.name_type = pnt.SID)
            loop
                if    n.name_type = 'Legal'
                   or v_subject_name is null then
                    v_subject_name := n.first_name || ' ';

                    if n.middle_name is not null then
                        v_subject_name := v_subject_name || n.middle_name || ' ';
                    end if;

                    v_subject_name := v_subject_name || n.last_name;

                    if n.cadency is not null then
                        v_subject_name := v_subject_name || ', ' || n.cadency;
                    end if;
                end if;
            end loop;

            if a.sa_rank is not null then
                v_subject_name := a.sa_rank || ' ' || v_subject_name;
            end if;

            --- Get the Subjects SSN ---
            if a.ssn is not null then
                v_subject_ssn := replace(a.ssn, '-', '');
                v_subject_ssn :=
                    substr(v_subject_ssn, 1, 3) || '-' || substr(v_subject_ssn, 4, 2) || '-'
                    || substr(v_subject_ssn, 5, 4);
            end if;

            --- Get Office Phone Number ---
            v_office_phone :=
                        osi_participant.get_contact_value(a.participant_version, 'Office - Primary');

            if v_office_phone is null then
                v_office_phone :=
                     osi_participant.get_contact_value(a.participant_version, 'Office - Alternate');
            end if;

            if v_office_phone is null then
                v_office_phone :=
                          osi_participant.get_contact_value(a.participant_version, 'DSN - Primary');
            end if;

            if v_office_phone is null then
                v_office_phone :=
                        osi_participant.get_contact_value(a.participant_version, 'DSN - Alternate');
            end if;

            --- Get Home Phone Number ---
            v_home_phone :=
                          osi_participant.get_contact_value(a.participant_version, 'Home - Primary');

            if v_home_phone is null then
                v_home_phone :=
                       osi_participant.get_contact_value(a.participant_version, 'Home - Alternate');
            end if;

            if v_home_phone is null then
                v_home_phone :=
                       osi_participant.get_contact_value(a.participant_version, 'Mobile - Primary');
            end if;

            if v_home_phone is null then
                v_home_phone :=
                     osi_participant.get_contact_value(a.participant_version, 'Mobile - Alternate');
            end if;

            --- Get Email Address ---
            v_email := osi_participant.get_contact_value(a.participant_version, 'Email - Primary');

            if v_email is null then
                v_email :=
                      osi_participant.get_contact_value(a.participant_version, 'Email - Alternate');
            end if;

   -------------------------------------------
--- Add this Participant to the Listing ---
   -------------------------------------------
            v_list := v_list || ltrim(rtrim(v_subject_name)) || ' \par ';

            if v_subject_ssn is not null then
                v_list := v_list || v_subject_ssn || ' \par ';
            end if;

            if a.curr_addr_line is not null then
                v_list := v_list || a.curr_addr_line || ' \par ';
            end if;

            if a.sa_service is not null and a.sa_service <> 'N/A' then
                v_list := v_list || a.sa_service || ' \par ';
            end if;

            if a.org_name is not null then
                v_list := v_list || a.org_name || ' \par ';
            end if;

            if a.org_addr is not null then
                v_list := v_list || a.org_addr || ' \par ';
            end if;

            if v_office_phone is not null then
                v_list := v_list || v_office_phone || ' \par ';
            end if;

            if v_home_phone is not null then
                v_list := v_list || v_home_phone || ' \par ';
            end if;

            if v_email is not null then
                v_list := v_list || v_email || ' \par ';
            end if;
        end loop;

        v_ok := core_template.replace_tag(v_template, 'FILE_ID', v_file_id, 'TOKEN@', true);
        v_ok := core_template.replace_tag(v_template, 'FULL_ID', v_full_id, 'TOKEN@', true);
        v_ok := core_template.replace_tag(v_template, 'LIST', v_list);
        log_error('CASE_SubjectVictimWitnessList - End ' || sysdate());
        return v_template;
    exception
        when others then
            log_error('CASE_SubjectVictimWitnessList - Error -->' || sqlerrm);
            return v_template;
    end case_subjectvictimwitnesslist;

    function idp_notes_report(psid in varchar2)
        return clob is
        v_ok              varchar2(1000);
        v_template        clob                                    := null;
        v_template_date   date;
        v_mime_type       t_core_template.mime_type%type;
        v_mime_disp       t_core_template.mime_disposition%type;
        v_cnt             number                                  := 0;
        v_full_id         varchar2(100)                           := null;
        v_file_id         varchar2(100)                           := null;
        v_unit_sid        varchar2(20);
        v_idp_list        clob                                    := null;
        v_url             varchar2(4000) := core_util.get_config('CORE.BASE_URL');
        v_tempstring      clob;
    begin
        log_error('IDP_Notes_Report<<< - Start ' || sysdate());
        v_obj_sid := psid;
        /* Grab template and assign to v_template  */
        v_ok :=
            core_template.get_latest('IDP_NOTES_RPT',
                                     v_template,
                                     v_template_date,
                                     v_mime_type,
                                     v_mime_disp);
        /* ----------------- Cover Page ------------------ */
        v_ok :=
            core_template.replace_tag(v_template,
                                      'RPT_DATE',
                                      to_char(sysdate, v_date_fmt),
                                      'TOKEN@',
                                      true);

        for b in (select full_id, id
                    into v_full_id, v_file_id
                    from t_osi_file
                   where SID = v_obj_sid)
        loop
            v_full_id := b.full_id;
            v_file_id := b.id;
        end loop;

        for c in (select unit, unit_name
                    from v_osi_obj_assignments oa, t_osi_unit_name un
                   where obj = v_obj_sid and un.unit = oa.current_unit and end_date is null)
        loop
            v_unit_sid := c.unit;
            v_ok := core_template.replace_tag(v_template, 'UNIT_NAME', c.unit_name, 'TOKEN@', true);
        -- multiple instances
        end loop;

        v_ok := core_template.replace_tag(v_template, 'FILE_ID', v_file_id, 'TOKEN@', true);
        -- multiple instances
        v_ok := core_template.replace_tag(v_template, 'FILE_NO', v_full_id, 'TOKEN@', true);
        -- multiple instances
        log_error('OBJ =' || v_obj_sid);
        v_idp_list := null;

        for a in (select n.sid, n.create_by, n.create_on, obj, note_text, seq, 'Note from:  ' || core_obj.get_parentinfo(n.obj) as parentinfo
                        from t_osi_note n, t_osi_note_type nt
                        where n.note_type=nt.sid 
                          and   (n.obj=v_obj_sid 
---                             or (n.obj in (select that_file from v_osi_assoc_fle_fle where this_file=v_obj_sid)) 
                             or (n.obj in (select activity_sid from v_osi_assoc_fle_act where file_sid=v_obj_sid)) 
---                             or (n.obj in (select activity_sid from v_osi_assoc_fle_act where file_sid in (select that_file from v_osi_assoc_fle_fle where this_file=v_obj_sid)))
                                )         
                          and nt.description in('Curtailed Content Report Note', 'IDP Note')
                      order by n.create_on,seq )
        loop
            v_cnt := v_cnt + 1;
            --osi_util.aitc(v_idp_list, '\par\par ' || v_cnt || '\tab ' || a.parentinfo || '\par \tab ');

        v_tempstring := '{\field\fldedit{\*\fldinst HYPERLINK "' || v_url || a.obj || '~' || a.sid || '" }';
        v_tempstring := v_tempstring || '{\fldrslt'; 
        v_tempstring := v_tempstring || '\cs16\ul\cf2 ' || osi_report.replace_special_chars_clob(a.parentinfo, 'RTF') || '}} ';
        osi_util.aitc(v_idp_list, '\par\par ' || v_cnt || '.\tab ' || v_tempstring || '\par \tab ');
        osi_util.aitc(v_idp_list, 'Note Created by ' || a.create_by || ' on ' || to_char(a.create_on, v_date_fmt) || '\par\par \tab ');
            
            dbms_lob.append(v_idp_list, osi_report.replace_special_chars_clob(a.note_text, 'RTF'));
        end loop;

        v_ok := core_template.replace_tag(v_template, 'CLASSIFICATION', osi_classification.get_report_class(v_obj_sid));
        v_ok := core_template.replace_tag(v_template, 'IDP_NOTES', v_idp_list);
        core_util.cleanup_temp_clob(v_idp_list);
        log_error('IDP_Notes_Report - End ' || sysdate());
        return v_template;
    exception
        when others then
            log_error('IDP_Notes_Report - Error -->' || sqlerrm);
            return v_template;
    end idp_notes_report;

    function form_40_roi(psid in varchar2)
        return clob is
        v_ok                         varchar2(1000);
        v_template                   clob                                    := null;
        v_template_date              date;
        v_mime_type                  t_core_template.mime_type%type;
        v_mime_disp                  t_core_template.mime_disposition%type;
        v_full_id                    varchar2(100)                           := null;
        v_file_id                    varchar2(100)                           := null;
        v_summary                    clob                                    := null;
        v_report_by                  varchar2(500);
        v_unit_name                  varchar2(500);
        v_unit_address               varchar2(500);
        v_subject_count              number;
        v_defendants                 clob;
        v_defendants_pages           clob;
        v_defendants_details         clob;
        v_phone_number               varchar2(100);
        v_birth_label                varchar2(50);
        v_birth_information          varchar2(32000);
        v_ssn_label                  varchar2(50);
        v_ssn_information            varchar2(100);
        v_marital_label              varchar2(50);
        v_marital_information        varchar2(100);
        v_heightweight               varchar2(100);
        v_occupation                 varchar2(500);
        v_spouse_sid                 varchar2(20);
        v_spouse_name                varchar2(500);
        v_spouse_deceased            date;
        v_height_weight              varchar2(100);
        v_subject_of_activity        varchar2(500);
        v_curr_address               varchar2(500);
        v_sid                        varchar2(20);
        v_exhibits_pages             clob;
        v_exhibit_information        clob;
        v_exhibit_counter            number;
        v_evidence_list              clob;
        v_evidence_counter           number;
        v_leadagent                  varchar2(500);
        v_background                 clob;
        v_status_notes               clob;
        v_other_activities           clob;
        v_other_activities_counter   number;
        v_program_data               clob;
        v_class                      varchar2(100);
        pragma autonomous_transaction;
    begin
        log_error('Form_40_ROI<<< - Start ' || sysdate());
        v_obj_sid := psid;
        /* Grab template and assign to v_template  */
        v_ok :=
            core_template.get_latest('FORM_40_ROI',
                                     v_template,
                                     v_template_date,
                                     v_mime_type,
                                     v_mime_disp);
        /* ----------------- Cover Page ------------------ */
        v_ok :=
            core_template.replace_tag(v_template,
                                      'RPT_DATE',
                                      to_char(sysdate, v_date_fmt),
                                      'TOKEN@',
                                      true);

        osi_report.load_participants(psid);
        osi_report.load_agents_assigned(psid);
        log_error('Get file details');

        for b in (select i.summary_investigation, i.summary_allegation, f.id, f.full_id
                    from t_osi_f_investigation i, t_osi_file f
                   where i.SID = v_obj_sid and i.SID(+) = f.SID)
        loop
            v_full_id := b.full_id;
            v_file_id := b.id;
            v_summary := b.summary_investigation;
            v_background := b.summary_allegation;
        end loop;

        v_ok := core_template.replace_tag(v_template, 'FILE_ID', v_file_id, 'TOKEN@', true);
        v_ok := core_template.replace_tag(v_template, 'FILE_NO', v_full_id, 'TOKEN@', true);
        v_ok :=
            core_template.replace_tag(v_template,
                                      'SUMMARY',
                                      osi_report.replace_special_chars_clob(v_summary, 'RTF'));

        v_class := osi_classification.get_report_class(v_obj_sid);

        v_ok :=
            core_template.replace_tag(v_template,
                                      'CLASSIFICATION',
                                      osi_report.replace_special_chars(v_class, 'RTF'),
                                      'TOKEN@',
                                      true);

        if    v_background is null
           or v_background = '' then
            v_ok := core_template.replace_tag(v_template, 'BACKGROUND_LABEL', '', 'TOKEN@', true);
            v_ok := core_template.replace_tag(v_template, 'BACKGROUND', '');
        else
            v_ok :=
                core_template.replace_tag(v_template,
                                          'BACKGROUND_LABEL',
                                          'Background',
                                          'TOKEN@',
                                          true);
            v_ok :=
                core_template.replace_tag(v_template,
                                          'BACKGROUND',
                                          osi_report.replace_special_chars_clob(v_background, 'RTF'));
        end if;

        -- Program Data
        log_error('Get Program Data Notes');
        v_program_data := '';

        for a in (select   n.note_text
                      from t_osi_note n, t_osi_note_type nt
                     where n.obj = v_obj_sid
                       and n.note_type = nt.SID
                       and nt.usage = 'NOTELIST'
                       and nt.code = 'PD'
                  order by n.create_on)
        loop
            osi_util.aitc(v_program_data,
                          osi_report.replace_special_chars_clob(a.note_text, 'RTF') || ' ');
        end loop;

        if (   v_program_data is null
            or v_program_data = '') then
            v_ok := core_template.replace_tag(v_template, 'PROGRAM_LABEL', '', 'TOKEN@', true);
            v_ok := core_template.replace_tag(v_template, 'PROGRAM', '');
        else
            v_ok := core_template.replace_tag(v_template, 'PROGRAM_LABEL', 'Program Information');
            v_ok :=
                core_template.replace_tag(v_template,
                                          'PROGRAM_LABEL',
                                          osi_rtf.page_break || ' Program Information');
            v_ok := core_template.replace_tag(v_template, 'PROGRAM', v_program_data);
        end if;

        --- Lead Agent ---
        log_error('get lead agent');

        for a in (select a.personnel, cp.first_name || ' ' || last_name as personnel_name,
                         osi_unit.get_name(a.unit) as unit_name
                    from t_osi_assignment a, t_core_personnel cp, t_osi_assignment_role_type art
                   where a.obj = v_obj_sid
                     and a.personnel = cp.SID
                     and a.assign_role = art.SID
                     and art.description = 'Lead Agent')
        loop
            select first_name || ' '
                   || decode(length(middle_name),
                             1, middle_name || '. ',
                             0, ' ',
                             null, ' ',
                             substr(middle_name, 1, 1) || '. ')
                   || last_name || ', SA, '
                   || decode(op.pay_category, '03', 'DAF', '04', 'DAF', 'USAF')
              into v_leadagent
              from t_core_personnel cp, t_osi_personnel op
             where cp.SID = a.personnel and cp.SID = op.SID;

            v_ok :=
                core_template.replace_tag(v_template,
                                          'LEAD_AGENT',
                                          osi_report.replace_special_chars(v_leadagent, 'RTF')
                                          || ' \par ' || a.unit_name,
                                          'TOKEN@',
                                          false);
            exit;
        end loop;

        --- Report By ---
        begin
            select unit_name,
                   osi_address.get_addr_display(osi_address.get_address_sid(ua.unit), null, ' ')
                                                                                         as address
              into v_unit_name,
                   v_unit_address
              from t_osi_personnel_unit_assign ua, t_osi_unit_name un
             where ua.unit = un.unit
               and ua.unit = osi_personnel.get_current_unit(core_context.personnel_sid)
               and ua.personnel = core_context.personnel_sid
               and un.end_date is null;
        /*select display_string_line
          into v_unit_address
          from v_address_v2
         where parent = context_pkg.unit_sid;  */
        exception
            when no_data_found then
                v_unit_address := '<unknown>';
            when others then
                log_error('Form_40_ROI - Error -->' || sqlerrm || ' '
                          || dbms_utility.format_error_backtrace);
        end;

        --- Try to get a Phone Number ---
        v_phone_number := getpersonnelphone(core_context.personnel_sid);
        log_error('I2MS' || ', ' || 'REPORT OUTPUT_1: REPORT_BY '
                  || osi_report.replace_special_chars(core_context.personnel_name, 'RTF'));
        v_ok :=
            core_template.replace_tag
                                  (v_template,
                                   'REPORT_BY',
                                   osi_report.replace_special_chars(core_context.personnel_name,
                                                                    'RTF')
                                   || ', ' || osi_report.replace_special_chars(v_unit_name, 'RTF')
                                   || ', ' || v_unit_address || ' ' || v_phone_number,
                                   'TOKEN@',
                                   false);
        --- Last Status ---
        v_ok :=
            core_template.replace_tag(v_template,
                                      'STATUS',
                                      osi_object.get_status(v_obj_sid),
                                      'TOKEN@',
                                      false);
        v_ok := core_template.replace_tag(v_template, 'SUBJECT_LIST', get_subject_list);
        v_subject_count := 1;

----------------------------------------------------
----------------------------------------------------
--- Get Defandants Table of Contents and Details ---
----------------------------------------------------
----------------------------------------------------
        for b in (select pv.participant, pi.participant_version, obj_type_desc, dob as birth_date,
                         pv.ssn, pv.co_cage, co_duns, osi_participant.get_name(pv.SID) as name,
                         pv.current_address_desc as curr_addr_line
                    from v_osi_participant_version pv,
                         t_osi_partic_involvement pi,
                         t_osi_partic_role_type prt
                   where pi.obj = v_obj_sid
                     and pv.SID = pi.participant_version
                     and pi.involvement_role = prt.SID
                     and prt.role = 'Subject')
        loop
            if v_subject_count > 1 then
                v_defendants := v_defendants || ' \par \par ';
                v_defendants_pages := v_defendants_pages || ' \par \par ';
            end if;

            if b.obj_type_desc = 'Individual' then
                --- Birth Date and Place of Birth ---
                v_birth_label := 'Date/POB:';
                v_birth_information :=
                    to_char(b.birth_date, v_date_fmt) || '/'
                    || osi_address.get_addr_display(osi_address.get_address_sid(b.participant),
                                                    null,
                                                    ' ');
                --- Social Security Number ---
                v_ssn_label := 'SSN: \tab  ';
                v_ssn_information := b.ssn;
                --- Get the Participants Marital Status ---
                v_marital_label := 'Marital Status:';
                v_marital_information := null;
                
                v_spouse_sid := null;
                for s in (select related_to from v_osi_partic_relation where this_participant = b.participant and description = 'is Spouse of' and end_date is null order by start_date)
                loop
                    v_spouse_sid := s.related_to;
                    exit;
                    
                end loop;

                if v_spouse_sid is not null then
                    begin
                        select p.dod, first_name || ' ' || last_name as name
                          into v_spouse_deceased, v_spouse_name
                          from t_osi_participant p,
                               t_osi_partic_name pn,
                               t_osi_participant_version pv
                         where p.SID = v_spouse_sid
                           and p.current_version = pv.SID
                           and pn.participant_version = pv.SID;

                        v_marital_information := 'Married to ' || v_spouse_name;

                        if v_spouse_deceased is not null then
                            v_marital_information := 'Widowed by ' || v_spouse_name;
                        end if;
                    exception
                        when no_data_found then
                            v_marital_information := 'Single';
                    end;
                end if;
            else
                --- These values are only if the Participant is NOT an Individual ---

                --- Management ---
                v_birth_label := 'Management:';
                v_birth_information := '';
                log_error('>>>Check for Management->b.PARTICIPANT_VERSION=' || b.participant_version
                          || ',b.PARTICPANT=' || b.participant);

                for m in (select osi_participant.get_name(pr.partic_b) as related_name,
                                 pr.mod1_value
                            from t_osi_partic_relation pr, t_osi_partic_relation_type rt
                           where pr.rel_type = rt.SID
                             and pr.partic_a = b.participant
                             and rt.description = 'is Management')
                loop
                    if length(v_birth_information) > 0 then
                        v_birth_information := v_birth_information || ' \par\par \tab\tab   ';
                    end if;

                    v_birth_information :=
                                       v_birth_information || m.related_name || ', ' || m.mod1_value;
                end loop;

                --- Vendor Code (I used Cage Code, hope it is the same) ---
                v_ssn_label := 'Vendor Code:';
                v_ssn_information := b.co_cage;
                --- DUNS Number ---
                v_marital_label := 'DUNS Number:';
                v_marital_information := b.co_duns;
                --- Try to get a Phone Number ---
                v_phone_number := osi_participant.get_contact_value(b.participant_version, 'HOMEP');
            end if;

            --- Defendants Table Of Contents Entry ---
            v_defendants := v_defendants || osi_report.replace_special_chars(b.name, 'RTF');
            v_defendants_pages :=
                                v_defendants_pages || 'B-' || ltrim(rtrim(to_char(v_subject_count)));
            --- List the Defendants Each on a Seperate Page ---
            v_defendants_details := v_defendants_details || '{\b Defendant \b \par\par }';
            v_defendants_details :=
                            v_defendants_details || '{Name: \tab \tab   ' || b.name || ' \par\par }';

            if b.obj_type_desc != 'Individual' then
                v_defendants_details :=
                    v_defendants_details || '{Address: \tab   ' || b.curr_addr_line
                    || ' \par\par }';
                v_defendants_details :=
                    v_defendants_details || '{Phone: \tab \tab   ' || v_phone_number
                    || ' \par\par }';
            end if;

            v_defendants_details :=
                v_defendants_details || '{' || v_birth_label || ' \tab   ' || v_birth_information
                || ' \par\par}';
            v_defendants_details :=
                v_defendants_details || '{' || v_ssn_label || ' \tab   ' || v_ssn_information
                || ' \par\par }';

            if b.obj_type_desc != 'Individual' then
                v_defendants_details :=
                    v_defendants_details || '{' || v_marital_label || '  ' || v_marital_information
                    || ' \par\par }';
            end if;

            v_status_notes := 'Status Note:  ';

            for n in (select n.note_text
                        from t_osi_note n, t_osi_note_type nt
                       where n.obj = b.participant
                         and n.note_type = nt.SID
                         and nt.description = 'Status of Defendant')
            loop
                v_status_notes :=
                    v_status_notes || osi_report.replace_special_chars_clob(n.note_text, 'RTF')
                    || ' \par\par ';
            end loop;

            if v_status_notes != 'Status Note:  ' then
                v_defendants_details := v_defendants_details || v_status_notes;
            end if;

            --- Page Number ---
            v_defendants_details :=
                v_defendants_details || '{ \pard\pvmrg\posyb\phmrg\posxc B-'
                || rtrim(ltrim(to_char(v_subject_count))) || '\par\page }';
            v_subject_count := v_subject_count + 1;
        end loop;

        --- Defendants Table Of Contents Replacement ---
        v_ok := core_template.replace_tag(v_template, 'DEFENDANTS', v_defendants);
        v_ok := core_template.replace_tag(v_template, 'DEFENDANTS_PAGES', v_defendants_pages);
        --- Defendants Detailed Listing ---
        v_ok := core_template.replace_tag(v_template, 'DEFENDANT_DETAILS', v_defendants_details);
--------------------------
--------------------------
--- Witness Interviews ---
--------------------------
--------------------------
        v_defendants := null;                                              --- Reusing Variables ---
        v_defendants_pages := null;
        v_defendants_details := null;
        v_subject_count := 1;
        v_exhibit_counter := 1;
        v_evidence_counter := 1;
        v_evidence_list := null;

        for b in (select fa.activity_sid, a.narrative
                    from t_osi_activity a, t_osi_assoc_fle_act fa, t_core_obj o,
                         t_core_obj_type cot
                   where fa.file_sid = v_obj_sid
                     and a.SID = fa.activity_sid
                     and a.SID = o.SID
                     and o.obj_type = cot.SID
                     and cot.description = 'Interview, Witness')
        loop
            if v_subject_count > 1 then
                v_defendants := v_defendants || ' \par \par ';
                v_defendants_pages := v_defendants_pages || ' \par \par ';
            end if;

            begin
                select osi_participant.get_name(pv.SID) as name,
                       pv.current_address_desc as curr_addr_line, pi.participant_version
                  into v_subject_of_activity,
                       v_curr_address, v_sid
                  from v_osi_participant_version pv,
                       t_osi_partic_involvement pi,
                       t_osi_partic_role_type prt
                 where pi.obj = b.activity_sid
                   and pv.SID = pi.participant_version
                   and pi.involvement_role = prt.SID
                   and prt.role = 'Subject of Activity';
            exception
                when no_data_found then
                    v_subject_of_activity := '<Unknown>';
                    v_curr_address := null;
                    v_sid := null;
            end;

            v_defendants :=
                      v_defendants || osi_report.replace_special_chars(v_subject_of_activity, 'RTF');
            v_defendants_pages :=
                                v_defendants_pages || 'C-' || ltrim(rtrim(to_char(v_subject_count)));
            --- List the Witnesses Each on a Seperate Page ---
            v_defendants_details := v_defendants_details || '{\b Witness \b \par\par }';
            v_defendants_details :=
                v_defendants_details || '{'
                || osi_report.replace_special_chars(v_subject_of_activity, 'RTF') || ' \par\par }';
            v_defendants_details :=
                v_defendants_details || '{'
                || osi_report.replace_special_chars(v_curr_address, 'RTF') || ' \par\par }';
            --- Try to get a Phone Number ---
            v_phone_number := getparticipantphone(v_sid);
            v_defendants_details :=
                v_defendants_details || '{'
                || osi_report.replace_special_chars(v_phone_number, 'RTF') || ' \par\par }';
            v_defendants_details :=
                v_defendants_details || '{'
                || osi_report.replace_special_chars_clob(b.narrative, 'RTF') || ' \par\par}';

            --- Exhibits ---
            for e in (select description
                        from t_osi_attachment
                       where obj = b.activity_sid)
            loop
                if v_exhibit_counter > 1 then
                    v_exhibit_information := v_exhibit_information || ' \par \par ';
                    v_exhibits_pages := v_exhibits_pages || ' \par \par ';
                end if;

                v_exhibit_information :=
                    v_exhibit_information
                    || osi_report.replace_special_chars_clob(e.description, 'RTF');
                v_exhibits_pages :=
                                v_exhibits_pages || 'F-' || ltrim(rtrim(to_char(v_exhibit_counter)));
                v_defendants_details :=
                    v_defendants_details || 'Exhibit ' || 'F-'
                    || ltrim(rtrim(to_char(v_exhibit_counter))) || ':  '
                    || osi_report.replace_special_chars_clob(e.description, 'RTF') || ' \par \par ';
                v_exhibit_counter := v_exhibit_counter + 1;
            end loop;

            --- Page Number ---
            v_defendants_details :=
                v_defendants_details || '{ \pard\pvmrg\posyb\phmrg\posxc C-'
                || rtrim(ltrim(to_char(v_subject_count))) || '\par\page }';
            v_subject_count := v_subject_count + 1;

            --- Evidence Listing ---
            for e in (select description
                        from t_osi_evidence
                       where obj = b.activity_sid)
            loop
                if v_evidence_counter > 1 then
                    v_evidence_list := v_evidence_list || ' \par \par ';
                end if;

                v_evidence_list :=
                    v_evidence_list || ltrim(rtrim(to_char(v_evidence_counter))) || '.  '
                    || osi_report.replace_special_chars_clob(e.description, 'RTF');
                v_evidence_counter := v_evidence_counter + 1;
            end loop;
        end loop;

        v_evidence_list := v_evidence_list || '\par { \pard\pvmrg\posyb\phmrg\posxc D-1 \par\page }';
        --- Witness Interviews Table Of Contents Replacement ---
        v_ok := core_template.replace_tag(v_template, 'WITNESS_INTERVIEWS', v_defendants);
        v_ok :=
               core_template.replace_tag(v_template, 'WITNESS_INTERVIEWS_PAGES', v_defendants_pages);
        --- Defendants Detailed Listing ---
        v_ok :=
            core_template.replace_tag(v_template, 'WITNESS_INTERVIEWS_DETAILS',
                                      v_defendants_details);
        --- Exhibits Table Of Contents Replacement ---
        v_ok := core_template.replace_tag(v_template, 'EXHIBITS', v_exhibit_information);
        v_ok := core_template.replace_tag(v_template, 'EXHIBITS_PAGES', v_exhibits_pages);
        --- Evidence Listing ---
        v_ok := core_template.replace_tag(v_template, 'EVIDENCE_LISTING', v_evidence_list);
        --- Other Activities ---
        v_other_activities_counter := 0;

        for b in (select   cot.description as type, narrative, title
                      from t_osi_assoc_fle_act fa,
                           t_osi_activity a,
                           t_core_obj co,
                           t_core_obj_type cot
                     where fa.file_sid = v_obj_sid
                       and fa.activity_sid = a.SID
                       and a.SID = co.SID
                       and co.obj_type = cot.SID
                  order by a.activity_date)
        loop
            if b.type = 'Interview, Witness' then
                --- Skip the Witness Interviews ---
                v_ok := null;
            else
                v_other_activities_counter := v_other_activities_counter + 1;

                if    b.narrative is null
                   or b.narrative = '' then
                    v_other_activities :=
                        v_other_activities || '{'
                        || rtrim(ltrim(to_char(v_other_activities_counter))) || '.  '
                        || osi_report.replace_special_chars_clob(b.title, 'RTF') || ' \par\par}';
                else
                    v_other_activities :=
                        v_other_activities || '{'
                        || rtrim(ltrim(to_char(v_other_activities_counter))) || '.  '
                        || osi_report.replace_special_chars_clob(b.narrative, 'RTF')
                        || ' \par\par}';
                end if;
            end if;
        end loop;

        v_ok :=
            core_template.replace_tag(v_template,
                                      'OTHER_ACTIVITIES',
                                      v_other_activities
                                      || '\par { \pard\pvmrg\posyb\phmrg\posxc E-1 \par }');
        log_error('Form_40_ROI - End ' || sysdate());
        return v_template;
    exception
        when others then
            log_error('Form_40_ROI - Error -->' || sqlerrm || ' '
                      || dbms_utility.format_error_backtrace);
            return v_template;
    end form_40_roi;

    /* Generic File report functions, included in this package because of common support functions and private variables */
    function genericfile_report(p_obj in varchar2)
        return clob is
        v_ok                varchar2(2);
        v_htlmorrtf         varchar2(4)                             := 'RTF';
        v_temp_template     clob;
        v_template          clob;
        v_template_date     date;
        v_mime_type         t_core_template.mime_type%type;
        v_mime_disp         t_core_template.mime_disposition%type;
        v_class_def         varchar2(500);
        v_class             varchar2(500);
        v_summary           clob                                    := null;
        v_full_id           varchar2(100)                           := null;
        v_report_period     varchar2(25)                            := null;
        v_description       varchar2(4000)                          := null;
        v_attachment_list   varchar2(30000)                         := null;
        v_parent_sid        varchar2(20);
    begin
        v_parent_sid := p_obj;

        begin
            select rs.SID
              into v_spec_sid                                                     --package variable
              from t_osi_report_spec rs, t_osi_report_type rt
             where rs.obj = p_obj and rs.report_type = rt.SID and rt.description = 'Report';
        exception
            when others then
                log_error('genericfile_report: ' || sqlerrm);
                v_template := 'Error: Report Specification not found.';
                return v_template;
        end;

        /* Grab template and assign to v_template  */
        v_ok :=
            core_template.get_latest('GENERIC_REPORT',
                                     v_temp_template,
                                     v_template_date,
                                     v_mime_type,
                                     v_mime_disp);

        /* ----------------- Cover Page ------------------ */

        --- Get default classification from t_core_config
        begin
            select description
              into v_class_def
              from t_core_classification_level
             where code = core_util.get_config('OSI.DEFAULT_CLASS');
        exception
            when no_data_found then
                v_class_def := core_util.get_config('OSI.DEFAULT_CLASS');
        end;

        for a in (select obj, osi_reference.lookup_ref_desc(classification) as classification
                    from t_osi_report_spec
                   where SID = v_spec_sid)
        loop
            v_ok :=
                core_template.replace_tag
                                    (v_temp_template,
                                     'REPORT_BY',
                                     osi_report.replace_special_chars(core_context.personnel_name,
                                                                      v_htlmorrtf));
            v_ok :=
                core_template.replace_tag
                    (v_temp_template,
                     'RPT_DATE',
                     osi_report.replace_special_chars
                                                (to_char(sysdate,
                                                         core_util.get_config('CORE.DATE_FMT_DAY')),
                                                 v_htlmorrtf));

            if a.classification is not null then
                --replace both header and footer tokens
                v_ok :=
                    core_template.replace_tag(v_temp_template,
                                              'CLASSIFICATION',
                                              osi_report.replace_special_chars(a.classification,
                                                                               v_htlmorrtf));
                v_ok :=
                    core_template.replace_tag(v_temp_template,
                                              'CLASSIFICATION',
                                              osi_report.replace_special_chars(a.classification,
                                                                               v_htlmorrtf));
            end if;
        end loop;

        --default classification not required in I2MS, so set to ' ' if no class exists
        --v_class := nvl(core_classification_v2.full_marking(p_obj), v_class_def);
        v_class := core_classification_v2.full_marking(p_obj);

        --replace both header and footer tokens, move on if token already filled
        begin
            v_ok := core_template.replace_tag(v_temp_template, 'CLASSIFICATION', v_class);
            v_ok := core_template.replace_tag(v_temp_template, 'CLASSIFICATION', v_class);
        exception
            when others then
                null;
        end;

        for b in (select description, full_id,
                         to_char(start_date,
                                 core_util.get_config('CORE.DATE_FMT_DAY'))
                         || ' - ' || to_char(end_date, core_util.get_config('CORE.DATE_FMT_DAY'))
                                                                                    as reportperiod
                    from v_osi_rpt_gen1
                   where SID = v_parent_sid)
        loop
            v_full_id := b.full_id;
            v_report_period := b.reportperiod;
            v_description := b.description;
        end loop;

        v_ok :=
            core_template.replace_tag(v_temp_template,
                                      'DESCRIPTION',
                                      osi_report.replace_special_chars(v_description, v_htlmorrtf));
        v_ok :=
            core_template.replace_tag(v_temp_template,
                                      'REPORT_PERIOD',
                                      osi_report.replace_special_chars(v_report_period, v_htlmorrtf));
        v_ok :=
            core_template.replace_tag(v_temp_template,
                                      'FILE_NO',
                                      osi_report.replace_special_chars(v_full_id, v_htlmorrtf));

        -- multiple instances
        for c in (select summary_text
                    from t_osi_f_gen1_summary
                   where active = 'Y'
                     and file_sid = v_parent_sid
                     and summary_date = (select max(t_osi_f_gen1_summary.summary_date)
                                           from t_osi_f_gen1_summary
                                          where active = 'Y' and file_sid = v_parent_sid))
        loop
            v_summary := c.summary_text;
        end loop;

        v_ok := core_template.replace_tag(v_temp_template, 'SUMMARY', v_summary);
        core_util.cleanup_temp_clob(v_summary);
        v_unit_sid := osi_file.get_unit_owner(v_parent_sid);
        v_ok :=
            core_template.replace_tag
                                   (v_temp_template,
                                    'UNIT_NAME',
                                    osi_report.replace_special_chars(osi_unit.get_name(v_unit_sid),
                                                                     v_htlmorrtf));
        v_ok := core_template.replace_tag(v_temp_template, 'UNIT_CDR', get_owning_unit_cdr);
        v_ok := core_template.replace_tag(v_temp_template, 'CAVEAT_LIST', get_caveats_list);
        v_attachment_list := get_attachment_list(v_parent_sid);
        v_ok := core_template.replace_tag(v_temp_template, 'ATTACHMENTS_LIST', v_attachment_list);
        get_objectives_list(v_parent_sid);
        v_ok := core_template.replace_tag(v_temp_template, 'OBJECTIVE_LIST', v_act_narr_list);
        core_util.cleanup_temp_clob(v_act_narr_list);
        v_ok := core_template.replace_tag(v_temp_template, 'OBJECTIVE_TOC', v_narr_toc_list);
        core_util.cleanup_temp_clob(v_narr_toc_list);
        get_idp_notes(v_spec_sid);
        v_ok := core_template.replace_tag(v_temp_template, 'IDP_LIST', v_idp_list);
        core_util.cleanup_temp_clob(v_idp_list);

        osi_report.load_participants(p_obj);
        osi_report.load_agents_assigned(p_obj);
        
        v_act_narr_list := null;
        v_act_toc_list := null;
        get_sel_activity(v_spec_sid);
        v_ok := core_template.replace_tag(v_temp_template, 'ACTIVITY_TOC', v_act_toc_list);
        v_ok := core_template.replace_tag(v_temp_template, 'ACTIVITY_LIST', v_act_narr_list);
        core_util.cleanup_temp_clob(v_act_toc_list);
        core_util.cleanup_temp_clob(v_act_narr_list);
        v_template := v_template || v_temp_template;
        return v_template;
    exception
        when others then
            log_error('genericfile_report: ' || sqlerrm || ' '
                      || dbms_utility.format_error_backtrace);
            return null;
    end genericfile_report;

    function get_attachment_list(p_obj in varchar2)
        return varchar2 is
        v_tmp_attachments   varchar2(30000) := null;
        v_cnt               number          := 0;
    begin
        for a in (select   description
                      from v_osi_attachments
                     where obj = p_obj
                  order by description)
        loop
            v_cnt := v_cnt + 1;

            if a.description is not null then
                if v_cnt = 1 then
                    v_tmp_attachments := v_tmp_attachments || 'Attachments\line ';
                end if;

                v_tmp_attachments := v_tmp_attachments || ' - ' || a.description || '\line ';
            else
                return null;
            end if;
        end loop;

        return v_tmp_attachments;
    exception
        when others then
            log_error('get_attachment_list: ' || sqlerrm);
            return null;
    end get_attachment_list;

    procedure get_objectives_list(p_obj in varchar2) is
        v_objective   varchar2(500)  := null;
        v_comments    varchar2(4000) := null;
        v_cnt         number         := 0;
    begin
        for a in (select   *
                      from t_osi_f_gen1_objective o
                     where o.file_sid = p_obj and o.objective_met <> 'U'
                  order by objective)
        loop
            v_cnt := v_cnt + 1;                                           -- paragraph counter   --
            v_objective := v_cnt || '\tab\b ' || a.objective || '\b0\par\par ';
            core_util.append_info_to_clob(v_act_narr_list, v_objective, null);

            if v_cnt = 1 then
                core_util.append_info_to_clob(v_narr_toc_list,
                                              a.objective || '\tab ' || v_cnt,
                                              null);
            else
                core_util.append_info_to_clob(v_narr_toc_list,
                                              '\par\par ' || a.objective || '\tab ' || v_cnt,
                                              null);
            end if;

            v_comments := c_blockpara || 'Objective Comment: \tab ' || a.comments || '\par\par ';
            core_util.append_info_to_clob(v_act_narr_list, v_comments, null);

            -- Determine if the objective was met --
            if a.objective_met = 'N' then
                core_util.append_info_to_clob(v_act_narr_list,
                                              'Objective Met? \tab No\par\par ',
                                              null);
            else
                core_util.append_info_to_clob(v_act_narr_list,
                                              'Objective Met? \tab Yes\par\par ',
                                              null);
            end if;

            core_util.append_info_to_clob(v_act_narr_list,
                                          c_blockpara || '\b Supporting Activities:\b0\par\par ',
                                          null);

            for act in (select   a2.narrative as narrative
                            from t_osi_f_gen1_objective_act oa, t_osi_activity a2
                           where oa.objective = a.SID and oa.activity = a2.SID
                        order by oa.objective)
            loop
                if act.narrative is null then
                    core_util.append_info_to_clob(v_act_narr_list, '<None>\par\par', null);
                else
                    core_util.append_info_to_clob(v_act_narr_list,
                                                  core_util.clob_replace(act.narrative,
                                                                         v_newline,
                                                                         c_hdr_linebreak)
                                                  || '\par\par ',
                                                  null);
                end if;
            end loop;

            core_util.append_info_to_clob(v_act_narr_list,
                                          c_blockpara || '\b Supporting Files:\b0\par\par ',
                                          null);

            for fle in (select   f.file_sid as that_file
                            from t_osi_f_gen1_objective_file f
                           where f.objective = a.SID
                        order by f.objective)
            loop
                core_util.append_info_to_clob
                                            (v_act_narr_list,
                                             core_util.clob_replace(get_summary(fle.that_file),
                                                                    v_newline,
                                                                    c_hdr_linebreak)
                                             || '\par\par ',
                                             null);
            end loop;
        end loop;
    exception
        when others then
            log_error('get_objectives_list: ' || sqlerrm);
    end get_objectives_list;

    function escape_the_html(v_clob in clob)
        return clob is
        
        l_outlob        clob;
        l_limit         NUMBER := 10000;
        v_text_amt      BINARY_INTEGER := l_limit;
        v_text_buffer   varchar2(32767);
        v_text_pos      NUMBER := 1;

    begin

         --- Create a tempory LOB to place our html in ---
         --dbms_lob.CREATETEMPORARY(lob_loc => v_clob , cache   => false  , dur     => dbms_lob.session);
  
         --- Now to loop through the CLOB in 10k intervals               ---
         --- so we can htf.escape_sc the string of data back on the page ---
         LOOP
             v_text_buffer := DBMS_LOB.SUBSTR(v_clob, v_text_amt, v_text_pos);
             EXIT WHEN v_text_buffer IS NULL;

             --- process the text and prepare to read again ---
             osi_util.aitc(l_outlob,  htf.escape_sc(v_text_buffer));
             v_text_pos := v_text_pos + v_text_amt;

         END LOOP;
 
         --- Kill the temporary LOB ---   
         --DBMS_LOB.FREETEMPORARY(lob_loc => l_narrative);
         return l_outlob;
         
    end escape_the_html;
    
    function activity_narrative_preview(psid in varchar2, htmlorrtf in varchar2 := 'HTML')
        return clob is
        v_group        clob         := null;
        v_header       clob         := null;
        v_narrative    clob         := null;
        v_exhibits     clob         := null;
        v_preview      clob         := null;
        v_parent_sid   varchar2(20);
        pparentsid     varchar2(20);
        pobjective     varchar2(20);
    begin
        load_activity(psid);

        begin
            select file_sid
              into v_parent_sid
              from t_osi_assoc_fle_act c
             where c.activity_sid = psid;
        exception
            when others then
                v_parent_sid := psid;
        end;

        osi_report.load_Participants(v_parent_sid);
        osi_report.load_agents_assigned(v_parent_sid);

        select roi_group(psid), roi_header(psid) as header, roi_narrative(psid) as narrative
          into v_group, v_header, v_narrative
          from dual;

        if v_obj_type_code like 'ACT.AAPP%' then
            -- member of osi_object.get_objtypes('ACT.AAPP') THEN
            select a.obj, t.code
              into pparentsid, pobjective
              from t_osi_f_aapp_file_obj_act a,
                   t_osi_f_aapp_file_obj o,
                   t_osi_f_aapp_file_obj_type t
             where a.obj = psid and a.objective = o.SID and o.obj_type = t.SID;

            --- Narrative Group ---
            osi_util.aitc(v_preview,
                          '\b ' || v_group || '\b0\tab \tab '
                          || osi_aapp_file.rpt_generate_add_info_sections(v_parent_sid, pobjective));
            --- Narrative Header ---
            v_preview :=
                v_preview || '\line '
                || osi_aapp_file.rpt_generate_generic_act_sect(v_parent_sid, pobjective);
        else
            --- Narrative Group ---
            osi_util.aitc(v_preview, '\b ' || v_group || '\b0');
            --- Narrative Header ---
            osi_util.aitc(v_preview,
                          '\par\par 2-##\tab\fi-720\li720 '
                          || replace(v_header, v_newline, c_hdr_linebreak || '\tab '));
            --- Exhibits ---
            v_exhibits := get_act_exhibit(psid);
            osi_util.aitc(v_preview, v_exhibits);

            if v_exhibits is not null then

              if htmlorrtf='HTML' then

                osi_util.aitc(v_preview, '\line ' || escape_the_html(v_exhibits));

              else

                osi_util.aitc(v_preview, '\line ' || v_exhibits);

              end if;
              
            end if;

            --- Narrative Text ---
            if v_narrative is not null then

              if htmlorrtf='HTML' then

                dbms_lob.append(v_preview, '\par \ql\fi0\li0\line ' || escape_the_html(v_narrative));

              else

                dbms_lob.append(v_preview, '\par \ql\fi0\li0\line ' || v_narrative);

              end if;
              
            end if;
        end if;

        if htmlorrtf = 'RTF' then
            v_preview := '{\rtf1' || v_preview || '}';
        else
            --- Replace Bolded Character Sequences ---
            v_preview := replace(v_preview, '\b0', '</b>');
            v_preview := replace(v_preview, '\b', '<b>');
            v_preview :=
                replace
                    (v_preview,
                     '\ql\fi-720\li720\ \line \tab ',
                     '<br>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;');
            --- Replace Tabs with Spaces ---
            v_preview :=
                      replace(v_preview, '\tab', '&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;');
            --- Replace \ql = Left-aligned, \fi = First Line Indent, and \li - Left Indent ---
            v_preview := replace(v_preview, '\fi-720\li720 ', '');
            v_preview := replace(v_preview, '\ql\fi0\li0 ', '');
            v_preview := replace(v_preview, '\fi-720\li720', '');
            v_preview := replace(v_preview, '\ql\fi0\li0', '');
            --- Replace \line and \par line breaks ---
            v_preview := replace(v_preview, '\line', '<br>');
            v_preview := replace(v_preview, '\par', '<br>');
            --- Add Font and Replace any final Line Breaks ---
            v_preview :=
                '<HTML><FONT FACE="Times New Roman">' || replace(v_preview, '\par ', '<br>')
                || '</FONT></HTML>';
        end if;

        return v_preview;
    end activity_narrative_preview;

procedure auto_load_specs(p_obj in varchar2, p_list out varchar2, p_send_first_back varchar2 := 'N') is

         v_list varchar2(2000);
         v_offense varchar2(20);
         v_incident varchar2(20);
         v_subject varchar2(20);
         v_victim varchar2(20);
         v_offense_code varchar2(10);
         v_msg varchar2(4000);
         v_complete varchar2(4000);
         v_nibrs varchar2(10);
         v_count number;

begin
     for a in(  select im.incident || '~' || io.offense || '~' || pi.participant_version || '~' || pi2.participant_version as ALL_COMBOS
        from t_osi_f_inv_incident_map im,
             t_osi_f_inv_offense io,
             t_osi_partic_involvement pi,
             t_osi_partic_role_type prt,
             t_osi_partic_involvement pi2,
             t_osi_partic_role_type prt2
       where im.investigation = p_obj
         and io.investigation = p_obj
         and pi.obj = p_obj
         and pi.involvement_role = prt.SID
         and prt.role = 'Subject'
         and pi2.obj = p_obj  
         and pi2.involvement_role = prt2.SID
         and prt2.role = 'Victim'
         and im.incident || '~' || io.offense || '~' || pi.participant_version || '~'
             || pi2.participant_version not in (select incident
             || '~' || offense
             || '~' || subject 
             || '~' || victim as EXISTING_SPECS
        from t_osi_f_inv_spec 
       where investigation = p_obj))
     loop
         v_list := '~'|| a.all_combos || '~';
      
         v_incident := core_list.POP_LIST_ITEM(v_list);
         v_offense := core_list.POP_LIST_ITEM(v_list);
         v_subject :=core_list.POP_LIST_ITEM(v_list);
         v_victim  := core_list.POP_LIST_ITEM(v_list);
           
         --- Make sure it is a valid Offense Combination ---
         begin
              select nibrs_code, code into v_nibrs, v_offense_code from t_dibrs_offense_type where sid=v_offense;
              osi_checklist.check_offense_combos(p_obj, v_nibrs, v_incident, v_victim, v_offense_code, v_complete, v_msg, v_count);

         exception when others then

                  v_msg:='';
                  v_count:=0;

         end;

         if v_count=0 then
           
           if p_send_first_back = 'N' then

             insert into t_osi_f_inv_spec (investigation, incident, offense, subject, victim) values (p_obj, v_incident, v_offense, v_subject, v_victim);
           
           else
         
             p_list := '~'|| a.all_combos || '~'; 
             return;
           
           end if;

         end if;
         
     end loop; 

exception when others then
         
         log_error('Error in auto_load_specs-' || SQLERRM);
         
end auto_load_specs;

function roi_get_offense_table(psid in varchar2) return clob is

     v_offense_header clob;
     v_offense_desc_prefix varchar2(100);

begin
     ---------------------------------------------------------------------------------------------------------------------------------
     ---- MAKE SURE that clcbpat## doesn't change from \red160\green160\blue160;  this corresponds to the ## entry in \colortbl; -----
     ---------------------------------------------------------------------------------------------------------------------------------

     ---------------------------
     --- Build Offense Table ---
     ---------------------------
     v_offense_header := '}\trowd \irow0\irowband0\ts18\trgaph108\trleft-108\trbrdrt\brdrs\brdrw10 \trbrdrl\brdrs\brdrw10 \trbrdrb\brdrs\brdrw10 \trbrdrr\brdrs\brdrw10 \trbrdrh\brdrs\brdrw10 \trbrdrv\brdrs\brdrw10';
     v_offense_header := v_offense_header || '\trftsWidth1\trftsWidthB3\trftsWidthA3\trautofit1\trpaddl108\trpaddr108\trpaddfl3\trpaddft3\trpaddfb3\trpaddfr3\tblrsid11671572\tbllkhdrrows\tbllklastrow\tbllkhdrcols\tbllklastcol \clvertalc\clbrdrt\brdrs\brdrw10 \clbrdrl\brdrs\brdrw10 \clbrdrb';
     v_offense_header := v_offense_header || '\brdrs\brdrw10 \clbrdrr\brdrs\brdrw10 \clcbpat18\cltxlrtb\clftsWidth1\clcbpatraw18 \cellx4536\pard\plain \qc \li0\ri0\widctlpar\intbl\tx5040\aspalpha\aspnum\faauto\adjustright\rin0\lin0\pararsid3480925\yts18';
     v_offense_header := v_offense_header || '\fs22\lang1033\langfe1033\cgrid\langnp1033\langfenp1033 {\b\insrsid3480925 MATTERS INVESTIGATED}{\insrsid3480925 \cell }\pard\plain \ql \li0\ri0\widctlpar\intbl\aspalpha\aspnum\faauto\adjustright\rin0\lin0';
     v_offense_header := v_offense_header || '\fs22\lang1033\langfe1033\cgrid\langnp1033\langfenp1033 {\insrsid3480925 \trowd \irow0\irowband0\ts18\trgaph108\trleft-108\trbrdrt\brdrs\brdrw10 \trbrdrl\brdrs\brdrw10 \trbrdrb\brdrs\brdrw10 \trbrdrr\brdrs\brdrw10 \trbrdrh\brdrs\brdrw10 \trbrdrv';
     v_offense_header := v_offense_header || '\brdrs\brdrw10 \trftsWidth1\trftsWidthB3\trftsWidthA3\trautofit1\trpaddl108\trpaddr108\trpaddfl3\trpaddft3\trpaddfb3\trpaddfr3\tblrsid11671572\tbllkhdrrows\tbllklastrow\tbllkhdrcols\tbllklastcol \clvertalc\clbrdrt\brdrs\brdrw10 \clbrdrl\brdrs\brdrw10';
     v_offense_header := v_offense_header || '\clbrdrb\brdrs\brdrw10 \clbrdrr\brdrs\brdrw10 \clcbpat18\cltxlrtb\clftsWidth1\clcbpatraw18 \cellx4536\row }\trowd \irow1\irowband1\lastrow \ts18\trgaph108\trleft-108\trbrdrt\brdrs\brdrw10 \trbrdrl\brdrs\brdrw10 \trbrdrb\brdrs\brdrw10 \trbrdrr';
     v_offense_header := v_offense_header || '\brdrs\brdrw10 \trbrdrh\brdrs\brdrw10 \trbrdrv\brdrs\brdrw10 \trftsWidth1\trftsWidthB3\trftsWidthA3\trautofit1\trpaddl108\trpaddr108\trpaddfl3\trpaddft3\trpaddfb3\trpaddfr3\tblrsid11671572\tbllkhdrrows\tbllklastrow\tbllkhdrcols\tbllklastcol \clvertalt';
     v_offense_header := v_offense_header || '\clbrdrt\brdrs\brdrw10 \clbrdrl\brdrs\brdrw10 \clbrdrb\brdrs\brdrw10 \clbrdrr\brdrs\brdrw10 \cltxlrtb\clftsWidth1\clshdrawnil \cellx1000\clvertalt\clbrdrt\brdrs\brdrw10 \clbrdrl\brdrs\brdrw10 \clbrdrb\brdrs\brdrw10 \clbrdrr\brdrs\brdrw10';
     v_offense_header := v_offense_header || '\cltxlrtb\clftsWidth1\clshdrawnil \cellx2881\clvertalt\clbrdrt\brdrs\brdrw10 \clbrdrl\brdrs\brdrw10 \clbrdrb\brdrs\brdrw10 \clbrdrr\brdrs\brdrw10 \cltxlrtb\clftsWidth1\clshdrawnil \cellx3742\clvertalt\clbrdrt\brdrs\brdrw10 \clbrdrl\brdrs\brdrw10 \clbrdrb';
     v_offense_header := v_offense_header || '\brdrs\brdrw10 \clbrdrr\brdrs\brdrw10 \cltxlrtb\clftsWidth1\clshdrawnil \cellx4536\pard\plain \ql \li0\ri0\widctlpar\intbl\tx5040\aspalpha\aspnum\faauto\adjustright\rin0\lin0\pararsid11035800\yts18 \fs22\lang1033\langfe1033\cgrid\langnp1033\langfenp1033 {';
     v_offense_header := v_offense_header || '\b\insrsid3480925 INCIDENT}{\insrsid3480925 \cell }{\b\insrsid3480925 OFFENSE DESCRIPTION}{\insrsid3480925 \cell }{\b\insrsid3480925 SUBJECT}{\insrsid3480925 \cell }{\b\insrsid3480925 VICTIM}{\insrsid3480925 \cell }\pard\plain';
     v_offense_header := v_offense_header || '\ql \li0\ri0\widctlpar\intbl\aspalpha\aspnum\faauto\adjustright\rin0\lin0 \fs22\lang1033\langfe1033\cgrid\langnp1033\langfenp1033 {\insrsid3480925 \trowd \irow1\irowband1\lastrow \ts18\trgaph108\trleft-108\trbrdrt\brdrs\brdrw10 \trbrdrl\brdrs\brdrw10';
     v_offense_header := v_offense_header || '\trbrdrb\brdrs\brdrw10 \trbrdrr\brdrs\brdrw10 \trbrdrh\brdrs\brdrw10 \trbrdrv\brdrs\brdrw10';
     v_offense_header := v_offense_header || '\trftsWidth1\trftsWidthB3\trftsWidthA3\trautofit1\trpaddl108\trpaddr108\trpaddfl3\trpaddft3\trpaddfb3\trpaddfr3\tblrsid11671572\tbllkhdrrows\tbllklastrow\tbllkhdrcols\tbllklastcol \clvertalt\clbrdrt\brdrs\brdrw10 \clbrdrl\brdrs\brdrw10 \clbrdrb';
     v_offense_header := v_offense_header || '\brdrs\brdrw10 \clbrdrr\brdrs\brdrw10 \cltxlrtb\clftsWidth1\clshdrawnil \cellx970\clvertalt\clbrdrt\brdrs\brdrw10 \clbrdrl\brdrs\brdrw10 \clbrdrb\brdrs\brdrw10 \clbrdrr\brdrs\brdrw10 \cltxlrtb\clftsWidth1\clshdrawnil \cellx2881\clvertalt\clbrdrt';
     v_offense_header := v_offense_header || '\brdrs\brdrw10 \clbrdrl\brdrs\brdrw10 \clbrdrb\brdrs\brdrw10 \clbrdrr\brdrs\brdrw10 \cltxlrtb\clftsWidth1\clshdrawnil \cellx3742\clvertalt\clbrdrt\brdrs\brdrw10 \clbrdrl\brdrs\brdrw10 \clbrdrb\brdrs\brdrw10 \clbrdrr\brdrs\brdrw10';
     v_offense_header := v_offense_header || '\cltxlrtb\clftsWidth1\clshdrawnil \cellx4536\row }\pard \ql \fi-1440\li1440\ri0\widctlpar\tx5040\aspalpha\aspnum\faauto\adjustright\rin0\lin1440\itap0 {\insrsid11035800 ';
     v_offense_header := v_offense_header || '}\pard \ql \li0\ri0\widctlpar\aspalpha\aspnum\faauto\adjustright\rin0\lin0\itap0 {\b\insrsid16598193 ';

     for c in (select r1.code as off_result,r2.code as off_involvement,i.incident_id as incident,ot.description as offense_desc,
                      pn1.first_name || ' ' || decode(length(pn1.middle_name), 1, pn1.middle_name || '. ', 0, ' ', null, ' ', substr(pn1.middle_name, 1, 1) || '. ') || pn1.last_name as subject_name,
                      pn2.first_name || ' ' || decode(length(pn2.middle_name), 1, pn2.middle_name || '. ', 0, ' ', null, ' ', substr(pn2.middle_name, 1, 1) || '. ') || pn2.last_name as victim_name
                 from t_osi_f_inv_spec s,
                      t_dibrs_reference r1,
                      t_dibrs_reference r2,
                      t_osi_f_inv_incident i,
                      t_osi_participant_version pv1,
                      t_osi_participant_version pv2,
                      t_osi_partic_name pn1,
                      t_osi_partic_name pn2,
                      t_dibrs_offense_type ot
                where s.investigation = v_obj_sid
                  and s.off_result = r1.SID(+)
                  and s.off_involvement = r2.SID(+)
                  and s.incident = i.SID
                  and s.subject = pv1.SID
                  and s.victim = pv2.SID
                  and pv1.current_name = pn1.SID
                  and pv2.current_name = pn2.SID
                  and s.offense = ot.SID)
     loop
         v_offense_desc_prefix := null;

         if c.off_result = 'A' then

           v_offense_desc_prefix := v_offense_desc_prefix || 'Attempted - ';

         end if;
            
         case c.off_involvement

             when 'A' then
                          v_offense_desc_prefix := v_offense_desc_prefix || 'Accessory - ';

             when 'C' then
                          v_offense_desc_prefix := v_offense_desc_prefix || 'Conspiracy - ';

             when 'S' then
                          v_offense_desc_prefix := v_offense_desc_prefix || 'Solicit - ';

                      else
                          v_offense_desc_prefix := '';
                          
         end case;

         v_offense_header := v_offense_header || '\trowd \irow1\irowband1\lastrow \ts18\trgaph108\trleft-108\trbrdrt\brdrs\brdrw10 \trbrdrl\brdrs\brdrw10 \trbrdrb\brdrs\brdrw10 \trbrdrr';
         v_offense_header := v_offense_header || '\brdrs\brdrw10 \trbrdrh\brdrs\brdrw10 \trbrdrv\brdrs\brdrw10 \trftsWidth1\trftsWidthB3\trftsWidthA3\trautofit1\trpaddl108\trpaddr108\trpaddfl3\trpaddft3\trpaddfb3\trpaddfr3\tblrsid11671572\tbllkhdrrows\tbllklastrow\tbllkhdrcols\tbllklastcol \clvertalt';
         v_offense_header := v_offense_header || '\clbrdrt\brdrs\brdrw10 \clbrdrl\brdrs\brdrw10 \clbrdrb\brdrs\brdrw10 \clbrdrr\brdrs\brdrw10 \cltxlrtb\clftsWidth1\clshdrawnil \cellx970\clvertalt\clbrdrt\brdrs\brdrw10 \clbrdrl\brdrs\brdrw10 \clbrdrb\brdrs\brdrw10 \clbrdrr\brdrs\brdrw10';
         v_offense_header := v_offense_header || '\cltxlrtb\clftsWidth1\clshdrawnil \cellx2881\clvertalt\clbrdrt\brdrs\brdrw10 \clbrdrl\brdrs\brdrw10 \clbrdrb\brdrs\brdrw10 \clbrdrr\brdrs\brdrw10 \cltxlrtb\clftsWidth1\clshdrawnil \cellx3742\clvertalt\clbrdrt\brdrs\brdrw10 \clbrdrl\brdrs\brdrw10 \clbrdrb';
         v_offense_header := v_offense_header || '\brdrs\brdrw10 \clbrdrr\brdrs\brdrw10 \cltxlrtb\clftsWidth1\clshdrawnil \cellx4536\pard\plain \ql \li0\ri0\widctlpar\intbl\tx5040\aspalpha\aspnum\faauto\adjustright\rin0\lin0\pararsid11035800\yts18 \fs22\lang1033\langfe1033\cgrid\langnp1033\langfenp1033 {';
         v_offense_header := v_offense_header || '\insrsid3480925 ' || c.incident || '}{\insrsid3480925 \cell }{\insrsid3480925 ' || v_offense_desc_prefix || c.offense_desc || '}{\insrsid3480925 \cell }{\insrsid3480925 ' || c.subject_name || '}{\insrsid3480925 \cell }{\insrsid3480925 ' || c.victim_name || '}{\insrsid3480925 \cell }\pard\plain';
         v_offense_header := v_offense_header || '\ql \li0\ri0\widctlpar\intbl\aspalpha\aspnum\faauto\adjustright\rin0\lin0 \fs22\lang1033\langfe1033\cgrid\langnp1033\langfenp1033 {\insrsid3480925 \trowd \irow1\irowband1\lastrow \ts18\trgaph108\trleft-108\trbrdrt\brdrs\brdrw10 \trbrdrl\brdrs\brdrw10';
         v_offense_header := v_offense_header || '\trbrdrb\brdrs\brdrw10 \trbrdrr\brdrs\brdrw10 \trbrdrh\brdrs\brdrw10 \trbrdrv\brdrs\brdrw10';
         v_offense_header := v_offense_header || '\trftsWidth1\trftsWidthB3\trftsWidthA3\trautofit1\trpaddl108\trpaddr108\trpaddfl3\trpaddft3\trpaddfb3\trpaddfr3\tblrsid11671572\tbllkhdrrows\tbllklastrow\tbllkhdrcols\tbllklastcol \clvertalt\clbrdrt\brdrs\brdrw10 \clbrdrl\brdrs\brdrw10 \clbrdrb';
         v_offense_header := v_offense_header || '\brdrs\brdrw10 \clbrdrr\brdrs\brdrw10 \cltxlrtb\clftsWidth1\clshdrawnil \cellx970\clvertalt\clbrdrt\brdrs\brdrw10 \clbrdrl\brdrs\brdrw10 \clbrdrb\brdrs\brdrw10 \clbrdrr\brdrs\brdrw10 \cltxlrtb\clftsWidth1\clshdrawnil \cellx2881\clvertalt\clbrdrt';
         v_offense_header := v_offense_header || '\brdrs\brdrw10 \clbrdrl\brdrs\brdrw10 \clbrdrb\brdrs\brdrw10 \clbrdrr\brdrs\brdrw10 \cltxlrtb\clftsWidth1\clshdrawnil \cellx3742\clvertalt\clbrdrt\brdrs\brdrw10 \clbrdrl\brdrs\brdrw10 \clbrdrb\brdrs\brdrw10 \clbrdrr\brdrs\brdrw10';
         v_offense_header := v_offense_header || '\cltxlrtb\clftsWidth1\clshdrawnil \cellx4536\row }';

     end loop;

     v_offense_header := v_offense_header || '\pard ';
     return v_offense_header;
        
end roi_get_offense_table;

function roi_get_attachments(pActSID in varchar2) return clob is

     v_Attachments     clob := null;

begin
     --for b in (select t.* from t_osi_attachment t,t_osi_report_roi_attach r where t.obj=pActSID and r.attachment=t.sid order by r.seq)
     for b in (select t.*,at.code,r.seq as sequence from t_osi_attachment t,t_osi_report_roi_attach r,t_osi_attachment_type at 
                 where t.obj=pActSID and r.attachment=t.sid and (t.type=at.sid(+) and at.code is null) --order by sequ
               union all
               select t.*,at.code,r.seq as sequence from t_osi_attachment t,t_osi_report_roi_attach r,t_osi_attachment_type at 
                 where t.obj=pActSID and r.attachment=t.sid and (t.type=at.sid and at.code not in ('FFORM40')) order by sequence)
     loop
         v_Attachments := v_Attachments || '&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<a href="#" id="ATTACHMENT~' || b.sid || '" onclick="javascript:window.open(''' || 'f?p=' || v( 'APP_ID') || ':250:' || v( 'SESSION') || ':' || b.sid || ':' || v( 'DEBUG') || ':250:'');"> - ' || b.source || '</a><br>' ;

     end loop;

     return v_Attachments;
     
end roi_get_attachments;

function roi_get_form40_link(pActCode in varchar2, pActSID in varchar2, pReportType in varchar2, pLinkText in varchar2) return clob is

   v_AttachmentSID varchar2(20) := NULL;
   
begin
     for a in (select t.sid from t_osi_attachment t,t_osi_attachment_type at where t.obj=pActSID and t.type=at.sid and at.code='FFORM40' order by t.create_on asc)
     loop
         v_AttachmentSID := a.sid;
         exit;
         
     end loop;

     if v_AttachmentSID is null then

       return '&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<a href="#" id="' || pActCode || '~' || pActSID || '" onclick="javascript:window.open(''' || 'f?p=' || v( 'APP_ID') || ':800:' || v( 'SESSION') || '::' || v( 'DEBUG') || '::P800_REPORT_TYPE,P0_OBJ:' || pReportType || ',' || pActSID || ''');">' || pLinkText || '</a><br>' ;
     
     else

       return '&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<a href="#" id="' || pActCode || '~' || pActSID || '" onclick="javascript:window.open(''' || 'f?p=' || v( 'APP_ID') || ':250:' || v( 'SESSION') || ':' || v_AttachmentSID || ':' || v( 'DEBUG') || ':250:'');">' || pLinkText || '</a><br>' ;

              
     end if;
     
end roi_get_form40_link;
                   
function roi_get_toc(pspecsid in varchar2, pObj in varchar2, pHTML in varchar2 := 'N') return clob is

     v_TOC     clob := null;

     v_Witness clob := null;
     v_Victim  clob := null;
     v_Subject clob := null;

     v_particVersionSid      varchar2(20);
     v_SubjectOfActivityName varchar2(4000);
     v_CommaSpace            number;
     
     v_ReportType varchar2(20);

begin
     log_error('<<<roi_get_toc(' || pspecsid || ',' || pObj || ',' || pHTML || ')');

     --- Get Form 40 Report Type ---
     begin
          select sid into v_ReportType from t_osi_report_type where description='Form 40';
     
     exception when OTHERS then

              v_ReportType:=null;
                   
     end;
     
     ------------------------------------
     ---- Get Substantive Interviews ----
     ------------------------------------
     if pHTML = 'N' then 

       v_TOC := '\tab -Interviews:\line ';
     
     else

       v_TOC := '<div id="InterviewsHeader">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; -Interviews:&nbsp;</div>';
     
     end if;
     for a in (select act.sid as act_sid,substr(ot.code,15) as interview_type,ot.code 
                 from t_osi_activity act,t_core_obj o,t_core_obj_type ot,t_osi_assoc_fle_act fa
                where act.sid=o.sid
                  and ot.sid=o.obj_type
                  and fa.file_sid=pObj
                  and fa.activity_sid=act.sid
                  and act.substantive='Y'
                  and ot.code in ('ACT.INTERVIEW.WITNESS','ACT.INTERVIEW.VICTIM','ACT.INTERVIEW.SUBJECT')
                order by act.activity_date)
     loop
         begin
              select participant_version into v_particVersionSid 
                                    from t_osi_partic_involvement i, t_osi_partic_role_type rt  
                                        where i.obj=a.act_sid
                                          and i.involvement_role=rt.sid
                                          and upper(rt.role)='SUBJECT OF ACTIVITY';

              v_SubjectOfActivityName := osi_participant.get_name(v_particVersionSid, 'Y');
              
              v_CommaSpace := instr(v_SubjectOfActivityName,', ');
              
              v_SubjectOfActivityName := substr(v_SubjectOfActivityName, 1, v_CommaSpace-1);
        
        exception when others then

                 v_SubjectOfActivityName := 'UNKNOWN';
        
        end;
        
        case a.interview_type
        
            when 'WITNESS' then
                
                if pHTML = 'N' then 

                  v_Witness := v_Witness || '\tab \tab -WITNESS ' || v_SubjectOfActivityName || ' INTERVIEW\line ';
                
                else
                  
                  v_Witness := v_Witness || roi_get_form40_link(a.code,a.act_sid,v_ReportType,' -WITNESS ' || v_SubjectOfActivityName || ' INTERVIEW');
                  v_Witness := v_Witness || roi_get_attachments(a.act_sid);
                   
                end if;
                
             when 'VICTIM' then

                if pHTML = 'N' then 

                  v_Victim := v_Victim || '\tab \tab -VICTIM ' || v_SubjectOfActivityName || ' INTERVIEW\line ';
                
                else
                
                  v_Victim := v_Victim || roi_get_form40_link(a.code,a.act_sid,v_ReportType,' -VICTIM ' || v_SubjectOfActivityName || ' INTERVIEW');
                  v_Victim := v_Victim || roi_get_attachments(a.act_sid);

                end if;

            when 'SUBJECT' then

                if pHTML = 'N' then 

                  v_Subject := v_Subject || '\tab \tab -SUBJECT ' || v_SubjectOfActivityName || ' INTERVIEW\line ';
                
                else
                
                  v_Subject := v_Subject || roi_get_form40_link(a.code,a.act_sid,v_ReportType,' -SUBJECT ' || v_SubjectOfActivityName || ' INTERVIEW');
                  v_Subject := v_Subject || roi_get_attachments(a.act_sid);

                end if;

            else
            
              null;
                          
        end case;
        
     end loop;

     if pHTML = 'N' then 

       v_TOC := v_TOC || v_Witness || v_Victim || v_Subject;
     
     else

       v_TOC := v_TOC || v_Witness || v_Victim || v_Subject;
     
     end if;
     
     ----------------------------------
     ---- Get Substantive Searches ----
     ----------------------------------
     if pHTML = 'N' then
     
       v_TOC := v_TOC || '\line \tab -Searches:\line ';
     
     else
     
       v_TOC := v_TOC || '<div>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; -Searches:&nbsp;</div>';
     
     end if;
     
     for a in (select act.sid as act_sid,substr(ot.code,12) as search_type, upper(ot.description) as act_description,ot.code 
                 from t_osi_activity act,t_core_obj o,t_core_obj_type ot,t_osi_assoc_fle_act fa
                where act.sid=o.sid
                  and ot.sid=o.obj_type
                  and fa.file_sid=pObj
                  and fa.activity_sid=act.sid
                  and act.substantive='Y'
                  and ot.code in ('ACT.SEARCH.PERSON','ACT.SEARCH.PLACE','ACT.SEARCH.PROPERTY')
                order by ot.code,act.activity_date)
     loop
         begin
              select participant_version into v_particVersionSid 
                                    from t_osi_partic_involvement i, t_osi_partic_role_type rt  
                                        where i.obj=a.act_sid
                                          and i.involvement_role=rt.sid
                                          and upper(rt.role)='SUBJECT OF ACTIVITY';

              v_SubjectOfActivityName := osi_participant.get_name(v_particVersionSid, 'Y');
              
              v_CommaSpace := instr(v_SubjectOfActivityName,', ');
              
              v_SubjectOfActivityName := ' (' || substr(v_SubjectOfActivityName, 1, v_CommaSpace-1) || ')';
        
        exception when others then

                 v_SubjectOfActivityName := '';
        
        end;
         
        if pHTML = 'N' then

          v_TOC := v_TOC || '\tab \tab - ' || a.act_description || v_SubjectOfActivityName || '\line ';

        else

          v_TOC := v_TOC || roi_get_form40_link(a.code,a.act_sid,v_ReportType,' - ' || a.act_description || v_SubjectOfActivityName);
          v_TOC := v_TOC || roi_get_attachments(a.act_sid);

        end if;
        
     end loop;

     ------------------------------------
     ---- Get Substantive Activities ----
     ------------------------------------
     if pHTML = 'N' then

       v_TOC := v_TOC || '\line \tab -Substantive Investigative Activities:\line ';

     else

       v_TOC := v_TOC || '<div>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; -Substantive Investigative Activities:</div>';

     end if;
     
     for a in (select act.sid as act_sid,ot.code as act_type, upper(ot.description) as act_description,ot.code
                 from t_osi_activity act,t_core_obj o,t_core_obj_type ot,t_osi_assoc_fle_act fa
                where act.sid=o.sid
                  and ot.sid=o.obj_type
                  and fa.file_sid=pObj
                  and fa.activity_sid=act.sid
                  and act.substantive='Y'
                  and ot.code not in ('ACT.INTERVIEW.WITNESS','ACT.INTERVIEW.VICTIM','ACT.INTERVIEW.SUBJECT','ACT.SEARCH.PERSON','ACT.SEARCH.PLACE','ACT.SEARCH.PROPERTY')
                order by act.activity_date)
     loop
         begin
              select participant_version into v_particVersionSid 
                                    from t_osi_partic_involvement i, t_osi_partic_role_type rt  
                                        where i.obj=a.act_sid
                                          and i.involvement_role=rt.sid
                                          and upper(rt.role)='SUBJECT OF ACTIVITY';

              v_SubjectOfActivityName := osi_participant.get_name(v_particVersionSid, 'Y');
              
              v_CommaSpace := instr(v_SubjectOfActivityName,', ');
              
              v_SubjectOfActivityName := ' (' || substr(v_SubjectOfActivityName, 1, v_CommaSpace-1) || ')';
        
        exception when others then

                 v_SubjectOfActivityName := '';
        
        end;
         
        if pHTML = 'N' then 

          v_TOC := v_TOC || '\tab \tab - ' || a.act_description || v_SubjectOfActivityName || '\line ';

        else

          v_TOC := v_TOC || roi_get_form40_link(a.code,a.act_sid,v_ReportType,' - ' || a.act_description || v_SubjectOfActivityName);
          v_TOC := v_TOC || roi_get_attachments(a.act_sid);

        end if;
        
     end loop;

     ----------------------------------------------
     ---- Get OTHER NON-Substantive Activities ----
     ----------------------------------------------
     if pHTML = 'N' then
     
       v_TOC := v_TOC || '\line \tab -OTHER INVESTIGATIVE ACTIVITIES:\line ';

     else

       v_TOC := v_TOC || '<div>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; -OTHER INVESTIGATIVE ACTIVITIES:</div>';

     end if;
     
     for a in (select act.sid as act_sid,ot.code as act_type, upper(ot.description) as act_description,ot.code 
                 from t_osi_activity act,t_core_obj o,t_core_obj_type ot,t_osi_assoc_fle_act fa
                where act.sid=o.sid
                  and ot.sid=o.obj_type
                  and fa.file_sid=pObj
                  and fa.activity_sid=act.sid
                  and (act.substantive='N' OR act.substantive is null)
                  --and ot.code not in ('ACT.INTERVIEW.WITNESS','ACT.INTERVIEW.VICTIM','ACT.INTERVIEW.SUBJECT','ACT.SEARCH.PERSON','ACT.SEARCH.PLACE','ACT.SEARCH.PROPERTY')
                order by act.activity_date)
     loop
         begin
              select participant_version into v_particVersionSid 
                                    from t_osi_partic_involvement i, t_osi_partic_role_type rt  
                                        where i.obj=a.act_sid
                                          and i.involvement_role=rt.sid
                                          and upper(rt.role)='SUBJECT OF ACTIVITY';

              v_SubjectOfActivityName := osi_participant.get_name(v_particVersionSid, 'Y');
              
              v_CommaSpace := instr(v_SubjectOfActivityName,', ');
              
              v_SubjectOfActivityName := ' (' || substr(v_SubjectOfActivityName, 1, v_CommaSpace-1) || ')';
        
        exception when others then

                 v_SubjectOfActivityName := '';
        
        end;
        
        if pHTML = 'N' then 

          v_TOC := v_TOC || '\tab \tab - ' || a.act_description || v_SubjectOfActivityName || '\line ';

        else

          v_TOC := v_TOC || roi_get_form40_link(a.code,a.act_sid,v_ReportType,' - ' || a.act_description || v_SubjectOfActivityName);
          v_TOC := v_TOC || roi_get_attachments(a.act_sid);

        end if;
        
     end loop;

     log_error('>>>roi_get_toc(' || pspecsid || ',' || pObj || ',' || pHTML || ')');

     return v_TOC;
     
exception when others then

         log_error('>>>roi_get_toc(' || pspecsid || ',' || pObj || ',' || pHTML || ') - ' || sqlerrm);
        
end roi_get_toc;

function get_report_period(psid in varchar2) return varchar2 is
     
     minActDate date;
     maxActDate date;

     minActDateRC date;
     maxActDateRC date;

     minActDateDR date;
     maxActDateDR date;
     
begin
     --- Over all Activities ---
     select min(activity_date),max(activity_date) into minActDate, maxActDate from t_osi_assoc_fle_act fa,t_osi_activity a 
          where fa.file_sid=psid
            and fa.activity_sid=a.sid;

     --- Law Enforcement Records Check Activities ---
     select min(activity_date),max(activity_date) into minActDateRC, maxActDateRC  from t_osi_assoc_fle_act fa,t_osi_a_records_check a 
       where fa.file_sid=psid
         and fa.activity_sid=a.obj;
     
     if minActDateRC < minActDate then

       minActDate := minActDateRC;

     end if;

     if maxActDateRC > maxActDate then

       maxActDate := maxActDateRC;

     end if;
     
     --- Document Review Activities ---
     select min(activity_date),max(activity_date) into minActDateDR, maxActDateDR  from t_osi_assoc_fle_act fa,t_osi_a_document_review a 
       where fa.file_sid=psid
         and fa.activity_sid=a.obj;
         
     if minActDateDR < minActDate then

       minActDate := minActDateDR;

     end if;

     if maxActDateDR > maxActDate then

       maxActDate := maxActDateDR;

     end if;

     return to_char(minActDate, v_date_fmt) || ' - ' || to_char(maxActDate, v_date_fmt);
        
end get_report_period;

function case_roi(psid in varchar2) return clob is

     v_ok varchar2(1000);
     v_template clob := null;
     v_template_date date;
     v_mime_type t_core_template.mime_type%type;
     v_mime_disp t_core_template.mime_disposition%type;
     v_full_id varchar2(100) := null;
     v_file_id varchar2(100) := null;
     v_summary clob := null;
     v_offense_header clob := null;
     v_offense_desc_prefix varchar2(100);
     v_report_by varchar2(500);
     v_commander varchar2(600);
     v_class varchar2(100);

     pragma autonomous_transaction;

begin
     log_error('Case_ROI(' || psid || ')<<< - Start ' || sysdate());
     v_obj_sid := psid;

     --- Grab template and assign to v_template ---
     v_ok := core_template.get_latest('ROI', v_template, v_template_date, v_mime_type, v_mime_disp);

     -----------------------------------------------
     ----------------- Cover Page ------------------
     -----------------------------------------------
     for a in (select s.SID, obj, to_char(start_date, v_date_fmt) || ' - ' || to_char(end_date, v_date_fmt) as report_period
                    from t_osi_report_spec s, t_osi_report_type rt where obj=v_obj_sid and s.report_type=rt.SID and rt.description='ROI (previous version)')
     loop
         v_spec_sid := a.SID;

         begin
              select 'SA ' || first_name || ' ' || decode(length(middle_name), 1, middle_name || '. ', 0, '', null, '', substr(middle_name, 1, 1) || '. ') || last_name into v_report_by
                from t_core_personnel where SID = core_context.personnel_sid;
         exception
 
              when no_data_found then
  
                  v_report_by := core_context.personnel_name;
  
         end;

         v_ok := core_template.replace_tag(v_template, 'REPORT_BY', v_report_by);
         v_ok := core_template.replace_tag(v_template, 'REPORT_PERIOD', a.report_period);
         v_ok := core_template.replace_tag(v_template, 'RPT_DATE', to_char(sysdate, v_date_fmt), 'TOKEN@', true);

     end loop;

     v_class := osi_classification.get_report_class(v_obj_sid);

     v_ok := core_template.replace_tag(v_template, 'CLASSIFICATION', osi_report.replace_special_chars(v_class, 'RTF'), 'TOKEN@', true);
                                      
     osi_report.load_participants(v_obj_sid);
     osi_report.load_agents_assigned(v_obj_sid);

     for b in (select i.summary_investigation, f.id, f.full_id
                    from t_osi_f_investigation i, 
                         t_osi_file f
                   where i.SID = psid
                     and i.SID(+) = f.SID)
     loop
         v_full_id := b.full_id;
         v_file_id := b.id;
         v_summary := b.summary_investigation;
         
     end loop;

     v_offense_header := roi_get_offense_table(psid);
        
     v_ok := core_template.replace_tag(v_template, 'FILE_ID', v_file_id, 'TOKEN@', true);
     v_ok := core_template.replace_tag(v_template, 'FILE_NO', v_full_id, 'TOKEN@', true);
     v_ok := core_template.replace_tag(v_template, 'FILE_OFFENSE', v_offense_header);--- || v_file_offense);
     v_ok := core_template.replace_tag(v_template, 'SUMMARY', v_summary);
     v_ok := core_template.replace_tag(v_template, 'SUBJECT_LIST', get_subject_list);
     v_ok := core_template.replace_tag(v_template, 'VICTIMS_LIST', get_victim_list);
     v_exhibit_cnt := 0;
     v_exhibit_covers := null;

     for c in (select unit, unit_name
                    from v_osi_obj_assignments oa, 
                         t_osi_unit_name un
                   where obj=v_obj_sid 
                     and un.unit=oa.current_unit 
                     and un.end_date is null)
     loop
         v_unit_sid := c.unit;
         v_ok := core_template.replace_tag(v_template, 'UNIT_NAME', c.unit_name, 'TOKEN@', true);

     end loop;

     v_commander := get_owning_unit_cdr;
     v_ok := core_template.replace_tag(v_template, 'UNIT_CDR', v_commander);

     if instr(v_commander, ', USAF') > 0 then

       v_ok := core_template.replace_tag(v_template, 'DESIGNATION', 'Commander');

     else

       v_ok := core_template.replace_tag(v_template, 'DESIGNATION', 'Special Agent in Charge');

     end if;

     v_ok := core_template.replace_tag(v_template, 'CAVEAT_LIST', get_caveats_list);

     get_sel_activity(v_spec_sid);
     v_ok := core_template.replace_tag(v_template, 'ACTIVITY_TOC', v_act_toc_list);
     core_util.cleanup_temp_clob(v_act_toc_list);

     v_ok := core_template.replace_tag(v_template, 'NARRATIVE_LIST', v_act_narr_list);
     core_util.cleanup_temp_clob(v_act_narr_list);

     v_ok := core_template.replace_tag(v_template, 'EXHIBITS_LIST', v_exhibits_list);
     core_util.cleanup_temp_clob(v_exhibits_list);

     if v_exhibit_covers is null or v_exhibit_covers = '' then

       v_ok := core_template.replace_tag(v_template, 'EXHIBIT_COVERS', 'Exhibits');

     else

       v_ok := core_template.replace_tag(v_template, 'EXHIBIT_COVERS', replace(v_exhibit_covers, '[TOKEN@FILE_ID]', v_full_id));

     end if;

     get_evidence_list(v_obj_sid, v_spec_sid);
     v_ok := core_template.replace_tag(v_template, 'EVIDENCE_LIST', v_evidence_list);
     core_util.cleanup_temp_clob(v_evidence_list);

     log_error('Case_ROI(' || psid || ') - End ' || sysdate());
     return v_template;

exception
         when others then

             log_error('Case_ROI(' || psid || ') - Error -->' || sqlerrm);
             return v_template;

end case_roi;

function case_roi_new(psid in varchar2) return clob is

     v_ok varchar2(1000);
     v_template clob := null;
     v_template_date date;
     v_mime_type t_core_template.mime_type%type;
     v_mime_disp t_core_template.mime_disposition%type;
     v_full_id varchar2(100) := null;
     v_file_id varchar2(100) := null;
     v_summary clob := null;
     v_offense_header clob := null;
     v_report_by varchar2(500);
     v_commander varchar2(600);
     v_class varchar2(100);
     v_report_period varchar2(100);
     v_distro_table clob;
          
     pragma autonomous_transaction;

begin
     log_error('case_roi_new(' || psid || ')<<< - Start ' || sysdate());
        
     v_obj_sid := psid;

     --- Grab template and assign to v_template  ---
     v_ok := core_template.get_latest('ROI_NEW', v_template, v_template_date, v_mime_type, v_mime_disp);
        
     -----------------------------------------------
     ----------------- Cover Page ------------------
     -----------------------------------------------
     v_report_period := get_report_period(psid);
     for a in (select s.SID,obj,to_char(start_date, v_date_fmt) || ' - ' || to_char(end_date, v_date_fmt) as report_period
                   from t_osi_report_spec s, t_osi_report_type rt where obj = v_obj_sid and s.report_type = rt.SID and rt.description = 'ROI')
     loop
         v_spec_sid := a.SID;

         begin
              select 'SA ' || first_name || ' ' || decode(length(middle_name), 1, middle_name || '. ', 0, '', null, '', substr(middle_name, 1, 1) || '. ') || last_name into v_report_by
               from t_core_personnel where SID = core_context.personnel_sid;
         exception
             when no_data_found then
                 v_report_by := core_context.personnel_name;
         end;

         v_ok := core_template.replace_tag(v_template, 'REPORT_BY', v_report_by);
         v_ok := core_template.replace_tag(v_template, 'REPORT_PERIOD', v_report_period);
         v_ok := core_template.replace_tag(v_template, 'RPT_DATE', to_char(sysdate, v_date_fmt), 'TOKEN@', true);

     end loop;

     --- Get Classification ---
     v_class := osi_classification.get_report_class(v_obj_sid);
     v_ok := core_template.replace_tag(v_template, 'CLASSIFICATION', osi_report.replace_special_chars(v_class, 'RTF'), 'TOKEN@', true);
                                      
     --- Load Participants and Assignments ---
     osi_report.load_participants(v_obj_sid);
     osi_report.load_agents_assigned(v_obj_sid);
        
     for b in (select i.summary_investigation, f.id, f.full_id
                 from t_osi_f_investigation i,
                      t_osi_file f
                where i.SID = psid
                  and i.SID(+) = f.SID)
     loop
         v_full_id := b.full_id;
         v_file_id := b.id;
         v_summary := b.summary_investigation;

     end loop;

     v_offense_header := roi_get_offense_table(psid);
        
     v_ok := core_template.replace_tag(v_template, 'FILE_ID', v_file_id, 'TOKEN@', true);
     v_ok := core_template.replace_tag(v_template, 'FILE_NO', v_full_id, 'TOKEN@', true);
     v_ok := core_template.replace_tag(v_template, 'FILE_OFFENSE', v_offense_header);
     v_ok := core_template.replace_tag(v_template, 'SUMMARY', osi_report.replace_special_chars_clob(v_summary,'RTF'));
     v_ok := core_template.replace_tag(v_template, 'SUBJECT_LIST', get_subject_list);
     v_ok := core_template.replace_tag(v_template, 'VICTIMS_LIST', get_victim_list);

     v_exhibit_cnt := 0;
     v_exhibit_covers := null;
        
     ---------------------
     --- Get Unit Name ---
     ---------------------
     for c in (select unit, unit_name from v_osi_obj_assignments oa, t_osi_unit_name un where obj = v_obj_sid and un.unit = oa.current_unit and un.end_date is null)
     loop
         v_unit_sid := c.unit;
         v_ok := core_template.replace_tag(v_template, 'UNIT_NAME', c.unit_name, 'TOKEN@', true);

     end loop;

     v_commander := get_owning_unit_cdr;
     v_ok := core_template.replace_tag(v_template, 'UNIT_CDR', v_commander);

     if instr(v_commander, ', USAF') > 0 then

       v_ok := core_template.replace_tag(v_template, 'DESIGNATION', 'Commander');

     else

       v_ok := core_template.replace_tag(v_template, 'DESIGNATION', 'Special Agent in Charge');

     end if;
     
     --- Do Distribution Table Rows ---
     for d in (select distribution || decode(withexhibits,'Y',' (w/ Exhibits)',' (w/o Exhibits)') as distribution,amount 
                   from t_osi_report_distribution rd,
                        t_osi_report_spec rs 
                   where rs.obj=v_obj_sid and rs.report_type='33318UYA' and rs.sid=rd.spec order by rd.seq)
     loop
         v_distro_table := v_distro_table || '{\rtlch\fcs1 \ab\af0 \ltrch\fcs0 \b\insrsid924550'; 
         v_distro_table := v_distro_table || '\ltrrow}\trowd \irow0\irowband0\lastrow \ltrrow\ts21\trgaph108\trleft-108\trftsWidth1\trftsWidthB3\trftsWidthA3\trautofit1\trpaddl108\trpaddr108\trpaddfl3\trpaddft3\trpaddfb3\trpaddfr3\tblrsid4546469\tbllkhdrrows\tbllkhdrcols\tbllknocolband\tblind0';
         v_distro_table := v_distro_table || '\tblindtype3 \clvertalt\clbrdrt\brdrtbl \clbrdrl\brdrtbl \clbrdrb\brdrtbl \clbrdrr\brdrtbl \cltxlrtb\clftsWidth3\clwWidth9198\clshdrawnil \cellx8542\clvertalt\clbrdrt\brdrtbl \clbrdrl\brdrtbl \clbrdrb\brdrtbl \clbrdrr\brdrtbl'; 
         v_distro_table := v_distro_table || '\cltxlrtb\clftsWidth3\clwWidth378\clshdrawnil \cellx9468\pard\plain \ltrpar\s15\ql \li0\ri0\widctlpar\intbl\tldot\tx8640\wrapdefault\aspalpha\aspnum\faauto\adjustright\rin0\lin0\yts21 \rtlch\fcs1 \af0\afs22\alang1025 \ltrch\fcs0'; 
         v_distro_table := v_distro_table || '\fs22\lang1033\langfe1033\cgrid\langnp1033\langfenp1033 {\rtlch\fcs1 \ab\af0 \ltrch\fcs0 \insrsid920783 ' || ltrim(rtrim(to_char(d.distribution))) || ' \tab}{\rtlch\fcs1 \ab\af0 \ltrch\fcs0 \b\insrsid4546469 \cell }{\rtlch\fcs1 \ab\af0 \ltrch\fcs0'; 
         v_distro_table := v_distro_table || '\insrsid920783 ' || ltrim(rtrim(to_char(d.amount))) || '}{\rtlch\fcs1 \ab\af0 \ltrch\fcs0 \b\insrsid4546469 \cell }\pard\plain \ltrpar\ql \li0\ri0\sa200\sl276\slmult1';
         v_distro_table := v_distro_table || '\widctlpar\intbl\wrapdefault\aspalpha\aspnum\faauto\adjustright\rin0\lin0 \rtlch\fcs1 \af0\afs22\alang1025 \ltrch\fcs0 \fs22\lang1033\langfe1033\cgrid\langnp1033\langfenp1033 {\rtlch\fcs1 \ab\af0 \ltrch\fcs0 \b\insrsid4546469'; 
         v_distro_table := v_distro_table || '\trowd \irow0\irowband0\lastrow \ltrrow\ts21\trgaph108\trleft-108\trftsWidth1\trftsWidthB3\trftsWidthA3\trautofit1\trpaddl108\trpaddr108\trpaddfl3\trpaddft3\trpaddfb3\trpaddfr3\tblrsid4546469\tbllkhdrrows\tbllkhdrcols\tbllknocolband\tblind0\tblindtype3'; 
         v_distro_table := v_distro_table || '\clvertalt\clbrdrt\brdrtbl \clbrdrl\brdrtbl \clbrdrb\brdrtbl \clbrdrr\brdrtbl \cltxlrtb\clftsWidth3\clwWidth9198\clshdrawnil \cellx8542\clvertalt\clbrdrt\brdrtbl \clbrdrl\brdrtbl \clbrdrb\brdrtbl \clbrdrr\brdrtbl'; 
         v_distro_table := v_distro_table || '\cltxlrtb\clftsWidth3\clwWidth378\clshdrawnil \cellx9468\row }';
              
     end loop;

     v_ok := core_template.replace_tag(v_template, 'DISTRIBUTION', v_distro_table);
     
     v_ok := core_template.replace_tag(v_template, 'CAVEAT_LIST', get_caveats_list);

     v_act_toc_list := roi_get_toc(v_spec_sid, v_obj_sid);
     v_ok := core_template.replace_tag(v_template, 'ACTIVITY_TOC', v_act_toc_list);
     core_util.cleanup_temp_clob(v_act_toc_list);

     get_evidence_list_new(v_obj_sid, v_spec_sid);
     v_ok := core_template.replace_tag(v_template, 'EVIDENCE_LIST', v_evidence_list);
     core_util.cleanup_temp_clob(v_evidence_list);

     log_error('case_roi_new(' || psid || ')>>> - End   ' || sysdate());
     return v_template;

exception
         when others then

             log_error('case_roi_new - Error -->' || sqlerrm);
             return v_template;

end case_roi_new;

function splitHTML(pHTML in out clob, psplitSize in number) return clob is

     v_nextBR number;
     v_htmlSplit clob;

begin
     v_nextBR := instr(pHTML,'<br>',psplitSize+1);  
     v_htmlSplit := substr(pHTML,1,v_nextBR+3);
       
     pHTML := substr(pHTML,v_nextBR+4);
     return v_htmlSplit;
     
end splitHTML;

function roi_get_print_html(p_obj in varchar2, pHTML1 out clob, pHTML2 out clob, pHTML3 out clob, pHTML4 out clob, pHTML5 out clob, pHTML6 out clob, pHTML7 out clob, pHTML8 out clob, pHTML9 out clob, pHTML10 out clob) return varchar2 is

     v_return clob;
     v_attach1 clob;
     v_attach2 clob;
     v_attach3 clob;
     v_form40 clob;
     v_ReportType varchar2(20);
     attachment_counter number;
     v_splitSize number := 31000;
     v_Splits number;

     type v_HTMLS_type is table of clob index by binary_integer;
     v_HTMLS v_HTMLS_type;
     
begin
     v_return := v_return || '<html>';
     v_return := v_return || '<head>';
     v_return := v_return || '<title>ROI Printing Page</title>';

--     v_return := v_return || '<script type="text/javascript">';
--     v_return := v_return || 'function printall()';
--     v_return := v_return || '{';
--     v_return := v_return || ' var counter=1;';
--     v_return := v_return || '';
--     v_return := v_return || ' $(".printFrame").each(function(index)';
--     v_return := v_return || '  {';
--     v_return := v_return || '   window.frames[this.name].focus();';
--     v_return := v_return || '   window.frames[this.name].print();';
--     v_return := v_return || '   alert(''Click here AFTER you have sent document '' + this.name + '' to the printer.'');';
--     v_return := v_return || '  });';
--     v_return := v_return || '}';
--     v_return := v_return || '</script>';
     v_return := v_return || '</head>';
     v_return := v_return || '<body>';
--     v_return := v_return || '<input type="submit" value="Print All" onclick="javascript:printall()" />';
     v_return := v_return || '<HR>';
     
     begin
          select sid into v_ReportType from t_osi_report_type where description='ROI_NEW - HIDDEN FROM REPORTS MENU';
     
     exception when OTHERS then

              v_ReportType:=null;
                   
     end;
     v_return := v_return || '<a id="CoverTOCSummary" href="#" onclick="javascript:window.open(''' || 'f?p=' || v( 'APP_ID') || ':800:' || v( 'SESSION') || '::' || v( 'DEBUG') || '::P800_REPORT_TYPE,P0_OBJ:' || v_ReportType || ',' || p_obj || ''');"> - Title Page, Summary of Investigation, Table of Contents - </a>' ;

     v_return := v_return || roi_get_toc(null, p_obj, 'Y');

     v_return := v_return || '<HR>';
     v_return := v_return || '</body>';
     v_return := v_return || '</html>';
     
     --- Since Application Express can only seem to handle 32K worth of a return even if the return is a CLOB we need to split it ---
     pHTML1 := NULL;
     pHTML2 := NULL;
     pHTML3 := NULL;
     pHTML4 := NULL;
     pHTML5 := NULL;
     pHTML6 := NULL;
     pHTML7 := NULL;
     pHTML8 := NULL;
     pHTML9 := NULL;
     pHTML10 := NULL;
     v_Splits := 0;
     
     if(length(v_return)>v_splitSize) then

       while(length(v_return)>v_splitSize)
       loop
           v_HTMLS(v_Splits):=splitHTML(v_return, v_splitSize);
           v_Splits := v_Splits + 1;
         
       end loop;

       --- Get possible left overs ---
       v_HTMLS(v_Splits):=v_return;
       
       --- Put everything back into the return CLOBs ---
       begin

            pHTML1 := v_HTMLS(0);
            pHTML2 := v_HTMLS(1);
            pHTML3 := v_HTMLS(2);
            pHTML4 := v_HTMLS(3);
            pHTML5 := v_HTMLS(4);
            pHTML6 := v_HTMLS(5);
            pHTML7 := v_HTMLS(6);
            pHTML8 := v_HTMLS(7);
            pHTML9 := v_HTMLS(8);
            pHTML10 := v_HTMLS(9);
            
       exception when others then

                null;

       end;
       
     else

       pHTML1 := v_return;
     
     end if;

     return 'Y';
     
/* testing
     v_return := v_return || '<html>';
     v_return := v_return || '<head>';
     v_return := v_return || '<title>Example Report</title>';


     v_return := v_return || '<script type="text/javascript">';
     v_return := v_return || 'function printall()';
     v_return := v_return || '{';
     v_return := v_return || ' var counter=1;';
     v_return := v_return || '';
     v_return := v_return || ' $(".printFrame").each(function(index)';
     v_return := v_return || '  {';
     v_return := v_return || '   window.frames[this.name].focus();';
     v_return := v_return || '   window.frames[this.name].print();';
     v_return := v_return || '   alert(''Click here AFTER you have sent document '' + this.name + '' to the printer.'');';
     v_return := v_return || '  });';
     v_return := v_return || '}';
     v_return := v_return || '</script>';
     v_return := v_return || '</head>';
     v_return := v_return || '<body>';
     v_return := v_return || '<input type="submit" value="Print All" onclick="javascript:printall()" />';
     v_return := v_return || '<p>Hi! I''m a report!</p>';
     v_return := v_return || '<iframe class="printFrame" id="printframe1" name="printframe1" src="https://hqcuiwebi2ms.ogn.af.mil:4443/i/TempFingerPrintImages/ROI_NEW - Copy.RTF"></iframe>';
     v_return := v_return || '<iframe class="printFrame" id="printframe2" name="printframe2" src="https://hqcuiwebi2ms.ogn.af.mil:4443/i/TempFingerPrintImages/amputated.jpg"></iframe>';
     v_return := v_return || '<iframe class="printFrame" id="printframe3" name="printframe3" src="https://hqcuiwebi2ms.ogn.af.mil:4443/i/TempFingerPrintImages/ImageNotAvailable.jpg"></iframe>';
     v_return := v_return || '<iframe class="printFrame" id="printframe4" name="printframe4" src="https://hqcuiwebi2ms.ogn.af.mil:4443/i/TempFingerPrintImages/unabletoprint.jpg"></iframe>';
     v_return := v_return || '<iframe class="printFrame" id="printframe5" name="printframe5" src="https://hqcuiwebi2ms.ogn.af.mil:4443/i/TempFingerPrintImages/Request For Leave Form v1.1.pdf"></iframe>';
     v_return := v_return || '';
     v_return := v_return || '<HR>';
     v_return := v_return || '<OBJECT data="https://hqcuiwebi2ms.ogn.af.mil:4443/i/TempFingerPrintImages/Request For Leave Form v1.1.pdf" TYPE="application/x-pdf" TITLE="SamplePdf" WIDTH=200 HEIGHT=100>';
     v_return := v_return || ' <a href="https://hqcuiwebi2ms.ogn.af.mil:4443/i/TempFingerPrintImages/Request For Leave Form v1.1.pdf">shree</a>'; 
     v_return := v_return || '</object>';

     v_return := v_return || '</body>';
     v_return := v_return || '</html>';
*/
     
end roi_get_print_html;

end osi_investigation;
/

-- "Set define off" turns off substitution variables. 
Set define off; 

CREATE OR REPLACE package osi_util as
/******************************************************************************
   Name:     OSI_UTIL
   Purpose:  Provides utility functions.

   Revisions:
    Date        Author          Description
    ----------  --------------  ------------------------------------
    23-APR-2009 T.Whitehead    Created package.
    07-MAY-2009 T.McGuffin     Added Address utilities (GET_ADDR_FIELDS, GET_ADDR_DISPLAY,
                               UPDATE_ADDRESS, INSERT_ADDRESS)
    16-may-2009 T.Whitehead    Added parse_size from OSI_ATTACHMENT.
    20-MAY-2009 T.McGuffin     Removed get_edit_link.
    22-May-2009 T.McGuffin     Modified insert_address to remove the obj_context.
    10-Jun-2009 R.Dibble       Added get_checklist_buttons
    25-Jun-2009 T.McGuffin     Added new update_single_address procedure which ties together insertion and
                               updating of an address, if either are applicable.
    29-Jul-2009 T.Whitehead    Moved get_mime_icon into this package.
    30-Nov-2009 T.Whitehead    Added get_report_links.
    29-Dec-2009 T.Whitehead    Added do_title_substitution.
    04-Jan-2010 T.Whitehead    Added procedure aitc that calls core_util.append_info_to_clob.
    16-Feb-2010 T.McGuffin     Added display_precision_date function.
    25-Mar-2010 T.Whitehead    Copied blob_to_clob, blob_to_hex, clob_to_clob, decapxml, encapxml
                               and hex_to_blob from I2MS.
    14-Jun-2010 J.Faris        Added show_tab function.
    12-Jul-2010 R.Dibble       Added encrypt_md5hex (copied from CORE_CONTEXT and made public)
    02-Mar-2011 Tim Ward       CR#3705 - Added WordWrapFunc.
    04-Oct-2011 Tim Ward       CR#3919 - Add Report Printing for Activities from the File/Activity Associations sreen.
                                Added get_report_menu.
    20-Jun-2012 Tim Ward       Added new parameter to get_report_links, get_status_buttons, and get_checklist_buttons.
                                Allows OSI_MENU to get the lists in a more usable way to split them up.
    03-Aug-2012 Tim Ward       Added new parameter to get_report_links so it adds the Report SID id to the return values.
                                Allows OSI_MENU to get the Report SID (this defaults to N).
    
******************************************************************************/
    procedure aitc(p_clob in out nocopy clob, p_text varchar2);

    function blob_to_clob(p_blob in blob)
        return clob;

    function blob_to_hex(p_blob in blob)
        return clob;

    function clob_to_blob(p_clob in clob)
        return blob;

    function decapxml(p_blob in blob, p_tag in varchar2)
        return blob;

    function encapxml(p_blob in blob)
        return blob;

    function hex_to_blob(p_blob in blob)
        return blob;

    function hex_to_blob(p_clob in clob)
        return blob;

    /*
     * Replaces any ~COLUMN_NAME~ items with values from table or view name p_tv_name.
     */
    function do_title_substitution(
        p_obj       in   varchar2,
        p_title     in   varchar2,
        p_tv_name   in   varchar2 := null)
        return varchar2;

    function get_mime_icon(p_mime_type in varchar2, p_file_name in varchar2)
        return varchar2;

    function get_report_links(p_obj in varchar2, p_delim in varchar2 := '~', pIncludeSID in varchar2 := 'N')
        return varchar2;

    function get_report_menu(p_obj in varchar2, p_justTemplate in varchar2 := 'Y')
        return varchar2;

--    This function is used to return a squigly deliminted list (~) of statuses that an
--    object may currently go to
    function get_status_buttons(p_obj in varchar2, p_delim in varchar2 := '~')
        return varchar2;

--    This function is used to return a squigly deliminted list (~) of checklists that an
--    object may utilize
    function get_checklist_buttons(p_obj in varchar2, p_delim in varchar2 := '~')
        return varchar2;

--    The following functions all make reference to an address list.  This list uses core_list (squiggly-
--    delimited values) and contains all of the address fields in the following order:
--    ~ADDRESS1~ADDRESS2~CITY~STATE(sid)~ZIP~COUNTRY(sid)~

    --    Takes a number X and returns X bytes, X KB, X MB, or X GB.
    function parse_size(p_size in number)
        return varchar2;

    -- Given a date, displays in the precision imbedded in the seconds field of the date.
    function display_precision_date(p_date date)
        return varchar2;

    /* This function executes any object or object type specific code to show/hide page tabs */
    function show_tab(p_obj_type_code in varchar2, p_tab in varchar2, p_obj in varchar2 := null, p_context in varchar2 := null)
            return varchar2;
            
   /* Used to compare passwords for PASSWORD CHANGE SCREEN ONLY!!! */
   function encrypt_md5hex(p_clear_text in varchar2)
        return varchar2;

    function WordWrapFunc(pst$ in clob, pLength in Number, Delimiter in clob) return clob;

end osi_util;
/


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

                 v_rtn := v_rtn || '<li><a href="javascript:void(0)" onclick="' || a.column_value || ' return false;" class="dhtmlSubMenuN" onmouseover="dhtml_CloseAllSubMenusL(this)">' || v_description || '</a></li>';
               
               else
               
                 v_description := a.column_value;
                
               end if;
               v_cnt := v_cnt + 1;
             
           end loop;
           return v_rtn;
         
         else

           v_rtn := '<ul class="dhtmlMenuLG2"><li class="dhtmlMenuItem1"><a>Reports</a><img src="/i/themes/theme_13/menu_small.gif" alt="Expand" onclick="GetAndOpenMenu(event, this,' || '''' || 'L' || p_obj || '''' || ',false)" style="cursor: pointer;"/></li><ul id="L' || p_obj || '" htmldb:listlevel="2" class="dhtmlSubMenu2" style="display:none;">';
           v_rtn := v_rtn || '</ul></ul>';
           
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


--------------------------------------------------------------------
-----------------ATTACHMENT TYPE FFORM40----------------------------
--------------------------------------------------------------------
--------------------------------------------------------------------
--------------------------------------------------------------------
--------------------------------------------------------------------
--------------------------------------------------------------------
--------------------------------------------------------------------
--------------------------------------------------------------------
--------------------------------------------------------------------
--------------------------------------------------------------------
INSERT INTO T_OSI_ATTACHMENT_TYPE ( SID, OBJ_TYPE, USAGE, CODE, DESCRIPTION, MIME_DISPOSITION, MIN_NUM, MAX_NUM, LOCK_MODE, SEQ, ACTIVE, OVERRIDE, CREATE_BY, CREATE_ON, MODIFY_BY, MODIFY_ON ) VALUES ( 
'33318VUB', '22203BP4', 'ATTACHMENT', 'FFORM40', 'Final Signed Form 40', 'ATTACHMENT', NULL, NULL, NULL, NULL, 'Y', 'N', 'timothy.ward',  TO_Date( '08/13/2012 12:16:04 PM', 'MM/DD/YYYY HH:MI:SS AM'), 'timothy.ward',  TO_Date( '08/13/2012 12:16:04 PM', 'MM/DD/YYYY HH:MI:SS AM')); 
INSERT INTO T_OSI_ATTACHMENT_TYPE ( SID, OBJ_TYPE, USAGE, CODE, DESCRIPTION, MIME_DISPOSITION, MIN_NUM, MAX_NUM, LOCK_MODE, SEQ, ACTIVE, OVERRIDE, CREATE_BY, CREATE_ON, MODIFY_BY, MODIFY_ON ) VALUES ( 
'33318VSR', '222000005ES', 'ATTACHMENT', 'FFORM40', 'Final Signed Form 40', 'ATTACHMENT', NULL, NULL, NULL, NULL, 'Y', 'N', 'timothy.ward',  TO_Date( '08/13/2012 12:16:04 PM', 'MM/DD/YYYY HH:MI:SS AM'), 'timothy.ward',  TO_Date( '08/13/2012 12:16:04 PM', 'MM/DD/YYYY HH:MI:SS AM')); 
INSERT INTO T_OSI_ATTACHMENT_TYPE ( SID, OBJ_TYPE, USAGE, CODE, DESCRIPTION, MIME_DISPOSITION, MIN_NUM, MAX_NUM, LOCK_MODE, SEQ, ACTIVE, OVERRIDE, CREATE_BY, CREATE_ON, MODIFY_BY, MODIFY_ON ) VALUES ( 
'33318VSS', '222000005ET', 'ATTACHMENT', 'FFORM40', 'Final Signed Form 40', 'ATTACHMENT', NULL, NULL, NULL, NULL, 'Y', 'N', 'timothy.ward',  TO_Date( '08/13/2012 12:16:04 PM', 'MM/DD/YYYY HH:MI:SS AM'), 'timothy.ward',  TO_Date( '08/13/2012 12:16:04 PM', 'MM/DD/YYYY HH:MI:SS AM')); 
INSERT INTO T_OSI_ATTACHMENT_TYPE ( SID, OBJ_TYPE, USAGE, CODE, DESCRIPTION, MIME_DISPOSITION, MIN_NUM, MAX_NUM, LOCK_MODE, SEQ, ACTIVE, OVERRIDE, CREATE_BY, CREATE_ON, MODIFY_BY, MODIFY_ON ) VALUES ( 
'33318VST', '222000008GT', 'ATTACHMENT', 'FFORM40', 'Final Signed Form 40', 'ATTACHMENT', NULL, NULL, NULL, NULL, 'Y', 'N', 'timothy.ward',  TO_Date( '08/13/2012 12:16:04 PM', 'MM/DD/YYYY HH:MI:SS AM'), 'timothy.ward',  TO_Date( '08/13/2012 12:16:04 PM', 'MM/DD/YYYY HH:MI:SS AM')); 
INSERT INTO T_OSI_ATTACHMENT_TYPE ( SID, OBJ_TYPE, USAGE, CODE, DESCRIPTION, MIME_DISPOSITION, MIN_NUM, MAX_NUM, LOCK_MODE, SEQ, ACTIVE, OVERRIDE, CREATE_BY, CREATE_ON, MODIFY_BY, MODIFY_ON ) VALUES ( 
'33318VSU', '222000008IS', 'ATTACHMENT', 'FFORM40', 'Final Signed Form 40', 'ATTACHMENT', NULL, NULL, NULL, NULL, 'Y', 'N', 'timothy.ward',  TO_Date( '08/13/2012 12:16:04 PM', 'MM/DD/YYYY HH:MI:SS AM'), 'timothy.ward',  TO_Date( '08/13/2012 12:16:04 PM', 'MM/DD/YYYY HH:MI:SS AM')); 
INSERT INTO T_OSI_ATTACHMENT_TYPE ( SID, OBJ_TYPE, USAGE, CODE, DESCRIPTION, MIME_DISPOSITION, MIN_NUM, MAX_NUM, LOCK_MODE, SEQ, ACTIVE, OVERRIDE, CREATE_BY, CREATE_ON, MODIFY_BY, MODIFY_ON ) VALUES ( 
'33318VSV', '222000008SW', 'ATTACHMENT', 'FFORM40', 'Final Signed Form 40', 'ATTACHMENT', NULL, NULL, NULL, NULL, 'Y', 'N', 'timothy.ward',  TO_Date( '08/13/2012 12:16:04 PM', 'MM/DD/YYYY HH:MI:SS AM'), 'timothy.ward',  TO_Date( '08/13/2012 12:16:04 PM', 'MM/DD/YYYY HH:MI:SS AM')); 
INSERT INTO T_OSI_ATTACHMENT_TYPE ( SID, OBJ_TYPE, USAGE, CODE, DESCRIPTION, MIME_DISPOSITION, MIN_NUM, MAX_NUM, LOCK_MODE, SEQ, ACTIVE, OVERRIDE, CREATE_BY, CREATE_ON, MODIFY_BY, MODIFY_ON ) VALUES ( 
'33318VSW', '222000008WJ', 'ATTACHMENT', 'FFORM40', 'Final Signed Form 40', 'ATTACHMENT', NULL, NULL, NULL, NULL, 'Y', 'N', 'timothy.ward',  TO_Date( '08/13/2012 12:16:04 PM', 'MM/DD/YYYY HH:MI:SS AM'), 'timothy.ward',  TO_Date( '08/13/2012 12:16:04 PM', 'MM/DD/YYYY HH:MI:SS AM')); 
INSERT INTO T_OSI_ATTACHMENT_TYPE ( SID, OBJ_TYPE, USAGE, CODE, DESCRIPTION, MIME_DISPOSITION, MIN_NUM, MAX_NUM, LOCK_MODE, SEQ, ACTIVE, OVERRIDE, CREATE_BY, CREATE_ON, MODIFY_BY, MODIFY_ON ) VALUES ( 
'33318VSX', '222000009EP', 'ATTACHMENT', 'FFORM40', 'Final Signed Form 40', 'ATTACHMENT', NULL, NULL, NULL, NULL, 'Y', 'N', 'timothy.ward',  TO_Date( '08/13/2012 12:16:04 PM', 'MM/DD/YYYY HH:MI:SS AM'), 'timothy.ward',  TO_Date( '08/13/2012 12:16:04 PM', 'MM/DD/YYYY HH:MI:SS AM')); 
INSERT INTO T_OSI_ATTACHMENT_TYPE ( SID, OBJ_TYPE, USAGE, CODE, DESCRIPTION, MIME_DISPOSITION, MIN_NUM, MAX_NUM, LOCK_MODE, SEQ, ACTIVE, OVERRIDE, CREATE_BY, CREATE_ON, MODIFY_BY, MODIFY_ON ) VALUES ( 
'33318VSY', '222000009LG', 'ATTACHMENT', 'FFORM40', 'Final Signed Form 40', 'ATTACHMENT', NULL, NULL, NULL, NULL, 'Y', 'N', 'timothy.ward',  TO_Date( '08/13/2012 12:16:04 PM', 'MM/DD/YYYY HH:MI:SS AM'), 'timothy.ward',  TO_Date( '08/13/2012 12:16:04 PM', 'MM/DD/YYYY HH:MI:SS AM')); 
INSERT INTO T_OSI_ATTACHMENT_TYPE ( SID, OBJ_TYPE, USAGE, CODE, DESCRIPTION, MIME_DISPOSITION, MIN_NUM, MAX_NUM, LOCK_MODE, SEQ, ACTIVE, OVERRIDE, CREATE_BY, CREATE_ON, MODIFY_BY, MODIFY_ON ) VALUES ( 
'33318VSZ', '222000009LI', 'ATTACHMENT', 'FFORM40', 'Final Signed Form 40', 'ATTACHMENT', NULL, NULL, NULL, NULL, 'Y', 'N', 'timothy.ward',  TO_Date( '08/13/2012 12:16:04 PM', 'MM/DD/YYYY HH:MI:SS AM'), 'timothy.ward',  TO_Date( '08/13/2012 12:16:04 PM', 'MM/DD/YYYY HH:MI:SS AM')); 
INSERT INTO T_OSI_ATTACHMENT_TYPE ( SID, OBJ_TYPE, USAGE, CODE, DESCRIPTION, MIME_DISPOSITION, MIN_NUM, MAX_NUM, LOCK_MODE, SEQ, ACTIVE, OVERRIDE, CREATE_BY, CREATE_ON, MODIFY_BY, MODIFY_ON ) VALUES ( 
'33318VT0', '222000009LJ', 'ATTACHMENT', 'FFORM40', 'Final Signed Form 40', 'ATTACHMENT', NULL, NULL, NULL, NULL, 'Y', 'N', 'timothy.ward',  TO_Date( '08/13/2012 12:16:04 PM', 'MM/DD/YYYY HH:MI:SS AM'), 'timothy.ward',  TO_Date( '08/13/2012 12:16:04 PM', 'MM/DD/YYYY HH:MI:SS AM')); 
INSERT INTO T_OSI_ATTACHMENT_TYPE ( SID, OBJ_TYPE, USAGE, CODE, DESCRIPTION, MIME_DISPOSITION, MIN_NUM, MAX_NUM, LOCK_MODE, SEQ, ACTIVE, OVERRIDE, CREATE_BY, CREATE_ON, MODIFY_BY, MODIFY_ON ) VALUES ( 
'33318VT1', '22200000CY0', 'ATTACHMENT', 'FFORM40', 'Final Signed Form 40', 'ATTACHMENT', NULL, NULL, NULL, NULL, 'Y', 'N', 'timothy.ward',  TO_Date( '08/13/2012 12:16:04 PM', 'MM/DD/YYYY HH:MI:SS AM'), 'timothy.ward',  TO_Date( '08/13/2012 12:16:04 PM', 'MM/DD/YYYY HH:MI:SS AM')); 
INSERT INTO T_OSI_ATTACHMENT_TYPE ( SID, OBJ_TYPE, USAGE, CODE, DESCRIPTION, MIME_DISPOSITION, MIN_NUM, MAX_NUM, LOCK_MODE, SEQ, ACTIVE, OVERRIDE, CREATE_BY, CREATE_ON, MODIFY_BY, MODIFY_ON ) VALUES ( 
'33318VT2', '22200000GFD', 'ATTACHMENT', 'FFORM40', 'Final Signed Form 40', 'ATTACHMENT', NULL, NULL, NULL, NULL, 'Y', 'N', 'timothy.ward',  TO_Date( '08/13/2012 12:16:04 PM', 'MM/DD/YYYY HH:MI:SS AM'), 'timothy.ward',  TO_Date( '08/13/2012 12:16:04 PM', 'MM/DD/YYYY HH:MI:SS AM')); 
INSERT INTO T_OSI_ATTACHMENT_TYPE ( SID, OBJ_TYPE, USAGE, CODE, DESCRIPTION, MIME_DISPOSITION, MIN_NUM, MAX_NUM, LOCK_MODE, SEQ, ACTIVE, OVERRIDE, CREATE_BY, CREATE_ON, MODIFY_BY, MODIFY_ON ) VALUES ( 
'33318VT3', '22200000HLH', 'ATTACHMENT', 'FFORM40', 'Final Signed Form 40', 'ATTACHMENT', NULL, NULL, NULL, NULL, 'Y', 'N', 'timothy.ward',  TO_Date( '08/13/2012 12:16:04 PM', 'MM/DD/YYYY HH:MI:SS AM'), 'timothy.ward',  TO_Date( '08/13/2012 12:16:04 PM', 'MM/DD/YYYY HH:MI:SS AM')); 
INSERT INTO T_OSI_ATTACHMENT_TYPE ( SID, OBJ_TYPE, USAGE, CODE, DESCRIPTION, MIME_DISPOSITION, MIN_NUM, MAX_NUM, LOCK_MODE, SEQ, ACTIVE, OVERRIDE, CREATE_BY, CREATE_ON, MODIFY_BY, MODIFY_ON ) VALUES ( 
'33318VT4', '22200000HLP', 'ATTACHMENT', 'FFORM40', 'Final Signed Form 40', 'ATTACHMENT', NULL, NULL, NULL, NULL, 'Y', 'N', 'timothy.ward',  TO_Date( '08/13/2012 12:16:04 PM', 'MM/DD/YYYY HH:MI:SS AM'), 'timothy.ward',  TO_Date( '08/13/2012 12:16:04 PM', 'MM/DD/YYYY HH:MI:SS AM')); 
INSERT INTO T_OSI_ATTACHMENT_TYPE ( SID, OBJ_TYPE, USAGE, CODE, DESCRIPTION, MIME_DISPOSITION, MIN_NUM, MAX_NUM, LOCK_MODE, SEQ, ACTIVE, OVERRIDE, CREATE_BY, CREATE_ON, MODIFY_BY, MODIFY_ON ) VALUES ( 
'33318VT5', '22200000HNQ', 'ATTACHMENT', 'FFORM40', 'Final Signed Form 40', 'ATTACHMENT', NULL, NULL, NULL, NULL, 'Y', 'N', 'timothy.ward',  TO_Date( '08/13/2012 12:16:04 PM', 'MM/DD/YYYY HH:MI:SS AM'), 'timothy.ward',  TO_Date( '08/13/2012 12:16:04 PM', 'MM/DD/YYYY HH:MI:SS AM')); 
INSERT INTO T_OSI_ATTACHMENT_TYPE ( SID, OBJ_TYPE, USAGE, CODE, DESCRIPTION, MIME_DISPOSITION, MIN_NUM, MAX_NUM, LOCK_MODE, SEQ, ACTIVE, OVERRIDE, CREATE_BY, CREATE_ON, MODIFY_BY, MODIFY_ON ) VALUES ( 
'33318VT6', '22200000HNR', 'ATTACHMENT', 'FFORM40', 'Final Signed Form 40', 'ATTACHMENT', NULL, NULL, NULL, NULL, 'Y', 'N', 'timothy.ward',  TO_Date( '08/13/2012 12:16:04 PM', 'MM/DD/YYYY HH:MI:SS AM'), 'timothy.ward',  TO_Date( '08/13/2012 12:16:04 PM', 'MM/DD/YYYY HH:MI:SS AM')); 
INSERT INTO T_OSI_ATTACHMENT_TYPE ( SID, OBJ_TYPE, USAGE, CODE, DESCRIPTION, MIME_DISPOSITION, MIN_NUM, MAX_NUM, LOCK_MODE, SEQ, ACTIVE, OVERRIDE, CREATE_BY, CREATE_ON, MODIFY_BY, MODIFY_ON ) VALUES ( 
'33318VT7', '22200000HNS', 'ATTACHMENT', 'FFORM40', 'Final Signed Form 40', 'ATTACHMENT', NULL, NULL, NULL, NULL, 'Y', 'N', 'timothy.ward',  TO_Date( '08/13/2012 12:16:04 PM', 'MM/DD/YYYY HH:MI:SS AM'), 'timothy.ward',  TO_Date( '08/13/2012 12:16:04 PM', 'MM/DD/YYYY HH:MI:SS AM')); 
INSERT INTO T_OSI_ATTACHMENT_TYPE ( SID, OBJ_TYPE, USAGE, CODE, DESCRIPTION, MIME_DISPOSITION, MIN_NUM, MAX_NUM, LOCK_MODE, SEQ, ACTIVE, OVERRIDE, CREATE_BY, CREATE_ON, MODIFY_BY, MODIFY_ON ) VALUES ( 
'33318VT8', '22200000HNT', 'ATTACHMENT', 'FFORM40', 'Final Signed Form 40', 'ATTACHMENT', NULL, NULL, NULL, NULL, 'Y', 'N', 'timothy.ward',  TO_Date( '08/13/2012 12:16:04 PM', 'MM/DD/YYYY HH:MI:SS AM'), 'timothy.ward',  TO_Date( '08/13/2012 12:16:04 PM', 'MM/DD/YYYY HH:MI:SS AM')); 
INSERT INTO T_OSI_ATTACHMENT_TYPE ( SID, OBJ_TYPE, USAGE, CODE, DESCRIPTION, MIME_DISPOSITION, MIN_NUM, MAX_NUM, LOCK_MODE, SEQ, ACTIVE, OVERRIDE, CREATE_BY, CREATE_ON, MODIFY_BY, MODIFY_ON ) VALUES ( 
'33318VT9', '22200000HNU', 'ATTACHMENT', 'FFORM40', 'Final Signed Form 40', 'ATTACHMENT', NULL, NULL, NULL, NULL, 'Y', 'N', 'timothy.ward',  TO_Date( '08/13/2012 12:16:04 PM', 'MM/DD/YYYY HH:MI:SS AM'), 'timothy.ward',  TO_Date( '08/13/2012 12:16:04 PM', 'MM/DD/YYYY HH:MI:SS AM')); 
INSERT INTO T_OSI_ATTACHMENT_TYPE ( SID, OBJ_TYPE, USAGE, CODE, DESCRIPTION, MIME_DISPOSITION, MIN_NUM, MAX_NUM, LOCK_MODE, SEQ, ACTIVE, OVERRIDE, CREATE_BY, CREATE_ON, MODIFY_BY, MODIFY_ON ) VALUES ( 
'33318VTA', '22200000HNV', 'ATTACHMENT', 'FFORM40', 'Final Signed Form 40', 'ATTACHMENT', NULL, NULL, NULL, NULL, 'Y', 'N', 'timothy.ward',  TO_Date( '08/13/2012 12:16:04 PM', 'MM/DD/YYYY HH:MI:SS AM'), 'timothy.ward',  TO_Date( '08/13/2012 12:16:04 PM', 'MM/DD/YYYY HH:MI:SS AM')); 
INSERT INTO T_OSI_ATTACHMENT_TYPE ( SID, OBJ_TYPE, USAGE, CODE, DESCRIPTION, MIME_DISPOSITION, MIN_NUM, MAX_NUM, LOCK_MODE, SEQ, ACTIVE, OVERRIDE, CREATE_BY, CREATE_ON, MODIFY_BY, MODIFY_ON ) VALUES ( 
'33318VTB', '22200000HNW', 'ATTACHMENT', 'FFORM40', 'Final Signed Form 40', 'ATTACHMENT', NULL, NULL, NULL, NULL, 'Y', 'N', 'timothy.ward',  TO_Date( '08/13/2012 12:16:04 PM', 'MM/DD/YYYY HH:MI:SS AM'), 'timothy.ward',  TO_Date( '08/13/2012 12:16:04 PM', 'MM/DD/YYYY HH:MI:SS AM')); 
INSERT INTO T_OSI_ATTACHMENT_TYPE ( SID, OBJ_TYPE, USAGE, CODE, DESCRIPTION, MIME_DISPOSITION, MIN_NUM, MAX_NUM, LOCK_MODE, SEQ, ACTIVE, OVERRIDE, CREATE_BY, CREATE_ON, MODIFY_BY, MODIFY_ON ) VALUES ( 
'33318VTC', '22200000HNX', 'ATTACHMENT', 'FFORM40', 'Final Signed Form 40', 'ATTACHMENT', NULL, NULL, NULL, NULL, 'Y', 'N', 'timothy.ward',  TO_Date( '08/13/2012 12:16:04 PM', 'MM/DD/YYYY HH:MI:SS AM'), 'timothy.ward',  TO_Date( '08/13/2012 12:16:04 PM', 'MM/DD/YYYY HH:MI:SS AM')); 
INSERT INTO T_OSI_ATTACHMENT_TYPE ( SID, OBJ_TYPE, USAGE, CODE, DESCRIPTION, MIME_DISPOSITION, MIN_NUM, MAX_NUM, LOCK_MODE, SEQ, ACTIVE, OVERRIDE, CREATE_BY, CREATE_ON, MODIFY_BY, MODIFY_ON ) VALUES ( 
'33318VTD', '22200000HNY', 'ATTACHMENT', 'FFORM40', 'Final Signed Form 40', 'ATTACHMENT', NULL, NULL, NULL, NULL, 'Y', 'N', 'timothy.ward',  TO_Date( '08/13/2012 12:16:04 PM', 'MM/DD/YYYY HH:MI:SS AM'), 'timothy.ward',  TO_Date( '08/13/2012 12:16:04 PM', 'MM/DD/YYYY HH:MI:SS AM')); 
INSERT INTO T_OSI_ATTACHMENT_TYPE ( SID, OBJ_TYPE, USAGE, CODE, DESCRIPTION, MIME_DISPOSITION, MIN_NUM, MAX_NUM, LOCK_MODE, SEQ, ACTIVE, OVERRIDE, CREATE_BY, CREATE_ON, MODIFY_BY, MODIFY_ON ) VALUES ( 
'33318VTE', '22200000KZN', 'ATTACHMENT', 'FFORM40', 'Final Signed Form 40', 'ATTACHMENT', NULL, NULL, NULL, NULL, 'Y', 'N', 'timothy.ward',  TO_Date( '08/13/2012 12:16:04 PM', 'MM/DD/YYYY HH:MI:SS AM'), 'timothy.ward',  TO_Date( '08/13/2012 12:16:04 PM', 'MM/DD/YYYY HH:MI:SS AM')); 
INSERT INTO T_OSI_ATTACHMENT_TYPE ( SID, OBJ_TYPE, USAGE, CODE, DESCRIPTION, MIME_DISPOSITION, MIN_NUM, MAX_NUM, LOCK_MODE, SEQ, ACTIVE, OVERRIDE, CREATE_BY, CREATE_ON, MODIFY_BY, MODIFY_ON ) VALUES ( 
'33318VTF', '22200000L63', 'ATTACHMENT', 'FFORM40', 'Final Signed Form 40', 'ATTACHMENT', NULL, NULL, NULL, NULL, 'Y', 'N', 'timothy.ward',  TO_Date( '08/13/2012 12:16:04 PM', 'MM/DD/YYYY HH:MI:SS AM'), 'timothy.ward',  TO_Date( '08/13/2012 12:16:04 PM', 'MM/DD/YYYY HH:MI:SS AM')); 
INSERT INTO T_OSI_ATTACHMENT_TYPE ( SID, OBJ_TYPE, USAGE, CODE, DESCRIPTION, MIME_DISPOSITION, MIN_NUM, MAX_NUM, LOCK_MODE, SEQ, ACTIVE, OVERRIDE, CREATE_BY, CREATE_ON, MODIFY_BY, MODIFY_ON ) VALUES ( 
'33318VTG', '22200000LBC', 'ATTACHMENT', 'FFORM40', 'Final Signed Form 40', 'ATTACHMENT', NULL, NULL, NULL, NULL, 'Y', 'N', 'timothy.ward',  TO_Date( '08/13/2012 12:16:04 PM', 'MM/DD/YYYY HH:MI:SS AM'), 'timothy.ward',  TO_Date( '08/13/2012 12:16:04 PM', 'MM/DD/YYYY HH:MI:SS AM')); 
INSERT INTO T_OSI_ATTACHMENT_TYPE ( SID, OBJ_TYPE, USAGE, CODE, DESCRIPTION, MIME_DISPOSITION, MIN_NUM, MAX_NUM, LOCK_MODE, SEQ, ACTIVE, OVERRIDE, CREATE_BY, CREATE_ON, MODIFY_BY, MODIFY_ON ) VALUES ( 
'33318VTH', '22200000LBD', 'ATTACHMENT', 'FFORM40', 'Final Signed Form 40', 'ATTACHMENT', NULL, NULL, NULL, NULL, 'Y', 'N', 'timothy.ward',  TO_Date( '08/13/2012 12:16:04 PM', 'MM/DD/YYYY HH:MI:SS AM'), 'timothy.ward',  TO_Date( '08/13/2012 12:16:04 PM', 'MM/DD/YYYY HH:MI:SS AM')); 
INSERT INTO T_OSI_ATTACHMENT_TYPE ( SID, OBJ_TYPE, USAGE, CODE, DESCRIPTION, MIME_DISPOSITION, MIN_NUM, MAX_NUM, LOCK_MODE, SEQ, ACTIVE, OVERRIDE, CREATE_BY, CREATE_ON, MODIFY_BY, MODIFY_ON ) VALUES ( 
'33318VTI', '22200000LBE', 'ATTACHMENT', 'FFORM40', 'Final Signed Form 40', 'ATTACHMENT', NULL, NULL, NULL, NULL, 'Y', 'N', 'timothy.ward',  TO_Date( '08/13/2012 12:16:04 PM', 'MM/DD/YYYY HH:MI:SS AM'), 'timothy.ward',  TO_Date( '08/13/2012 12:16:04 PM', 'MM/DD/YYYY HH:MI:SS AM')); 
INSERT INTO T_OSI_ATTACHMENT_TYPE ( SID, OBJ_TYPE, USAGE, CODE, DESCRIPTION, MIME_DISPOSITION, MIN_NUM, MAX_NUM, LOCK_MODE, SEQ, ACTIVE, OVERRIDE, CREATE_BY, CREATE_ON, MODIFY_BY, MODIFY_ON ) VALUES ( 
'33318VTJ', '22200000M3T', 'ATTACHMENT', 'FFORM40', 'Final Signed Form 40', 'ATTACHMENT', NULL, NULL, NULL, NULL, 'Y', 'N', 'timothy.ward',  TO_Date( '08/13/2012 12:16:04 PM', 'MM/DD/YYYY HH:MI:SS AM'), 'timothy.ward',  TO_Date( '08/13/2012 12:16:04 PM', 'MM/DD/YYYY HH:MI:SS AM')); 
INSERT INTO T_OSI_ATTACHMENT_TYPE ( SID, OBJ_TYPE, USAGE, CODE, DESCRIPTION, MIME_DISPOSITION, MIN_NUM, MAX_NUM, LOCK_MODE, SEQ, ACTIVE, OVERRIDE, CREATE_BY, CREATE_ON, MODIFY_BY, MODIFY_ON ) VALUES ( 
'33318VTK', '22200000M8R', 'ATTACHMENT', 'FFORM40', 'Final Signed Form 40', 'ATTACHMENT', NULL, NULL, NULL, NULL, 'Y', 'N', 'timothy.ward',  TO_Date( '08/13/2012 12:16:04 PM', 'MM/DD/YYYY HH:MI:SS AM'), 'timothy.ward',  TO_Date( '08/13/2012 12:16:04 PM', 'MM/DD/YYYY HH:MI:SS AM')); 
INSERT INTO T_OSI_ATTACHMENT_TYPE ( SID, OBJ_TYPE, USAGE, CODE, DESCRIPTION, MIME_DISPOSITION, MIN_NUM, MAX_NUM, LOCK_MODE, SEQ, ACTIVE, OVERRIDE, CREATE_BY, CREATE_ON, MODIFY_BY, MODIFY_ON ) VALUES ( 
'33318VTL', '22200000M8S', 'ATTACHMENT', 'FFORM40', 'Final Signed Form 40', 'ATTACHMENT', NULL, NULL, NULL, NULL, 'Y', 'N', 'timothy.ward',  TO_Date( '08/13/2012 12:16:04 PM', 'MM/DD/YYYY HH:MI:SS AM'), 'timothy.ward',  TO_Date( '08/13/2012 12:16:04 PM', 'MM/DD/YYYY HH:MI:SS AM')); 
INSERT INTO T_OSI_ATTACHMENT_TYPE ( SID, OBJ_TYPE, USAGE, CODE, DESCRIPTION, MIME_DISPOSITION, MIN_NUM, MAX_NUM, LOCK_MODE, SEQ, ACTIVE, OVERRIDE, CREATE_BY, CREATE_ON, MODIFY_BY, MODIFY_ON ) VALUES ( 
'33318VTM', '22200000M8T', 'ATTACHMENT', 'FFORM40', 'Final Signed Form 40', 'ATTACHMENT', NULL, NULL, NULL, NULL, 'Y', 'N', 'timothy.ward',  TO_Date( '08/13/2012 12:16:04 PM', 'MM/DD/YYYY HH:MI:SS AM'), 'timothy.ward',  TO_Date( '08/13/2012 12:16:04 PM', 'MM/DD/YYYY HH:MI:SS AM')); 
INSERT INTO T_OSI_ATTACHMENT_TYPE ( SID, OBJ_TYPE, USAGE, CODE, DESCRIPTION, MIME_DISPOSITION, MIN_NUM, MAX_NUM, LOCK_MODE, SEQ, ACTIVE, OVERRIDE, CREATE_BY, CREATE_ON, MODIFY_BY, MODIFY_ON ) VALUES ( 
'33318VTN', '22200000M8U', 'ATTACHMENT', 'FFORM40', 'Final Signed Form 40', 'ATTACHMENT', NULL, NULL, NULL, NULL, 'Y', 'N', 'timothy.ward',  TO_Date( '08/13/2012 12:16:04 PM', 'MM/DD/YYYY HH:MI:SS AM'), 'timothy.ward',  TO_Date( '08/13/2012 12:16:04 PM', 'MM/DD/YYYY HH:MI:SS AM')); 
INSERT INTO T_OSI_ATTACHMENT_TYPE ( SID, OBJ_TYPE, USAGE, CODE, DESCRIPTION, MIME_DISPOSITION, MIN_NUM, MAX_NUM, LOCK_MODE, SEQ, ACTIVE, OVERRIDE, CREATE_BY, CREATE_ON, MODIFY_BY, MODIFY_ON ) VALUES ( 
'33318VTO', '22200000M8V', 'ATTACHMENT', 'FFORM40', 'Final Signed Form 40', 'ATTACHMENT', NULL, NULL, NULL, NULL, 'Y', 'N', 'timothy.ward',  TO_Date( '08/13/2012 12:16:04 PM', 'MM/DD/YYYY HH:MI:SS AM'), 'timothy.ward',  TO_Date( '08/13/2012 12:16:04 PM', 'MM/DD/YYYY HH:MI:SS AM')); 
INSERT INTO T_OSI_ATTACHMENT_TYPE ( SID, OBJ_TYPE, USAGE, CODE, DESCRIPTION, MIME_DISPOSITION, MIN_NUM, MAX_NUM, LOCK_MODE, SEQ, ACTIVE, OVERRIDE, CREATE_BY, CREATE_ON, MODIFY_BY, MODIFY_ON ) VALUES ( 
'33318VTP', '22200000M8W', 'ATTACHMENT', 'FFORM40', 'Final Signed Form 40', 'ATTACHMENT', NULL, NULL, NULL, NULL, 'Y', 'N', 'timothy.ward',  TO_Date( '08/13/2012 12:16:04 PM', 'MM/DD/YYYY HH:MI:SS AM'), 'timothy.ward',  TO_Date( '08/13/2012 12:16:04 PM', 'MM/DD/YYYY HH:MI:SS AM')); 
INSERT INTO T_OSI_ATTACHMENT_TYPE ( SID, OBJ_TYPE, USAGE, CODE, DESCRIPTION, MIME_DISPOSITION, MIN_NUM, MAX_NUM, LOCK_MODE, SEQ, ACTIVE, OVERRIDE, CREATE_BY, CREATE_ON, MODIFY_BY, MODIFY_ON ) VALUES ( 
'33318VTQ', '22200000MBN', 'ATTACHMENT', 'FFORM40', 'Final Signed Form 40', 'ATTACHMENT', NULL, NULL, NULL, NULL, 'Y', 'N', 'timothy.ward',  TO_Date( '08/13/2012 12:16:04 PM', 'MM/DD/YYYY HH:MI:SS AM'), 'timothy.ward',  TO_Date( '08/13/2012 12:16:04 PM', 'MM/DD/YYYY HH:MI:SS AM')); 
INSERT INTO T_OSI_ATTACHMENT_TYPE ( SID, OBJ_TYPE, USAGE, CODE, DESCRIPTION, MIME_DISPOSITION, MIN_NUM, MAX_NUM, LOCK_MODE, SEQ, ACTIVE, OVERRIDE, CREATE_BY, CREATE_ON, MODIFY_BY, MODIFY_ON ) VALUES ( 
'33318VTR', '22200000MS7', 'ATTACHMENT', 'FFORM40', 'Final Signed Form 40', 'ATTACHMENT', NULL, NULL, NULL, NULL, 'Y', 'N', 'timothy.ward',  TO_Date( '08/13/2012 12:16:04 PM', 'MM/DD/YYYY HH:MI:SS AM'), 'timothy.ward',  TO_Date( '08/13/2012 12:16:04 PM', 'MM/DD/YYYY HH:MI:SS AM')); 
INSERT INTO T_OSI_ATTACHMENT_TYPE ( SID, OBJ_TYPE, USAGE, CODE, DESCRIPTION, MIME_DISPOSITION, MIN_NUM, MAX_NUM, LOCK_MODE, SEQ, ACTIVE, OVERRIDE, CREATE_BY, CREATE_ON, MODIFY_BY, MODIFY_ON ) VALUES ( 
'33318VTS', '22200000MT9', 'ATTACHMENT', 'FFORM40', 'Final Signed Form 40', 'ATTACHMENT', NULL, NULL, NULL, NULL, 'Y', 'N', 'timothy.ward',  TO_Date( '08/13/2012 12:16:04 PM', 'MM/DD/YYYY HH:MI:SS AM'), 'timothy.ward',  TO_Date( '08/13/2012 12:16:04 PM', 'MM/DD/YYYY HH:MI:SS AM')); 
INSERT INTO T_OSI_ATTACHMENT_TYPE ( SID, OBJ_TYPE, USAGE, CODE, DESCRIPTION, MIME_DISPOSITION, MIN_NUM, MAX_NUM, LOCK_MODE, SEQ, ACTIVE, OVERRIDE, CREATE_BY, CREATE_ON, MODIFY_BY, MODIFY_ON ) VALUES ( 
'33318VTT', '22200000MTA', 'ATTACHMENT', 'FFORM40', 'Final Signed Form 40', 'ATTACHMENT', NULL, NULL, NULL, NULL, 'Y', 'N', 'timothy.ward',  TO_Date( '08/13/2012 12:16:04 PM', 'MM/DD/YYYY HH:MI:SS AM'), 'timothy.ward',  TO_Date( '08/13/2012 12:16:04 PM', 'MM/DD/YYYY HH:MI:SS AM')); 
INSERT INTO T_OSI_ATTACHMENT_TYPE ( SID, OBJ_TYPE, USAGE, CODE, DESCRIPTION, MIME_DISPOSITION, MIN_NUM, MAX_NUM, LOCK_MODE, SEQ, ACTIVE, OVERRIDE, CREATE_BY, CREATE_ON, MODIFY_BY, MODIFY_ON ) VALUES ( 
'33318VTU', '22200000MTB', 'ATTACHMENT', 'FFORM40', 'Final Signed Form 40', 'ATTACHMENT', NULL, NULL, NULL, NULL, 'Y', 'N', 'timothy.ward',  TO_Date( '08/13/2012 12:16:04 PM', 'MM/DD/YYYY HH:MI:SS AM'), 'timothy.ward',  TO_Date( '08/13/2012 12:16:04 PM', 'MM/DD/YYYY HH:MI:SS AM')); 
INSERT INTO T_OSI_ATTACHMENT_TYPE ( SID, OBJ_TYPE, USAGE, CODE, DESCRIPTION, MIME_DISPOSITION, MIN_NUM, MAX_NUM, LOCK_MODE, SEQ, ACTIVE, OVERRIDE, CREATE_BY, CREATE_ON, MODIFY_BY, MODIFY_ON ) VALUES ( 
'33318VTV', '22200000MTV', 'ATTACHMENT', 'FFORM40', 'Final Signed Form 40', 'ATTACHMENT', NULL, NULL, NULL, NULL, 'Y', 'N', 'timothy.ward',  TO_Date( '08/13/2012 12:16:04 PM', 'MM/DD/YYYY HH:MI:SS AM'), 'timothy.ward',  TO_Date( '08/13/2012 12:16:04 PM', 'MM/DD/YYYY HH:MI:SS AM')); 
INSERT INTO T_OSI_ATTACHMENT_TYPE ( SID, OBJ_TYPE, USAGE, CODE, DESCRIPTION, MIME_DISPOSITION, MIN_NUM, MAX_NUM, LOCK_MODE, SEQ, ACTIVE, OVERRIDE, CREATE_BY, CREATE_ON, MODIFY_BY, MODIFY_ON ) VALUES ( 
'33318VTW', '22200000MTW', 'ATTACHMENT', 'FFORM40', 'Final Signed Form 40', 'ATTACHMENT', NULL, NULL, NULL, NULL, 'Y', 'N', 'timothy.ward',  TO_Date( '08/13/2012 12:16:04 PM', 'MM/DD/YYYY HH:MI:SS AM'), 'timothy.ward',  TO_Date( '08/13/2012 12:16:04 PM', 'MM/DD/YYYY HH:MI:SS AM')); 
INSERT INTO T_OSI_ATTACHMENT_TYPE ( SID, OBJ_TYPE, USAGE, CODE, DESCRIPTION, MIME_DISPOSITION, MIN_NUM, MAX_NUM, LOCK_MODE, SEQ, ACTIVE, OVERRIDE, CREATE_BY, CREATE_ON, MODIFY_BY, MODIFY_ON ) VALUES ( 
'33318VTX', '22200000MTX', 'ATTACHMENT', 'FFORM40', 'Final Signed Form 40', 'ATTACHMENT', NULL, NULL, NULL, NULL, 'Y', 'N', 'timothy.ward',  TO_Date( '08/13/2012 12:16:04 PM', 'MM/DD/YYYY HH:MI:SS AM'), 'timothy.ward',  TO_Date( '08/13/2012 12:16:04 PM', 'MM/DD/YYYY HH:MI:SS AM')); 
INSERT INTO T_OSI_ATTACHMENT_TYPE ( SID, OBJ_TYPE, USAGE, CODE, DESCRIPTION, MIME_DISPOSITION, MIN_NUM, MAX_NUM, LOCK_MODE, SEQ, ACTIVE, OVERRIDE, CREATE_BY, CREATE_ON, MODIFY_BY, MODIFY_ON ) VALUES ( 
'33318VTY', '22200000MTY', 'ATTACHMENT', 'FFORM40', 'Final Signed Form 40', 'ATTACHMENT', NULL, NULL, NULL, NULL, 'Y', 'N', 'timothy.ward',  TO_Date( '08/13/2012 12:16:04 PM', 'MM/DD/YYYY HH:MI:SS AM'), 'timothy.ward',  TO_Date( '08/13/2012 12:16:04 PM', 'MM/DD/YYYY HH:MI:SS AM')); 
INSERT INTO T_OSI_ATTACHMENT_TYPE ( SID, OBJ_TYPE, USAGE, CODE, DESCRIPTION, MIME_DISPOSITION, MIN_NUM, MAX_NUM, LOCK_MODE, SEQ, ACTIVE, OVERRIDE, CREATE_BY, CREATE_ON, MODIFY_BY, MODIFY_ON ) VALUES ( 
'33318VTZ', '22200000MTZ', 'ATTACHMENT', 'FFORM40', 'Final Signed Form 40', 'ATTACHMENT', NULL, NULL, NULL, NULL, 'Y', 'N', 'timothy.ward',  TO_Date( '08/13/2012 12:16:04 PM', 'MM/DD/YYYY HH:MI:SS AM'), 'timothy.ward',  TO_Date( '08/13/2012 12:16:04 PM', 'MM/DD/YYYY HH:MI:SS AM')); 
INSERT INTO T_OSI_ATTACHMENT_TYPE ( SID, OBJ_TYPE, USAGE, CODE, DESCRIPTION, MIME_DISPOSITION, MIN_NUM, MAX_NUM, LOCK_MODE, SEQ, ACTIVE, OVERRIDE, CREATE_BY, CREATE_ON, MODIFY_BY, MODIFY_ON ) VALUES ( 
'33318VU0', '22200000P2A', 'ATTACHMENT', 'FFORM40', 'Final Signed Form 40', 'ATTACHMENT', NULL, NULL, NULL, NULL, 'Y', 'N', 'timothy.ward',  TO_Date( '08/13/2012 12:16:04 PM', 'MM/DD/YYYY HH:MI:SS AM'), 'timothy.ward',  TO_Date( '08/13/2012 12:16:04 PM', 'MM/DD/YYYY HH:MI:SS AM')); 
INSERT INTO T_OSI_ATTACHMENT_TYPE ( SID, OBJ_TYPE, USAGE, CODE, DESCRIPTION, MIME_DISPOSITION, MIN_NUM, MAX_NUM, LOCK_MODE, SEQ, ACTIVE, OVERRIDE, CREATE_BY, CREATE_ON, MODIFY_BY, MODIFY_ON ) VALUES ( 
'33318VU1', '22200000Q7A', 'ATTACHMENT', 'FFORM40', 'Final Signed Form 40', 'ATTACHMENT', NULL, NULL, NULL, NULL, 'Y', 'N', 'timothy.ward',  TO_Date( '08/13/2012 12:16:04 PM', 'MM/DD/YYYY HH:MI:SS AM'), 'timothy.ward',  TO_Date( '08/13/2012 12:16:04 PM', 'MM/DD/YYYY HH:MI:SS AM')); 
INSERT INTO T_OSI_ATTACHMENT_TYPE ( SID, OBJ_TYPE, USAGE, CODE, DESCRIPTION, MIME_DISPOSITION, MIN_NUM, MAX_NUM, LOCK_MODE, SEQ, ACTIVE, OVERRIDE, CREATE_BY, CREATE_ON, MODIFY_BY, MODIFY_ON ) VALUES ( 
'33318VU2', '22200000Q7B', 'ATTACHMENT', 'FFORM40', 'Final Signed Form 40', 'ATTACHMENT', NULL, NULL, NULL, NULL, 'Y', 'N', 'timothy.ward',  TO_Date( '08/13/2012 12:16:04 PM', 'MM/DD/YYYY HH:MI:SS AM'), 'timothy.ward',  TO_Date( '08/13/2012 12:16:04 PM', 'MM/DD/YYYY HH:MI:SS AM')); 
INSERT INTO T_OSI_ATTACHMENT_TYPE ( SID, OBJ_TYPE, USAGE, CODE, DESCRIPTION, MIME_DISPOSITION, MIN_NUM, MAX_NUM, LOCK_MODE, SEQ, ACTIVE, OVERRIDE, CREATE_BY, CREATE_ON, MODIFY_BY, MODIFY_ON ) VALUES ( 
'33318VU3', '22200000Q7C', 'ATTACHMENT', 'FFORM40', 'Final Signed Form 40', 'ATTACHMENT', NULL, NULL, NULL, NULL, 'Y', 'N', 'timothy.ward',  TO_Date( '08/13/2012 12:16:04 PM', 'MM/DD/YYYY HH:MI:SS AM'), 'timothy.ward',  TO_Date( '08/13/2012 12:16:04 PM', 'MM/DD/YYYY HH:MI:SS AM')); 
INSERT INTO T_OSI_ATTACHMENT_TYPE ( SID, OBJ_TYPE, USAGE, CODE, DESCRIPTION, MIME_DISPOSITION, MIN_NUM, MAX_NUM, LOCK_MODE, SEQ, ACTIVE, OVERRIDE, CREATE_BY, CREATE_ON, MODIFY_BY, MODIFY_ON ) VALUES ( 
'33318VU4', '22200000Q7D', 'ATTACHMENT', 'FFORM40', 'Final Signed Form 40', 'ATTACHMENT', NULL, NULL, NULL, NULL, 'Y', 'N', 'timothy.ward',  TO_Date( '08/13/2012 12:16:04 PM', 'MM/DD/YYYY HH:MI:SS AM'), 'timothy.ward',  TO_Date( '08/13/2012 12:16:04 PM', 'MM/DD/YYYY HH:MI:SS AM')); 
INSERT INTO T_OSI_ATTACHMENT_TYPE ( SID, OBJ_TYPE, USAGE, CODE, DESCRIPTION, MIME_DISPOSITION, MIN_NUM, MAX_NUM, LOCK_MODE, SEQ, ACTIVE, OVERRIDE, CREATE_BY, CREATE_ON, MODIFY_BY, MODIFY_ON ) VALUES ( 
'33318VU5', '22200000RWN', 'ATTACHMENT', 'FFORM40', 'Final Signed Form 40', 'ATTACHMENT', NULL, NULL, NULL, NULL, 'Y', 'N', 'timothy.ward',  TO_Date( '08/13/2012 12:16:04 PM', 'MM/DD/YYYY HH:MI:SS AM'), 'timothy.ward',  TO_Date( '08/13/2012 12:16:04 PM', 'MM/DD/YYYY HH:MI:SS AM')); 
INSERT INTO T_OSI_ATTACHMENT_TYPE ( SID, OBJ_TYPE, USAGE, CODE, DESCRIPTION, MIME_DISPOSITION, MIN_NUM, MAX_NUM, LOCK_MODE, SEQ, ACTIVE, OVERRIDE, CREATE_BY, CREATE_ON, MODIFY_BY, MODIFY_ON ) VALUES ( 
'33318VU6', '2220110E', 'ATTACHMENT', 'FFORM40', 'Final Signed Form 40', 'ATTACHMENT', NULL, NULL, NULL, NULL, 'Y', 'N', 'timothy.ward',  TO_Date( '08/13/2012 12:16:04 PM', 'MM/DD/YYYY HH:MI:SS AM'), 'timothy.ward',  TO_Date( '08/13/2012 12:16:04 PM', 'MM/DD/YYYY HH:MI:SS AM')); 
INSERT INTO T_OSI_ATTACHMENT_TYPE ( SID, OBJ_TYPE, USAGE, CODE, DESCRIPTION, MIME_DISPOSITION, MIN_NUM, MAX_NUM, LOCK_MODE, SEQ, ACTIVE, OVERRIDE, CREATE_BY, CREATE_ON, MODIFY_BY, MODIFY_ON ) VALUES ( 
'33318VU7', '2220116Y', 'ATTACHMENT', 'FFORM40', 'Final Signed Form 40', 'ATTACHMENT', NULL, NULL, NULL, NULL, 'Y', 'N', 'timothy.ward',  TO_Date( '08/13/2012 12:16:04 PM', 'MM/DD/YYYY HH:MI:SS AM'), 'timothy.ward',  TO_Date( '08/13/2012 12:16:04 PM', 'MM/DD/YYYY HH:MI:SS AM')); 
INSERT INTO T_OSI_ATTACHMENT_TYPE ( SID, OBJ_TYPE, USAGE, CODE, DESCRIPTION, MIME_DISPOSITION, MIN_NUM, MAX_NUM, LOCK_MODE, SEQ, ACTIVE, OVERRIDE, CREATE_BY, CREATE_ON, MODIFY_BY, MODIFY_ON ) VALUES ( 
'33318VU8', '22201170', 'ATTACHMENT', 'FFORM40', 'Final Signed Form 40', 'ATTACHMENT', NULL, NULL, NULL, NULL, 'Y', 'N', 'timothy.ward',  TO_Date( '08/13/2012 12:16:04 PM', 'MM/DD/YYYY HH:MI:SS AM'), 'timothy.ward',  TO_Date( '08/13/2012 12:16:04 PM', 'MM/DD/YYYY HH:MI:SS AM')); 
INSERT INTO T_OSI_ATTACHMENT_TYPE ( SID, OBJ_TYPE, USAGE, CODE, DESCRIPTION, MIME_DISPOSITION, MIN_NUM, MAX_NUM, LOCK_MODE, SEQ, ACTIVE, OVERRIDE, CREATE_BY, CREATE_ON, MODIFY_BY, MODIFY_ON ) VALUES ( 
'33318VU9', '22201172', 'ATTACHMENT', 'FFORM40', 'Final Signed Form 40', 'ATTACHMENT', NULL, NULL, NULL, NULL, 'Y', 'N', 'timothy.ward',  TO_Date( '08/13/2012 12:16:04 PM', 'MM/DD/YYYY HH:MI:SS AM'), 'timothy.ward',  TO_Date( '08/13/2012 12:16:04 PM', 'MM/DD/YYYY HH:MI:SS AM')); 
INSERT INTO T_OSI_ATTACHMENT_TYPE ( SID, OBJ_TYPE, USAGE, CODE, DESCRIPTION, MIME_DISPOSITION, MIN_NUM, MAX_NUM, LOCK_MODE, SEQ, ACTIVE, OVERRIDE, CREATE_BY, CREATE_ON, MODIFY_BY, MODIFY_ON ) VALUES ( 
'33318VUA', '22203423', 'ATTACHMENT', 'FFORM40', 'Final Signed Form 40', 'ATTACHMENT', NULL, NULL, NULL, NULL, 'Y', 'N', 'timothy.ward',  TO_Date( '08/13/2012 12:16:04 PM', 'MM/DD/YYYY HH:MI:SS AM'), 'timothy.ward',  TO_Date( '08/13/2012 12:16:04 PM', 'MM/DD/YYYY HH:MI:SS AM')); 
INSERT INTO T_OSI_ATTACHMENT_TYPE ( SID, OBJ_TYPE, USAGE, CODE, DESCRIPTION, MIME_DISPOSITION, MIN_NUM, MAX_NUM, LOCK_MODE, SEQ, ACTIVE, OVERRIDE, CREATE_BY, CREATE_ON, MODIFY_BY, MODIFY_ON ) VALUES ( 
'33318VUC', '22203D0A', 'ATTACHMENT', 'FFORM40', 'Final Signed Form 40', 'ATTACHMENT', NULL, NULL, NULL, NULL, 'Y', 'N', 'timothy.ward',  TO_Date( '08/13/2012 12:16:04 PM', 'MM/DD/YYYY HH:MI:SS AM'), 'timothy.ward',  TO_Date( '08/13/2012 12:16:04 PM', 'MM/DD/YYYY HH:MI:SS AM')); 
---INSERT INTO T_OSI_ATTACHMENT_TYPE ( SID, OBJ_TYPE, USAGE, CODE, DESCRIPTION, MIME_DISPOSITION, MIN_NUM, MAX_NUM, LOCK_MODE, SEQ, ACTIVE, OVERRIDE, CREATE_BY, CREATE_ON, MODIFY_BY, MODIFY_ON ) VALUES ( 
---'33318VUD', '33315ZPW', 'ATTACHMENT', 'FFORM40', 'Final Signed Form 40', 'ATTACHMENT', NULL, NULL, NULL, NULL, 'Y', 'N', 'timothy.ward',  TO_Date( '08/13/2012 12:16:04 PM', 'MM/DD/YYYY HH:MI:SS AM'), 'timothy.ward',  TO_Date( '08/13/2012 12:16:04 PM', 'MM/DD/YYYY HH:MI:SS AM')); 
INSERT INTO T_OSI_ATTACHMENT_TYPE ( SID, OBJ_TYPE, USAGE, CODE, DESCRIPTION, MIME_DISPOSITION, MIN_NUM, MAX_NUM, LOCK_MODE, SEQ, ACTIVE, OVERRIDE, CREATE_BY, CREATE_ON, MODIFY_BY, MODIFY_ON ) VALUES ( 
'33318VUE', '333164T0', 'ATTACHMENT', 'FFORM40', 'Final Signed Form 40', 'ATTACHMENT', NULL, NULL, NULL, NULL, 'Y', 'N', 'timothy.ward',  TO_Date( '08/13/2012 12:16:04 PM', 'MM/DD/YYYY HH:MI:SS AM'), 'timothy.ward',  TO_Date( '08/13/2012 12:16:04 PM', 'MM/DD/YYYY HH:MI:SS AM')); 
INSERT INTO T_OSI_ATTACHMENT_TYPE ( SID, OBJ_TYPE, USAGE, CODE, DESCRIPTION, MIME_DISPOSITION, MIN_NUM, MAX_NUM, LOCK_MODE, SEQ, ACTIVE, OVERRIDE, CREATE_BY, CREATE_ON, MODIFY_BY, MODIFY_ON ) VALUES ( 
'33318VUF', '333164T1', 'ATTACHMENT', 'FFORM40', 'Final Signed Form 40', 'ATTACHMENT', NULL, NULL, NULL, NULL, 'Y', 'N', 'timothy.ward',  TO_Date( '08/13/2012 12:16:04 PM', 'MM/DD/YYYY HH:MI:SS AM'), 'timothy.ward',  TO_Date( '08/13/2012 12:16:04 PM', 'MM/DD/YYYY HH:MI:SS AM')); 
INSERT INTO T_OSI_ATTACHMENT_TYPE ( SID, OBJ_TYPE, USAGE, CODE, DESCRIPTION, MIME_DISPOSITION, MIN_NUM, MAX_NUM, LOCK_MODE, SEQ, ACTIVE, OVERRIDE, CREATE_BY, CREATE_ON, MODIFY_BY, MODIFY_ON ) VALUES ( 
'33318VUG', '333164T2', 'ATTACHMENT', 'FFORM40', 'Final Signed Form 40', 'ATTACHMENT', NULL, NULL, NULL, NULL, 'Y', 'N', 'timothy.ward',  TO_Date( '08/13/2012 12:16:04 PM', 'MM/DD/YYYY HH:MI:SS AM'), 'timothy.ward',  TO_Date( '08/13/2012 12:16:04 PM', 'MM/DD/YYYY HH:MI:SS AM')); 
INSERT INTO T_OSI_ATTACHMENT_TYPE ( SID, OBJ_TYPE, USAGE, CODE, DESCRIPTION, MIME_DISPOSITION, MIN_NUM, MAX_NUM, LOCK_MODE, SEQ, ACTIVE, OVERRIDE, CREATE_BY, CREATE_ON, MODIFY_BY, MODIFY_ON ) VALUES ( 
'33318VUH', '33317VAI', 'ATTACHMENT', 'FFORM40', 'Final Signed Form 40', 'ATTACHMENT', NULL, NULL, NULL, NULL, 'Y', 'N', 'timothy.ward',  TO_Date( '08/13/2012 12:16:04 PM', 'MM/DD/YYYY HH:MI:SS AM'), 'timothy.ward',  TO_Date( '08/13/2012 12:16:04 PM', 'MM/DD/YYYY HH:MI:SS AM')); 
INSERT INTO T_OSI_ATTACHMENT_TYPE ( SID, OBJ_TYPE, USAGE, CODE, DESCRIPTION, MIME_DISPOSITION, MIN_NUM, MAX_NUM, LOCK_MODE, SEQ, ACTIVE, OVERRIDE, CREATE_BY, CREATE_ON, MODIFY_BY, MODIFY_ON ) VALUES ( 
'33318VUI', '33317VAJ', 'ATTACHMENT', 'FFORM40', 'Final Signed Form 40', 'ATTACHMENT', NULL, NULL, NULL, NULL, 'Y', 'N', 'timothy.ward',  TO_Date( '08/13/2012 12:16:04 PM', 'MM/DD/YYYY HH:MI:SS AM'), 'timothy.ward',  TO_Date( '08/13/2012 12:16:04 PM', 'MM/DD/YYYY HH:MI:SS AM')); 
INSERT INTO T_OSI_ATTACHMENT_TYPE ( SID, OBJ_TYPE, USAGE, CODE, DESCRIPTION, MIME_DISPOSITION, MIN_NUM, MAX_NUM, LOCK_MODE, SEQ, ACTIVE, OVERRIDE, CREATE_BY, CREATE_ON, MODIFY_BY, MODIFY_ON ) VALUES ( 
'33318VUJ', '33317VAK', 'ATTACHMENT', 'FFORM40', 'Final Signed Form 40', 'ATTACHMENT', NULL, NULL, NULL, NULL, 'Y', 'N', 'timothy.ward',  TO_Date( '08/13/2012 12:16:04 PM', 'MM/DD/YYYY HH:MI:SS AM'), 'timothy.ward',  TO_Date( '08/13/2012 12:16:04 PM', 'MM/DD/YYYY HH:MI:SS AM')); 
INSERT INTO T_OSI_ATTACHMENT_TYPE ( SID, OBJ_TYPE, USAGE, CODE, DESCRIPTION, MIME_DISPOSITION, MIN_NUM, MAX_NUM, LOCK_MODE, SEQ, ACTIVE, OVERRIDE, CREATE_BY, CREATE_ON, MODIFY_BY, MODIFY_ON ) VALUES ( 
'33318VUK', '33317VAL', 'ATTACHMENT', 'FFORM40', 'Final Signed Form 40', 'ATTACHMENT', NULL, NULL, NULL, NULL, 'Y', 'N', 'timothy.ward',  TO_Date( '08/13/2012 12:16:04 PM', 'MM/DD/YYYY HH:MI:SS AM'), 'timothy.ward',  TO_Date( '08/13/2012 12:16:04 PM', 'MM/DD/YYYY HH:MI:SS AM')); 
INSERT INTO T_OSI_ATTACHMENT_TYPE ( SID, OBJ_TYPE, USAGE, CODE, DESCRIPTION, MIME_DISPOSITION, MIN_NUM, MAX_NUM, LOCK_MODE, SEQ, ACTIVE, OVERRIDE, CREATE_BY, CREATE_ON, MODIFY_BY, MODIFY_ON ) VALUES ( 
'33318VUL', '33317VAM', 'ATTACHMENT', 'FFORM40', 'Final Signed Form 40', 'ATTACHMENT', NULL, NULL, NULL, NULL, 'Y', 'N', 'timothy.ward',  TO_Date( '08/13/2012 12:16:04 PM', 'MM/DD/YYYY HH:MI:SS AM'), 'timothy.ward',  TO_Date( '08/13/2012 12:16:04 PM', 'MM/DD/YYYY HH:MI:SS AM')); 
INSERT INTO T_OSI_ATTACHMENT_TYPE ( SID, OBJ_TYPE, USAGE, CODE, DESCRIPTION, MIME_DISPOSITION, MIN_NUM, MAX_NUM, LOCK_MODE, SEQ, ACTIVE, OVERRIDE, CREATE_BY, CREATE_ON, MODIFY_BY, MODIFY_ON ) VALUES ( 
'33318VUM', '33317VAN', 'ATTACHMENT', 'FFORM40', 'Final Signed Form 40', 'ATTACHMENT', NULL, NULL, NULL, NULL, 'Y', 'N', 'timothy.ward',  TO_Date( '08/13/2012 12:16:04 PM', 'MM/DD/YYYY HH:MI:SS AM'), 'timothy.ward',  TO_Date( '08/13/2012 12:16:04 PM', 'MM/DD/YYYY HH:MI:SS AM')); 
INSERT INTO T_OSI_ATTACHMENT_TYPE ( SID, OBJ_TYPE, USAGE, CODE, DESCRIPTION, MIME_DISPOSITION, MIN_NUM, MAX_NUM, LOCK_MODE, SEQ, ACTIVE, OVERRIDE, CREATE_BY, CREATE_ON, MODIFY_BY, MODIFY_ON ) VALUES ( 
'33318VUN', '33317VAO', 'ATTACHMENT', 'FFORM40', 'Final Signed Form 40', 'ATTACHMENT', NULL, NULL, NULL, NULL, 'Y', 'N', 'timothy.ward',  TO_Date( '08/13/2012 12:16:04 PM', 'MM/DD/YYYY HH:MI:SS AM'), 'timothy.ward',  TO_Date( '08/13/2012 12:16:04 PM', 'MM/DD/YYYY HH:MI:SS AM')); 
INSERT INTO T_OSI_ATTACHMENT_TYPE ( SID, OBJ_TYPE, USAGE, CODE, DESCRIPTION, MIME_DISPOSITION, MIN_NUM, MAX_NUM, LOCK_MODE, SEQ, ACTIVE, OVERRIDE, CREATE_BY, CREATE_ON, MODIFY_BY, MODIFY_ON ) VALUES ( 
'33318VUO', '33317VAP', 'ATTACHMENT', 'FFORM40', 'Final Signed Form 40', 'ATTACHMENT', NULL, NULL, NULL, NULL, 'Y', 'N', 'timothy.ward',  TO_Date( '08/13/2012 12:16:04 PM', 'MM/DD/YYYY HH:MI:SS AM'), 'timothy.ward',  TO_Date( '08/13/2012 12:16:04 PM', 'MM/DD/YYYY HH:MI:SS AM')); 
INSERT INTO T_OSI_ATTACHMENT_TYPE ( SID, OBJ_TYPE, USAGE, CODE, DESCRIPTION, MIME_DISPOSITION, MIN_NUM, MAX_NUM, LOCK_MODE, SEQ, ACTIVE, OVERRIDE, CREATE_BY, CREATE_ON, MODIFY_BY, MODIFY_ON ) VALUES ( 
'33318VUP', '33317VAQ', 'ATTACHMENT', 'FFORM40', 'Final Signed Form 40', 'ATTACHMENT', NULL, NULL, NULL, NULL, 'Y', 'N', 'timothy.ward',  TO_Date( '08/13/2012 12:16:04 PM', 'MM/DD/YYYY HH:MI:SS AM'), 'timothy.ward',  TO_Date( '08/13/2012 12:16:04 PM', 'MM/DD/YYYY HH:MI:SS AM')); 
INSERT INTO T_OSI_ATTACHMENT_TYPE ( SID, OBJ_TYPE, USAGE, CODE, DESCRIPTION, MIME_DISPOSITION, MIN_NUM, MAX_NUM, LOCK_MODE, SEQ, ACTIVE, OVERRIDE, CREATE_BY, CREATE_ON, MODIFY_BY, MODIFY_ON ) VALUES ( 
'33318VUQ', '33317VAR', 'ATTACHMENT', 'FFORM40', 'Final Signed Form 40', 'ATTACHMENT', NULL, NULL, NULL, NULL, 'Y', 'N', 'timothy.ward',  TO_Date( '08/13/2012 12:16:04 PM', 'MM/DD/YYYY HH:MI:SS AM'), 'timothy.ward',  TO_Date( '08/13/2012 12:16:04 PM', 'MM/DD/YYYY HH:MI:SS AM')); 
INSERT INTO T_OSI_ATTACHMENT_TYPE ( SID, OBJ_TYPE, USAGE, CODE, DESCRIPTION, MIME_DISPOSITION, MIN_NUM, MAX_NUM, LOCK_MODE, SEQ, ACTIVE, OVERRIDE, CREATE_BY, CREATE_ON, MODIFY_BY, MODIFY_ON ) VALUES ( 
'33318VUR', '33317VAS', 'ATTACHMENT', 'FFORM40', 'Final Signed Form 40', 'ATTACHMENT', NULL, NULL, NULL, NULL, 'Y', 'N', 'timothy.ward',  TO_Date( '08/13/2012 12:16:04 PM', 'MM/DD/YYYY HH:MI:SS AM'), 'timothy.ward',  TO_Date( '08/13/2012 12:16:04 PM', 'MM/DD/YYYY HH:MI:SS AM')); 
INSERT INTO T_OSI_ATTACHMENT_TYPE ( SID, OBJ_TYPE, USAGE, CODE, DESCRIPTION, MIME_DISPOSITION, MIN_NUM, MAX_NUM, LOCK_MODE, SEQ, ACTIVE, OVERRIDE, CREATE_BY, CREATE_ON, MODIFY_BY, MODIFY_ON ) VALUES ( 
'33318VUS', '33317VAT', 'ATTACHMENT', 'FFORM40', 'Final Signed Form 40', 'ATTACHMENT', NULL, NULL, NULL, NULL, 'Y', 'N', 'timothy.ward',  TO_Date( '08/13/2012 12:16:04 PM', 'MM/DD/YYYY HH:MI:SS AM'), 'timothy.ward',  TO_Date( '08/13/2012 12:16:04 PM', 'MM/DD/YYYY HH:MI:SS AM')); 
INSERT INTO T_OSI_ATTACHMENT_TYPE ( SID, OBJ_TYPE, USAGE, CODE, DESCRIPTION, MIME_DISPOSITION, MIN_NUM, MAX_NUM, LOCK_MODE, SEQ, ACTIVE, OVERRIDE, CREATE_BY, CREATE_ON, MODIFY_BY, MODIFY_ON ) VALUES ( 
'33318VUT', '33317VAU', 'ATTACHMENT', 'FFORM40', 'Final Signed Form 40', 'ATTACHMENT', NULL, NULL, NULL, NULL, 'Y', 'N', 'timothy.ward',  TO_Date( '08/13/2012 12:16:04 PM', 'MM/DD/YYYY HH:MI:SS AM'), 'timothy.ward',  TO_Date( '08/13/2012 12:16:04 PM', 'MM/DD/YYYY HH:MI:SS AM')); 
INSERT INTO T_OSI_ATTACHMENT_TYPE ( SID, OBJ_TYPE, USAGE, CODE, DESCRIPTION, MIME_DISPOSITION, MIN_NUM, MAX_NUM, LOCK_MODE, SEQ, ACTIVE, OVERRIDE, CREATE_BY, CREATE_ON, MODIFY_BY, MODIFY_ON ) VALUES ( 
'33318VUU', '33317VAV', 'ATTACHMENT', 'FFORM40', 'Final Signed Form 40', 'ATTACHMENT', NULL, NULL, NULL, NULL, 'Y', 'N', 'timothy.ward',  TO_Date( '08/13/2012 12:16:04 PM', 'MM/DD/YYYY HH:MI:SS AM'), 'timothy.ward',  TO_Date( '08/13/2012 12:16:04 PM', 'MM/DD/YYYY HH:MI:SS AM')); 
INSERT INTO T_OSI_ATTACHMENT_TYPE ( SID, OBJ_TYPE, USAGE, CODE, DESCRIPTION, MIME_DISPOSITION, MIN_NUM, MAX_NUM, LOCK_MODE, SEQ, ACTIVE, OVERRIDE, CREATE_BY, CREATE_ON, MODIFY_BY, MODIFY_ON ) VALUES ( 
'33318VUV', '33317VN7', 'ATTACHMENT', 'FFORM40', 'Final Signed Form 40', 'ATTACHMENT', NULL, NULL, NULL, NULL, 'Y', 'N', 'timothy.ward',  TO_Date( '08/13/2012 12:16:04 PM', 'MM/DD/YYYY HH:MI:SS AM'), 'timothy.ward',  TO_Date( '08/13/2012 12:16:04 PM', 'MM/DD/YYYY HH:MI:SS AM')); 
INSERT INTO T_OSI_ATTACHMENT_TYPE ( SID, OBJ_TYPE, USAGE, CODE, DESCRIPTION, MIME_DISPOSITION, MIN_NUM, MAX_NUM, LOCK_MODE, SEQ, ACTIVE, OVERRIDE, CREATE_BY, CREATE_ON, MODIFY_BY, MODIFY_ON ) VALUES ( 
'33318VUW', '33318QCZ', 'ATTACHMENT', 'FFORM40', 'Final Signed Form 40', 'ATTACHMENT', NULL, NULL, NULL, NULL, 'Y', 'N', 'timothy.ward',  TO_Date( '08/13/2012 12:16:04 PM', 'MM/DD/YYYY HH:MI:SS AM'), 'timothy.ward',  TO_Date( '08/13/2012 12:16:04 PM', 'MM/DD/YYYY HH:MI:SS AM')); 
INSERT INTO T_OSI_ATTACHMENT_TYPE ( SID, OBJ_TYPE, USAGE, CODE, DESCRIPTION, MIME_DISPOSITION, MIN_NUM, MAX_NUM, LOCK_MODE, SEQ, ACTIVE, OVERRIDE, CREATE_BY, CREATE_ON, MODIFY_BY, MODIFY_ON ) VALUES ( 
'33318VUX', '33318SVJ', 'ATTACHMENT', 'FFORM40', 'Final Signed Form 40', 'ATTACHMENT', NULL, NULL, NULL, NULL, 'Y', 'N', 'timothy.ward',  TO_Date( '08/13/2012 12:16:04 PM', 'MM/DD/YYYY HH:MI:SS AM'), 'timothy.ward',  TO_Date( '08/13/2012 12:16:04 PM', 'MM/DD/YYYY HH:MI:SS AM')); 
COMMIT;



























----------------------------------------------------------------------
----------------------------------------------------------------------
-----------------ATTACHMENT TYPE ACT.OTHER----------------------------
----------------------------------------------------------------------
----------------------------------------------------------------------
----------------------------------------------------------------------
----------------------------------------------------------------------
----------------------------------------------------------------------
----------------------------------------------------------------------
----------------------------------------------------------------------
----------------------------------------------------------------------
----------------------------------------------------------------------
INSERT INTO T_OSI_ATTACHMENT_TYPE ( SID, OBJ_TYPE, USAGE, CODE, DESCRIPTION, MIME_DISPOSITION, MIN_NUM, MAX_NUM, LOCK_MODE, SEQ, ACTIVE, OVERRIDE, CREATE_BY, CREATE_ON, MODIFY_BY, MODIFY_ON ) VALUES ( 
'33318WTM', '222000005ES', 'ATTACHMENT', 'ACT.OTHER', 'Other', 'ATTACHMENT', NULL, NULL, NULL, NULL, 'Y', 'N', 'timothy.ward',  TO_Date( '08/21/2012 12:28:33 PM', 'MM/DD/YYYY HH:MI:SS AM'), 'timothy.ward',  TO_Date( '08/21/2012 12:28:33 PM', 'MM/DD/YYYY HH:MI:SS AM')); 
INSERT INTO T_OSI_ATTACHMENT_TYPE ( SID, OBJ_TYPE, USAGE, CODE, DESCRIPTION, MIME_DISPOSITION, MIN_NUM, MAX_NUM, LOCK_MODE, SEQ, ACTIVE, OVERRIDE, CREATE_BY, CREATE_ON, MODIFY_BY, MODIFY_ON ) VALUES ( 
'33318WTN', '222000005ET', 'ATTACHMENT', 'ACT.OTHER', 'Other', 'ATTACHMENT', NULL, NULL, NULL, NULL, 'Y', 'N', 'timothy.ward',  TO_Date( '08/21/2012 12:28:33 PM', 'MM/DD/YYYY HH:MI:SS AM'), 'timothy.ward',  TO_Date( '08/21/2012 12:28:33 PM', 'MM/DD/YYYY HH:MI:SS AM')); 
INSERT INTO T_OSI_ATTACHMENT_TYPE ( SID, OBJ_TYPE, USAGE, CODE, DESCRIPTION, MIME_DISPOSITION, MIN_NUM, MAX_NUM, LOCK_MODE, SEQ, ACTIVE, OVERRIDE, CREATE_BY, CREATE_ON, MODIFY_BY, MODIFY_ON ) VALUES ( 
'33318WTO', '222000008GT', 'ATTACHMENT', 'ACT.OTHER', 'Other', 'ATTACHMENT', NULL, NULL, NULL, NULL, 'Y', 'N', 'timothy.ward',  TO_Date( '08/21/2012 12:28:33 PM', 'MM/DD/YYYY HH:MI:SS AM'), 'timothy.ward',  TO_Date( '08/21/2012 12:28:33 PM', 'MM/DD/YYYY HH:MI:SS AM')); 
INSERT INTO T_OSI_ATTACHMENT_TYPE ( SID, OBJ_TYPE, USAGE, CODE, DESCRIPTION, MIME_DISPOSITION, MIN_NUM, MAX_NUM, LOCK_MODE, SEQ, ACTIVE, OVERRIDE, CREATE_BY, CREATE_ON, MODIFY_BY, MODIFY_ON ) VALUES ( 
'33318WTP', '222000008IS', 'ATTACHMENT', 'ACT.OTHER', 'Other', 'ATTACHMENT', NULL, NULL, NULL, NULL, 'Y', 'N', 'timothy.ward',  TO_Date( '08/21/2012 12:28:33 PM', 'MM/DD/YYYY HH:MI:SS AM'), 'timothy.ward',  TO_Date( '08/21/2012 12:28:33 PM', 'MM/DD/YYYY HH:MI:SS AM')); 
INSERT INTO T_OSI_ATTACHMENT_TYPE ( SID, OBJ_TYPE, USAGE, CODE, DESCRIPTION, MIME_DISPOSITION, MIN_NUM, MAX_NUM, LOCK_MODE, SEQ, ACTIVE, OVERRIDE, CREATE_BY, CREATE_ON, MODIFY_BY, MODIFY_ON ) VALUES ( 
'33318WTQ', '222000008SW', 'ATTACHMENT', 'ACT.OTHER', 'Other', 'ATTACHMENT', NULL, NULL, NULL, NULL, 'Y', 'N', 'timothy.ward',  TO_Date( '08/21/2012 12:28:33 PM', 'MM/DD/YYYY HH:MI:SS AM'), 'timothy.ward',  TO_Date( '08/21/2012 12:28:33 PM', 'MM/DD/YYYY HH:MI:SS AM')); 
INSERT INTO T_OSI_ATTACHMENT_TYPE ( SID, OBJ_TYPE, USAGE, CODE, DESCRIPTION, MIME_DISPOSITION, MIN_NUM, MAX_NUM, LOCK_MODE, SEQ, ACTIVE, OVERRIDE, CREATE_BY, CREATE_ON, MODIFY_BY, MODIFY_ON ) VALUES ( 
'33318WTR', '222000008WJ', 'ATTACHMENT', 'ACT.OTHER', 'Other', 'ATTACHMENT', NULL, NULL, NULL, NULL, 'Y', 'N', 'timothy.ward',  TO_Date( '08/21/2012 12:28:33 PM', 'MM/DD/YYYY HH:MI:SS AM'), 'timothy.ward',  TO_Date( '08/21/2012 12:28:33 PM', 'MM/DD/YYYY HH:MI:SS AM')); 
INSERT INTO T_OSI_ATTACHMENT_TYPE ( SID, OBJ_TYPE, USAGE, CODE, DESCRIPTION, MIME_DISPOSITION, MIN_NUM, MAX_NUM, LOCK_MODE, SEQ, ACTIVE, OVERRIDE, CREATE_BY, CREATE_ON, MODIFY_BY, MODIFY_ON ) VALUES ( 
'33318WTS', '222000009EP', 'ATTACHMENT', 'ACT.OTHER', 'Other', 'ATTACHMENT', NULL, NULL, NULL, NULL, 'Y', 'N', 'timothy.ward',  TO_Date( '08/21/2012 12:28:33 PM', 'MM/DD/YYYY HH:MI:SS AM'), 'timothy.ward',  TO_Date( '08/21/2012 12:28:33 PM', 'MM/DD/YYYY HH:MI:SS AM')); 
INSERT INTO T_OSI_ATTACHMENT_TYPE ( SID, OBJ_TYPE, USAGE, CODE, DESCRIPTION, MIME_DISPOSITION, MIN_NUM, MAX_NUM, LOCK_MODE, SEQ, ACTIVE, OVERRIDE, CREATE_BY, CREATE_ON, MODIFY_BY, MODIFY_ON ) VALUES ( 
'33318WTT', '222000009LG', 'ATTACHMENT', 'ACT.OTHER', 'Other', 'ATTACHMENT', NULL, NULL, NULL, NULL, 'Y', 'N', 'timothy.ward',  TO_Date( '08/21/2012 12:28:33 PM', 'MM/DD/YYYY HH:MI:SS AM'), 'timothy.ward',  TO_Date( '08/21/2012 12:28:33 PM', 'MM/DD/YYYY HH:MI:SS AM')); 
INSERT INTO T_OSI_ATTACHMENT_TYPE ( SID, OBJ_TYPE, USAGE, CODE, DESCRIPTION, MIME_DISPOSITION, MIN_NUM, MAX_NUM, LOCK_MODE, SEQ, ACTIVE, OVERRIDE, CREATE_BY, CREATE_ON, MODIFY_BY, MODIFY_ON ) VALUES ( 
'33318WTU', '222000009LI', 'ATTACHMENT', 'ACT.OTHER', 'Other', 'ATTACHMENT', NULL, NULL, NULL, NULL, 'Y', 'N', 'timothy.ward',  TO_Date( '08/21/2012 12:28:33 PM', 'MM/DD/YYYY HH:MI:SS AM'), 'timothy.ward',  TO_Date( '08/21/2012 12:28:33 PM', 'MM/DD/YYYY HH:MI:SS AM')); 
INSERT INTO T_OSI_ATTACHMENT_TYPE ( SID, OBJ_TYPE, USAGE, CODE, DESCRIPTION, MIME_DISPOSITION, MIN_NUM, MAX_NUM, LOCK_MODE, SEQ, ACTIVE, OVERRIDE, CREATE_BY, CREATE_ON, MODIFY_BY, MODIFY_ON ) VALUES ( 
'33318WTV', '222000009LJ', 'ATTACHMENT', 'ACT.OTHER', 'Other', 'ATTACHMENT', NULL, NULL, NULL, NULL, 'Y', 'N', 'timothy.ward',  TO_Date( '08/21/2012 12:28:33 PM', 'MM/DD/YYYY HH:MI:SS AM'), 'timothy.ward',  TO_Date( '08/21/2012 12:28:33 PM', 'MM/DD/YYYY HH:MI:SS AM')); 
INSERT INTO T_OSI_ATTACHMENT_TYPE ( SID, OBJ_TYPE, USAGE, CODE, DESCRIPTION, MIME_DISPOSITION, MIN_NUM, MAX_NUM, LOCK_MODE, SEQ, ACTIVE, OVERRIDE, CREATE_BY, CREATE_ON, MODIFY_BY, MODIFY_ON ) VALUES ( 
'33318WTW', '22200000CY0', 'ATTACHMENT', 'ACT.OTHER', 'Other', 'ATTACHMENT', NULL, NULL, NULL, NULL, 'Y', 'N', 'timothy.ward',  TO_Date( '08/21/2012 12:28:33 PM', 'MM/DD/YYYY HH:MI:SS AM'), 'timothy.ward',  TO_Date( '08/21/2012 12:28:33 PM', 'MM/DD/YYYY HH:MI:SS AM')); 
INSERT INTO T_OSI_ATTACHMENT_TYPE ( SID, OBJ_TYPE, USAGE, CODE, DESCRIPTION, MIME_DISPOSITION, MIN_NUM, MAX_NUM, LOCK_MODE, SEQ, ACTIVE, OVERRIDE, CREATE_BY, CREATE_ON, MODIFY_BY, MODIFY_ON ) VALUES ( 
'33318WTX', '22200000GFD', 'ATTACHMENT', 'ACT.OTHER', 'Other', 'ATTACHMENT', NULL, NULL, NULL, NULL, 'Y', 'N', 'timothy.ward',  TO_Date( '08/21/2012 12:28:33 PM', 'MM/DD/YYYY HH:MI:SS AM'), 'timothy.ward',  TO_Date( '08/21/2012 12:28:33 PM', 'MM/DD/YYYY HH:MI:SS AM')); 
INSERT INTO T_OSI_ATTACHMENT_TYPE ( SID, OBJ_TYPE, USAGE, CODE, DESCRIPTION, MIME_DISPOSITION, MIN_NUM, MAX_NUM, LOCK_MODE, SEQ, ACTIVE, OVERRIDE, CREATE_BY, CREATE_ON, MODIFY_BY, MODIFY_ON ) VALUES ( 
'33318WTY', '22200000HLH', 'ATTACHMENT', 'ACT.OTHER', 'Other', 'ATTACHMENT', NULL, NULL, NULL, NULL, 'Y', 'N', 'timothy.ward',  TO_Date( '08/21/2012 12:28:33 PM', 'MM/DD/YYYY HH:MI:SS AM'), 'timothy.ward',  TO_Date( '08/21/2012 12:28:33 PM', 'MM/DD/YYYY HH:MI:SS AM')); 
INSERT INTO T_OSI_ATTACHMENT_TYPE ( SID, OBJ_TYPE, USAGE, CODE, DESCRIPTION, MIME_DISPOSITION, MIN_NUM, MAX_NUM, LOCK_MODE, SEQ, ACTIVE, OVERRIDE, CREATE_BY, CREATE_ON, MODIFY_BY, MODIFY_ON ) VALUES ( 
'33318WTZ', '22200000HLP', 'ATTACHMENT', 'ACT.OTHER', 'Other', 'ATTACHMENT', NULL, NULL, NULL, NULL, 'Y', 'N', 'timothy.ward',  TO_Date( '08/21/2012 12:28:33 PM', 'MM/DD/YYYY HH:MI:SS AM'), 'timothy.ward',  TO_Date( '08/21/2012 12:28:33 PM', 'MM/DD/YYYY HH:MI:SS AM')); 
INSERT INTO T_OSI_ATTACHMENT_TYPE ( SID, OBJ_TYPE, USAGE, CODE, DESCRIPTION, MIME_DISPOSITION, MIN_NUM, MAX_NUM, LOCK_MODE, SEQ, ACTIVE, OVERRIDE, CREATE_BY, CREATE_ON, MODIFY_BY, MODIFY_ON ) VALUES ( 
'33318WU0', '22200000HNQ', 'ATTACHMENT', 'ACT.OTHER', 'Other', 'ATTACHMENT', NULL, NULL, NULL, NULL, 'Y', 'N', 'timothy.ward',  TO_Date( '08/21/2012 12:28:33 PM', 'MM/DD/YYYY HH:MI:SS AM'), 'timothy.ward',  TO_Date( '08/21/2012 12:28:33 PM', 'MM/DD/YYYY HH:MI:SS AM')); 
INSERT INTO T_OSI_ATTACHMENT_TYPE ( SID, OBJ_TYPE, USAGE, CODE, DESCRIPTION, MIME_DISPOSITION, MIN_NUM, MAX_NUM, LOCK_MODE, SEQ, ACTIVE, OVERRIDE, CREATE_BY, CREATE_ON, MODIFY_BY, MODIFY_ON ) VALUES ( 
'33318WU1', '22200000HNR', 'ATTACHMENT', 'ACT.OTHER', 'Other', 'ATTACHMENT', NULL, NULL, NULL, NULL, 'Y', 'N', 'timothy.ward',  TO_Date( '08/21/2012 12:28:33 PM', 'MM/DD/YYYY HH:MI:SS AM'), 'timothy.ward',  TO_Date( '08/21/2012 12:28:33 PM', 'MM/DD/YYYY HH:MI:SS AM')); 
INSERT INTO T_OSI_ATTACHMENT_TYPE ( SID, OBJ_TYPE, USAGE, CODE, DESCRIPTION, MIME_DISPOSITION, MIN_NUM, MAX_NUM, LOCK_MODE, SEQ, ACTIVE, OVERRIDE, CREATE_BY, CREATE_ON, MODIFY_BY, MODIFY_ON ) VALUES ( 
'33318WU2', '22200000HNS', 'ATTACHMENT', 'ACT.OTHER', 'Other', 'ATTACHMENT', NULL, NULL, NULL, NULL, 'Y', 'N', 'timothy.ward',  TO_Date( '08/21/2012 12:28:33 PM', 'MM/DD/YYYY HH:MI:SS AM'), 'timothy.ward',  TO_Date( '08/21/2012 12:28:33 PM', 'MM/DD/YYYY HH:MI:SS AM')); 
INSERT INTO T_OSI_ATTACHMENT_TYPE ( SID, OBJ_TYPE, USAGE, CODE, DESCRIPTION, MIME_DISPOSITION, MIN_NUM, MAX_NUM, LOCK_MODE, SEQ, ACTIVE, OVERRIDE, CREATE_BY, CREATE_ON, MODIFY_BY, MODIFY_ON ) VALUES ( 
'33318WU3', '22200000HNT', 'ATTACHMENT', 'ACT.OTHER', 'Other', 'ATTACHMENT', NULL, NULL, NULL, NULL, 'Y', 'N', 'timothy.ward',  TO_Date( '08/21/2012 12:28:33 PM', 'MM/DD/YYYY HH:MI:SS AM'), 'timothy.ward',  TO_Date( '08/21/2012 12:28:33 PM', 'MM/DD/YYYY HH:MI:SS AM')); 
INSERT INTO T_OSI_ATTACHMENT_TYPE ( SID, OBJ_TYPE, USAGE, CODE, DESCRIPTION, MIME_DISPOSITION, MIN_NUM, MAX_NUM, LOCK_MODE, SEQ, ACTIVE, OVERRIDE, CREATE_BY, CREATE_ON, MODIFY_BY, MODIFY_ON ) VALUES ( 
'33318WU4', '22200000HNU', 'ATTACHMENT', 'ACT.OTHER', 'Other', 'ATTACHMENT', NULL, NULL, NULL, NULL, 'Y', 'N', 'timothy.ward',  TO_Date( '08/21/2012 12:28:33 PM', 'MM/DD/YYYY HH:MI:SS AM'), 'timothy.ward',  TO_Date( '08/21/2012 12:28:33 PM', 'MM/DD/YYYY HH:MI:SS AM')); 
INSERT INTO T_OSI_ATTACHMENT_TYPE ( SID, OBJ_TYPE, USAGE, CODE, DESCRIPTION, MIME_DISPOSITION, MIN_NUM, MAX_NUM, LOCK_MODE, SEQ, ACTIVE, OVERRIDE, CREATE_BY, CREATE_ON, MODIFY_BY, MODIFY_ON ) VALUES ( 
'33318WU5', '22200000HNV', 'ATTACHMENT', 'ACT.OTHER', 'Other', 'ATTACHMENT', NULL, NULL, NULL, NULL, 'Y', 'N', 'timothy.ward',  TO_Date( '08/21/2012 12:28:33 PM', 'MM/DD/YYYY HH:MI:SS AM'), 'timothy.ward',  TO_Date( '08/21/2012 12:28:33 PM', 'MM/DD/YYYY HH:MI:SS AM')); 
INSERT INTO T_OSI_ATTACHMENT_TYPE ( SID, OBJ_TYPE, USAGE, CODE, DESCRIPTION, MIME_DISPOSITION, MIN_NUM, MAX_NUM, LOCK_MODE, SEQ, ACTIVE, OVERRIDE, CREATE_BY, CREATE_ON, MODIFY_BY, MODIFY_ON ) VALUES ( 
'33318WU6', '22200000HNW', 'ATTACHMENT', 'ACT.OTHER', 'Other', 'ATTACHMENT', NULL, NULL, NULL, NULL, 'Y', 'N', 'timothy.ward',  TO_Date( '08/21/2012 12:28:33 PM', 'MM/DD/YYYY HH:MI:SS AM'), 'timothy.ward',  TO_Date( '08/21/2012 12:28:33 PM', 'MM/DD/YYYY HH:MI:SS AM')); 
INSERT INTO T_OSI_ATTACHMENT_TYPE ( SID, OBJ_TYPE, USAGE, CODE, DESCRIPTION, MIME_DISPOSITION, MIN_NUM, MAX_NUM, LOCK_MODE, SEQ, ACTIVE, OVERRIDE, CREATE_BY, CREATE_ON, MODIFY_BY, MODIFY_ON ) VALUES ( 
'33318WU7', '22200000HNX', 'ATTACHMENT', 'ACT.OTHER', 'Other', 'ATTACHMENT', NULL, NULL, NULL, NULL, 'Y', 'N', 'timothy.ward',  TO_Date( '08/21/2012 12:28:33 PM', 'MM/DD/YYYY HH:MI:SS AM'), 'timothy.ward',  TO_Date( '08/21/2012 12:28:33 PM', 'MM/DD/YYYY HH:MI:SS AM')); 
INSERT INTO T_OSI_ATTACHMENT_TYPE ( SID, OBJ_TYPE, USAGE, CODE, DESCRIPTION, MIME_DISPOSITION, MIN_NUM, MAX_NUM, LOCK_MODE, SEQ, ACTIVE, OVERRIDE, CREATE_BY, CREATE_ON, MODIFY_BY, MODIFY_ON ) VALUES ( 
'33318WU8', '22200000HNY', 'ATTACHMENT', 'ACT.OTHER', 'Other', 'ATTACHMENT', NULL, NULL, NULL, NULL, 'Y', 'N', 'timothy.ward',  TO_Date( '08/21/2012 12:28:33 PM', 'MM/DD/YYYY HH:MI:SS AM'), 'timothy.ward',  TO_Date( '08/21/2012 12:28:33 PM', 'MM/DD/YYYY HH:MI:SS AM')); 
INSERT INTO T_OSI_ATTACHMENT_TYPE ( SID, OBJ_TYPE, USAGE, CODE, DESCRIPTION, MIME_DISPOSITION, MIN_NUM, MAX_NUM, LOCK_MODE, SEQ, ACTIVE, OVERRIDE, CREATE_BY, CREATE_ON, MODIFY_BY, MODIFY_ON ) VALUES ( 
'33318WU9', '22200000KZN', 'ATTACHMENT', 'ACT.OTHER', 'Other', 'ATTACHMENT', NULL, NULL, NULL, NULL, 'Y', 'N', 'timothy.ward',  TO_Date( '08/21/2012 12:28:33 PM', 'MM/DD/YYYY HH:MI:SS AM'), 'timothy.ward',  TO_Date( '08/21/2012 12:28:33 PM', 'MM/DD/YYYY HH:MI:SS AM')); 
INSERT INTO T_OSI_ATTACHMENT_TYPE ( SID, OBJ_TYPE, USAGE, CODE, DESCRIPTION, MIME_DISPOSITION, MIN_NUM, MAX_NUM, LOCK_MODE, SEQ, ACTIVE, OVERRIDE, CREATE_BY, CREATE_ON, MODIFY_BY, MODIFY_ON ) VALUES ( 
'33318WUA', '22200000L63', 'ATTACHMENT', 'ACT.OTHER', 'Other', 'ATTACHMENT', NULL, NULL, NULL, NULL, 'Y', 'N', 'timothy.ward',  TO_Date( '08/21/2012 12:28:33 PM', 'MM/DD/YYYY HH:MI:SS AM'), 'timothy.ward',  TO_Date( '08/21/2012 12:28:33 PM', 'MM/DD/YYYY HH:MI:SS AM')); 
INSERT INTO T_OSI_ATTACHMENT_TYPE ( SID, OBJ_TYPE, USAGE, CODE, DESCRIPTION, MIME_DISPOSITION, MIN_NUM, MAX_NUM, LOCK_MODE, SEQ, ACTIVE, OVERRIDE, CREATE_BY, CREATE_ON, MODIFY_BY, MODIFY_ON ) VALUES ( 
'33318WUB', '22200000LBC', 'ATTACHMENT', 'ACT.OTHER', 'Other', 'ATTACHMENT', NULL, NULL, NULL, NULL, 'Y', 'N', 'timothy.ward',  TO_Date( '08/21/2012 12:28:33 PM', 'MM/DD/YYYY HH:MI:SS AM'), 'timothy.ward',  TO_Date( '08/21/2012 12:28:33 PM', 'MM/DD/YYYY HH:MI:SS AM')); 
INSERT INTO T_OSI_ATTACHMENT_TYPE ( SID, OBJ_TYPE, USAGE, CODE, DESCRIPTION, MIME_DISPOSITION, MIN_NUM, MAX_NUM, LOCK_MODE, SEQ, ACTIVE, OVERRIDE, CREATE_BY, CREATE_ON, MODIFY_BY, MODIFY_ON ) VALUES ( 
'33318WUC', '22200000LBD', 'ATTACHMENT', 'ACT.OTHER', 'Other', 'ATTACHMENT', NULL, NULL, NULL, NULL, 'Y', 'N', 'timothy.ward',  TO_Date( '08/21/2012 12:28:33 PM', 'MM/DD/YYYY HH:MI:SS AM'), 'timothy.ward',  TO_Date( '08/21/2012 12:28:33 PM', 'MM/DD/YYYY HH:MI:SS AM')); 
INSERT INTO T_OSI_ATTACHMENT_TYPE ( SID, OBJ_TYPE, USAGE, CODE, DESCRIPTION, MIME_DISPOSITION, MIN_NUM, MAX_NUM, LOCK_MODE, SEQ, ACTIVE, OVERRIDE, CREATE_BY, CREATE_ON, MODIFY_BY, MODIFY_ON ) VALUES ( 
'33318WUD', '22200000LBE', 'ATTACHMENT', 'ACT.OTHER', 'Other', 'ATTACHMENT', NULL, NULL, NULL, NULL, 'Y', 'N', 'timothy.ward',  TO_Date( '08/21/2012 12:28:33 PM', 'MM/DD/YYYY HH:MI:SS AM'), 'timothy.ward',  TO_Date( '08/21/2012 12:28:33 PM', 'MM/DD/YYYY HH:MI:SS AM')); 
INSERT INTO T_OSI_ATTACHMENT_TYPE ( SID, OBJ_TYPE, USAGE, CODE, DESCRIPTION, MIME_DISPOSITION, MIN_NUM, MAX_NUM, LOCK_MODE, SEQ, ACTIVE, OVERRIDE, CREATE_BY, CREATE_ON, MODIFY_BY, MODIFY_ON ) VALUES ( 
'33318WUE', '22200000M3T', 'ATTACHMENT', 'ACT.OTHER', 'Other', 'ATTACHMENT', NULL, NULL, NULL, NULL, 'Y', 'N', 'timothy.ward',  TO_Date( '08/21/2012 12:28:33 PM', 'MM/DD/YYYY HH:MI:SS AM'), 'timothy.ward',  TO_Date( '08/21/2012 12:28:33 PM', 'MM/DD/YYYY HH:MI:SS AM')); 
INSERT INTO T_OSI_ATTACHMENT_TYPE ( SID, OBJ_TYPE, USAGE, CODE, DESCRIPTION, MIME_DISPOSITION, MIN_NUM, MAX_NUM, LOCK_MODE, SEQ, ACTIVE, OVERRIDE, CREATE_BY, CREATE_ON, MODIFY_BY, MODIFY_ON ) VALUES ( 
'33318WUF', '22200000M8R', 'ATTACHMENT', 'ACT.OTHER', 'Other', 'ATTACHMENT', NULL, NULL, NULL, NULL, 'Y', 'N', 'timothy.ward',  TO_Date( '08/21/2012 12:28:33 PM', 'MM/DD/YYYY HH:MI:SS AM'), 'timothy.ward',  TO_Date( '08/21/2012 12:28:33 PM', 'MM/DD/YYYY HH:MI:SS AM')); 
INSERT INTO T_OSI_ATTACHMENT_TYPE ( SID, OBJ_TYPE, USAGE, CODE, DESCRIPTION, MIME_DISPOSITION, MIN_NUM, MAX_NUM, LOCK_MODE, SEQ, ACTIVE, OVERRIDE, CREATE_BY, CREATE_ON, MODIFY_BY, MODIFY_ON ) VALUES ( 
'33318WUG', '22200000M8S', 'ATTACHMENT', 'ACT.OTHER', 'Other', 'ATTACHMENT', NULL, NULL, NULL, NULL, 'Y', 'N', 'timothy.ward',  TO_Date( '08/21/2012 12:28:33 PM', 'MM/DD/YYYY HH:MI:SS AM'), 'timothy.ward',  TO_Date( '08/21/2012 12:28:33 PM', 'MM/DD/YYYY HH:MI:SS AM')); 
INSERT INTO T_OSI_ATTACHMENT_TYPE ( SID, OBJ_TYPE, USAGE, CODE, DESCRIPTION, MIME_DISPOSITION, MIN_NUM, MAX_NUM, LOCK_MODE, SEQ, ACTIVE, OVERRIDE, CREATE_BY, CREATE_ON, MODIFY_BY, MODIFY_ON ) VALUES ( 
'33318WUH', '22200000M8T', 'ATTACHMENT', 'ACT.OTHER', 'Other', 'ATTACHMENT', NULL, NULL, NULL, NULL, 'Y', 'N', 'timothy.ward',  TO_Date( '08/21/2012 12:28:33 PM', 'MM/DD/YYYY HH:MI:SS AM'), 'timothy.ward',  TO_Date( '08/21/2012 12:28:33 PM', 'MM/DD/YYYY HH:MI:SS AM')); 
INSERT INTO T_OSI_ATTACHMENT_TYPE ( SID, OBJ_TYPE, USAGE, CODE, DESCRIPTION, MIME_DISPOSITION, MIN_NUM, MAX_NUM, LOCK_MODE, SEQ, ACTIVE, OVERRIDE, CREATE_BY, CREATE_ON, MODIFY_BY, MODIFY_ON ) VALUES ( 
'33318WUI', '22200000M8U', 'ATTACHMENT', 'ACT.OTHER', 'Other', 'ATTACHMENT', NULL, NULL, NULL, NULL, 'Y', 'N', 'timothy.ward',  TO_Date( '08/21/2012 12:28:33 PM', 'MM/DD/YYYY HH:MI:SS AM'), 'timothy.ward',  TO_Date( '08/21/2012 12:28:33 PM', 'MM/DD/YYYY HH:MI:SS AM')); 
INSERT INTO T_OSI_ATTACHMENT_TYPE ( SID, OBJ_TYPE, USAGE, CODE, DESCRIPTION, MIME_DISPOSITION, MIN_NUM, MAX_NUM, LOCK_MODE, SEQ, ACTIVE, OVERRIDE, CREATE_BY, CREATE_ON, MODIFY_BY, MODIFY_ON ) VALUES ( 
'33318WUJ', '22200000M8V', 'ATTACHMENT', 'ACT.OTHER', 'Other', 'ATTACHMENT', NULL, NULL, NULL, NULL, 'Y', 'N', 'timothy.ward',  TO_Date( '08/21/2012 12:28:33 PM', 'MM/DD/YYYY HH:MI:SS AM'), 'timothy.ward',  TO_Date( '08/21/2012 12:28:33 PM', 'MM/DD/YYYY HH:MI:SS AM')); 
INSERT INTO T_OSI_ATTACHMENT_TYPE ( SID, OBJ_TYPE, USAGE, CODE, DESCRIPTION, MIME_DISPOSITION, MIN_NUM, MAX_NUM, LOCK_MODE, SEQ, ACTIVE, OVERRIDE, CREATE_BY, CREATE_ON, MODIFY_BY, MODIFY_ON ) VALUES ( 
'33318WUK', '22200000M8W', 'ATTACHMENT', 'ACT.OTHER', 'Other', 'ATTACHMENT', NULL, NULL, NULL, NULL, 'Y', 'N', 'timothy.ward',  TO_Date( '08/21/2012 12:28:33 PM', 'MM/DD/YYYY HH:MI:SS AM'), 'timothy.ward',  TO_Date( '08/21/2012 12:28:33 PM', 'MM/DD/YYYY HH:MI:SS AM')); 
INSERT INTO T_OSI_ATTACHMENT_TYPE ( SID, OBJ_TYPE, USAGE, CODE, DESCRIPTION, MIME_DISPOSITION, MIN_NUM, MAX_NUM, LOCK_MODE, SEQ, ACTIVE, OVERRIDE, CREATE_BY, CREATE_ON, MODIFY_BY, MODIFY_ON ) VALUES ( 
'33318WUL', '22200000MBN', 'ATTACHMENT', 'ACT.OTHER', 'Other', 'ATTACHMENT', NULL, NULL, NULL, NULL, 'Y', 'N', 'timothy.ward',  TO_Date( '08/21/2012 12:28:33 PM', 'MM/DD/YYYY HH:MI:SS AM'), 'timothy.ward',  TO_Date( '08/21/2012 12:28:33 PM', 'MM/DD/YYYY HH:MI:SS AM')); 
INSERT INTO T_OSI_ATTACHMENT_TYPE ( SID, OBJ_TYPE, USAGE, CODE, DESCRIPTION, MIME_DISPOSITION, MIN_NUM, MAX_NUM, LOCK_MODE, SEQ, ACTIVE, OVERRIDE, CREATE_BY, CREATE_ON, MODIFY_BY, MODIFY_ON ) VALUES ( 
'33318WUM', '22200000MS7', 'ATTACHMENT', 'ACT.OTHER', 'Other', 'ATTACHMENT', NULL, NULL, NULL, NULL, 'Y', 'N', 'timothy.ward',  TO_Date( '08/21/2012 12:28:33 PM', 'MM/DD/YYYY HH:MI:SS AM'), 'timothy.ward',  TO_Date( '08/21/2012 12:28:33 PM', 'MM/DD/YYYY HH:MI:SS AM')); 
INSERT INTO T_OSI_ATTACHMENT_TYPE ( SID, OBJ_TYPE, USAGE, CODE, DESCRIPTION, MIME_DISPOSITION, MIN_NUM, MAX_NUM, LOCK_MODE, SEQ, ACTIVE, OVERRIDE, CREATE_BY, CREATE_ON, MODIFY_BY, MODIFY_ON ) VALUES ( 
'33318WUN', '22200000MT9', 'ATTACHMENT', 'ACT.OTHER', 'Other', 'ATTACHMENT', NULL, NULL, NULL, NULL, 'Y', 'N', 'timothy.ward',  TO_Date( '08/21/2012 12:28:33 PM', 'MM/DD/YYYY HH:MI:SS AM'), 'timothy.ward',  TO_Date( '08/21/2012 12:28:33 PM', 'MM/DD/YYYY HH:MI:SS AM')); 
INSERT INTO T_OSI_ATTACHMENT_TYPE ( SID, OBJ_TYPE, USAGE, CODE, DESCRIPTION, MIME_DISPOSITION, MIN_NUM, MAX_NUM, LOCK_MODE, SEQ, ACTIVE, OVERRIDE, CREATE_BY, CREATE_ON, MODIFY_BY, MODIFY_ON ) VALUES ( 
'33318WUO', '22200000MTA', 'ATTACHMENT', 'ACT.OTHER', 'Other', 'ATTACHMENT', NULL, NULL, NULL, NULL, 'Y', 'N', 'timothy.ward',  TO_Date( '08/21/2012 12:28:33 PM', 'MM/DD/YYYY HH:MI:SS AM'), 'timothy.ward',  TO_Date( '08/21/2012 12:28:33 PM', 'MM/DD/YYYY HH:MI:SS AM')); 
INSERT INTO T_OSI_ATTACHMENT_TYPE ( SID, OBJ_TYPE, USAGE, CODE, DESCRIPTION, MIME_DISPOSITION, MIN_NUM, MAX_NUM, LOCK_MODE, SEQ, ACTIVE, OVERRIDE, CREATE_BY, CREATE_ON, MODIFY_BY, MODIFY_ON ) VALUES ( 
'33318WUP', '22200000MTB', 'ATTACHMENT', 'ACT.OTHER', 'Other', 'ATTACHMENT', NULL, NULL, NULL, NULL, 'Y', 'N', 'timothy.ward',  TO_Date( '08/21/2012 12:28:33 PM', 'MM/DD/YYYY HH:MI:SS AM'), 'timothy.ward',  TO_Date( '08/21/2012 12:28:33 PM', 'MM/DD/YYYY HH:MI:SS AM')); 
INSERT INTO T_OSI_ATTACHMENT_TYPE ( SID, OBJ_TYPE, USAGE, CODE, DESCRIPTION, MIME_DISPOSITION, MIN_NUM, MAX_NUM, LOCK_MODE, SEQ, ACTIVE, OVERRIDE, CREATE_BY, CREATE_ON, MODIFY_BY, MODIFY_ON ) VALUES ( 
'33318WUQ', '22200000MTV', 'ATTACHMENT', 'ACT.OTHER', 'Other', 'ATTACHMENT', NULL, NULL, NULL, NULL, 'Y', 'N', 'timothy.ward',  TO_Date( '08/21/2012 12:28:33 PM', 'MM/DD/YYYY HH:MI:SS AM'), 'timothy.ward',  TO_Date( '08/21/2012 12:28:33 PM', 'MM/DD/YYYY HH:MI:SS AM')); 
INSERT INTO T_OSI_ATTACHMENT_TYPE ( SID, OBJ_TYPE, USAGE, CODE, DESCRIPTION, MIME_DISPOSITION, MIN_NUM, MAX_NUM, LOCK_MODE, SEQ, ACTIVE, OVERRIDE, CREATE_BY, CREATE_ON, MODIFY_BY, MODIFY_ON ) VALUES ( 
'33318WUR', '22200000MTW', 'ATTACHMENT', 'ACT.OTHER', 'Other', 'ATTACHMENT', NULL, NULL, NULL, NULL, 'Y', 'N', 'timothy.ward',  TO_Date( '08/21/2012 12:28:33 PM', 'MM/DD/YYYY HH:MI:SS AM'), 'timothy.ward',  TO_Date( '08/21/2012 12:28:33 PM', 'MM/DD/YYYY HH:MI:SS AM')); 
INSERT INTO T_OSI_ATTACHMENT_TYPE ( SID, OBJ_TYPE, USAGE, CODE, DESCRIPTION, MIME_DISPOSITION, MIN_NUM, MAX_NUM, LOCK_MODE, SEQ, ACTIVE, OVERRIDE, CREATE_BY, CREATE_ON, MODIFY_BY, MODIFY_ON ) VALUES ( 
'33318WUS', '22200000MTX', 'ATTACHMENT', 'ACT.OTHER', 'Other', 'ATTACHMENT', NULL, NULL, NULL, NULL, 'Y', 'N', 'timothy.ward',  TO_Date( '08/21/2012 12:28:33 PM', 'MM/DD/YYYY HH:MI:SS AM'), 'timothy.ward',  TO_Date( '08/21/2012 12:28:33 PM', 'MM/DD/YYYY HH:MI:SS AM')); 
INSERT INTO T_OSI_ATTACHMENT_TYPE ( SID, OBJ_TYPE, USAGE, CODE, DESCRIPTION, MIME_DISPOSITION, MIN_NUM, MAX_NUM, LOCK_MODE, SEQ, ACTIVE, OVERRIDE, CREATE_BY, CREATE_ON, MODIFY_BY, MODIFY_ON ) VALUES ( 
'33318WUT', '22200000MTY', 'ATTACHMENT', 'ACT.OTHER', 'Other', 'ATTACHMENT', NULL, NULL, NULL, NULL, 'Y', 'N', 'timothy.ward',  TO_Date( '08/21/2012 12:28:33 PM', 'MM/DD/YYYY HH:MI:SS AM'), 'timothy.ward',  TO_Date( '08/21/2012 12:28:33 PM', 'MM/DD/YYYY HH:MI:SS AM')); 
INSERT INTO T_OSI_ATTACHMENT_TYPE ( SID, OBJ_TYPE, USAGE, CODE, DESCRIPTION, MIME_DISPOSITION, MIN_NUM, MAX_NUM, LOCK_MODE, SEQ, ACTIVE, OVERRIDE, CREATE_BY, CREATE_ON, MODIFY_BY, MODIFY_ON ) VALUES ( 
'33318WUU', '22200000MTZ', 'ATTACHMENT', 'ACT.OTHER', 'Other', 'ATTACHMENT', NULL, NULL, NULL, NULL, 'Y', 'N', 'timothy.ward',  TO_Date( '08/21/2012 12:28:33 PM', 'MM/DD/YYYY HH:MI:SS AM'), 'timothy.ward',  TO_Date( '08/21/2012 12:28:33 PM', 'MM/DD/YYYY HH:MI:SS AM')); 
INSERT INTO T_OSI_ATTACHMENT_TYPE ( SID, OBJ_TYPE, USAGE, CODE, DESCRIPTION, MIME_DISPOSITION, MIN_NUM, MAX_NUM, LOCK_MODE, SEQ, ACTIVE, OVERRIDE, CREATE_BY, CREATE_ON, MODIFY_BY, MODIFY_ON ) VALUES ( 
'33318WUV', '22200000P2A', 'ATTACHMENT', 'ACT.OTHER', 'Other', 'ATTACHMENT', NULL, NULL, NULL, NULL, 'Y', 'N', 'timothy.ward',  TO_Date( '08/21/2012 12:28:33 PM', 'MM/DD/YYYY HH:MI:SS AM'), 'timothy.ward',  TO_Date( '08/21/2012 12:28:33 PM', 'MM/DD/YYYY HH:MI:SS AM')); 
INSERT INTO T_OSI_ATTACHMENT_TYPE ( SID, OBJ_TYPE, USAGE, CODE, DESCRIPTION, MIME_DISPOSITION, MIN_NUM, MAX_NUM, LOCK_MODE, SEQ, ACTIVE, OVERRIDE, CREATE_BY, CREATE_ON, MODIFY_BY, MODIFY_ON ) VALUES ( 
'33318WUW', '22200000Q7A', 'ATTACHMENT', 'ACT.OTHER', 'Other', 'ATTACHMENT', NULL, NULL, NULL, NULL, 'Y', 'N', 'timothy.ward',  TO_Date( '08/21/2012 12:28:33 PM', 'MM/DD/YYYY HH:MI:SS AM'), 'timothy.ward',  TO_Date( '08/21/2012 12:28:33 PM', 'MM/DD/YYYY HH:MI:SS AM')); 
INSERT INTO T_OSI_ATTACHMENT_TYPE ( SID, OBJ_TYPE, USAGE, CODE, DESCRIPTION, MIME_DISPOSITION, MIN_NUM, MAX_NUM, LOCK_MODE, SEQ, ACTIVE, OVERRIDE, CREATE_BY, CREATE_ON, MODIFY_BY, MODIFY_ON ) VALUES ( 
'33318WUX', '22200000Q7B', 'ATTACHMENT', 'ACT.OTHER', 'Other', 'ATTACHMENT', NULL, NULL, NULL, NULL, 'Y', 'N', 'timothy.ward',  TO_Date( '08/21/2012 12:28:33 PM', 'MM/DD/YYYY HH:MI:SS AM'), 'timothy.ward',  TO_Date( '08/21/2012 12:28:33 PM', 'MM/DD/YYYY HH:MI:SS AM')); 
INSERT INTO T_OSI_ATTACHMENT_TYPE ( SID, OBJ_TYPE, USAGE, CODE, DESCRIPTION, MIME_DISPOSITION, MIN_NUM, MAX_NUM, LOCK_MODE, SEQ, ACTIVE, OVERRIDE, CREATE_BY, CREATE_ON, MODIFY_BY, MODIFY_ON ) VALUES ( 
'33318WUY', '22200000Q7C', 'ATTACHMENT', 'ACT.OTHER', 'Other', 'ATTACHMENT', NULL, NULL, NULL, NULL, 'Y', 'N', 'timothy.ward',  TO_Date( '08/21/2012 12:28:33 PM', 'MM/DD/YYYY HH:MI:SS AM'), 'timothy.ward',  TO_Date( '08/21/2012 12:28:33 PM', 'MM/DD/YYYY HH:MI:SS AM')); 
INSERT INTO T_OSI_ATTACHMENT_TYPE ( SID, OBJ_TYPE, USAGE, CODE, DESCRIPTION, MIME_DISPOSITION, MIN_NUM, MAX_NUM, LOCK_MODE, SEQ, ACTIVE, OVERRIDE, CREATE_BY, CREATE_ON, MODIFY_BY, MODIFY_ON ) VALUES ( 
'33318WUZ', '22200000Q7D', 'ATTACHMENT', 'ACT.OTHER', 'Other', 'ATTACHMENT', NULL, NULL, NULL, NULL, 'Y', 'N', 'timothy.ward',  TO_Date( '08/21/2012 12:28:33 PM', 'MM/DD/YYYY HH:MI:SS AM'), 'timothy.ward',  TO_Date( '08/21/2012 12:28:33 PM', 'MM/DD/YYYY HH:MI:SS AM')); 
INSERT INTO T_OSI_ATTACHMENT_TYPE ( SID, OBJ_TYPE, USAGE, CODE, DESCRIPTION, MIME_DISPOSITION, MIN_NUM, MAX_NUM, LOCK_MODE, SEQ, ACTIVE, OVERRIDE, CREATE_BY, CREATE_ON, MODIFY_BY, MODIFY_ON ) VALUES ( 
'33318WV0', '22200000RWN', 'ATTACHMENT', 'ACT.OTHER', 'Other', 'ATTACHMENT', NULL, NULL, NULL, NULL, 'Y', 'N', 'timothy.ward',  TO_Date( '08/21/2012 12:28:33 PM', 'MM/DD/YYYY HH:MI:SS AM'), 'timothy.ward',  TO_Date( '08/21/2012 12:28:33 PM', 'MM/DD/YYYY HH:MI:SS AM')); 
INSERT INTO T_OSI_ATTACHMENT_TYPE ( SID, OBJ_TYPE, USAGE, CODE, DESCRIPTION, MIME_DISPOSITION, MIN_NUM, MAX_NUM, LOCK_MODE, SEQ, ACTIVE, OVERRIDE, CREATE_BY, CREATE_ON, MODIFY_BY, MODIFY_ON ) VALUES ( 
'33318WV1', '2220110E', 'ATTACHMENT', 'ACT.OTHER', 'Other', 'ATTACHMENT', NULL, NULL, NULL, NULL, 'Y', 'N', 'timothy.ward',  TO_Date( '08/21/2012 12:28:33 PM', 'MM/DD/YYYY HH:MI:SS AM'), 'timothy.ward',  TO_Date( '08/21/2012 12:28:33 PM', 'MM/DD/YYYY HH:MI:SS AM')); 
INSERT INTO T_OSI_ATTACHMENT_TYPE ( SID, OBJ_TYPE, USAGE, CODE, DESCRIPTION, MIME_DISPOSITION, MIN_NUM, MAX_NUM, LOCK_MODE, SEQ, ACTIVE, OVERRIDE, CREATE_BY, CREATE_ON, MODIFY_BY, MODIFY_ON ) VALUES ( 
'33318WV2', '2220116Y', 'ATTACHMENT', 'ACT.OTHER', 'Other', 'ATTACHMENT', NULL, NULL, NULL, NULL, 'Y', 'N', 'timothy.ward',  TO_Date( '08/21/2012 12:28:33 PM', 'MM/DD/YYYY HH:MI:SS AM'), 'timothy.ward',  TO_Date( '08/21/2012 12:28:33 PM', 'MM/DD/YYYY HH:MI:SS AM')); 
INSERT INTO T_OSI_ATTACHMENT_TYPE ( SID, OBJ_TYPE, USAGE, CODE, DESCRIPTION, MIME_DISPOSITION, MIN_NUM, MAX_NUM, LOCK_MODE, SEQ, ACTIVE, OVERRIDE, CREATE_BY, CREATE_ON, MODIFY_BY, MODIFY_ON ) VALUES ( 
'33318WV3', '22201170', 'ATTACHMENT', 'ACT.OTHER', 'Other', 'ATTACHMENT', NULL, NULL, NULL, NULL, 'Y', 'N', 'timothy.ward',  TO_Date( '08/21/2012 12:28:33 PM', 'MM/DD/YYYY HH:MI:SS AM'), 'timothy.ward',  TO_Date( '08/21/2012 12:28:33 PM', 'MM/DD/YYYY HH:MI:SS AM')); 
INSERT INTO T_OSI_ATTACHMENT_TYPE ( SID, OBJ_TYPE, USAGE, CODE, DESCRIPTION, MIME_DISPOSITION, MIN_NUM, MAX_NUM, LOCK_MODE, SEQ, ACTIVE, OVERRIDE, CREATE_BY, CREATE_ON, MODIFY_BY, MODIFY_ON ) VALUES ( 
'33318WV4', '22201172', 'ATTACHMENT', 'ACT.OTHER', 'Other', 'ATTACHMENT', NULL, NULL, NULL, NULL, 'Y', 'N', 'timothy.ward',  TO_Date( '08/21/2012 12:28:33 PM', 'MM/DD/YYYY HH:MI:SS AM'), 'timothy.ward',  TO_Date( '08/21/2012 12:28:33 PM', 'MM/DD/YYYY HH:MI:SS AM')); 
INSERT INTO T_OSI_ATTACHMENT_TYPE ( SID, OBJ_TYPE, USAGE, CODE, DESCRIPTION, MIME_DISPOSITION, MIN_NUM, MAX_NUM, LOCK_MODE, SEQ, ACTIVE, OVERRIDE, CREATE_BY, CREATE_ON, MODIFY_BY, MODIFY_ON ) VALUES ( 
'33318WV5', '22203423', 'ATTACHMENT', 'ACT.OTHER', 'Other', 'ATTACHMENT', NULL, NULL, NULL, NULL, 'Y', 'N', 'timothy.ward',  TO_Date( '08/21/2012 12:28:33 PM', 'MM/DD/YYYY HH:MI:SS AM'), 'timothy.ward',  TO_Date( '08/21/2012 12:28:33 PM', 'MM/DD/YYYY HH:MI:SS AM')); 
INSERT INTO T_OSI_ATTACHMENT_TYPE ( SID, OBJ_TYPE, USAGE, CODE, DESCRIPTION, MIME_DISPOSITION, MIN_NUM, MAX_NUM, LOCK_MODE, SEQ, ACTIVE, OVERRIDE, CREATE_BY, CREATE_ON, MODIFY_BY, MODIFY_ON ) VALUES ( 
'33318WV6', '22203BP4', 'ATTACHMENT', 'ACT.OTHER', 'Other', 'ATTACHMENT', NULL, NULL, NULL, NULL, 'Y', 'N', 'timothy.ward',  TO_Date( '08/21/2012 12:28:33 PM', 'MM/DD/YYYY HH:MI:SS AM'), 'timothy.ward',  TO_Date( '08/21/2012 12:28:33 PM', 'MM/DD/YYYY HH:MI:SS AM')); 
INSERT INTO T_OSI_ATTACHMENT_TYPE ( SID, OBJ_TYPE, USAGE, CODE, DESCRIPTION, MIME_DISPOSITION, MIN_NUM, MAX_NUM, LOCK_MODE, SEQ, ACTIVE, OVERRIDE, CREATE_BY, CREATE_ON, MODIFY_BY, MODIFY_ON ) VALUES ( 
'33318WV7', '22203D0A', 'ATTACHMENT', 'ACT.OTHER', 'Other', 'ATTACHMENT', NULL, NULL, NULL, NULL, 'Y', 'N', 'timothy.ward',  TO_Date( '08/21/2012 12:28:33 PM', 'MM/DD/YYYY HH:MI:SS AM'), 'timothy.ward',  TO_Date( '08/21/2012 12:28:33 PM', 'MM/DD/YYYY HH:MI:SS AM')); 
---INSERT INTO T_OSI_ATTACHMENT_TYPE ( SID, OBJ_TYPE, USAGE, CODE, DESCRIPTION, MIME_DISPOSITION, MIN_NUM, MAX_NUM, LOCK_MODE, SEQ, ACTIVE, OVERRIDE, CREATE_BY, CREATE_ON, MODIFY_BY, MODIFY_ON ) VALUES ( 
---'33318WV8', '33315ZPW', 'ATTACHMENT', 'ACT.OTHER', 'Other', 'ATTACHMENT', NULL, NULL, NULL, NULL, 'Y', 'N', 'timothy.ward',  TO_Date( '08/21/2012 12:28:33 PM', 'MM/DD/YYYY HH:MI:SS AM'), 'timothy.ward',  TO_Date( '08/21/2012 12:28:33 PM', 'MM/DD/YYYY HH:MI:SS AM')); 
INSERT INTO T_OSI_ATTACHMENT_TYPE ( SID, OBJ_TYPE, USAGE, CODE, DESCRIPTION, MIME_DISPOSITION, MIN_NUM, MAX_NUM, LOCK_MODE, SEQ, ACTIVE, OVERRIDE, CREATE_BY, CREATE_ON, MODIFY_BY, MODIFY_ON ) VALUES ( 
'33318WV9', '333164T0', 'ATTACHMENT', 'ACT.OTHER', 'Other', 'ATTACHMENT', NULL, NULL, NULL, NULL, 'Y', 'N', 'timothy.ward',  TO_Date( '08/21/2012 12:28:33 PM', 'MM/DD/YYYY HH:MI:SS AM'), 'timothy.ward',  TO_Date( '08/21/2012 12:28:33 PM', 'MM/DD/YYYY HH:MI:SS AM')); 
INSERT INTO T_OSI_ATTACHMENT_TYPE ( SID, OBJ_TYPE, USAGE, CODE, DESCRIPTION, MIME_DISPOSITION, MIN_NUM, MAX_NUM, LOCK_MODE, SEQ, ACTIVE, OVERRIDE, CREATE_BY, CREATE_ON, MODIFY_BY, MODIFY_ON ) VALUES ( 
'33318WVA', '333164T1', 'ATTACHMENT', 'ACT.OTHER', 'Other', 'ATTACHMENT', NULL, NULL, NULL, NULL, 'Y', 'N', 'timothy.ward',  TO_Date( '08/21/2012 12:28:33 PM', 'MM/DD/YYYY HH:MI:SS AM'), 'timothy.ward',  TO_Date( '08/21/2012 12:28:33 PM', 'MM/DD/YYYY HH:MI:SS AM')); 
INSERT INTO T_OSI_ATTACHMENT_TYPE ( SID, OBJ_TYPE, USAGE, CODE, DESCRIPTION, MIME_DISPOSITION, MIN_NUM, MAX_NUM, LOCK_MODE, SEQ, ACTIVE, OVERRIDE, CREATE_BY, CREATE_ON, MODIFY_BY, MODIFY_ON ) VALUES ( 
'33318WVB', '333164T2', 'ATTACHMENT', 'ACT.OTHER', 'Other', 'ATTACHMENT', NULL, NULL, NULL, NULL, 'Y', 'N', 'timothy.ward',  TO_Date( '08/21/2012 12:28:33 PM', 'MM/DD/YYYY HH:MI:SS AM'), 'timothy.ward',  TO_Date( '08/21/2012 12:28:33 PM', 'MM/DD/YYYY HH:MI:SS AM')); 
INSERT INTO T_OSI_ATTACHMENT_TYPE ( SID, OBJ_TYPE, USAGE, CODE, DESCRIPTION, MIME_DISPOSITION, MIN_NUM, MAX_NUM, LOCK_MODE, SEQ, ACTIVE, OVERRIDE, CREATE_BY, CREATE_ON, MODIFY_BY, MODIFY_ON ) VALUES ( 
'33318WVC', '33317VAI', 'ATTACHMENT', 'ACT.OTHER', 'Other', 'ATTACHMENT', NULL, NULL, NULL, NULL, 'Y', 'N', 'timothy.ward',  TO_Date( '08/21/2012 12:28:33 PM', 'MM/DD/YYYY HH:MI:SS AM'), 'timothy.ward',  TO_Date( '08/21/2012 12:28:33 PM', 'MM/DD/YYYY HH:MI:SS AM')); 
INSERT INTO T_OSI_ATTACHMENT_TYPE ( SID, OBJ_TYPE, USAGE, CODE, DESCRIPTION, MIME_DISPOSITION, MIN_NUM, MAX_NUM, LOCK_MODE, SEQ, ACTIVE, OVERRIDE, CREATE_BY, CREATE_ON, MODIFY_BY, MODIFY_ON ) VALUES ( 
'33318WVD', '33317VAJ', 'ATTACHMENT', 'ACT.OTHER', 'Other', 'ATTACHMENT', NULL, NULL, NULL, NULL, 'Y', 'N', 'timothy.ward',  TO_Date( '08/21/2012 12:28:33 PM', 'MM/DD/YYYY HH:MI:SS AM'), 'timothy.ward',  TO_Date( '08/21/2012 12:28:33 PM', 'MM/DD/YYYY HH:MI:SS AM')); 
INSERT INTO T_OSI_ATTACHMENT_TYPE ( SID, OBJ_TYPE, USAGE, CODE, DESCRIPTION, MIME_DISPOSITION, MIN_NUM, MAX_NUM, LOCK_MODE, SEQ, ACTIVE, OVERRIDE, CREATE_BY, CREATE_ON, MODIFY_BY, MODIFY_ON ) VALUES ( 
'33318WVE', '33317VAK', 'ATTACHMENT', 'ACT.OTHER', 'Other', 'ATTACHMENT', NULL, NULL, NULL, NULL, 'Y', 'N', 'timothy.ward',  TO_Date( '08/21/2012 12:28:33 PM', 'MM/DD/YYYY HH:MI:SS AM'), 'timothy.ward',  TO_Date( '08/21/2012 12:28:33 PM', 'MM/DD/YYYY HH:MI:SS AM')); 
INSERT INTO T_OSI_ATTACHMENT_TYPE ( SID, OBJ_TYPE, USAGE, CODE, DESCRIPTION, MIME_DISPOSITION, MIN_NUM, MAX_NUM, LOCK_MODE, SEQ, ACTIVE, OVERRIDE, CREATE_BY, CREATE_ON, MODIFY_BY, MODIFY_ON ) VALUES ( 
'33318WVF', '33317VAL', 'ATTACHMENT', 'ACT.OTHER', 'Other', 'ATTACHMENT', NULL, NULL, NULL, NULL, 'Y', 'N', 'timothy.ward',  TO_Date( '08/21/2012 12:28:33 PM', 'MM/DD/YYYY HH:MI:SS AM'), 'timothy.ward',  TO_Date( '08/21/2012 12:28:33 PM', 'MM/DD/YYYY HH:MI:SS AM')); 
INSERT INTO T_OSI_ATTACHMENT_TYPE ( SID, OBJ_TYPE, USAGE, CODE, DESCRIPTION, MIME_DISPOSITION, MIN_NUM, MAX_NUM, LOCK_MODE, SEQ, ACTIVE, OVERRIDE, CREATE_BY, CREATE_ON, MODIFY_BY, MODIFY_ON ) VALUES ( 
'33318WVG', '33317VAM', 'ATTACHMENT', 'ACT.OTHER', 'Other', 'ATTACHMENT', NULL, NULL, NULL, NULL, 'Y', 'N', 'timothy.ward',  TO_Date( '08/21/2012 12:28:33 PM', 'MM/DD/YYYY HH:MI:SS AM'), 'timothy.ward',  TO_Date( '08/21/2012 12:28:33 PM', 'MM/DD/YYYY HH:MI:SS AM')); 
INSERT INTO T_OSI_ATTACHMENT_TYPE ( SID, OBJ_TYPE, USAGE, CODE, DESCRIPTION, MIME_DISPOSITION, MIN_NUM, MAX_NUM, LOCK_MODE, SEQ, ACTIVE, OVERRIDE, CREATE_BY, CREATE_ON, MODIFY_BY, MODIFY_ON ) VALUES ( 
'33318WVH', '33317VAN', 'ATTACHMENT', 'ACT.OTHER', 'Other', 'ATTACHMENT', NULL, NULL, NULL, NULL, 'Y', 'N', 'timothy.ward',  TO_Date( '08/21/2012 12:28:33 PM', 'MM/DD/YYYY HH:MI:SS AM'), 'timothy.ward',  TO_Date( '08/21/2012 12:28:33 PM', 'MM/DD/YYYY HH:MI:SS AM')); 
INSERT INTO T_OSI_ATTACHMENT_TYPE ( SID, OBJ_TYPE, USAGE, CODE, DESCRIPTION, MIME_DISPOSITION, MIN_NUM, MAX_NUM, LOCK_MODE, SEQ, ACTIVE, OVERRIDE, CREATE_BY, CREATE_ON, MODIFY_BY, MODIFY_ON ) VALUES ( 
'33318WVI', '33317VAO', 'ATTACHMENT', 'ACT.OTHER', 'Other', 'ATTACHMENT', NULL, NULL, NULL, NULL, 'Y', 'N', 'timothy.ward',  TO_Date( '08/21/2012 12:28:33 PM', 'MM/DD/YYYY HH:MI:SS AM'), 'timothy.ward',  TO_Date( '08/21/2012 12:28:33 PM', 'MM/DD/YYYY HH:MI:SS AM')); 
INSERT INTO T_OSI_ATTACHMENT_TYPE ( SID, OBJ_TYPE, USAGE, CODE, DESCRIPTION, MIME_DISPOSITION, MIN_NUM, MAX_NUM, LOCK_MODE, SEQ, ACTIVE, OVERRIDE, CREATE_BY, CREATE_ON, MODIFY_BY, MODIFY_ON ) VALUES ( 
'33318WVJ', '33317VAP', 'ATTACHMENT', 'ACT.OTHER', 'Other', 'ATTACHMENT', NULL, NULL, NULL, NULL, 'Y', 'N', 'timothy.ward',  TO_Date( '08/21/2012 12:28:33 PM', 'MM/DD/YYYY HH:MI:SS AM'), 'timothy.ward',  TO_Date( '08/21/2012 12:28:33 PM', 'MM/DD/YYYY HH:MI:SS AM')); 
INSERT INTO T_OSI_ATTACHMENT_TYPE ( SID, OBJ_TYPE, USAGE, CODE, DESCRIPTION, MIME_DISPOSITION, MIN_NUM, MAX_NUM, LOCK_MODE, SEQ, ACTIVE, OVERRIDE, CREATE_BY, CREATE_ON, MODIFY_BY, MODIFY_ON ) VALUES ( 
'33318WVK', '33317VAQ', 'ATTACHMENT', 'ACT.OTHER', 'Other', 'ATTACHMENT', NULL, NULL, NULL, NULL, 'Y', 'N', 'timothy.ward',  TO_Date( '08/21/2012 12:28:33 PM', 'MM/DD/YYYY HH:MI:SS AM'), 'timothy.ward',  TO_Date( '08/21/2012 12:28:33 PM', 'MM/DD/YYYY HH:MI:SS AM')); 
INSERT INTO T_OSI_ATTACHMENT_TYPE ( SID, OBJ_TYPE, USAGE, CODE, DESCRIPTION, MIME_DISPOSITION, MIN_NUM, MAX_NUM, LOCK_MODE, SEQ, ACTIVE, OVERRIDE, CREATE_BY, CREATE_ON, MODIFY_BY, MODIFY_ON ) VALUES ( 
'33318WVL', '33317VAR', 'ATTACHMENT', 'ACT.OTHER', 'Other', 'ATTACHMENT', NULL, NULL, NULL, NULL, 'Y', 'N', 'timothy.ward',  TO_Date( '08/21/2012 12:28:33 PM', 'MM/DD/YYYY HH:MI:SS AM'), 'timothy.ward',  TO_Date( '08/21/2012 12:28:33 PM', 'MM/DD/YYYY HH:MI:SS AM')); 
INSERT INTO T_OSI_ATTACHMENT_TYPE ( SID, OBJ_TYPE, USAGE, CODE, DESCRIPTION, MIME_DISPOSITION, MIN_NUM, MAX_NUM, LOCK_MODE, SEQ, ACTIVE, OVERRIDE, CREATE_BY, CREATE_ON, MODIFY_BY, MODIFY_ON ) VALUES ( 
'33318WVM', '33317VAS', 'ATTACHMENT', 'ACT.OTHER', 'Other', 'ATTACHMENT', NULL, NULL, NULL, NULL, 'Y', 'N', 'timothy.ward',  TO_Date( '08/21/2012 12:28:33 PM', 'MM/DD/YYYY HH:MI:SS AM'), 'timothy.ward',  TO_Date( '08/21/2012 12:28:33 PM', 'MM/DD/YYYY HH:MI:SS AM')); 
INSERT INTO T_OSI_ATTACHMENT_TYPE ( SID, OBJ_TYPE, USAGE, CODE, DESCRIPTION, MIME_DISPOSITION, MIN_NUM, MAX_NUM, LOCK_MODE, SEQ, ACTIVE, OVERRIDE, CREATE_BY, CREATE_ON, MODIFY_BY, MODIFY_ON ) VALUES ( 
'33318WVN', '33317VAT', 'ATTACHMENT', 'ACT.OTHER', 'Other', 'ATTACHMENT', NULL, NULL, NULL, NULL, 'Y', 'N', 'timothy.ward',  TO_Date( '08/21/2012 12:28:33 PM', 'MM/DD/YYYY HH:MI:SS AM'), 'timothy.ward',  TO_Date( '08/21/2012 12:28:33 PM', 'MM/DD/YYYY HH:MI:SS AM')); 
INSERT INTO T_OSI_ATTACHMENT_TYPE ( SID, OBJ_TYPE, USAGE, CODE, DESCRIPTION, MIME_DISPOSITION, MIN_NUM, MAX_NUM, LOCK_MODE, SEQ, ACTIVE, OVERRIDE, CREATE_BY, CREATE_ON, MODIFY_BY, MODIFY_ON ) VALUES ( 
'33318WVO', '33317VAU', 'ATTACHMENT', 'ACT.OTHER', 'Other', 'ATTACHMENT', NULL, NULL, NULL, NULL, 'Y', 'N', 'timothy.ward',  TO_Date( '08/21/2012 12:28:33 PM', 'MM/DD/YYYY HH:MI:SS AM'), 'timothy.ward',  TO_Date( '08/21/2012 12:28:33 PM', 'MM/DD/YYYY HH:MI:SS AM')); 
INSERT INTO T_OSI_ATTACHMENT_TYPE ( SID, OBJ_TYPE, USAGE, CODE, DESCRIPTION, MIME_DISPOSITION, MIN_NUM, MAX_NUM, LOCK_MODE, SEQ, ACTIVE, OVERRIDE, CREATE_BY, CREATE_ON, MODIFY_BY, MODIFY_ON ) VALUES ( 
'33318WVP', '33317VAV', 'ATTACHMENT', 'ACT.OTHER', 'Other', 'ATTACHMENT', NULL, NULL, NULL, NULL, 'Y', 'N', 'timothy.ward',  TO_Date( '08/21/2012 12:28:33 PM', 'MM/DD/YYYY HH:MI:SS AM'), 'timothy.ward',  TO_Date( '08/21/2012 12:28:33 PM', 'MM/DD/YYYY HH:MI:SS AM')); 
INSERT INTO T_OSI_ATTACHMENT_TYPE ( SID, OBJ_TYPE, USAGE, CODE, DESCRIPTION, MIME_DISPOSITION, MIN_NUM, MAX_NUM, LOCK_MODE, SEQ, ACTIVE, OVERRIDE, CREATE_BY, CREATE_ON, MODIFY_BY, MODIFY_ON ) VALUES ( 
'33318WVQ', '33317VN7', 'ATTACHMENT', 'ACT.OTHER', 'Other', 'ATTACHMENT', NULL, NULL, NULL, NULL, 'Y', 'N', 'timothy.ward',  TO_Date( '08/21/2012 12:28:33 PM', 'MM/DD/YYYY HH:MI:SS AM'), 'timothy.ward',  TO_Date( '08/21/2012 12:28:33 PM', 'MM/DD/YYYY HH:MI:SS AM')); 
INSERT INTO T_OSI_ATTACHMENT_TYPE ( SID, OBJ_TYPE, USAGE, CODE, DESCRIPTION, MIME_DISPOSITION, MIN_NUM, MAX_NUM, LOCK_MODE, SEQ, ACTIVE, OVERRIDE, CREATE_BY, CREATE_ON, MODIFY_BY, MODIFY_ON ) VALUES ( 
'33318WVR', '33318QCZ', 'ATTACHMENT', 'ACT.OTHER', 'Other', 'ATTACHMENT', NULL, NULL, NULL, NULL, 'Y', 'N', 'timothy.ward',  TO_Date( '08/21/2012 12:28:33 PM', 'MM/DD/YYYY HH:MI:SS AM'), 'timothy.ward',  TO_Date( '08/21/2012 12:28:33 PM', 'MM/DD/YYYY HH:MI:SS AM')); 
INSERT INTO T_OSI_ATTACHMENT_TYPE ( SID, OBJ_TYPE, USAGE, CODE, DESCRIPTION, MIME_DISPOSITION, MIN_NUM, MAX_NUM, LOCK_MODE, SEQ, ACTIVE, OVERRIDE, CREATE_BY, CREATE_ON, MODIFY_BY, MODIFY_ON ) VALUES ( 
'33318WVS', '33318SVJ', 'ATTACHMENT', 'ACT.OTHER', 'Other', 'ATTACHMENT', NULL, NULL, NULL, NULL, 'Y', 'N', 'timothy.ward',  TO_Date( '08/21/2012 12:28:33 PM', 'MM/DD/YYYY HH:MI:SS AM'), 'timothy.ward',  TO_Date( '08/21/2012 12:28:33 PM', 'MM/DD/YYYY HH:MI:SS AM')); 
COMMIT;


alter trigger OSI_ACT_B_IUD_BUMP disable;

ALTER TABLE T_OSI_ACTIVITY ADD LEADERSHIP_APPROVED VARCHAR2(1) DEFAULT 'N';

alter trigger OSI_ACT_B_IUD_BUMP enable;
CREATE OR REPLACE VIEW V_OSI_ACTIVITY_SUMMARY
(SID, ID, TITLE, CREATE_ON, CREATE_BY, 
 RESTRICTION, ACTIVITY_DATE, CREATING_UNIT, ASSIGNED_UNIT, AUXILIARY_UNIT, 
 COMPLETE_DATE, SUSPENSE_DATE, CLOSE_DATE, CURRENT_STATUS, INV_SUPPORT, 
 NARRATIVE, OBJECT_TYPE_DESCRIPTION, OBJECT_TYPE_CODE, OBJECT_TYPE_SID, SUBSTANTIVE, 
 LEADERSHIP_APPROVED)
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
           leadership_approved
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
           substantive = :new.substantive,
           leadership_approved = :new.leadership_approved
     where sid = :new.sid;

    if nvl(:new.inv_support, 'null') <> nvl(:old.inv_support, 'null') then
        osi_activity.set_inv_support(:new.sid, :new.inv_support);
    end if;

    core_obj.bump(:new.sid);
end;
/


CREATE OR REPLACE VIEW V_OSI_ASSOC_FLE_ACT
(SID, FILE_SID, FILE_ID, FILE_TITLE, FILE_TYPE_DESC, 
 ACTIVITY_SID, ACTIVITY_ID, ACTIVITY_TITLE, ACTIVITY_TYPE_DESC, ACTIVITY_COMPLETE_DATE, 
 ACTIVITY_CLOSE_DATE, ACTIVITY_DATE, ACTIVITY_SUSPENSE_DATE, ACTIVITY_UNIT_ASSIGNED, SUBSTANTIVE, LEADERSHIP_APPROVED, 
 SOURCE)
AS 
select oafa.sid, oafa.file_sid, of1.id as "FILE_ID", of1.title as "FILE_TITLE",
           cot1.description as "FILE_TYPE_DESC", oafa.activity_sid, oa.id as "ACTIVITY_ID",
           oa.title as "ACTIVITY_TITLE", cot2.description as "ACTIVITY_TYPE_DESC",
           oa.complete_date as "ACTIVITY_COMPLETE_DATE", oa.close_date as "ACTIVITY_CLOSE_DATE",
           oa.activity_date as "ACTIVITY_DATE", oa.suspense_date as "ACTIVITY_SUSPENSE_DATE", 
           osi_unit.get_name(oa.assigned_unit) as "ACTIVITY_UNIT_ASSIGNED",
           oa.substantive as "SUBSTANTIVE",
           oa.leadership_approved as "APPROVED",
           oa.source as "SOURCE"
    from   t_osi_assoc_fle_act oafa,
           t_osi_file of1,
           t_core_obj co1,
           t_core_obj_type cot1,
           t_osi_activity oa,
           t_core_obj co2,
           t_core_obj_type cot2
     where of1.sid = oafa.file_sid
       and of1.sid = co1.sid
       and cot1.sid = co1.obj_type
       and oa.sid = oafa.activity_sid
       and oa.sid = co2.sid
       and cot2.sid = co2.obj_type
/


CREATE OR REPLACE VIEW V_OSI_ASSOC_SOURCE_MEET
(SID, FILE_SID, FILE_ID, FILE_TITLE, FILE_TYPE_DESC, 
 ACTIVITY_SID, ACTIVITY_ID, ACTIVITY_TITLE, ACTIVITY_TYPE_DESC, ACTIVITY_COMPLETE_DATE, 
 ACTIVITY_CLOSE_DATE, ACTIVITY_DATE, ACTIVITY_SUSPENSE_DATE, ACTIVITY_UNIT_ASSIGNED, SUBSTANTIVE, LEADERSHIP_APPROVED)
AS 
select oasm.sid, of1.sid, of1.id as "FILE_ID", of1.title as "FILE_TITLE",
           cot1.description as "FILE_TYPE_DESC", oasm.sid, oa.id as "ACTIVITY_ID",
           oa.title as "ACTIVITY_TITLE", cot2.description as "ACTIVITY_TYPE_DESC",
           oa.complete_date as "ACTIVITY_COMPLETE_DATE", oa.close_date as "ACTIVITY_CLOSE_DATE",
           oa.activity_date as "ACTIVITY_DATE", oa.suspense_date as "ACTIVITY_SUSPENSE_DATE", 
           osi_unit.get_name(oa.assigned_unit) as "ACTIVITY_UNIT_ASSIGNED",
           oa.substantive as "SUBSTANTIVE",
           oa.leadership_approved as "APPROVED"
    from   t_osi_a_source_meet oasm,
           t_osi_file of1,
           t_core_obj co1,
           t_core_obj_type cot1,
           t_osi_activity oa,
           t_core_obj co2,
           t_core_obj_type cot2
     where of1.sid = co1.sid
       and cot1.sid = co1.obj_type
       and oa.sid = oasm.sid
       and oa.sid = co2.sid
       and cot2.sid = co2.obj_type
       and cot2.code='ACT.SOURCE_MEET'
       and oa.source=of1.sid
/


INSERT INTO T_OSI_AUTH_PRIV ( SID, OBJ_TYPE, ACTION, CREATE_BY, CREATE_ON, MODIFY_BY, MODIFY_ON, DESCRIPTION ) VALUES ( '33318VYI', '2220000083O', '222011NJ', 'timothy.ward',  TO_Date( '08/14/2012 07:05:13 AM', 'MM/DD/YYYY HH:MI:SS AM'), 'timothy.ward',  TO_Date( '08/14/2012 07:05:13 AM', 'MM/DD/YYYY HH:MI:SS AM'), 'Activity Approval'); 
COMMIT;

INSERT INTO T_OSI_AUTH_ROLE_PRIV ( ROLE, PRIV, GRANTABLE, ENABLED ) 
SELECT SID,'33318VYI','Y','Y' FROM T_OSI_AUTH_ROLE
  WHERE CODE IN ('BRANCH','COMMANDER','HQCOMMAND','HQPMO','HQSUPER','IMACC','IMASUPER','RGNCOMMAND','RGNDD','RGNIMA','RGNSC','RGNSUPER','RGNVC','SQDCOMMAND','SUPER')
 ORDER BY CODE;
COMMIT;

set define off;

CREATE OR REPLACE package body osi_activity as
/******************************************************************************
   Name:     Osi_Activity
   Purpose:  Provides Functionality For Activity Objects.

   Revisions:
    Date        Author          Description
    ----------  --------------  ------------------------------------
     7-Apr-2009 T.McGuffin      Created Package.
    28-Apr-2009 T.McGuffin      Modified Get_Tagline To Only Return Title.
    27-May-2009 T.McGuffin      Added Create_Instance function.
    01-Jun-2009 T.McGuffin      Added Get_ID function.
    04-Jun-2009 T.McGuffin      Added Get_Inv_Support function and Set_Inv_Support procedure.
    16-Jun-2009 T.McGuffin      Removed subtype from Create Instance.
    30-Jun-2009 T.McGuffin      Phased out CORE ACL for simple Restriction.
    06-Jul-2009 R.Dibble        Added get_activity_date
    15-Oct-2009 J.Faris         Added can_delete.
    28-Oct-2009 R.Dibble        Added generate_form_40
    16-Nov-2009 R.Dibble        Added get_title
    02-Dec-2009 R.Dibble        Modified generate_form_40 to utilize CORE_TEMPLATE procedure calls
    09-Dec-2009 T.McGuffin      Modified get_f40_place for the briefing activity.
    23-Dec-2009 T.Whitehead     Added get_source.
    30-Dec-2009 T.Whitehead     Added get_file.
    10-Feb-2010 T.McGuffin      Added check_writability function.
    10-Feb-2010 T.McGuffin      Modified can_delete to include cfunds expenses.
    26-Feb-2010 T.McGuffin      Modified generate_form_40 to remove get_activity_lead function to
                                replace the call with osi_object.get_lead_agent.
     4-Apr-2010 J.Faris         Updated check_writability to accommodate object type specific rules.
     9-Apr-2010 J.Faris         Added Susp Act specific privilege check of 'SAR.EDIT' to can_delete.
    25-May-2010 T.Leighty       Added make_doc_act
    25-Jun-2010 T.McGuffin      Added get_oldest_file
     5-Aug-2010 J.Faris         Added generate_form_40_summary.
    18-Mar-2011 Tim Ward        CR#3731 - Privilege needs to be checked in here now since the
                                 checkForPriv from i2ms.js deleteObj function.
                                 Fixed the Pending check for deletion with workhours.
                                 Changed for loops to select count(*).
                                 Changed in can_delete.
    24-Jan-2012 Tim Ward        CR#3959 - Form 40 Report fails when there is no lead agent.
                                 Changed generate_form_40 and generate_form_40_summary.
                                 Pulled get_f40_place from both generate_form_40 functions so it
                                 is only in one place.
    30-Apr-2012 Tim Ward        CR#4043 - Changed parameters to create_instance.
                                 All Activities now call this for creation.
    09-May-2012 Tim Ward        CR#4045 - Added substantive parameter create_instance.
    17-Jul-2012 Tim Ward        CR#4048 - Interview Form 40 Changes.
                                 Changed in generate_form_40 and get_attachment_list.
    24-Jul-2012 Tim Ward        CR#4049 - Law Enforcement Records Check Form 40 Changes.
                                 Changed in generate_form_40.
    30-Jul-2012 Tim Ward        CR#4050 - Law Enforcement Records Check Form 40 Changes.
                                 Changed in generate_form_40.
    14-Aug-2012 Tim Ward        CR#4054 - Added a check for Leadership approval before 
                                 generating the Form 40.
                                 Changed in generate_form_40.
    03-Oct-2012 Tim Ward        CR#4054 - Get rid of the last ';' in the attachment list.
                                 Changed in generate_form_40.                                 
    03-Oct-2012 Tim Ward        CR#4054 - Since Leadership approved is being hidden for 
                                 ACT.CONSULTATION, make sure it defaults to 'Y'.
                                 Changed in create_instance.
    04-Oct-2012 Tim Ward        CR#4054 - ALL FORM 40's need to show Case file and new
                                 stuff that I only included in Interviews, Document Reviews,
                                 and Record Checks.  Also only show Participant Information
                                 for activities that have participants, for the others
                                 show the title instead.
                                 Changed in generate_form_40.                                 
******************************************************************************/
    c_pipe        varchar2(100)  := core_util.get_config('CORE.PIPE_PREFIX') || 'OSI_ACTIVITY';
    v_syn_error   varchar2(4000) := null;

    procedure log_error(p_msg in varchar2) is
    begin
        core_logger.log_it(c_pipe, p_msg);
    end log_error;

    function get_file(p_obj in varchar2)
        return varchar2 is
    begin
        for x in (select   file_sid
                      from t_osi_assoc_fle_act
                     where activity_sid = p_obj
                  order by create_on asc)
        loop
            return x.file_sid;
        end loop;

        return null;
    exception
        when others then
            log_error('get_file: ' || sqlerrm);
            return null;
    end get_file;

    function get_tagline(p_obj in varchar2)
        return varchar2 is
        v_title   t_osi_activity.title%type;
    begin
        select title
          into v_title
          from t_osi_activity
         where SID = p_obj;

        return v_title;
    exception
        when others then
            log_error('get_tagline: ' || sqlerrm);
            return 'get_tagline: Error';
    end get_tagline;

    function get_id(p_obj in varchar2)
        return varchar2 is
        v_id   t_osi_activity.id%type;
    begin
        if p_obj is null then
            log_error('get_id: null value passed');
            return null;
        end if;

        select id
          into v_id
          from t_osi_activity
         where SID = p_obj;

        return v_id;
    exception
        when no_data_found then
            return null;
        when others then
            log_error('get_id: ' || sqlerrm);
    end get_id;

    /* Given and activity sid as p_obj, returns the title of the activity */
    function get_title(p_obj in varchar2)
        return varchar2 is
        v_title   t_osi_activity.id%type;
    begin
        if p_obj is null then
            log_error('get_title: null value passed');
            return null;
        end if;

        select title
          into v_title
          from t_osi_activity
         where SID = p_obj;

        return v_title;
    exception
        when no_data_found then
            return null;
        when others then
            log_error('get_title: ' || sqlerrm);
    end get_title;

    function get_source(p_obj in varchar2)
        return varchar2 is
    begin
        for x in (select source
                    from t_osi_activity
                   where SID = p_obj)
        loop
            return x.source;
        end loop;

        return null;
    exception
        when others then
            log_error('get_source: ' || sqlerrm);
            return null;
    end get_source;

    function get_summary(p_obj in varchar2, p_variant in varchar2 := null)
        return clob is
    begin
        return 'Activity Summary';
    exception
        when others then
            log_error('get_summary: ' || sqlerrm);
            return 'get_summary: Error';
    end get_summary;

    procedure index1(p_obj in varchar2, p_clob in out nocopy clob) is
    begin
        p_clob := 'Activity Index1 XML Clob';
    exception
        when others then
            log_error('index1: ' || sqlerrm);
    end index1;

    function get_status(p_obj in varchar2)
        return varchar2 is
    begin
        return osi_object.get_status(p_obj);
    exception
        when others then
            log_error('get_status: ' || sqlerrm);
            return 'get_status: Error';
    end get_status;

    function create_instance(p_obj_type_sid in varchar2,p_act_date in date,p_title in varchar2,p_restriction in varchar2,p_narrative in clob,p_FieldNames in clob:=null,p_FieldValues in clob:=null,p_ParticipantVersion in varchar2:=null,p_ParticipantUsage in varchar2:=null,p_ParticipantCode in varchar2:=null,p_TableName in varchar2:=null,p_FileToAssociate in varchar2:=null,p_AddressUsage in varchar2:=null,p_AddressCode in varchar2:=null,p_AddressValue in varchar2:=null,p_ObjectiveParent in varchar2:=null,p_Pay_Cat in varchar2:=null,p_Duty_Cat in varchar2:=null,p_Mission in varchar2:=null,p_Work_Date in date:=null,p_Hours in varchar2:=null,p_Complete in varchar2:=null,p_Substantive in varchar2:='N') return varchar2 is

         v_sid                  t_core_obj.SID%type;
         v_obj_type_code        t_core_obj_type.CODE%type;
         v_insert_string        varchar2(32000);
         v_source               t_core_obj.SID%type;
         v_ParticipantVersion   t_core_obj.SID%type;
         v_InvolvementRole      t_core_obj.SID%type;
         v_complete_status_sid  t_core_obj.SID%type;
         stime                  number;
         v_UnitSID              t_core_obj.SID%type:=osi_personnel.get_current_unit(core_context.personnel_sid);
         
    begin
         log_error('<<< create_instance(' || p_obj_type_sid || ',' || p_act_date || ',' || p_title || ',' || p_restriction || ',' || p_narrative || ',' || p_FieldNames || ',' || p_FieldValues || ',' || p_ParticipantVersion || ',' || p_ParticipantUsage || ',' || p_ParticipantCode || ',' || p_TableName || ',' || p_FileToAssociate || ',' || p_AddressUsage || ',' || p_AddressCode || ',' || p_AddressValue || ',' || p_ObjectiveParent || ',' || p_Pay_Cat || ',' || p_Duty_Cat  || ',' || p_Mission || ',' || p_Work_Date || ',' || p_Hours || ',' || p_Complete || ')');

         -------------------------------------------------
         --- Get Object Type Code from Object Type SID ---
         -------------------------------------------------
         select code into v_obj_type_code from t_core_obj_type where sid=p_obj_type_sid;
         
         ---------------------------------
         --- Insert Core Object Record ---
         ---------------------------------
         insert into t_core_obj (obj_type) values (p_obj_type_sid) returning SID into v_sid;

         --------------------------------------------------------------
         --- If Source Meet, Participant is Source, not Participant ---
         --------------------------------------------------------------
         if v_obj_type_code='ACT.SOURCE_MEET' then
           
           v_source := p_ParticipantVersion;
           v_ParticipantVersion := NULL;
         
         else
           
           v_ParticipantVersion := p_ParticipantVersion;
           
         end if;
         
         ------------------------------
         --- Insert Activity Record ---
         ------------------------------
         if (v_obj_type_code like 'ACT.CONSULTATION%') then

           insert into t_osi_activity (sid,id,title,creating_unit,assigned_unit,activity_date,narrative,restriction,source,substantive,leadership_approved)
               values (v_sid,osi_object.get_next_id,p_title,osi_personnel.get_current_unit(core_context.personnel_sid),v_UnitSID,p_act_date,p_narrative,p_restriction,v_source,p_Substantive,'Y');

         else

           insert into t_osi_activity (sid,id,title,creating_unit,assigned_unit,activity_date,narrative,restriction,source,substantive)
               values (v_sid,osi_object.get_next_id,p_title,osi_personnel.get_current_unit(core_context.personnel_sid),v_UnitSID,p_act_date,p_narrative,p_restriction,v_source,p_Substantive);

         end if;
         
         ---------------------------------------------------------
         --- Insert into Activity Specific Table, if passed in ---
         ---------------------------------------------------------
         if p_TableName is not null then 
  
           v_insert_string := 'insert into ' || p_TableName || ' (';
           if p_FieldNames is null or p_FieldValues is null then

             v_insert_string := v_insert_string || 'sid) values (''' || v_sid || ''')';

           else

             v_insert_string := v_insert_string || p_FieldNames || ') values (' || replace(replace(p_FieldValues,'~^~P0_OBJ~^~',v_sid),'~^~UNIT~^~',v_UnitSID) || ')';

           end if;
           
           v_insert_string:=replace(replace(v_insert_string,'''' || 'null' || '''','Null'),'''' || '%null%' || '''','Null');
           log_error(v_insert_string);
           execute immediate v_insert_string;
           
         end if;

         --------------------------
         --- Handle Participant ---
         --------------------------
         if v_ParticipantVersion is not null then
          
           begin
                select sid into v_InvolvementRole from t_osi_partic_role_type where obj_type=p_obj_type_sid and code=p_ParticipantCode and usage=p_ParticipantUsage;
               
           exception when others then

                    null;

           end;
          
           if v_InvolvementRole is null then
  
             begin 
                  select sid into v_InvolvementRole from t_osi_partic_role_type where obj_type member of osi_object.get_objtypes(p_obj_type_sid) and code=p_ParticipantCode and usage=p_ParticipantUsage;
               
             exception when others then

                      null;

             end;
 
           end if;
          
           insert into t_osi_partic_involvement i (obj, participant_version, involvement_role) values (v_sid,v_ParticipantVersion,v_InvolvementRole);

         end if;

         -------------------------------
         --- Handle File Association ---
         -------------------------------
         if p_FileToAssociate is not null then
 
           insert into T_OSI_ASSOC_FLE_ACT (ACTIVITY_SID, FILE_SID) values (v_sid, p_FileToAssociate);
                                                
         end if;

         ------------------------------------------------------------------------------
         --- Handle Associate activity to objective (Agent Applicant Activity ONLY) ---
         ------------------------------------------------------------------------------
         if p_ObjectiveParent is not null then

           insert into t_osi_f_aapp_file_obj_act (objective, obj) values (p_ObjectiveParent, v_sid);

         end if;
        
         ----------------------------
         --- Handle Address Field ---
         ----------------------------
         if p_AddressUsage is not null and p_AddressCode is not null and p_AddressValue is not null then

           osi_address.insert_address(v_sid,osi_address.get_addr_type(p_obj_type_sid,p_AddressUsage,p_AddressCode),p_AddressValue);
          
         end if;
        
         ----------------------------------
         --- Create the Lead Assignment ---
         ----------------------------------
         osi_object.create_lead_assignment(v_sid);

         -------------------------------
         --- Set the starting status ---
         -------------------------------
         osi_status.change_status_brute(v_sid, osi_status.get_starting_status(p_obj_type_sid), 'Created');
         core_obj.bump(v_sid);

         -----------------------------------------------------------
         --- Handle Workhours if all required fields are present ---
         -----------------------------------------------------------
         if p_pay_cat is not null and p_duty_cat is not null and p_work_date is not null and p_hours is not null then

           insert into t_osi_work_hours (PERSONNEL,OBJ,WORK_DATE,PAY_CAT,DUTY_CAT,MISSION,HOURS) VALUES
             (core_context.personnel_sid,v_sid,p_work_date,p_pay_cat,p_duty_cat,p_mission,p_hours);
             
         end if;
         
         -------------------------------------------
         --- Handle Marking Activity as Complete ---
         -------------------------------------------
         if (p_complete='Y') then
           
           begin
                ---------------------------------------------------
                --- Try to get the Status for Complete Activity ---
                ---------------------------------------------------
                select sid into v_complete_status_sid
                         from v_osi_status_change osc
                        where (from_status = osi_status.get_starting_status(p_obj_type_sid) and button_label='Complete Activity')
                          and (obj_type member of osi_object.get_objtypes(p_obj_type_sid) or obj_type = core_obj.lookup_objtype('ALL'))and button_label is not null
                          and osc.active = 'Y'
                          and osc.code not in(                
                          select code
                               from v_osi_status_change osc2 
                              where ((obj_type = p_obj_type_sid and override = 'Y')
                                     or
                                    (obj_type member of osi_object.get_objtypes(p_obj_type_sid)
                                and override = 'Y'))  and osc.sid <> osc2.sid);         
 
                if (osi_checklist.checklist_complete(v_sid,v_complete_status_sid))='Y' then
  
                  --- Sleep 1 Second so the Create/Complete are at least one second apart ---
                  stime := iol.sleep(1);
                                           
                  osi_status.change_status(v_sid,v_complete_status_sid);
             
                end if;
           
           exception when others then

                    log_error('create_instance - Could not get Complete Status - ' || SQLERRM);
                    
           end;
             
         end if;

        log_error('>>> create_instance(' || p_obj_type_sid || ',' || p_act_date || ',' || p_title || ',' || p_restriction || ',' || p_narrative || ',' || p_FieldNames || ',' || p_FieldValues || ',' || p_ParticipantVersion || ',' || p_ParticipantUsage || ',' || p_ParticipantCode || ',' || p_TableName || ',' || p_FileToAssociate || ',' || p_AddressUsage || ',' || p_AddressCode || ',' || p_AddressValue || ',' || p_ObjectiveParent || ',' || p_Pay_Cat || ',' || p_Duty_Cat  || ',' || p_Mission || ',' || p_Work_Date || ',' || p_Hours || ',' || p_Complete || ')');
        return v_sid;

    exception
        when others then

            log_error('create_instance: ' || sqlerrm);
            raise;

    end create_instance;

    /* Build an array of the missions associated to the activity, and
       convert that array to an apex-friendly colon-delimited list */
    function get_inv_support(p_obj in varchar2)
        return varchar2 is
        v_array    apex_application_global.vc_arr2;
        v_idx      integer                         := 1;
        v_string   varchar2(4000);
    begin
        for i in (select mission
                    from t_osi_mission
                   where obj = p_obj)
        loop
            v_array(v_idx) := i.mission;
            v_idx := v_idx + 1;
        end loop;

        v_string := apex_util.table_to_string(v_array, ':');
        return v_string;
    exception
        when others then
            log_error('get_inv_support: ' || sqlerrm);
            raise;
    end get_inv_support;

    /* Translates p_inv_support (colon-delimited list of mission sids) into an array, then
       loops through and adds those that don't exist already.  Deletes those that no longer
       appear in the list */
    procedure set_inv_support(p_obj in varchar2, p_inv_support in varchar2) is
        v_array    apex_application_global.vc_arr2;
        v_string   varchar2(4000);
    begin
        v_array := apex_util.string_to_table(p_inv_support, ':');

        for i in 1 .. v_array.count
        loop
            insert into t_osi_mission
                        (obj, mission)
                select p_obj, v_array(i)
                  from dual
                 where not exists(select 1
                                    from t_osi_mission
                                   where obj = p_obj and mission = v_array(i));
        end loop;

        delete from t_osi_mission
              where obj = p_obj and instr(nvl(p_inv_support, 'null'), mission) = 0;
    exception
        when others then
            log_error('set_inv_support: ' || sqlerrm);
            raise;
    end set_inv_support;

    /*Returns the activity date for the current activity*/
    function get_activity_date(p_obj in varchar2)
        return date is
        v_return   date;
    begin
        select activity_date
          into v_return
          from t_osi_activity
         where SID = p_obj;

        return v_return;
    exception
        when others then
            log_error('get_activity_date: ' || sqlerrm);
            raise;
    end get_activity_date;

    /*Returns a custom error message if the object is not deletable, otherwise will return a 'Y' */
    function can_delete(p_obj in varchar2) return varchar2 is

         v_status      varchar2(200) := null;
         v_count_check number := 0;
         
    begin
         if osi_auth.check_for_priv('DELETE',Core_Obj.get_objtype(p_obj))='N' then
         
           return 'You are not authorized to perform the requested action.';
           
         end if;
         
         v_status := upper(osi_object.get_status(p_obj));

         ---Is activity completed?---
         if v_status = 'COMPLETED' then
 
           return 'Cannot delete completed activities.';
  
         end if;

         ---Is activity closed?---
         if v_status = 'CLOSED' then
 
           return 'Cannot delete closed activities.';
  
         end if;

         ---Is Activity an Active Lead?---
         for a in (select SID from t_osi_activity
                         where SID=p_obj 
                           and nvl(creating_unit, 'NONE') <> nvl(assigned_unit, 'NONE'))
         loop

             return 'Cannot delete active leads.';

         end loop;

         ---Does the Activity Have WorkHours Associated with it?---
         select count(*) into v_count_check from t_osi_work_hours where obj=p_obj;
         if v_count_check > 0 then

           return 'Cannot delete activities with associated work hours.';

         end if;

         ---Does the Activity Have File(s) Associated with it?---
         select count(*) into v_count_check from t_osi_assoc_fle_act where activity_sid = p_obj;
         if v_count_check > 0 then

             return 'Cannot delete activities with associated files.';

         end if;

         ---Does the Activity Have CFund Expenses Associated with it?---
         select count(*) into v_count_check from t_cfunds_expense_v3 where parent = p_obj;
         if v_count_check > 0 then

             return 'Cannot delete activities with C Fund Expenses.';

         end if;

         ---Does the Activity Have Evidence Associated with it?---
         select count(*) into v_count_check from t_osi_evidence where obj = p_obj;
         if v_count_check > 0 then

             return 'Cannot delete activities with Evidence.';

         end if;

         ---Suspicious Activity Report specific check - must also have 'SAR.EDIT' priv --- 
         ---Only watch members may delete talons because of the talon 'states'         ---
         if core_obj.get_objtype(p_obj) = core_obj.lookup_objtype('ACT.SUSPACT_REPORT') then
        
           if osi_auth.check_for_priv('SAR.EDIT', core_obj.get_objtype(p_obj)) <> 'Y' then
        
             return 'You are not authorized to perform the requested action.';
        
           end if;
        
         end if;

         return 'Y';

    exception
        when others then
            log_error('OSI_ACTIVITY.Can_Delete: Error encountered using Object ' || nvl(p_obj, 'NULL') || ':' || sqlerrm);
            return 'Untrapped error in OSI_ACTIVITY.Can_Delete using Object: ' || nvl(p_obj, 'NULL');

    end can_delete;

    function get_f40_place(p_obj in varchar2) return varchar2 is

            v_return           varchar2(1000) := null;
            v_create_by_unit   varchar2(20);
            v_name             varchar2(100);
            v_obj_type_code    varchar2(200);

    begin
         select creating_unit into v_create_by_unit from t_osi_activity where SID = p_obj;

         --- Get object type code ---
         v_obj_type_code := osi_object.get_objtype_code(core_obj.get_objtype(p_obj));

         if v_obj_type_code like 'ACT.INTERVIEW%' then                           -- interviews --

           v_return := osi_address.get_addr_display(osi_address.get_address_sid(p_obj));

         elsif v_obj_type_code like 'ACT.BRIEFING%' then                         -- briefings --

              select location into v_return from t_osi_a_briefing where SID = p_obj;
              
         elsif v_obj_type_code like 'ACT.SOURCE%' then                           -- source meets --

              v_return := osi_address.get_addr_display(osi_address.get_address_sid(p_obj));

         elsif v_obj_type_code like 'ACT.SEARCH%' then                           -- searches --

              v_return := osi_address.get_addr_display(osi_address.get_address_sid(p_obj));

         elsif v_obj_type_code like 'ACT.POLY%' then                             -- polygraphs --

              v_return := osi_address.get_addr_display(osi_address.get_address_sid(p_obj));

              ---select location into v_return from t_act_poly_exam where sid = psid;
              
         elsif v_obj_type_code like 'ACT.SURV%' then                             -- polygraphs --
 
              v_return := osi_address.get_addr_display(osi_address.get_address_sid(p_obj));
              
         else
         
           --- This is the displayed text for all other types ---
           v_name := osi_unit.get_name(osi_object.get_assigned_unit(p_obj));
           v_return := v_name || ', ' || osi_address.get_addr_display (osi_address.get_address_sid(osi_object.get_assigned_unit(p_obj)));

         end if;

         v_return := replace(v_return, chr(13) || chr(10), ' ');                        -- CRLF's
         v_return := replace(v_return, chr(10), ' ');                                     -- LF's
         v_return := rtrim(v_return, ', ');
         return v_return;
    exception
    
         when no_data_found then
             raise;
             return null;
    
    end get_f40_place;

    function get_attachment_list(p_obj in varchar2, p_delimeter1 in varchar2 := ' - ', p_delimeter2 in varchar2 := '\line ', p_header in varchar2 := 'Attachments\line ') return varchar2 is
    
            v_tmp_attachments   varchar2(30000) := null;
            v_cnt               number          := 0;
    
    begin
         for a in (select description from t_osi_attachment where obj = p_obj order by description)
         loop
             v_cnt := v_cnt + 1;

             if a.description is not null then

               if v_cnt = 1 then

                 v_tmp_attachments := v_tmp_attachments || p_header;

               end if;

               v_tmp_attachments := v_tmp_attachments || p_delimeter1 || a.description || p_delimeter2;
            
             else
             
               return null;
             
             end if;

         end loop;

         return v_tmp_attachments;

    end get_attachment_list;

    /* Used to generate Form 40 Reports */
    function generate_form_40(p_obj in varchar2) return clob is

        v_ok1               varchar2(1000);
        v_ok2               varchar2(1000);
        v_return            clob                                    := null;
        v_return_date       date;
        v_mime_type         t_core_template.mime_type%type;
        v_mime_disp         t_core_template.mime_disposition%type;
        v_narrative_text    clob                                    := null;
        v_narrative         clob                                    := null;
        v_attachment_list   varchar2(3000)                          := null;
        v_classification    varchar2(1000)                          := null;
        v_activity_lead     varchar2(20);
        v_place             varchar2(32000);
        v_newline           varchar2(10)                            := chr(13) || chr(10);
        v_particVersionSid  varchar2(20);
        v_Result            varchar2(32000);
        v_SAA               varchar2(32000);
        v_Per               varchar2(32000);
        v_SubjectName       varchar2(32000);
        v_LatestOrg         varchar2(20);
        v_RelationshipSID   varchar2(20);
        v_Position          varchar2(32000);
        v_Phone             varchar2(32000);
        v_last_unit_name    varchar2(32000);
        v_unit_address      varchar2(32000);
        v_per_unit_cnt      number;
        v_title             varchar2(32000);
        v_obj_type_code     varchar2(1000);
                
    begin
         --- Get latest template ---
         v_ok1 := core_template.get_latest('FORM_40', v_return, v_return_date, v_mime_type, v_mime_disp);

         for k in (select a.SID, a.id as act_no, a.title, a.activity_date, a.narrative, a.object_type_code, a.leadership_approved 
                     from v_osi_activity_summary a 
                         where a.SID = p_obj)
         loop
             if k.leadership_approved is null or k.leadership_approved = 'N' then
               
               return 'Form 40 Cannot be genereated until Activity is Approved by Leadership.....';
               
             end if;
             
             v_obj_type_code := k.object_type_code;

             --- Get place of activity ---
             v_place := get_f40_place(k.SID);

             --- Get classification Markings --
             select osi_classification.get_report_class(p_obj) into v_classification from dual;

             v_ok2 := core_template.replace_tag(v_return, 'LEADAGENT_NAME', osi_object.get_lead_agent_name(p_obj));
             v_ok2 := core_template.replace_tag(v_return, 'RPT_DATE', to_char(k.activity_date, 'dd-Mon-yyyy'));
             v_ok2 := core_template.replace_tag(v_return, 'ACTIVITY_NO', k.act_no);
             v_ok2 := core_template.replace_tag(v_return, 'PLACE_OF_ACTIVITY', v_place);
             if v_classification is not null then

               v_ok2 := core_template.replace_tag(v_return, 'BOILERPLATE', v_classification, 'TOKEN@', true);

             end if;
             
---             if k.object_type_code in ('ACT.INTERVIEW.SUBJECT','ACT.INTERVIEW.VICTIM','ACT.INTERVIEW.WITNESS','ACT.DOCUMENT_REVIEW','ACT.RECORDS_CHECK') then

               begin
                    select participant_version into v_particVersionSid 
                      from t_osi_partic_involvement i, t_osi_partic_role_type rt  
                          where i.OBJ=p_obj
                            and i.INVOLVEMENT_ROLE=rt.sid
                            and upper(rt.role)='SUBJECT OF ACTIVITY';

               exception when others then

                        v_particVersionSid := null;
                        
               end;
               
               if k.object_type_code in ('ACT.INTERVIEW.SUBJECT','ACT.INTERVIEW.VICTIM','ACT.INTERVIEW.WITNESS') then

                 v_title := 'Interview of:  ';
                 
               elsif k.object_type_code in ('ACT.DOCUMENT_REVIEW') then

                    v_title := 'Document Review of:  ';

               elsif k.object_type_code in ('ACT.RECORDS_CHECK') then

                    v_title := 'Law Enforcement Checks of:  ';

               end if;
               
               --- Show Subject Information for Activities that have a Participant or Title ---
               if k.object_type_code in ('ACT.INTERVIEW.SUBJECT','ACT.INTERVIEW.VICTIM','ACT.INTERVIEW.WITNESS',
                                         'ACT.FINGERPRINT.CRIMINAL','ACT.FINGERPRINT.MANUAL',
                                         'ACT.INIT_NOTIF','ACT.POLY_EXAM','ACT.SEARCH.PERSON',
                                         'ACT.DOCUMENT_REVIEW','ACT.RECORDS_CHECK') then

                 --- Get Subject Name ---
                 osi_investigation.get_basic_info(v_particVersionSid, v_SubjectName, v_SAA, v_Per, True, True, False, False, 'N');
               
                 --- Get Other Basic Information ---
                 osi_investigation.get_basic_info(v_particVersionSid, v_Result, v_SAA, v_Per, False, False, False, False, 'N');
                 v_narrative := v_narrative || v_title || rtrim(v_SubjectName,' ;') || ' (SUBJECT); ' || v_Result;

                 ---  Get Military Organization ---
                 v_Result := osi_investigation.get_org_info(v_particVersionSid, True);
                 v_narrative := v_narrative || v_Result || '; ';
               
                 --- Get Current Work Position ---
                 begin
                      v_LatestOrg := osi_participant.Latest_Org(v_particVersionSid);
                      select w.sid into v_RelationshipSID from v_osi_partic_relation_2way w 
                         where w.this_partic=v_Per 
                           and w.THAT_PARTIC=v_LatestOrg;
               
                      v_Position := osi_participant.get_relation_specifics(v_RelationshipSID);
                    
                 exception when others then
                        
                          v_Position := 'UNK';
                        
                 end;
               
                 v_narrative := v_narrative || v_Position || '; ';
                 
                 --- Get Participant Phone Number ---
                 v_Phone := osi_investigation.getparticipantphone(v_Per);
                 v_narrative := v_narrative || 'Phone: ' || v_Phone || '.\line ';
               
               else
                 
                 v_narrative := v_narrative || k.title || '\line ';
                   
               end if;
               
               if k.object_type_code in ('ACT.INTERVIEW.SUBJECT','ACT.INTERVIEW.VICTIM','ACT.INTERVIEW.WITNESS') then

                 --- Get Interviewers ---
                 v_narrative := v_narrative || 'Interviewers: ';
               
                 --- Segment by Units so we only display the Unit address ONCE ---
                 for u in (select distinct un.unit as unit_sid, un.unit_name as unit_name 
                             from t_osi_assignment a, t_osi_assignment_role_type at, t_osi_personnel op, t_core_personnel cp, t_osi_personnel_unit_assign ua, t_osi_unit_name un
                              where a.assign_role=at.sid
                                and a.obj=p_obj
                                and a.personnel=op.sid
                                and op.sid=cp.sid
                                and ua.personnel=op.sid
                                and ua.end_date is null
                                and un.unit=ua.unit
                                and un.end_date is null order by un.unit_name)
                 loop
                     begin
                          select u.unit_name || ', ' || ad.city || decode(s.code,null, '', ', ' || s.code) into v_unit_address from t_osi_address ad,t_dibrs_state s where obj=u.unit_sid and ad.state=s.sid(+);
                          
                     exception when others then

                              v_unit_address := '';
                              
                     end;
                   
                     for a in (select last_name,first_Name,badge_num,un.unit_name,decode(badge_num,null,'','SA ') as name_prefix, decode(at.code,'LEAD',' (LEAD)','') as name_suffix, rownum, count(un.unit_name) over (partition by un.unit_name) as rowcount 
                                 from t_osi_assignment a, t_osi_assignment_role_type at, t_osi_personnel op, t_core_personnel cp, t_osi_unit_name un, t_osi_personnel_unit_assign ua
                                  where a.assign_role=at.sid
                                    and a.obj=p_obj
                                    and a.personnel=op.sid
                                    and op.sid=cp.sid
                                    and un.unit=u.unit_sid
                                    and ua.personnel=op.sid
                                    and ua.end_date is null
                                    and un.unit=ua.unit
                                    and un.end_date is null order by un.unit_name, last_name, first_name)
                     loop
                         if (a.rownum = (a.rowcount-1)) then

                           v_narrative := v_narrative || a.name_prefix || a.first_name || ' ' || a.last_name || a.name_suffix || ', and ';

                         else

                           v_narrative := v_narrative || a.name_prefix || a.first_name || ' ' || a.last_name || a.name_suffix || ', ';
                       
                         end if;
                     
                     end loop;

                     v_narrative := v_narrative || v_unit_address || '; ';
                   
                 end loop;
                 v_narrative := v_narrative || '\line ';
                 
               end if;
                              
               --- Get Associated Case File ---
               for c in (select nvl(f.full_id,f.id) as id,offt.description
                from t_osi_assoc_fle_act fa, t_osi_file f, t_core_obj_type ot, t_core_obj o, t_osi_f_inv_offense off, t_dibrs_offense_type offt, t_osi_reference ref
                           where fa.file_sid=f.sid 
                             and fa.activity_sid=p_obj
                             and o.sid=fa.file_sid
                             and ot.sid=o.obj_type
                             and off.investigation=fa.file_sid
                             and off.offense=offt.sid(+)
                             and off.priority=ref.sid(+)
                             and ref.code='P')
               loop
                   v_narrative := v_narrative || 'Case: ' || c.description || ', ' || c.id || '\line ';
                   
               end loop;

               ---   Appends Attachments List ---
               v_attachment_list := get_attachment_list(p_obj, '', '; ', 'Attachments: ');
  
               if v_attachment_list is not null then

                 v_narrative := v_narrative || rtrim(v_attachment_list, '; ') || '\line ';

               end if;
               v_narrative := v_narrative || '\line ';
               
---             else
---
---               --- Assemble the Narrative Header ---
---               v_narrative := v_narrative || k.title || '\par\par Date/Place: ' || k.activity_date || '/' || v_place || '\line\line ';
---
---               ---   Appends Attachments List ---
---               v_attachment_list := get_attachment_list(p_obj, '', '; ', 'Attachments: ');
---  
---               if v_attachment_list is not null then
---
---                 v_narrative := v_narrative || rtrim(v_attachment_list, '; ') || '\line ';
---
---               end if;
---
---             end if;
             
         end loop;

         if v_obj_type_code in ('ACT.RECORDS_CHECK','ACT.DOCUMENT_REVIEW') then
           
           
           if v_obj_type_code='ACT.RECORDS_CHECK' then

             v_narrative_text := replace(osi_records_check.get_narrative(p_obj),chr(13) || chr(10),'\line ');

           end if;
           
           if v_obj_type_code='ACT.DOCUMENT_REVIEW' then

             v_narrative_text := replace(osi_document_review.get_narrative(p_obj),chr(13) || chr(10),'\line ');

           end if;

         else

           for k in (select narrative from t_osi_activity where SID = p_obj)
           loop
               v_narrative_text := osi_report.clob_replace(k.narrative, v_newline, '\line ');
           end loop;
           
         end if;
         
         --- Append Narrative to variable ---
         dbms_lob.append(v_narrative, v_narrative_text);

         --- Appends the Narrative itself ---
         v_ok2 := core_template.replace_tag(v_return, 'NARRATIVE', v_narrative, 'TOKEN@', true);

         -- Get the boilerplate ---
         if v_classification is null then

           for f in (select setting from t_core_config where code = 'F40_CAVEAT')
           loop
               begin
                    select description into v_classification from t_core_classification_hi_type where code = f.setting;
               exception
                    when others then
                        begin
                             select description into v_classification from t_core_classification_level where code = f.setting;
                        exception
                            when others then
                                v_classification := null;
                        end;
               end;

           end loop;

         end if;

         if v_classification is null then

           for f in (select setting from t_core_config where code = 'DEFAULT_CLASS')
           loop
               begin
                    select description into v_classification from t_core_classification_hi_type where code = f.setting;
               exception
                    when others then
                        begin
                           select description into v_classification from t_core_classification_level where code = f.setting;
                        exception
                           when others then
                               v_classification := f.setting;
                        end;
               end;
 
           end loop;

         end if;

         if v_classification is null then

           v_classification := 'FOR OFFICIAL USE ONLY';

         end if;

         v_ok2 := core_template.replace_tag(v_return, 'BOILERPLATE', upper(v_classification), 'TOKEN@', true);

         return v_return;

    exception
        when others then
            log_error('osi_activity.generate_form_40: ' || sqlerrm);
            raise;
            return v_return;
    end generate_form_40;

    /* Used to generate Form 40 Reports */
    function generate_form_40_summary(p_obj in varchar2) return clob is

        v_ok1              varchar2(1000);
        v_ok2              varchar2(1000);
        v_return           clob                                    := null;
        v_return_date      date;
        v_mime_type        t_core_template.mime_type%type;
        v_mime_disp        t_core_template.mime_disposition%type;
        v_narrative_text   clob                                    := null;
        v_classification   varchar2(1000)                          := null;
        v_activity_lead    varchar2(20);
        v_place            varchar2(32000);
        v_newline          varchar2(10)                            := chr(13) || chr(10);
        v_cnt              number                                  := 0;

    begin
         --- Get latest template ---
         v_ok1 := core_template.get_latest('FORM_40_SUMMARY', v_return, v_return_date, v_mime_type, v_mime_disp);

         --- Get Activity Lead ---
         v_activity_lead := osi_object.get_lead_agent(p_obj);

         for k in (select a.SID, a.id as act_no, a.title, a.activity_date, a.narrative from v_osi_activity_summary a where a.SID = p_obj)
         loop
             --- Get place of activity ---
             v_place := get_f40_place(k.SID);

             --- Get classification Markings ---
             select osi_classification.get_report_class(p_obj) into v_classification from dual;

             v_ok2 := core_template.replace_tag(v_return, 'LEADAGENT_NAME', osi_object.get_lead_agent_name(p_obj));
             v_ok2 := core_template.replace_tag(v_return, 'RPT_DATE', to_char(k.activity_date, 'dd-Mon-yyyy'));
             v_ok2 := core_template.replace_tag(v_return, 'ACTIVITY_NO', k.act_no);
             v_ok2 := core_template.replace_tag(v_return, 'PLACE_OF_ACTIVITY', v_place);

             if v_classification is not null then

               v_ok2 := core_template.replace_tag(v_return, 'BOILERPLATE', v_classification, p_multiple => true);

             end if;

         end loop;

         for k in (select n.note_text 
                         from t_osi_note n, t_osi_note_type nt
                             where n.obj = p_obj 
                               and n.note_type = nt.SID
                               and nt.description = 'Form 40 Summary Note'
                             order by n.create_on)
         loop
             v_cnt := v_cnt + 1;

             if v_cnt > 1 then
             
               v_narrative_text := v_narrative_text || '\par\par ';
             
             end if;

             v_narrative_text := v_narrative_text || v_cnt || '.  ';
             v_narrative_text := v_narrative_text || osi_report.clob_replace(k.note_text, v_newline, '\line ');

         end loop;

         --- Appends the Narrative itself ---
         v_ok2 := core_template.replace_tag(v_return, 'NARRATIVE', v_narrative_text, 'TOKEN@', true);
 
         --- Get the boilerplate ---
         if v_classification is null then

           for f in (select setting from t_core_config where code = 'F40_CAVEAT')
           loop
               begin
                    select description into v_classification from t_core_classification_hi_type where code = f.setting;
               exception
                    when others then
                        begin
                             select description into v_classification from t_core_classification_level where code = f.setting;
                        exception
                            when others then
                                v_classification := null;
                        end;
               end;

           end loop;

         end if;

         if v_classification is null then

           for f in (select setting from t_core_config where code = 'DEFAULT_CLASS')
           loop
               begin
                    select description into v_classification from t_core_classification_hi_type where code = f.setting;
               exception
                    when others then
                        begin
                             select description into v_classification from t_core_classification_level where code = f.setting;
                        exception
                             when others then
                                 v_classification := f.setting;
                        end;
               end;

           end loop;

         end if;

         if v_classification is null then
  
           v_classification := 'FOR OFFICIAL USE ONLY';
   
         end if;

         v_ok2 := core_template.replace_tag(v_return, 'BOILERPLATE', upper(v_classification), p_multiple => true);
         return v_return;

    exception
        when others then
            log_error('osi_activity.generate_form_40_summary: ' || sqlerrm || dbms_utility.format_error_backtrace);
            raise;
            return v_return;
            
    end generate_form_40_summary;

    function check_writability(p_obj in varchar2)
        return varchar2 is
        v_rtn      varchar2(1000)            := null;
        v_ot_rec   t_core_obj_type%rowtype;
    begin
        -- begin object type specific writability check
        v_ot_rec.SID := core_obj.get_objtype(p_obj);

        select *
          into v_ot_rec
          from t_core_obj_type
         where SID = v_ot_rec.SID;

        begin
            execute immediate 'begin :RTN := ' || v_ot_rec.method_pkg
                              || '.CHECK_WRITABILITY(:OBJ); end;'
                        using out v_rtn, in p_obj;

            if v_rtn = 'N' then
                return v_rtn;
            end if;
        exception
            when others then
                null;                              -- do nothing, move on to generic activity check
        end;

        --end object type specific writability check
        if osi_object.get_status_code(p_obj) = 'CL' then
            return 'N';
        else
            return 'Y';
        end if;
    exception
        when others then
            log_error('osi_activity.check_writability: ' || sqlerrm);
            raise;
    end check_writability;

--======================================================================================================================
-- Following routines create activity object type specific documents for reporting purposes.
--======================================================================================================================
    procedure make_doc_act(p_sid in varchar2, p_doc in out nocopy clob) is
        v_temp_clob   clob;
        v_template    clob;
        v_ok          varchar2(1000);
        v_act_rec     t_osi_activity%rowtype;
    begin
        core_logger.log_it(c_pipe, '--> make_doc_act');

        -- main program
        if core_classification.has_hi(p_sid, null, 'ORCON') = 'Y' then
            core_logger.log_it
                           (c_pipe,
                            'ODW.Make_Doc_ACT: Activity is ORCON - no document will be synthesized');
            return;
        end if;

        if core_classification.has_hi(p_sid, null, 'LIMDIS') = 'Y' then
            core_logger.log_it
                          (c_pipe,
                           'ODW.Make_Doc_ACT: Activity is LIMDIS - no document will be synthesized');
            return;
        end if;

        select *
          into v_act_rec
          from t_osi_activity
         where SID = p_sid;

        osi_object.get_template('OSI_ODW_DETAIL_ACT', v_template);
        v_template := osi_object.addicon(v_template, p_sid);
        -- Fill in data
        v_ok := core_template.replace_tag(v_template, 'ID', v_act_rec.id);
        v_ok := core_template.replace_tag(v_template, 'TITLE', v_act_rec.title);
        v_ok :=
            core_template.replace_tag(v_template,
                                      'NARRATIVE',
                                      core_util.html_ize(v_act_rec.narrative));
        osi_object.append_involved_participants(v_temp_clob, v_act_rec.SID);
        v_ok := core_template.replace_tag(v_template, 'PARTICIPANTS', v_temp_clob);
        core_util.cleanup_temp_clob(v_temp_clob);
        osi_object.append_attachments(v_temp_clob, v_act_rec.SID);
        v_ok := core_template.replace_tag(v_template, 'ATTACHMENTS', v_temp_clob);
        core_util.cleanup_temp_clob(v_temp_clob);
        osi_object.append_notes(v_temp_clob, v_act_rec.SID);
        v_ok := core_template.replace_tag(v_template, 'NOTES', v_temp_clob);
        core_util.cleanup_temp_clob(v_temp_clob);
        p_doc := v_template;
        core_util.cleanup_temp_clob(v_template);
        core_logger.log_it(c_pipe, '<-- make_doc_act');
    exception
        when others then
            v_syn_error := sqlerrm;
            core_logger.log_it(c_pipe, 'ODW.Make_Doc_ACT Error: ' || v_syn_error);
    end make_doc_act;

    function get_oldest_file(p_obj in varchar2)
        return varchar2 is
    begin
        for f in (select   file_sid
                      from t_osi_assoc_fle_act
                     where activity_sid = p_obj
                  order by modify_on)
        loop
            return f.file_sid;                                               -- only need first one
        end loop;

        return null;                                                          -- no associated files
    end get_oldest_file;
end osi_activity;
/



update t_osi_a_rc_dr_results
  set default_narrative='A review of ~RECORD_TYPE~ records identifiable with SUBJECT DISCLOSED THERE WAS NO RECORD ON FILE.'
  where code='NOREC';
commit;



update t_osi_a_rc_dr_results
  set default_narrative='A review of ~RECORD_TYPE~ records identifiable with SUBJECT DISCLOSED NOTHING PERTINENT TO THIS INVESTIGATION.'
  where code='NODEROG';
commit;



update t_osi_a_rc_dr_results
  set default_narrative='A review of ~RECORD_TYPE~ records identifiable with SUBJECT was conducted.  The review disclosed SUBJECT [[[[PERTINENT INFORMATION HERE]]]].'
  where code='DEROGATORY';
commit;



------------------------------------
--- Remove Form 4 Summary Report ---
------------------------------------
UPDATE T_OSI_REPORT_TYPE SET ACTIVE='N' WHERE DESCRIPTION='Form 40 Summary';
commit;


-------------------------------------------------
--- Add Approved to the Activity Desktop View ---
-------------------------------------------------
ALTER TABLE T_OSI_ACTIVITY_LOOKUP ADD LEADERSHIP_APPROVED VARCHAR2(1) DEFAULT 'N';


--------------------------------------------------------------------------------------------------------
--- Make sure they are all defaulted to NO so T_OSI_ACTIVITY_LOOKUP job will update when they change ---
--------------------------------------------------------------------------------------------------------
alter trigger OSI_ACT_B_IUD_BUMP disable;

update t_osi_activity set leadership_approved='N' where leadership_approved is null;
commit;

alter trigger OSI_ACT_B_IUD_BUMP enable;


UPDATE T_OSI_ACTIVITY_LOOKUP SET LEADERSHIP_APPROVED='N';
COMMIT;


--------------------------------------------------------------
--- TRIGGER AND PACKAGE FOR T_OSI_ACTIVITY_LOOKUP UPDATING ---
--------------------------------------------------------------
CREATE OR REPLACE TRIGGER WEBI2MS.OSI_STATHIST_B_I_AL
BEFORE INSERT
ON T_OSI_STATUS_HISTORY 
REFERENCING NEW AS NEW OLD AS OLD
FOR EACH ROW
DECLARE

is_act NUMBER := 0;
up_on date := sysdate;

BEGIN

select count(a.sid) into is_act from t_osi_activity a where a.sid = :new.obj;

IF is_act > 0 THEN
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
         a.leadership_approved
    FROM T_OSI_ACTIVITY a, T_CORE_OBJ_TYPE ot, T_CORE_OBJ o
   WHERE a.SID = o.SID AND o.obj_type = ot.SID
        AND a.SID = :new.obj; 

delete from t_osi_activity_lookup tal where tal.sid= :new.obj and tal.updated_on <> up_on;

END IF;

END;
/


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
******************************************************************************/

   PROCEDURE UP_TITLE;
   PROCEDURE UP_CONUNIT;
   PROCEDURE UP_LEAD;
   PROCEDURE UP_NOLEAD;
   PROCEDURE UP_LEADAGT;
   PROCEDURE UP_COMPDATE;
   PROCEDURE UP_APPROVED;
   PROCEDURE DEL_ACT;
   PROCEDURE ADD_ACT;
   
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
        a.leadership_approved
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

END OSI_ACT_LOOK_UPDATES;
/





/*********************************************put this in the implementation package.
---
--- DROP JOB 107 in PRODUCTION ---
----------------------------------



--257 
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
end;'
   ,next_date => to_date('06/09/2012 13:24:11','dd/mm/yyyy hh24:mi:ss')
   ,interval  => 'SYSDATE+2/1440 '
   ,no_parse  => FALSE
  );
END;
/


*/









------------------------------------
--- Add Approved to Desktop View ---
------------------------------------
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
                      'decode(a.Leadership_Approved,''Y'',''Yes'',''No'') as "Approved"';
       
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
                                                                ' group by a.sid,a.id,a.activity_type,a.title,a.url,a.lead_agent,a.status,a.controlling_unit,a.vlt,a.is_lead,a.date_completed,a.suspense_date,a.created_on,a.created_by,r1.keep_on_top' ||  
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
                        ' AND (u.unit_parent=un2.unit and un2.end_date is null)';
                        
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
--   Date and Time:   13:25 Friday September 7, 2012
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

PROMPT ...Remove page 1010
 
begin
 
wwv_flow_api.remove_page (p_flow_id=>wwv_flow.g_flow_id, p_page_id=>1010);
 
end;
/

 
--application/pages/page_01010
prompt  ...PAGE 1010: Desktop Activities
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
  p_id     => 1010,
  p_flow_id=> wwv_flow.g_flow_id,
  p_tab_set=> '',
  p_name   => 'Desktop Activities',
  p_step_title=> '&DESKTOP_TITLE.',
  p_step_sub_title => 'Desktop Activities',
  p_step_sub_title_type => 'TEXT_WITH_SUBSTITUTIONS',
  p_first_item=> 'NO_FIRST_ITEM',
  p_include_apex_css_js_yn=>'Y',
  p_autocomplete_on_off => 'ON',
  p_group_id => 92115409285163743+ wwv_flow_api.g_id_offset,
  p_help_text => '',
  p_html_page_header => ' ',
  p_step_template => 92011431286949262+ wwv_flow_api.g_id_offset,
  p_required_patch=> null + wwv_flow_api.g_id_offset,
  p_last_updated_by => 'TWARD',
  p_last_upd_yyyymmddhh24miss => '20120907131817',
  p_page_is_public_y_n=> 'N',
  p_protection_level=> 'N',
  p_page_comment  => '06-Jan-2012 - Tim Ward - CR#3738 - All/Active Filter missing.  '||chr(10)||
'                         CR#3728 - Save Filter and rows values.'||chr(10)||
'                         CR#3742 - Save Filter and rows values.'||chr(10)||
'                         CR#3641 - Default Sort Order for Recent.'||chr(10)||
'                         CR#3635 - Last Accessed inconsistencies.'||chr(10)||
'                         CR#3563 - Default Desktop Views.'||chr(10)||
'                         CR#3446 - Implement speed improvements.'||chr(10)||
'                         CR#3447 - Implement speed improvements.');
 
wwv_flow_api.set_html_page_header(p_flow_id=>wwv_flow.g_flow_id,p_flow_step_id=>1010,p_text=>ph);
end;
 
end;
/

declare
  s varchar2(32767) := null;
  l_clob clob;
  l_length number := 1;
begin
s:=s||'SELECT C001,C002,C003,C004,C005,C006,C007,to_date(C008),to_date(C009),C010,C011,C012,C013,C014,to_date(C015),to_date(C016),C017'||chr(10)||
'FROM APEX_COLLECTIONS '||chr(10)||
'WHERE COLLECTION_NAME=''P'' || :APP_PAGE_ID || ''_CURRENT_FILTER'';'||chr(10)||
'';

wwv_flow_api.create_page_plug (
  p_id=> 2079608043609376 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_page_id=> 1010,
  p_plug_name=> 'Desktop > Activities',
  p_region_name=>'',
  p_plug_template=> 92167138176750921+ wwv_flow_api.g_id_offset,
  p_plug_display_sequence=> 10,
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
  p_plug_display_when_condition => 'osi_auth.check_for_priv(''DESKTOP'',core_obj.lookup_objtype(''ACT''))=''Y''',
  p_pagination_display_position=>'BOTTOM_RIGHT',
  p_plug_customized=>'0',
  p_plug_caching=> 'NOT_CACHED',
  p_plug_comment=> '');
end;
/
declare
 a1 varchar2(32767) := null;
begin
a1:=a1||'SELECT C001,C002,C003,C004,C005,C006,C007,to_date(C008),to_date(C009),C010,C011,C012,C013,C014,to_date(C015),to_date(C016),C017'||chr(10)||
'FROM APEX_COLLECTIONS '||chr(10)||
'WHERE COLLECTION_NAME=''P'' || :APP_PAGE_ID || ''_CURRENT_FILTER'';'||chr(10)||
'';

wwv_flow_api.create_worksheet(
  p_id => 2079815927609381+wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_page_id => 1010,
  p_region_id => 2079608043609376+wwv_flow_api.g_id_offset,
  p_name => 'Desktop > C-Funds Expenses',
  p_folder_id => null, 
  p_alias => '',
  p_report_id_item => '',
  p_max_row_count => '10000',
  p_max_row_count_message => 'This query returns more then 10,000 rows, please filter your data to ensure complete results.',
  p_no_data_found_message => 'No Activities found.',
  p_max_rows_per_page    => '',
  p_search_button_label  => '',
  p_page_items_to_submit => '',
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
  p_download_filename         =>'&P1010_EXPORT_NAME.',
  p_detail_link              =>'#C001#',
  p_detail_link_text         =>'<img src="#IMAGE_PREFIX#ws/small_page.gif" alt="">',
  p_allow_exclude_null_values =>'N',
  p_allow_hide_extra_columns  =>'N',
  p_owner                     =>'THOMAS');
end;
/
begin
wwv_flow_api.create_worksheet_column(
  p_id => 2082918883609404+wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_page_id=> 1010,
  p_worksheet_id => 2079815927609381+wwv_flow_api.g_id_offset,
  p_db_column_name         =>'C001',
  p_display_order          =>1,
  p_group_id               =>null+wwv_flow_api.g_id_offset,
  p_column_identifier      =>'C',
  p_column_label           =>'Url',
  p_report_label           =>'Url',
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
  p_id => 2083021220609404+wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_page_id=> 1010,
  p_worksheet_id => 2079815927609381+wwv_flow_api.g_id_offset,
  p_db_column_name         =>'C002',
  p_display_order          =>2,
  p_group_id               =>null+wwv_flow_api.g_id_offset,
  p_column_identifier      =>'D',
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
  p_id => 2083107607609404+wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_page_id=> 1010,
  p_worksheet_id => 2079815927609381+wwv_flow_api.g_id_offset,
  p_db_column_name         =>'C003',
  p_display_order          =>3,
  p_group_id               =>null+wwv_flow_api.g_id_offset,
  p_column_identifier      =>'E',
  p_column_label           =>'Activity Type',
  p_report_label           =>'Activity Type',
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
  p_id => 2083220544609404+wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_page_id=> 1010,
  p_worksheet_id => 2079815927609381+wwv_flow_api.g_id_offset,
  p_db_column_name         =>'C004',
  p_display_order          =>4,
  p_group_id               =>null+wwv_flow_api.g_id_offset,
  p_column_identifier      =>'F',
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
  p_id => 2083300436609404+wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_page_id=> 1010,
  p_worksheet_id => 2079815927609381+wwv_flow_api.g_id_offset,
  p_db_column_name         =>'C005',
  p_display_order          =>5,
  p_group_id               =>null+wwv_flow_api.g_id_offset,
  p_column_identifier      =>'G',
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
  p_id => 2083418479609404+wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_page_id=> 1010,
  p_worksheet_id => 2079815927609381+wwv_flow_api.g_id_offset,
  p_db_column_name         =>'C006',
  p_display_order          =>6,
  p_group_id               =>null+wwv_flow_api.g_id_offset,
  p_column_identifier      =>'H',
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
  p_id => 2083500251609406+wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_page_id=> 1010,
  p_worksheet_id => 2079815927609381+wwv_flow_api.g_id_offset,
  p_db_column_name         =>'C007',
  p_display_order          =>7,
  p_group_id               =>null+wwv_flow_api.g_id_offset,
  p_column_identifier      =>'I',
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
  p_id => 4860719320336770+wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_page_id=> null,
  p_worksheet_id => 2079815927609381+wwv_flow_api.g_id_offset,
  p_db_column_name         =>'TO_DATE(C008)',
  p_display_order          =>8,
  p_group_id               =>null+wwv_flow_api.g_id_offset,
  p_column_identifier      =>'N',
  p_column_label           =>'Created On',
  p_report_label           =>'Created On',
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
  p_id => 4860827413336770+wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_page_id=> null,
  p_worksheet_id => 2079815927609381+wwv_flow_api.g_id_offset,
  p_db_column_name         =>'TO_DATE(C009)',
  p_display_order          =>9,
  p_group_id               =>null+wwv_flow_api.g_id_offset,
  p_column_identifier      =>'O',
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
  p_display_condition      =>'SELECT 1 FROM APEX_COLLECTIONS WHERE TO_DATE(C009) IS NOT NULL AND COLLECTION_NAME=''P1010_CURRENT_FILTER''',
  p_help_text              =>'');
end;
/
begin
wwv_flow_api.create_worksheet_column(
  p_id => 2083806261609406+wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_page_id=> 1010,
  p_worksheet_id => 2079815927609381+wwv_flow_api.g_id_offset,
  p_db_column_name         =>'C010',
  p_display_order          =>10,
  p_group_id               =>null+wwv_flow_api.g_id_offset,
  p_column_identifier      =>'L',
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
  p_display_condition      =>'SELECT 1 FROM APEX_COLLECTIONS WHERE C010 IS NOT NULL AND COLLECTION_NAME=''P1010_CURRENT_FILTER''',
  p_help_text              =>'');
end;
/
begin
wwv_flow_api.create_worksheet_column(
  p_id => 2083916281609406+wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_page_id=> 1010,
  p_worksheet_id => 2079815927609381+wwv_flow_api.g_id_offset,
  p_db_column_name         =>'C011',
  p_display_order          =>11,
  p_group_id               =>null+wwv_flow_api.g_id_offset,
  p_column_identifier      =>'M',
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
  p_display_condition      =>'SELECT 1 FROM APEX_COLLECTIONS WHERE C011 IS NOT NULL AND COLLECTION_NAME=''P1010_CURRENT_FILTER''',
  p_help_text              =>'');
end;
/
begin
wwv_flow_api.create_worksheet_column(
  p_id => 4861722531394450+wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_page_id=> null,
  p_worksheet_id => 2079815927609381+wwv_flow_api.g_id_offset,
  p_db_column_name         =>'C012',
  p_display_order          =>12,
  p_group_id               =>null+wwv_flow_api.g_id_offset,
  p_column_identifier      =>'P',
  p_column_label           =>'            ',
  p_report_label           =>'            ',
  p_sync_form_label        =>'Y',
  p_display_in_default_rpt =>'Y',
  p_column_link            =>'#C012#',
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
  p_id => 4861801281394451+wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_page_id=> null,
  p_worksheet_id => 2079815927609381+wwv_flow_api.g_id_offset,
  p_db_column_name         =>'C013',
  p_display_order          =>13,
  p_group_id               =>null+wwv_flow_api.g_id_offset,
  p_column_identifier      =>'Q',
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
  p_id => 4861914834394451+wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_page_id=> null,
  p_worksheet_id => 2079815927609381+wwv_flow_api.g_id_offset,
  p_db_column_name         =>'C014',
  p_display_order          =>14,
  p_group_id               =>null+wwv_flow_api.g_id_offset,
  p_column_identifier      =>'R',
  p_column_label           =>'Is A Lead',
  p_report_label           =>'Is A Lead',
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
  p_id => 4862022500394451+wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_page_id=> null,
  p_worksheet_id => 2079815927609381+wwv_flow_api.g_id_offset,
  p_db_column_name         =>'TO_DATE(C015)',
  p_display_order          =>15,
  p_group_id               =>null+wwv_flow_api.g_id_offset,
  p_column_identifier      =>'S',
  p_column_label           =>'Date Completed',
  p_report_label           =>'Date Completed',
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
  p_id => 4862101691394451+wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_page_id=> null,
  p_worksheet_id => 2079815927609381+wwv_flow_api.g_id_offset,
  p_db_column_name         =>'TO_DATE(C016)',
  p_display_order          =>16,
  p_group_id               =>null+wwv_flow_api.g_id_offset,
  p_column_identifier      =>'T',
  p_column_label           =>'Suspense Date',
  p_report_label           =>'Suspense Date',
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
  p_id => 16448214345311852+wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_page_id=> null,
  p_worksheet_id => 2079815927609381+wwv_flow_api.g_id_offset,
  p_db_column_name         =>'C017',
  p_display_order          =>17,
  p_group_id               =>null+wwv_flow_api.g_id_offset,
  p_column_identifier      =>'U',
  p_column_label           =>'Approved',
  p_report_label           =>'Approved',
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
wwv_flow_api.create_worksheet_rpt(
  p_id => 2085323540609409+wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_page_id=> 1010,
  p_worksheet_id => 2079815927609381+wwv_flow_api.g_id_offset,
  p_session_id  => null,
  p_base_report_id  => null+wwv_flow_api.g_id_offset,
  p_application_user => 'APXWS_DEFAULT',
  p_report_seq              =>10,
  p_status                  =>'PRIVATE',
  p_category_id             =>null+wwv_flow_api.g_id_offset,
  p_is_default              =>'Y',
  p_display_rows            =>25,
  p_report_columns          =>'C002:C003:C004:C005:C006:C007:TO_DATE(C008):TO_DATE(C009):C010:C011:C012',
  p_flashback_enabled       =>'N',
  p_calendar_display_column =>'');
end;
/
declare
  s varchar2(32767) := null;
  l_clob clob;
  l_length number := 1;
begin
s:=s||'You do not have access privileges for this folder.'||chr(10)||
'';

wwv_flow_api.create_page_plug (
  p_id=> 6183225704261979 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_page_id=> 1010,
  p_plug_name=> 'Access Restricted',
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
  p_plug_query_num_rows_type => 'NEXT_PREVIOUS_LINKS',
  p_plug_query_row_count_max => 500,
  p_plug_query_show_nulls_as => ' - ',
  p_plug_display_condition_type => 'PLSQL_EXPRESSION',
  p_plug_display_when_condition => 'osi_auth.check_for_priv(''DESKTOP'',core_obj.lookup_objtype(''ACT''))=''N''',
  p_pagination_display_position=>'BOTTOM_RIGHT',
  p_plug_customized=>'0',
  p_plug_caching=> 'NOT_CACHED',
  p_plug_comment=> '');
end;
/
 
begin
 
wwv_flow_api.create_page_button(
  p_id             => 15191624248639839 + wwv_flow_api.g_id_offset,
  p_flow_id        => wwv_flow.g_flow_id,
  p_flow_step_id   => 1010,
  p_button_sequence=> 10,
  p_button_plug_id => 2079608043609376+wwv_flow_api.g_id_offset,
  p_button_name    => 'EXPORT',
  p_button_image   => 'template:'||to_char(15353513871475325+wwv_flow_api.g_id_offset),
  p_button_image_alt=> '&BTN_EXPORT.',
  p_button_position=> 'RIGHT_OF_IR_SEARCH_BAR',
  p_button_alignment=> 'LEFT',
  p_button_redirect_url=> 'javascript:getIRCSV(null, this, 1010);',
  p_button_cattributes=>'onClick="getIRCSV(null, this, 1010);"',
  p_button_comment=>'javascript:void(0);',
  p_required_patch => null + wwv_flow_api.g_id_offset);
 
 
end;
/

 
begin
 
wwv_flow_api.create_page_branch(
  p_id=>6208415117295842 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 1010,
  p_branch_action=> 'f?p=&APP_ID.:1010:&SESSION.::&DEBUG.:::',
  p_branch_point=> 'AFTER_PROCESSING',
  p_branch_type=> 'REDIRECT_URL',
  p_branch_sequence=> 10,
  p_save_state_before_branch_yn=>'N',
  p_branch_comment=> 'Created 22-FEB-2010 10:35 by TIM');
 
 
end;
/

declare
    h varchar2(32767) := null;
begin
wwv_flow_api.create_page_item(
  p_id=>6207731262291012 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 1010,
  p_name=>'P1010_FILTER',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 10,
  p_item_plug_id => 2079608043609376+wwv_flow_api.g_id_offset,
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
  p_protection_level => 'N',
  p_item_comment => '');
 
 
end;
/

declare
    h varchar2(32767) := null;
begin
wwv_flow_api.create_page_item(
  p_id=>8788006742945022 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 1010,
  p_name=>'P1010_ACTIVE_FILTER',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 15,
  p_item_plug_id => 2079608043609376+wwv_flow_api.g_id_offset,
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
  p_label_alignment  => 'LEFT',
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
  p_id=>8819808179336167 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 1010,
  p_name=>'P1010_NUM_ROWS',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 30,
  p_item_plug_id => 2079608043609376+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'YES',
  p_item_default_type => 'STATIC_TEXT_WITH_SUBSTITUTIONS',
  p_prompt=>'Num Rows',
  p_source_type=> 'STATIC',
  p_display_as=> 'HIDDEN',
  p_lov_columns=> 1,
  p_lov_display_null=> 'NO',
  p_lov_translated=> 'N',
  p_cSize=> 30,
  p_cMaxlength=> 2000,
  p_cHeight=> 5,
  p_cAttributes=> 'nowrap="nowrap"',
  p_begin_on_new_line => 'YES',
  p_begin_on_new_field=> 'YES',
  p_colspan => 1,
  p_rowspan => 1,
  p_label_alignment  => 'RIGHT',
  p_field_alignment  => 'LEFT',
  p_field_template => 179220647225554497+wwv_flow_api.g_id_offset,
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
  p_id=>10349213755153079 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 1010,
  p_name=>'P1010_OBJECT_TYPE',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 40,
  p_item_plug_id => 2079608043609376+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'YES',
  p_item_default_type => 'STATIC_TEXT_WITH_SUBSTITUTIONS',
  p_source=>'ACT',
  p_source_type=> 'STATIC',
  p_display_as=> 'HIDDEN',
  p_lov_columns=> 1,
  p_lov_display_null=> 'NO',
  p_lov_translated=> 'N',
  p_cSize=> 30,
  p_cMaxlength=> 2000,
  p_cHeight=> 1,
  p_cAttributes=> 'nowrap="nowrap"',
  p_begin_on_new_line => 'NO',
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
  p_id=>15442907538685931 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 1010,
  p_name=>'P1010_EXPORT_NAME',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 20,
  p_item_plug_id => 2079608043609376+wwv_flow_api.g_id_offset,
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
  p_id=> 8826509189459484 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 1010,
  p_computation_sequence => 10,
  p_computation_item=> 'P1010_NUM_ROWS',
  p_computation_point=> 'BEFORE_BOX_BODY',
  p_computation_type=> 'PLSQL_EXPRESSION',
  p_computation_processed=> 'REPLACE_EXISTING',
  p_computation=> 'osi_personnel.get_user_setting(:user_sid,'||chr(10)||
'                               ''P'' || :APP_PAGE_ID || ''_NUM_ROWS.'' || ''ACT'','||chr(10)||
'                               ''25'');'||chr(10)||
'',
  p_compute_when => '',
  p_compute_when_type=>'');
 
null;
 
end;
/

 
begin
 
wwv_flow_api.create_page_computation(
  p_id=> 6207904728292859 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 1010,
  p_computation_sequence => 10,
  p_computation_item=> 'P1010_FILTER',
  p_computation_point=> 'BEFORE_HEADER',
  p_computation_type=> 'STATIC_ASSIGNMENT',
  p_computation_processed=> 'REPLACE_EXISTING',
  p_computation=> 'RECENT',
  p_compute_when => 'P1010_FILTER',
  p_compute_when_type=>'ITEM_IS_NULL');
 
null;
 
end;
/

 
begin
 
wwv_flow_api.create_page_computation(
  p_id=> 8793829242576054 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 1010,
  p_computation_sequence => 20,
  p_computation_item=> 'P1010_ACTIVE_FILTER',
  p_computation_point=> 'BEFORE_HEADER',
  p_computation_type=> 'STATIC_ASSIGNMENT',
  p_computation_processed=> 'REPLACE_EXISTING',
  p_computation=> 'ACTIVE',
  p_compute_when => 'P1010_ACTIVE_FILTER',
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
'   :P1010_FILTER := osi_personnel.get_user_setting(:user_sid,'||chr(10)||
'                                                   ''P'' || :APP_PAGE_ID || ''_FILTER.'' || ''ACT'','||chr(10)||
'                                                   ''RECENT'');'||chr(10)||
''||chr(10)||
'   :P1010_ACTIVE_FILTER := osi_personnel.get_user_setting(:user_sid,'||chr(10)||
'                                                          ''P'' || :APP_PAGE_ID || ''_ACTIVE_FILTER.'' || ''AC';

p:=p||'T'','||chr(10)||
'                                                          ''ACTIVE'');'||chr(10)||
''||chr(10)||
'End;';

wwv_flow_api.create_page_process(
  p_id     => 2079310683600681 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id => 1010,
  p_process_sequence=> 20,
  p_process_point=> 'BEFORE_HEADER',
  p_process_type=> 'PLSQL',
  p_process_name=> 'DESKTOP FILTERS DEFAULT',
  p_process_sql_clob => p, 
  p_process_error_message=> '',
  p_process_success_message=> '',
  p_process_is_stateful_y_n=>'N',
  p_process_comment=>'/* OLD'||chr(10)||
'   if apex_collection.collection_exists'||chr(10)||
'     (p_collection_name=>''P'' || :APP_PAGE_ID || ''_CURRENT_FILTER'') then'||chr(10)||
'    '||chr(10)||
'     apex_collection.delete_collection'||chr(10)||
'         (p_collection_name=>''P'' || :APP_PAGE_ID || ''_CURRENT_FILTER'');'||chr(10)||
'  '||chr(10)||
'   end if;'||chr(10)||
''||chr(10)||
'  APEX_COLLECTION.CREATE_COLLECTION_FROM_QUERY_B('||chr(10)||
'       p_collection_name=>''P'' || :APP_PAGE_ID || ''_CURRENT_FILTER'','||chr(10)||
'       p_query => OSI_DESKTOP.DesktopSQL(:P1010_FILTER, '||chr(10)||
'                                         :user_sid, '||chr(10)||
'                                         ''ACT'','||chr(10)||
'                                         '''', '||chr(10)||
'                                         :P1010_ACTIVE_FILTER,'||chr(10)||
'                                         :P1010_NUM_ROWS,'||chr(10)||
'                                         ''P'','||chr(10)||
'                                         '''','||chr(10)||
'                                         :APXWS_MAX_ROW_CNT));'||chr(10)||
'*/');
end;
null;
 
end;
/

 
begin
 
---------------------------------------
-- ...updatable report columns for page 1010
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








------------------------------------------------------------------
---- Bug found in DOCREV and LERC if result is null on updates ---
------------------------------------------------------------------
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
--   Date and Time:   07:46 Tuesday September 11, 2012
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

PROMPT ...Remove page 21505
 
begin
 
wwv_flow_api.remove_page (p_flow_id=>wwv_flow.g_flow_id, p_page_id=>21505);
 
end;
/

 
--application/pages/page_21505
prompt  ...PAGE 21505: Records Check and Document Review Details
--
 
begin
 
declare
    h varchar2(32767) := null;
    ph varchar2(32767) := null;
begin
h:=h||'No help is available for this page.';

ph:=ph||'"JS_BUILDRC_DRNARRATIVEANDTITLE"'||chr(10)||
'"JS_HIDESHOWFIELD"'||chr(10)||
'<script language="javascript">'||chr(10)||
'function showHideFields()'||chr(10)||
'{'||chr(10)||
' pObjTypeCode = $(''#P21505_OBJ_TYPE_CODE'').val();'||chr(10)||
' pDocTypeText = $(''#P21505_TYPE > option:selected'').text();'||chr(10)||
''||chr(10)||
' showField(''P21505_REFERENCE_NUM'', false, false);'||chr(10)||
' hideField(''P21505_EXPLANATION'', false, true);'||chr(10)||
''||chr(10)||
' if(pObjTypeCode==''ACT.DOCUMENT_REVIEW'')'||chr(10)||
'   {'||chr(10)||
'    if(pDocTypeText==''Other'')'||chr(10)||
'    ';

ph:=ph||'  {'||chr(10)||
'       showField(''P21505_EXPLANATION'', false, true);'||chr(10)||
'       hideField(''P21505_REFERENCE_NUM'', false, false);'||chr(10)||
'      }'||chr(10)||
'   }'||chr(10)||
'}'||chr(10)||
'</script>';

wwv_flow_api.create_page(
  p_id     => 21505,
  p_flow_id=> wwv_flow.g_flow_id,
  p_tab_set=> '',
  p_name   => 'Records Check and Document Review Details',
  p_step_title=> '&P0_OBJ_TAGLINE.',
  p_step_sub_title_type => 'TEXT_WITH_SUBSTITUTIONS',
  p_first_item=> 'AUTO_FIRST_ITEM',
  p_include_apex_css_js_yn=>'Y',
  p_footer_text => '<script language="javascript">'||chr(10)||
'$(document).ready(function () '||chr(10)||
'{'||chr(10)||
' showHideFields();'||chr(10)||
'});'||chr(10)||
''||chr(10)||
''||chr(10)||
'</script>',
  p_autocomplete_on_off => 'ON',
  p_group_id => 88816921197003939+ wwv_flow_api.g_id_offset,
  p_help_text => ' ',
  p_html_page_header => ' ',
  p_step_template => '',
  p_required_patch=> null + wwv_flow_api.g_id_offset,
  p_last_updated_by => 'TWARD',
  p_last_upd_yyyymmddhh24miss => '20120911074309',
  p_page_is_public_y_n=> 'N',
  p_protection_level=> 'N',
  p_page_comment  => '07-OCT-2010 J.FARIS WCHG0000360 - Enabled date picker.'||chr(10)||
''||chr(10)||
'24-Jul-2012 - Tim Ward - CR#4049 - Allow multiple Checks in one Activity.'||chr(10)||
''||chr(10)||
'02-Aug-2012 - Tim Ward - P0_OBJ Passing in the Page Branches.'||chr(10)||
''||chr(10)||
'11-Sep-2012 - Tim Ward - CR#4049 - Beta Testing found error when updating'||chr(10)||
'                          because pick lists return .');
 
wwv_flow_api.set_page_help_text(p_flow_id=>wwv_flow.g_flow_id,p_flow_step_id=>21505,p_text=>h);
wwv_flow_api.set_html_page_header(p_flow_id=>wwv_flow.g_flow_id,p_flow_step_id=>21505,p_text=>ph);
end;
 
end;
/

declare
  s varchar2(32767) := null;
  l_clob clob;
  l_length number := 1;
begin
s:=s||'SELECT SID,'||chr(10)||
'       HTMLDB_ITEM.CHECKBOX (1, sid) as "Select",'||chr(10)||
'       ACTIVITY_DATE as "Review Date",'||chr(10)||
'       REFERENCE_NUM as "Reference Number",'||chr(10)||
'       NARRATIVE,'||chr(10)||
'       OSI_REFERENCE.LOOKUP_REF_DESC(DOC_TYPE) as "Record Type",'||chr(10)||
'       decode(:p21505_selected,sid,''Y'',''N'') "Current"'||chr(10)||
'FROM T_OSI_A_RECORDS_CHECK'||chr(10)||
'WHERE OBJ=:P21505_OBJ';

wwv_flow_api.create_report_region (
  p_id=> 14971424570394387 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_page_id=> 21505,
  p_name=> 'Law Enforcement Records Checks Associated to this Activity',
  p_region_name=>'',
  p_template=> 92560720055766143+ wwv_flow_api.g_id_offset,
  p_display_sequence=> 40,
  p_display_column=> 1,
  p_display_point=> 'AFTER_SHOW_ITEMS',
  p_source=> s,
  p_source_type=> 'SQL_QUERY',
  p_display_error_message=> '#SQLERRM#',
  p_display_when_condition=> ':P21505_OBJ_TYPE_CODE=''ACT.RECORDS_CHECK''',
  p_display_condition_type=> 'PLSQL_EXPRESSION',
  p_plug_caching=> 'NOT_CACHED',
  p_customized=> '0',
  p_translate_title=> 'Y',
  p_ajax_enabled=> 'Y',
  p_query_row_template=> 5228919666917120+ wwv_flow_api.g_id_offset,
  p_query_headings_type=> 'COLON_DELMITED_LIST',
  p_query_options=> 'DERIVED_REPORT_COLUMNS',
  p_query_show_nulls_as=> ' - ',
  p_query_break_cols=> '0',
  p_query_no_data_found=> '<b><center>***** No &P21505_OBJ_TYPE_DESCRIPTION.s in the List Yet *****</center></b>',
  p_query_num_rows_type=> 'NEXT_PREVIOUS_LINKS',
  p_query_row_count_max=> '500',
  p_pagination_display_position=> 'BOTTOM_RIGHT',
  p_csv_output=> 'N',
  p_sort_null=> 'F',
  p_query_asc_image=> 'arrow_down_gray_dark.gif',
  p_query_asc_image_attr=> 'width="13" height="12" alt=""',
  p_query_desc_image=> 'arrow_up_gray_dark.gif',
  p_query_desc_image_attr=> 'width="13" height="12" alt=""',
  p_plug_query_strip_html=> 'Y',
  p_comment=>'');
end;
/
declare
  s varchar2(32767) := null;
begin
s := null;
wwv_flow_api.create_report_columns (
  p_id=> 14971617016394387 + wwv_flow_api.g_id_offset,
  p_region_id=> 14971424570394387 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_query_column_id=> 1,
  p_form_element_id=> null,
  p_column_alias=> 'SID',
  p_column_display_sequence=> 1,
  p_column_heading=> '&nbsp;',
  p_column_link=>'javascript:doSubmit(''EDIT_#SID#'');',
  p_column_linktext=>'&ICON_EDIT.',
  p_column_link_attr=>'name=''#SID#''',
  p_column_alignment=>'LEFT',
  p_heading_alignment=>'CENTER',
  p_default_sort_column_sequence=>0,
  p_disable_sort_column=>'Y',
  p_sum_column=> 'N',
  p_hidden_column=> 'N',
  p_display_as=>'WITHOUT_MODIFICATION',
  p_lov_show_nulls=> 'NO',
  p_pk_col_source=> s,
  p_include_in_export=> 'Y',
  p_column_comment=>'');
end;
/
declare
  s varchar2(32767) := null;
begin
s := null;
wwv_flow_api.create_report_columns (
  p_id=> 14972424256394387 + wwv_flow_api.g_id_offset,
  p_region_id=> 14971424570394387 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_query_column_id=> 2,
  p_form_element_id=> null,
  p_column_alias=> 'Select',
  p_column_display_sequence=> 2,
  p_column_heading=> '<input type="Checkbox" onclick="$f_CheckFirstColumn(this)">',
  p_column_alignment=>'LEFT',
  p_heading_alignment=>'CENTER',
  p_default_sort_column_sequence=>0,
  p_disable_sort_column=>'Y',
  p_sum_column=> 'N',
  p_hidden_column=> 'N',
  p_display_as=>'WITHOUT_MODIFICATION',
  p_pk_col_source=> s,
  p_column_comment=>'');
end;
/
declare
  s varchar2(32767) := null;
begin
s := null;
wwv_flow_api.create_report_columns (
  p_id=> 14973029895405378 + wwv_flow_api.g_id_offset,
  p_region_id=> 14971424570394387 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_query_column_id=> 3,
  p_form_element_id=> null,
  p_column_alias=> 'Review Date',
  p_column_display_sequence=> 3,
  p_column_heading=> 'Review Date',
  p_column_format=> '&FMT_DATE.',
  p_column_alignment=>'LEFT',
  p_heading_alignment=>'CENTER',
  p_default_sort_column_sequence=>0,
  p_disable_sort_column=>'Y',
  p_sum_column=> 'N',
  p_hidden_column=> 'N',
  p_display_as=>'WITHOUT_MODIFICATION',
  p_lov_show_nulls=> 'NO',
  p_pk_col_source=> s,
  p_lov_display_extra=> 'YES',
  p_include_in_export=> 'Y',
  p_column_comment=>'');
end;
/
declare
  s varchar2(32767) := null;
begin
s := null;
wwv_flow_api.create_report_columns (
  p_id=> 14973310287409203 + wwv_flow_api.g_id_offset,
  p_region_id=> 14971424570394387 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_query_column_id=> 4,
  p_form_element_id=> null,
  p_column_alias=> 'Reference Number',
  p_column_display_sequence=> 5,
  p_column_heading=> '&P21505_NUMBER_LABEL.',
  p_column_alignment=>'LEFT',
  p_heading_alignment=>'CENTER',
  p_default_sort_column_sequence=>0,
  p_disable_sort_column=>'Y',
  p_sum_column=> 'N',
  p_hidden_column=> 'N',
  p_display_as=>'WITHOUT_MODIFICATION',
  p_pk_col_source=> s,
  p_column_comment=>'');
end;
/
declare
  s varchar2(32767) := null;
begin
s := null;
wwv_flow_api.create_report_columns (
  p_id=> 14971910336394387 + wwv_flow_api.g_id_offset,
  p_region_id=> 14971424570394387 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_query_column_id=> 5,
  p_form_element_id=> null,
  p_column_alias=> 'NARRATIVE',
  p_column_display_sequence=> 6,
  p_column_heading=> 'Narrative',
  p_column_alignment=>'LEFT',
  p_heading_alignment=>'CENTER',
  p_default_sort_column_sequence=>0,
  p_disable_sort_column=>'Y',
  p_sum_column=> 'N',
  p_hidden_column=> 'N',
  p_display_as=>'WITHOUT_MODIFICATION',
  p_pk_col_source=> s,
  p_column_comment=>'');
end;
/
declare
  s varchar2(32767) := null;
begin
s := null;
wwv_flow_api.create_report_columns (
  p_id=> 14972317792394387 + wwv_flow_api.g_id_offset,
  p_region_id=> 14971424570394387 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_query_column_id=> 6,
  p_form_element_id=> null,
  p_column_alias=> 'Record Type',
  p_column_display_sequence=> 4,
  p_column_heading=> '&P21505_TYPE_LABEL.',
  p_column_alignment=>'LEFT',
  p_heading_alignment=>'CENTER',
  p_default_sort_column_sequence=>0,
  p_disable_sort_column=>'Y',
  p_sum_column=> 'N',
  p_hidden_column=> 'N',
  p_display_as=>'WITHOUT_MODIFICATION',
  p_pk_col_source=> s,
  p_column_comment=>'');
end;
/
declare
  s varchar2(32767) := null;
begin
s := null;
wwv_flow_api.create_report_columns (
  p_id=> 14972532547394387 + wwv_flow_api.g_id_offset,
  p_region_id=> 14971424570394387 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_query_column_id=> 7,
  p_form_element_id=> null,
  p_column_alias=> 'Current',
  p_column_display_sequence=> 7,
  p_column_heading=> 'Current',
  p_column_alignment=>'LEFT',
  p_heading_alignment=>'CENTER',
  p_default_sort_column_sequence=>0,
  p_disable_sort_column=>'Y',
  p_sum_column=> 'N',
  p_hidden_column=> 'Y',
  p_display_as=>'WITHOUT_MODIFICATION',
  p_pk_col_source=> s,
  p_column_comment=>'');
end;
/
declare
  s varchar2(32767) := null;
  l_clob clob;
  l_length number := 1;
begin
s:=s||'SELECT SID,'||chr(10)||
'       HTMLDB_ITEM.CHECKBOX (1, sid) as "Select",'||chr(10)||
'       ACTIVITY_DATE as "Review Date",'||chr(10)||
'       DOCUMENT_NUMBER as "Document Number",'||chr(10)||
'       EXPLANATION as "Explanation",'||chr(10)||
'       NARRATIVE,'||chr(10)||
'       OSI_REFERENCE.LOOKUP_REF_DESC(DOC_TYPE) as "Document Type",'||chr(10)||
'       decode(:p21505_selected,sid,''Y'',''N'') "Current"'||chr(10)||
'FROM T_OSI_A_DOCUMENT_REVIEW'||chr(10)||
'WHERE OBJ=:P21505_OBJ';

wwv_flow_api.create_report_region (
  p_id=> 15158319616591900 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_page_id=> 21505,
  p_name=> 'Document Reviews Associated to this Activity',
  p_region_name=>'',
  p_template=> 92560720055766143+ wwv_flow_api.g_id_offset,
  p_display_sequence=> 30,
  p_display_column=> 1,
  p_display_point=> 'AFTER_SHOW_ITEMS',
  p_source=> s,
  p_source_type=> 'SQL_QUERY',
  p_display_error_message=> '#SQLERRM#',
  p_display_when_condition=> ':P21505_OBJ_TYPE_CODE=''ACT.DOCUMENT_REVIEW''',
  p_display_condition_type=> 'PLSQL_EXPRESSION',
  p_plug_caching=> 'NOT_CACHED',
  p_customized=> '0',
  p_translate_title=> 'Y',
  p_ajax_enabled=> 'Y',
  p_query_row_template=> 5228919666917120+ wwv_flow_api.g_id_offset,
  p_query_headings_type=> 'COLON_DELMITED_LIST',
  p_query_options=> 'DERIVED_REPORT_COLUMNS',
  p_query_show_nulls_as=> ' - ',
  p_query_break_cols=> '0',
  p_query_no_data_found=> '<b><center>***** No &P21505_OBJ_TYPE_DESCRIPTION.s in the List Yet *****</center></b>',
  p_query_num_rows_type=> 'NEXT_PREVIOUS_LINKS',
  p_query_row_count_max=> '500',
  p_pagination_display_position=> 'BOTTOM_RIGHT',
  p_csv_output=> 'N',
  p_sort_null=> 'F',
  p_query_asc_image=> 'arrow_down_gray_dark.gif',
  p_query_asc_image_attr=> 'width="13" height="12" alt=""',
  p_query_desc_image=> 'arrow_up_gray_dark.gif',
  p_query_desc_image_attr=> 'width="13" height="12" alt=""',
  p_plug_query_strip_html=> 'Y',
  p_comment=>'');
end;
/
declare
  s varchar2(32767) := null;
begin
s := null;
wwv_flow_api.create_report_columns (
  p_id=> 15158527104591902 + wwv_flow_api.g_id_offset,
  p_region_id=> 15158319616591900 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_query_column_id=> 1,
  p_form_element_id=> null,
  p_column_alias=> 'SID',
  p_column_display_sequence=> 1,
  p_column_heading=> '&nbsp;',
  p_column_link=>'javascript:doSubmit(''EDIT_#SID#'');',
  p_column_linktext=>'&ICON_EDIT.',
  p_column_link_attr=>'name=''#SID#''',
  p_column_alignment=>'LEFT',
  p_heading_alignment=>'CENTER',
  p_default_sort_column_sequence=>0,
  p_disable_sort_column=>'Y',
  p_sum_column=> 'N',
  p_hidden_column=> 'N',
  p_display_as=>'WITHOUT_MODIFICATION',
  p_lov_show_nulls=> 'NO',
  p_pk_col_source=> s,
  p_include_in_export=> 'Y',
  p_column_comment=>'');
end;
/
declare
  s varchar2(32767) := null;
begin
s := null;
wwv_flow_api.create_report_columns (
  p_id=> 15158612089591902 + wwv_flow_api.g_id_offset,
  p_region_id=> 15158319616591900 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_query_column_id=> 2,
  p_form_element_id=> null,
  p_column_alias=> 'Select',
  p_column_display_sequence=> 2,
  p_column_heading=> '<input type="Checkbox" onclick="$f_CheckFirstColumn(this)">',
  p_column_alignment=>'LEFT',
  p_heading_alignment=>'CENTER',
  p_default_sort_column_sequence=>0,
  p_disable_sort_column=>'Y',
  p_sum_column=> 'N',
  p_hidden_column=> 'N',
  p_display_as=>'WITHOUT_MODIFICATION',
  p_pk_col_source=> s,
  p_column_comment=>'');
end;
/
declare
  s varchar2(32767) := null;
begin
s := null;
wwv_flow_api.create_report_columns (
  p_id=> 15158724174591902 + wwv_flow_api.g_id_offset,
  p_region_id=> 15158319616591900 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_query_column_id=> 3,
  p_form_element_id=> null,
  p_column_alias=> 'Review Date',
  p_column_display_sequence=> 3,
  p_column_heading=> 'Review Date',
  p_column_format=> '&FMT_DATE.',
  p_column_alignment=>'LEFT',
  p_heading_alignment=>'CENTER',
  p_default_sort_column_sequence=>0,
  p_disable_sort_column=>'Y',
  p_sum_column=> 'N',
  p_hidden_column=> 'N',
  p_display_as=>'WITHOUT_MODIFICATION',
  p_lov_show_nulls=> 'NO',
  p_pk_col_source=> s,
  p_include_in_export=> 'Y',
  p_column_comment=>'');
end;
/
declare
  s varchar2(32767) := null;
begin
s := null;
wwv_flow_api.create_report_columns (
  p_id=> 15159914337609256 + wwv_flow_api.g_id_offset,
  p_region_id=> 15158319616591900 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_query_column_id=> 4,
  p_form_element_id=> null,
  p_column_alias=> 'Document Number',
  p_column_display_sequence=> 5,
  p_column_heading=> 'Document Number',
  p_column_alignment=>'LEFT',
  p_heading_alignment=>'CENTER',
  p_default_sort_column_sequence=>0,
  p_disable_sort_column=>'Y',
  p_sum_column=> 'N',
  p_hidden_column=> 'N',
  p_display_as=>'WITHOUT_MODIFICATION',
  p_pk_col_source=> s,
  p_column_comment=>'');
end;
/
declare
  s varchar2(32767) := null;
begin
s := null;
wwv_flow_api.create_report_columns (
  p_id=> 15160022347609256 + wwv_flow_api.g_id_offset,
  p_region_id=> 15158319616591900 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_query_column_id=> 5,
  p_form_element_id=> null,
  p_column_alias=> 'Explanation',
  p_column_display_sequence=> 6,
  p_column_heading=> 'Explanation',
  p_column_alignment=>'LEFT',
  p_heading_alignment=>'CENTER',
  p_default_sort_column_sequence=>0,
  p_disable_sort_column=>'Y',
  p_sum_column=> 'N',
  p_hidden_column=> 'N',
  p_display_as=>'WITHOUT_MODIFICATION',
  p_pk_col_source=> s,
  p_column_comment=>'');
end;
/
declare
  s varchar2(32767) := null;
begin
s := null;
wwv_flow_api.create_report_columns (
  p_id=> 15158907025591902 + wwv_flow_api.g_id_offset,
  p_region_id=> 15158319616591900 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_query_column_id=> 6,
  p_form_element_id=> null,
  p_column_alias=> 'NARRATIVE',
  p_column_display_sequence=> 7,
  p_column_heading=> 'Narrative',
  p_column_alignment=>'LEFT',
  p_heading_alignment=>'CENTER',
  p_default_sort_column_sequence=>0,
  p_disable_sort_column=>'Y',
  p_sum_column=> 'N',
  p_hidden_column=> 'N',
  p_display_as=>'WITHOUT_MODIFICATION',
  p_pk_col_source=> s,
  p_column_comment=>'');
end;
/
declare
  s varchar2(32767) := null;
begin
s := null;
wwv_flow_api.create_report_columns (
  p_id=> 15160132539609256 + wwv_flow_api.g_id_offset,
  p_region_id=> 15158319616591900 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_query_column_id=> 7,
  p_form_element_id=> null,
  p_column_alias=> 'Document Type',
  p_column_display_sequence=> 4,
  p_column_heading=> 'Document Type',
  p_column_alignment=>'LEFT',
  p_heading_alignment=>'CENTER',
  p_default_sort_column_sequence=>0,
  p_disable_sort_column=>'Y',
  p_sum_column=> 'N',
  p_hidden_column=> 'N',
  p_display_as=>'WITHOUT_MODIFICATION',
  p_pk_col_source=> s,
  p_column_comment=>'');
end;
/
declare
  s varchar2(32767) := null;
begin
s := null;
wwv_flow_api.create_report_columns (
  p_id=> 15159128236591902 + wwv_flow_api.g_id_offset,
  p_region_id=> 15158319616591900 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_query_column_id=> 8,
  p_form_element_id=> null,
  p_column_alias=> 'Current',
  p_column_display_sequence=> 8,
  p_column_heading=> 'Current',
  p_column_alignment=>'LEFT',
  p_heading_alignment=>'CENTER',
  p_default_sort_column_sequence=>0,
  p_disable_sort_column=>'Y',
  p_sum_column=> 'N',
  p_hidden_column=> 'Y',
  p_display_as=>'WITHOUT_MODIFICATION',
  p_pk_col_source=> s,
  p_column_comment=>'');
end;
/
declare
  s varchar2(32767) := null;
  l_clob clob;
  l_length number := 1;
begin
s := null;
wwv_flow_api.create_page_plug (
  p_id=> 15255719924339446 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_page_id=> 21505,
  p_plug_name=> 'Hidden',
  p_region_name=>'',
  p_plug_template=> 0,
  p_plug_display_sequence=> 5,
  p_plug_display_column=> 1,
  p_plug_display_point=> 'AFTER_SHOW_ITEMS',
  p_plug_source=> s,
  p_plug_source_type=> 'STATIC_TEXT',
  p_translate_title=> 'Y',
  p_plug_display_error_message=> '#SQLERRM#',
  p_plug_query_row_template=> 1,
  p_plug_query_headings_type=> 'COLON_DELMITED_LIST',
  p_plug_query_row_count_max => 500,
  p_plug_display_condition_type => '',
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
  p_id=> 92093732891224301 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_page_id=> 21505,
  p_plug_name=> '&P21505_OBJ_TYPE_DESCRIPTION. Details',
  p_region_name=>'',
  p_plug_template=> 179216655889554481+ wwv_flow_api.g_id_offset,
  p_plug_display_sequence=> 50,
  p_plug_display_column=> 1,
  p_plug_display_point=> 'AFTER_SHOW_ITEMS',
  p_plug_source=> s,
  p_plug_source_type=> 'STATIC_TEXT',
  p_translate_title=> 'Y',
  p_plug_display_error_message=> '#SQLERRM#',
  p_plug_query_row_template=> 1,
  p_plug_query_headings_type=> 'COLON_DELMITED_LIST',
  p_plug_query_row_count_max => 500,
  p_plug_display_condition_type => 'PLSQL_EXPRESSION',
  p_plug_display_when_condition => ':P21505_SELECTED IS NOT NULL'||chr(10)||
'OR'||chr(10)||
':REQUEST IN (''ADDNEW'')',
  p_plug_customized=>'0',
  p_plug_caching=> 'NOT_CACHED',
  p_plug_comment=> '');
end;
/
 
begin
 
wwv_flow_api.create_page_button(
  p_id             => 14993025346725866 + wwv_flow_api.g_id_offset,
  p_flow_id        => wwv_flow.g_flow_id,
  p_flow_step_id   => 21505,
  p_button_sequence=> 50,
  p_button_plug_id => 14971424570394387+wwv_flow_api.g_id_offset,
  p_button_name    => 'ADDNEW',
  p_button_image   => 'template:'||to_char(179221063608554498+wwv_flow_api.g_id_offset),
  p_button_image_alt=> 'Add New',
  p_button_position=> 'REGION_TEMPLATE_CHANGE',
  p_button_alignment=> 'RIGHT',
  p_button_redirect_url=> '',
  p_security_scheme => 4418131991249078+ wwv_flow_api.g_id_offset,
  p_required_patch => null + wwv_flow_api.g_id_offset);
 
wwv_flow_api.create_page_button(
  p_id             => 15112517566305156 + wwv_flow_api.g_id_offset,
  p_flow_id        => wwv_flow.g_flow_id,
  p_flow_step_id   => 21505,
  p_button_sequence=> 70,
  p_button_plug_id => 14971424570394387+wwv_flow_api.g_id_offset,
  p_button_name    => 'REMOVE',
  p_button_image   => 'template:'||to_char(179221063608554498+wwv_flow_api.g_id_offset),
  p_button_image_alt=> 'Remove Selected',
  p_button_position=> 'REGION_TEMPLATE_CHANGE',
  p_button_alignment=> 'RIGHT',
  p_button_redirect_url=> '',
  p_required_patch => null + wwv_flow_api.g_id_offset);
 
wwv_flow_api.create_page_button(
  p_id             => 15167023950630994 + wwv_flow_api.g_id_offset,
  p_flow_id        => wwv_flow.g_flow_id,
  p_flow_step_id   => 21505,
  p_button_sequence=> 80,
  p_button_plug_id => 15158319616591900+wwv_flow_api.g_id_offset,
  p_button_name    => 'ADDNEW',
  p_button_image   => 'template:'||to_char(179221063608554498+wwv_flow_api.g_id_offset),
  p_button_image_alt=> 'Add New',
  p_button_position=> 'REGION_TEMPLATE_CHANGE',
  p_button_alignment=> 'RIGHT',
  p_button_redirect_url=> '',
  p_security_scheme => 4418131991249078+ wwv_flow_api.g_id_offset,
  p_required_patch => null + wwv_flow_api.g_id_offset);
 
wwv_flow_api.create_page_button(
  p_id             => 15167227066631877 + wwv_flow_api.g_id_offset,
  p_flow_id        => wwv_flow.g_flow_id,
  p_flow_step_id   => 21505,
  p_button_sequence=> 90,
  p_button_plug_id => 15158319616591900+wwv_flow_api.g_id_offset,
  p_button_name    => 'REMOVE',
  p_button_image   => 'template:'||to_char(179221063608554498+wwv_flow_api.g_id_offset),
  p_button_image_alt=> 'Remove Selected',
  p_button_position=> 'REGION_TEMPLATE_CHANGE',
  p_button_alignment=> 'RIGHT',
  p_button_redirect_url=> '',
  p_required_patch => null + wwv_flow_api.g_id_offset);
 
wwv_flow_api.create_page_button(
  p_id             => 92094015476224306 + wwv_flow_api.g_id_offset,
  p_flow_id        => wwv_flow.g_flow_id,
  p_flow_step_id   => 21505,
  p_button_sequence=> 30,
  p_button_plug_id => 92093732891224301+wwv_flow_api.g_id_offset,
  p_button_name    => 'SAVE',
  p_button_image   => 'template:'||to_char(179221063608554498+wwv_flow_api.g_id_offset),
  p_button_image_alt=> '&BTN_SAVE.',
  p_button_position=> 'REGION_TEMPLATE_CREATE',
  p_button_alignment=> 'RIGHT',
  p_button_redirect_url=> '',
  p_button_condition=> ':P21505_SELECTED IS NOT NULL'||chr(10)||
'AND'||chr(10)||
':REQUEST NOT IN (''ADDNEW'')',
  p_button_condition_type=> 'PLSQL_EXPRESSION',
  p_security_scheme => 4418131991249078+ wwv_flow_api.g_id_offset,
  p_required_patch => null + wwv_flow_api.g_id_offset);
 
wwv_flow_api.create_page_button(
  p_id             => 15104005820178675 + wwv_flow_api.g_id_offset,
  p_flow_id        => wwv_flow.g_flow_id,
  p_flow_step_id   => 21505,
  p_button_sequence=> 60,
  p_button_plug_id => 92093732891224301+wwv_flow_api.g_id_offset,
  p_button_name    => 'ADD',
  p_button_image   => 'template:'||to_char(179221063608554498+wwv_flow_api.g_id_offset),
  p_button_image_alt=> '&BTN_SAVE.',
  p_button_position=> 'REGION_TEMPLATE_CREATE',
  p_button_alignment=> 'RIGHT',
  p_button_redirect_url=> '',
  p_button_condition=> 'ADDNEW',
  p_button_condition_type=> 'REQUEST_EQUALS_CONDITION',
  p_security_scheme => 4418131991249078+ wwv_flow_api.g_id_offset,
  p_required_patch => null + wwv_flow_api.g_id_offset);
 
wwv_flow_api.create_page_button(
  p_id             => 92094338215224307 + wwv_flow_api.g_id_offset,
  p_flow_id        => wwv_flow.g_flow_id,
  p_flow_step_id   => 21505,
  p_button_sequence=> 10,
  p_button_plug_id => 92093732891224301+wwv_flow_api.g_id_offset,
  p_button_name    => 'CANCEL',
  p_button_image   => 'template:'||to_char(179221063608554498+wwv_flow_api.g_id_offset),
  p_button_image_alt=> '&BTN_CANCEL.',
  p_button_position=> 'REGION_TEMPLATE_PREVIOUS',
  p_button_alignment=> 'RIGHT',
  p_button_redirect_url=> '',
  p_required_patch => null + wwv_flow_api.g_id_offset);
 
 
end;
/

 
begin
 
wwv_flow_api.create_page_branch(
  p_id=>92557208179630251 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 21505,
  p_branch_action=> 'f?p=&APP_ID.:&TAB_PAGE.:&SESSION.:TAB:&DEBUG.:&TAB_PAGE.:P0_OBJ:&TAB_PAGE_OBJ.',
  p_branch_point=> 'AFTER_PROCESSING',
  p_branch_type=> 'REDIRECT_URL',
  p_branch_sequence=> 5,
  p_branch_condition_type=> 'PLSQL_EXPRESSION',
  p_branch_condition=> ':REQUEST LIKE ''TAB%''',
  p_save_state_before_branch_yn=>'N',
  p_branch_comment=> '');
 
wwv_flow_api.create_page_branch(
  p_id=>92094926113224317 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 21505,
  p_branch_action=> 'f?p=&APP_ID.:21505:&SESSION.:&REQUEST.:&DEBUG.::P0_OBJ:&P21505_OBJ.&success_msg=#SUCCESS_MSG#',
  p_branch_point=> 'AFTER_PROCESSING',
  p_branch_type=> 'REDIRECT_URL',
  p_branch_sequence=> 20,
  p_save_state_before_branch_yn=>'N',
  p_branch_comment=> '');
 
 
end;
/

declare
    h varchar2(32767) := null;
begin
wwv_flow_api.create_page_item(
  p_id=>14974716399477216 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 21505,
  p_name=>'P21505_SELECTED',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 5,
  p_item_plug_id => 15255719924339446+wwv_flow_api.g_id_offset,
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
  p_cAttributes=> 'nowrap="nowrap"',
  p_begin_on_new_line => 'NO',
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
  p_id=>14975028650490262 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 21505,
  p_name=>'P21505_NARRATIVE',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 7,
  p_item_plug_id => 92093732891224301+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'YES',
  p_item_default_type => 'STATIC_TEXT_WITH_SUBSTITUTIONS',
  p_prompt=>'Narrative Text:',
  p_source_type=> 'STATIC',
  p_display_as=> 'TEXTAREA_CHAR_COUNT',
  p_lov_columns=> 1,
  p_lov_display_null=> 'NO',
  p_lov_translated=> 'N',
  p_cSize=> 0,
  p_cMaxlength=> 30000,
  p_cHeight=> 15,
  p_cAttributes=> 'style="width:100%"',
  p_cattributes_element=>'style="width:100%"',
  p_tag_attributes  => 'style="width:100%" style="height:auto" style="rows:30"',
  p_tag_attributes2=> 'style="width:100%"',
  p_begin_on_new_line => 'YES',
  p_begin_on_new_field=> 'YES',
  p_colspan => 1,
  p_rowspan => 1,
  p_label_alignment  => 'ABOVE',
  p_field_alignment  => 'LEFT-TOP',
  p_field_template => 179220647225554497+wwv_flow_api.g_id_offset,
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
  p_id=>14975614368504983 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 21505,
  p_name=>'P21505_X',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 6,
  p_item_plug_id => 92093732891224301+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'YES',
  p_item_default_type => 'STATIC_TEXT_WITH_SUBSTITUTIONS',
  p_source_type=> 'STATIC',
  p_display_as=> 'STOP_AND_START_HTML_TABLE',
  p_lov_columns=> 1,
  p_lov_display_null=> 'NO',
  p_lov_translated=> 'N',
  p_cSize=> 30,
  p_cMaxlength=> 2000,
  p_cHeight=> 1,
  p_cAttributes=> 'nowrap="nowrap"',
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
  p_id=>14992017802629046 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 21505,
  p_name=>'P21505_RESULT',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 5,
  p_item_plug_id => 92093732891224301+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'YES',
  p_item_default_type => 'STATIC_TEXT_WITH_SUBSTITUTIONS',
  p_prompt=>'&P21505_RESULT_LABEL.',
  p_source_type=> 'STATIC',
  p_display_as=> 'COMBOBOX',
  p_lov => 'STATIC2:&P21505_RESULT_LOV.',
  p_lov_columns=> 1,
  p_lov_display_null=> 'NO',
  p_lov_translated=> 'N',
  p_cSize=> 30,
  p_cMaxlength=> 2000,
  p_cHeight=> 5,
  p_cAttributes=> 'nowrap',
  p_tag_attributes  => 'onchange="javascript:buildRC_DRNarrativeandTitle(''P21505_TYPE'',''P21505_RESULT'',''P21505_NARRATIVE'','''',''P21505_OBJ_TYPE_CODE''); showHideFields();"',
  p_begin_on_new_line => 'YES',
  p_begin_on_new_field=> 'YES',
  p_colspan => 1,
  p_rowspan => 1,
  p_label_alignment  => 'LEFT',
  p_field_alignment  => 'LEFT',
  p_field_template => 179220647225554497+wwv_flow_api.g_id_offset,
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
  p_id=>14992231655633045 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 21505,
  p_name=>'P21505_TYPE_LOV',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 7,
  p_item_plug_id => 15255719924339446+wwv_flow_api.g_id_offset,
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
  p_cAttributes=> 'nowrap="nowrap"',
  p_begin_on_new_line => 'NO',
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
  p_id=>14992503520643836 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 21505,
  p_name=>'P21505_TYPE_LABEL',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 6,
  p_item_plug_id => 15255719924339446+wwv_flow_api.g_id_offset,
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
  p_cAttributes=> 'nowrap="nowrap"',
  p_begin_on_new_line => 'NO',
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
  p_id=>15060718222934705 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 21505,
  p_name=>'P21505_RESULT_LABEL',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 8,
  p_item_plug_id => 15255719924339446+wwv_flow_api.g_id_offset,
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
  p_cAttributes=> 'nowrap="nowrap"',
  p_begin_on_new_line => 'NO',
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
  p_id=>15060925148936716 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 21505,
  p_name=>'P21505_RESULT_LOV',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 9,
  p_item_plug_id => 15255719924339446+wwv_flow_api.g_id_offset,
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
  p_cAttributes=> 'nowrap="nowrap"',
  p_begin_on_new_line => 'NO',
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
  p_id=>15111311501265521 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 21505,
  p_name=>'P21505_OBJ',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 1,
  p_item_plug_id => 15255719924339446+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'YES',
  p_item_default_type => 'STATIC_TEXT_WITH_SUBSTITUTIONS',
  p_source_type=> 'STATIC',
  p_display_as=> 'HIDDEN',
  p_lov_columns=> 1,
  p_lov_display_null=> 'NO',
  p_lov_translated=> 'N',
  p_cSize=> 30,
  p_cMaxlength=> 2000,
  p_cHeight=> 5,
  p_cAttributes=> 'nowrap="nowrap"',
  p_begin_on_new_line => 'NO',
  p_begin_on_new_field=> 'YES',
  p_colspan => 1,
  p_rowspan => 1,
  p_label_alignment  => 'LEFT',
  p_field_alignment  => 'LEFT',
  p_field_template => 179220647225554497+wwv_flow_api.g_id_offset,
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
  p_id=>15146103902227797 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 21505,
  p_name=>'P21505_OBJ_TYPE_CODE',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 2,
  p_item_plug_id => 15255719924339446+wwv_flow_api.g_id_offset,
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
  p_cAttributes=> 'nowrap="nowrap"',
  p_begin_on_new_line => 'NO',
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
  p_id=>15147331653264200 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 21505,
  p_name=>'P21505_OBJ_TYPE_DESCRIPTION',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 3,
  p_item_plug_id => 15255719924339446+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'YES',
  p_item_default_type => 'STATIC_TEXT_WITH_SUBSTITUTIONS',
  p_source_type=> 'STATIC',
  p_display_as=> 'HIDDEN',
  p_lov_columns=> 1,
  p_lov_display_null=> 'NO',
  p_lov_translated=> 'N',
  p_cSize=> 30,
  p_cMaxlength=> 2000,
  p_cHeight=> 5,
  p_cAttributes=> 'nowrap="nowrap"',
  p_begin_on_new_line => 'NO',
  p_begin_on_new_field=> 'YES',
  p_colspan => 1,
  p_rowspan => 1,
  p_label_alignment  => 'LEFT',
  p_field_alignment  => 'LEFT',
  p_field_template => 179220647225554497+wwv_flow_api.g_id_offset,
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
  p_id=>15149211015343399 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 21505,
  p_name=>'P21505_NUMBER_LABEL',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 10,
  p_item_plug_id => 15255719924339446+wwv_flow_api.g_id_offset,
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
  p_cAttributes=> 'nowrap="nowrap"',
  p_begin_on_new_line => 'NO',
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
  p_id=>15149720936412471 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 21505,
  p_name=>'P21505_EXPLANATION',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 4,
  p_item_plug_id => 92093732891224301+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'YES',
  p_item_default_type => 'STATIC_TEXT_WITH_SUBSTITUTIONS',
  p_prompt=>'Explanation',
  p_source_type=> 'STATIC',
  p_display_as=> 'TEXTAREA_CHAR_COUNT',
  p_lov_columns=> 1,
  p_lov_display_null=> 'NO',
  p_lov_translated=> 'N',
  p_cSize=> 80,
  p_cMaxlength=> 1000,
  p_cHeight=> 10,
  p_begin_on_new_line => 'YES',
  p_begin_on_new_field=> 'YES',
  p_colspan => 1,
  p_rowspan => 1,
  p_label_alignment  => 'LEFT-TOP',
  p_field_alignment  => 'LEFT',
  p_display_when=>':P21505_OBJ_TYPE_CODE=''ACT.DOCUMENT_REVIEW''',
  p_display_when_type=>'PLSQL_EXPRESSION',
  p_field_template => 179220647225554497+wwv_flow_api.g_id_offset,
  p_is_persistent=> 'Y',
  p_lov_display_extra=>'NO',
  p_protection_level => 'N',
  p_item_comment => 'osi_reference.lookup_ref_sid(''DOCREV_DOCTYPE'',''ZZZ'') = :P21505_TYPE');
 
 
end;
/

declare
    h varchar2(32767) := null;
begin
wwv_flow_api.create_page_item(
  p_id=>16853427690736732 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 21505,
  p_name=>'P21505_ACTIVITY_DATE',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 1,
  p_item_plug_id => 92093732891224301+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'YES',
  p_item_default_type => 'STATIC_TEXT_WITH_SUBSTITUTIONS',
  p_prompt=>'Review Date',
  p_format_mask=>'&FMT_DATE.',
  p_source_type=> 'STATIC',
  p_display_as=> 'TEXT',
  p_lov_columns=> 1,
  p_lov_display_null=> 'NO',
  p_lov_translated=> 'N',
  p_cSize=> 18,
  p_cMaxlength=> 4000,
  p_cHeight=> 1,
  p_cAttributes=> 'nowrap',
  p_tag_attributes  => 'class="datepickernew"',
  p_begin_on_new_line => 'YES',
  p_begin_on_new_field=> 'YES',
  p_colspan => 1,
  p_rowspan => 1,
  p_label_alignment  => 'LEFT',
  p_field_alignment  => 'LEFT',
  p_field_template => 179220853378554498+wwv_flow_api.g_id_offset,
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
  p_id=>92095130765224317 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 21505,
  p_name=>'P21505_SID',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 4,
  p_item_plug_id => 15255719924339446+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'YES',
  p_item_default_type => 'STATIC_TEXT_WITH_SUBSTITUTIONS',
  p_source_type=> 'STATIC',
  p_display_as=> 'HIDDEN',
  p_lov_columns=> 1,
  p_lov_display_null=> 'NO',
  p_lov_translated=> 'N',
  p_cSize=> 30,
  p_cMaxlength=> 255,
  p_cHeight=> 1,
  p_begin_on_new_line => 'NO',
  p_begin_on_new_field=> 'YES',
  p_colspan => 1,
  p_rowspan => 1,
  p_label_alignment  => 'LEFT',
  p_field_alignment  => 'LEFT',
  p_field_template => 179220647225554497+wwv_flow_api.g_id_offset,
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
  p_id=>92095321905224326 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 21505,
  p_name=>'P21505_REFERENCE_NUM',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 3,
  p_item_plug_id => 92093732891224301+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'YES',
  p_item_default_type => 'STATIC_TEXT_WITH_SUBSTITUTIONS',
  p_prompt=>'&P21505_NUMBER_LABEL.',
  p_source_type=> 'STATIC',
  p_display_as=> 'TEXT',
  p_lov_columns=> 1,
  p_lov_display_null=> 'NO',
  p_lov_translated=> 'N',
  p_cSize=> 32,
  p_cMaxlength=> 100,
  p_cHeight=> 1,
  p_begin_on_new_line => 'YES',
  p_begin_on_new_field=> 'YES',
  p_colspan => 1,
  p_rowspan => 1,
  p_label_alignment  => 'LEFT',
  p_field_alignment  => 'LEFT',
  p_field_template => 179220647225554497+wwv_flow_api.g_id_offset,
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
  p_id=>92559636884685906 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 21505,
  p_name=>'P21505_TYPE',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 2,
  p_item_plug_id => 92093732891224301+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'YES',
  p_item_default_type => 'STATIC_TEXT_WITH_SUBSTITUTIONS',
  p_prompt=>'Record Type',
  p_source_type=> 'STATIC',
  p_display_as=> 'COMBOBOX',
  p_lov => 'STATIC2:&P21505_TYPE_LOV.',
  p_lov_columns=> 1,
  p_lov_display_null=> 'NO',
  p_lov_translated=> 'N',
  p_cSize=> 50,
  p_cMaxlength=> 200,
  p_cHeight=> 5,
  p_cAttributes=> 'nowrap="nowrap"',
  p_tag_attributes  => 'onchange="javascript:buildRC_DRNarrativeandTitle(''P21505_TYPE'',''P21505_RESULT'',''P21505_NARRATIVE'','''',''P21505_OBJ_TYPE_CODE''); showHideFields();"',
  p_begin_on_new_line => 'YES',
  p_begin_on_new_field=> 'YES',
  p_colspan => 1,
  p_rowspan => 1,
  p_label_alignment  => 'LEFT',
  p_field_alignment  => 'LEFT',
  p_field_template => 179220853378554498+wwv_flow_api.g_id_offset,
  p_is_persistent=> 'Y',
  p_lov_display_extra=>'NO',
  p_protection_level => 'N',
  p_item_comment => '');
 
 
end;
/

 
begin
 
wwv_flow_api.create_page_validation(
  p_id => 16854312368751275 + wwv_flow_api.g_id_offset,
  p_flow_id => wwv_flow.g_flow_id,
  p_flow_step_id => 21505,
  p_validation_name => 'P21505_ACTIVITY_DATE',
  p_validation_sequence=> 1,
  p_validation => 'P21505_ACTIVITY_DATE',
  p_validation_type => 'ITEM_NOT_NULL',
  p_error_message => 'Review Date must be specified.',
  p_when_button_pressed=> 92094015476224306 + wwv_flow_api.g_id_offset,
  p_associated_item=> 16853427690736732 + wwv_flow_api.g_id_offset,
  p_error_display_location=>'INLINE_WITH_FIELD_AND_NOTIFICATION',
  p_validation_comment=> '');
 
null;
 
end;
/

 
begin
 
wwv_flow_api.create_page_validation(
  p_id => 16854606958759159 + wwv_flow_api.g_id_offset,
  p_flow_id => wwv_flow.g_flow_id,
  p_flow_step_id => 21505,
  p_validation_name => 'Valid Date',
  p_validation_sequence=> 5,
  p_validation => 'P21505_ACTIVITY_DATE',
  p_validation_type => 'ITEM_IS_DATE',
  p_error_message => 'Date is invalid.',
  p_validation_condition=> ':p21505_activity_date is not null and :request = ''SAVE''',
  p_validation_condition_type=> 'PLSQL_EXPRESSION',
  p_associated_item=> 16853427690736732 + wwv_flow_api.g_id_offset,
  p_error_display_location=>'INLINE_WITH_FIELD_AND_NOTIFICATION',
  p_validation_comment=> '');
 
null;
 
end;
/

 
begin
 
wwv_flow_api.create_page_validation(
  p_id => 92594608534406278 + wwv_flow_api.g_id_offset,
  p_flow_id => wwv_flow.g_flow_id,
  p_flow_step_id => 21505,
  p_validation_name => 'Document Type not null',
  p_validation_sequence=> 10,
  p_validation => 'P21505_TYPE',
  p_validation_type => 'ITEM_NOT_NULL',
  p_error_message => 'A Record Type must be selected from the list.',
  p_when_button_pressed=> 92094015476224306 + wwv_flow_api.g_id_offset,
  p_associated_item=> 92559636884685906 + wwv_flow_api.g_id_offset,
  p_error_display_location=>'INLINE_WITH_FIELD_AND_NOTIFICATION',
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
p:=p||':P21505_SELECTED:=NULL;'||chr(10)||
':P21505_NARRATIVE:=NULL;'||chr(10)||
':P21505_TYPE:=NULL;'||chr(10)||
':P21505_RESULT:=NULL;'||chr(10)||
':P21505_REFERENCE_NUM:=NULL;'||chr(10)||
':P21505_EXPLANATION:=NULL;';

wwv_flow_api.create_page_process(
  p_id     => 15096317201153588 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id => 21505,
  p_process_sequence=> 80,
  p_process_point=> 'AFTER_HEADER',
  p_process_type=> 'PLSQL',
  p_process_name=> 'ClearSelected',
  p_process_sql_clob => p, 
  p_process_error_message=> '',
  p_process_when=>'ADDNEW',
  p_process_when_type=>'REQUEST_EQUALS_CONDITION',
  p_process_success_message=> '',
  p_process_is_stateful_y_n=>'N',
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
'     if :p21505_obj_type_code=''ACT.RECORDS_CHECK'' then'||chr(10)||
''||chr(10)||
'       begin'||chr(10)||
'           for I in 1 .. apex_application.g_f01.count'||chr(10)||
'           loop'||chr(10)||
'               delete from T_OSI_A_RECORDS_CHECK'||chr(10)||
'                     where sid = apex_application.g_f01(I);'||chr(10)||
''||chr(10)||
'               if (apex_application.g_f01(I) = :P21505_SELECTED) then'||chr(10)||
''||chr(10)||
'                 :P21505_SELECTED:=NULL;'||chr(10)||
''||chr(10)||
'               end if;'||chr(10)||
''||chr(10)||
'        ';

p:=p||'   end loop;'||chr(10)||
''||chr(10)||
'       end;'||chr(10)||
''||chr(10)||
'     elsif :p21505_obj_type_code=''ACT.DOCUMENT_REVIEW'' then'||chr(10)||
''||chr(10)||
'          begin'||chr(10)||
'              for I in 1 .. apex_application.g_f01.count'||chr(10)||
'              loop'||chr(10)||
'                  delete from T_OSI_A_DOCUMENT_REVIEW'||chr(10)||
'                        where sid = apex_application.g_f01(I);'||chr(10)||
''||chr(10)||
'                  if (apex_application.g_f01(I) = :P21505_SELECTED) then'||chr(10)||
''||chr(10)||
'                    :P21505_';

p:=p||'SELECTED:=NULL;'||chr(10)||
''||chr(10)||
'                  end if;'||chr(10)||
''||chr(10)||
'              end loop;'||chr(10)||
''||chr(10)||
'          end;'||chr(10)||
''||chr(10)||
'     end if;'||chr(10)||
''||chr(10)||
'     commit;'||chr(10)||
''||chr(10)||
'end;';

wwv_flow_api.create_page_process(
  p_id     => 14973915743429703 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id => 21505,
  p_process_sequence=> 5,
  p_process_point=> 'AFTER_SUBMIT',
  p_process_type=> 'PLSQL',
  p_process_name=> 'Remove Selected',
  p_process_sql_clob => p, 
  p_process_error_message=> '',
  p_process_when_button_id=>15112517566305156 + wwv_flow_api.g_id_offset,
  p_process_when=>'REMOVE',
  p_process_when_type=>'REQUEST_EQUALS_CONDITION',
  p_process_success_message=> '',
  p_security_scheme => 4418131991249078+ wwv_flow_api.g_id_offset,
  p_process_is_stateful_y_n=>'N',
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
'   '||chr(10)||
'   if :p21505_obj_type_code=''ACT.RECORDS_CHECK'' then'||chr(10)||
''||chr(10)||
'     insert into t_osi_a_records_check (activity_date,reference_num,narrative,doc_type,results,obj) values'||chr(10)||
'           (:P21505_ACTIVITY_DATE,'||chr(10)||
'           :P21505_REFERENCE_NUM,'||chr(10)||
'           :P21505_NARRATIVE,'||chr(10)||
'           REPLACE(:P21505_TYPE,''%null%'',NULL),'||chr(10)||
'           REPLACE(:P21505_RESULT,''%null%'',NULL),'||chr(10)||
'           :P21505_OBJ) '||chr(10)||
'     re';

p:=p||'turning sid into :P21505_SELECTED;'||chr(10)||
''||chr(10)||
'   elsif :p21505_obj_type_code=''ACT.DOCUMENT_REVIEW'' then'||chr(10)||
''||chr(10)||
'         insert into t_osi_a_document_review (activity_date,document_number,narrative,doc_type,results,obj,explanation) values'||chr(10)||
'               (:P21505_ACTIVITY_DATE,'||chr(10)||
'               :P21505_REFERENCE_NUM,'||chr(10)||
'               :P21505_NARRATIVE,'||chr(10)||
'               REPLACE(:P21505_TYPE,''%null%'',NULL),'||chr(10)||
'               ';

p:=p||'REPLACE(:P21505_RESULT,''%null%'',NULL),'||chr(10)||
'               :P21505_OBJ,'||chr(10)||
'               :P21505_EXPLANATION) '||chr(10)||
'        returning sid into :P21505_SELECTED;'||chr(10)||
''||chr(10)||
'   end if;'||chr(10)||
''||chr(10)||
'   commit;'||chr(10)||
''||chr(10)||
'end;';

wwv_flow_api.create_page_process(
  p_id     => 14974121284431269 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id => 21505,
  p_process_sequence=> 5,
  p_process_point=> 'AFTER_SUBMIT',
  p_process_type=> 'PLSQL',
  p_process_name=> 'Add Check To List',
  p_process_sql_clob => p, 
  p_process_error_message=> '',
  p_process_when_button_id=>15104005820178675 + wwv_flow_api.g_id_offset,
  p_process_when=>':REQUEST IN (''ADD'');',
  p_process_when_type=>'PLSQL_EXPRESSION',
  p_process_success_message=> '',
  p_process_is_stateful_y_n=>'N',
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
'   '||chr(10)||
'   if :p21505_obj_type_code=''ACT.RECORDS_CHECK'' then'||chr(10)||
''||chr(10)||
'     update t_osi_a_records_check set'||chr(10)||
'           reference_num=:p21505_reference_num,'||chr(10)||
'           doc_type=REPLACE(:P21505_TYPE,''%null%'',NULL),'||chr(10)||
'           narrative=:p21505_narrative,'||chr(10)||
'           activity_date=:p21505_activity_date,'||chr(10)||
'           results=REPLACE(:P21505_RESULT,''%null%'',NULL)'||chr(10)||
'      where SID=:p21505_selected;'||chr(10)||
''||chr(10)||
'   elsif :p21';

p:=p||'505_obj_type_code=''ACT.DOCUMENT_REVIEW'' then'||chr(10)||
''||chr(10)||
'        update t_osi_a_document_review set'||chr(10)||
'              document_number=:p21505_reference_num,'||chr(10)||
'              doc_type=REPLACE(:P21505_TYPE,''%null%'',NULL),'||chr(10)||
'              narrative=:p21505_narrative,'||chr(10)||
'              activity_date=:p21505_activity_date,'||chr(10)||
'              results=REPLACE(:P21505_RESULT,''%null%'',NULL),'||chr(10)||
'              explanation=:p21505_explanati';

p:=p||'on'||chr(10)||
'         where SID=:p21505_selected;'||chr(10)||
''||chr(10)||
'   end if;'||chr(10)||
''||chr(10)||
'   commit;'||chr(10)||
'end;';

wwv_flow_api.create_page_process(
  p_id     => 16853728167746410 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id => 21505,
  p_process_sequence=> 5,
  p_process_point=> 'AFTER_SUBMIT',
  p_process_type=> 'PLSQL',
  p_process_name=> 'Update',
  p_process_sql_clob => p, 
  p_process_error_message=> '&FAILURE_MSG.',
  p_process_when_button_id=>92094015476224306 + wwv_flow_api.g_id_offset,
  p_process_success_message=> '',
  p_process_is_stateful_y_n=>'N',
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
'   '||chr(10)||
'   if :p21505_obj_type_code=''ACT.RECORDS_CHECK'' then'||chr(10)||
''||chr(10)||
'     SELECT SID,'||chr(10)||
'            to_char(ACTIVITY_DATE,''dd-Mon-rrrr'') as ACTIVITY_DATE,'||chr(10)||
'            REFERENCE_NUM,'||chr(10)||
'            NARRATIVE,'||chr(10)||
'            DOC_TYPE,'||chr(10)||
'            RESULTS'||chr(10)||
'        INTO'||chr(10)||
'            :P21505_SELECTED,'||chr(10)||
'            :P21505_ACTIVITY_DATE,'||chr(10)||
'            :P21505_REFERENCE_NUM,'||chr(10)||
'            :P21505_NARRATIVE,'||chr(10)||
'            :P21';

p:=p||'505_TYPE,'||chr(10)||
'            :P21505_RESULT'||chr(10)||
'        FROM T_OSI_A_RECORDS_CHECK WHERE SID=REPLACE(:REQUEST,''EDIT_'','''');'||chr(10)||
''||chr(10)||
'   elsif :p21505_obj_type_code=''ACT.DOCUMENT_REVIEW'' then'||chr(10)||
''||chr(10)||
'        SELECT SID,'||chr(10)||
'               to_char(ACTIVITY_DATE,''dd-Mon-rrrr'') as ACTIVITY_DATE,'||chr(10)||
'               DOCUMENT_NUMBER,'||chr(10)||
'               NARRATIVE,'||chr(10)||
'               DOC_TYPE,'||chr(10)||
'               RESULTS,'||chr(10)||
'               EXPLANATION'||chr(10)||
'    ';

p:=p||'       INTO'||chr(10)||
'               :P21505_SELECTED,'||chr(10)||
'               :P21505_ACTIVITY_DATE,'||chr(10)||
'               :P21505_REFERENCE_NUM,'||chr(10)||
'               :P21505_NARRATIVE,'||chr(10)||
'               :P21505_TYPE,'||chr(10)||
'               :P21505_RESULT,'||chr(10)||
'               :P21505_EXPLANATION'||chr(10)||
'           FROM T_OSI_A_DOCUMENT_REVIEW WHERE SID=REPLACE(:REQUEST,''EDIT_'','''');'||chr(10)||
''||chr(10)||
'   end if;'||chr(10)||
''||chr(10)||
'end;';

wwv_flow_api.create_page_process(
  p_id     => 14973710549428221 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id => 21505,
  p_process_sequence=> 70,
  p_process_point=> 'AFTER_SUBMIT',
  p_process_type=> 'PLSQL',
  p_process_name=> 'Select Check in List',
  p_process_sql_clob => p, 
  p_process_error_message=> '',
  p_process_when=>':REQUEST LIKE ''EDIT%''',
  p_process_when_type=>'PLSQL_EXPRESSION',
  p_process_success_message=> '',
  p_process_is_stateful_y_n=>'N',
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
p:=p||'P21505_SELECTED';

wwv_flow_api.create_page_process(
  p_id     => 15610323737847566 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id => 21505,
  p_process_sequence=> 80,
  p_process_point=> 'AFTER_SUBMIT',
  p_process_type=> 'CLEAR_CACHE_FOR_ITEMS',
  p_process_name=> 'Cancel',
  p_process_sql_clob => p, 
  p_process_error_message=> '',
  p_process_when_button_id=>92094338215224307 + wwv_flow_api.g_id_offset,
  p_process_success_message=> '',
  p_process_is_stateful_y_n=>'N',
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
'  :P21505_obj := :p0_obj;'||chr(10)||
'  :P21505_OBJ_TYPE_CODE := :P0_OBJ_TYPE_CODE;'||chr(10)||
''||chr(10)||
'  select t.description into :P21505_OBJ_TYPE_DESCRIPTION  '||chr(10)||
'    from t_core_obj_type t where t.code=:P21505_OBJ_TYPE_CODE;'||chr(10)||
''||chr(10)||
'  IF (:P21505_OBJ_TYPE_CODE=''ACT.RECORDS_CHECK'') THEN'||chr(10)||
''||chr(10)||
'    :P21505_TYPE_LABEL := ''Records Check Type'';'||chr(10)||
'    :P21505_TYPE_LOV := ''- Select Record Type -;%null%,'' || osi_reference.get_lov(''LERC_DOCTYPE';

p:=p||''');'||chr(10)||
'    :P21505_RESULT_LABEL := ''Records Check Result'';'||chr(10)||
'    :P21505_NUMBER_LABEL := ''Reference Number'';'||chr(10)||
''||chr(10)||
'  ELSIF (:P21505_OBJ_TYPE_CODE=''ACT.DOCUMENT_REVIEW'') THEN'||chr(10)||
''||chr(10)||
'       :P21505_TYPE_LABEL := ''Document Type'';'||chr(10)||
'       :P21505_TYPE_LOV := ''- Select Document Type -;%null%,'' || osi_reference.get_lov(''DOCREV_DOCTYPE'');'||chr(10)||
'       :P21505_RESULT_LABEL := ''Document Review Result'';'||chr(10)||
'       :P21505_NUMBER_LABE';

p:=p||'L := ''Document Number'';'||chr(10)||
''||chr(10)||
'  END IF;'||chr(10)||
''||chr(10)||
'  if :P21505_RESULT is null then'||chr(10)||
''||chr(10)||
'    :P21505_RESULT_LOV:=''- Select -;%null%,'';'||chr(10)||
'    for a in (select DESCRIPTION d, CODE r from T_OSI_A_RC_DR_RESULTS order by 1)'||chr(10)||
'    loop'||chr(10)||
'        :P21505_RESULT_LOV := :P21505_RESULT_LOV || replace(a.d, '', '', '' / '') || '';'' || a.r || '',''; '||chr(10)||
'    end loop;'||chr(10)||
''||chr(10)||
'  end if;'||chr(10)||
''||chr(10)||
'end;';

wwv_flow_api.create_page_process(
  p_id     => 92558037877657803 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id => 21505,
  p_process_sequence=> 10,
  p_process_point=> 'BEFORE_HEADER',
  p_process_type=> 'PLSQL',
  p_process_name=> 'Setup',
  p_process_sql_clob => p, 
  p_process_error_message=> '',
  p_process_when=>'p21505_obj',
  p_process_when_type=>'ITEM_IS_NULL',
  p_process_success_message=> '',
  p_process_is_stateful_y_n=>'N',
  p_process_comment=>'');
end;
null;
 
end;
/

 
begin
 
---------------------------------------
-- ...updatable report columns for page 21505
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




































alter table t_osi_report_distribution_type add "default" varchar2(1) default 'N';
alter table t_osi_report_distribution_type add WITHEXHIBITS varchar2(1) default 'N';

INSERT INTO T_OSI_REPORT_DISTRIBUTION_TYPE ( SID, REPORT_TYPE, DISTRIBUTION, DEFAULT_AMOUNT, SEQ, CREATE_BY, CREATE_ON, MODIFY_BY, MODIFY_ON, "default", WITHEXHIBITS ) VALUES ( '333194EA', NULL, 'Action Authority', 1, 1, 'timothy.ward',  TO_Date( '09/11/2012 07:22:39 AM', 'MM/DD/YYYY HH:MI:SS AM'), 'timothy.ward',  TO_Date( '09/11/2012 08:49:03 AM', 'MM/DD/YYYY HH:MI:SS AM'), 'Y', 'N'); 
INSERT INTO T_OSI_REPORT_DISTRIBUTION_TYPE ( SID, REPORT_TYPE, DISTRIBUTION, DEFAULT_AMOUNT, SEQ, CREATE_BY, CREATE_ON, MODIFY_BY, MODIFY_ON, "default", WITHEXHIBITS ) VALUES ( '333194EB', NULL, 'Legal', 1, 2, 'timothy.ward',  TO_Date( '09/11/2012 07:22:42 AM', 'MM/DD/YYYY HH:MI:SS AM'), 'timothy.ward',  TO_Date( '09/11/2012 08:49:03 AM', 'MM/DD/YYYY HH:MI:SS AM'), 'Y', 'N'); 
INSERT INTO T_OSI_REPORT_DISTRIBUTION_TYPE ( SID, REPORT_TYPE, DISTRIBUTION, DEFAULT_AMOUNT, SEQ, CREATE_BY, CREATE_ON, MODIFY_BY, MODIFY_ON, "default", WITHEXHIBITS ) VALUES ( '333194EC', NULL, 'File', 1, 3, 'timothy.ward',  TO_Date( '09/11/2012 07:23:09 AM', 'MM/DD/YYYY HH:MI:SS AM'), 'timothy.ward',  TO_Date( '09/11/2012 08:49:20 AM', 'MM/DD/YYYY HH:MI:SS AM'), 'Y', 'Y'); 
COMMIT;COMMIT;

alter table t_osi_report_distribution add WITHEXHIBITS varchar2(1) default 'N';


DROP INDEX UK_OSI_REPORT_DIST_TYPE;
CREATE UNIQUE INDEX WEBI2MS.UK_OSI_REPORT_DIST_TYPE ON WEBI2MS.T_OSI_REPORT_DISTRIBUTION_TYPE (REPORT_TYPE, DISTRIBUTION, WITHEXHIBITS);
ALTER TABLE T_OSI_REPORT_DISTRIBUTION_TYPE MODIFY DEFAULT_AMOUNT NUMBER DEFAULT 1;


ALTER TABLE T_OSI_REPORT_DISTRIBUTION_TYPE ADD CREATE_BY_SID VARCHAR2(20);

ALTER TABLE WEBI2MS.T_OSI_REPORT_DISTRIBUTION_TYPE ADD 
CONSTRAINT FK_OSI_RPTDISTYP_PERSONNEL
 FOREIGN KEY (CREATE_BY_SID)
 REFERENCES WEBI2MS.T_CORE_PERSONNEL (SID) ENABLE
 VALIDATE;


DROP INDEX UK_OSI_REPORT_DISTRIBUTION;
CREATE UNIQUE INDEX WEBI2MS.UK_OSI_REPORT_DISTRIBUTION ON WEBI2MS.T_OSI_REPORT_DISTRIBUTION (SPEC, DISTRIBUTION, WITHEXHIBITS);




------------------------------------------------------------
--- Default Leadership Approved for Consultations to 'Y' ---
------------------------------------------------------------
update t_osi_activity set leadership_approved='Y'
 where sid in (select sid from v_osi_activity_summary where object_type_code like 'ACT.CONSULTATION%'); 
commit;



--------------------------------------------------------------------------------------
--- VIA phone conversation with Jon Sivert, remove SUBJECT from the result strings ---
---   this was instead of a SUBJECT/VICTIM/WITNESS/INCIDENTAL drop down.........   ---
--------------------------------------------------------------------------------------
UPDATE T_OSI_A_RC_DR_RESULTS SET DEFAULT_NARRATIVE='A review of ~RECORD_TYPE~ records disclosed there was no record on file.' WHERE CODE='NOREC';
UPDATE T_OSI_A_RC_DR_RESULTS SET DEFAULT_NARRATIVE='A review of ~RECORD_TYPE~ records disclosed nothing pertinent to this investigation.' WHERE CODE='NODEROG'; 
UPDATE T_OSI_A_RC_DR_RESULTS SET DEFAULT_NARRATIVE='A review of ~RECORD_TYPE~ records was conducted.  The review disclosed [[[[PERTINENT INFORMATION HERE]]]].' WHERE CODE='DEROGATORY'; 
COMMIT;

