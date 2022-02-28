class Tag < ApplicationRecord
  has_many :restaurant_tag_relations
  has_many :restaurants, through: :restaurant_tag_relations
  validates :tag_name, uniqueness: true
end