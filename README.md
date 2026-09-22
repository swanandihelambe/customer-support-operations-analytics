# Customer Support Operations Analytics

## Project Overview

Customer Support Operations Analytics is an end-to-end data analytics project that analyzes customer support ticket data to understand support workload, resolution efficiency, backlog, reopen rates, SLA performance, and customer satisfaction.

The project uses **Python, PostgreSQL, and SQL** to transform raw support ticket data into operational KPIs, visualizations, and business-oriented insights.

> **Dataset note:** The project uses a synthetic customer-support dataset containing 100,000 tickets. The findings are intended for analytics practice and portfolio demonstration rather than representing a real company's support operations.

---

## Objectives

The project focuses on answering key customer-support operations questions:

- How does support workload change over time?
- What is the overall resolution and backlog rate?
- How does priority affect resolution time?
- Which issue types have higher reopen rates?
- Which issue types have lower or higher customer satisfaction?
- Which product-area and issue-type combinations create backlog hotspots?
- Which priority and issue combinations take longer to resolve?
- How can operational teams use these findings for workload planning and process improvement?

---

## Dataset

**Source:** Kaggle — Synthetic IT Support Tickets

**Dataset size:**
- 100,000 tickets
- 20 original columns
- Time period: 2022–2025

The dataset contains information about:

- Ticket creation
- Customer segment
- Support channel
- Product area
- Issue type
- Priority
- Ticket status
- SLA plan
- Resolution time
- Reopen status
- Customer sentiment
- CSAT score
- Platform
- Region

---

## Tech Stack

| Technology | Purpose |
|---|---|
| Python | Data cleaning, feature engineering and EDA |
| Pandas | Data manipulation and analysis |
| NumPy | Numerical operations |
| Matplotlib | Data visualization |
| Seaborn | Statistical visualizations |
| PostgreSQL | Analytical database |
| SQL | KPI analysis and operational queries |
| Jupyter Notebook | Analysis workflow |
| SQLAlchemy | PostgreSQL connectivity |
| psycopg2 | PostgreSQL driver |

---

## Project Architecture

```text
Raw Dataset
     │
     ▼
Data Cleaning
     │
     ▼
Feature Engineering
     │
     ▼
Cleaned CSV
     │
     ▼
PostgreSQL
     │
     ├──────────────► SQL Analysis
     │
     └──────────────► Python EDA
                            │
                            ▼
                     Operational KPIs
                            │
                            ▼
                  Business Insights
```

---

## Project Structure

```text
Customer Support Operations Analytics/
│
├── data/
│   ├── raw/
│   │   └── synthetic_it_support_tickets.csv
│   │
│   └── cleaned/
│       └── customer_support_cleaned.csv
│
├── notebooks/
│   └── customer_support_analysis.ipynb
│
├── sql/
│   └── support_analysis.sql
│
├── src/
│   └── data_cleaning.py
│
├── visualizations/
│   ├── monthly_ticket_volume.png
│   ├── resolution_time_by_priority.png
│   ├── reopen_rate_by_issue_type.png
│   ├── average_csat_by_issue_type.png
│   ├── backlog_by_status.png
│   ├── resolution_time_heatmap.png
│   └── backlog_rate_heatmap.png
│
├── README.md
└── requirements.txt
```

---

## Data Cleaning & Feature Engineering

The raw dataset was processed using Python before being loaded into PostgreSQL.

### Data Quality Checks

The analysis included:

- Duplicate ticket ID validation
- Timestamp validation
- Missing-value analysis
- Categorical-value validation
- Binary-field validation
- Numerical-value inspection

### Missing Values

`resolution_time_hours` and `resolution_summary` are missing for unresolved tickets.

These values were **not imputed**, because missing resolution time represents unresolved support work rather than an unknown completed value.

Missing `region` values were replaced with:

```text
Unknown
```

### Engineered Features

The following features were created:

- `year`
- `month`
- `quarter`
- `day_of_week`
- `hour`
- `is_resolved`
- `is_backlog`
- `resolution_time_band`

The operational definition used in the project is:

**Resolved:**
- `resolved`
- `closed_no_action`

**Backlog:**
- `open`
- `in_progress`
- `on_hold`

---

## Key KPIs

| KPI | Value |
|---|---:|
| Total Tickets | 100,000 |
| Resolved Tickets | 60,113 |
| Backlog Tickets | 39,887 |
| Resolution Rate | 60.11% |
| Reopen Rate | 5.04% |
| Average Resolution Time | 45.01 hours |
| Average CSAT | 2.24 |

---

## SQL Analysis

The PostgreSQL analysis covers:

