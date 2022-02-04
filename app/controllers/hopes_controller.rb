class HopesController < ApplicationController
  before_action :set_hope

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
