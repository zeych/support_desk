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
