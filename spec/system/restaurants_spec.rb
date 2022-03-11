require 'rails_helper'

RSpec.describe '店舗投稿', type: :system do
  before do
    user = FactoryBot.create(:user)
    @restaurant = FactoryBot.create(:restaurant)
    image = fixture_file_upload('public/images/test_image.png', 'image/png')
    @restaurant_tag = FactoryBot.build(:restaurant_tag, user_id: user.id, image: image)
  end

  context '店舗投稿に成功したとき' do
    it 'ログインしたユーザーは新規投稿できる' do
      # ログインする
      sign_in_support(@restaurant.user)
      # ヘッダードロップダウンに投稿ページがあることを確認する
      expect(
        find('.dropdown').click
      ).to have_content('Post')
      # 新規投稿ページへ移動する
      visit new_restaurant_path
      # フォームに情報を入力する
      post = @restaurant_tag.name
      fill_in '店舗名', with: post
      fill_in '店舗ホームページURL', with: @restaurant_tag.restaurant_url
      expect(
        all('.collection')[0].click
      ).to have_content('北海道')
      all('option[value="2"]')[0].click
      fill_in '駅名', with: @restaurant_tag.station
      expect(
        all('.collection')[1].click
      ).to have_content('寿司')
      all('option[value="2"]')[1].click
      fill_in '食品名', with: @restaurant_tag.food
      expect(
        all('.collection')[2].click
      ).to have_content('〜1,000円')
      all('option[value="2"]')[2].click
      fill_in '評価コメント', with: @restaurant_tag.opinion
      fill_in 'タグ', with: @restaurant_tag.tag_name
      # 添付する画像を定義する
      image_path = Rails.root.join('public/images/test_image.png')
      # 画像選択フォームに画像を添付する
      attach_file('restaurant_tag[image]', image_path)
      # 送信するとTweetモデルのカウントが1上がることを確認する
      expect do
        find('input[name="commit"]').click
      end.to change { Restaurant.count }.by(1)
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
      sign_in_support(@restaurant.user)
      # ヘッダードロップダウンに投稿ページがあることを確認する
      expect(
        find('.dropdown').click
      ).to have_content('Post')
      # 新規投稿ページへ移動する
      visit new_restaurant_path
      # フォームに空で入力する
      fill_in '店舗名', with: ''
      fill_in '【任意】店舗ホームページURL', with: ''
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
      fill_in 'タグ', with: ''
      # DBに保存されていないことを確認する
      expect  do
        find('input[name="commit"]').click
      end.not_to change { Restaurant.count }
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

RSpec.describe '店舗編集', type: :system do
  before do
    user = FactoryBot.create(:user)
    @restaurant1 = FactoryBot.create(:restaurant)
    @restaurant2 = FactoryBot.create(:restaurant)
    tag = FactoryBot.create(:tag)
    restaurant_tag_relation = FactoryBot.create(:restaurant_tag_relation, restaurant_id: @restaurant1.id, tag_id: tag.id)
  end

  context '店舗編集ができるとき' do
    it 'ログインしたユーザーは自分が投稿した店舗の編集ができる' do
      # 店舗１を投稿したユーザーでログインする
      sign_in_support(@restaurant1.user)
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
        find('#floatingInputUrl').value
      ).to eq(@restaurant1.restaurant_url)
      expect(
        find('#prefecture').value
      ).to eq(@restaurant1.prefecture_id.to_s)
      expect(
        find('#floatingInputStation').value
      ).to eq(@restaurant1.station)
      expect(
        find('#genre').value
      ).to eq(@restaurant1.genre_id.to_s)
      expect(
        find('#floatingInputFood').value
      ).to eq(@restaurant1.food)
      expect(
        find('#price').value
      ).to eq(@restaurant1.price_id.to_s)
      expect(
        find('#floatingInputOpinion').value
      ).to eq(@restaurant1.opinion)
      expect(
        find('#floatingInputTag').value
      ).to eq(@restaurant1.tags[0].tag_name)
      # 投稿内容を編集する
      fill_in '店舗名', with: "#{@restaurant1.name}+編集したテキスト"
      fill_in '店舗ホームページURL', with: "#{@restaurant1.restaurant_url}+編集したテキスト"
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
      fill_in 'タグ', with: "#{@restaurant1.tags[0].tag_name}+編集したテキスト"
      # 添付する画像を定義する
      image_path = Rails.root.join('public/images/test_image2.png')
      # 画像選択フォームに画像を添付する
      attach_file('restaurant_tag[image]', image_path)
      # 編集してもRestaurantモデルのカウントは変わらないことを確認する
      expect do
        find('input[name="commit"]').click
      end.to change { Restaurant.count }.by(0)
      # 店舗詳細ページに推移したことを確認する
      expect(current_path).to eq(restaurant_path(@restaurant1))
      # トップページには先ほど変更した内容が存在することを確認する（店舗名）
      expect(page).to have_content("#{@restaurant1.name}+編集したテキスト")
    end
  end

  context '店舗編集ができないとき' do
    it 'ログインしたユーザーは自分以外が投稿したツイートの編集画面には遷移できない' do
      # 店舗1を投稿したユーザーでログインする
      sign_in_support(@restaurant1.user)
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
      # 編集ページへの推移を試みる
      visit edit_restaurant_path(@restaurant2)
      # 編集ページへ推移できず、ログインページにいることを確認する
      expect(current_path).to eq(new_user_session_path)
    end
  end
