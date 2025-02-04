UPDATE T_CORE_CONFIG SET SETTING='This investigation was initiated on ~ACTIVITY_DATE^DD MON YY~, based upon information from ~NOTIFIED~.' WHERE CODE='OSI.INV_DEFAULT_BACKGROUND';
COMMIT;