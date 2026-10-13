-- Tab 2: User Activity and Dashboard Usage
SELECT 
    l.id AS log_id,
    l.dttm AS event_timestamp,
    CAST(l.dttm AS DATE) AS event_date,
    u.username,
    u.first_name || ' ' || u.last_name AS user_full_name,
    d.id AS dashboard_id,
    COALESCE(d.dashboard_title, 'Direct Chart/Explore') AS dashboard_title,
    l.action,
    l.duration_ms
FROM logs l
JOIN ab_user u ON l.user_id = u.id
LEFT JOIN dashboards d ON l.dashboard_id = d.id
WHERE l.action IN ('dashboard', 'explore', 'explore_json');





-- View Action Telemetry: Users <-> Usage <-> Dashboard
SELECT 
    l.id AS log_id,
    l.dttm AS event_timestamp,
    l.dttm::date AS view_date,
    EXTRACT(HOUR FROM l.dttm)::int AS view_hour,
    
    -- User Mapping
    u.id AS user_id,
    CONCAT(u.first_name, ' ', u.last_name) AS user_name,
    u.email AS user_email,
    
    -- Dashboard Mapping
    d.id AS dashboard_id,
    COALESCE(d.dashboard_title, 'Direct / External View') AS dashboard_title,
    
    -- Action Filtering (Distinct View Actions)
    l.action AS raw_action,
    CASE 
        WHEN l.action IN ('dashboard', 'explore', 'explore_json') THEN 'View Action'
        ELSE 'Other Action'
    END AS action_category,
    
    l.duration_ms / 1000.0 AS response_time_seconds

FROM logs l
JOIN ab_user u 
    ON l.user_id = u.id
LEFT JOIN dashboards d 
    ON l.dashboard_id = d.id
WHERE 
    l.action IN ('dashboard', 'explore', 'explore_json')  -- Filter for distinct view actions only
    AND l.user_id IS NOT NULL;




    SELECT
    d.id               AS dashboard_id,
    d.dashboard_title  AS dashboard,
    u.username         AS "user",
    l.dttm             AS viewed_at,
    l.duration_ms      AS load_duration_ms
FROM logs l
JOIN dashboards d   ON d.id = l.dashboard_id
LEFT JOIN ab_user u ON u.id = l.user_id
WHERE l.action = 'dashboard'
ORDER BY l.dttm DESC;