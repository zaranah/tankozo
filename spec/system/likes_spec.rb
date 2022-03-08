require 'rails_helper'

RSpec.describe 'Likes', type: :system do
  before do
    @restaurant1 = FactoryBot.create(:restaurant)
    @restaurant2 = FactoryBot.create(:restaurant)
  end

  describe 'create' do
    it 'ログインしたユーザーは自分が投稿していない店舗詳細ページにて「よかった」ボタンをクリックできる' do
      # 店舗１を投稿したユーザーでログインする
      sign_in_support(@restaurant1.user)
      # 詳細ページに遷移する
      visit restaurant_path(@restaurant2)
      # 店舗投稿内に「よかった」ボタンがあることを確認する
      expect(page).to have_content('よかった')
      # 店舗投稿内の「よかった」ボタンを正常にクリックできることを確認する
      expect do
        find('.fa-heart').click
        visit restaurant_path(@restaurant2)
      end.to change { Like.count }.by(1)
    end

    it 'ログインしたユーザーは自分が投稿した店舗詳細ページに「よかった」ボタンが表示されない' do
      # 店舗１を投稿したユーザーでログインする
      sign_in_support(@restaurant1.user)
      # 詳細ページに遷移する
      visit restaurant_path(@restaurant1)
      # 店舗投稿内に「よかった」ボタンがないことを確認する
      expect(page).to have_no_content('よかった')
    end

    it 'ログインしていないユーザーは自分が投稿した店舗詳細ページに「よかった」ボタンが押せない' do
      # 詳細ページに遷移する
      visit restaurant_path(@restaurant1)
      # 店舗投稿内「よかった」ボタンを押せないことを確認する
      expect do
        find('.fa-heart').click
      end.not_to change { Like.count }
    end
  end

  describe 'destroy' do
    it 'ログインしたユーザーは自分が投稿していない店舗詳細ページにて「よかった」ボタンを消すことができる' do
      # 店舗１を投稿したユーザーでログインする
      sign_in_support(@restaurant1.user)
      # 詳細ページに遷移する
      visit restaurant_path(@restaurant2)
      # 店舗投稿内に「よかった」ボタンがあることを確認する
      expect(page).to have_content('よかった')
      # 店舗投稿内の「よかった」ボタンを正常にクリックできることを確認する
      expect do
        find('.fa-heart').click
        visit restaurant_path(@restaurant2)
      end.to change { Like.count }.by(1)
      # 店舗投稿内の「よかった」ボタンをもう一度押すと削除できることを確認する
      expect do
        find('.fa-heart').click
        visit restaurant_path(@restaurant2)
      end.to change { Like.count }.by(-1)
    end
  end
end
