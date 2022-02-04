class RestaurantsController < ApplicationController
  before_action :authenticate_user!, only: [:new, :edit, :destroy]
  before_action :set_item, only: [:edit, :show, :update, :destroy]
  before_action :move_to_index, only: [:edit, :destroy]

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

  private

  def set_item
    @restaurant = Restaurant.find(params[:id])
  end

  def move_to_index
    redirect_to action: :index unless current_user.id == @restaurant.user_id
  end

  def restaurant_params
    params.require(:restaurant).permit(
      :name, :prefecture_id, :station, :genre_id, :food, :price_id, :opinion, :image
    ).merge(user_id: current_user.id)
  end
end
