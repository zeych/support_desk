-- dbo.v_requests_full исходный текст

ALTER VIEW v_requests_full AS
SELECT
    r.request_id,
    r.title,
    c.name AS category,
    cl.full_name AS client,
    e.full_name AS executor,
    r.priority,
    r.status,
    r.created_at
FROM
    requests r
JOIN categories c ON
    r.category_id = c.category_id
JOIN clients cl ON
    r.client_id = cl.client_id
LEFT JOIN employees e ON
    r.assigned_to = e.employee_id;
-- dbo.v_stats_by_category исходный текст

ALTER VIEW v_stats_by_category
AS
SELECT
    cat.name AS category_name,
    COUNT(r.request_id) AS total_requests,
    SUM(CASE WHEN r.status = 'new' THEN 1 ELSE 0 END) AS new_count,
    SUM(CASE WHEN r.status = 'in_progress' THEN 1 ELSE 0 END) AS in_progress_count,
    SUM(CASE WHEN r.status = 'done' THEN 1 ELSE 0 END) AS done_count,
    SUM(CASE WHEN r.status = 'waiting' THEN 1 ELSE 0 END) AS waiting_count
FROM
    categories cat
LEFT JOIN requests r ON
    cat.category_id = r.category_id
GROUP BY
    cat.category_id,
    cat.name;
