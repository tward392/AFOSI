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



