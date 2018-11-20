create or replace PACKAGE xxege_purge AS
    PROCEDURE run_purge (
        p_days_retention IN INTEGER DEFAULT 7
    );

END xxege_purge;