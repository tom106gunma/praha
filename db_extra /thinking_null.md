## 課題1-1

- SELECT NULL = 0;

NULL

- NULL = NULL (以下、SELECT部分を省略)

NULL

- NULL <> NULL

NULL

- NULL AND TRUE

NULL

- NULL AND FALSE

false

- NULL OR TRUE

true

- NULL IS NULL

true

- NULL IS NOT NULL

false

NULLと比較すると、結果はNULLとなってしまう。
NULLを抽出したい場合は `IS NULL` を使う。
