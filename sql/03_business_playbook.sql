-- ============================================================
-- FILE 03 : Business Playbook — Fintech Analytics Queries
-- ============================================================
-- Dataset : fictional bank transactions (5 clients, 3 months)
--
-- A collection of analysis queries answering real fintech
-- business questions using SQL aggregations and window functions.
--
-- 💡 How to run: each query is self-contained.
--    Copy from the WITH clause down to the ORDER BY and run it.
--
-- Questions covered:
--   Q1 — What is each client's monthly cashflow?
--   Q2 — What is each client's savings rate per month?
--   Q3 — What share of spending goes to each category?
--   Q4 — How is each client's spending evolving month over month?
--   Q5 — Which transactions are anomalous vs the client's average?
-- ============================================================


-- ============================================================
-- Q1 — What is each client's monthly cashflow?
--
-- Business context : core KPI for any neobank or PFM (Personal
--   Finance Management) product. A negative cashflow two months
--   in a row is an early signal of financial stress.
--
-- Technique : GROUP BY + conditional SUM (CASE WHEN)
-- ============================================================

WITH transactions AS (
  SELECT 'TXN001' AS txn_id, 'C001' AS client_id, DATE '2026-01-05' AS txn_date,  2800.00 AS amount, 'incoming_transfer'  AS txn_type, 'salary'       AS category UNION ALL
  SELECT 'TXN002', 'C001', DATE '2026-01-07',  -950.00, 'outgoing_transfer', 'rent'          UNION ALL
  SELECT 'TXN003', 'C001', DATE '2026-01-12',   -85.40, 'card_payment',      'groceries'     UNION ALL
  SELECT 'TXN004', 'C001', DATE '2026-01-18',   -42.00, 'card_payment',      'transport'     UNION ALL
  SELECT 'TXN005', 'C001', DATE '2026-01-25',  -120.00, 'card_payment',      'leisure'       UNION ALL
  SELECT 'TXN006', 'C001', DATE '2026-02-05',  2800.00, 'incoming_transfer', 'salary'        UNION ALL
  SELECT 'TXN007', 'C001', DATE '2026-02-08',  -950.00, 'outgoing_transfer', 'rent'          UNION ALL
  SELECT 'TXN008', 'C001', DATE '2026-02-14',   -67.20, 'card_payment',      'groceries'     UNION ALL
  SELECT 'TXN009', 'C001', DATE '2026-02-20',   -35.90, 'card_payment',      'subscription'  UNION ALL
  SELECT 'TXN010', 'C001', DATE '2026-03-05',  2800.00, 'incoming_transfer', 'salary'        UNION ALL
  SELECT 'TXN011', 'C002', DATE '2026-01-03',  3500.00, 'incoming_transfer', 'salary'        UNION ALL
  SELECT 'TXN012', 'C002', DATE '2026-01-06', -1200.00, 'outgoing_transfer', 'rent'          UNION ALL
  SELECT 'TXN013', 'C002', DATE '2026-01-10',  -210.50, 'card_payment',      'groceries'     UNION ALL
  SELECT 'TXN014', 'C002', DATE '2026-01-15',  -580.00, 'card_payment',      'leisure'       UNION ALL
  SELECT 'TXN015', 'C002', DATE '2026-01-22',   -89.00, 'card_payment',      'transport'     UNION ALL
  SELECT 'TXN016', 'C002', DATE '2026-02-03',  3500.00, 'incoming_transfer', 'salary'        UNION ALL
  SELECT 'TXN017', 'C002', DATE '2026-02-09', -1200.00, 'outgoing_transfer', 'rent'          UNION ALL
  SELECT 'TXN018', 'C002', DATE '2026-02-16',  -145.00, 'card_payment',      'groceries'     UNION ALL
  SELECT 'TXN019', 'C002', DATE '2026-02-17',   -15.00, 'card_payment',      'groceries'     UNION ALL
  SELECT 'TXN020', 'C002', DATE '2026-03-03',  3500.00, 'incoming_transfer', 'salary'        UNION ALL
  SELECT 'TXN021', 'C002', DATE '2026-03-07', -1200.00, 'outgoing_transfer', 'rent'          UNION ALL
  SELECT 'TXN022', 'C003', DATE '2026-01-02',  1800.00, 'incoming_transfer', 'salary'        UNION ALL
  SELECT 'TXN023', 'C003', DATE '2026-01-03',   -30.00, 'card_payment',      'leisure'       UNION ALL
  SELECT 'TXN024', 'C003', DATE '2026-01-05',  -700.00, 'outgoing_transfer', 'rent'          UNION ALL
  SELECT 'TXN025', 'C003', DATE '2026-01-11',   -55.30, 'card_payment',      'groceries'     UNION ALL
  SELECT 'TXN026', 'C003', DATE '2026-01-19',  -200.00, 'cash_withdrawal',   'leisure'       UNION ALL
  SELECT 'TXN027', 'C003', DATE '2026-02-02',  1800.00, 'incoming_transfer', 'salary'        UNION ALL
  SELECT 'TXN028', 'C003', DATE '2026-02-06',  -700.00, 'outgoing_transfer', 'rent'          UNION ALL
  SELECT 'TXN029', 'C003', DATE '2026-02-13',   -48.90, 'card_payment',      'groceries'     UNION ALL
  SELECT 'TXN030', 'C003', DATE '2026-02-21',   -25.00, 'card_payment',      'subscription'  UNION ALL
  SELECT 'TXN031', 'C003', DATE '2026-02-21',   -50.00, 'card_payment',      'leisure'       UNION ALL
  SELECT 'TXN032', 'C003', DATE '2026-03-02',  1800.00, 'incoming_transfer', 'salary'        UNION ALL
  SELECT 'TXN033', 'C003', DATE '2026-03-10',  -300.00, 'card_payment',      'leisure'       UNION ALL
  SELECT 'TXN034', 'C004', DATE '2026-01-04',  4200.00, 'incoming_transfer', 'salary'        UNION ALL
  SELECT 'TXN035', 'C004', DATE '2026-01-08', -1500.00, 'outgoing_transfer', 'rent'          UNION ALL
  SELECT 'TXN036', 'C004', DATE '2026-01-13',  -320.00, 'card_payment',      'groceries'     UNION ALL
  SELECT 'TXN037', 'C004', DATE '2026-01-20',  -850.00, 'card_payment',      'leisure'       UNION ALL
  SELECT 'TXN038', 'C004', DATE '2026-01-28',  -200.00, 'card_payment',      'transport'     UNION ALL
  SELECT 'TXN039', 'C004', DATE '2026-02-04',  4200.00, 'incoming_transfer', 'salary'        UNION ALL
  SELECT 'TXN040', 'C004', DATE '2026-02-10', -1500.00, 'outgoing_transfer', 'rent'          UNION ALL
  SELECT 'TXN041', 'C004', DATE '2026-02-24',  -980.00, 'card_payment',      'leisure'       UNION ALL
  SELECT 'TXN042', 'C004', DATE '2026-03-04',  4200.00, 'incoming_transfer', 'salary'        UNION ALL
  SELECT 'TXN043', 'C005', DATE '2026-01-06',  2200.00, 'incoming_transfer', 'salary'        UNION ALL
  SELECT 'TXN044', 'C005', DATE '2026-01-09',  -800.00, 'outgoing_transfer', 'rent'          UNION ALL
  SELECT 'TXN045', 'C005', DATE '2026-01-14',   -92.10, 'card_payment',      'groceries'     UNION ALL
  SELECT 'TXN046', 'C005', DATE '2026-01-23',   -55.00, 'card_payment',      'subscription'  UNION ALL
  SELECT 'TXN047', 'C005', DATE '2026-02-06',  2200.00, 'incoming_transfer', 'salary'        UNION ALL
  SELECT 'TXN048', 'C005', DATE '2026-02-10',  -800.00, 'outgoing_transfer', 'rent'          UNION ALL
  SELECT 'TXN049', 'C005', DATE '2026-03-06',  2200.00, 'incoming_transfer', 'salary'        UNION ALL
  SELECT 'TXN050', 'C005', DATE '2026-03-12',  -800.00, 'outgoing_transfer', 'rent'
)

