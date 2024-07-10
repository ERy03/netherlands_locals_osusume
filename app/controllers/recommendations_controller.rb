class RecommendationsController < ApplicationController
  skip_before_action :authenticate_user!, only: [ :index, :show]
  before_action :set_recommendation, only: [:show, :destroy, :edit, :update]
  before_action :authorize_user!, only: [:edit, :update, :destroy]

  def index
    @recommendations = Recommendation.all
    @recommendation_count = Recommendation.count

    if params[:query].present?
        @recommendations = @recommendations.where("name ILIKE ?", "%#{params[:query]}%")
        @recommendation_count = @recommendations.length()
    end

    if params[:sort].present?
      @recommendations = sort_recommendations(@recommendations, params[:sort])
    end

    if params[:filter].present?
      @recommendations = filter_recommendations(@recommendations, params[:filter])
      @recommendation_count = @recommendations.length()
    end

    respond_to do |format|
      format.html # Follow regular flow of Rails
      format.json
    end
  end

  def show
    @reviews = @recommendation.reviews.includes(:user).order(created_at: :desc)
    @review = Review.new(recommendation: @recommendation)
  end

  def new
    @recommendation = Recommendation.new
  end

  def create
    @recommendation = Recommendation.new(recommendation_params)
    @recommendation.user = current_user

    if @recommendation.save
      redirect_to recommendation_path(@recommendation)
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
  end

  def update
    if remove_current_photos(recommendation_params[:photos])
      # Check if it already has photos and purge them
      if @recommendation.photos.attached?
        @recommendation.photos.purge
      end
    end

    if @recommendation.update(recommendation_params.except(:photos))
      # Attach new photos if provided
      if recommendation_params[:photos].present? && recommendation_params[:photos].any?(&:present?)
        recommendation_params[:photos].each do |photo|
          @recommendation.photos.attach(photo)
        end
      end
      redirect_to recommendation_path(@recommendation), notice: "Osusume was successfully updated."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    if @recommendation.photos.attached?
      @recommendation.photos.purge
    end

    @recommendation.destroy
    redirect_to recommendations_path, status: :see_other, notice: "Osusume was successfully deleted."
  end

  private


  def remove_current_photos(photos)
    return false unless photos # Handle nil case

    photos.any? { |photo| !photo.blank? }
  end

  def recommendation_params
    params.require(:recommendation).permit(:name, :description, :address, :visit_date, :recommendation_type, :website_url, :instagram_url, :price, photos: [])
  end

  def set_recommendation
    @recommendation = Recommendation.find(params[:id])
    @is_created_by_current_user = @recommendation.user == current_user
    @is_admin = user_signed_in? && current_user.is_admin
  end

  def authorize_user!
    unless @is_created_by_current_user || @is_admin
      redirect_to recommendation_path(@recommendation), alert: "You are not authorized to perform this action."
    end
  end

  def sort_recommendations(recommendations, sort)
    case sort
    when "top_rated"
      recommendations.order(Arel.sql('COALESCE(rating, 0) DESC'))
    when "low_rated"
      recommendations.order(Arel.sql('COALESCE(rating, 0) ASC'))
    when "newly_added"
      recommendations.order(created_at: :desc)
    when "old"
      recommendations.order(created_at: :asc)
    when "az"
      recommendations.order(name: :asc)
    when "za"
      recommendations.order(name: :desc)
    else
      recommendations
    end
  end

  def filter_recommendations(recommendations, filter)
    case filter
    when 'Restaurant'
      recommendations.where(recommendation_type: :Restaurant)
    when 'Cafe'
      recommendations.where(recommendation_type: :Cafe)
    when 'Shop'
      recommendations.where(recommendation_type: :Shop)
    when 'Event'
      recommendations.where(recommendation_type: :Event)
    when 'Park'
      recommendations.where(recommendation_type: :Park)
    when 'Bakery'
      recommendations.where(recommendation_type: :Bakery)
    when 'Market'
      recommendations.where(recommendation_type: :Market)
    when 'Scenery'
      recommendations.where(recommendation_type: :Scenery)
    when 'Other'
      recommendations.where(recommendation_type: :Other)
    else
      recommendations
    end
  end

end
