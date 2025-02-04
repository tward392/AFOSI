CREATE OR REPLACE TRIGGER WEBI2MS.OSI_PARTICINVLV_B_D_CLEANUP
    BEFORE DELETE
    ON WEBI2MS.T_OSI_PARTIC_INVOLVEMENT
    REFERENCING NEW AS New OLD AS Old
    FOR EACH ROW
BEGIN
    Delete from T_OSI_F_INV_SPEC s
          Where s.investigation = :old.obj
            And (   s.subject = :old.participant_version
                 Or s.victim = :old.participant_version);

    Delete from T_OSI_F_INV_SUBJ_DISPOSITION d
          Where d.investigation = :old.obj And d.subject = :old.participant_version;
EXCEPTION
    WHEN OTHERS THEN
        -- Consider logging the error and then re-raise
        RAISE;
END OSI_PARTICINVLV_B_D_CLEANUP;
/