# たん小僧

[![Image from Gyazo](https://i.gyazo.com/5f0010719e425066209283674de006c9.png)](https://gyazo.com/5f0010719e425066209283674de006c9)

## URL
http://52.199.17.26/

[![Image from Gyazo](https://i.gyazo.com/5b7ea442acacaad1b67ae83e0ede7db0.png)](https://gyazo.com/5b7ea442acacaad1b67ae83e0ede7db0)

## Basic認証
ID: tantan  
Password: tan3tongue6

## テストユーザー情報
Email address: test@test.com  
Password: testtest123

## 紹介
たん小僧は美味しいレストランを紹介または見つけることができるアプリです。  
投稿する際は食品ごとに自分にとって一番美味しいお店のみ紹介するので、
本当におすすめできるお店が掲載されるようにしています。  
例）一番美味しいと思う親子丼のお店が「招福亭」の場合、「招福亭」のみ投稿し、他の親子丼を紹介する投稿はしない。

また、自分の投稿した店舗に対する「よかった数」に応じて、アバターの舌が伸びるのでその辺りもお楽しみください。

[![Image from Gyazo](https://i.gyazo.com/90c5aaaff984dcab1479ce76c51c0b3a.png)](https://gyazo.com/90c5aaaff984dcab1479ce76c51c0b3a)
[![Image from Gyazo](https://i.gyazo.com/8aaec14e129d8cab27b92ee1f61b7f6b.png)](https://gyazo.com/8aaec14e129d8cab27b92ee1f61b7f6b)
[![Image from Gyazo](https://i.gyazo.com/04db39e6532beaacaf30ab706e4e1777.png)](https://gyazo.com/04db39e6532beaacaf30ab706e4e1777)

0 →→→→→→→→→→→→→→→→→→→→→→→→→→→→→ ∞

## このアプリを作成した理由
- 自分にとって一番美味しいお店のみ投稿されていくことで、本当に美味しいお店のみが発見できるアプリがあるといいなと思ったため
- 投稿者の味の好みを掲載することで、自分と同じ味の好みの投稿からよりお気に入りのお店を見つけられると思ったため

## 工夫したポイント
- 投稿者の味の好みを掲載することによる、より自分好みの投稿の見つけやすさ
- 見ていてお腹の空くようなカラーリング
- よかった数に応じてアバターの舌が伸びる面白さ・可愛さ
- ワード検索、複数検索、タグ検索など機能を充実させることで検索のしやすさ、使い勝手
- よかった、行きたいボタンを押すとき、マイページ内でのページ推移、コメント投稿・削除非同期通信にてできることによる使いやすさ

## 要件定義
[要件定義](https://docs.google.com/spreadsheets/d/1uHMzZSmTfgDPQwHV-c8mBO7f20mlDJwTTLANjF9kX7Q/edit#gid=1785908763)

## バージョン
Ruby 2.6.5  
Rails 6.0.0

## 使い方
### 投稿者(サインイン)
1. サインイン
2. お気に入りのレストランを投稿する
3. よかったまたはいきたいボタンを押す
(よかった: そのお店に実際に行ってみて良かった場合のボタン  
行きたい: そのお店にいつか行ってみたいと思った場合のボタン)
4. お店の投稿にコメントをする
5. マイページにて自分が投稿したお店、よかった・行きたいボタンを押した投稿を見ることができる
### 閲覧者(サインイン)
1. サインイン
2. レストランを閲覧する
3. よかったまたはいきたいボタンを押す
(よかった: そのお店に実際に行ってみて良かった場合のボタン  
行きたい: そのお店にいつか行ってみたいと思った場合のボタン)
4. お店の投稿にコメントをする
5. マイページにて自分がよかった・行きたいボタンを押した投稿を見ることができる
### 閲覧者
1. レストランを閲覧する


## デモ
よかったまたはいきたいボタンを押す
[![Image from Gyazo](https://i.gyazo.com/323cf24bd1c42ffa30919104ffe881a1.gif)](https://gyazo.com/323cf24bd1c42ffa30919104ffe881a1)

マイページにて自分が投稿したお店、よかった・行きたいボタンを押した投稿を見ることができる
[![Image from Gyazo](https://i.gyazo.com/dce3ea136424714dd7cb5690e0fbbca4.gif)](https://gyazo.com/dce3ea136424714dd7cb5690e0fbbca4)

## 作成者
https://github.com/zaranah

# テーブル
## ER
[![Image from Gyazo](https://i.gyazo.com/fab24c35aaf51aa9d78b67d83571fcf9.png)](https://gyazo.com/fab24c35aaf51aa9d78b67d83571fcf9)

## users table

| Column             | Type    | Options                   |
| ------------------ | ------- | ------------------------- |
| nickname           | string  | null: false               |
| favorite_taste_id  | integer | null: false               |
| email              | string  | null: false, unique: true |
| encrypted_password | string  | null: false               |


### Association

- has_many :restaurants
- has_many :comments
- has_many :hopes
- has_many :likes

## restaurants table

| Column                 | Type       | Options                        |
| ---------------------- | ---------- | ------------------------------ |
| name                   | string     | null: false                    |
| restaurant_url         | text       |                                |
| prefecture_id          | integer    | null: false                    |
| station                | string     | null: false                    |
| genre_id               | integer    | null: false                    |
| food                   | string     | null: false                    |
| price_id               | integer    | null: false                    |
| opinion                | text       | null: false                    |
| user                   | references | null: false, foreign_key: true |

### Association

- belongs_to :user
- has_many :comments
- has_many :hopes
- has_many :likes
- has_many :restaurant_tag_relations
- has_many :tags, through: :restaurant_tag_relations

## comments table

| Column     | Type       | Options                        |
| ---------- | ---------- | ------------------------------ |
| comment    | string     | null: false                    |
| user       | references | null: false, foreign_key: true |
| restaurant | references | null: false, foreign_key: true |

### Association

- belongs_to :user
- belongs_to :restaurant

## hopes table

| Column     | Type       | Options                        |
| ---------- | ---------- | ------------------------------ |
| user       | references | null: false, foreign_key: true |
| restaurant | references | null: false, foreign_key: true |

### Association

- belongs_to :user
- belongs_to :restaurant

## likes table

| Column     | Type       | Options                        |
| ---------- | ---------- | ------------------------------ |
| user       | references | null: false, foreign_key: true |
| restaurant | references | null: false, foreign_key: true |

### Association

- belongs_to :user
- belongs_to :restaurant

## restaurant_tag_relations table

| Column     | Type       | Options                        |
| ---------- | ---------- | ------------------------------ |
| restaurant | references | null: false, foreign_key: true |
| tag        | references | null: false, foreign_key: true |

### Association

- belongs_to :restaurant
- belongs_to :tag

## tags table

| Column     | Type       | Options                   |
| ---------- | ---------- | ------------------------- |
| tag_name   | string     | null: false, unique: true |

### Association

- has_many :restaurant_tag_relations
- has_many :restaurants, through: :restaurant_tag_relations