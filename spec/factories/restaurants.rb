FactoryBot.define do
  factory :restaurant do
    name { Faker::Restaurant.name }
    restaurant_url { Faker::Internet.url }
    prefecture_id { Faker::Number.between(from: 2, to: 48) }
    station { Faker::Quote.famous_last_words }
    genre_id { Faker::Number.between(from: 2, to: 17) }
    food { Faker::Food.dish }
    price_id { Faker::Number.between(from: 2, to: 4) }
    opinion { Faker::Quote.famous_last_words }
    association :user

    after(:build) do |item|
      item.image.attach(io: File.open('public/images/test_image.png'), filename: 'test_image.png')
    end
  end
end