SELECT
  client_id,
  FORMAT_DATE('%Y-%m', txn_date)                                      AS month,
  ROUND(SUM(CASE WHEN amount > 0 THEN amount ELSE 0 END), 2)          AS total_income,
  ROUND(SUM(CASE WHEN amount < 0 THEN ABS(amount) ELSE 0 END), 2)     AS total_spending,
  ROUND(SUM(amount), 2)                                               AS net_cashflow,
  CASE
    WHEN SUM(amount) >= 0 THEN 'positive'
    ELSE 'negative'
  END                                                                 AS cashflow_status
FROM transactions
GROUP BY client_id, FORMAT_DATE('%Y-%m', txn_date)
ORDER BY client_id, month;


-- ============================================================
-- Q2 — What is each client's savings rate per month?
--
-- Business context : savings rate = % of income that is not
--   spent. A rate below 10% is a risk signal for credit scoring.
--   A rate above 30% is a signal for investment product targeting.
--
-- Technique : GROUP BY aggregation + SAFE_DIVIDE for null safety
-- ============================================================

WITH transactions AS (
  SELECT 'TXN001' AS txn_id, 'C001' AS client_id, DATE '2026-01-05' AS txn_date,  2800.00 AS amount, 'incoming_transfer'  AS txn_type, 'salary'       AS category UNION ALL
  SELECT 'TXN002', 'C001', DATE '2026-01-07',  -950.00, 'outgoing_transfer', 'rent'          UNION ALL
  SELECT 'TXN003', 'C001', DATE '2026-01-12',   -85.40, 'card_payment',      'groceries'     UNION ALL
  SELECT 'TXN004', 'C001', DATE '2026-01-18',   -42.00, 'card_payment',      'transport'     UNION ALL
  SELECT 'TXN005', 'C001', DATE '2026-01-25',  -120.00, 'card_payment',      'leisure'       UNION ALL
  SELECT 'TXN006', 'C001', DATE '2026-02-05',  2800.00, 'incoming_transfer', 'salary'        UNION ALL
  SELECT 'TXN007', 'C001', DATE '2026-02-08',  -950.00, 'outgoing_transfer', 'rent'          UNION ALL
  SELECT 'TXN008', 'C001', DATE '2026-02-14',   -67.20, 'card_payment',      'groceries'     UNION ALL
  SELECT 'TXN009', 'C001', DATE '2026-02-20',   -35.90, 'card_payment',      'subscription'  UNION ALL
  SELECT 'TXN010', 'C001', DATE '2026-03-05',  2800.00, 'incoming_transfer', 'salary'        UNION ALL
  SELECT 'TXN011', 'C002', DATE '2026-01-03',  3500.00, 'incoming_transfer', 'salary'        UNION ALL
  SELECT 'TXN012', 'C002', DATE '2026-01-06', -1200.00, 'outgoing_transfer', 'rent'          UNION ALL
  SELECT 'TXN013', 'C002', DATE '2026-01-10',  -210.50, 'card_payment',      'groceries'     UNION ALL
  SELECT 'TXN014', 'C002', DATE '2026-01-15',  -580.00, 'card_payment',      'leisure'       UNION ALL
  SELECT 'TXN015', 'C002', DATE '2026-01-22',   -89.00, 'card_payment',      'transport'     UNION ALL
  SELECT 'TXN016', 'C002', DATE '2026-02-03',  3500.00, 'incoming_transfer', 'salary'        UNION ALL
  SELECT 'TXN017', 'C002', DATE '2026-02-09', -1200.00, 'outgoing_transfer', 'rent'          UNION ALL
  SELECT 'TXN018', 'C002', DATE '2026-02-16',  -145.00, 'card_payment',      'groceries'     UNION ALL
  SELECT 'TXN019', 'C002', DATE '2026-02-17',   -15.00, 'card_payment',      'groceries'     UNION ALL
  SELECT 'TXN020', 'C002', DATE '2026-03-03',  3500.00, 'incoming_transfer', 'salary'        UNION ALL
  SELECT 'TXN021', 'C002', DATE '2026-03-07', -1200.00, 'outgoing_transfer', 'rent'          UNION ALL
  SELECT 'TXN022', 'C003', DATE '2026-01-02',  1800.00, 'incoming_transfer', 'salary'        UNION ALL
  SELECT 'TXN023', 'C003', DATE '2026-01-03',   -30.00, 'card_payment',      'leisure'       UNION ALL
  SELECT 'TXN024', 'C003', DATE '2026-01-05',  -700.00, 'outgoing_transfer', 'rent'          UNION ALL
  SELECT 'TXN025', 'C003', DATE '2026-01-11',   -55.30, 'card_payment',      'groceries'     UNION ALL
  SELECT 'TXN026', 'C003', DATE '2026-01-19',  -200.00, 'cash_withdrawal',   'leisure'       UNION ALL
  SELECT 'TXN027', 'C003', DATE '2026-02-02',  1800.00, 'incoming_transfer', 'salary'        UNION ALL
  SELECT 'TXN028', 'C003', DATE '2026-02-06',  -700.00, 'outgoing_transfer', 'rent'          UNION ALL
  SELECT 'TXN029', 'C003', DATE '2026-02-13',   -48.90, 'card_payment',      'groceries'     UNION ALL
  SELECT 'TXN030', 'C003', DATE '2026-02-21',   -25.00, 'card_payment',      'subscription'  UNION ALL
  SELECT 'TXN031', 'C003', DATE '2026-02-21',   -50.00, 'card_payment',      'leisure'       UNION ALL
  SELECT 'TXN032', 'C003', DATE '2026-03-02',  1800.00, 'incoming_transfer', 'salary'        UNION ALL
  SELECT 'TXN033', 'C003', DATE '2026-03-10',  -300.00, 'card_payment',      'leisure'       UNION ALL
  SELECT 'TXN034', 'C004', DATE '2026-01-04',  4200.00, 'incoming_transfer', 'salary'        UNION ALL
  SELECT 'TXN035', 'C004', DATE '2026-01-08', -1500.00, 'outgoing_transfer', 'rent'          UNION ALL
  SELECT 'TXN036', 'C004', DATE '2026-01-13',  -320.00, 'card_payment',      'groceries'     UNION ALL
  SELECT 'TXN037', 'C004', DATE '2026-01-20',  -850.00, 'card_payment',      'leisure'       UNION ALL
  SELECT 'TXN038', 'C004', DATE '2026-01-28',  -200.00, 'card_payment',      'transport'     UNION ALL
  SELECT 'TXN039', 'C004', DATE '2026-02-04',  4200.00, 'incoming_transfer', 'salary'        UNION ALL
  SELECT 'TXN040', 'C004', DATE '2026-02-10', -1500.00, 'outgoing_transfer', 'rent'          UNION ALL
  SELECT 'TXN041', 'C004', DATE '2026-02-24',  -980.00, 'card_payment',      'leisure'       UNION ALL
  SELECT 'TXN042', 'C004', DATE '2026-03-04',  4200.00, 'incoming_transfer', 'salary'        UNION ALL
  SELECT 'TXN043', 'C005', DATE '2026-01-06',  2200.00, 'incoming_transfer', 'salary'        UNION ALL
  SELECT 'TXN044', 'C005', DATE '2026-01-09',  -800.00, 'outgoing_transfer', 'rent'          UNION ALL
  SELECT 'TXN045', 'C005', DATE '2026-01-14',   -92.10, 'card_payment',      'groceries'     UNION ALL
  SELECT 'TXN046', 'C005', DATE '2026-01-23',   -55.00, 'card_payment',      'subscription'  UNION ALL
  SELECT 'TXN047', 'C005', DATE '2026-02-06',  2200.00, 'incoming_transfer', 'salary'        UNION ALL
  SELECT 'TXN048', 'C005', DATE '2026-02-10',  -800.00, 'outgoing_transfer', 'rent'          UNION ALL
  SELECT 'TXN049', 'C005', DATE '2026-03-06',  2200.00, 'incoming_transfer', 'salary'        UNION ALL
  SELECT 'TXN050', 'C005', DATE '2026-03-12',  -800.00, 'outgoing_transfer', 'rent'
),

