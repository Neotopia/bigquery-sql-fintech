-- ============================================================
-- FILE 02 : Window Functions – The Basics
-- ============================================================
-- Dataset : fictional bank transactions (5 clients, 3 months) (CTE)
-- Goal    : use window functions on concrete financial use cases.
--
-- 💡 How to run: copy ONE query at a time into BigQuery,
--    starting from the "transactions" CTE available in 01_dataset_transactions.sql
--    down to the final SELECT available in this file.
-- ============================================================


-- ─────────────────────────────────────────────────────────────
-- QUERY 1 : ROW_NUMBER – Organising transactions by client
-- ─────────────────────────────────────────────────────────────
-- Use case : find the first and last transaction for each client
--            to study the duration of the client relationship
-- ROW_NUMBER() assigns a unique number to each row within a partition (group)



SELECT
  client_id,
  txn_id,
  txn_date,
  amount,

  -- Position of the transaction in the client's history (1 = oldest)
  ROW_NUMBER() OVER w_client AS txn_rank,

  -- Total number of known transactions for this client
  COUNT(*) OVER w_client_total AS txn_count,

  -- First and last transaction dates
  MIN(txn_date) OVER w_client_total AS first_txn_date,
  MAX(txn_date) OVER w_client_total AS last_txn_date

FROM transactions

WINDOW
  w_client       AS (PARTITION BY client_id ORDER BY txn_date ASC),
  w_client_total AS (PARTITION BY client_id)

ORDER BY client_id, txn_date;

