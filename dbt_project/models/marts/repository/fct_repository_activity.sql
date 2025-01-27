-- models/marts/repository/fct_repository_activity.sql

{{ config(
    materialized='table'
) }}

WITH commits AS (
    SELECT
        stg.repository,
        stg.created_at::date AS commit_date,
        stg.author,
        stg.sha
    FROM {{ ref('stg_commits') }} AS stg
),

pull_requests AS (
    SELECT
        stg.repository,
        stg.created_at::date AS pr_date,
        stg.state,
        stg.merged_at,
        stg.id
    FROM {{ ref('stg_pull_requests') }} AS stg
),

repositories AS (
    SELECT DISTINCT repository
    FROM commits
    UNION
    SELECT DISTINCT repository
    FROM pull_requests
)

SELECT
    replace(r.repository, 'waku-org/','') as repository,
    DATE_TRUNC('month', c.commit_date) AS month,
    COUNT(DISTINCT c.sha) AS total_commits,
    COUNT(DISTINCT pr.id) AS total_pull_requests,
    COUNT(DISTINCT CASE WHEN pr.state = 'closed' AND pr.merged_at IS NOT NULL THEN pr.id END) AS merged_pull_requests
FROM repositories r
LEFT JOIN commits c ON r.repository = c.repository
LEFT JOIN pull_requests pr ON r.repository = pr.repository AND DATE_TRUNC('month', pr.pr_date::date) = DATE_TRUNC('month', c.commit_date)
GROUP BY r.repository, month
ORDER BY r.repository, month
