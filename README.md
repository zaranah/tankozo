# Tankozo

[![Image from Gyazo](https://i.gyazo.com/5f0010719e425066209283674de006c9.png)](https://gyazo.com/5f0010719e425066209283674de006c9)

## URL
http://52.199.17.26/

[![Image from Gyazo](https://i.gyazo.com/ec80041188652884e1336e0c3a7727e9.png)](https://gyazo.com/ec80041188652884e1336e0c3a7727e9)

## Basic
ID: tantan  
Password: tan3tongue6

## Test user info
Email address: test@test.com  
Password: testtest123

## Introduction
Tankozo is the application to find a tasty restaurants.  
You can introduce your best restaurants ever.  

When you get lots of likes from others, your avator changes.

[![Image from Gyazo](https://i.gyazo.com/90c5aaaff984dcab1479ce76c51c0b3a.png)](https://gyazo.com/90c5aaaff984dcab1479ce76c51c0b3a)
[![Image from Gyazo](https://i.gyazo.com/8aaec14e129d8cab27b92ee1f61b7f6b.png)](https://gyazo.com/8aaec14e129d8cab27b92ee1f61b7f6b)
[![Image from Gyazo](https://i.gyazo.com/04db39e6532beaacaf30ab706e4e1777.png)](https://gyazo.com/04db39e6532beaacaf30ab706e4e1777)

0 →→→→→→→→→→→→→→→→→→→→→→→→→→→→→ ∞

## The reasons why I made this
- I think that we can find the good restaurants by posting the best restaurant for each ones.
- Also, it's easier and more usuful to find our favorite restaurant when we can check the introducer's favorite taste.

## The points that I worked out
- The color making you get hungry.
- The funny and cute setting that your avotor's tongue is getting longer when you get lots of likes.
- The easy find by the searching and tagging function. 
- The asynchronous access to more usuful when you do likes, hopes and page transition on your page.

## Description
To know some real good restaurants.

## Requirements definition
[Requirements definition](https://docs.google.com/spreadsheets/d/1uHMzZSmTfgDPQwHV-c8mBO7f20mlDJwTTLANjF9kX7Q/edit#gid=1785908763)

## Version
Ruby 2.6.5  
Rails 6.0.0

## Usage
### Introducer(Sign in user)
1. Sign up
2. Post a good restaurant
3. Likes or hopes others'ones
(Like: when you visited the restaurant and like it.  
Hope: when you want to visit the restaurant someday.)
4. Comment ones
5. See the restaurants which you post, like and hope
### Viewer1(Sign in user)
1. Sign in
2. See some restaurants
3. Likes or hopes ones  
(Like: when you visited the restaurant and like it.  
Hope: when you want to visit the restaurant someday.)
4. Comment ones
5. See the restaurants which you post, like and hope
### Viewer2
1. See some restaurants


## Demo
Likes or hopes ones
[![Image from Gyazo](https://i.gyazo.com/323cf24bd1c42ffa30919104ffe881a1.gif)](https://gyazo.com/323cf24bd1c42ffa30919104ffe881a1)

See the restaurants which you post, like and hope
[![Image from Gyazo](https://i.gyazo.com/dce3ea136424714dd7cb5690e0fbbca4.gif)](https://gyazo.com/dce3ea136424714dd7cb5690e0fbbca4)

## Author
https://github.com/zaranah

# Tables
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