-- 特定の記事の履歴を一覧表示
SELECT
	article_id,
	version,
	title,
	content
FROM article_histories
WHERE article_id = 'A000001'
ORDER BY version DESC

-- 最新状態の記事を一覧表示
SELECT
	AH.article_id,
	AH.title,
	AH.content
FROM article_histories AH
INNER JOIN articles A USING (article_id)
WHERE A.user_id = 'UID000001'
	AND A.current_version = AH.version

-- 記事を作成する
START TRANSACTION;
	SET @articleId='A000004';

	INSERT INTO article_histories (article_id, version, title, content)
	VALUES (@articleId, 1, '記事4', '記事を作成。');

	INSERT INTO articles (article_id, current_version, user_id, status, published_at)
	VALUES (@articleId, 1, 'UID000001', 'draft', NULL);

COMMIT;

-- 記事を更新する
START TRANSACTION;
	SET @articleId='A000004';

	INSERT INTO article_histories (article_id, version, title, content)
	SELECT
		@articleId,
		MAX(version) + 1,
		'記事4-2',
		'記事4を更新。'
	FROM article_histories
	WHERE article_id = @articleId;

	UPDATE articles A
	SET A.current_version = (
		SELECT
			MAX(version)
		FROM article_histories
		WHERE article_id = @articleId
	)
	WHERE article_id = @articleId;
COMMIT;

-- 記事を復元する
UPDATE articles SET current_version = 1 WHERE article_id = 'A000004';
