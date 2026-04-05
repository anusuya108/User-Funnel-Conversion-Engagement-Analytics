CREATE DATABASE user_funnel_project;
GO

USE user_funnel_project;
GO
-- ============================================================
-- 4. DATA VALIDATION
-- ============================================================

-- Run these after importing CSVs
SELECT COUNT(*) AS total_rows FROM dbo.session_master;
SELECT COUNT(*) AS total_rows FROM dbo.session_summary;
SELECT COUNT(*) AS total_rows FROM dbo.funnel_summary;
SELECT COUNT(*) AS total_rows FROM dbo.device_conversion;
SELECT COUNT(*) AS total_rows FROM dbo.source_conversion;
SELECT COUNT(*) AS total_rows FROM dbo.country_conversion;
SELECT COUNT(*) AS total_rows FROM dbo.engagement_comparison;
SELECT COUNT(*) AS total_rows FROM dbo.drop_off_analysis;
GO


-- ============================================================
-- 5. CORE KPI ANALYSIS
-- ============================================================

SELECT 
    COUNT(*) AS total_sessions,
    COUNT(DISTINCT user_id) AS total_users,
    SUM(purchased) AS total_purchases,
    ROUND(SUM(purchased) * 100.0 / COUNT(*), 2) AS overall_conversion_rate_pct
FROM dbo.session_master;
GO


-- ============================================================
-- 6. FUNNEL ANALYSIS
-- ============================================================

-- 6.1 Funnel stage counts
SELECT
    SUM(visited_home) AS home_sessions,
    SUM(visited_product_page) AS product_page_sessions,
    SUM(visited_cart) AS cart_sessions,
    SUM(visited_checkout) AS checkout_sessions,
    SUM(visited_confirmation) AS confirmation_sessions,
    SUM(purchased) AS purchased_sessions
FROM dbo.session_master;
GO

-- 6.2 Funnel conversion rates
SELECT
    ROUND(SUM(visited_product_page) * 100.0 / NULLIF(SUM(visited_home),0), 2) AS home_to_product_pct,
    ROUND(SUM(visited_cart) * 100.0 / NULLIF(SUM(visited_product_page),0), 2) AS product_to_cart_pct,
    ROUND(SUM(visited_checkout) * 100.0 / NULLIF(SUM(visited_cart),0), 2) AS cart_to_checkout_pct,
    ROUND(SUM(visited_confirmation) * 100.0 / NULLIF(SUM(visited_checkout),0), 2) AS checkout_to_confirmation_pct,
    ROUND(SUM(purchased) * 100.0 / NULLIF(SUM(visited_home),0), 2) AS overall_conversion_pct
FROM dbo.session_master;
GO

-- 6.3 Funnel table format (dashboard-ready)
SELECT 'Home' AS stage, SUM(visited_home) AS sessions FROM dbo.session_master
UNION ALL
SELECT 'Product Page', SUM(visited_product_page) FROM dbo.session_master
UNION ALL
SELECT 'Cart', SUM(visited_cart) FROM dbo.session_master
UNION ALL
SELECT 'Checkout', SUM(visited_checkout) FROM dbo.session_master
UNION ALL
SELECT 'Confirmation', SUM(visited_confirmation) FROM dbo.session_master
UNION ALL
SELECT 'Purchased', SUM(purchased) FROM dbo.session_master;
GO


-- ============================================================
-- 7. DEVICE PERFORMANCE ANALYSIS
-- ============================================================

SELECT
    device_type,
    COUNT(*) AS total_sessions,
    SUM(purchased) AS purchases,
    ROUND(SUM(purchased) * 100.0 / COUNT(*), 2) AS conversion_rate_pct
FROM dbo.session_master
GROUP BY device_type
ORDER BY conversion_rate_pct DESC;
GO


-- ============================================================
-- 8. REFERRAL SOURCE PERFORMANCE ANALYSIS
-- ============================================================

SELECT
    referral_source,
    COUNT(*) AS total_sessions,
    SUM(purchased) AS purchases,
    ROUND(SUM(purchased) * 100.0 / COUNT(*), 2) AS conversion_rate_pct
FROM dbo.session_master
GROUP BY referral_source
ORDER BY conversion_rate_pct DESC;
GO


-- ============================================================
-- 9. COUNTRY PERFORMANCE ANALYSIS
-- ============================================================

SELECT
    country,
    COUNT(*) AS total_sessions,
    SUM(purchased) AS purchases,
    ROUND(SUM(purchased) * 100.0 / COUNT(*), 2) AS conversion_rate_pct
FROM dbo.session_master
GROUP BY country
ORDER BY conversion_rate_pct DESC;
GO


