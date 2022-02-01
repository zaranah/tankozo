class FavoriteTaste < ActiveHash::Base
  self.data = [
    { id: 1, name: '-Taste-' },
    { id: 2, name: '薄味派' },
    { id: 3, name: '普通' },
    { id: 4, name: '濃い味派' }
  ]

  include ActiveHash::Associations
  has_many :users
end
