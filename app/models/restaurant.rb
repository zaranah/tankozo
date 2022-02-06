class Restaurant < ApplicationRecord
  extend ActiveHash::Associations::ActiveRecordExtensions
  belongs_to :prefecture
  belongs_to :genre
  belongs_to :price

  belongs_to :user
  has_many :comments, dependent: :destroy
  has_many :likes, dependent: :destroy
  has_many :hopes, dependent: :destroy
  has_one_attached :image

  validates :name, presence: true
  validates :prefecture_id, numericality: { other_than: 1, message: 'を入力してください' }
  validates :station, presence: true
  validates :genre_id, numericality: { other_than: 1, message: 'を入力してください' }
  validates :food, presence: true
  validates :price_id, numericality: { other_than: 1, message: 'を入力してください' }
  validates :opinion, presence: true

  validates :image, presence: true

  def self.search(search)
    if search != ""
      search = "%#{search}%"
      Restaurant.find_by_sql(["select * from restaurants where name like ? OR station like ? OR food like ? ", search, search, search]) 
    else
      Restaurant.all
    end
  end
end
