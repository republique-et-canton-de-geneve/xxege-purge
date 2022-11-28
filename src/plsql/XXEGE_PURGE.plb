create or replace PACKAGE BODY xxege_purge AS
  --
  --
  --

    PROCEDURE purge_osb (
        p_days_retention IN INTEGER DEFAULT 7
    ) AS
    BEGIN
        DELETE FROM wli_qs_report_data rd
        WHERE
            EXISTS (
                SELECT
                    'x'
                FROM
                    wli_qs_report_attribute ra
                WHERE
                    ra.msg_guid = rd.msg_guid
                    AND ra.db_timestamp < trunc(SYSDATE) - p_days_retention
            );

        DELETE FROM wli_qs_report_attribute ra
        WHERE
            ra.db_timestamp < trunc(SYSDATE) - p_days_retention;

    EXCEPTION
        WHEN OTHERS THEN
            log_error('ERROR(purge_osb) ');
    END purge_osb;
--
--
--

    PROCEDURE purge_soa (
        p_days_retention IN INTEGER DEFAULT 7
    ) AS
    max_creation_date timestamp;
    min_creation_date timestamp;
    batch_size integer;
    max_runtime integer;
    retention_period timestamp;
    composite_name varchar2(500);
    composite_revision varchar2(50);
    soa_partition_name varchar2(200);
    PQS integer;
    ignore_state boolean; 
    BEGIN
        min_creation_date := SYSDATE-100; --maybe use more if you plan on purging less frequently
        max_creation_date := SYSDATE-p_days_retention;
        max_runtime := 60;
        batch_size := 1000;
        soa.delete_instances(
                            min_creation_date => min_creation_date,
                            max_creation_date => max_creation_date,
                            batch_size => batch_size,
                            max_runtime => max_runtime,
                            purge_partitioned_component => false
                            );
    EXCEPTION
        WHEN OTHERS THEN
            log_error('ERROR(purge_soa) ');
            RAISE;
    END purge_soa;
--
--
--

    PROCEDURE post_purge_osb AS
    BEGIN
        EXECUTE IMMEDIATE 'ALTER TABLE wli_qs_report_data DEALLOCATE unused';
        EXECUTE IMMEDIATE 'ALTER TABLE wli_qs_report_data enable row movement';
        EXECUTE IMMEDIATE 'ALTER TABLE wli_qs_report_data shrink space compact';
        EXECUTE IMMEDIATE 'ALTER TABLE wli_qs_report_attribute DEALLOCATE unused';
        EXECUTE IMMEDIATE 'ALTER TABLE wli_qs_report_attribute enable row movement';
        EXECUTE IMMEDIATE 'ALTER TABLE wli_qs_report_attribute shrink space compact';
        EXECUTE IMMEDIATE 'ALTER INDEX IX_WLI_QS_REPORT_ATTRIBUTE_DM REBUILD';
        EXECUTE IMMEDIATE 'ALTER INDEX IX_WLI_QS_REPORT_ATTRIBUTE_IED REBUILD';
    EXCEPTION
        WHEN OTHERS THEN
            log_error('ERROR(post_purge_osb) ');
            RAISE;
    END post_purge_osb;