end

RSpec.describe '店舗削除', type: :system do
  before do
    user = FactoryBot.create(:user)
    @restaurant1 = FactoryBot.create(:restaurant)
    @restaurant2 = FactoryBot.create(:restaurant)
  end

  context '店舗削除ができるとき' do
    it 'ログインしたユーザーは自らが投稿した店舗の削除ができる' do
      # 店舗１を投稿したユーザーでログインする
      sign_in_support(@restaurant1.user)
      # 店舗１の店舗詳細ページへ遷移する
      visit restaurant_path(@restaurant1)
      # 店舗1に「削除」へのリンクがあることを確認する
      expect(page).to have_content('Delete')
      # 投稿を削除するとレコードの数が1減ることを確認する
      expect do
        accept_alert do
          find_link('Delete', href: restaurant_path(@restaurant1)).click
        end
        visit root_path
      end.to change { Restaurant.count }.by(-1)
      # トップページに遷移したことを確認する
      expect(current_path).to eq(root_path)
      # トップページにはツイート1の内容が存在しないことを確認する（店舗名）
      expect(page).to have_no_content(@restaurant1.name.to_s)
    end
    it '店舗を削除すると、店舗内のコメントがすべて削除されている' do
      # 店舗１を投稿したユーザーでログインする
      sign_in_support(@restaurant1.user)
      # 店舗１の店舗詳細ページへ遷移する
      visit restaurant_path(@restaurant1)
      # コメントを5つDBに追加する
      FactoryBot.create_list(:comment, 5, restaurant_id: @restaurant1.id, user_id: @restaurant1.user.id)
      # 店舗削除することで、作成した5つのコメントが削除されていることを確認する
      expect do
        accept_alert do
          find_link('Delete', href: restaurant_path(@restaurant1)).click
        end
        visit root_path
      end.to change { @restaurant1.comments.count }.by(-5)
      # トップページに遷移していることを確認する
      expect(current_path).to eq(root_path)
    end
  end
  context '店舗削除ができないとき' do
    it 'ログインしたユーザーは自分以外が投稿した店舗の削除ができない' do
      # 店舗1を投稿したユーザーでログインする
      sign_in_support(@restaurant1.user)
      # 店舗2の店舗詳細ページへ遷移する
      visit restaurant_path(@restaurant2)
      # 店舗2に「削除」へのリンクがないことを確認する
      expect(page).to have_no_content('Delete')
    end
    it 'ログアウト状態では店舗の削除ボタンがない' do
      # 店舗1の店舗詳細ページへ遷移する
      visit restaurant_path(@restaurant1)
      # 店舗1に「編集」へのリンクがないことを確認する
      expect(page).to have_no_content('Delete')
      # 店舗2の店舗詳細ページへ遷移する
      visit restaurant_path(@restaurant2)
      # 店舗2に「編集」へのリンクがないことを確認する
      expect(page).to have_no_content('Delete')
    end
  end
end

