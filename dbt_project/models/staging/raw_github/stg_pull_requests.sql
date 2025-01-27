-- models/staging/raw_github/stg_pull_requests.sql

{{ config(
    materialized='view'
) }}

SELECT
    _airbyte_unique_key,
    id::numeric AS id,
    url,
    base,
    body,
    head,
    "user",
    NULLIF(draft, 'null')::BOOLEAN AS darft,
    state,
    title,
    _links,
    labels,
    NULLIF(locked, 'null')::BOOLEAN as locked,
    number,
    node_id,
    assignee,
    diff_url,
    html_url,
    assignees,
    closed_at,
    issue_url,
    merged_at,
    milestone,
    patch_url,
    auto_merge,
    created_at::date,
    repository,
    updated_at,
    commits_url,
    comments_url,
    statuses_url,
    requested_teams,
    merge_commit_sha,
    active_lock_reason,
    author_association,
    review_comment_url,
    requested_reviewers,
    review_comments_url,
    _airbyte_ab_id,
    _airbyte_emitted_at,
    _airbyte_normalized_at,
    _airbyte_pull_requests_hashid
FROM raw_github.pull_requests
WHERE id IS NOT NULL AND created_at IS NOT NULL AND repository IS NOT NULL
