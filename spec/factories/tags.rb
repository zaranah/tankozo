FactoryBot.define do
  factory :tag do
    tag_name { Faker::JapaneseMedia::StudioGhibli.character }
  end
end