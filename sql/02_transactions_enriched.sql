-- ============================================================
-- FILE 02 : Enriched transaction view
-- ============================================================
-- Dataset : fictional bank transactions (5 clients, 3 months)
-- Goal    : annotate each transaction with client-level context
--           using window functions — cumulative balance, spending rank,
--           transaction frequency, and more.
--
-- 💡 How to run: copy the entire file into BigQuery and run it.
--    The dataset is defined inline via a CTE — no table needed.
-- ============================================================


-- ============================================================
-- DATASET — Inline CTE (copied from 01_dataset_transactions.sql)
-- ============================================================

WITH transactions AS (

  -- C001 — 10 transactions (Jan–Mar 2026)
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

  -- C002 — 11 transactions (Jan–Mar 2026)
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

  -- C003 — 12 transactions (Jan–Mar 2026)
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

  -- C004 — 9 transactions (Jan–Mar 2026)
  SELECT 'TXN034', 'C004', DATE '2026-01-04',  4200.00, 'incoming_transfer', 'salary'        UNION ALL
  SELECT 'TXN035', 'C004', DATE '2026-01-08', -1500.00, 'outgoing_transfer', 'rent'          UNION ALL
  SELECT 'TXN036', 'C004', DATE '2026-01-13',  -320.00, 'card_payment',      'groceries'     UNION ALL
  SELECT 'TXN037', 'C004', DATE '2026-01-20',  -850.00, 'card_payment',      'leisure'       UNION ALL
  SELECT 'TXN038', 'C004', DATE '2026-01-28',  -200.00, 'card_payment',      'transport'     UNION ALL
  SELECT 'TXN039', 'C004', DATE '2026-02-04',  4200.00, 'incoming_transfer', 'salary'        UNION ALL
  SELECT 'TXN040', 'C004', DATE '2026-02-10', -1500.00, 'outgoing_transfer', 'rent'          UNION ALL
  SELECT 'TXN041', 'C004', DATE '2026-02-24',  -980.00, 'card_payment',      'leisure'       UNION ALL
  SELECT 'TXN042', 'C004', DATE '2026-03-04',  4200.00, 'incoming_transfer', 'salary'        UNION ALL

  -- C005 — 8 transactions (Jan–Mar 2026)
  SELECT 'TXN043', 'C005', DATE '2026-01-06',  2200.00, 'incoming_transfer', 'salary'        UNION ALL
  SELECT 'TXN044', 'C005', DATE '2026-01-09',  -800.00, 'outgoing_transfer', 'rent'          UNION ALL
  SELECT 'TXN045', 'C005', DATE '2026-01-14',   -92.10, 'card_payment',      'groceries'     UNION ALL
  SELECT 'TXN046', 'C005', DATE '2026-01-23',   -55.00, 'card_payment',      'subscription'  UNION ALL
  SELECT 'TXN047', 'C005', DATE '2026-02-06',  2200.00, 'incoming_transfer', 'salary'        UNION ALL
  SELECT 'TXN048', 'C005', DATE '2026-02-10',  -800.00, 'outgoing_transfer', 'rent'          UNION ALL
  SELECT 'TXN049', 'C005', DATE '2026-03-06',  2200.00, 'incoming_transfer', 'salary'        UNION ALL
  SELECT 'TXN050', 'C005', DATE '2026-03-12',  -800.00, 'outgoing_transfer', 'rent'

)


-- Row-level enrichment: each transaction is annotated with client-level context.
-- No aggregation — all 50 source rows are preserved in the output.

SELECT
  client_id,
  txn_id,
  txn_date,
  amount,
  category,

  -- Position of the transaction in the client's history (1 = oldest)
  ROW_NUMBER() OVER w_client                               AS txn_rank,

  -- Total number of known transactions for this client
  COUNT(*) OVER w_client_total                             AS txn_count,

  -- First and last transaction dates for this client
  MIN(txn_date) OVER w_client_total                        AS first_txn_date,
  MAX(txn_date) OVER w_client_total                        AS last_txn_date,

  -- Running balance transaction by transaction (to identify spending spikes)
  ROUND(SUM(amount) OVER w_balance, 2)                     AS cumulative_balance,

  -- Amount of the previous transaction for the same client (to identify large jumps)
  LAG(amount) OVER w_client                                AS previous_txn_amount,

  -- Number of days since the previous transaction (spending frequency)
  DATE_DIFF(
    txn_date,
    LAG(txn_date) OVER w_client,
    DAY
  )                                                        AS days_since_previous_txn,

  -- Expense rank within the client's transactions (1 = largest expense, NULL for credits)
  CASE
    WHEN amount < 0
    THEN DENSE_RANK() OVER (PARTITION BY client_id ORDER BY amount ASC)
  END                                                      AS spending_rank

FROM transactions

WINDOW
  w_client       AS (PARTITION BY client_id ORDER BY txn_date ASC),
  w_client_total AS (PARTITION BY client_id),
  w_balance      AS (PARTITION BY client_id ORDER BY txn_date ASC
                     ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW)

ORDER BY client_id, txn_date;
