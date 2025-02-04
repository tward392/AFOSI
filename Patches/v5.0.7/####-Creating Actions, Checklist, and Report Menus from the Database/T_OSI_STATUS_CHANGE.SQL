ALTER TABLE T_OSI_STATUS_CHANGE ADD IMAGE VARCHAR2(50);

ALTER TABLE T_OSI_STATUS_CHANGE ADD CHECKLIST_IMAGE VARCHAR2(50);


update t_osi_status_change set image='transfer16.gif' where transition like '%Transfer%';
commit;

update t_osi_status_change set image='adminclosure16.gif' where transition='Admin Closure';
commit;

update t_osi_status_change set image='approveclosure16.gif' where transition='Approve Closure';
commit;

update t_osi_status_change set image='approvefile16.gif' where transition like 'Approve %' and transition!='Approve Closure';
commit;

update t_osi_status_change set image='archive16.gif' where transition='Archive';
commit;

update t_osi_status_change set image='handclipboardcheckmark16.gif' where transition in ('Assign Auxiliary Unit');
commit;

update t_osi_status_change set image='cloneactivity16.gif' where transition in ('Clone Activity');
commit;

update t_osi_status_change set image='closefile16.gif' where transition like 'Close%' and transition!='Close Activity';
commit;

update t_osi_status_change set image='closeactivity16.gif' where transition='Close Activity';
commit;

update t_osi_status_change set image='handclipboardcheckmark16.gif' where transition='Complete Activity';
commit;

update t_osi_status_change set image='submitforapproveclose16.gif' where upper(transition) like '%SUBMIT FOR CLOSURE%' or upper(transition) like '%SUBMIT FOR APPROVAL%';
commit;

update t_osi_status_change set image='updateparticipantlinks16.gif' where transition='Update Participant Links';
commit;

update t_osi_status_change set image='unarchive16.gif' where transition='Unarchive';
commit;

update t_osi_status_change set image='receivedatarchive16.gif' where upper(transition) like '%RECEIVE%ARCHIVE%';
commit;

update t_osi_status_change set image='sendtoarchive16.gif' where upper(transition) like '%SEND%ARCHIVE%' OR upper(transition) like '%SUBMIT%ARCHIVE%';
commit;

update t_osi_status_change set image='reopenfile16.gif' where transition in ('Reopen','Reopen File','Reopen PSO');
commit;

update t_osi_status_change set image='rejectclosure16.gif' where transition in ('Reject Closure');
commit;

update t_osi_status_change set image='rejectapproval16.gif' where transition in ('Reject Approval');
commit;

update t_osi_status_change set image='Case.gif' where transition in ('Create Case');
commit;

update t_osi_status_change set image='recallactivity16.gif' where transition in ('Recall Activity');
update t_osi_status_change set image='rejectactivity16.gif' where transition in ('Reject Activity');
update t_osi_status_change set image='reopenactivity16.gif' where transition in ('Reopen Activity');
commit;

update t_osi_status_change set image='confirm16.gif' where transition in ('Confirm');
update t_osi_status_change set image='unconfirm16.gif' where transition in ('Unconfirm');
commit;

update t_osi_status_change set image='recallsubmission16.gif' where upper(transition) in ('RECALL SUBMIT FOR APPROVAL');
commit;

--- Source ---
update t_osi_status_change set image='sourceapprove16.gif' where upper(transition) in ('APPROVE SOURCE');
update t_osi_status_change set image='sourcerequestactivation16.gif' where upper(transition) in ('REQUEST ACTIVATION');
update t_osi_status_change set image='sourcerejecttermination16.gif' where upper(transition) in ('REJECT TERMINATION');
update t_osi_status_change set image='sourcemaintenancecomplete16.gif' where upper(transition) in ('MAINTENANCE COMPLETE');
update t_osi_status_change set image='sourcesubmitformaintenance16.gif' where upper(transition) in ('SUBMIT FOR MAINTENANCE');
update t_osi_status_change set image='recallsubmission16.gif' where upper(transition) in ('RECALL SUBMIT FOR BURN');
update t_osi_status_change set image='sourcesubmitforburn16.gif' where upper(transition) in ('SUBMIT FOR BURN');
update t_osi_status_change set image='recallsubmission16.gif' where upper(transition) in ('RECALL SUBMIT FOR TERMINATION');
update t_osi_status_change set image='sourcesubmitfortermination16.gif' where upper(transition) in ('SUBMIT FOR TERMINATION');
update t_osi_status_change set image='sourceapprovetermination16.gif' where upper(transition) in ('TERMINATE SOURCE');
update t_osi_status_change set image='transfer16.gif' where transition='Migrate to Existing Source';
commit;

