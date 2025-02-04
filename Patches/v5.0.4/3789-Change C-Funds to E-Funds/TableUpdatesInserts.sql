update t_core_obj_type set description=replace(description,'CFunds','EFunds') where description like 'CFunds%';
commit;

update t_cfunds_menu_items set name=replace(name,'C-Funds','E-Funds') where name like '%C-Funds%';
commit;

update t_cfunds_menu_items set name=replace(name,'CFMS','EFMS') where name like '%CFMS%';
commit;


update t_cfunds_paragraphs set content=replace(content,'C-funds','E-funds') where content like '%C-funds%';
commit;







INSERT INTO T_HTML_TEMPLATE ( NAME, DT, FLOWERBOX, MODIFY_BY, MODIFY_ON ) VALUES ( 'cfunds_expense_form',  TO_Date( '08/16/2011 06:51:54 AM', 'MM/DD/YYYY HH:MI:SS AM'), '10-06-2004 AES Added ''For Official Use Only'' header and footer. ', 'HQSBUXIID0726A',  TO_Date( '08/16/2011 06:51:55 AM', 'MM/DD/YYYY HH:MI:SS AM')); 
COMMIT;

INSERT INTO T_HTML_TEMPLATE ( NAME, DT, FLOWERBOX, MODIFY_BY, MODIFY_ON ) VALUES ( 'cfunds_page_background_begin',  TO_Date( '08/16/2011 07:29:50 AM', 'MM/DD/YYYY HH:MI:SS AM'), '26-Jul-2007 Try to disable caching to keep the figures on screen up to date. ', 'HQSBUXIID0726A',  TO_Date( '08/16/2011 07:29:51 AM', 'MM/DD/YYYY HH:MI:SS AM')); 
COMMIT;

INSERT INTO T_HTML_TEMPLATE ( NAME, DT, FLOWERBOX, MODIFY_BY, MODIFY_ON ) VALUES ( 'cfunds_expense_rejection_comments',  TO_Date( '08/16/2011 07:42:17 AM', 'MM/DD/YYYY HH:MI:SS AM'), NULL, 'HQSBUXIID0726A',  TO_Date( '08/16/2011 07:42:17 AM', 'MM/DD/YYYY HH:MI:SS AM')); 
COMMIT;

INSERT INTO T_HTML_TEMPLATE ( NAME, DT, FLOWERBOX, MODIFY_BY, MODIFY_ON ) VALUES ( 'cfunds_expense_repayment_form',  TO_Date( '08/16/2011 07:45:23 AM', 'MM/DD/YYYY HH:MI:SS AM'), NULL, 'HQSBUXIID0726A',  TO_Date( '08/16/2011 07:45:25 AM', 'MM/DD/YYYY HH:MI:SS AM')); 
COMMIT;

INSERT INTO T_HTML_TEMPLATE ( NAME, DT, FLOWERBOX, MODIFY_BY, MODIFY_ON ) VALUES ( 
'cfunds_navigation',  TO_Date( '08/16/2011 07:54:05 AM', 'MM/DD/YYYY HH:MI:SS AM'), '17-Aug-2004 C.Johnson   Added fiscal year and unit controls to allow the back button to keep same context.
                        Updated this page to reflect the current menu links and structure of CFMS.
                        Modified text so comments are different color to make it easier to read. ', 'HQSBUXIID0726A',  TO_Date( '08/16/2011 07:54:06 AM', 'MM/DD/YYYY HH:MI:SS AM')); 
COMMIT;


INSERT INTO T_HTML_TEMPLATE ( NAME, DT, FLOWERBOX, MODIFY_BY, MODIFY_ON ) VALUES ( 
'cfunds_payment_listing_form',  TO_Date( '08/16/2011 07:56:02 AM', 'MM/DD/YYYY HH:MI:SS AM'), '02/17/2009 JDB ADDED FPD PEC TO FORM
04/21/2010 RND Updated Web I2MS with new PEC code template', 'HQSBUXIID0726A',  TO_Date( '08/16/2011 07:56:51 AM', 'MM/DD/YYYY HH:MI:SS AM')); 
COMMIT;



INSERT INTO T_HTML_TEMPLATE ( NAME, DT, FLOWERBOX, MODIFY_BY, MODIFY_ON ) VALUES ( 
'cfunds_payment_listing_eft_section',  TO_Date( '08/16/2011 07:59:34 AM', 'MM/DD/YYYY HH:MI:SS AM'), '02/17/2009 JDB ADDED FPD PEC TO FORM
04/21/2010 RND Updated Web I2MS with new PEC code template', 'HQSBUXIID0726A',  TO_Date( '08/16/2011 07:59:35 AM', 'MM/DD/YYYY HH:MI:SS AM')); 
COMMIT;


INSERT INTO T_HTML_TEMPLATE ( NAME, DT, FLOWERBOX, MODIFY_BY, MODIFY_ON ) VALUES ( 
'cfunds_unit_list',  TO_Date( '08/16/2011 08:06:22 AM', 'MM/DD/YYYY HH:MI:SS AM'), '04-Aug-2004 C.Johnson   Modified table headers: now use the <th> tag, modified the stylesheet to 
                        put the background color as gray, and removed background color from here. ', 'HQSBUXIID0726A',  TO_Date( '08/16/2011 08:06:23 AM', 'MM/DD/YYYY HH:MI:SS AM')); 
COMMIT;





update t_osi_tab set tab_label='EFunds' where tab_label='CFunds';
commit;
