class LikesController < ApplicationController
  before_action :find_recommendation

  def create
    @recommendation.likes.create(user: current_user)
    redirect_to @recommendation
  end

  def destroy
    @recommendation.likes.find_by(user: current_user).destroy
    redirect_to @recommendation
  end

  private

  def find_recommendation
    @recommendation = Recommendation.find(params[:recommendation_id])
  end
end
