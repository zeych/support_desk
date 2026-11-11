USE support_desk;
GO

-- =====================================
-- 1. СТРУКТУРА БАЗЫ ДАННЫХ
-- =====================================
-- support_desk.dbo.categories определение

-- Drop table

-- DROP TABLE support_desk.dbo.categories;

CREATE TABLE support_desk.dbo.categories (
	category_id int IDENTITY(1,1) NOT NULL,
	name nvarchar(100) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	description nvarchar(255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	is_active bit DEFAULT 1 NOT NULL,
	CONSTRAINT PK__categori__D54EE9B49F949AA1 PRIMARY KEY (category_id),
	CONSTRAINT UQ__categori__72E12F1B0BE51D14 UNIQUE (name)
);


-- support_desk.dbo.clients определение

-- Drop table

-- DROP TABLE support_desk.dbo.clients;

CREATE TABLE support_desk.dbo.clients (
	client_id int IDENTITY(1,1) NOT NULL,
	client_type varchar(20) COLLATE SQL_Latin1_General_CP1_CI_AS DEFAULT 'person' NOT NULL,
	full_name nvarchar(150) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	phone varchar(30) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	email varchar(100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	address nvarchar(255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	created_at datetime2 DEFAULT sysdatetime() NOT NULL,
	CONSTRAINT PK__clients__BF21A424C2FA772D PRIMARY KEY (client_id)
);
ALTER TABLE support_desk.dbo.clients WITH NOCHECK ADD CONSTRAINT chk_clients_type CHECK (([client_type]='organization' OR [client_type]='person'));


-- support_desk.dbo.employees определение

-- Drop table

-- DROP TABLE support_desk.dbo.employees;

CREATE TABLE support_desk.dbo.employees (
	employee_id int IDENTITY(1,1) NOT NULL,
	[login] varchar(50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	password_hash varchar(255) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	password_salt varchar(32) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	full_name nvarchar(150) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	email varchar(100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	phone varchar(30) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[position] nvarchar(100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[role] varchar(20) COLLATE SQL_Latin1_General_CP1_CI_AS DEFAULT 'operator' NOT NULL,
	is_active bit DEFAULT 1 NOT NULL,
	created_at datetime2 DEFAULT sysdatetime() NOT NULL,
	CONSTRAINT PK__employee__C52E0BA8DC894060 PRIMARY KEY (employee_id),
	CONSTRAINT UQ__employee__7838F272DF54F81E UNIQUE ([login])
);
ALTER TABLE support_desk.dbo.employees WITH NOCHECK ADD CONSTRAINT chk_employees_role CHECK (([role]='manager' OR [role]='operator' OR [role]='admin'));


-- support_desk.dbo.users определение

-- Drop table

-- DROP TABLE support_desk.dbo.users;

CREATE TABLE support_desk.dbo.users (
	user_id int IDENTITY(1,1) NOT NULL,
	[login] nvarchar(50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	password_salt nvarchar(32) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	password_hash nvarchar(64) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[role] nvarchar(20) COLLATE SQL_Latin1_General_CP1_CI_AS DEFAULT N'operator' NOT NULL,
	is_active bit DEFAULT 1 NOT NULL,
	created_at datetime2 DEFAULT sysdatetime() NOT NULL,
	CONSTRAINT PK__users__B9BE370FE84E9E9C PRIMARY KEY (user_id),
	CONSTRAINT UQ__users__7838F27229788CB4 UNIQUE ([login])
);
ALTER TABLE support_desk.dbo.users WITH NOCHECK ADD CONSTRAINT CK__users__role__267ABA7A CHECK (([role]=N'admin' OR [role]=N'manager' OR [role]=N'operator'));


-- support_desk.dbo.requests определение

-- Drop table

-- DROP TABLE support_desk.dbo.requests;

CREATE TABLE support_desk.dbo.requests (
	request_id int IDENTITY(1,1) NOT NULL,
	client_id int NOT NULL,
	category_id int NOT NULL,
	created_by int NOT NULL,
	assigned_to int NULL,
	title nvarchar(200) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	description nvarchar(MAX) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	status varchar(50) COLLATE SQL_Latin1_General_CP1_CI_AS DEFAULT 'new' NOT NULL,
	priority varchar(20) COLLATE SQL_Latin1_General_CP1_CI_AS DEFAULT 'normal' NOT NULL,
	created_at datetime2 DEFAULT sysdatetime() NOT NULL,
	updated_at datetime2 DEFAULT sysdatetime() NOT NULL,
	due_at datetime2 NULL,
	closed_at datetime2 NULL,
	CONSTRAINT PK__requests__18D3B90F7A781B44 PRIMARY KEY (request_id),
	CONSTRAINT fk_requests_assignee FOREIGN KEY (assigned_to) REFERENCES support_desk.dbo.employees(employee_id),
	CONSTRAINT fk_requests_category FOREIGN KEY (category_id) REFERENCES support_desk.dbo.categories(category_id),
	CONSTRAINT fk_requests_client FOREIGN KEY (client_id) REFERENCES support_desk.dbo.clients(client_id),
	CONSTRAINT fk_requests_creator FOREIGN KEY (created_by) REFERENCES support_desk.dbo.employees(employee_id)
);
 CREATE NONCLUSTERED INDEX idx_requests_assigned ON support_desk.dbo.requests (  assigned_to ASC  )  
	 WITH (  PAD_INDEX = OFF ,FILLFACTOR = 100  ,SORT_IN_TEMPDB = OFF , IGNORE_DUP_KEY = OFF , STATISTICS_NORECOMPUTE = OFF , ONLINE = OFF , ALLOW_ROW_LOCKS = ON , ALLOW_PAGE_LOCKS = ON  )
	 ON [PRIMARY ] ;
 CREATE NONCLUSTERED INDEX idx_requests_client ON support_desk.dbo.requests (  client_id ASC  )  
	 WITH (  PAD_INDEX = OFF ,FILLFACTOR = 100  ,SORT_IN_TEMPDB = OFF , IGNORE_DUP_KEY = OFF , STATISTICS_NORECOMPUTE = OFF , ONLINE = OFF , ALLOW_ROW_LOCKS = ON , ALLOW_PAGE_LOCKS = ON  )
	 ON [PRIMARY ] ;
 CREATE NONCLUSTERED INDEX idx_requests_created ON support_desk.dbo.requests (  created_at ASC  )  
	 WITH (  PAD_INDEX = OFF ,FILLFACTOR = 100  ,SORT_IN_TEMPDB = OFF , IGNORE_DUP_KEY = OFF , STATISTICS_NORECOMPUTE = OFF , ONLINE = OFF , ALLOW_ROW_LOCKS = ON , ALLOW_PAGE_LOCKS = ON  )
	 ON [PRIMARY ] ;
 CREATE NONCLUSTERED INDEX idx_requests_status ON support_desk.dbo.requests (  status ASC  )  
	 WITH (  PAD_INDEX = OFF ,FILLFACTOR = 100  ,SORT_IN_TEMPDB = OFF , IGNORE_DUP_KEY = OFF , STATISTICS_NORECOMPUTE = OFF , ONLINE = OFF , ALLOW_ROW_LOCKS = ON , ALLOW_PAGE_LOCKS = ON  )
	 ON [PRIMARY ] ;
ALTER TABLE support_desk.dbo.requests WITH NOCHECK ADD CONSTRAINT chk_requests_status CHECK (([status]='cancelled' OR [status]='done' OR [status]='waiting' OR [status]='in_progress' OR [status]='new'));
ALTER TABLE support_desk.dbo.requests WITH NOCHECK ADD CONSTRAINT chk_requests_priority CHECK (([priority]='critical' OR [priority]='high' OR [priority]='normal' OR [priority]='low'));


-- support_desk.dbo.request_history определение

-- Drop table

-- DROP TABLE support_desk.dbo.request_history;

CREATE TABLE support_desk.dbo.request_history (
	history_id int IDENTITY(1,1) NOT NULL,
	request_id int NOT NULL,
	changed_by int NOT NULL,
	change_type varchar(50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	old_value nvarchar(255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	new_value nvarchar(255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	comment nvarchar(500) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	created_at datetime2 DEFAULT sysdatetime() NOT NULL,
	CONSTRAINT PK__request___096AA2E9D24F9B51 PRIMARY KEY (history_id),
	CONSTRAINT fk_history_request FOREIGN KEY (request_id) REFERENCES support_desk.dbo.requests(request_id) ON DELETE CASCADE,
	CONSTRAINT fk_history_user FOREIGN KEY (changed_by) REFERENCES support_desk.dbo.employees(employee_id)
);
 CREATE NONCLUSTERED INDEX idx_history_request_type ON support_desk.dbo.request_history (  request_id ASC  , change_type ASC  )  
	 WITH (  PAD_INDEX = OFF ,FILLFACTOR = 100  ,SORT_IN_TEMPDB = OFF , IGNORE_DUP_KEY = OFF , STATISTICS_NORECOMPUTE = OFF , ONLINE = OFF , ALLOW_ROW_LOCKS = ON , ALLOW_PAGE_LOCKS = ON  )
	 ON [PRIMARY ] ;
	 
-- Следующий раздел
	 INSERT INTO support_desk.dbo.categories (name,description,is_active) VALUES
	 (N'Hardware',N'Проблемы с оборудованием',1),
	 (N'Software',N'Проблемы с программным обеспечением',1);
INSERT INTO support_desk.dbo.clients (client_type,full_name,phone,email,address,created_at) VALUES
	 (N'organization',N'ООО Ромашка',N'+7-495-111-22-33',N'info@romashka.ru',NULL,N'2026-11-09 12:16:41.4613853'),
	 (N'person',N'Иванов И.И.',N'+7-926-123-45-67',N'ivanov@mail.ru',NULL,N'2026-11-09 12:16:41.4613853');
INSERT INTO support_desk.dbo.employees ([login],password_hash,password_salt,full_name,email,phone,[position],[role],is_active,created_at) VALUES
	 (N'admin',N'b85e29d891280f770a30e0b33830ca16c090b4b228509dcf41f7784292699d3a',N'a1b2c3d4e5f67890fedcba9876543210',N'Администратор системы',NULL,NULL,NULL,N'admin',1,N'2026-11-09 12:16:41.4458350'),
	 (N'operator1',N'24128a907cff5b8ce4a04fac0068fa6a76384afbf98ca7ab6c616d8870e702ad',N'b2c3d4e5f678901223456789abcdef01',N'Петрова Анна Сергеевна',NULL,NULL,NULL,N'operator',1,N'2026-11-09 12:16:41.4458350'),
	 (N'manager1',N'f309209b454a5d1a18f7d400f5f6b657284fe72efada75f9e86bdf0953745e06',N'c3d4e5f67890123456789abcdef01234',N'Сидоров Павел Иванович',NULL,NULL,NULL,N'manager',1,N'2026-11-09 12:16:41.4458350');
INSERT INTO support_desk.dbo.requests (client_id,category_id,created_by,assigned_to,title,description,status,priority,created_at,updated_at,due_at,closed_at) VALUES
	 (1,1,2,2,N'Не включается ПК',N'После скачка напряжения...',N'done',N'normal',N'2026-11-09 12:16:41.5561150',N'2026-11-09 12:16:41.5561150',NULL,NULL),
	 (2,2,2,2,N'Ошибка 0x80070005',N'При установке обновления...',N'in_progress',N'normal',N'2026-11-09 12:16:41.5561150',N'2026-11-09 12:16:41.5561150',NULL,NULL),
	 (1,1,2,NULL,N'Не печатает принтер',N'Горит красная лампа',N'new',N'normal',N'2026-11-09 13:30:52.4139750',N'2026-11-09 13:30:52.4139750',NULL,NULL);
INSERT INTO support_desk.dbo.users ([login],password_salt,password_hash,[role],is_active,created_at) VALUES
	 (N'admin',N'a1b2c3d4e5f67890',N'240be518fabd2724ddb6f04eeb1da5967448d7e831c08c8fa822809f74c720a9',N'admin',1,N'2026-11-09 11:29:25.1303504'),
	 (N'operator1',N'b2c3d4e5f6789012',N'd7a8fbb307d78094...',N'operator',1,N'2026-11-09 11:29:25.1303504'),
	 (N'manager1',N'c3d4e5f678901234',N'f2d5f9c8e1a3b7d4...',N'manager',1,N'2026-11-09 11:29:25.1303504'),
	 (N'1',N'e2c594373944a4990212efacec266e5b',N'82d97103abaf711c2670d2aef3ede339294e36a38e1a0227ae8e98d92f27ae73',N'operator',1,N'2026-11-10 14:39:41.9089961'),
	 (N'2',N'38e031c3d07287d6b7a1114359c41686',N'ea9cb6ddb9ef9529594e439f0932f0ee060660395ad4a2bae667c6bf739029d5',N'operator',1,N'2026-11-10 15:01:12.4601044'),
	 (N'boss',N'ba821e42391b9de92c7125eade1d7ed7',N'13f6542cccd0eb2c4bd23644e5dcc2160afd8d79299883d20521a8306e975320',N'admin',1,N'2026-11-10 16:22:13.5690786');


-- Следующий раздел
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
	
-- Следующий раздел
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

-- Следующий раздел
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


