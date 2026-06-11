# BigQuery SQL — Personal Finance Analysis (Fintech)

SQL queries for analysing simulated personal finance data, written and commented in English.
Personal project designed to deepen my analytical and data skills beyond web and digital analytics use cases.

**Stack:** Google BigQuery · Standard SQL · Window Functions · Analytical SQL

---

## Context & Business Questions

This project explores a simulated dataset of 50 personal banking transactions across 5 clients over 3 months (Jan–Mar 2026). It targets the kinds of analytical questions that matter in a fintech or personal finance product:

- How does each client's account balance evolve over time?
- Which clients save the most relative to their income?
- How do spending patterns differ across categories and income levels?
- Which transactions represent unusual or high-value spend?
- How is each client's spending trending month over month?

---

## Repository Structure

```
bigquery-sql-fintech/
└── sql/
    ├── 01_dataset_transactions.sql   → Simulated dataset (50 transactions, 5 clients, inline CTE)
    ├── 02_transactions_enriched.sql  → Row-level enrichment with window functions
    └── 03_business_playbook.sql      → Business questions answered with analytical SQL
```

---

## How to Run

Each file is **self-contained** — copy the full content into [BigQuery Sandbox](https://console.cloud.google.com/bigquery) and click **Run**. No table creation or CSV import needed. All data is defined inline via a `WITH` CTE.

> File `01` can be used to preview the raw dataset.  
> Files `02` and `03` each embed the dataset and run independently.

---

## Concepts Covered

| File | SQL Concepts |
|---|---|
| `01_dataset_transactions.sql` | CTE (`WITH`), inline data generation |
| `02_transactions_enriched.sql` | `ROW_NUMBER`, `LAG`, `DENSE_RANK`, `SUM() OVER`, `COUNT() OVER`, `MIN/MAX() OVER`, named `WINDOW` clause, `ROWS BETWEEN` frame |
| `03_business_playbook.sql` | `GROUP BY` aggregation, conditional `SUM` (`CASE WHEN`), `SAFE_DIVIDE`, `FORMAT_DATE`, `LAG` on monthly aggregates, `AVG() OVER`, MoM trend analysis, customer segmentation |

---

## Business Playbook — Queries at a Glance

| # | Business Question | Use Case |
|---|---|---|
| Q1 | Monthly cashflow per client | PFM dashboard, financial stress detection |
| Q2 | Savings rate per client per month | Credit scoring, investment product targeting |
| Q3 | Spending share per category | Customer profiling, rent burden flagging |
| Q4 | Month-over-month spending trend | Over-indebtedness early warning |
| Q5 | Anomalous transactions vs client baseline | Fraud detection, unusual spend alerts |

---

## Author

**Lisa Momas** — Digital Analytics & Data  
[LinkedIn](https://www.linkedin.com/in/lisa-momas-69518b177)
