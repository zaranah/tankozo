class CommentsController < ApplicationController
  before_action :authenticate_user!, only: :create

  def create
    comment = Comment.create(comment_params)
    userid = comment.user_id
    user = User.find(userid)
    render json: { comment: comment, user: user }
  end

  private

  def comment_params
    params.require(:comment).permit(:comment).merge(user_id: current_user.id, restaurant_id: params[:restaurant_id])
  end
end
