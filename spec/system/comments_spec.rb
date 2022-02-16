require 'rails_helper'

RSpec.describe 'コメント投稿', type: :system do
  before do
    @restaurant = FactoryBot.create(:restaurant)
    @comment = FactoryBot.create(:comment)
  end

  context 'コメント投稿に成功したとき' do
    it 'ログインしたユーザーはレストラン詳細ページでコメント投稿できる' do
      # ログインする
      sign_in(@comment.user)
      # レストラン詳細ページに遷移する
      visit restaurant_path(@restaurant)
      # フォームに情報を入力してコメントするとCommentモデルのカウントが1上がっていることを確認する
      post = @comment.comment
      expect do
        fill_in 'comment[comment]', with: post
        click_button 'SEND'
        visit current_path
      end.to change { Comment.count }.by(1)
      # 詳細ページにいることを確認する
      expect(current_path).to eq(restaurant_path(@restaurant))
      # 詳細ページ上に先ほどのコメント内容が含まれていることを確認する
      expect(page).to have_content(post)
    end
  end

  context 'コメント投稿ができないとき' do
    it '送る値が空の為、メッセージの送信に失敗する' do
      # ログインする
      sign_in(@comment.user)
      # レストラン詳細ページに遷移する
      visit restaurant_path(@restaurant)
      # フォームに空で入力する
      fill_in 'comment[comment]', with: ''
      # DBに保存されていないことを確認する
      expect do
        find('input[name="commit"]').click
      end.not_to change { Comment.count }
      # 詳細ページにいることを確認する
      expect(current_path).to eq(restaurant_path(@restaurant))
    end

    it 'ログアウトの状態ではコメントできない' do
      # レストラン詳細ページに遷移する
      visit restaurant_path(@restaurant)
      # コメント投稿するボタンが表示されていないことを確認する
      expect(page).to have_no_content('SEND')
    end
  end
end

RSpec.describe 'コメント削除', type: :system do
  before do
    @comment1 = FactoryBot.create(:comment)
    @comment2 = FactoryBot.create(:comment)
  end

  context 'コメント削除ができるとき' do
    it 'ログインしたユーザーは自らが投稿したコメントの削除ができる' do
      # コメント１を投稿したユーザーでログインする
      sign_in(@comment1.user)
      # コメント1を投稿した店舗詳細ページへ遷移する
      visit restaurant_path(@comment1.restaurant)
      # コメントを削除するとレコードの数が1減ることを確認する
      expect do
        accept_alert do
          find('.fa-trash-alt').click
        end
        visit restaurant_path(@comment1.restaurant)
      end.to change { Comment.count }.by(-1)
      # 店舗詳細ページにいることを確認する
      expect(current_path).to eq(restaurant_path(@comment1.restaurant))
      # トップページにはコメント1の内容が存在しないことを確認する（店舗名）
      expect(page).to have_no_content(@comment1.comment)
    end
  end
  context 'コメント削除ができないとき' do
    it 'ログインしたユーザーは自分以外が投稿したコメントの削除ができない' do
      # コメント１を投稿したユーザーでログインする
      sign_in(@comment1.user)
      # コメント2を投稿した店舗詳細ページへ遷移する
      visit restaurant_path(@comment2.restaurant)
      # コメント削除ボタンがないことを確認する
      expect(page).to have_no_content('.fa-trash-alt')
    end
    it 'ログアウト状態ではコメントの削除ボタンがない' do
      # コメント１を投稿した店舗詳細ページへ遷移する
      visit restaurant_path(@comment1.restaurant)
      # コメント削除ボタンがないことを確認する
      expect(page).to have_no_content('.fa-trash-alt')
      # コメント2を投稿した店舗詳細ページへ遷移する
      visit restaurant_path(@comment2.restaurant)
      # コメント削除ボタンがないことを確認する
      expect(page).to have_no_content('.fa-trash-alt')
    end
  end
end