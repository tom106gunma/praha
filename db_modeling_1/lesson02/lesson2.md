## 課題2-1
order_detail_optionsにshari_sizeカラムを追加して対応
わさび以外のオプションを管理

### 適用オプションテーブル(order_detail_options)
| カラム名        | データ型   | 説明               |
|----------------|-----------|-------------------|
| id             | INT        | 主キー            |
| order_detail   | INT        | 外部キー 注文詳細テーブルを参照|
| shari_size     | VARCHAR    | シャリの大きさ 'large', 'small'|


## 課題2-2
categoriesテーブルのtypeカラムでセット商品か単品商品か判断
order_detailsのquantityで数量、create_atで注文された月が判断できるようにする。

### メニューテーブル(menu)
| カラム名      | データ型   | 説明                   |
|--------------|-----------|------------------------|
| id           | INT       | 主キー                 |
| name         | VARCHAR   | 商品の名前             |
| price_id     | INT       | 外部キー 金額テーブルを参照       |
| category_id  | INT       | 外部キー カテゴリーテーブルを参照 |
| quantity     | INT       | 数量                 |
| takeout_flag | BOOLEAN   | テイクアウト可否             |

### カテゴリーテーブル(categories)
| カラム名      | データ型   | 説明                   |
|--------------|-----------|------------------------|
| id           | INT       | 主キー                 |
| name         | VARCHAR   | カテゴリーの名前        |
| type         | VARCHAR   | セットかお好みすしか 'set', 'single'|

### 注文詳細テーブル(order_details)
| カラム名        | データ型   | 説明                   |
|----------------|------------|----------------------|
| id            | INT        | 主キー                 |
| order_id      | INT        | 外部キー 注文テーブルを参照 |
| menu_id       | INT        | 外部キー メニューテーブルを参照 |
| quantity      | INT        | 数量                 |
| create_at    | TIMESTAMP   | 注文日         |
| update_at    | TIMESTAMP   | 更新日         |

## 課題2-3
・特定の期間のみメニューに表示する、期間限定メニューを提供することになりました。どのようなテーブル設計が必要でしょうか？

menuテーブルにstart_at, end_atカラムを追加して、値が入っている場合はその期間だけメニューに表示されるようにする

### メニューテーブル(menu)
| カラム名      | データ型   | 説明                   |
|--------------|-----------|------------------------|
| id           | INT       | 主キー                 |
| name         | VARCHAR   | 商品の名前             |
| price_id     | INT       | 外部キー 金額テーブルを参照       |
| category_id  | INT       | 外部キー カテゴリーテーブルを参照 |
| takeout_flag | BOOLEAN   | テイクアウト可否             |
| start_at     | TIMESTAMP  | 開始日         |
| end_at       | TIMESTAMP  | 終了日         |

・ポイント制度を導入します。顧客はポイントを保有し、１ポイント１円として支払いに使用できます。

phone_numberもユニークにして同じ電話番号は登録できないようにする
同じ電話番号の場合は更新(ポイントを追加)
pointsテーブル, point_detailsテーブルを追加


### 顧客テーブル(customer_info)
| カラム名      | データ型  | 説明                    |
|--------------|----------|------------------------|
| id           | INT      | 主キー                  |
| name         | VARCHAR  | 顧客の名前               |
| phone_number | VARCHAR  | ユニーク 顧客の電話番号 |
| create_at    | TIMESTAMP| 作成日         |
| update_at    | TIMESTAMP| 更新日         |

### ポイント管理テーブル(points)
| カラム名       | データ型  | 説明                   |
|---------------|----------|------------------------|
| id            | INT      | 主キー                 |
| customer_id   | INT      | 外部キー 顧客テーブルを参照 |

### ポイント詳細テーブル(point_details)
| カラム名       | データ型  | 説明                   |
|---------------|----------|------------------------|
| id            | INT      | 主キー                 |
| order_id      | INT      | 外部キー 注文テーブルを参照 |
| point_id      | INT      | 外部キー ポイントテーブルを参照 |
| point         | INT      | ポイント |
| create_at     | TIMESTAMP| 作成日         |
| update_at     | TIMESTAMP| 更新日         |

### 注文テーブル(orders)
| カラム名        | データ型  | 説明                   |
|----------------|----------|------------------------|
| id             | INT      | 主キー                 |
| customer_id     | INT     | 外部キー 顧客テーブルを参照|
| order_detail_id| INT      | 外部キー 注文詳細テーブルを参照 |
| payment_status | BOOLEAN  | 支払状態            |
| point_detail_id| INT      | 外部キー ポイント詳細テーブルを参照|
| remark         | VARCHAR  | その他(備考)     |
| receive_at     | TIMESTAMP| 受取日         |
| create_at      | TIMESTAMP| 作成日         |
| update_at      | TIMESTAMP| 更新日         |

・希望者に受取日にリマインドする機能を提供することになりました。どのようようなテーブル設計が必要でしょうか？(今回は電話番号を使ってSMSで送る)

customer_infoテーブルにremind_flagを追加
remind_flagがtrueになっていたら受取日にリマインドする

### 注文者テーブル(customer_info)
| カラム名      | データ型  | 説明                    |
|--------------|----------|------------------------|
| id           | INT      | 主キー                  |
| name         | VARCHAR  | 顧客の名前               |
| phone_number | VARCHAR  | 主キー 顧客の名前               |
| remind_flag  | BOOLEAN  | リマインド希望かどうか|
| create_at    | TIMESTAMP| 作成日         |
| update_at    | TIMESTAMP| 更新日         |

### 注文テーブル(orders)
| カラム名        | データ型  | 説明                   |
|----------------|----------|------------------------|
| id             | INT      | 主キー                 |
| customer_id    | INT      | 外部キー 顧客テーブルを参照|
| payment_status | BOOLEAN  | 支払状態            |
| remark         | VARCHAR  | その他(備考)     |
| receive_at     | TIMESTAMP| 受取日         |
| create_at      | TIMESTAMP| 作成日         |
| update_at      | TIMESTAMP| 更新日         |

・注文する際に、カート機能を導入する(注文したい商品をカートに入れていき、まとめて注文できるようにする。)
cartsテーブルを追加
確定したものをorders, order_detailsに追加
確定したらcartsテーブルの該当データを削除

### カートテーブル(carts)
| カラム名        | データ型  | 説明                   |
|----------------|----------|------------------------|
| id             | INT      | 主キー                 |
| customer_id    | INT      | 外部キー 顧客テーブルを参照|
| menu_id        | INT      | 外部キー 注文テーブルを参照 |
| quantity       | INT      | 数量 |
| create_at      | TIMESTAMP| 作成日         |
| update_at      | TIMESTAMP| 更新日         |
