CREATE OR REPLACE TRIGGER "WEBI2MS"."OSI_PRSNLSETTINGS_B_IU_VAL" 
    before insert or update on t_osi_personnel_settings for each row
begin
    if :new.setting_value = 'OSI'  then
       :new.setting_value := 'RECENT';
    end if;
    if :new.setting_value like '%000' then
       :new.setting_value := '200';
    end if;
end;
/