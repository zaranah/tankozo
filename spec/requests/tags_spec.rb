require 'rails_helper'

RSpec.describe 'Tags', type: :request do
  before do
    @tag = FactoryBot.create(:tag)
  end

  describe 'GET #show' do
    it 'showアクションにリクエストすると正常にレスポンスが返ってくる' do
      get "/tags/#{@tag.id}", params: { tag_id: @tag }
      expect(response.status).to eq 200
    end
    it 'showアクションにリクエストするとレスポンスにタグ名が存在する' do
      get "/tags/#{@tag.id}", params: { tag_id: @tag }
      expect(response.body).to include(@tag.tag_name)
    end
  end
end
