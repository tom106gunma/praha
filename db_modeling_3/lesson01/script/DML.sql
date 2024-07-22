INSERT INTO users (id, name) VALUES
('UID000001', 'kawata');

INSERT INTO directories (id, name, user_id, parent_directory_id) VALUES
('DIR000001', 'Directory01', 'UID000001', NULL),
('DIR000002', 'Directory02', 'UID000001', NULL),
('DIR000003', 'Directory01_1', 'UID000001', 'DIR000001'),
('DIR000004', 'Directory01_2', 'UID000001', 'DIR000003');

INSERT INTO documents (id, directory_id, name, content, user_id) VALUES
('DOC000001', 'DIR000001', 'document1', 'document1', 'UID000001'),
('DOC000002', 'DIR000002', 'document2', 'document2', 'UID000001'),
('DOC000003', 'DIR000002', 'document3', 'document3', 'UID000001'),
('DOC000004', 'DIR000003', 'document4', 'document4', 'UID000001'),
('DOC000005', 'DIR000004', 'document5', 'document5', 'UID000001'),
('DOC000006', 'DIR000004', 'document6', 'document6', 'UID000001');

INSERT INTO document_histories (document_id, user_id, status) VALUES
('DOC000001', 'UID000001', 'CREATE'),
('DOC000002', 'UID000001', 'CREATE'),
('DOC000003', 'UID000001', 'CREATE'),
('DOC000004', 'UID000001', 'CREATE'),
('DOC000005', 'UID000001', 'CREATE'),
('DOC000006', 'UID000001', 'CREATE');
