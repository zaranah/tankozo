class RestaurantsController < ApplicationController
  before_action :authenticate_user!, only: :new

  def index
    @restaurants = Restaurant.order('created_at DESC')
  end

  def new
    @restaurant = Restaurant.new
  end

  def create
    @restaurant = Restaurant.new(restaurant_params)
    if @restaurant.save
      redirect_to root_path
    else
      render :new
    end
  end

  private

  def restaurant_params
    params.require(:restaurant).permit(
      :name, :prefecture_id, :station, :genre_id, :food, :price_id, :opinion, :image
    ).merge(user_id: current_user.id)
  end
end
