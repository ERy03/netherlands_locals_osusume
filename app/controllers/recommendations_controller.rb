class RecommendationsController < ApplicationController
  skip_before_action :authenticate_user!, only: [ :index, :show]
  before_action :set_recommendation, only: [:show]

  def index
    @recommendations = Recommendation.all
    @recommendation_count = Recommendation.count

    if params[:query].present?
        @recommendations = @recommendations.search_by_name(params[:query])
        @recommendation_count = @recommendations.length()
    end

    respond_to do |format|
      format.html # Follow regular flow of Rails
      format.json
    end
  end

  def show
  end

  private

  def set_recommendation
    @recommendation = Recommendation.find(params[:id])
  end
end
