class Restaurant < ApplicationRecord
  extend ActiveHash::Associations::ActiveRecordExtensions
  belongs_to :prefecture
  belongs_to :genre
  belongs_to :price

  belongs_to :user
  has_one_attached :image

  validates :name, presence: true
  validates :prefecture_id, numericality: { other_than: 1, message: "can't be blank" }
  validates :station, presence: true
  validates :genre_id, numericality: { other_than: 1, message: "can't be blank" }
  validates :food, presence: true
  validates :price_id, numericality: { other_than: 1, message: "can't be blank" }
  validates :opinion, presence: true

  validates :image, presence: true

end