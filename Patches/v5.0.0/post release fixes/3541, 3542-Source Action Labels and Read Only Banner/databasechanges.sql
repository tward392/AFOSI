UPDATE T_OSI_STATUS_CHANGE SET TRANSITION='Terminate Source' WHERE BUTTON_LABEL='Terminate Source' AND TRANSITION='Reject Approval';
commit;

UPDATE T_OSI_STATUS_CHANGE SET TRANSITION='Reject Approval' WHERE BUTTON_LABEL='Reject Approval' AND TRANSITION='Return for Corrections';
commit;