--
--
--

    PROCEDURE post_purge_soa AS
    BEGIN
        EXECUTE IMMEDIATE 'ALTER table mediator_case_instance enable row movement';
        EXECUTE IMMEDIATE 'ALTER table mediator_case_instance shrink space';
        EXECUTE IMMEDIATE 'ALTER table mediator_case_instance disable row movement';
        EXECUTE IMMEDIATE 'ALTER table mediator_audit_document enable row movement';
        EXECUTE IMMEDIATE 'ALTER table mediator_audit_document shrink space';
        EXECUTE IMMEDIATE 'ALTER table mediator_audit_document disable row movement';
        EXECUTE IMMEDIATE 'ALTER table mediator_callback enable row movement';
        EXECUTE IMMEDIATE 'ALTER table mediator_callback shrink space';
        EXECUTE IMMEDIATE 'ALTER table mediator_callback disable row movement';
        EXECUTE IMMEDIATE 'ALTER table mediator_group_status enable row movement';
        EXECUTE IMMEDIATE 'ALTER table mediator_group_status shrink space';
        EXECUTE IMMEDIATE 'ALTER table mediator_group_status disable row movement';
        EXECUTE IMMEDIATE 'ALTER table mediator_payload enable row movement';
        EXECUTE IMMEDIATE 'ALTER table mediator_payload shrink space';
        EXECUTE IMMEDIATE 'ALTER table mediator_payload disable row movement';
        EXECUTE IMMEDIATE 'ALTER table mediator_deferred_message enable row movement';
        EXECUTE IMMEDIATE 'ALTER table mediator_deferred_message shrink space';
        EXECUTE IMMEDIATE 'ALTER table mediator_deferred_message disable row movement';
        EXECUTE IMMEDIATE 'ALTER table mediator_resequencer_message enable row movement';
        EXECUTE IMMEDIATE 'ALTER table mediator_resequencer_message shrink space';
        EXECUTE IMMEDIATE 'ALTER table mediator_resequencer_message disable row movement';
        EXECUTE IMMEDIATE 'ALTER table mediator_case_detail enable row movement';
        EXECUTE IMMEDIATE 'ALTER table mediator_case_detail shrink space';
        EXECUTE IMMEDIATE 'ALTER table mediator_case_detail disable row movement';
        EXECUTE IMMEDIATE 'ALTER table mediator_correlation enable row movement';
        EXECUTE IMMEDIATE 'ALTER table mediator_correlation shrink space';
        EXECUTE IMMEDIATE 'ALTER table mediator_correlation disable row movement';
        EXECUTE IMMEDIATE 'ALTER table headers_properties enable row movement';
        EXECUTE IMMEDIATE 'ALTER table headers_properties shrink space';
        EXECUTE IMMEDIATE 'ALTER table headers_properties disable row movement';
        EXECUTE IMMEDIATE 'ALTER table ag_instance enable row movement';
        EXECUTE IMMEDIATE 'ALTER table ag_instance shrink space';
        EXECUTE IMMEDIATE 'ALTER table ag_instance disable row movement';
        EXECUTE IMMEDIATE 'ALTER table audit_counter enable row movement';
        EXECUTE IMMEDIATE 'ALTER table audit_counter shrink space';
        EXECUTE IMMEDIATE 'ALTER table audit_counter disable row movement';
        EXECUTE IMMEDIATE 'ALTER table audit_trail enable row movement';
        EXECUTE IMMEDIATE 'ALTER table audit_trail shrink space';
        EXECUTE IMMEDIATE 'ALTER table audit_trail disable row movement';
        EXECUTE IMMEDIATE 'ALTER table audit_details enable row movement';
        EXECUTE IMMEDIATE 'ALTER table audit_details shrink space';
        EXECUTE IMMEDIATE 'ALTER table audit_details disable row movement';
        EXECUTE IMMEDIATE 'ALTER table ci_indexes enable row movement';
        EXECUTE IMMEDIATE 'ALTER table ci_indexes shrink space';
        EXECUTE IMMEDIATE 'ALTER table ci_indexes disable row movement';
        EXECUTE IMMEDIATE 'ALTER table work_item enable row movement';
        EXECUTE IMMEDIATE 'ALTER table work_item shrink space';
        EXECUTE IMMEDIATE 'ALTER table work_item disable row movement';
        EXECUTE IMMEDIATE 'ALTER table wi_fault enable row movement';
        EXECUTE IMMEDIATE 'ALTER table wi_fault shrink space';
        EXECUTE IMMEDIATE 'ALTER table wi_fault disable row movement';
        EXECUTE IMMEDIATE 'ALTER table xml_document_ref enable row movement';
        EXECUTE IMMEDIATE 'ALTER table xml_document_ref shrink space';
        EXECUTE IMMEDIATE 'ALTER table xml_document_ref disable row movement';
        EXECUTE IMMEDIATE 'ALTER table document_dlv_msg_ref enable row movement';
        EXECUTE IMMEDIATE 'ALTER table document_dlv_msg_ref shrink space';
        EXECUTE IMMEDIATE 'ALTER table document_dlv_msg_ref disable row movement';
        EXECUTE IMMEDIATE 'ALTER table document_ci_ref enable row movement';
        EXECUTE IMMEDIATE 'ALTER table document_ci_ref shrink space';
        EXECUTE IMMEDIATE 'ALTER table document_ci_ref disable row movement';
        EXECUTE IMMEDIATE 'ALTER table dlv_subscription enable row movement';
        EXECUTE IMMEDIATE 'ALTER table dlv_subscription shrink space';
        EXECUTE IMMEDIATE 'ALTER table dlv_subscription disable row movement';
        EXECUTE IMMEDIATE 'ALTER table dlv_message enable row movement';
        EXECUTE IMMEDIATE 'ALTER table dlv_message shrink space';
        EXECUTE IMMEDIATE 'ALTER table dlv_message disable row movement';
        EXECUTE IMMEDIATE 'ALTER table rejected_msg_native_payload enable row movement';
        EXECUTE IMMEDIATE 'ALTER table rejected_msg_native_payload shrink space';
        EXECUTE IMMEDIATE 'ALTER table rejected_msg_native_payload disable row movement';
        EXECUTE IMMEDIATE 'ALTER table instance_payload enable row movement';
        EXECUTE IMMEDIATE 'ALTER table instance_payload shrink space';
        EXECUTE IMMEDIATE 'ALTER table instance_payload disable row movement';
        EXECUTE IMMEDIATE 'ALTER table test_details enable row movement';
        EXECUTE IMMEDIATE 'ALTER table test_details shrink space';
        EXECUTE IMMEDIATE 'ALTER table test_details disable row movement';
        EXECUTE IMMEDIATE 'ALTER table cube_scope enable row movement';
        EXECUTE IMMEDIATE 'ALTER table cube_scope shrink space';
        EXECUTE IMMEDIATE 'ALTER table cube_scope disable row movement';
        EXECUTE IMMEDIATE 'ALTER table cube_instance enable row movement';
        EXECUTE IMMEDIATE 'ALTER table cube_instance shrink space';
        EXECUTE IMMEDIATE 'ALTER table cube_instance disable row movement';
        EXECUTE IMMEDIATE 'ALTER table bpm_audit_query enable row movement';
        EXECUTE IMMEDIATE 'ALTER table bpm_audit_query shrink space';
        EXECUTE IMMEDIATE 'ALTER table bpm_audit_query disable row movement';
        EXECUTE IMMEDIATE 'ALTER table bpm_measurement_actions enable row movement';
        EXECUTE IMMEDIATE 'ALTER table bpm_measurement_actions shrink space';
        EXECUTE IMMEDIATE 'ALTER table bpm_measurement_actions disable row movement';
        EXECUTE IMMEDIATE 'ALTER table bpm_measurement_action_exceps enable row movement';
        EXECUTE IMMEDIATE 'ALTER table bpm_measurement_action_exceps shrink space';
        EXECUTE IMMEDIATE 'ALTER table bpm_measurement_action_exceps disable row movement';
        EXECUTE IMMEDIATE 'ALTER table bpm_cube_auditinstance enable row movement';
        EXECUTE IMMEDIATE 'ALTER table bpm_cube_auditinstance shrink space';
        EXECUTE IMMEDIATE 'ALTER table bpm_cube_auditinstance disable row movement';
        EXECUTE IMMEDIATE 'ALTER table bpm_cube_taskperformance enable row movement';
        EXECUTE IMMEDIATE 'ALTER table bpm_cube_taskperformance shrink space';
        EXECUTE IMMEDIATE 'ALTER table bpm_cube_taskperformance disable row movement';
        EXECUTE IMMEDIATE 'ALTER table bpm_cube_processperformance enable row movement';
        EXECUTE IMMEDIATE 'ALTER table bpm_cube_processperformance shrink space';
        EXECUTE IMMEDIATE 'ALTER table bpm_cube_processperformance disable row movement';
        EXECUTE IMMEDIATE 'ALTER table wftask_tl enable row movement';
        EXECUTE IMMEDIATE 'ALTER table wftask_tl shrink space';
        EXECUTE IMMEDIATE 'ALTER table wftask_tl disable row movement';
        EXECUTE IMMEDIATE 'ALTER table wftaskhistory enable row movement';
        EXECUTE IMMEDIATE 'ALTER table wftaskhistory shrink space';
        EXECUTE IMMEDIATE 'ALTER table wftaskhistory disable row movement';
        EXECUTE IMMEDIATE 'ALTER table wftaskhistory_tl enable row movement';
        EXECUTE IMMEDIATE 'ALTER table wftaskhistory_tl shrink space';
        EXECUTE IMMEDIATE 'ALTER table wftaskhistory_tl disable row movement';
        EXECUTE IMMEDIATE 'ALTER table wfcomments enable row movement';
        EXECUTE IMMEDIATE 'ALTER table wfcomments shrink space';
        EXECUTE IMMEDIATE 'ALTER table wfcomments disable row movement';
        EXECUTE IMMEDIATE 'ALTER table wfmessageattribute enable row movement';
        EXECUTE IMMEDIATE 'ALTER table wfmessageattribute shrink space';
        EXECUTE IMMEDIATE 'ALTER table wfmessageattribute disable row movement';
        EXECUTE IMMEDIATE 'ALTER table wfattachment enable row movement';
        EXECUTE IMMEDIATE 'ALTER table wfattachment shrink space';
        EXECUTE IMMEDIATE 'ALTER table wfattachment disable row movement';
        EXECUTE IMMEDIATE 'ALTER table wfassignee enable row movement';
        EXECUTE IMMEDIATE 'ALTER table wfassignee shrink space';
        EXECUTE IMMEDIATE 'ALTER table wfassignee disable row movement';
        EXECUTE IMMEDIATE 'ALTER table wfreviewer enable row movement';
        EXECUTE IMMEDIATE 'ALTER table wfreviewer shrink space';
        EXECUTE IMMEDIATE 'ALTER table wfreviewer disable row movement';
        EXECUTE IMMEDIATE 'ALTER table wfcollectiontarget enable row movement';
        EXECUTE IMMEDIATE 'ALTER table wfcollectiontarget shrink space';
        EXECUTE IMMEDIATE 'ALTER table wfcollectiontarget disable row movement';
        EXECUTE IMMEDIATE 'ALTER table wfroutingslip enable row movement';
        EXECUTE IMMEDIATE 'ALTER table wfroutingslip shrink space';
        EXECUTE IMMEDIATE 'ALTER table wfroutingslip disable row movement';
        EXECUTE IMMEDIATE 'ALTER table wfnotification enable row movement';
        EXECUTE IMMEDIATE 'ALTER table wfnotification shrink space';
        EXECUTE IMMEDIATE 'ALTER table wfnotification disable row movement';
        EXECUTE IMMEDIATE 'ALTER table wftasktimer enable row movement';
        EXECUTE IMMEDIATE 'ALTER table wftasktimer shrink space';
        EXECUTE IMMEDIATE 'ALTER table wftasktimer disable row movement';
        EXECUTE IMMEDIATE 'ALTER table wftaskerror enable row movement';
        EXECUTE IMMEDIATE 'ALTER table wftaskerror shrink space';
        EXECUTE IMMEDIATE 'ALTER table wftaskerror disable row movement';
        EXECUTE IMMEDIATE 'ALTER table wfheaderprops enable row movement';
        EXECUTE IMMEDIATE 'ALTER table wfheaderprops shrink space';
        EXECUTE IMMEDIATE 'ALTER table wfheaderprops disable row movement';
        EXECUTE IMMEDIATE 'ALTER table wfevidence enable row movement';
        EXECUTE IMMEDIATE 'ALTER table wfevidence shrink space';
        EXECUTE IMMEDIATE 'ALTER table wfevidence disable row movement';
        EXECUTE IMMEDIATE 'ALTER table wftaskaggregation enable row movement';
        EXECUTE IMMEDIATE 'ALTER table wftaskaggregation shrink space';
        EXECUTE IMMEDIATE 'ALTER table wftaskaggregation disable row movement';
        EXECUTE IMMEDIATE 'ALTER table wftask enable row movement';
        EXECUTE IMMEDIATE 'ALTER table wftask shrink space';
        EXECUTE IMMEDIATE 'ALTER table wftask disable row movement';
        EXECUTE IMMEDIATE 'ALTER table composite_sensor_value enable row movement';
        EXECUTE IMMEDIATE 'ALTER table composite_sensor_value shrink space';
        EXECUTE IMMEDIATE 'ALTER table composite_sensor_value disable row movement';
        EXECUTE IMMEDIATE 'ALTER table composite_instance_assoc enable row movement';
        EXECUTE IMMEDIATE 'ALTER table composite_instance_assoc shrink space';
        EXECUTE IMMEDIATE 'ALTER table composite_instance_assoc disable row movement';
        EXECUTE IMMEDIATE 'ALTER table attachment enable row movement';
        EXECUTE IMMEDIATE 'ALTER table attachment shrink space';
        EXECUTE IMMEDIATE 'ALTER table attachment disable row movement';
        EXECUTE IMMEDIATE 'ALTER table attachment_ref enable row movement';
        EXECUTE IMMEDIATE 'ALTER table attachment_ref shrink space';
        EXECUTE IMMEDIATE 'ALTER table attachment_ref disable row movement';
        EXECUTE IMMEDIATE 'ALTER table component_instance enable row movement';
        EXECUTE IMMEDIATE 'ALTER table component_instance shrink space';
        EXECUTE IMMEDIATE 'ALTER table component_instance disable row movement';
    EXCEPTION
        WHEN OTHERS THEN
            log_error('ERROR(post_purge_soa) ');
            RAISE;
    END post_purge_soa;
