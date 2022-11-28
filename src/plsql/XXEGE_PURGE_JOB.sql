begin
dbms_scheduler.create_job
(
 job_name        => 'ESB_PURGE',
 job_type        => 'PLSQL_BLOCK',
 job_action      => 'BEGIN xxege_purge.run_purge(32); END;',
 start_date      => systimestamp,
 repeat_interval => 'freq=weekly; byday=sun; byhour=5; byminute=0; bysecond=0;',
 enabled         => FALSE,
 comments        => 'ESB Purge'
);
end;