monthly_cashflow AS (
  SELECT
    client_id,
    FORMAT_DATE('%Y-%m', txn_date)                               AS month,
    SUM(CASE WHEN amount > 0 THEN amount ELSE 0 END)             AS income,
    SUM(CASE WHEN amount < 0 THEN ABS(amount) ELSE 0 END)        AS spending
  FROM transactions
  GROUP BY client_id, FORMAT_DATE('%Y-%m', txn_date)
)

SELECT
  client_id,
  month,
  ROUND(income, 2)                                               AS income,
  ROUND(spending, 2)                                             AS spending,
  ROUND(income - spending, 2)                                    AS savings,
  ROUND(SAFE_DIVIDE(income - spending, income) * 100, 1)         AS savings_rate_pct,
  CASE
    WHEN SAFE_DIVIDE(income - spending, income) >= 0.30 THEN 'high saver  → investment product'
    WHEN SAFE_DIVIDE(income - spending, income) >= 0.10 THEN 'average saver'
    WHEN SAFE_DIVIDE(income - spending, income) >= 0     THEN 'low saver   → budgeting nudge'
    ELSE                                                      'overspending → alert'
  END                                                            AS savings_segment
FROM monthly_cashflow
ORDER BY client_id, month;


-- ============================================================
-- Q3 — What share of spending goes to each category per client?
--
-- Business context : spending breakdown is used in PFM dashboards,
--   credit risk scoring, and personalised advice engines.
--   A client spending >50% on rent is classified as "rent-burdened"
--   in most fintech risk models.
--
-- Technique : GROUP BY + SUM OVER (PARTITION BY) without ORDER BY
--             → window function returns the partition-wide total,
--               not a cumulative sum
-- ============================================================

