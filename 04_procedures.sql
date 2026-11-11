CREATE PROCEDURE sp_assign_employee
    @p_request_id INT,
    @p_employee_id INT
AS
BEGIN
    SET
    NOCOUNT ON;
    
    IF NOT EXISTS (
    SELECT
        1
    FROM
        requests
    WHERE
        request_id = @p_request_id)
        THROW 50002,
    N'Заявка не найдена',
    1;

IF NOT EXISTS (
SELECT
    1
FROM
    employees
WHERE
    employee_id = @p_employee_id
    AND is_active = 1)
        THROW 50003,
N'Сотрудник не найден или неактивен',
1;

UPDATE
    requests
SET
    assigned_to = @p_employee_id,
        status = CASE
        WHEN status = 'new' THEN 'in_progress'
        ELSE status
    END
WHERE
    request_id = @p_request_id;
END;

CREATE PROCEDURE sp_change_status
    @p_request_id INT,
@p_new_status VARCHAR(30),
@p_user_id INT
AS
BEGIN
    SET
    NOCOUNT ON;
    
    IF @p_new_status NOT IN ('new', 'in_progress', 'waiting', 'done', 'cancelled')
        THROW 50001,
    N'Недопустимый статус',
    1;

IF NOT EXISTS (
SELECT
    1
FROM
    requests
WHERE
    request_id = @p_request_id)
        THROW 50002,
N'Заявка не найдена',
1;

UPDATE
    requests
SET
    status = @p_new_status
WHERE
    request_id = @p_request_id;
END;

CREATE PROCEDURE sp_create_request
    @p_client_id INT,
@p_category_id INT,
@p_created_by INT,
@p_title NVARCHAR(200),
@p_description NVARCHAR(MAX) = NULL,
@p_request_id INT OUTPUT
AS
BEGIN
    SET
    NOCOUNT ON;
    
    INSERT
    INTO
    requests (client_id,
    category_id,
    created_by,
    title,
    description,
    status)
VALUES (@p_client_id,
@p_category_id,
@p_created_by,
@p_title,
@p_description,
'new');

SET
@p_request_id = SCOPE_IDENTITY();
END;