--- AAPP ---
update t_osi_status_change set image='receivedatarchive16.gif' where upper(transition) like '%RETRIEVE%ARCHIVE%';
update t_osi_status_change set image='sourceapprovetermination16.gif' where upper(transition)='WITHDRAW';
update t_osi_status_change set image='sourcerejecttermination16.gif' where upper(transition)='TERMINATE';
update t_osi_status_change set image='rejectapproval16.gif' where upper(transition)='REGION RETURN';
update t_osi_status_change set image='approvefile16.gif' where upper(transition)='FORWARD TO REGION';
update t_osi_status_change set image='rejectapproval16.gif' where upper(transition)='UNIT RETURN';
update t_osi_status_change set image='approvefile16.gif' where upper(transition)='SUBMIT FOR UNIT REVIEW';
update t_osi_status_change set image='approvefile16.gif' where upper(transition)='DOA APPROVED';
update t_osi_status_change set image='rejectapproval16.gif' where upper(transition)='DOA REJECT';
update t_osi_status_change set image='approvefile16.gif' where upper(transition)='SUBMIT FOR DOA (AGENT)';
update t_osi_status_change set image='approvefile16.gif' where upper(transition)='SUBMIT FOR REJECTION';
update t_osi_status_change set image='approvefile16.gif' where upper(transition)='SUBMIT FOR DET APPROVAL';
update t_osi_status_change set image='submitforapproveclose16.gif' where upper(transition)='PRIOR AFOSI';
update t_osi_status_change set image='rejectapproval16.gif' where upper(transition)='DP RETURN';
update t_osi_status_change set image='rejectapproval16.gif' where upper(transition)='DET RETURN';
update t_osi_status_change set image='rejectapproval16.gif' where upper(transition)='RETURN TO AGENT';
update t_osi_status_change set image='approvefile16.gif' where upper(transition)='DET APPROVAL';
update t_osi_status_change set image='recallsubmission16.gif' where upper(transition)='RECALL';
update t_osi_status_change set image='selectedforafosiduty16.gif' where upper(transition)='SELECTED FOR AFOSI DUTY';
update t_osi_status_change set image='notselectedforafosiduty16.gif' where upper(transition)='NOT SELECTED FOR AFOSI DUTY';
commit;

--- POLY ---
update t_osi_status_change set image='adminclosure16.gif' where upper(transition)='SUBMIT FOR ADMIN CLOSURE';
update t_osi_status_change set image='recallsubmission16.gif' where upper(transition)='RECALL SUBMIT FOR HQ CLOSURE' or upper(transition)='RECALL SUBMIT FOR RPO REVIEW';
update t_osi_status_change set image='rejectclosure16.gif' where upper(transition)='REJECT BY HQ';
update t_osi_status_change set image='submitforapproveclose16.gif' where upper(transition)='SUBMIT FOR HQ REVIEW' or upper(transition)='SUBMIT FOR RPO REVIEW' or upper(transition)='SUBMIT FOR HQ CLOSURE';
commit;

--- PSO ---
update t_osi_status_change set image='rejectapproval16.gif' where upper(transition)='REJECT PSO';
commit;

--- SUSPICIOUS ACTIVITY REPORT ---
update t_osi_status_change set image='createecho16.gif' where upper(transition)='CREATE ECHO';
update t_osi_status_change set image='publishreport16.gif' where upper(transition)='PUBLISH REPORT';
update t_osi_status_change set image='submitforreview16.gif' where upper(transition)='SUBMIT FOR REVIEW';
update t_osi_status_change set image='submittopublish16.gif' where upper(transition)='SUBMIT TO PUBLISH';
commit;

--- PMM ---
update t_osi_status_change set image='fixloginid16.gif' where transition='Fix Login ID';
--update t_osi_status_change set image='lockfile16.gif' where transition='';
update t_osi_status_change set image='resetpassword16.gif' where transition='Reset Password';
update t_osi_status_change set image='suspendpersonnelfile16.gif' where transition='Suspend User Account';
update t_osi_status_change set image='reopen16.gif' where transition='Re-Open User Account';
commit;


update t_osi_status_change set image='SFS.gif' where transition='Create DCII Indexing File';
commit;
