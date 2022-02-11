class HopesController < ApplicationController
  before_action :authenticate_user!, only: [:create, :destroy]
  before_action :set_hope, except: :index

  def index
    @user = User.find(params[:user_id])
    @user_hopes = @user.hopes.page(params[:page]).per(15)
  end

  def create
    Hope.create(hope_params)
    @hope = Hope.where(hope_params)
  end

  def destroy
    @hope = Hope.where(hope_params)
    @hope.destroy_all
  end

  private

  def hope_params
    params.permit(:restaurant_id).merge(user_id: current_user.id)
  end

  def set_hope
    @restaurant = Restaurant.find(params[:restaurant_id])
  end
end
