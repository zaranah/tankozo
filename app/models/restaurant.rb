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
  validate :file_type, if: :was_attached?

  def was_attached?
    self.image.attached?
  end

  def file_type
    if !image.blob.content_type.in?(%('image/jpg image/jpeg image/png'))
      errors.add(:image, 'は JPG/JPEG 形式または PNG 形式のみ選択してください')
    end
  end
end