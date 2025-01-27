-- models/staging/raw_github/stg_commits.sql

{{ config(
    materialized='view'
) }}

SELECT
    _airbyte_unique_key,
    sha,
    url,
    author,      
    branch,
    commit,      
    node_id,
    parents,     
    html_url,
    committer,   
    created_at,
    repository,
    comments_url,
    _airbyte_ab_id,
    _airbyte_emitted_at,
    _airbyte_normalized_at,
    _airbyte_commits_hashid
FROM raw_github.commits
