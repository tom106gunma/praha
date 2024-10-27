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
	CA.article_id,
	CA.title,
	CA.content
FROM current_articles CA
INNER JOIN articles A USING (article_id)
WHERE A.user_id = 'UID000001'

-- 記事を更新する
START TRANSACTION;
	SET @articleId='A000001';
	INSERT INTO article_histories (article_id, version, title, content)
	SELECT
		@articleId,
		MAX(version) + 1,
		'記事1-2', '記事1を更新。'
	FROM article_histories
	WHERE article_id = @articleId;

	UPDATE current_articles CA
	JOIN (
			SELECT article_id, version AS current_version, title, content
			FROM article_histories
			WHERE article_id = @articleId
			ORDER BY version DESC LIMIT 1
	) AH USING (article_id)
	SET CA.current_version = AH.current_version,
			CA.title = AH.title,
			CA.content = AH.content
	WHERE article_id = @articleId;
COMMIT;

-- 記事を作成する
START TRANSACTION;
	SET @articleId='A000004';
	SET @version=1;

	INSERT INTO articles (article_id, user_id, status, published_at)
	VALUES (@articleId, 'UID000001', 'draft', NULL);

	INSERT INTO article_histories (article_id, version, title, content)
	VALUES (@articleId, @version, '記事4', '記事を作成。');

	INSERT INTO current_articles (article_id, current_version, title, content)
		SELECT
			article_id,
			version,
			title,
			content
		FROM
			article_histories
		WHERE
			article_id = @articleId
			AND version = @version;

COMMIT;


-- 記事を復元する
UPDATE current_articles CA
JOIN (
    SELECT article_id, version AS current_version, title, content
    FROM article_histories
    WHERE article_id = 'A000001'
			AND version = 1
) AH USING (article_id)
SET CA.current_version = AH.current_version,
    CA.title = AH.title,
    CA.content = AH.content
WHERE article_id = 'A000001';
