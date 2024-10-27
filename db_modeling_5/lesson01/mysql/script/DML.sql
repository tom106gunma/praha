INSERT INTO users (user_id, name) VALUES
('UID000001', 'tom106'),
('UID000002', 'kkkttt');

INSERT INTO articles (article_id, user_id, status, published_at) VALUES
('A000001', 'UID000001', 'published', '2024-08-09 10:00:00'),
('A000002', 'UID000001', 'published', '2024-08-09 11:00:00'),
('A000003', 'UID000001', 'published', '2024-08-09 12:00:00');

INSERT INTO article_histories (article_id, version, title, content) VALUES
('A000001', 1, '記事1', '1つ目の記事です.'),
('A000002', 1, '記事2', '2つ目の記事です.'),
('A000003', 1, '記事3', '3つ目の記事です.');

INSERT INTO current_articles (article_id, current_version, title, content)
SELECT
  article_id,
  version,
  title,
  content
FROM article_histories;
