require 'rails_helper'

RSpec.describe RestaurantTag, type: :model do
  before do
    user = FactoryBot.create(:user)
    image = fixture_file_upload('public/images/test_image.png', 'image/png')
    @restaurant_tag = FactoryBot.build(:restaurant_tag, user_id: user.id, image: image)
  end

  describe '店舗投稿' do
    context '投稿できるとき' do
      it 'name、restaurant_url、prefecture_id、station、genre_id、food、price_id、opinion、tag_name、imageが存在すれば登録できる' do
        expect(@restaurant_tag).to be_valid
      end
      it 'name、prefecture_id、station、genre_id、food、price_id、opinion、imageが存在すれば登録できる' do
        @restaurant_tag.restaurant_url = ''
        @restaurant_tag.tag_name = ''
        expect(@restaurant_tag).to be_valid
      end
    end
    context '投稿できないとき' do
      it 'nameが空では登録できない' do
        @restaurant_tag.name = ''
        @restaurant_tag.valid?
        expect(@restaurant_tag.errors.full_messages).to include('店舗名を入力してください')
      end
      it 'prefecture_idが空では登録できない' do
        @restaurant_tag.prefecture_id = ''
        @restaurant_tag.valid?
        expect(@restaurant_tag.errors.full_messages).to include('都道府県を入力してください')
      end
      it 'prefecture_idの未選択項目を選ぶと登録できない' do
        @restaurant_tag.prefecture_id = '1'
        @restaurant_tag.valid?
        expect(@restaurant_tag.errors.full_messages).to include('都道府県を入力してください')
      end
      it 'stationが空では登録できない' do
        @restaurant_tag.station = ''
        @restaurant_tag.valid?
        expect(@restaurant_tag.errors.full_messages).to include('駅名を入力してください')
      end
      it 'genre_idが空では登録できない' do
        @restaurant_tag.genre_id = ''
        @restaurant_tag.valid?
        expect(@restaurant_tag.errors.full_messages).to include('ジャンルを入力してください')
      end
      it 'genre_idの未選択項目を選ぶと登録できない' do
        @restaurant_tag.genre_id = '1'
        @restaurant_tag.valid?
        expect(@restaurant_tag.errors.full_messages).to include('ジャンルを入力してください')
      end
      it 'foodが空では登録できない' do
        @restaurant_tag.food = ''
        @restaurant_tag.valid?
        expect(@restaurant_tag.errors.full_messages).to include('食品名を入力してください')
      end
      it 'price_idが空では登録できない' do
        @restaurant_tag.price_id = ''
        @restaurant_tag.valid?
        expect(@restaurant_tag.errors.full_messages).to include('価格帯を入力してください')
      end
      it 'price_idの未選択項目を選ぶと登録できない' do
        @restaurant_tag.price_id = '1'
        @restaurant_tag.valid?
        expect(@restaurant_tag.errors.full_messages).to include('価格帯を入力してください')
      end
      it 'opinionが空では登録できない' do
        @restaurant_tag.opinion = ''
        @restaurant_tag.valid?
        expect(@restaurant_tag.errors.full_messages).to include('評価コメントを入力してください')
      end
      it 'imageが空では登録できない' do
        @restaurant_tag.image = nil
        @restaurant_tag.valid?
        expect(@restaurant_tag.errors.full_messages).to include('画像を入力してください')
      end
      it 'userが紐付いていなければ出品できない' do
        @restaurant_tag.user_id = nil
        @restaurant_tag.valid?
        expect(@restaurant_tag.errors.full_messages).to include('Userを入力してください')
      end
    end
  end
end
