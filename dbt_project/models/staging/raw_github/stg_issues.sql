-- models/staging/raw_github/stg_issues.sql

{{ config(
    materialized='view'
) }}

SELECT
    _airbyte_unique_key,
    id,
    url,
    body,
    user,
    draft::BOOLEAN,
    state,
    title,
    labels,  
    locked::BOOLEAN,
    number,
    node_id,
    user_id,
    assignee,
    comments,
    html_url,
    assignees,  
    closed_at,
    milestone,  
    reactions,  
    created_at,
    events_url,
    labels_url,
    repository,
    updated_at,
    comments_url,
    pull_request,  
    state_reason,
    timeline_url,
    repository_url,
    active_lock_reason,
    author_association,
    performed_via_github_app,
    _airbyte_ab_id,
    _airbyte_emitted_at,
    _airbyte_normalized_at,
    _airbyte_issues_hashid
FROM raw_github.issues
