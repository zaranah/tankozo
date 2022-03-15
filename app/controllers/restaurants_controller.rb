class RestaurantsController < ApplicationController
  before_action :authenticate_user!, only: [:new, :edit, :destroy]
  before_action :set_item, only: [:edit, :show, :update, :destroy]
  before_action :move_to_index, only: [:edit, :destroy]
  before_action :header_item

  def index
    @restaurants = Restaurant.order('created_at DESC').page(params[:page]).per(6)
    @restaurant_likes_ranks = Restaurant.find(Like.group(:restaurant_id).order('count(restaurant_id) desc').includes(:restaurant).limit(5).pluck(:restaurant_id))
  end

  def new
    @restaurant_tag = RestaurantTag.new
  end

  def create
    @restaurant_tag = RestaurantTag.new(restaurant_tag_params)
    if @restaurant_tag.valid?
      @restaurant_tag.save
      redirect_to root_path
    else
      render :new
    end
  end

  def show
    @comment = Comment.new
    @comments = @restaurant.comments.page(params[:page]).per(10).order('created_at DESC').includes(:user)
    if user_signed_in?
      @like = Like.where(user_id: current_user.id, restaurant_id: @restaurant.id)
      @hope = Hope.where(user_id: current_user.id, restaurant_id: @restaurant.id)
    end
  end

  def edit
    restaurant_attributes = @restaurant.attributes
    @restaurant_tag = RestaurantTag.new(restaurant_attributes)
    @restaurant_tag.tag_name = @restaurant.tags.pluck(:tag_name).join(',')
  end

  def update
    @restaurant_tag = RestaurantTag.new(restaurant_tag_params)
    # 画像を選択し直していない場合は、既存の画像をセットする
    @restaurant_tag.image ||= @restaurant.image.blob
    if @restaurant_tag.valid?
      @restaurant_tag.update(restaurant_tag_params, @restaurant)
      redirect_to restaurant_path(@restaurant)
    else
      render :edit
    end
  end

  def destroy
    @restaurant.destroy
    redirect_to root_path
  end

  def search
    if params[:q]&.dig(:name)
      squished_keywords = params[:q][:name].squish
      params[:q][:name_cont_any] = squished_keywords.split(' ')
    end

    if params[:q]&.dig(:station)
      squished_keywords = params[:q][:station].squish
      params[:q][:station_cont_any] = squished_keywords.split(' ')
    end

    if params[:q]&.dig(:food)
      squished_keywords = params[:q][:food].squish
      params[:q][:food_cont_any] = squished_keywords.split(' ')
    end

    @q = Restaurant.ransack(params[:q])
    @restaurants = @q.result.page(params[:page]).per(9)
  end

  def intro
  end

  private

  def set_item
    @restaurant = Restaurant.find(params[:id])
  end

  def move_to_index
    redirect_to action: :index unless current_user.id == @restaurant.user_id
  end

  def header_item
    if user_signed_in?
      @user = current_user
      @user_restaurants = @user.restaurants
      @likes_count = 0
      @user_restaurants.each do |restaurant|
        @likes_count += restaurant.likes.count
      end
    end
  end

  def restaurant_tag_params
    params.require(:restaurant_tag).permit(
      :name, :restaurant_url, :prefecture_id, :station, :genre_id, :food, :price_id, :opinion, :tag_name, :image
    ).merge(user_id: current_user.id)
  end
end
