

--------------------------------------
-- 1. Create schema: raw_github
--------------------------------------
CREATE SCHEMA IF NOT EXISTS raw_github;

--------------------------------------
-- 2. Create + load raw_github.issues
--------------------------------------
DROP TABLE IF EXISTS raw_github.issues CASCADE;
CREATE TABLE raw_github.issues (
    _airbyte_unique_key              TEXT,
    id                               BIGINT,
    url                              TEXT,
    body                             TEXT,
    "user"                           TEXT,
    draft                            TEXT,
    state                            TEXT,
    title                            TEXT,
    labels                           TEXT,
    locked                           TEXT,     
    number                           BIGINT,
    node_id                          TEXT,
    user_id                          TEXT,
    assignee                         TEXT,
    comments                         BIGINT,   
    html_url                         TEXT,
    assignees                        TEXT,
    closed_at                        TIMESTAMP,
    milestone                        TEXT,
    reactions                        TEXT,
    created_at                       TIMESTAMP,
    events_url                       TEXT,
    labels_url                       TEXT,
    repository                       TEXT,
    updated_at                       TIMESTAMP,
    comments_url                     TEXT,
    pull_request                     TEXT,
    state_reason                     TEXT,
    timeline_url                     TEXT,
    repository_url                   TEXT,
    active_lock_reason               TEXT,
    author_association               TEXT,
    performed_via_github_app         TEXT,
    _airbyte_ab_id                   TEXT,
    _airbyte_emitted_at             TIMESTAMP,
    _airbyte_normalized_at           TIMESTAMP,
    _airbyte_issues_hashid           TEXT
);

COPY raw_github.issues
FROM '/docker-entrypoint-initdb.d/raw_github_issues.csv'
CSV HEADER;

--------------------------------------
-- 3. Create + load raw_github.commits
--------------------------------------
DROP TABLE IF EXISTS raw_github.commits CASCADE;
CREATE TABLE raw_github.commits (
    _airbyte_unique_key              TEXT,
    sha                              TEXT,
    url                              TEXT,
    author                           TEXT,
    branch                           TEXT,
    commit                           TEXT,
    node_id                          TEXT,
    parents                          TEXT,
    html_url                         TEXT,
    committer                        TEXT,
    created_at                       TIMESTAMP,
    repository                       TEXT,
    comments_url                     TEXT,
    _airbyte_ab_id                   TEXT,
    _airbyte_emitted_at             TIMESTAMP,
    _airbyte_normalized_at           TIMESTAMP,
    _airbyte_commits_hashid          TEXT
);

COPY raw_github.commits
FROM '/docker-entrypoint-initdb.d/raw_github_commits.csv'
CSV HEADER;

--------------------------------------------
-- 4. Create + load raw_github.pull_requests
--------------------------------------------
DROP TABLE IF EXISTS raw_github.pull_requests CASCADE;
CREATE TABLE raw_github.pull_requests (
    _airbyte_unique_key              TEXT,
    id                               BIGINT,
    url                              TEXT,
    base                             TEXT,
    body                             TEXT,
    head                             TEXT,
    "user"                           TEXT,
    draft                            TEXT,
    state                            TEXT,
    title                            TEXT,
    _links                           TEXT,
    labels                           TEXT,
    locked                           TEXT,     
    number                           BIGINT,
    node_id                          TEXT,
    assignee                         TEXT,
    diff_url                         TEXT,
    html_url                         TEXT,
    assignees                        TEXT,
    closed_at                        TIMESTAMP,
    issue_url                        TEXT,
    merged_at                        TIMESTAMP,
    milestone                        TEXT,
    patch_url                        TEXT,
    auto_merge                       TEXT,
    created_at                       TIMESTAMP,
    repository                       TEXT,
    updated_at                       TIMESTAMP,
    commits_url                      TEXT,
    comments_url                     TEXT,
    statuses_url                     TEXT,
    requested_teams                  TEXT,
    merge_commit_sha                 TEXT,
    active_lock_reason               TEXT,
    author_association               TEXT,
    review_comment_url               TEXT,
    requested_reviewers              TEXT,
    review_comments_url              TEXT,
    _airbyte_ab_id                   TEXT,
    _airbyte_emitted_at             TIMESTAMP,
    _airbyte_normalized_at           TIMESTAMP,
    _airbyte_pull_requests_hashid    TEXT
);

COPY raw_github.pull_requests
FROM '/docker-entrypoint-initdb.d/raw_github_pull_requests.csv'
CSV HEADER;


---------------------------------------
-- 5. JSON Invoice Data (raw_finance)
---------------------------------------

CREATE SCHEMA IF NOT EXISTS raw_finance;

-- Stage table for invoice JSON
DROP TABLE IF EXISTS raw_finance.invoices_stg CASCADE;
CREATE TABLE raw_finance.invoices_stg (
    payload TEXT
);

-- Load the single-column CSV with JSON
COPY raw_finance.invoices_stg (payload)
FROM '/docker-entrypoint-initdb.d/raw_finance_invoice.csv'
CSV HEADER;

-- Final invoices table with parsed columns
DROP TABLE IF EXISTS raw_finance.invoices CASCADE;
CREATE TABLE raw_finance.invoices (
    id NUMERIC(38, 0),
    invoice_date DATE,
    currency TEXT,
    amount NUMERIC,
    department TEXT,
    comment TEXT
);

INSERT INTO raw_finance.invoices (id, invoice_date, currency, amount, department, comment)
SELECT
    (payload::json ->> 'id')::numeric(38,0)            AS id,
    (payload::json ->> 'date')::date          AS invoice_date,
    (payload::json ->> 'currency')            AS currency,
    (payload::json ->> 'amount')::numeric     AS amount,
    (payload::json ->> 'department')          AS department,
    (payload::json ->> 'comment')             AS comment
FROM raw_finance.invoices_stg;

-- Optional: drop the staging table
DROP TABLE raw_finance.invoices_stg;
