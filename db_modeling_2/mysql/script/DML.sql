INSERT INTO users (name)
VALUES
    ('kawata'),
    ('ito'),
    ('kubo'),
    ('nakamura'),
    ('minamino'),
    ('morita');

INSERT INTO workspaces (name)
VALUES
    ('Japan'),
    ('France'),
    ('Spain'),
    ('Portugal');

INSERT INTO workspace_members (workspace_id,user_id)
VALUES
    (1, 1),
    (1, 2),
    (1, 3),
    (1, 4),
    (1, 5),
    (1, 6),
    (2, 2),
    (2, 4),
    (2, 5),
    (3, 3),
    (4, 6);

INSERT INTO channels (name, workspace_id)
VALUES
    ('All Japan', 1),
    ('All France', 2),
    ('STADE REIMS', 2),
    ('AS MONACO', 2),
    ('All Spain', 3),
    ('All Portugal', 4);

INSERT INTO channel_members (channel_id,user_id)
VALUES
    (1, 1),
    (1, 2),
    (1, 3),
    (1, 4),
    (1, 5),
    (1, 6),
    (2, 2),
    (2, 4),
    (2, 5),
    (3, 2),
    (3, 4),
    (4, 5),
    (5, 2),
    (6, 6);

INSERT INTO messages (channel_id, user_id, content)
VALUES
    (1, 1, 'こんにちは、調子はどうですか？'),
    (1, 2, '今日のミーティングは何時からですか？'),
    (3, 2, 'モナ王がまたゴール決めたらしいよ。'),
    (2, 2, 'パリに集合できる？');

INSERT INTO threads (message_id, user_id, content)
VALUES
    (1, 5, 'こんにちは、いい感じです。'),
    (2, 6, '10時からみたいです。'),
    (3, 4, 'モナ王すごいですね。');
