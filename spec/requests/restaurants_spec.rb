require 'rails_helper'

RSpec.describe "Restaurants", type: :request do

  before do
    user = FactoryBot.create(:user)
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

  # describe 'GET #new' do
  #   it 'newアクションにリクエストすると正常にレスポンスが返ってくる' do 
  #     get new_restaurant_path
  #     expect(response.status).to eq 200
  #   end
  # end

  # describe 'GET #create' do
  #   it 'createアクションにリクエストすると正常にレスポンスが返ってくる' do 
  #     get new_restaurant_path
  #     expect(response.status).to eq 200

  #     sign_in @user
  #     post "/posts", :params => { :post => { :title => "test", :body => "test", :user_id => 1}}
  #     expect(response).to have_http_status(200)
  #   end
  # end

  # describe 'GET #show' do
  #   it 'showアクションにリクエストすると正常にレスポンスが返ってくる' do
  #     get restautant_path(@restaurant)
  #     expect(response.status).to eq 200
  #   end
  #   it 'showアクションにリクエストするとレスポンスに投稿済みの店舗名が存在する' do 
  #     get restautant_path(@restaurant)
  #     expect(response.body).to include(@restaurant.name)
  #   end
  #   it 'showアクションにリクエストするとレスポンスに好みの味付けというタイトルが存在する' do 
  #     get restautant_path(@restaurant)
  #     expect(response.body).to include('好みの味付け')
  #   end
  #   it 'showアクションにリクエストするとレスポンスにコメント一覧表示部分が存在する' do 
  #     get restautant_path(@restaurant)
  #     expect(response.body).to include('コメント一覧')
  #   end
  # end 

  # describe 'GET #edit' do
  #   it 'editアクションにリクエストすると正常にレスポンスが返ってくる' do 
  #     get edit_user_path
  #     expect(response.status).to eq 200
  #   end
  # end

  # describe 'GET #create' do
  #   it 'createアクションにリクエストすると正常にレスポンスが返ってくる' do 
  #     get new_restaurant_path
  #     expect(response.status).to eq 200

  #     sign_in @user
  #     post "/posts", :params => { :post => { :title => "test", :body => "test", :user_id => 1}}
  #     expect(response).to have_http_status(200)
  #   end
  # end
end
