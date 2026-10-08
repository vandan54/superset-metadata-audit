-- Tab 3: Dashboard Adoption & Performance Metrics
SELECT 
    d.id AS dashboard_id,
    d.dashboard_title,
    d.created_on AS dashboard_created_at,
    creator.username AS created_by_user,
    COUNT(l.id) AS total_views,
    COUNT(DISTINCT l.user_id) AS unique_viewers,
    MAX(l.dttm) AS last_accessed_at
FROM dashboards d
LEFT JOIN logs l ON d.id = l.dashboard_id AND l.action IN ('dashboard', 'explore_json')
LEFT JOIN ab_user creator ON d.created_by_fk = creator.id
GROUP BY d.id, d.dashboard_title, d.created_on, creator.username;