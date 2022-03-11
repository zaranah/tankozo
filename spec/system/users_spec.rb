require 'rails_helper'

RSpec.describe 'ユーザー新規登録', type: :system do
  before do
    @user = FactoryBot.build(:user)
  end

  context 'ユーザー新規登録ができるとき' do
    it '正しい情報を入力すればユーザー新規登録ができてトップページに移動する' do
      # トップページに移動する
      visit root_path
      # トップページに新規登録ページへ遷移するボタンがあることを確認する
      expect(
        find('.dropdown').click
      ).to have_content('新規登録')
      # 新規登録ページへ移動する
      visit new_user_registration_path
      # ユーザー情報を入力する
      expect(
        find('.collection').click
      ).to have_content('薄味派')
      find('option[value="2"]').click
      fill_in 'Nickname', with: @user.nickname
      fill_in 'Email address', with: @user.email
      fill_in 'Password', with: @user.password
      fill_in 'Password confirmation', with: @user.password_confirmation
      # 新規登録ボタンを押すとユーザーモデルのカウントが1上がることを確認する
      expect do
        find('input[name="commit"]').click
      end.to change { User.count }.by(1)
      # トップページへ遷移したことを確認する
      expect(current_path).to eq(root_path)
      # ヘッダーをクリックするとログアウトボタンが表示されることを確認する
      expect(
        find('.dropdown').click
      ).to have_content('Sign out')
      # 新規登録ページへ遷移するボタンや、ログインページへ遷移するボタンが表示されていないことを確認する
      expect(
        find('.dropdown').click
      ).to have_no_content('新規登録' && 'ログイン')
    end
  end
  context 'ユーザー新規登録ができないとき' do
    it '誤った情報ではユーザー新規登録ができずに新規登録ページへ戻ってくる' do
      # トップページに移動する
      visit root_path
      # トップページに新規登録ページへ遷移するボタンがあることを確認する
      expect(
        find('.dropdown').click
      ).to have_content('新規登録')
      # 新規登録ページへ移動する
      visit new_user_registration_path
      # ユーザー情報を入力する
      expect(
        find('.collection').click
      ).to have_content('薄味派')
      find('option[value="1"]').click
      fill_in 'Nickname', with: ''
      fill_in 'Email', with: ''
      fill_in 'Password', with: ''
      fill_in 'Password confirmation', with: ''
      # 送信ボタンを押してもユーザーモデルのカウントは上がらないことを確認する
      expect  do
        find('input[name="commit"]').click
      end.to change { User.count }.by(0)
      # 新規登録ページへ戻されることを確認する
      expect(current_path).to eq user_registration_path
    end
  end
end

RSpec.describe 'ログイン', type: :system do
  before do
    @user = FactoryBot.create(:user)
  end
  context 'ログインができるとき' do
    it 'ログインに成功し、トップページに遷移する' do
      # トップページに移動する
      visit root_path
      # トップページに「ログイン」へのリンクがあることを確認する
      expect(
        find('.dropdown').click
      ).to have_content('ログイン')
      # ログインページへ移動する
      visit new_user_session_path
      # すでに保存されているユーザーのemailとpasswordを入力する
      fill_in 'Email address', with: @user.email
      fill_in 'Password', with: @user.password
      # ログインボタンをクリックする
      find('input[name="commit"]').click
      # トップページに遷移していることを確認する
      expect(current_path).to eq(root_path)
      # ヘッダーをクリックするとログアウトボタン、編集ボタン、マイページボタンが表示されることを確認する
      expect(
        find('.dropdown').click
      ).to have_content('Sign out' && 'Edit profile' && 'My page')
      # 新規登録ページ、ログインページへ遷移するボタンが表示されていないことを確認する
      expect(
        find('.dropdown').click
      ).to have_no_content('新規登録' && 'ログイン')
    end
  end

  context 'ログインができないとき' do
    it 'ログインに失敗し、再びサインインページに戻ってくる' do
      # トップページに移動する
      visit root_path
      # 予め、ユーザーをDBに保存する
      @user = FactoryBot.create(:user)
      # ログインページへ移動する
      visit new_user_session_path
      # 誤ったユーザー情報を入力する
      fill_in 'Email address', with: 'test@test'
      fill_in 'Password', with: 'test'
      # ログインボタンをクリックする
      find('input[name="commit"]').click
      # ログインページに戻ってきていることを確認する
      expect(current_path).to eq(new_user_session_path)
    end
  end
