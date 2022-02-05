class UsersController < ApplicationController
  before_action :authenticate_user!, only: :edit
  before_action :set_item, only: [:edit, :show, :update]
  before_action :move_to_index, only: :edit
  before_action :header_item, only: [:edit, :show]

  def edit
  end

  def update
    if current_user.update(user_params)
      redirect_to root_path
    else
      render :edit
    end
  end

  def show
    @user_hopes = @user.hopes
    @user_likes = @user.likes
  end

  private

  def set_item
    @user = User.find(params[:id])
  end

  def move_to_index
    redirect_to root_path unless current_user.id == @user.id
  end

  def header_item
      @user_restaurants = @user.restaurants
      @likes_count = 0
      @user_restaurants.each do |restaurant|
      @likes_count += restaurant.likes.count
      end
  end

  def user_params
    params.require(:user).permit(:nickname, :favorite_taste_id, :email)
  end
end