-- ============================================================
-- 10. ENGAGEMENT ANALYSIS
-- ============================================================

-- 10.1 Engagement comparison between purchased and not purchased users
SELECT
    CASE 
        WHEN purchased = 1 THEN 'Purchased'
        ELSE 'Not Purchased'
    END AS purchase_status,

    ROUND(AVG(total_pages_visited), 2) AS avg_pages_visited,
    ROUND(AVG(total_time_spent_seconds), 2) AS avg_time_spent_seconds,
    ROUND(AVG(session_duration_minutes), 2) AS avg_session_duration_minutes,
    ROUND(AVG(max_items_in_cart), 2) AS avg_items_in_cart

FROM dbo.session_master
GROUP BY purchased;
GO

-- 10.2 Highly engaged but not converted users
SELECT *
FROM dbo.session_master
WHERE total_pages_visited >= 5
AND max_items_in_cart >= 2
AND purchased = 0;
GO

-- 10.3 Low engagement users
SELECT *
FROM dbo.session_master
WHERE total_pages_visited <= 2
AND session_duration_minutes < 1;
GO


-- ============================================================
-- 11. DROP-OFF ANALYSIS
-- ============================================================

SELECT
    last_page_visited,
    COUNT(*) AS sessions_dropped_here
FROM dbo.session_master
GROUP BY last_page_visited
ORDER BY sessions_dropped_here DESC;
GO


-- ============================================================
-- 12. ADVANCED SEGMENT ANALYSIS
-- ============================================================

-- 12.1 Device + Referral Source combined analysis
SELECT
    device_type,
    referral_source,
    COUNT(*) AS sessions,
    SUM(purchased) AS purchases,
    ROUND(SUM(purchased) * 100.0 / COUNT(*), 2) AS conversion_rate_pct
FROM dbo.session_master
GROUP BY device_type, referral_source
ORDER BY conversion_rate_pct DESC;
GO

-- 12.2 Top converting customer segments
SELECT
    device_type,
    country,
    referral_source,
    COUNT(*) AS sessions,
    SUM(purchased) AS purchases,
    ROUND(SUM(purchased) * 100.0 / COUNT(*), 2) AS conversion_rate_pct
FROM dbo.session_master
GROUP BY device_type, country, referral_source
HAVING COUNT(*) > 50
ORDER BY conversion_rate_pct DESC;
GO


-- ============================================================
-- 13. OPTIONAL SAVED VIEWS (SQL SERVER VERSION)
-- ============================================================

-- Drop old views first
DROP VIEW IF EXISTS dbo.vw_funnel_analysis;
DROP VIEW IF EXISTS dbo.vw_device_conversion;
DROP VIEW IF EXISTS dbo.vw_source_conversion;
DROP VIEW IF EXISTS dbo.vw_drop_off_analysis;
GO

-- Funnel view
CREATE VIEW dbo.vw_funnel_analysis AS
SELECT 'Home' AS stage, SUM(visited_home) AS sessions FROM dbo.session_master
UNION ALL
SELECT 'Product Page', SUM(visited_product_page) FROM dbo.session_master
UNION ALL
SELECT 'Cart', SUM(visited_cart) FROM dbo.session_master
UNION ALL
SELECT 'Checkout', SUM(visited_checkout) FROM dbo.session_master
UNION ALL
SELECT 'Confirmation', SUM(visited_confirmation) FROM dbo.session_master
UNION ALL
SELECT 'Purchased', SUM(purchased) FROM dbo.session_master;
GO

-- Device performance view
CREATE VIEW dbo.vw_device_conversion AS
SELECT
    device_type,
    COUNT(*) AS total_sessions,
    SUM(purchased) AS purchases,
    ROUND(SUM(purchased) * 100.0 / COUNT(*), 2) AS conversion_rate_pct
FROM dbo.session_master
GROUP BY device_type;
GO

-- Source performance view
CREATE VIEW dbo.vw_source_conversion AS
SELECT
    referral_source,
    COUNT(*) AS total_sessions,
    SUM(purchased) AS purchases,
    ROUND(SUM(purchased) * 100.0 / COUNT(*), 2) AS conversion_rate_pct
FROM dbo.session_master
GROUP BY referral_source;
GO

-- Drop-off view
CREATE VIEW dbo.vw_drop_off_analysis AS
SELECT
    last_page_visited,
    COUNT(*) AS sessions_dropped_here
FROM dbo.session_master
GROUP BY last_page_visited;
GO


-- ============================================================
-- END OF SQL SERVER SCRIPT
-- ============================================================

SELECT COLUMN_NAME
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_NAME = 'session_master'
AND TABLE_SCHEMA = 'dbo';


