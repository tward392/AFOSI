CREATE OR REPLACE VIEW V_OSI_F_AAPP_FILE
(SID, START_DATE, CATEGORY_SID, CATEGORY_CODE, CATEGORY_DESC, 
 SYNOPSIS)
AS 
select ofaf.sid, ofaf.start_date, ofaf.sid as "CATEGORY_SID", oref.code as "CATEGORY_CODE",
           oref.description as "CATEGORY_DESC", ofaf.synopsis
      from t_osi_f_aapp_file ofaf, t_osi_reference oref
     where ofaf.category = oref.sid(+)
/

