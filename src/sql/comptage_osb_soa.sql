-- Nombre de rapports OSB (normalement 1 par appel) par date
SELECT
    trunc(localhost_timestamp) AS date_msg,
    COUNT(*) AS occurences,
    trunc(SYSDATE) - trunc(localhost_timestamp) AS jours_retention
FROM
    wli_qs_report_attribute
GROUP BY
    trunc(localhost_timestamp)
ORDER BY
    1;

-- Nombre de rapports OSB 1/2
SELECT
    COUNT(*)
FROM
    wli_qs_report_attribute;
    
-- Nombre de rapports OSB 2/2, doit être égal
SELECT
    COUNT(*)
FROM
    wli_qs_report_data;

-- Nombre d'instance SOA par statut
SELECT
    ( CASE
        WHEN state = 1    THEN 'OPEN AND RUNNING'
        WHEN state = 2    THEN 'OPEN AND SUSPENDED'
        WHEN state = 3    THEN 'OPEN AND FAULTED'
        WHEN state = 4    THEN 'CLOSED AND PENDING'
        WHEN state = 5    THEN 'CLOSED AND COMPLETED'
        WHEN state = 6    THEN 'CLOSED AND FAUTED'
        WHEN state = 7    THEN 'CLOSED AND CANCELLED'
        WHEN state = 8    THEN 'CLOSED AND ABORTED'
        WHEN state = 9    THEN 'CLOSED AND STALE'
        WHEN state = 10   THEN 'NON-RECOVERABLE'
        ELSE state || ''
    END ) AS state,
    COUNT(*) AS num_of_cube_inst
FROM
    cube_instance
GROUP BY
    state;