-- ドキュメントを先頭に移動する
UPDATE documents
SET display_position = (
    SELECT MIN(display_position) / 2
    FROM documents
    WHERE directory_id = <directory_id>
)
WHERE id = <document_id>;


-- ドキュメントの並び替え
UPDATE documents
SET display_position = (
    SELECT (d1.display_position + d2.display_position) / 2
    FROM documents d1, documents d2
    WHERE d1.id = <前のdocument_id> AND d2.id = <後のdocument_id>
)
WHERE id = <document_id>;

-- ドキュメントを最後尾に移動する
UPDATE documents
SET display_position = MAX(display_position) + 65536
WHERE id = <document_id>;
