CREATE OR REPLACE FUNCTION "SAVE_REPORT_ROWS_NUMBER" (pPageID in varchar2, pNumber in varchar2, pUserSID in varchar2) return varchar2 is
  
  v_return varchar2(4000);
    
begin
     v_return := osi_personnel.set_user_setting(pUserSID, 'P' || pPageID || '_REPORT_ROWS', pNumber);     
     return v_return;
     
end SAVE_REPORT_ROWS_NUMBER;
/

CREATE OR REPLACE FUNCTION "GET_REPORT_ROWS_NUMBER" (pPageID in varchar2, pUserSID in varchar2) return varchar2 is
  
  v_return varchar2(4000);
    
begin
     v_return := osi_personnel.get_user_setting(pUserSID, 'P' || pPageID || '_REPORT_ROWS', '5');     
     return v_return;
     
end GET_REPORT_ROWS_NUMBER;
/
