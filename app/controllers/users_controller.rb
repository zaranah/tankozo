class UsersController < ApplicationController
  before_action :authenticate_user!, only: :edit
  before_action :set_item, only: [:edit, :show, :update]
  before_action :move_to_index, only: :edit

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
    @user_restaurants = @user.restaurants
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

  def user_params
    params.require(:user).permit(:nickname, :favorite_taste_id, :email)
  end
end
