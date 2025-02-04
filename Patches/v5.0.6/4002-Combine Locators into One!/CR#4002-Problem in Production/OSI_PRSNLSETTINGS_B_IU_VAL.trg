CREATE OR REPLACE TRIGGER WEBI2MS.OSI_PRSNLSETTINGS_B_IU_VAL
BEFORE INSERT OR UPDATE
ON WEBI2MS.T_OSI_PERSONNEL_SETTINGS 
REFERENCING NEW AS NEW OLD AS OLD
FOR EACH ROW
begin
    if :new.setting_value = 'OSI'  then
       :new.setting_value := 'RECENT';
    end if;
    if :new.setting_value != 'RECENT' and :new.setting_name = 'P301_FILTER.PARTICIPANT' then
       :new.setting_value := 'RECENT';
    end if;
    if :new.setting_value like '%000' then
       :new.setting_value := '200';
    end if;
end;
