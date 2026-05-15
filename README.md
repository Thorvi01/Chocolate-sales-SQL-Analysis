# 🍫 Chocolate Sales SQL Analysis (2023–2024)

**Author:** Dishaa  
**Tools:** PostgreSQL · Supabase · SQL  
**Dataset:** Chocolate Sales Dataset 2023–2024 (Kaggle)  
**Status:** Completed

---

## 📌 Project Overview

This is an end-to-end SQL analytics project analysing 2 years of chocolate sales data across 100 stores, 200 products, 6 brands, and 50,000 customers. The project covers the full data analytics workflow — from data quality checks to advanced window function analysis — and answers real business questions a Data Scientist would face in industry.

---

## 📂 Dataset Description

The dataset consists of 5 relational tables hosted on Supabase (PostgreSQL):

| Table | Rows | Description |
|---|---|---|
| `sales` | 416,898 | Core transaction records |
| `customers` | 50,000 | Customer demographics |
| `products` | 200 | Product details by brand and category |
| `stores` | 100 | Store locations and types |
| `calendar` | 731 | Date dimension table (2023–2024) |

---

## 🛠️ Tools Used

- **Database:** PostgreSQL via Supabase (cloud-hosted)
- **Query Editor:** Supabase SQL Editor
- **Language:** SQL (PostgreSQL dialect)
- **Portfolio:** GitHub

---

## 🔍 Phase 1 — Data Quality & Exploration

Before any analysis, a full data quality audit was performed.

**Checks Performed:**
- NULL values across all critical columns
- Duplicate order IDs
- Orphaned foreign keys (product IDs in sales not matching products table)

**Findings:**

| Check | Result |
|---|---|
| NULL values in critical columns | ✅ 0 found |
| Duplicate order IDs | ✅ 0 found |
| Invalid product IDs | ⚠️ 2 found — P0000 and P0201 |
| Affected transactions | ⚠️ 4,051 rows excluded |
| Clean records for analysis | ✅ 412,847 |

**Decision:** All 4,051 transactions linked to P0000 and P0201 were excluded from analysis as these product IDs have no matching records in the products table, making them unanalysable.

---

## 📊 Phase 2 — Aggregations & Business Performance

### Overall Business Summary

| Metric | Value |
|---|---|
| Total Revenue | $10,517,916 |
| Total Cost | $6,310,228 |
| Total Profit | $4,207,684 |
| Overall Profit Margin | ~40% |

### Revenue by Category

| Rank | Category | Revenue | Profit | Margin |
|---|---|---|---|---|
| 1 | Praline | $2,771,990 | $1,108,494 | 39.99% |
| 2 | White | $2,541,459 | $1,016,610 | 40.00% |
| 3 | Dark | $2,198,899 | $880,507 | 40.04% |
| 4 | Truffle | $1,632,119 | $652,877 | 40.00% |
| 5 | Milk | $1,373,447 | $549,193 | 39.99% |

> 💡 **Insight:** Praline leads in revenue but all 5 categories maintain an almost identical ~40% profit margin — a difference of only 0.05% between highest and lowest. This suggests a highly standardised pricing strategy across the product range.

### Revenue by Brand

| Rank | Brand | Revenue | Profit | Margin |
|---|---|---|---|---|
| 1 | Ferrero | $1,948,627 | $779,985 | 40.03% |
| 2 | Cadbury | $1,944,689 | $777,266 | 39.97% |
| 3 | Lindt | $1,845,882 | $739,638 | 40.07% |
| 4 | Mars | $1,731,743 | $692,437 | 39.99% |
| 5 | Godiva | $1,575,865 | $629,868 | 39.97% |
| 6 | Hershey | $1,471,107 | $588,486 | 40.00% |

> 💡 **Insight:** Ferrero narrowly leads Cadbury by just $3,937 in revenue — an extremely close competition at the top. All 6 brands maintain ~40% margins, confirming uniform pricing across brands as well as categories.

### Store Performance

| Metric | Value |
|---|---|
| Top Store | Chocolate Store 100 — $109,358 |
| Bottom Store | Chocolate Store 4 — $100,641 |
| Revenue Range | $8,717 difference across all 100 stores |

> 💡 **Insight:** All 100 stores perform remarkably consistently with less than 9% difference between the best and worst performing store — indicating strong operational standardisation across locations.

---

