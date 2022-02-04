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

  private

  def comment_params
    params.require(:comment).permit(:comment).merge(user_id: current_user.id, restaurant_id: params[:restaurant_id])
  end
end
