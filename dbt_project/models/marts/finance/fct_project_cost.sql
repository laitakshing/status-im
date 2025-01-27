-- models/marts/finance/fct_project_cost.sql

{{ config(
    materialized='table'
) }}

WITH exchange_rates AS (
    SELECT 'USD' AS currency, 0.90 AS rate_to_eur UNION ALL
    SELECT 'AOA', 0.014 UNION ALL
    SELECT 'EUR', 1.00  -- Base currency
),

converted_invoices AS (
    SELECT
        stg.invoice_date,
        stg.amount,
        stg.department,
        stg.currency,
        -- Convert amount to EUR using fixed exchange rates
        CASE 
            WHEN stg.currency = 'USD' THEN stg.amount * er.rate_to_eur
            WHEN stg.currency = 'AOA' THEN stg.amount * er.rate_to_eur
            WHEN stg.currency = 'EUR' THEN stg.amount * er.rate_to_eur
            ELSE NULL  -- Handle unexpected currencies
        END AS amount_eur
    FROM {{ ref('stg_invoices') }} AS stg
    LEFT JOIN exchange_rates er
        ON stg.currency = er.currency
    WHERE stg.invoice_date IS NOT NULL
        AND stg.amount IS NOT NULL
        AND stg.currency IN ('USD', 'AOA', 'EUR')  -- Include only defined currencies
),

cleaned_invoices AS (
    SELECT
        invoice_date,
        amount,
        department,
        currency,
        amount_eur
    FROM converted_invoices
    WHERE amount_eur IS NOT NULL  -- Exclude records with undefined currencies
)

SELECT
    DATE_TRUNC('month', invoice_date) AS month,
    SUM(amount_eur) AS total_cost,
    SUM(CASE WHEN department = 'CODEX' THEN amount_eur ELSE 0 END) AS codex_cost,
    SUM(CASE WHEN department = 'WAKU' THEN amount_eur ELSE 0 END) AS waku_cost,
    SUM(CASE WHEN department = 'COMMUNICATION' THEN amount_eur ELSE 0 END) AS communication_cost,
    SUM(CASE WHEN department = 'infra' THEN amount_eur ELSE 0 END) AS infra_cost,
    SUM(CASE WHEN department IS NULL THEN amount_eur ELSE 0 END) AS other_cost
FROM cleaned_invoices
GROUP BY month
ORDER BY month
