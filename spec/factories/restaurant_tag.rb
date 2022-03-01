FactoryBot.define do
  factory :restaurant_tag do
    name { Faker::Restaurant.name }
    restaurant_url { Faker::Internet.url }
    prefecture_id { Faker::Number.between(from: 2, to: 48) }
    station { Faker::Quote.famous_last_words }
    genre_id { Faker::Number.between(from: 2, to: 17) }
    food { Faker::Food.dish }
    price_id { Faker::Number.between(from: 2, to: 4) }
    opinion { Faker::Quote.famous_last_words }
    tag_name { Faker::JapaneseMedia::StudioGhibli.character }
  end
end
