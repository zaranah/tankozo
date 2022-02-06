class RestaurantsController < ApplicationController
  before_action :authenticate_user!, only: [:new, :edit, :destroy]
  before_action :set_item, only: [:edit, :show, :update, :destroy]
  before_action :move_to_index, only: [:edit, :destroy]
  before_action :header_item

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

  def show
    @comment = Comment.new
    @comments = @restaurant.comments.order('created_at DESC').includes(:user)
    if user_signed_in?
      @like = Like.where(user_id: current_user.id, restaurant_id: @restaurant.id)
      @hope = Hope.where(user_id: current_user.id, restaurant_id: @restaurant.id)
    end
  end

  def edit
  end

  def update
    if @restaurant.update(restaurant_params)
      redirect_to restaurant_path(@restaurant)
    else
      render :edit
    end
  end

  def destroy
    @restaurant.destroy
    redirect_to root_path
  end

  def search
    @restaurants = Restaurant.search(params[:keyword])
    # @restaurants = SearchRestaurantsService.search(params[:keyword])
  end

  private

  def set_item
    @restaurant = Restaurant.find(params[:id])
  end

  def move_to_index
    redirect_to action: :index unless current_user.id == @restaurant.user_id
  end

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

  def restaurant_params
    params.require(:restaurant).permit(
      :name, :prefecture_id, :station, :genre_id, :food, :price_id, :opinion, :image
    ).merge(user_id: current_user.id)
  end
end
