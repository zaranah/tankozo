class TastesController < ApplicationController
  before_action :header_item

  def show
    @users = User.where(favorite_taste_id: params[:id])
    @taste_name = @users[0].favorite_taste.name
    @restaurants = Restaurant.where(user_id: @users.ids)
    @tastes = @restaurants.page(params[:page]).per(15)
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
