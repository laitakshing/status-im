-- models/staging/raw_finance/stg_invoices.sql

{{ config(
    materialized='view'
) }}

SELECT
    id,
    invoice_date,
    currency,
    amount,
    department,
    comment
FROM raw_finance.invoices
WHERE invoice_date IS NOT NULL
