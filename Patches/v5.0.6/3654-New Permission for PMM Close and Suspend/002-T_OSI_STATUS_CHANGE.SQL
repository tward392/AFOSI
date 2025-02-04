update t_osi_status_change set auth_action='33318LTX' where button_label='Close User Account';
update t_osi_status_change set auth_action='33318LTY' where button_label='Suspend User Account';
COMMIT;