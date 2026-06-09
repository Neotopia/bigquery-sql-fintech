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


-- ============================================================
-- SECTION 1 — Row-level enrichment with window functions
--
-- Each row is enriched with contextual metrics computed over
-- a window of rows (partition), without collapsing the result.
-- ============================================================



SELECT
  client_id,
  txn_id,
  txn_date,
  amount,
  category,

  -- Position of the transaction in the client's history (1 = oldest)
  ROW_NUMBER() OVER w_client AS txn_rank,

  -- Total number of known transactions for this client
  COUNT(*) OVER w_client_total AS txn_count,

  -- First and last transaction dates
  MIN(txn_date) OVER w_client_total AS first_txn_date,
  MAX(txn_date) OVER w_client_total AS last_txn_date,

  -- Running balance transaction by transaction to identify spending spikes
  ROUND(SUM(amount) OVER w_balance, 2) AS cumulative_balance,

  -- Amount of the previous transaction for the same customer (to identify large jumps)
  LAG(amount) OVER w_client AS previous_txn_amount,

  -- Number of days since the previous transaction (spending frequency)
  DATE_DIFF(
    txn_date,
    LAG(txn_date) OVER w_client,
    DAY
  ) AS days_since_previous_transaction,

  -- Rank of the expenses among all transactions of the same client
  CASE
  WHEN amount < 0 THEN
    DENSE_RANK() OVER (
      PARTITION BY client_id
      ORDER BY amount ASC
    )
  END AS spending_rank

FROM transactions

WINDOW
  w_client       AS (PARTITION BY client_id ORDER BY txn_date ASC),
  w_client_total AS (PARTITION BY client_id),
  w_balance      AS (PARTITION BY client_id ORDER BY txn_date ASC
                      ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW
                    )

ORDER BY client_id, txn_date;

