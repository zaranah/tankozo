class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  extend ActiveHash::Associations::ActiveRecordExtensions
  belongs_to :favorite_taste
  
  has_many :restaurants

  validates :nickname, presence: true
  validates :favorite_taste_id, presence: true, numericality: { other_than: 1, message: "can't be blank" }
end