WITH transactions AS (
  SELECT 'TXN001' AS txn_id, 'C001' AS client_id, DATE '2026-01-05' AS txn_date,  2800.00 AS amount, 'incoming_transfer'  AS txn_type, 'salary'       AS category UNION ALL
  SELECT 'TXN002', 'C001', DATE '2026-01-07',  -950.00, 'outgoing_transfer', 'rent'          UNION ALL
  SELECT 'TXN003', 'C001', DATE '2026-01-12',   -85.40, 'card_payment',      'groceries'     UNION ALL
  SELECT 'TXN004', 'C001', DATE '2026-01-18',   -42.00, 'card_payment',      'transport'     UNION ALL
  SELECT 'TXN005', 'C001', DATE '2026-01-25',  -120.00, 'card_payment',      'leisure'       UNION ALL
  SELECT 'TXN006', 'C001', DATE '2026-02-05',  2800.00, 'incoming_transfer', 'salary'        UNION ALL
  SELECT 'TXN007', 'C001', DATE '2026-02-08',  -950.00, 'outgoing_transfer', 'rent'          UNION ALL
  SELECT 'TXN008', 'C001', DATE '2026-02-14',   -67.20, 'card_payment',      'groceries'     UNION ALL
  SELECT 'TXN009', 'C001', DATE '2026-02-20',   -35.90, 'card_payment',      'subscription'  UNION ALL
  SELECT 'TXN010', 'C001', DATE '2026-03-05',  2800.00, 'incoming_transfer', 'salary'        UNION ALL
  SELECT 'TXN011', 'C002', DATE '2026-01-03',  3500.00, 'incoming_transfer', 'salary'        UNION ALL
  SELECT 'TXN012', 'C002', DATE '2026-01-06', -1200.00, 'outgoing_transfer', 'rent'          UNION ALL
  SELECT 'TXN013', 'C002', DATE '2026-01-10',  -210.50, 'card_payment',      'groceries'     UNION ALL
  SELECT 'TXN014', 'C002', DATE '2026-01-15',  -580.00, 'card_payment',      'leisure'       UNION ALL
  SELECT 'TXN015', 'C002', DATE '2026-01-22',   -89.00, 'card_payment',      'transport'     UNION ALL
  SELECT 'TXN016', 'C002', DATE '2026-02-03',  3500.00, 'incoming_transfer', 'salary'        UNION ALL
  SELECT 'TXN017', 'C002', DATE '2026-02-09', -1200.00, 'outgoing_transfer', 'rent'          UNION ALL
  SELECT 'TXN018', 'C002', DATE '2026-02-16',  -145.00, 'card_payment',      'groceries'     UNION ALL
  SELECT 'TXN019', 'C002', DATE '2026-02-17',   -15.00, 'card_payment',      'groceries'     UNION ALL
  SELECT 'TXN020', 'C002', DATE '2026-03-03',  3500.00, 'incoming_transfer', 'salary'        UNION ALL
  SELECT 'TXN021', 'C002', DATE '2026-03-07', -1200.00, 'outgoing_transfer', 'rent'          UNION ALL
  SELECT 'TXN022', 'C003', DATE '2026-01-02',  1800.00, 'incoming_transfer', 'salary'        UNION ALL
  SELECT 'TXN023', 'C003', DATE '2026-01-03',   -30.00, 'card_payment',      'leisure'       UNION ALL
  SELECT 'TXN024', 'C003', DATE '2026-01-05',  -700.00, 'outgoing_transfer', 'rent'          UNION ALL
  SELECT 'TXN025', 'C003', DATE '2026-01-11',   -55.30, 'card_payment',      'groceries'     UNION ALL
  SELECT 'TXN026', 'C003', DATE '2026-01-19',  -200.00, 'cash_withdrawal',   'leisure'       UNION ALL
  SELECT 'TXN027', 'C003', DATE '2026-02-02',  1800.00, 'incoming_transfer', 'salary'        UNION ALL
  SELECT 'TXN028', 'C003', DATE '2026-02-06',  -700.00, 'outgoing_transfer', 'rent'          UNION ALL
  SELECT 'TXN029', 'C003', DATE '2026-02-13',   -48.90, 'card_payment',      'groceries'     UNION ALL
  SELECT 'TXN030', 'C003', DATE '2026-02-21',   -25.00, 'card_payment',      'subscription'  UNION ALL
  SELECT 'TXN031', 'C003', DATE '2026-02-21',   -50.00, 'card_payment',      'leisure'       UNION ALL
  SELECT 'TXN032', 'C003', DATE '2026-03-02',  1800.00, 'incoming_transfer', 'salary'        UNION ALL
  SELECT 'TXN033', 'C003', DATE '2026-03-10',  -300.00, 'card_payment',      'leisure'       UNION ALL
  SELECT 'TXN034', 'C004', DATE '2026-01-04',  4200.00, 'incoming_transfer', 'salary'        UNION ALL
  SELECT 'TXN035', 'C004', DATE '2026-01-08', -1500.00, 'outgoing_transfer', 'rent'          UNION ALL
  SELECT 'TXN036', 'C004', DATE '2026-01-13',  -320.00, 'card_payment',      'groceries'     UNION ALL
  SELECT 'TXN037', 'C004', DATE '2026-01-20',  -850.00, 'card_payment',      'leisure'       UNION ALL
  SELECT 'TXN038', 'C004', DATE '2026-01-28',  -200.00, 'card_payment',      'transport'     UNION ALL
  SELECT 'TXN039', 'C004', DATE '2026-02-04',  4200.00, 'incoming_transfer', 'salary'        UNION ALL
  SELECT 'TXN040', 'C004', DATE '2026-02-10', -1500.00, 'outgoing_transfer', 'rent'          UNION ALL
  SELECT 'TXN041', 'C004', DATE '2026-02-24',  -980.00, 'card_payment',      'leisure'       UNION ALL
  SELECT 'TXN042', 'C004', DATE '2026-03-04',  4200.00, 'incoming_transfer', 'salary'        UNION ALL
  SELECT 'TXN043', 'C005', DATE '2026-01-06',  2200.00, 'incoming_transfer', 'salary'        UNION ALL
  SELECT 'TXN044', 'C005', DATE '2026-01-09',  -800.00, 'outgoing_transfer', 'rent'          UNION ALL
  SELECT 'TXN045', 'C005', DATE '2026-01-14',   -92.10, 'card_payment',      'groceries'     UNION ALL
  SELECT 'TXN046', 'C005', DATE '2026-01-23',   -55.00, 'card_payment',      'subscription'  UNION ALL
  SELECT 'TXN047', 'C005', DATE '2026-02-06',  2200.00, 'incoming_transfer', 'salary'        UNION ALL
  SELECT 'TXN048', 'C005', DATE '2026-02-10',  -800.00, 'outgoing_transfer', 'rent'          UNION ALL
  SELECT 'TXN049', 'C005', DATE '2026-03-06',  2200.00, 'incoming_transfer', 'salary'        UNION ALL
  SELECT 'TXN050', 'C005', DATE '2026-03-12',  -800.00, 'outgoing_transfer', 'rent'
),

