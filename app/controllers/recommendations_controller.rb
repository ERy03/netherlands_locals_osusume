class RecommendationsController < ApplicationController
  skip_before_action :authenticate_user!, only: [ :index, :show]
  before_action :set_recommendation, only: [:show]

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
  end

  private

  def set_recommendation
    @recommendation = Recommendation.find(params[:id])
  end

  def sort_recommendations(recommendations, sort)
    case sort
    when "top_rated"
      recommendations.order(rating: :desc)
    when "low_rated"
      recommendations.order(rating: :asc)
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
