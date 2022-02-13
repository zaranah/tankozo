class CommentsController < ApplicationController
  before_action :authenticate_user!, only: :create

  def create
    comment = Comment.new(comment_params)
    if comment.save
      userid = comment.user_id
      user = User.find(userid)
    end
    render json: { comment: comment, user: user }
  end

  def destroy
    @restaurant = Restaurant.find(params[:restaurant_id]) 
    @comments = @restaurant.comments.order('created_at DESC').includes(:user).page(params[:page]).per(20)
    comment = Comment.find_by(id: params[:id], restaurant_id: params[:restaurant_id])
    comment.destroy
  end

  private

  def comment_params
    params.require(:comment).permit(:comment).merge(user_id: current_user.id, restaurant_id: params[:restaurant_id])
  end
end