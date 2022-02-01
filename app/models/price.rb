class Price < ActiveHash::Base
  self.data = [
    { id: 1, name: '-価格帯' },
    { id: 2, name: '〜1,000円' },
    { id: 3, name: '1,000円〜5,000円' },
    { id: 4, name: '5,000円〜10,000円' },
    { id: 5, name: '10,000円〜' }
  ]

  include ActiveHash::Associations
  has_many :restaurants
end