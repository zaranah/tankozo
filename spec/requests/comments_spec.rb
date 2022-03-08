require 'rails_helper'

RSpec.describe 'Comments', type: :request do
  before do
    @restaurant = FactoryBot.create(:restaurant)
    @comment = FactoryBot.create(:comment)
  end

  describe 'POST #create' do
    it 'createアクションにリクエストすると正常にレスポンスが返ってくる' do
      sign_in @restaurant.user
      get "/restaurants/#{@restaurant.id}", params: { restaurant_id: @restaurant }
      post "/restaurants/#{@restaurant.id}/comments", params: { restaurant_id: @restaurant, comment: { comment: 'test' } }
      expect(response.status).to eq 200
    end
  end

  describe 'DELETE #destroy' do
    it 'destroyアクションにリクエストすると正常にレスポンスが返ってくる' do
      delete "/restaurants/#{@restaurant.id}/comments/#{@comment.id}"
      get "/restaurants/#{@restaurant.id}", params: { restaurant_id: @restaurant }
      expect(response.status).to eq 200
    end
    it 'ログアウト状態でdestroyアクションにリクエストすると異常のレスポンスが返ってくる' do
      get "/restaurants/#{@restaurant.id}", params: { restaurant_id: @restaurant }
      delete "/restaurants/#{@restaurant.id}/comments/#{@comment.id}",
             params: { restaurant_id: @restaurant, comment_id: @comment }
      expect(response.status).to eq 302
    end
  end
end