--
--
--

    PROCEDURE run_purge_osb (
        p_days_retention IN INTEGER DEFAULT 7
    ) AS
        PRAGMA autonomous_transaction;
    BEGIN
        purge_osb(p_days_retention);
        post_purge_osb;
        COMMIT;
    EXCEPTION
        WHEN OTHERS THEN
            log_error('ERROR(run_purge_osb) ');
            RAISE;
    END run_purge_osb;
--
--
--

    PROCEDURE run_purge_soa (
        p_days_retention IN INTEGER DEFAULT 7
    ) AS
        PRAGMA autonomous_transaction;
    BEGIN
        purge_soa(p_days_retention);
        post_purge_soa;
        COMMIT;
    EXCEPTION
        WHEN OTHERS THEN
            log_error('ERROR(run_purge_soa) ');
            RAISE;
    END run_purge_soa;
--
--
--

    PROCEDURE run_stats AS
    BEGIN
        dbms_stats.gather_schema_stats(ownname => 'ESB_SOAINFRA',estimate_percent => 10,cascade => true);
    EXCEPTION
        WHEN OTHERS THEN
            log_error('ERROR(run_stats) ');
            RAISE;
    END run_stats;
--
--
--

    PROCEDURE run_purge (
        p_days_retention IN INTEGER DEFAULT 7
    ) AS
    BEGIN
        run_purge_osb(p_days_retention);
        run_purge_soa(p_days_retention);
        run_stats;
    EXCEPTION
        WHEN OTHERS THEN
            log_error('ERROR(run_purge) ');
            RAISE;
    END run_purge;
--
--
--

END xxege_purge;