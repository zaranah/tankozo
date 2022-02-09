require 'rails_helper'

RSpec.describe "店舗投稿", type: :system do
  before do
    @restaurant = FactoryBot.create(:restaurant)
  end

  context '店舗投稿に成功したとき' do
    it 'ログインしたユーザーは新規投稿できる' do
      # ログインする
      sign_in(@restaurant.user)
      # ヘッダードロップダウンに投稿ページがあることを確認する
      expect(
        find('.dropdown').click
      ).to have_content('Post')
      # 新規投稿ページへ移動する
      visit new_restaurant_path
      # フォームに情報を入力する
      post = @restaurant.name
      fill_in '店舗名', with: post
      expect(
        all('.collection')[0].click
      ).to have_content('北海道')
      all('option[value="2"]')[0].click
      fill_in '駅名', with: @restaurant.station
      expect(
        all('.collection')[1].click
      ).to have_content('寿司')
      all('option[value="2"]')[1].click
      fill_in '食品名', with: @restaurant.food
      expect(
        all('.collection')[2].click
      ).to have_content('〜1,000円')
      all('option[value="2"]')[2].click
      fill_in '評価コメント', with: @restaurant.opinion
      # 添付する画像を定義する
      image_path = Rails.root.join('public/images/test_image.png')
      # 画像選択フォームに画像を添付する
      attach_file('restaurant[image]', image_path )
      # 送信するとTweetモデルのカウントが1上がることを確認する
      expect{
        find('input[name="commit"]').click
      }.to change { Restaurant.count }.by(1)
      # トップページにいることを確認する
      expect(current_path).to eq(root_path)
      # トップページ上に先ほどの投稿内容が含まれていることを確認する
      expect(page).to have_content(post)
      # 送信した画像がブラウザに表示されていることを確認する
      expect(page).to have_selector('img')
    end
  end

  context '店舗投稿ができないとき' do
    it '送る値が空の為、メッセージの送信に失敗する' do
      # ログインする
      sign_in(@restaurant.user)
      # ヘッダードロップダウンに投稿ページがあることを確認する
      expect(
        find('.dropdown').click
      ).to have_content('Post')
      # 新規投稿ページへ移動する
      visit new_restaurant_path
      # フォームに空で入力する
      fill_in '店舗名', with: ''
      expect(
        all('.collection')[0].click
      ).to have_content('北海道')
      fill_in '駅名', with: ''
      expect(
        all('.collection')[1].click
      ).to have_content('寿司')
      fill_in '食品名', with: ''
      expect(
        all('.collection')[2].click
      ).to have_content('〜1,000円')
      fill_in '評価コメント', with: ''
      # DBに保存されていないことを確認する
      expect{
        find('input[name="commit"]').click
      }.not_to change { Restaurant.count }
      # 新規登録ページにいることを確認する
      expect(current_path).to eq(restaurants_path)
    end
    it 'ログアウトの状態ではコメントできない' do
      # トップページに移動する
      visit root_path
      # ヘッダードロップダウンに投稿ページがないことを確認する
      expect(
        find('.dropdown').click
      ).to have_no_content('post')
      # 新規投稿ページへ移動する
      visit new_restaurant_path
      # ログインページに遷移することを確認する
      expect(current_path).to eq(new_user_session_path)
    end
  end
end