spending_by_category AS (
  SELECT
    client_id,
    category,
    ROUND(SUM(ABS(amount)), 2) AS category_total
  FROM transactions
  WHERE amount < 0
  GROUP BY client_id, category
)

SELECT
  client_id,
  category,
  category_total,
  ROUND(SUM(category_total) OVER (PARTITION BY client_id), 2)     AS client_total_spending,
  ROUND(
    SAFE_DIVIDE(category_total, SUM(category_total) OVER (PARTITION BY client_id)) * 100,
    1
  )                                                                AS share_pct,
  CASE
    WHEN category = 'rent'
     AND SAFE_DIVIDE(category_total, SUM(category_total) OVER (PARTITION BY client_id)) > 0.50
    THEN '⚠️ rent-burdened'
    ELSE NULL
  END                                                              AS risk_flag
FROM spending_by_category
ORDER BY client_id, share_pct DESC;


-- ============================================================
-- Q4 — How is each client's spending evolving month over month?
--
-- Business context : a consistent MoM spending increase is an
--   early warning for over-indebtedness. Used in proactive
--   customer care and credit limit adjustment decisions.
--
-- Technique : GROUP BY to get monthly totals, then LAG() to
--             compare current month vs the previous one
-- ============================================================

WITH transactions AS (
  SELECT 'TXN001' AS txn_id, 'C001' AS client_id, DATE '2026-01-05' AS txn_date,  2800.00 AS amount, 'incoming_transfer'  AS txn_type, 'salary'       AS category UNION ALL
  SELECT 'TXN002', 'C001', DATE '2026-01-07',  -950.00, 'outgoing_transfer', 'rent'          UNION ALL
  SELECT 'TXN003', 'C001', DATE '2026-01-12',   -85.40, 'card_payment',      'groceries'     UNION ALL
  SELECT 'TXN004', 'C001', DATE '2026-01-18',   -42.00, 'card_payment',      'transport'     UNION ALL
  SELECT 'TXN005', 'C001', DATE '2026-01-25',  -120.00, 'card_payment',      'leisure'       UNION ALL
  SELECT 'TXN006', 'C001', DATE '2026-02-05',  2800.00, 'incoming_transfer', 'salary'        UNION ALL
  SELECT 'TXN007', 'C001', DATE '2026-02-08',  -950.00, 'outgoing_transfer', 'rent'          UNION ALL
  SELECT 'TXN008', 'C001', DATE '2026-02-14',   -67.20, 'card_payment',      'groceries'     UNION ALL
  SELECT 'TXN009', 'C001', DATE '2026-02-20',   -35.90, 'card_payment',      'subscription'  UNION ALL
  SELECT 'TXN010', 'C001', DATE '2026-03-05',  2800.00, 'incoming_transfer', 'salary'        UNION ALL
  SELECT 'TXN011', 'C002', DATE '2026-01-03',  3500.00, 'incoming_transfer', 'salary'        UNION ALL
  SELECT 'TXN012', 'C002', DATE '2026-01-06', -1200.00, 'outgoing_transfer', 'rent'          UNION ALL
  SELECT 'TXN013', 'C002', DATE '2026-01-10',  -210.50, 'card_payment',      'groceries'     UNION ALL
  SELECT 'TXN014', 'C002', DATE '2026-01-15',  -580.00, 'card_payment',      'leisure'       UNION ALL
  SELECT 'TXN015', 'C002', DATE '2026-01-22',   -89.00, 'card_payment',      'transport'     UNION ALL
  SELECT 'TXN016', 'C002', DATE '2026-02-03',  3500.00, 'incoming_transfer', 'salary'        UNION ALL
  SELECT 'TXN017', 'C002', DATE '2026-02-09', -1200.00, 'outgoing_transfer', 'rent'          UNION ALL
  SELECT 'TXN018', 'C002', DATE '2026-02-16',  -145.00, 'card_payment',      'groceries'     UNION ALL
  SELECT 'TXN019', 'C002', DATE '2026-02-17',   -15.00, 'card_payment',      'groceries'     UNION ALL
  SELECT 'TXN020', 'C002', DATE '2026-03-03',  3500.00, 'incoming_transfer', 'salary'        UNION ALL
  SELECT 'TXN021', 'C002', DATE '2026-03-07', -1200.00, 'outgoing_transfer', 'rent'          UNION ALL
  SELECT 'TXN022', 'C003', DATE '2026-01-02',  1800.00, 'incoming_transfer', 'salary'        UNION ALL
  SELECT 'TXN023', 'C003', DATE '2026-01-03',   -30.00, 'card_payment',      'leisure'       UNION ALL
  SELECT 'TXN024', 'C003', DATE '2026-01-05',  -700.00, 'outgoing_transfer', 'rent'          UNION ALL
  SELECT 'TXN025', 'C003', DATE '2026-01-11',   -55.30, 'card_payment',      'groceries'     UNION ALL
  SELECT 'TXN026', 'C003', DATE '2026-01-19',  -200.00, 'cash_withdrawal',   'leisure'       UNION ALL
  SELECT 'TXN027', 'C003', DATE '2026-02-02',  1800.00, 'incoming_transfer', 'salary'        UNION ALL
  SELECT 'TXN028', 'C003', DATE '2026-02-06',  -700.00, 'outgoing_transfer', 'rent'          UNION ALL
  SELECT 'TXN029', 'C003', DATE '2026-02-13',   -48.90, 'card_payment',      'groceries'     UNION ALL
  SELECT 'TXN030', 'C003', DATE '2026-02-21',   -25.00, 'card_payment',      'subscription'  UNION ALL
  SELECT 'TXN031', 'C003', DATE '2026-02-21',   -50.00, 'card_payment',      'leisure'       UNION ALL
  SELECT 'TXN032', 'C003', DATE '2026-03-02',  1800.00, 'incoming_transfer', 'salary'        UNION ALL
  SELECT 'TXN033', 'C003', DATE '2026-03-10',  -300.00, 'card_payment',      'leisure'       UNION ALL
  SELECT 'TXN034', 'C004', DATE '2026-01-04',  4200.00, 'incoming_transfer', 'salary'        UNION ALL
  SELECT 'TXN035', 'C004', DATE '2026-01-08', -1500.00, 'outgoing_transfer', 'rent'          UNION ALL
  SELECT 'TXN036', 'C004', DATE '2026-01-13',  -320.00, 'card_payment',      'groceries'     UNION ALL
  SELECT 'TXN037', 'C004', DATE '2026-01-20',  -850.00, 'card_payment',      'leisure'       UNION ALL
  SELECT 'TXN038', 'C004', DATE '2026-01-28',  -200.00, 'card_payment',      'transport'     UNION ALL
  SELECT 'TXN039', 'C004', DATE '2026-02-04',  4200.00, 'incoming_transfer', 'salary'        UNION ALL
  SELECT 'TXN040', 'C004', DATE '2026-02-10', -1500.00, 'outgoing_transfer', 'rent'          UNION ALL
  SELECT 'TXN041', 'C004', DATE '2026-02-24',  -980.00, 'card_payment',      'leisure'       UNION ALL
  SELECT 'TXN042', 'C004', DATE '2026-03-04',  4200.00, 'incoming_transfer', 'salary'        UNION ALL
  SELECT 'TXN043', 'C005', DATE '2026-01-06',  2200.00, 'incoming_transfer', 'salary'        UNION ALL
  SELECT 'TXN044', 'C005', DATE '2026-01-09',  -800.00, 'outgoing_transfer', 'rent'          UNION ALL
  SELECT 'TXN045', 'C005', DATE '2026-01-14',   -92.10, 'card_payment',      'groceries'     UNION ALL
  SELECT 'TXN046', 'C005', DATE '2026-01-23',   -55.00, 'card_payment',      'subscription'  UNION ALL
  SELECT 'TXN047', 'C005', DATE '2026-02-06',  2200.00, 'incoming_transfer', 'salary'        UNION ALL
  SELECT 'TXN048', 'C005', DATE '2026-02-10',  -800.00, 'outgoing_transfer', 'rent'          UNION ALL
  SELECT 'TXN049', 'C005', DATE '2026-03-06',  2200.00, 'incoming_transfer', 'salary'        UNION ALL
  SELECT 'TXN050', 'C005', DATE '2026-03-12',  -800.00, 'outgoing_transfer', 'rent'
),

