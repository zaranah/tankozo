# Tankozo

## URL
https://tankozo.herokuapp.com/

## Introduction
Tankozo is the application to find a tasty restaurants.
You can introduce your best restaurants ever.

## Description
To know some real good restaurants.

## Requirements definition
[Requirements definition](https://docs.google.com/spreadsheets/d/1uHMzZSmTfgDPQwHV-c8mBO7f20mlDJwTTLANjF9kX7Q/edit#gid=1785908763)

## Version
Ruby 2.6.5  
Rails 6.0.0

## Usage
### Introducer
1. Sign up
2. Post a good restaurant
### Viewer1
1. Sign in
2. See some restaurants
3. Likes or hopes ones  
(Like: when you visited the restaurant and like it.  
Hope: when you want to visit the restaurant someday.)
### Viewer2
1. See some restaurants

## Author
https://github.com/zaranah

# Tables
## ER
[![Image from Gyazo](https://i.gyazo.com/a68da747aff9ffc2da91f2b4391924eb.png)](https://gyazo.com/a68da747aff9ffc2da91f2b4391924eb)

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
