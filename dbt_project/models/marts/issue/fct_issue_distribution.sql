-- models/marts/issue/fct_issue_distribution.sql

{{ config(
    materialized='table'
) }}

WITH issues AS (
    SELECT
        stg.id,
        stg.state,
        stg.created_at::date AS created_date,
        stg.closed_at::date AS closed_date,
        stg.labels
    FROM {{ ref('stg_issues') }} AS stg
),

labels AS (
    SELECT
        id,
        TRIM(label->>'name') AS label_name
    FROM issues,
    LATERAL jsonb_array_elements(issues.labels::jsonb) AS label
    WHERE issues.labels IS NOT NULL
)

SELECT
    created_date,
    label_name,
    COUNT(*) AS issues_created,
    SUM(CASE WHEN state = 'closed' THEN 1 ELSE 0 END) AS issues_closed,
    COUNT(*) - SUM(CASE WHEN state = 'closed' THEN 1 ELSE 0 END) AS issues_open
FROM issues
LEFT JOIN labels ON issues.id = labels.id
GROUP BY created_date, label_name
ORDER BY created_date, label_name