## 🔎 Phase 3 — Filtering & Conditional Logic

### Discount Tier Analysis

| Discount Tier | Orders | Units Sold | Revenue |
|---|---|---|---|
| No Discount (0%) | 260,530 | 780,716 | $7,030,387 |
| Medium (11–25%) | 104,136 | 312,792 | $2,323,980 |
| Low (1–10%) | 52,232 | 156,356 | $1,266,708 |

> 💡 **Insight:** 63% of all sales occur with zero discount applied. This suggests the products sell well at full price and heavy discounting is not a key driver of sales volume.

### Loyalty vs Regular Customers
- Loyalty member spending patterns were analysed using CASE WHEN segmentation
- Customers segmented into loyalty vs regular groups across all 50,000 customers

---

## 🧮 Phase 4 — CTEs & Subqueries

### Revenue Contribution by Category
Each category's percentage contribution to total revenue was calculated using a subquery inside SELECT.

### Customer Age Segmentation

| Segment | Age Range |
|---|---|
| Gen Z | Under 25 |
| Millennials | 25–40 |
| Gen X | 41–56 |
| Boomers+ | 57+ |

Customer spending behaviour was analysed across all 4 age groups using CTEs.

### Top 5 Products Per Brand
Using `DENSE_RANK()` window function inside a CTE, the top 5 revenue-generating products were identified for each of the 6 brands.

**Top Product Overall:** Lindt P0122 — $56,079 (highest single product revenue across all brands)

---

## 📈 Phase 5 — Window Functions

### Month-over-Month Revenue Growth
`LAG()` window function used to compare each month's revenue against the previous month, calculating both absolute and percentage growth.

### Running Total of Revenue
Cumulative revenue tracked daily across the full 2-year period using `SUM() OVER()`:

| Milestone | Date |
|---|---|
| $1M cumulative revenue | March 2023 |
| $5M cumulative revenue | December 2023 |
| $10M cumulative revenue | November 2024 |
| Final cumulative revenue | $10,621,076 (Dec 31 2024) |

> 💡 **Insight:** The business generated its first $5M in 12 months (2023) and its second $5M in 11 months (2024) — indicating slight but consistent revenue growth year over year.

### Store Rankings by Country
`DENSE_RANK() OVER(PARTITION BY country)` used to rank stores within each country by revenue performance.

---

## 💡 Key Business Insights Summary

1. **Uniform ~40% profit margin** across all categories and brands — pricing strategy is highly consistent and standardised
2. **Praline is the top category** by revenue ($2.77M) but holds no margin advantage over other categories
3. **Ferrero vs Cadbury** — an extremely tight race at the top with only $3,937 separating them
4. **63% of sales require no discount** — strong full-price demand across the product range
5. **All 100 stores perform consistently** — less than 9% revenue gap between best and worst store
6. **Business crossed $10M cumulative revenue** in November 2024
7. **Data quality issue identified** — 4,051 transactions (1% of data) linked to invalid product IDs excluded from analysis

---

## 🧠 SQL Concepts Demonstrated

| Concept | Used In |
|---|---|
| SELECT, FROM, WHERE, GROUP BY, ORDER BY | All phases |
| IS NULL, IS NOT NULL | Phase 1 |
| COUNT DISTINCT | Phase 1 |
| LEFT JOIN with NULL detection | Phase 1 |
| NOT IN | Phase 1 |
| SUM, AVG, ROUND, MIN, MAX | Phase 2 |
| Type casting (::numeric) | Phase 2 |
| Table aliases | Phase 2 |
| CASE WHEN | Phase 3 |
| EXTRACT(YEAR) for date filtering | Phase 3 |
| Subqueries | Phase 4 |
| CTEs (WITH clause) | Phase 4 |
| DENSE_RANK() OVER(PARTITION BY) | Phase 4 & 5 |
| LAG() for time series comparison | Phase 5 |
| SUM() OVER() for running totals | Phase 5 |
| DATE_TRUNC for monthly aggregation | Phase 5 |

---

## 📁 Repository Structure

```
chocolate-sales-sql-analysis/
│
├── README.md
├── 01_data_exploration.sql
├── 02_aggregations.sql
├── 03_filtering_case_when.sql
├── 04_ctes_subqueries.sql
└── 05_window_functions.sql
```

---

*Project completed by Dishaa as part of an end-to-end SQL portfolio project using real-world chocolate sales data.*
