# テーブル設計

## users テーブル

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

## restaurants テーブル

| Column                 | Type       | Options                        |
| ---------------------- | ---------- | ------------------------------ |
| name                   | string     | null: false                    |
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

## comments テーブル

| Column     | Type       | Options                        |
| ---------- | ---------- | ------------------------------ |
| comment    | string     | null: false                    |
| user       | references | null: false, foreign_key: true |
| restaurant | references | null: false, foreign_key: true |

### Association

- belongs_to :user
- belongs_to :restaurant

## hopes テーブル

| Column     | Type       | Options                        |
| ---------- | ---------- | ------------------------------ |
| user       | references | null: false, foreign_key: true |
| restaurant | references | null: false, foreign_key: true |

### Association

- belongs_to :user
- belongs_to :restaurant

## likes テーブル

| Column     | Type       | Options                        |
| ---------- | ---------- | ------------------------------ |
| user       | references | null: false, foreign_key: true |
| restaurant | references | null: false, foreign_key: true |

### Association

- belongs_to :user
- belongs_to :restaurant