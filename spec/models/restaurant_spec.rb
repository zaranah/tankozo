require 'rails_helper'

RSpec.describe Restaurant, type: :model do
  before do
    @restaurant = FactoryBot.build(:restaurant)
  end

  describe '店舗投稿' do
    context '投稿できるとき' do
      it 'name、prefecture_id、station、genre_id、food、price_id、opinion、imageが存在すれば登録できる' do
        expect(@restaurant).to be_valid
      end
    end
    context '投稿できないとき' do
      it 'nameが空では登録できない' do
        @restaurant.name = ''
        @restaurant.valid?
        expect(@restaurant.errors.full_messages).to include("Name can't be blank")
      end
      it 'prefecture_idが空では登録できない' do
        @restaurant.prefecture_id = ''
        @restaurant.valid?
        expect(@restaurant.errors.full_messages).to include("Prefecture can't be blank")
      end
      it 'prefecture_idの未選択項目を選ぶと登録できない' do
        @restaurant.prefecture_id = '1'
        @restaurant.valid?
        expect(@restaurant.errors.full_messages).to include("Prefecture can't be blank")
      end
      it 'stationが空では登録できない' do
        @restaurant.station = ''
        @restaurant.valid?
        expect(@restaurant.errors.full_messages).to include("Station can't be blank")
      end
      it 'genre_idが空では登録できない' do
        @restaurant.genre_id = ''
        @restaurant.valid?
        expect(@restaurant.errors.full_messages).to include("Genre can't be blank")
      end
      it 'genre_idの未選択項目を選ぶと登録できない' do
        @restaurant.genre_id = '1'
        @restaurant.valid?
        expect(@restaurant.errors.full_messages).to include("Genre can't be blank")
      end
      it 'foodが空では登録できない' do
        @restaurant.food = ''
        @restaurant.valid?
        expect(@restaurant.errors.full_messages).to include("Food can't be blank")
      end
      it 'price_idが空では登録できない' do
        @restaurant.price_id = ''
        @restaurant.valid?
        expect(@restaurant.errors.full_messages).to include("Price can't be blank")
      end
      it 'price_idの未選択項目を選ぶと登録できない' do
        @restaurant.price_id = '1'
        @restaurant.valid?
        expect(@restaurant.errors.full_messages).to include("Price can't be blank")
      end
      it 'opinionが空では登録できない' do
        @restaurant.opinion = ''
        @restaurant.valid?
        expect(@restaurant.errors.full_messages).to include("Opinion can't be blank")
      end
      it 'imageが空では登録できない' do
        @restaurant.image = nil
        @restaurant.valid?
        expect(@restaurant.errors.full_messages).to include("Image can't be blank")
      end
      it 'userが紐付いていなければ出品できない' do
        @restaurant.user = nil
        @restaurant.valid?
        expect(@restaurant.errors.full_messages).to include("User must exist")
      end
    end
  end
end
