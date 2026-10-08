-- Tab 1: Access & Roles Overview
SELECT 
    u.id AS user_id,
    u.first_name || ' ' || u.last_name AS full_name,
    u.username,
    u.email,
    CASE WHEN u.active = true THEN 'Active' ELSE 'Inactive' END AS account_status,
    u.created_on AS user_created_date,
    u.last_login,
    COALESCE(r.name, 'No Role Assigned') AS role_name
FROM ab_user u
LEFT JOIN ab_user_role ur ON u.id = ur.user_id
LEFT JOIN ab_role r ON ur.role_id = r.id;