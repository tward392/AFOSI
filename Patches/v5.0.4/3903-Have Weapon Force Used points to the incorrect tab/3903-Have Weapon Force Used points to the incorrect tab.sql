UPDATE T_OSI_CHECKLIST_ITEM_TYPE SET DETAILS='Must have Weapon Force Used for the selected offenses.' || chr(10) || chr(13) ||
' Weapon Force Used cannot be reported for Provoking Speech/Gesture (117---) offense.' || chr(10) || chr(13) ||
' If Suicide (0000A6) offense, Type Weapon Force Used is required.' || chr(10) || chr(13) ||
' If a homicide or simple assault offense is selected, the Type Weapon Force Used must be selected.' || chr(10) || chr(13) ||
' For Homicide offenses, Type Weapon Force Used cannot be None.' || chr(10) || chr(13) ||
' For simple assault offenses, Type Weapon Force Used must be Personal Weapons, Other, Unknown, or None.' || chr(10) || chr(13) ||
' For simple assault offenses, the second Type Weapon Force Used must be either Personal Weapons or Other.' || chr(10) || chr(13) ||
'Instructions for adding/verifying information:' || chr(10) || chr(13) ||
'1. From the Details->Specification sub tab, select the Offense/Incident sub tab.' || chr(10) || chr(13) ||
'2. Verify/Select the Type Weapon Force Used.' || chr(10) || chr(13)
where title='Have Weapon Force Used';
commit;
