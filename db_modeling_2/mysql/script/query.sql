-- メッセージとスレッドメッセージを横断的に検索
WITH user_channels AS (
    SELECT channel_id
    FROM channel_members
    WHERE user_id = 1  -- ユーザーIDを指定
)
SELECT c.name AS 'チャンネル名', type, user_id, u.name AS 'ユーザー名', content, search_contents.created_at  FROM (
    SELECT 'messages' AS type, m.id AS id, m.channel_id, m.user_id, m.content, m.created_at
    FROM messages m
    JOIN user_channels uc ON m.channel_id = uc.channel_id

    UNION ALL

    SELECT 'threads' AS type, t.id AS id, t.message_id, t.user_id, t.content, t.created_at
    FROM threads t
    JOIN messages m ON t.message_id = m.id
    JOIN user_channels uc ON m.channel_id = uc.channel_id
) search_contents
INNER JOIN channels c on c.id = search_contents.channel_id
INNER JOIN users u on u.id = search_contents.user_id
WHERE content like '%%'; -- 検索ワード

-- ユーザーをワークスペースに参加させる
INSERT INTO workspace_members (workspace_id, user_id) VALUES (1, 1);

-- ユーザをワークスペースから脱退させる(脱退するワークスペースに関連するチャンネル参加権限も削除)
DELETE FROM channel_members
WHERE channel_id IN (
    SELECT c.id
    FROM channels c
    WHERE c.workspace_id = 1  -- ワークスペースIDを指定
) AND user_id = 1;

DELETE FROM workspace_members WHERE workspace_id = 1 AND user_id = 1;

-- ユーザをチャンネルに参加させる
INSERT INTO channel_members (channel_id, user_id) VALUES (1, 1);

-- ユーザをチャンネルから脱退させる
DELETE FROM channel_members WHERE channel_id = 1 AND user_id = 1;
