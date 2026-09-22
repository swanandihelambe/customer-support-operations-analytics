-- ============================================================
-- Customer Support Operations Analytics
-- SQL Analysis
-- Database: customer_support_analytics
-- Table: support_tickets
-- ============================================================

-- Final analytical queries for customer support operations.
-- Data validation and exploratory checks were performed
-- separately during the Python data-quality assessment.


-- ============================================================
-- 1. Overall Support Operations KPIs
-- ============================================================
-- Business Question:
-- What is the overall operational performance of the support system?


SELECT
    COUNT(*) AS total_tickets,
    SUM(is_resolved) AS resolved_tickets,
    SUM(is_backlog) AS backlog_tickets,
    ROUND(100.0 * SUM(is_resolved) / COUNT(*), 2)
        AS resolution_rate_pct,
    ROUND(100.0 * SUM(reopened) / COUNT(*), 2)
        AS reopen_rate_pct,
    ROUND(AVG(resolution_time_hours), 2)
        AS avg_resolution_time_hours,
    ROUND(AVG(csat_score), 2)
        AS avg_csat
FROM support_tickets;


-- ============================================================
-- 2. Ticket Volume and Performance by Channel
-- ============================================================
-- Business Question:
-- How do workload and operational outcomes differ across
-- support channels?

SELECT
    channel,
    COUNT(*) AS total_tickets,
    SUM(is_resolved) AS resolved_tickets,
    SUM(is_backlog) AS backlog_tickets,
    ROUND(100.0 * SUM(is_resolved) / COUNT(*), 2)
        AS resolution_rate_pct,
    ROUND(AVG(resolution_time_hours), 2)
        AS avg_resolution_time_hours,
    ROUND(AVG(csat_score), 2)
        AS avg_csat
FROM support_tickets
GROUP BY channel
ORDER BY total_tickets DESC;


-- ============================================================
-- 3. Operational Performance by Priority
-- ============================================================
-- Business Question:
-- How does ticket priority relate to resolution efficiency,
-- backlog, reopen rate, and CSAT?

SELECT
    priority,
    COUNT(*) AS total_tickets,
    SUM(is_resolved) AS resolved_tickets,
    SUM(is_backlog) AS backlog_tickets,
    ROUND(100.0 * SUM(is_resolved) / COUNT(*), 2)
        AS resolution_rate_pct,
    ROUND(AVG(resolution_time_hours), 2)
        AS avg_resolution_time_hours,
    ROUND(AVG(reopened) * 100, 2)
        AS reopen_rate_pct,
    ROUND(AVG(csat_score), 2)
        AS avg_csat
FROM support_tickets
GROUP BY priority
ORDER BY
    CASE priority
        WHEN 'urgent' THEN 1
        WHEN 'high' THEN 2
        WHEN 'medium' THEN 3
        WHEN 'low' THEN 4
    END;


-- ============================================================
-- 4. Support Performance by Issue Type
-- ============================================================
-- Business Question:
-- Which issue types differ in workload, resolution efficiency,
-- reopen rate, and customer satisfaction?

SELECT
    issue_type,
    COUNT(*) AS total_tickets,
    SUM(is_resolved) AS resolved_tickets,
    SUM(is_backlog) AS backlog_tickets,
    ROUND(100.0 * SUM(is_resolved) / COUNT(*), 2)
        AS resolution_rate_pct,
    ROUND(AVG(resolution_time_hours), 2)
        AS avg_resolution_time_hours,
    ROUND(AVG(reopened) * 100, 2)
        AS reopen_rate_pct,
    ROUND(AVG(csat_score), 2)
        AS avg_csat
FROM support_tickets
GROUP BY issue_type
ORDER BY total_tickets DESC;


-- ============================================================
-- 5. Performance by Product Area
-- ============================================================
-- Business Question:
-- Which product areas show differences in support workload
-- and operational outcomes?

SELECT
    product_area,
    COUNT(*) AS total_tickets,
    SUM(is_resolved) AS resolved_tickets,
    SUM(is_backlog) AS backlog_tickets,
    ROUND(100.0 * SUM(is_resolved) / COUNT(*), 2)
        AS resolution_rate_pct,
    ROUND(AVG(resolution_time_hours), 2)
        AS avg_resolution_time_hours,
    ROUND(AVG(reopened) * 100, 2)
        AS reopen_rate_pct,
    ROUND(AVG(csat_score), 2)
        AS avg_csat
FROM support_tickets
GROUP BY product_area
ORDER BY total_tickets DESC;


-- ============================================================
-- 6. SLA Plan Performance
-- ============================================================
-- Business Question:
-- How do different SLA plans compare across operational KPIs?

SELECT
    sla_plan,
    COUNT(*) AS total_tickets,
    SUM(is_resolved) AS resolved_tickets,
    SUM(is_backlog) AS backlog_tickets,
    ROUND(100.0 * SUM(is_resolved) / COUNT(*), 2)
        AS resolution_rate_pct,
    ROUND(AVG(resolution_time_hours), 2)
        AS avg_resolution_time_hours,
    ROUND(AVG(reopened) * 100, 2)
        AS reopen_rate_pct,
    ROUND(AVG(csat_score), 2)
        AS avg_csat
