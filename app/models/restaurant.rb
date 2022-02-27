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

  validate :file_type, if: :was_attached?

  def was_attached?
    image.attached?
  end

  def file_type
    unless image.blob.content_type.in?(%('image/jpg image/jpeg image/png'))
      errors.add(:image,
                  'は JPG/JPEG 形式または PNG 形式のみ選択してください')
    end
  end
end