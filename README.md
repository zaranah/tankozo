# Tankozo

## Introduction
Tankozo is the application to find a tasty restaurants.
https://tankozo.herokuapp.com/

## Description
To know some real good restaurants.

## version
Ruby 2.6.5
Rails 6.0.0

## Usage
### Introducer
1. Signup
2. Post a good restaurant
### Viewer1
1. Signup
2. See some restaurants
3. Likes ones
### Viewer2
1. See some restaurants

## Author
https://github.com/zaranah

# Tables

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
