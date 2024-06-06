class ReviewsController < ApplicationController
  def create
    @recommendation = Recommendation.find(params[:recommendation_id])
    raise
  end
end
