## 課題1-1

### テナントごとにデータベースを分けておく

会社ごとに異なるデータベースを用意し、テナントごとのデータを隔離する。

メリット

- テナントIDを指定し忘れても、他のテナントのデータにアクセスすることができなくなる。
- 特定のテナントでアクセスが増えた場合でも、他の会社は影響を受けない
- データベース障害時の影響範囲がテナントごとになる

デメリット

- 費用がかかる
- テナントの数が増えるとデータベースの管理が複雑になり、運用コストがあがってしまう。


## 課題2-1

マルチテナントアーキテクチャには「テナント毎にデータベースを分割する」「テナント毎にスキーマを分割する」「すべてのテナントで同じスキーマを使う」など様々なパターンがあります。
それぞれのメリット・デメリットを調べてみましょう。

### テナント毎にデータベースを分割する

メリット

- 情報漏洩するリスクが低い
- テナントごとに個別に設定を変えることができる
- データベース障害時の影響範囲がテナントごとになる

デメリット

- 費用コストが高い

### テナント毎にスキーマを分割する

メリット

- データベースを分割するより開発がしやすい
    - テストやマイグレーションを行いやすい
    - データベース接続管理がシンプル

デメリット

- 設定ミスなどにより、他のスキーマにアクセスしてしまう可能性がある。
- 運用コストが高い

### すべてのテナントで同じスキーマを使う

メリット

- 費用を抑えることができる

デメリット

- 情報漏洩のリスクが高い

サービスはどのパターンに合っているか、サービスが大きくなったときに別のパターンにも対応できるようなシンプルな設計を考える


## 課題2-2

### RLS(行レベルのセキュリティポリシー)とは

DBテーブルの各行に対するアクセスを制御するための機能。
PostgreSQLなどいくつかのDBで利用でき、あるテーブルの行に対して特定のユーザーのみがアクセスできる制約を設けることができる。

メリット

- 1つのデータベーススキーマで管理可能
- アプリケーションコード側でのミスを防ぎやすい

デメリット

- RLSの設定を誤ってしまうと情報漏洩のリスクはある
- データベースの障害が起きた時に全テナントが影響を受ける

### テストデータ作成
RLSの対象となるテーブルを新規作成、データの流し込み
```sql
CREATE TABLE post(
    id SERIAL PRIMARY KEY
    ,content TEXT NOT NULL
    ,tenant_id UUID NOT NULL
);

INSERT INTO post (content, tenant_id) VALUES
('tenant_aの投稿', 'f47ac10b-58cc-4372-a567-0e02b2c3d479'),
('tenant_bの投稿', '550e8400-e29b-41d4-a716-446655440000');
```

### RLSの設定
GRANTコマンドで必要な権限を付与し、ALTER TABLEでRLSを有効化

DBロールにテーブルへのアクセス権限をGRANT
```sql
GRANT SELECT, INSERT, UPDATE, DELETE, REFERENCES ON post TO app_user;
```

テーブルに対しRLSを有効化する(app_user 以外の適切な権限をもつロールで行う)
```sql
ALTER TABLE post ENABLE ROW LEVEL SECURITY;

// 現在のロールを確認するクエリ
SELECT CURRENT_USER;
```

実行時パラメータを利用したRLSポリシーを追加する
```sql
CREATE POLICY tenant_isolation_policy ON post TO app_user
    USING (tenant_id = current_setting('app.current_tenant_id')::UUID);
```

### 試してみる

RLSポリシーを設定したロールに切り替え
```sql
SET ROLE app_user;
```

実行時パラメータをセットせずにクエリを実行するとエラーが出る
```sql
SELECT * FROM post;

// 結果
// 実行時にテナント情報が設定されていないと、RLSが適用されないためアクセスが拒否される
SQLエラー [42704]: ERROR: unrecognized configuration parameter "app.current_tenant_id"
```

実行時パラメータのセット
```sql
SET app.current_tenant_id = 'f47ac10b-58cc-4372-a567-0e02b2c3d479';
```

// 実行するとセットしたtenant_idのレコードが返る
```sql
SELECT * FROM post;
```
id | content |              tenant_id
|--------------|-----------|------------------------|
 1 | tenant_aの投稿 | f47ac10b-58cc-4372-a567-0e02b2c3d479


## 参考文献
- [RLSではじめるマルチテナントSaaS](https://zenn.dev/nstock/articles/multi-tenant-saas-using-rls)
- [マルチテナント SaaS を設計する際に参考になった資料](https://qiita.com/nassy20/items/99ff3d7ac0fb00989aef)
- [マルチテナントの実現における技術選定の審美眼とDB設計](https://youtu.be/PXy6I-AeI-I?si=kCiyhxkwKZtIMSPo)
- [マルチテナントの実現におけるDB設計とRLS / Utilizing RSL in multi-tenancy](https://speakerdeck.com/soudai/utilizing-rsl-in-multi-tenancy)
