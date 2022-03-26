require 'rails_helper'

RSpec.describe 'Tastes', type: :request do
  before do
    @user = FactoryBot.create(:user)
  end

  describe 'GET #show' do
    it 'showアクションにリクエストすると正常にレスポンスが返ってくる' do
      get taste_path(@user.favorite_taste_id)
      expect(response.status).to eq 200
    end
    it 'showアクションにリクエストするとレスポンスに味の好みが存在する' do
      get "/tastes/#{@user.favorite_taste_id}", params: { favorite_taste_id: @user.favorite_taste_id }
      expect(response.body).to include(@user.favorite_taste.name)
    end
  end
end
