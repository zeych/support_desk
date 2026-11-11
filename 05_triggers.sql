CREATE TRIGGER trg_request_updated_at
ON
requests
AFTER
UPDATE
    AS
BEGIN
        SET
        NOCOUNT ON;
        
        UPDATE
    r
SET
    r.updated_at = GETDATE()
FROM
    requests r
JOIN inserted i ON
    r.request_id = i.request_id;
END;
-- Триггер автообновления updated_at — отдельный батч (GO до и после),
-- иначе будет ошибка 'CREATE TRIGGER must be the first statement in a query batch'
CREATE TRIGGER trg_requests_updated
ON
requests
AFTER
UPDATE
    AS
BEGIN
        SET
        NOCOUNT ON;
        
        UPDATE
    r
SET
    updated_at = SYSDATETIME()
FROM
    requests r
INNER JOIN inserted i ON
    r.request_id = i.request_id
WHERE
    r.updated_at <> i.updated_at
    OR (r.updated_at IS NULL
        AND i.updated_at IS NOT NULL);
END;
