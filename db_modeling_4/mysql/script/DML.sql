INSERT INTO users (id, slack_user_id, name, created_at, updated_at) VALUES
('UID000001', 'U12345678A0', 'ktom106', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP),
('UID000002', 'U87654321B0', 'ktom1062', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP);

INSERT INTO frequency_types (type, created_at, updated_at) VALUES
('every', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP),
('daily', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP),
('weekly', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP),
('monthly', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP);


INSERT INTO reminders (id, channel_name, message, frequency_type_id, frequency_value, created_at, updated_at) VALUES
('REM000001', '#test1', '1on1ミーティングを設定してください〜', 1, 0, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP),
('REM000002', '#test2', '出張費の精算をしてください。', 3, 1, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP);


INSERT INTO reminder_recipients (id, reminder_id, user_id, is_complete, created_at, updated_at) VALUES
('RER000001', 'REM000001', 'UID000001', FALSE, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP),
('RER000002', 'REM000002', 'UID000002', FALSE, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP);

INSERT INTO reminder_queue (reminder_recipient_id, send_time, status, created_at, updated_at) VALUES
('RER000001', '2024-08-01 10:00:00', 'pending', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP),
('RER000002', '2024-08-05 10:00:00', 'pending', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP);
