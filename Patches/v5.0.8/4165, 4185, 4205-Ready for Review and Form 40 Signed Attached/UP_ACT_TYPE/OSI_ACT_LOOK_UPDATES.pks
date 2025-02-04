CREATE OR REPLACE PACKAGE WEBI2MS.OSI_ACT_LOOK_UPDATES AS
/******************************************************************************
   NAME:       OSI_ACT_LOOK_UPDATES
   PURPOSE:

   REVISIONS:
   Ver        Date        Author           Description
   ---------  ----------  ---------------  ------------------------------------
   1.0        12/28/2011  Administrator    1. Created this package.
              12/29/2011  wcc              Procedures to update the t_osi_activity_lookup table.  
                                            These are called from a schedule job every 2 minutes.
******************************************************************************/

   PROCEDURE UP_TITLE;
   PROCEDURE UP_CONUNIT;
   PROCEDURE UP_LEAD;
   PROCEDURE UP_NOLEAD;
   PROCEDURE UP_LEADAGT;
   PROCEDURE UP_COMPDATE;
   PROCEDURE UP_APPROVED;
   PROCEDURE DEL_ACT;
   PROCEDURE ADD_ACT;
   PROCEDURE UP_ACT_TYPE;
   
END OSI_ACT_LOOK_UPDATES;
/

