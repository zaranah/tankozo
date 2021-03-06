class UsersController < ApplicationController
  before_action :authenticate_user!, only: :edit
  before_action :set_item, only: [:edit, :show, :update]
  before_action :move_to_index, only: :edit

  def index
    @user = User.find(params[:user_id])
    @user_restaurants = @user.restaurants.page(params[:page]).per(15)
    @likes_count = 0
    @user_restaurants.each do |restaurant|
      @likes_count += restaurant.likes.count
    end
  end

  def edit
    @user_restaurants = @user.restaurants
    @likes_count = 0
    @user_restaurants.each do |restaurant|
      @likes_count += restaurant.likes.count
    end
  end

  def update
    if current_user.update(user_params)
      redirect_to user_path(@user)
    else
      render :edit
    end
  end

  def show
    @user_restaurants = @user.restaurants.includes(:hopes, :likes, {image_attachment: :blob}).page(params[:page]).per(15)
    @likes_count = 0
    @user_restaurants.each do |restaurant|
      @likes_count += restaurant.likes.count
    end
  end

  private

  def set_item
    @user = User.find(params[:id])
  end

  def move_to_index
    redirect_to root_path unless current_user.id == @user.id
  end

  def user_params
    params.require(:user).permit(:nickname, :favorite_taste_id, :email)
  end
end
