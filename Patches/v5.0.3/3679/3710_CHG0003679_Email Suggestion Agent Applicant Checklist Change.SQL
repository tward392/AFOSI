update T_OSI_CHECKLIST_ITEM_TYPE_MAP set 
    COMPLETION_REQUIRED = 1
    where CHECKLIST_ITEM_TYPE_SID = (select SID from T_OSI_CHECKLIST_ITEM_TYPE
                                     where TITLE = 'All activities must be closed.')
    and STATUS_CHANGE_SID = (select SID from T_OSI_STATUS_CHANGE
                                    where CHECKLIST_BUTTON_LABEL = 'Final Unit Approval Checklist');
   
commit;