FROM support_tickets
GROUP BY sla_plan
ORDER BY
    CASE sla_plan
        WHEN 'platinum' THEN 1
        WHEN 'gold' THEN 2
        WHEN 'standard' THEN 3
    END;


-- ============================================================
-- 7. Monthly Support Workload Trend
-- ============================================================
-- Business Question:
-- How does ticket workload and resolution performance change
-- over time?

SELECT
    year,
    month,
    COUNT(*) AS total_tickets,
    SUM(is_resolved) AS resolved_tickets,
    SUM(is_backlog) AS backlog_tickets,
    ROUND(100.0 * SUM(is_resolved) / COUNT(*), 2)
        AS resolution_rate_pct
FROM support_tickets
GROUP BY year, month
ORDER BY year, month;


-- ============================================================
-- 8. Reopen Rate by Issue Type
-- ============================================================
-- Business Question:
-- Which issue types have relatively higher reopen rates?

SELECT
    issue_type,
    COUNT(*) AS total_tickets,
    SUM(reopened) AS reopened_tickets,
    ROUND(100.0 * SUM(reopened) / COUNT(*), 2)
        AS reopen_rate_pct,
    ROUND(AVG(resolution_time_hours), 2)
        AS avg_resolution_time_hours,
    ROUND(AVG(csat_score), 2)
        AS avg_csat
FROM support_tickets
GROUP BY issue_type
ORDER BY reopen_rate_pct DESC;


-- ============================================================
-- 9. Top 3 Slowest Issue Types Within Each Priority
-- ============================================================
-- Business Question:
-- Which issue types take the longest to resolve within each
-- priority level?
--
-- Demonstrates:
-- CTE + Window Function + Partitioned Ranking

WITH issue_priority AS (
    SELECT
        priority,
        issue_type,
        COUNT(*) AS total_tickets,
        ROUND(AVG(resolution_time_hours), 2)
            AS avg_resolution_time_hours
    FROM support_tickets
    WHERE resolution_time_hours IS NOT NULL
    GROUP BY priority, issue_type
),
ranked_issues AS (
    SELECT
        *,
        RANK() OVER (
            PARTITION BY priority
            ORDER BY avg_resolution_time_hours DESC
        ) AS resolution_rank
    FROM issue_priority
)
SELECT
    priority,
    issue_type,
    total_tickets,
    avg_resolution_time_hours,
    resolution_rank
FROM ranked_issues
WHERE resolution_rank <= 3
ORDER BY
    CASE priority
        WHEN 'urgent' THEN 1
        WHEN 'high' THEN 2
        WHEN 'medium' THEN 3
        WHEN 'low' THEN 4
    END,
    resolution_rank;


-- ============================================================
-- 10. Backlog Composition by Status and Priority
-- ============================================================
-- Business Question:
-- What does the current support backlog consist of?

SELECT
    status,
    priority,
    COUNT(*) AS backlog_tickets,
    ROUND(
        100.0 * COUNT(*) /
        SUM(COUNT(*)) OVER (),
        2
    ) AS backlog_share_pct
FROM support_tickets
WHERE is_backlog = 1
GROUP BY status, priority
ORDER BY backlog_tickets DESC;


-- ============================================================
-- 11. Top Product + Issue Backlog Hotspots
-- ============================================================
-- Business Question:
-- Which product-area and issue-type combinations generate
-- the largest backlog volumes?
--
-- Demonstrates:
-- CTE + Window Function

WITH backlog_analysis AS (
    SELECT
        product_area,
        issue_type,
        COUNT(*) AS total_tickets,
        SUM(is_backlog) AS backlog_tickets,
        ROUND(
            100.0 * SUM(is_backlog) / COUNT(*),
            2
        ) AS backlog_rate_pct
    FROM support_tickets
    GROUP BY product_area, issue_type
),
ranked AS (
    SELECT
        *,
        RANK() OVER (
            ORDER BY backlog_tickets DESC
        ) AS backlog_rank
    FROM backlog_analysis
)
SELECT
    product_area,
    issue_type,
    total_tickets,
    backlog_tickets,
    backlog_rate_pct,
    backlog_rank
FROM ranked
WHERE backlog_rank <= 10
ORDER BY backlog_rank;


-- ============================================================
-- 12. Backlog Rate by Product Area and Issue Type
-- ============================================================
-- Business Question:
-- Which product + issue combinations have the highest
-- proportion of tickets remaining in backlog?

SELECT
    product_area,
    issue_type,
    COUNT(*) AS total_tickets,
    SUM(is_backlog) AS backlog_tickets,
    ROUND(
        100.0 * SUM(is_backlog) / COUNT(*),
        2
    ) AS backlog_rate_pct
FROM support_tickets
GROUP BY product_area, issue_type
ORDER BY backlog_rate_pct DESC;