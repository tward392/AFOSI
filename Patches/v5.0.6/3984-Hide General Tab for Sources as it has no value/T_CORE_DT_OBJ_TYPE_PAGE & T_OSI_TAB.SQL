----------------------------------------------------------------------------------------------
--- Changes FILE.SOURCE to open the History Tab (10000) instead of the General Tab (10250) ---
----------------------------------------------------------------------------------------------
UPDATE T_CORE_DT_OBJ_TYPE_PAGE SET PAGE_NUM='10000' WHERE PAGE_NUM='10250' AND OBJ_TYPE='22200000LVZ';
COMMIT;

INSERT INTO T_OSI_TAB ( SID, OBJ_TYPE, TAB_LEVEL, PARENT_TAB, SEQ, TAB_LABEL, PAGE_NUM, IS_DEFAULT, TAB_PARAMS, CREATE_BY, CREATE_ON, MODIFY_BY, MODIFY_ON, ACTIVE, AUTH_ACTION, OVERRIDE ) VALUES ( '33318DR2', '22200000LVZ', 1, NULL, 10, 'Summary', NULL, 'N', NULL, 'timothy.ward',  TO_Date( '03/07/2012 09:01:05 AM', 'MM/DD/YYYY HH:MI:SS AM'), 'timothy.ward',  TO_Date( '03/07/2012 09:02:46 AM', 'MM/DD/YYYY HH:MI:SS AM'), 'Y', NULL, 'Y'); 
INSERT INTO T_OSI_TAB ( SID, OBJ_TYPE, TAB_LEVEL, PARENT_TAB, SEQ, TAB_LABEL, PAGE_NUM, IS_DEFAULT, TAB_PARAMS, CREATE_BY, CREATE_ON, MODIFY_BY, MODIFY_ON, ACTIVE, AUTH_ACTION, OVERRIDE ) VALUES ( '33318DR1', '22200000LVZ', 2, '33318DR2', 1, 'History', 10000, 'N', NULL, 'timothy.ward',  TO_Date( '03/07/2012 08:52:19 AM', 'MM/DD/YYYY HH:MI:SS AM'), 'timothy.ward',  TO_Date( '03/07/2012 09:01:40 AM', 'MM/DD/YYYY HH:MI:SS AM'), 'N', NULL, 'Y'); 
COMMIT;