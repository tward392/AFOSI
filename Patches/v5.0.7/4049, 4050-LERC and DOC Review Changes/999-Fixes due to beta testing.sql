-------------------------------------
-------------------------------------
-------------------------------------
---- FIXES found by Beta Testing ----
-------------------------------------
-------------------------------------
-------------------------------------

----------------------------------------------------------
--- Change done to conducted per J Stivert's Direction ---
----------------------------------------------------------
update t_osi_a_rc_dr_results 
  set default_narrative='A review of ~RECORD_TYPE~ records identifiable with SUBJECT was conducted.  The review disclosed SUBJECT [[[[Derogatory Information HERE]]]].'
   where code='DEROGATORY';
commit;


update t_osi_a_rc_dr_results 
  set default_narrative='A review of ~RECORD_TYPE~ records identifiable with SUBJECT disclosed there was no record on file.'
   where code='NOREC';
commit;

update t_osi_a_rc_dr_results 
  set default_narrative='A review of ~RECORD_TYPE~ records identifiable with SUBJECT disclosed nothing pertinent to this investigation.'
   where code='NODEROG';
commit;


update t_osi_reference
  set description='Mental Health Records'
   where code='MHR' and usage='DOCREV_DOCTYPE';
commit;  