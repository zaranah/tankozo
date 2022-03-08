require 'rails_helper'

RSpec.describe "Likes", type: :system do
  before do
    user = FactoryBot.create(:user)
    @restaurant1 = FactoryBot.create(:restaurant)
    @restaurant2 = FactoryBot.create(:restaurant)
    tag1 = FactoryBot.create(:tag)
    tag2 = FactoryBot.create(:tag)
    restaurant_tag_relation1 = FactoryBot.create(:restaurant_tag_relation, restaurant_id: @restaurant1.id, tag_id: tag1.id)
    restaurant_tag_relation2 = FactoryBot.create(:restaurant_tag_relation, restaurant_id: @restaurant2.id, tag_id: tag2.id)
  end

  describe 'create' do
    it 'ログインしたユーザーは自分が投稿していない店舗詳細ページにて「行きたい」・「よかった」ボタンをクリックできる' do
      # 店舗１を投稿したユーザーでログインする
      sign_in_support(@restaurant1.user)
      # 詳細ページに遷移する
      visit restaurant_path(@restaurant2)
      # 店舗投稿内に「行きたい」・「よかった」ボタンがあることを確認する
      expect(page).to have_content('行きたい' && 'よかった')
      # 店舗投稿内の「行きたい」ボタンを正常にクリックできることを確認する
      expect do
        find('.fa-running').click
        visit restaurant_path(@restaurant2)
      end.to change { Hope.count }.by(1)
      # 店舗投稿内の「よかった」ボタンを正常にクリックできることを確認する
      expect do
        find('.fa-heart').click
        visit restaurant_path(@restaurant2)
      end.to change { Like.count }.by(1)
    end

    it 'ログインしたユーザーは自分が投稿した店舗詳細ページに「行きたい」・「よかった」ボタンが表示されない' do
      # 店舗１を投稿したユーザーでログインする
      sign_in_support(@restaurant1.user)
      # 詳細ページに遷移する
      visit restaurant_path(@restaurant1)
      # 店舗投稿内に「行きたい」・「よかった」ボタンがないことを確認する
      expect(page).to have_no_content('行きたい' && 'よかった')
    end

    it 'ログインしていないユーザーは自分が投稿した店舗詳細ページに「行きたい」・「よかった」ボタンが押せない' do
      # 詳細ページに遷移する
      visit restaurant_path(@restaurant1)
      # 店舗投稿内に「行きたい」・「よかった」ボタンを押せないことを確認する
      expect do
        find('.fa-running').click
      end.not_to change { Hope.count }
      expect do
        find('.fa-heart').click
      end.not_to change { Like.count }
    end
  end

end