RSpec.describe '店舗詳細', type: :system do
  before do
    user = FactoryBot.create(:user)
    @restaurant1 = FactoryBot.create(:restaurant)
    @restaurant2 = FactoryBot.create(:restaurant)
    tag1 = FactoryBot.create(:tag)
    tag2 = FactoryBot.create(:tag)
    restaurant_tag_relation1 = FactoryBot.create(:restaurant_tag_relation, restaurant_id: @restaurant1.id, tag_id: tag1.id)
    restaurant_tag_relation2 = FactoryBot.create(:restaurant_tag_relation, restaurant_id: @restaurant2.id, tag_id: tag2.id)
  end

  it 'ログインしたユーザーは自分が投稿した店舗詳細ページに遷移してコメント投稿欄が表示される' do
    # 店舗１を投稿したユーザーでログインする
    sign_in_support(@restaurant1.user)
    # 店舗投稿内に「詳細」へのリンクがあることを確認する
    expect(page).to have_content('View')
    # 詳細ページに遷移する
    visit restaurant_path(@restaurant1)
    # 詳細ページにツイートの内容が含まれている
    expect(page).to have_content(@restaurant1.name)
    expect(page).to have_link @restaurant1.name, href: @restaurant1.restaurant_url
    expect(page).to have_content(@restaurant1.prefecture.name)
    expect(page).to have_content(@restaurant1.station)
    expect(page).to have_content(@restaurant1.genre.name)
    expect(page).to have_content(@restaurant1.food)
    expect(page).to have_content(@restaurant1.price.name)
    expect(page).to have_content(@restaurant1.opinion)
    expect(page).to have_content(@restaurant1.tags[0].tag_name)
    # コメント用のフォームが存在する
    expect(page).to have_selector('form[id="comment-form"]')
    # 店舗投稿内に「行きたい」・「よかった」ボタンがないことを確認する
    expect(page).to have_no_content('行きたい' && 'よかった')
  end
  it 'ログインしたユーザーは自分が投稿していない店舗詳細ページに遷移してコメント投稿欄、「行きたい」・「よかった」ボタンが表示される' do
    # 店舗１を投稿したユーザーでログインする
    sign_in_support(@restaurant1.user)
    # 店舗投稿内に「詳細」へのリンクがあることを確認する
    expect(page).to have_content('View')
    # 詳細ページに遷移する
    visit restaurant_path(@restaurant2)
    # 詳細ページにツイートの内容が含まれている
    expect(page).to have_content(@restaurant2.name)
    expect(page).to have_link @restaurant2.name, href: @restaurant2.restaurant_url
    expect(page).to have_content(@restaurant2.prefecture.name)
    expect(page).to have_content(@restaurant2.station)
    expect(page).to have_content(@restaurant2.genre.name)
    expect(page).to have_content(@restaurant2.food)
    expect(page).to have_content(@restaurant2.price.name)
    expect(page).to have_content(@restaurant2.opinion)
    expect(page).to have_content(@restaurant2.tags[0].tag_name)
    # コメント用のフォームが存在する
    expect(page).to have_selector('form[id="comment-form"]')
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
  it 'ログインしていない状態でツイート詳細ページに遷移できるもののコメント投稿欄が表示されない' do
    # トップページに移動する
    visit root_path
    # ツイートに「詳細」へのリンクがあることを確認する
    expect(page).to have_content('View')
    # 詳細ページに遷移する
    visit restaurant_path(@restaurant1)
    # 詳細ページにツイートの内容が含まれている
    expect(page).to have_content(@restaurant1.name)
    expect(page).to have_link @restaurant1.name, href: @restaurant1.restaurant_url
    expect(page).to have_content(@restaurant1.prefecture.name)
    expect(page).to have_content(@restaurant1.station)
    expect(page).to have_content(@restaurant1.genre.name)
    expect(page).to have_content(@restaurant1.food)
    expect(page).to have_content(@restaurant1.price.name)
    expect(page).to have_content(@restaurant1.opinion)
    expect(page).to have_content(@restaurant1.tags[0].tag_name)
    # フォームが存在しないことを確認する
    expect(page).to have_no_selector('form[id="comment-form"]')
    # 「コメントの投稿には新規登録/ログインが必要です」が表示されていることを確認する
    expect(page).to have_content('コメントの投稿には新規登録/ログインが必要です')
    # 店舗投稿内に「行きたい」・「よかった」ボタンを押せないことを確認する
    expect do
      find('.fa-running').click
    end.not_to change { Hope.count }
    expect do
      find('.fa-heart').click
    end.not_to change { Like.count }
  end
end
