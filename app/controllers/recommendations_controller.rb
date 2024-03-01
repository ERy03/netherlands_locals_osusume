class RecommendationsController < ApplicationController
  skip_before_action :authenticate_user!, only: [ :index ]

  def index
    @recommendations = Recommendation.all
  end
end
