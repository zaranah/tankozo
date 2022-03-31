class TagsController < ApplicationController
  before_action :header_item

  def show
    @tag = Tag.find(params[:id])
    @tags = @tag.restaurants.includes({image_attachment: :blob}).page(params[:page]).per(15)
  end

  private

  def header_item
    if user_signed_in?
      @user = current_user
      @user_restaurants = @user.restaurants
      @likes_count = 0
      @user_restaurants.each do |restaurant|
        @likes_count += restaurant.likes.count
      end
    end
  end
end
