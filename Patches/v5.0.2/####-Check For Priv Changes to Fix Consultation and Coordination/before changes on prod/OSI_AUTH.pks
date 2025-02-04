CREATE OR REPLACE package WEBI2MS.osi_auth as
/******************************************************************************
   Name:     osi_auth
   Purpose:  Provides Functionality For Authorization.

   Revisions:
    Date        Author          Description
    ----------  --------------  ------------------------------------
    29-Oct-2009 T.McGuffin      Created Package
    17-Dec-2009 R.Dibble        Added get_role_description, get_role_lov
    18-Dec-2009 R.Dibble        Added get_role_complete_description,validate_role_creation
    04-Jan-2010 R.Dibble        Added get_perm_complete_description, get_perm_description, get_perm_lov
    06-Jan-2010 R.Dibble        Added user_can_grant_priv
    07-Jan-2010 R.Dibble        Added change_permission
    12-Jan-2010 R.Dibble        Added user_can_grant_role
    18-Jan-2010 R.Dibble        Added change_role
    01-Oct-2010 R.Dibble        Added get_priv_description
    13-Dec-2010 R.Dibble        Added p_supress_logging to check_access and check_for_priv.  Defaults to FALSE.
    08-Feb-2011 Tim Ward        CR#3536 - Lead Agent Name not found in check_access.
                                 Added a boolean input to check_access (p_get_message).
******************************************************************************/
--###################################################################################################
--#                  Check Access Algorithm - Documented by Richard N. Dibble                       #
--###################################################################################################
--#  Privilege (or Combo)     #  User Ability                                                       #
--###################################################################################################
--#           .OVR            #  This privilege is a RESTRICTION OVERRIDE.                          #
--#                           #                                                                     #
--#                           #  Ex. If a user has all other needed access to an object, but does   #
--#                           #  NOT meet the proper restriction, they can still access the         #
--#                           #  object.  So, if an object is set to "Unit" or "Unit and Assigned   #
--#                           #  Personnel" restrictions, and they are neither, they can access     #
--#                           #  this object if all other requirements are met (.ACA or .ACC, see   #
--#       "OVERRIDE"          #  below).                                                            #
--###################################################################################################
--#           .ACA            #  This is the ACCESS ALL PRIVILEGE.                                  #
--#                           #                                                                     #
--#                           #  WHEN NO RESTRICTION EXISTS, a user can access an object in         #
--#                           #  another unit.  So, if an object is set to "None" restriction, they #
--#                           #  can access an object either WITHIN or OUTSIDE OF THEIR UNIT.       #
--#                           #                                                                     #
--#                           #  WHEN A RESTRICTION EXISTS, a user would be able to access an       #
--#                           #  object only if they meet the restriction, whether or not they are  #
--#                           #  in the objects unit - a user may be assigned to an object, but not #
--#                           #  in the objects unit (this is very common as agents from unit A     #
--#                           #  will often get assigned to objects from unit B).                   #
--#                           #                                                                     #
--#                           #  - If the restriction is "Unit and Assigned Personnel", they would  #
--#                           #  be able to open the object when either in the objects unit, or if  #
--#                           #  they are assigned to the object.                                   #
--#                           #                                                                     #
--#                           #  - If the restriction is "Unit", they would be able to open the     #
--#                           #  object when they are in the objects unit even if they are not      #
--#          "ACCESS"         #  assigned.                                                          #
--###################################################################################################
--#           .ACC            #  This is the ACCESS PRIVILEGE.                                      #
--#                           #                                                                     #
--#                           #  WHEN NO RESTRICTION EXISTS, a user can access an object in their   #
--#                           #  unit.  This privilege deals with the notation "Within the          #
--#                           #  specified chain of command".  This means that if this privilege    #
--#                           #  is granted to the user for "All OSI Units" or "Unit and            #
--#                           #  Subordinate Units", the user will in fact be able to access an     #
--#                           #  object that is in either THEIR or in a SUBORDINATE UNIT.           #
--#                           #  **See details for this below.                                      #
--#                           #                                                                     #
--#                           #  WHEN A RESTRICTION EXISTS, the user would be able to access an     #
--#                           #  object as stated in the .ACA section - "When a restriction         #
--#        "ACCESS_UNT"       #  exists" above.                                                     #
--###################################################################################################
--#           .OVR            #  WHEN A RESTRICTION EXISTS, this combination will allow a user to   #
--#            and            #  access any object in THEIR UNIT, REGARDLESS of RESTRICTION.  Most  #
--#           .ACC            #  likely used for Unit Leadership.                                   #
--###################################################################################################
--#           .OVR            #  WHEN A RESTRICTION EXISTS, this combination will a user to access  #
--#            and            #  any object REGARDLESS of RESTRICTION or UNIT AFFILIATION.  Most    #
--#           .ACA            #  likely used for Administrative or HQ leadership.                   #
--###################################################################################################
--# FURTHER NOTES:                                                                                  #
--# **This functionality algorithm is slightly different from Legacy to Web:                        #
--#                                                                                                 #
--#  LEGACY: The CheckForPriv() function would start at the objects unit, and travel upwards        #
--#          through the chain of command (looking at each subsequent units parent) until it found  #
--#          a match for the given privilege for the given personnel.                               #
--#                                                                                                 #
--#  WEB: In the web version, there is a single cursor loop (actually 3 for different checks) in    #
--#       the CheckForPriv() that utilizes the osi_unit.is_subordinate(objects_unit, users_unit)    #
--#       function to determine if the user has the privilege.                                      #
--#                                                                                                 #
--#  BOTH: Privs are checked by looking in the users roles, then their personnel privs, then the    #
--#        proxy table.                                                                             #
--###################################################################################################

    /*
        Determines if p_Personnel may use p_Priv in p_Unit, returning Y or N as a result

        Parameters:
            p_action:    The action to test (i.e. CREATE).
            p_obj_type:  The object type sid to test.
            p_Personnel: The personnel to test.  If null, will use context to get personnel info
            p_Unit:      The unit in which the priv is to be used.  If null, will get unit info from
                         context personnel.
    */
    function check_for_priv(
        p_action            in   varchar2,
        p_obj_type          in   varchar2,
        p_personnel         in   varchar2 := null,
        p_unit              in   varchar2 := null,
        p_supress_logging   in   boolean := false)
        return varchar2;

    function check_access(
        p_obj               in   varchar2,
        p_personnel         in   varchar2 := null,
        p_supress_logging   in   boolean := false, 
        p_get_message in boolean := false)
        return varchar2;

    /* Given a Role SID, I will return you the Description */
    function get_role_description(p_role_sid in varchar2)
        return varchar2;

    /* Given a Role SID, I will return you the Complete Description */
    function get_role_complete_description(p_role_sid in varchar2)
        return varchar2;

    /* Returns an LOV of currently usable roles */
    function get_role_lov(p_current_role in varchar2)
        return varchar2;

    /* Given a Permission SID, I will return you the Complete Description */
    function get_perm_complete_description(p_perm in varchar2)
        return varchar2;

    /* Given a Permission SID, I will return you the Basic Description */
    function get_perm_description(p_perm in varchar2)
        return varchar2;

    /* Returns an LOV of currently usable permissions */
    function get_perm_lov
        return varchar2;

    /* Used to validate a role creation */
    function validate_role_creation(
        p_assign_role   in   varchar2,
        p_unit          in   varchar2,
        p_personnel     in   varchar2)
        return varchar2;

    /* Returns 'Y' if the currently logged on user can grant a specific privilege */
    function user_can_grant_priv(
        p_unit        in   varchar2,
        p_incsubs     in   varchar2,
        p_priv        in   varchar2,
        p_personnel   in   varchar2 := null)
        return varchar2;

    /* Returns 'Y' if the currently logged on user can grant a specific role */
    function user_can_grant_role(
        p_unit        in   varchar2,
        p_incsubs     in   varchar2,
        p_role        in   varchar2,
        p_personnel   in   varchar2 := null)
        return varchar2;

    /* Used when a user "Edit's" a permission */
    /* Returns the SID of the new permission for SEL_PERM purposes */
    /* Note: This function actually ends the current permission, then creates another with the new specs. */
    function change_permission(
        p_current_perm_sid   in   varchar2,
        p_perm               in   varchar2,
        p_unit               in   varchar2,
        p_start_date         in   date,
        p_end_date           in   date,
        p_enabled            in   varchar2,
        p_grantable          in   varchar2,
        p_include_subords    in   varchar2,
        p_allow_or_deny      in   varchar2)
        return varchar2;

    /* Used when a user "Edit's" a role */
    /* Returns the SID of the new role for SEL_ROLE purposes */
    /* Note: This function actually ends the current role, then creates another with the new specs. */
    function change_role(
        p_current_role_sid   in   varchar2,
        p_role               in   varchar2,
        p_unit               in   varchar2,
        p_start_date         in   date,
        p_end_date           in   date,
        p_enabled            in   varchar2,
        p_grantable          in   varchar2,
        p_include_subords    in   varchar2)
        return varchar2;

    /* Used to egt the free text representation of a permission */
    function get_priv_description(p_priv in varchar2)
        return varchar2;
--DEBUG ONLY
 --function priv_is_common_grant(p_priv in varchar2)
     --return varchar2;
end osi_auth; 
/