1. Overall support KPIs
2. Channel performance
3. Priority analysis
4. Issue-type analysis
5. Product-area analysis
6. SLA-plan analysis
7. Monthly support trends
8. Reopen-rate analysis
9. Priority × issue-type resolution bottlenecks
10. Backlog composition by status and priority
11. Product-area × issue-type backlog hotspots
12. Product-area × issue-type backlog rates

Advanced SQL concepts used include:

- `GROUP BY`
- Aggregate functions
- `CASE`
- Common Table Expressions (CTEs)
- Window functions
- `RANK()`
- Percentage calculations
- Multi-dimensional analysis

---

## Exploratory Data Analysis

Python was used to create visualizations for:

### Monthly Ticket Volume

Shows support workload patterns across the 2022–2025 period.

### Resolution Time by Priority

Shows how average resolution time changes across priority levels.

### Reopen Rate by Issue Type

Compares the percentage of reopened tickets across issue categories.

### Customer Satisfaction by Issue Type

Compares average CSAT across different issue types.

### Backlog Composition

Shows the distribution of unresolved tickets across:

- In progress
- On hold
- Open

### Resolution Time Heatmap

Combines priority and issue type to identify resolution-time patterns.

### Backlog Rate Heatmap

Combines product area and issue type to identify higher-backlog combinations.

---

## Key Findings

### 1. Stable Support Workload

Monthly ticket volume remained broadly within the 1,800–2,200 range across 2022–2025, without a sustained upward or downward trend.

### 2. Priority and Resolution Time

Resolution time varied substantially by priority.

- Urgent: approximately 26.7 hours
- High: approximately 31.6 hours
- Medium: approximately 43.3 hours
- Low: approximately 55.6 hours

However, resolution rates remained close to 60% across priority levels.

### 3. Customer Satisfaction Differences

Average CSAT varied noticeably across issue types.

`how_to` and `feature_request` tickets had higher average CSAT, while `account_access`, `performance`, and `security_concern` had lower average CSAT.

### 4. Backlog Composition

There were 39,887 backlog tickets.

Approximately half of the backlog was in `in_progress` status, followed by `on_hold` and `open`.

### 5. Product × Issue Backlog Hotspots

Several product-area and issue-type combinations had backlog rates above 40%.

This shows why analyzing multiple operational dimensions together can reveal patterns that may not appear in overall KPIs.

### 6. Priority × Issue Bottlenecks

The slowest issue type differed across priority levels.

This suggests that operational bottlenecks should be analyzed using both priority and issue type rather than relying only on overall averages.

### 7. Reopen Rate

Reopen rates were relatively close across issue types, ranging from approximately 4.8% to 5.3%.

---

## Business Recommendations

Based on the analysis:

- Review backlog at the **product-area × issue-type** level.
- Investigate issue categories associated with lower customer satisfaction.
- Use **priority × issue-type** analysis when planning workload routing and operational resources.
- Monitor the large `in_progress` backlog segment.
- Use historical monthly workload as a baseline for capacity planning.
- Evaluate reopen rate alongside resolution time, backlog, and CSAT rather than using it as a standalone KPI.

These recommendations represent data-informed areas for further investigation rather than causal conclusions.

---

## Skills Demonstrated

### Data Analytics
- Data cleaning
- Exploratory data analysis
- KPI development
- Trend analysis
- Operational analysis
- Business insight generation

### SQL
- PostgreSQL
- Aggregations
- CTEs
- Window functions
- Ranking
- Multi-dimensional analysis

### Python
- Pandas
- NumPy
- Matplotlib
- Seaborn
- Jupyter Notebook

### Data Engineering Foundations
- Raw → cleaned data pipeline
- Structured database loading
- Relational data modeling
- SQL-based analytical workflows

---

## How to Run

### 1. Clone the repository

```bash
git clone <repository-url>
cd "Customer Support Operations Analytics"
```

### 2. Create a virtual environment

```bash
python -m venv venv
```

### 3. Activate the environment

Windows:

```bash
venv\Scripts\activate
```

### 4. Install dependencies

```bash
pip install -r requirements.txt
```

### 5. Run the data-cleaning script

```bash
python src\data_cleaning.py
```

### 6. PostgreSQL Setup

Create a PostgreSQL database named:

```text
customer_support_analytics
```

Create the `support_tickets` table using the schema developed for the project, then load the cleaned CSV and execute the analytical queries in:

```text
sql/support_analysis.sql
```

### 7. Run the Notebook

Open:

```text
notebooks/customer_support_analysis.ipynb
```

and run the analysis cells using the project virtual environment.

---

## Project Outcome

This project demonstrates an end-to-end customer-support analytics workflow, from raw synthetic ticket data through cleaning, PostgreSQL data storage, SQL analysis, Python-based EDA, KPI development, visualization, and business-oriented recommendations.
