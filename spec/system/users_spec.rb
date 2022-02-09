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
