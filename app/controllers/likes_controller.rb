class LikesController < ApplicationController
  before_action :find_recommendation

  def create
    if current_user
      like = @recommendation.likes.create(user: current_user)
      if like.save
        render json: { liked: true, likes_count: @recommendation.likes.count }, status: :created
      else
        render json: { errors: like.errors.full_messages }, status: :unprocessable_entity
      end
    else
      render json: { status: 'error', message: 'User must be logged in to like a recommendation' }
    end
  end

  def destroy
    if current_user
      like = @recommendation.likes.find_by(user: current_user)
      if like&.destroy
        render json: { liked: false, likes_count: @recommendation.likes.count }, status: :ok
      else
        render json: { errors: ["Unable to unlike recommendation"] }, status: :unprocessable_entity
      end
    else
      render json: { status: 'error', message: 'User must be logged in to unlike a recommendation' }
    end
  end

  private

  def find_recommendation
    @recommendation = Recommendation.find(params[:recommendation_id])
  end
end
