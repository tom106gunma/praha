## 課題1-1
- データの整合性が崩れてしまったり、孤立したデータが作成されてしまう可能性が考えられる

  Authorテーブルに存在しないidでBookテーブルにデータが作成されてしまう。

- アプリケーション側でデータの整合性の管理を行う必要が出てくるので開発コストが上がる

## 課題1-2
- データ量が多い場合、パフォーマンスが落ちてしまうことが考えられる

  データの挿入・更新・削除時に他のテーブルを参照するため、データ量が多いとパフォーマンスが落ちてしまう。


## 課題2-1
- CASCADE

親テーブルのレコードを削除または更新したときに、子テーブルの関連するレコードを自動的に削除または更新したい場合に使用する。

- SET NULL

親テーブルの行を削除または更新したときに、子テーブルの外部キー列の値にNULLをセットしたい場合に使用する。
SET NULL を使用する場合、外部キー列に NULL を許可する必要がある。

- RESTRICT

参照（子）テーブルに一致する行がある親テーブルから行を削除または更新するときに、エラーが戻され、親テーブルの行の削除または更新ができないようにしたい場合に使用する。

- NO ACTION

RESTRICTに似ている機能だが、適用されるタイミングが違うため、タイミングに関する制約を柔軟に扱う場合に使用する。

RESTRICTは即座にエラーを返すが、NO ACTIONは他の制約が適用された後にエラーが返される。(PostgreSQL)

- SET DEFAULT

参照先の値が変更もしくは削除されたときに、外部キーの値をデフォルト値にしたい場合に使用する。
デフォルト値は参照操作設定時に指定できる。MySQLでは使用することができない。

[MySQLドキュメント](https://dev.mysql.com/doc/refman/8.0/ja/create-table-foreign-keys.html)


## 課題2-2
- 部署が廃止になったためDepartmentテーブルのデータ削除したところ、削除した部署に所属している従業員のデータもまとめて消してしまったというような、意図しない連鎖削除が行われてしまう可能性がある。

## 課題2-3
- 担当者が削除されると、その担当者に割り当てられていた案件（Issue）の `assignee_id` が `NULL` となってしまい、担当者が任命されていないIssueが作成されてしまう可能性がでてしまう。

## 課題2-4
### Prismaの参照アクションのデフォルト値

| **句** | **オプション関係** | **義務的関係** |
| --- | --- | --- |
| `onDelete` | `SetNull` | `Restrict` |
| onUpdate | Cascade | Cascade |

[Prismaドキュメント](https://www.prisma.io/docs/orm/prisma-schema/data-model/relations/referential-actions#referential-action-defaults)

### TypeORMの参照アクションのデフォルト値

Cascadeは未設定、onDeleteは`NO ACTION`もしくは`RESTRICT`がデフォルトになっているとドキュメントや問い合わせから考えられる。

[TypeORMドキュメント](https://typeorm.io/relations#cascade-options)

[TypeORM問い合わせ](https://github.com/typeorm/typeorm/issues/3059)

データの整合性を保つことや、予期しないデータの削除を防ぐためにこのような設定になっていると考えられる。
上記のような設定がよく採用されていて、フレームワークを使うことで設定の手間をなくせるようにしているようにも感じた。

### MySQLとPostgreSQLでは`restrict`と`no action`の違い

MySQLには`RESTRICT` と `NO ACTION` に違いはないが、PostgreSQLでは`RESTRICT`は即座にエラーを返すが、`NO ACTION`は他の制約が適用された後にエラーが返される。

- PostgreSQL

RESTRICTは、被参照行を削除するのを防ぎます。 NO ACTIONは、制約がチェックされた時に参照行がまだ存在していた場合に、エラーとなることを意味しています。

https://www.postgresql.jp/document/8.0/html/ddl-constraints.html#:~:text=RESTRICTは、被参照行,デフォルトの振舞いとなります。

- MySQL

`NO ACTION`: 標準 SQL のキーワード。 MySQL では、`RESTRICT` と同等です。

https://dev.mysql.com/doc/refman/8.0/ja/create-table-foreign-keys.html

## 課題3-1
- 外部キー制約を設定することによって、どのようなことができなくなりますか？

**選択肢**

A. 親テーブルのデータを更新できなくなる

B. 参照されている親テーブルのデータを、子テーブルに関連するレコードが存在する状態で削除できなくなる

C. 親テーブルに新しい行を挿入できなくなる

D. 子テーブルの全データを一度に削除できなくなる


- 外部キーの設定を変更するにはどうすればいいですか？

**選択肢**
A. 外部キー制約の設定を直接編集できる

B. 外部キー制約を削除してから、新しい外部キー制約を再作成する

C. テーブルを再作成しないと、外部キー制約を変更することはできない

D. 外部キー制約を無効化した後、修正する


- Mysqlでは一つのカラムに対して、複数のテーブルの外部キーを設定することができますか？


## 参考文献
https://zenn.dev/praha/articles/2667cbb1ab7233

https://go-to-k.hatenablog.com/entry/2021/10/14/005047

https://jp.navicat.com/company/aboutus/blog/846-mysql外部キー制約のガイド#:~:text=MySQLは、次の5,NULLに設定されます。
