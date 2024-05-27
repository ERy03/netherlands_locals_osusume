class RecommendationsController < ApplicationController
  skip_before_action :authenticate_user!, only: [ :index, :show]
  before_action :set_recommendation, only: [:show]

  def index
    @recommendations = Recommendation.all
    if params[:query].present?
        @recommendations = @recommendations.search_by_name(params[:query])
    end
  end

  def show
  end

  private

  def set_recommendation
    @recommendation = Recommendation.find(params[:id])
  end
end
