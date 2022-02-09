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

RSpec.describe "店舗編集", type: :system do
  before do
    @restaurant1 = FactoryBot.create(:restaurant)
    @restaurant2 = FactoryBot.create(:restaurant)
  end

  context '店舗編集ができるとき' do
    it 'ログインしたユーザーは自分が投稿した店舗の編集ができる' do
      # 店舗１を投稿したユーザーでログインする
      sign_in(@restaurant1.user)
      # 店舗１の店舗詳細ページへ遷移する
      visit restaurant_path(@restaurant1)
      # 店舗1に「編集」へのリンクがあることを確認する
      expect(page).to have_content('Edit')
      # 編集ページへ遷移する
      visit edit_restaurant_path(@restaurant1)
      # すでに投稿済みの内容がフォームに入っていることを確認する
      expect(
        find('#floatingInputName').value
      ).to eq(@restaurant1.name)
      expect(
        find('#prefecture').value
      ).to eq("#{@restaurant1.prefecture_id}")
      expect(
        find('#floatingInputStation').value
      ).to eq(@restaurant1.station)
      expect(
        find('#genre').value
      ).to eq("#{@restaurant1.genre_id}")
      expect(
        find('#floatingInputFood').value
      ).to eq(@restaurant1.food)
      expect(
        find('#price').value
      ).to eq("#{@restaurant1.price_id}")
      expect(
        find('#floatingInputOpinion').value
      ).to eq(@restaurant1.opinion)
      # 投稿内容を編集する
      fill_in '店舗名', with: "#{@restaurant1.name}+編集したテキスト"
      expect(
        all('.collection')[0].click
      ).to have_content('北海道')
      all('option[value="3"]')[0].click
      fill_in '駅名', with: "#{@restaurant1.station}+編集したテキスト"
      expect(
        all('.collection')[1].click
      ).to have_content('寿司')
      all('option[value="3"]')[1].click
      fill_in '食品名', with: "#{@restaurant1.food}+編集したテキスト"
      expect(
        all('.collection')[2].click
      ).to have_content('〜1,000円')
      all('option[value="3"]')[2].click
      fill_in '評価コメント', with: "#{@restaurant1.opinion}+編集したテキスト"
      # 添付する画像を定義する
      image_path = Rails.root.join('public/images/test_image2.png')
      # 画像選択フォームに画像を添付する
      attach_file('restaurant[image]', image_path )
      # 編集してもTweetモデルのカウントは変わらないことを確認する
      expect{
        find('input[name="commit"]').click
      }.to change { Restaurant.count }.by(0)
      # 店舗詳細ページに推移したことを確認する
      expect(current_path).to eq(restaurant_path(@restaurant1))
      
      # トップページには先ほど変更した内容のツイートが存在することを確認する（画像）
      # expect(page).to have_selector ".bd-placeholder-img[src="Rails.root.join('public/images/test_image2.png')"]"

      # トップページには先ほど変更した内容のツイートが存在することを確認する（店舗名）
      expect(page).to have_content("#{@restaurant1.name}+編集したテキスト")
    end
  end

  context '店舗編集ができないとき' do
    it 'ログインしたユーザーは自分以外が投稿したツイートの編集画面には遷移できない' do
      # 店舗1を投稿したユーザーでログインする
      sign_in(@restaurant1.user)
      # 店舗2の店舗詳細ページへ遷移する
      visit restaurant_path(@restaurant2)
      # 店舗2に「編集」へのリンクがないことを確認する
      expect(page).to have_no_content('Edit')
      # 編集ページへの推移を試みる
      visit edit_restaurant_path(@restaurant2)
      # 編集ページへ推移できず、トップページにいることを確認する
      expect(current_path).to eq(root_path)
    end
    it 'ログインしていないとツイートの編集画面には遷移できない' do
      # 店舗1の店舗詳細ページへ遷移する
      visit restaurant_path(@restaurant1)
      # 店舗1に「編集」へのリンクがないことを確認する
      expect(page).to have_no_content('Edit')
      # 店舗2の店舗詳細ページへ遷移する
      visit restaurant_path(@restaurant2)
      # 店舗2に「編集」へのリンクがないことを確認する
      expect(page).to have_no_content('Edit')
    end
  end
end
