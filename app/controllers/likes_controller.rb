class LikesController < ApplicationController
  before_action :set_like

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
