class LikesController < ApplicationController
  before_action :authenticate_user!, only: [:create, :destroy]
  before_action :set_like, except: :index

  def index
    @user = User.find(params[:user_id])
    @user_likes = @user.likes.page(params[:page]).per(15)
  end

  def create
    Like.create(like_params)
    @like = Like.where(like_params)
  end

  def destroy
    @like = Like.where(like_params)
    @like.destroy_all
  end

  private

  def like_params
    params.permit(:restaurant_id).merge(user_id: current_user.id)
  end

  def set_like
    @restaurant = Restaurant.find(params[:restaurant_id])
  end
end