end

RSpec.describe 'マイページ', type: :system do
  before do
    @user = FactoryBot.create(:user)
    @user2 = FactoryBot.create(:user)
  end

  it 'ログインしたユーザーは自分のマイページに遷移してユーザー情報が表示される' do
    # 店舗１を投稿したユーザーでログインする
    sign_in_support(@user)
    # マイページに遷移する
    visit user_path(@user)
    # マイページにユーザー情報が含まれている
    expect(page).to have_content(@user.nickname)
    expect(page).to have_content(@user.favorite_taste.name)
  end
  it 'ログインしたユーザーは自分以外のマイページに遷移してユーザー情報が表示される' do
    # 店舗１を投稿したユーザーでログインする
    sign_in_support(@user)
    # マイページに遷移する
    visit user_path(@user2)
    # マイページにユーザー情報が含まれている
    expect(page).to have_content(@user2.nickname)
    expect(page).to have_content(@user2.favorite_taste.name)
  end
end

RSpec.describe 'ユーザー編集', type: :system do
  before do
    @user = FactoryBot.create(:user)
    @user2 = FactoryBot.create(:user)
  end

  context '店舗編集ができるとき' do
    it 'ログインしたユーザーは自分のユーザー情報の編集ができる' do
      # トップページに移動する
      visit root_path
      # トップページに「ログイン」へのリンクがあることを確認する
      expect(
        find('.dropdown').click
      ).to have_content('ログイン')
      # ログインページへ移動する
      visit new_user_session_path
      # すでに保存されているユーザーのemailとpasswordを入力する
      fill_in 'Email address', with: @user.email
      fill_in 'Password', with: @user.password
      # ログインボタンをクリックする
      find('input[name="commit"]').click
      # トップページに遷移していることを確認する
      expect(current_path).to eq(root_path)
      # ヘッダーをクリックすると編集ボタンが表示されることを確認する
      expect(
        find('.dropdown').click
      ).to have_content('Edit profile')
      # 編集ページへ遷移する
      visit edit_user_path(@user)
      # すでに登録済みの内容がフォームに入っていることを確認する
      expect(
        find('#floatingInputNickname').value
      ).to eq(@user.nickname)
      expect(
        find('#favorite-taste').value
      ).to eq(@user.favorite_taste_id.to_s)
      expect(
        find('#floatingInputEmailaddress').value
      ).to eq(@user.email)
      # ユーザー情報を編集する
      expect(
        all('.collection')[0].click
      ).to have_content('薄味派')
      all('option[value="3"]')[0].click
      fill_in 'Nickname', with: "#{@user.nickname}+編集したテキスト"
      fill_in 'Email address', with: "#{@user.email}test"
      # 編集してもUserモデルのカウントは変わらないことを確認する
      expect do
        find('input[name="commit"]').click
      end.to change { User.count }.by(0)
      # マイページに推移したことを確認する
      expect(current_path).to eq(user_path(@user))
      # トップページには先ほど変更した内容が存在することを確認する
      expect(page).to have_content("#{@user.nickname}+編集したテキスト")
    end
  end

  context 'ユーザー編集ができないとき' do
    it 'ログインしたユーザーは自分以外が投稿したツイートの編集画面には遷移できない' do
      # ログインページへ移動する
      visit new_user_session_path
      # すでに保存されているユーザーのemailとpasswordを入力する
      fill_in 'Email address', with: @user.email
      fill_in 'Password', with: @user.password
      # ログインボタンをクリックする
      find('input[name="commit"]').click
      # 編集ページへの推移を試みる
      visit edit_user_path(@user2)
      # 編集ページへ推移できず、トップページにいることを確認する
      expect(current_path).to eq(root_path)
    end
    it 'ログインしていないとツイートの編集画面には遷移できない' do
      # 編集ページへの推移を試みる
      visit edit_user_path(@user)
      # 編集ページへ推移できず、ログインページにいることを確認する
      expect(current_path).to eq(new_user_session_path)
    end
  end
end