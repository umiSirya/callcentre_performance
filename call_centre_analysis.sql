USE callcentre;
SELECT * FROM callcenter_clean LIMIT 10;
SELECT COUNT(*) AS total_rows FROM callcenter_clean

-- Overall KPIs
SELECT COUNT(*) AS total_records,
	   SUM(calls_handled) AS total_calls,
       ROUND(AVG(avg_aht/60), 2) AS avg_aht_mins,
       ROUND(AVG(std_pass) *100, 2) AS pass_rate_pct
	   FROM callcenter_clean;
       
       -- Performance by Agent
SELECT agent_id,
    SUM(calls_handled) AS total_calls,
    ROUND(AVG(avg_aht / 60), 2) AS avg_aht_mins,
    ROUND(AVG(std_pass) * 100, 2) AS pass_rate_pct
FROM callcenter_clean
GROUP BY agent_id
ORDER BY total_calls DESC;

-- Performance by product
SELECT product_id,
    SUM(calls_handled) AS total_calls,
    ROUND(AVG(avg_aht / 60), 2) AS avg_aht_mins,
    ROUND(AVG(std_pass) * 100, 2) AS pass_rate_pct
FROM callcenter_clean
GROUP BY product_id
ORDER BY total_calls DESC;

-- performance by language
SELECT lang_id,
    SUM(calls_handled) AS total_calls,
    ROUND(AVG(avg_aht / 60), 2) AS avg_aht_mins,
    ROUND(AVG(std_pass) * 100, 2) AS pass_rate_pct
FROM callcenter_clean
GROUP BY lang_id
ORDER BY total_calls DESC;

-- Monthly call volume trend
SELECT MONTH(date) AS month_num,
    MONTHNAME(date) AS month_name,
    SUM(calls_handled) AS total_calls,
    ROUND(AVG(avg_aht / 60), 2) AS avg_aht_mins,
    ROUND(AVG(std_pass) * 100, 2) AS pass_rate_pct
FROM callcenter_clean
GROUP BY MONTH(date), MONTHNAME(date)
ORDER BY month_num;

-- Top 3 Best Performing Agents
SELECT agent_id,
    SUM(calls_handled) AS total_calls,
    ROUND(AVG(avg_aht / 60), 2) AS avg_aht_mins,
    ROUND(AVG(std_pass) * 100, 2) AS pass_rate_pct
FROM callcenter_clean
GROUP BY agent_id
ORDER BY pass_rate_pct DESC
LIMIT 3;

-- Bottom 3 worst Performing Agents
SELECT agent_id,
    SUM(calls_handled) AS total_calls,
    ROUND(AVG(avg_aht / 60), 2) AS avg_aht_mins,
    ROUND(AVG(std_pass) * 100, 2) AS pass_rate_pct
FROM callcenter_clean
GROUP BY agent_id
ORDER BY pass_rate_pct ASC
LIMIT 3

-- Flagged Suspicious Calls
SELECT agent_id,
    date,
    product_id,
    calls_handled,
    ROUND(avg_aht / 60, 2) AS avg_aht_mins,
    std_pass
FROM callcenter_clean
WHERE avg_aht < 10
ORDER BY avg_aht ASC;

-- Peak Call Days
SELECT date,
    SUM(calls_handled) AS total_calls,
    ROUND(AVG(avg_aht / 60), 2) AS avg_aht_mins
FROM callcenter_clean
GROUP BY date
ORDER BY total_calls DESC
LIMIT 10;

-- Agents Performance summary
SELECT agent_id,
    COUNT(*) AS total_records,
    SUM(calls_handled) AS total_calls,
    ROUND(AVG(avg_aht / 60), 2) AS avg_aht_mins,
    ROUND(MIN(avg_aht / 60), 2) AS min_aht_mins,
    ROUND(MAX(avg_aht / 60), 2) AS max_aht_mins,
    ROUND(AVG(std_pass) * 100, 2) AS pass_rate_pct,
    SUM(low_aht_flag) AS suspicious_calls
FROM callcenter_clean
GROUP BY agent_id
ORDER BY pass_rate_pct DESC;
