require 'rails_helper'

RSpec.describe "Restaurants", type: :request do

  before do
    @restaurant = FactoryBot.create(:restaurant)
  end

  describe 'GET #index' do
    it 'indexアクションにリクエストすると正常にレスポンスが返ってくる' do 
      get root_path
      expect(response.status).to eq 200
    end
    it 'indexアクションにリクエストするとレスポンスに投稿済みの店舗名が存在する' do 
      get root_path
      expect(response.body).to include(@restaurant.name)
    end
    it 'indexアクションにリクエストするとレスポンスに投稿済みの店舗画像が存在する' do 
      get root_path
      expect(response.body).to include('img')
    end
    it 'indexアクションにリクエストするとレスポンスに投稿検索フォームが存在する' do 
      get root_path
      expect(response.body).to include('Multiple search')
    end
  end

  describe 'GET #new' do
    it 'newアクションにリクエストすると正常にレスポンスが返ってくる' do
      sign_in @restaurant.user
      get new_restaurant_path
      expect(response.status).to eq 200
    end
    it 'newアクションにリクエストするとレスポンスに投稿フォームのタイトルお店を紹介するが存在する' do 
      sign_in @restaurant.user
      get new_restaurant_path
      expect(response.body).to include('お店を紹介する')
    end
    it 'ログアウト状態でnewアクションにリクエストすると異常のレスポンスが返ってくる' do
      get new_restaurant_path
      expect(response.status).to eq 302
    end
  end

  describe 'POST #create' do
    it 'createアクションにリクエストすると正常にレスポンスが返ってくる' do 
      sign_in @restaurant.user
      get new_restaurant_path
      @image = fixture_file_upload('public/images/test_image.png', 'image/png')
      post "/restaurants", :params => { :restaurant_tag => { :name => "test", :prefecture_id => "2", :station => "test", :genre_id => "2", :food => "test", :price_id => "2", :opinion => "test", :user_id => 1}}
      expect(response).to have_http_status(200)
    end
  end

  describe 'GET #show' do
    it 'showアクションにリクエストすると正常にレスポンスが返ってくる' do
      get "/restaurants/#{@restaurant.id}", params: { restaurant_id: @restaurant }
      expect(response.status).to eq 200
    end
    it 'showアクションにリクエストするとレスポンスに投稿済みの店舗名が存在する' do 
      get "/restaurants/#{@restaurant.id}", params: { restaurant_id: @restaurant }
      expect(response.body).to include(@restaurant.name)
    end
    it 'showアクションにリクエストするとレスポンスに好みの味付けというタイトルが存在する' do 
      get "/restaurants/#{@restaurant.id}", params: { restaurant_id: @restaurant }
      expect(response.body).to include('好みの味付け')
    end
    it 'showアクションにリクエストするとレスポンスにコメント一覧表示部分が存在する' do 
      get "/restaurants/#{@restaurant.id}", params: { restaurant_id: @restaurant }
      expect(response.body).to include('コメント一覧')
    end
  end

  describe 'GET #edit' do
    it 'editアクションにリクエストすると正常にレスポンスが返ってくる' do
      sign_in @restaurant.user
      get "/restaurants/#{@restaurant.id}/edit", params: { restaurant_id: @restaurant }
      expect(response.status).to eq 200
    end
    it 'editアクションにリクエストするとレスポンスに投稿フォームのタイトルお店を紹介するが存在する' do 
      sign_in @restaurant.user
      get "/restaurants/#{@restaurant.id}/edit", params: { restaurant_id: @restaurant }
      expect(response.body).to include('お店を編集する')
    end
    it 'ログアウト状態でnewアクションにリクエストすると異常のレスポンスが返ってくる' do
      get "/restaurants/#{@restaurant.id}/edit", params: { restaurant_id: @restaurant }
      expect(response.status).to eq 302
    end
  end

  describe 'PATCH #update' do
    it 'updateアクションにリクエストすると正常にレスポンスが返ってくる' do 
      sign_in @restaurant.user
      get "/restaurants/#{@restaurant.id}/edit", params: { restaurant_id: @restaurant }
      patch "/restaurants/#{@restaurant.id}", params: { restaurant_id: @restaurant, :restaurant_tag => { :name => "test"}}
      expect(response).to have_http_status(200)
    end
  end

  describe 'DELETE #destroy' do
    it 'destroyアクションにリクエストすると正常にレスポンスが返ってくる' do 
      sign_in @restaurant.user
      delete "/restaurants/#{@restaurant.id}", params: { restaurant_id: @restaurant }
      expect(response).to redirect_to root_path
    end
      it 'ログアウト状態でdestroyアクションにリクエストすると異常のレスポンスが返ってくる' do
      delete "/restaurants/#{@restaurant.id}", params: { restaurant_id: @restaurant }
      expect(response.status).to eq 302
    end
  end
end
