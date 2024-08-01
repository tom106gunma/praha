WITH RECURSIVE directory_structure AS (
    -- ルートディレクトリを取得
    SELECT
        id,
        name,
        parent_directory_id,
        name AS path
    FROM
        directories
    WHERE
        parent_directory_id IS NULL

    UNION ALL

    -- サブディレクトリを取得
    SELECT
        d.id,
        d.name,
        d.parent_directory_id,
        CONCAT(ds.path, ' > ', d.name) AS path
    FROM
        directories d
    INNER JOIN
        directory_structure ds
    ON
        d.parent_directory_id = ds.id
)
-- 結果を表示
SELECT * FROM directory_structure;


-- ディレクトリに入っているドキュメントを取得
SELECT
    id, name
FROM
    documents
WHERE
    directory_id = 'DIR000002'
