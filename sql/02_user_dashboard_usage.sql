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