FactoryBot.define do
  factory :comment do
    comment { Faker::Quote.famous_last_words }
    association :user
    association :restaurant
  end
end