monthly_spending AS (
  SELECT
    client_id,
    FORMAT_DATE('%Y-%m', txn_date)              AS month,
    ROUND(SUM(ABS(amount)), 2)                  AS total_spending
  FROM transactions
  WHERE amount < 0
  GROUP BY client_id, FORMAT_DATE('%Y-%m', txn_date)
)

SELECT
  client_id,
  month,
  total_spending,
  LAG(total_spending) OVER (PARTITION BY client_id ORDER BY month)  AS prev_month_spending,
  ROUND(
    total_spending - LAG(total_spending) OVER (PARTITION BY client_id ORDER BY month),
    2
  )                                                                  AS spending_change,
  ROUND(
    SAFE_DIVIDE(
      total_spending - LAG(total_spending) OVER (PARTITION BY client_id ORDER BY month),
      LAG(total_spending) OVER (PARTITION BY client_id ORDER BY month)
    ) * 100,
    1
  )                                                                  AS spending_change_pct,
  CASE
    WHEN LAG(total_spending) OVER (PARTITION BY client_id ORDER BY month) IS NULL THEN 'first month'
    WHEN total_spending > LAG(total_spending) OVER (PARTITION BY client_id ORDER BY month) THEN '↑ increase'
    WHEN total_spending < LAG(total_spending) OVER (PARTITION BY client_id ORDER BY month) THEN '↓ decrease'
    ELSE '→ stable'
  END                                                                AS trend
