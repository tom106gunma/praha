---
title: "複数列属性のDB設計" # 記事のタイトル
emoji: "💭" # アイキャッチとして使われる絵文字（1文字だけ）
type: "tech" # tech: 技術記事 / idea: アイデア記事
topics: ["SQL","DB"] # タグ。["markdown", "rust", "aws"]のように指定する
published: false # 公開設定（falseにすると下書き）
---
転職のためのユーザーと企業をマッチングするサービス。
当初はスキルを1個しか登録できない予定だったが、仕様変更により3個まで登録できるようになったため、とりあえずスキルidカラムを3個に増やして対応した。

## テーブル構造

```mermaid
erDiagram
    "Users(変更前)" {
        user_id varchar PK
        name varchar
        skill1id varchar FK
    }
    "Users(変更後)" {
        user_id varchar PK
        name varchar
        skill1id varchar FK
        skill2id varchar FK
        skill3id varchar FK
    }

    Skills {
        id　varchar PK
        name varchar
    }

    "Users(変更前)" ||--o{ Skills : "has"
```
変更対応後、「動作が遅くなった」「2個しか登録できない」といった問い合わせが増えたため、
設計を見直すことにした。

## 問題点
この設計には以下のような問題が発生してしまうことがわかった。
### 検索が非効率
特定の値が存在するUsersを検索する場合、3列すべて取得しないといけない。
```
SELECT * FROM Users
WHERE skill1id = 'スキルA'
OR skill2id = 'スキルA'
OR skill3id = 'スキルA';
```

### データが重複してしまう可能性がある
ユニーク制約を設定することが難しいため、skill1id, skill2id, skill3idに重複したデータが入ってしまう可能性がある。

### タグの登録数を増やす場合に問題が発生する可能性がある
- テーブルに関係するすべてのクエリの見直しが必要になる
- テーブル全体をロックしないといけなくなってしまう可能性がある
:::message
サービスを停止しなければならない可能性がでてしまう
:::

## どのように解決するか
`Users`から`Skills`の多対多関係を中間テーブルUserSkillsで管理することで、以下のような改善が可能だと考えられる。
```mermaid
erDiagram
    Users {
        user_id varchar PK
        name varchar
    }

    Skills {
        skill_id　varchar PK
        name varchar
    }

    UserSkills {
        post_id varchar FK
        skill_id varchar FK
    }

    Users ||--o{ UserSkills : "has"
    Skills ||--o{ UserSkills : "has"
```
### クエリの効率化
JOINを使ったクエリによって、効率的にスキルを持つユーザーを取得できるようになる。
スキルごとのユーザー検索において冗長なOR条件が不要となるため、効率的な検索が可能になる。
```
SELECT u.*
FROM Users u
JOIN UserSkills us ON u.user_id = us.user_id
WHERE us.skill_id = 'スキルA';
```
### データ重複問題の解決
中間テーブルである`UserSkills`に対して、`user_id`と`skill_id`の組み合わせにユニーク制約を付けることで、同じユーザーに同じスキルが複数回登録されるのを防ぐことができる。

### スキルの拡張性
テーブルを変更することなく登録数を増やすことができるため、サービスを停止せずに運用が可能になる。

## 参考文献
https://www.oreilly.co.jp/books/9784873115894/
