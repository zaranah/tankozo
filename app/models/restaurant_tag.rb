class RestaurantTag
  include ActiveModel::Model
  
  # 保存する両方のカラム名を記載する
  attr_accessor(
    :name, :prefecture_id, :station, :genre_id, :food, :price_id, :opinion, :user_id, :restaurant_url, :image,
    :id, :created_at, :datetime, :updated_at, :datetime,
    :tag_name
  )
  
  # 必要なバリデーションを記載する
  with_options presence: true do
    validates :name
    validates :station
    validates :food
    validates :opinion
    validates :image
  end
  validates :prefecture_id, numericality: { other_than: 1, message: 'を入力してください' }
  validates :genre_id, numericality: { other_than: 1, message: 'を入力してください' }
  validates :price_id, numericality: { other_than: 1, message: 'を入力してください' }

  validate :file_type, if: :was_attached?

  def was_attached?
    image != nil
  end

  def file_type
    unless image.content_type.in?(%('image/jpg image/jpeg image/png'))
      errors.add(:image,
                  'は JPG/JPEG 形式または PNG 形式のみ選択してください')
    end
  end
  
  # 保存する処理を記載する
  def save
    restaurant = Restaurant.create(
      name: name, prefecture_id: prefecture_id, station: station, genre_id: genre_id, food: food, price_id: price_id, opinion: opinion, image: image, restaurant_url: restaurant_url, user_id: user_id)
    tag_list = tag_name.gsub(" ", "") .split(',')
    tag_list.each do |tag_one|
      tag = Tag.where(tag_name: tag_one).first_or_initialize
      tag.save
      RestaurantTagRelation.create(restaurant_id: restaurant.id, tag_id: tag.id)
    end
  end

  def update(params, restaurant)
    restaurant.update(params)
  end
end