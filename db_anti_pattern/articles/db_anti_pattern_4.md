## 課題1-1
SQLアンチパターン Naive Trees（素朴な木） にあたる

```
TABLE Message {
  id: varchar
  parent_message_id: varchar
  text: varchar
  FOREIGN KEY (parent_message_id) REFERENCES Message(id)
}
```

### クエリが複雑になる
検索が困難になる(階層全体の取得)
再帰的なクエリが必要になるため、パフォーマンスも低下してしまう
| id | parent_message_id | text |
| --- | --- | --- |
| 1 | NULL | Hello. |
| 2 | 1 | >>1に対してのコメント |
| 3 | 2 | >>2に対してのコメント |
| 4 | 3 | >>3に対してのコメント |

id = 1 の直近の子１(id = 2)を参照する場合
```
SELECT * FROM Message m1
LEFT OUTER JOIN Message m2 ON m1.id = m2.parent_message_id
WHERE m1.id = 1;
```

id = 1 の2つ目の深さのメッセージ(id = 3)を参照する場合
```
SELECT * FROM Message m1
LEFT OUTER JOIN Message m2 ON m1.id = m2.parent_message_id
LEFT OUTER JOIN Message m3 ON m2.id = m3.parent_message_id
WHERE m1.id = 1;
```

id = 1 の3つ目の深さのメッセージ(id = 4)を参照する場合
```
SELECT * FROM Message m1
LEFT OUTER JOIN Message m2 ON m1.id = m2.parent_message_id
LEFT OUTER JOIN Message m3 ON m2.id = m3.parent_message_id
LEFT OUTER JOIN Message m4 ON m3.id = m4.parent_message_id
WHERE m1.id = 1;
```

あらかじめ階層の深さがわかっていれば、上記のクエリを組み合わせて取得できる。
しかし、階層の深さがどれくらいになるか分からない場合や全ての階層のコメントを一度に取得したいときには、クエリの数を増やすことができないため、この方法では対応できない。


`WITH RECURSIVE`を使用することで、階層の深さにかかわらず全てのメッセージを一度に取得できる。
ただ、利用しているデータベースやバージョンによっては利用できない。
```
WITH RECURSIVE MessageTree AS (
  SELECT id, parent_message_id, text, 1 AS depth
  FROM Message
  WHERE id = 1  -- ルートノードを指定
  UNION ALL
  SELECT m.id, m.parent_message_id, m.text, mt.depth + 1
  FROM Message m
  INNER JOIN MessageTree mt ON m.parent_message_id = mt.id
)
SELECT * FROM MessageTree;
```

### 親ノードを削除した際に整合性を取りづらい
親ノードが削除されると、その子ノードや孫ノードがどのように扱われるべきかデータの整合性を保つのが難しくなる
| id | parent_message_id | text |
| --- | --- | --- |
| 1 | NULL | Hello. |
| 2 | 1 | >>1に対してのコメント |
| 3 | 2 | >>2に対してのコメント |
| 4 | 3 | >>3に対してのコメント |


この構造では、id1がルートノードとなり、子メッセージとしてid2、孫メッセージとしてid3、ひ孫メッセージとしてid4が存在する。
id = 1の親ノードを削除した場合、次のような整合性問題が発生。
- 子メッセージの孤立
  - id2、id3、id4は本来id1に依存しているため、親ノードがなくなることでツリー内で孤立してしまう。
  - 子メッセージがどの親メッセージに属するのかが不明となり、データの意味が失われてしまうため、アプリケーションのロジックが崩れてしまう可能性がある。


## 課題2-1
### 経路列挙モデル
各ノードの経路を文字列として保存する方法。
parent_message_idの代わりに、経路全体を示すpathカラムを追加。
```
TABLE Message {
  id: varchar
  path: varchar
  text: varchar
}
```
| id | path | text |
| --- | --- | --- |
| 1 | 1 | Hello. |
| 2 | 1/2 | >>1に対してのコメント |
| 3 | 1/2/3 | >>2に対してのコメント |
| 4 | 1/2/3/4 | >>3に対してのコメント |

すべての子ノードを取得するにはLIKE演算子を使用する。
```
SELECT * FROM Message WHERE path LIKE '1/%';
```

親ノードid = 1を削除する場合、その子孫ノードのパスは1/%の形になる。これを利用して、すべての子孫ノードを一緒に削除することができる。
```
DELETE FROM Message
WHERE path LIKE '1/%';
```
- デメリット
子孫ノードを削除するだけであれば簡単だが、再割り当てや別の親に移す際は整合性を維持するためには慎重な操作が必要となる。


### 閉包テーブル
各ノードとそのすべての子孫ノードの関係を別のテーブルに保存する方法。
```
TABLE MessageTree {
  ancestor_id: varchar
  descendant_id: varchar
  FOREIGN KEY (ancestor_id) REFERENCES Message(id)
  FOREIGN KEY (descendant_id) REFERENCES Message(id)
}
```

| ancestor_id | descendant_id |
| --- | --- |
| 1 | 1 |
| 1 | 2 |
| 1 | 3 |
| 1 | 4 |
| 2 | 2 |
| 2 | 3 |
| 2 | 4 |
| 3 | 3 |
| 3 | 4 |
| 4 | 4 |


全階層のメッセージをテーブルに保存してあるため、特定のメッセージidに対応するすべての子孫を簡単に取得できる。
```
SELECT m.*
FROM Message m
JOIN MessageTree mt ON m.id = mt.descendant_id
WHERE mc.ancestor_id = 1;
```

- デメリット
  - 挿入・削除が複雑
  新しいノードを追加したりノードを削除する際には、閉包テーブルに対して複数行の挿入・削除が必要になる。
  例) Messeage.id = 5 をid = 2 の子供として追加する場合
  ```
  INSERT INTO MessageTree (ancestor, descendant)
  SELECT ancestor, 5
  FROM MessageTree
  WHERE descendant = 2
  UNION ALL
  SELECT 5, 5
  ```

  - ストレージの増加
  各ノード間の全ての祖先・子孫関係を保存するため、データ量が増加してしまう。

### 課題3-1
人事管理システム
- 企業の階層型組織を表現する際にアンチパターンに陥る

## 感じたこと
どの解決策でもデータの整合性を保つためには慎重な操作が必要になる。
データ量は多くなってしまうが、閉包テーブルが直感的で管理しやすいように感じた。

## 参考文献
SQLアンチパターン
https://www.oreilly.co.jp/books/9784873115894/
