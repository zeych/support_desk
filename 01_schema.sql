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