# BigQuery SQL — Personal Finance Analysis (Fintech)

SQL queries for analysing simulated personal finance data, written and commented in English.  
Built as part of a skill progression toward **Data Analyst / Analytics Engineer** roles.

**Stack:** Google BigQuery · Standard SQL · Window Functions

---

## Context & Business Questions

This project explores a simulated dataset of 50 personal banking transactions across 5 clients over 3 months (Jan–Mar 2026). It targets the kinds of analytical questions that matter in a fintech or personal finance product:

- How does each client's account balance evolve over time?
- Which clients save the most relative to their income?
- How do spending patterns differ across categories and income levels?
- Which transactions represent unusual or high-value spend?

---

## Repository Structure

```
bigquery-sql-fintech/
└── sql/
    ├── 01_dataset_transactions.sql    → Self-contained dataset (50 rows, defined inline via CTE)
    └── 02_window_functions_basics.sql → Dataset enrichment using window functions
```

---

## How to Run

1. Open [BigQuery Sandbox](https://console.cloud.google.com/bigquery)
2. Create a new project if needed
3. Open `01_dataset_transactions.sql` and run it to preview the raw dataset
4. To run the window function analysis:
   - Keep only the `WITH transactions AS (...)` block from file `01`
   - Paste the content of file `02` directly below it
   - Click **Run**

> All data is self-contained: defined directly inside a `WITH` CTE — no table creation or CSV import needed.

---

## Concepts Covered

| File | SQL Concepts |
|---|---|
| `01_dataset_transactions.sql` | CTE (`WITH`) |
| `02_window_functions_basics.sql` | `ROW_NUMBER`, `RANK`, `LAG`, `SUM() OVER`, `AVG() OVER`, `FORMAT_DATE`, frame clauses (`ROWS BETWEEN`) |

---

## Author

**Lisa Momas** — Digital Analytics & Data  
[LinkedIn](https://www.linkedin.com/in/lisa-momas-69518b177) · Transitioning toward Analytics Engineer / Data Analyst roles