FROM monthly_spending
ORDER BY client_id, month;


-- ============================================================
-- Q5 — Which transactions are anomalous vs the client's average?
--
-- Business context : anomaly detection is used in fraud prevention,
--   unusual behaviour alerts, and spend monitoring features.
--   Simple baseline: flag any debit > 2× the client's average
--   debit as "unusual". In production, a z-score or ML model
--   would replace this threshold, and fixed charges (rent) would
--   be excluded from the baseline computation.
--
-- Technique : AVG OVER (PARTITION BY) without ORDER BY
--             → returns the same average on every row of the partition
-- ============================================================

WITH transactions AS (
  SELECT 'TXN001' AS txn_id, 'C001' AS client_id, DATE '2026-01-05' AS txn_date,  2800.00 AS amount, 'incoming_transfer'  AS txn_type, 'salary'       AS category UNION ALL
  SELECT 'TXN002', 'C001', DATE '2026-01-07',  -950.00, 'outgoing_transfer', 'rent'          UNION ALL
  SELECT 'TXN003', 'C001', DATE '2026-01-12',   -85.40, 'card_payment',      'groceries'     UNION ALL
  SELECT 'TXN004', 'C001', DATE '2026-01-18',   -42.00, 'card_payment',      'transport'     UNION ALL
  SELECT 'TXN005', 'C001', DATE '2026-01-25',  -120.00, 'card_payment',      'leisure'       UNION ALL
  SELECT 'TXN006', 'C001', DATE '2026-02-05',  2800.00, 'incoming_transfer', 'salary'        UNION ALL
  SELECT 'TXN007', 'C001', DATE '2026-02-08',  -950.00, 'outgoing_transfer', 'rent'          UNION ALL
  SELECT 'TXN008', 'C001', DATE '2026-02-14',   -67.20, 'card_payment',      'groceries'     UNION ALL
  SELECT 'TXN009', 'C001', DATE '2026-02-20',   -35.90, 'card_payment',      'subscription'  UNION ALL
  SELECT 'TXN010', 'C001', DATE '2026-03-05',  2800.00, 'incoming_transfer', 'salary'        UNION ALL
  SELECT 'TXN011', 'C002', DATE '2026-01-03',  3500.00, 'incoming_transfer', 'salary'        UNION ALL
  SELECT 'TXN012', 'C002', DATE '2026-01-06', -1200.00, 'outgoing_transfer', 'rent'          UNION ALL
  SELECT 'TXN013', 'C002', DATE '2026-01-10',  -210.50, 'card_payment',      'groceries'     UNION ALL
  SELECT 'TXN014', 'C002', DATE '2026-01-15',  -580.00, 'card_payment',      'leisure'       UNION ALL
  SELECT 'TXN015', 'C002', DATE '2026-01-22',   -89.00, 'card_payment',      'transport'     UNION ALL
  SELECT 'TXN016', 'C002', DATE '2026-02-03',  3500.00, 'incoming_transfer', 'salary'        UNION ALL
  SELECT 'TXN017', 'C002', DATE '2026-02-09', -1200.00, 'outgoing_transfer', 'rent'          UNION ALL
  SELECT 'TXN018', 'C002', DATE '2026-02-16',  -145.00, 'card_payment',      'groceries'     UNION ALL
  SELECT 'TXN019', 'C002', DATE '2026-02-17',   -15.00, 'card_payment',      'groceries'     UNION ALL
  SELECT 'TXN020', 'C002', DATE '2026-03-03',  3500.00, 'incoming_transfer', 'salary'        UNION ALL
  SELECT 'TXN021', 'C002', DATE '2026-03-07', -1200.00, 'outgoing_transfer', 'rent'          UNION ALL
  SELECT 'TXN022', 'C003', DATE '2026-01-02',  1800.00, 'incoming_transfer', 'salary'        UNION ALL
  SELECT 'TXN023', 'C003', DATE '2026-01-03',   -30.00, 'card_payment',      'leisure'       UNION ALL
  SELECT 'TXN024', 'C003', DATE '2026-01-05',  -700.00, 'outgoing_transfer', 'rent'          UNION ALL
  SELECT 'TXN025', 'C003', DATE '2026-01-11',   -55.30, 'card_payment',      'groceries'     UNION ALL
  SELECT 'TXN026', 'C003', DATE '2026-01-19',  -200.00, 'cash_withdrawal',   'leisure'       UNION ALL
  SELECT 'TXN027', 'C003', DATE '2026-02-02',  1800.00, 'incoming_transfer', 'salary'        UNION ALL
  SELECT 'TXN028', 'C003', DATE '2026-02-06',  -700.00, 'outgoing_transfer', 'rent'          UNION ALL
  SELECT 'TXN029', 'C003', DATE '2026-02-13',   -48.90, 'card_payment',      'groceries'     UNION ALL
  SELECT 'TXN030', 'C003', DATE '2026-02-21',   -25.00, 'card_payment',      'subscription'  UNION ALL
  SELECT 'TXN031', 'C003', DATE '2026-02-21',   -50.00, 'card_payment',      'leisure'       UNION ALL
  SELECT 'TXN032', 'C003', DATE '2026-03-02',  1800.00, 'incoming_transfer', 'salary'        UNION ALL
  SELECT 'TXN033', 'C003', DATE '2026-03-10',  -300.00, 'card_payment',      'leisure'       UNION ALL
  SELECT 'TXN034', 'C004', DATE '2026-01-04',  4200.00, 'incoming_transfer', 'salary'        UNION ALL
  SELECT 'TXN035', 'C004', DATE '2026-01-08', -1500.00, 'outgoing_transfer', 'rent'          UNION ALL
  SELECT 'TXN036', 'C004', DATE '2026-01-13',  -320.00, 'card_payment',      'groceries'     UNION ALL
  SELECT 'TXN037', 'C004', DATE '2026-01-20',  -850.00, 'card_payment',      'leisure'       UNION ALL
  SELECT 'TXN038', 'C004', DATE '2026-01-28',  -200.00, 'card_payment',      'transport'     UNION ALL
  SELECT 'TXN039', 'C004', DATE '2026-02-04',  4200.00, 'incoming_transfer', 'salary'        UNION ALL
  SELECT 'TXN040', 'C004', DATE '2026-02-10', -1500.00, 'outgoing_transfer', 'rent'          UNION ALL
  SELECT 'TXN041', 'C004', DATE '2026-02-24',  -980.00, 'card_payment',      'leisure'       UNION ALL
  SELECT 'TXN042', 'C004', DATE '2026-03-04',  4200.00, 'incoming_transfer', 'salary'        UNION ALL
  SELECT 'TXN043', 'C005', DATE '2026-01-06',  2200.00, 'incoming_transfer', 'salary'        UNION ALL
  SELECT 'TXN044', 'C005', DATE '2026-01-09',  -800.00, 'outgoing_transfer', 'rent'          UNION ALL
  SELECT 'TXN045', 'C005', DATE '2026-01-14',   -92.10, 'card_payment',      'groceries'     UNION ALL
  SELECT 'TXN046', 'C005', DATE '2026-01-23',   -55.00, 'card_payment',      'subscription'  UNION ALL
  SELECT 'TXN047', 'C005', DATE '2026-02-06',  2200.00, 'incoming_transfer', 'salary'        UNION ALL
  SELECT 'TXN048', 'C005', DATE '2026-02-10',  -800.00, 'outgoing_transfer', 'rent'          UNION ALL
  SELECT 'TXN049', 'C005', DATE '2026-03-06',  2200.00, 'incoming_transfer', 'salary'        UNION ALL
  SELECT 'TXN050', 'C005', DATE '2026-03-12',  -800.00, 'outgoing_transfer', 'rent'
)

SELECT
  client_id,
  txn_id,
  txn_date,
  ABS(amount)                                                        AS debit_amount,
  category,
  ROUND(AVG(ABS(amount)) OVER (PARTITION BY client_id), 2)          AS client_avg_debit,
  ROUND(
    SAFE_DIVIDE(ABS(amount), AVG(ABS(amount)) OVER (PARTITION BY client_id)),
    2
  )                                                                  AS ratio_vs_avg,
  CASE
    WHEN ABS(amount) > 2 * AVG(ABS(amount)) OVER (PARTITION BY client_id)
    THEN '⚠️ anomalous'
    ELSE 'normal'
  END                                                                AS anomaly_flag
FROM transactions
WHERE amount < 0
ORDER BY client_id, ratio_vs_avg DESC;
