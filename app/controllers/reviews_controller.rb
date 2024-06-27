class ReviewsController < ApplicationController
  def create
    @recommendation = Recommendation.find(params[:recommendation_id])
    # Checks if user has already written a review
    existing_review = @recommendation.reviews.find_by(user: current_user)

    if existing_review
      render json: { errors: ["You have already submitted a review for this recommendation."] }, status: :unprocessable_entity
    else
      @review = Review.new(review_params)
      @review.recommendation = @recommendation
      @review.user = current_user

      # Use transacation to prevent race conditions
      begin
        ActiveRecord::Base.transaction do
          if @review.save
            update_recommendation_rating
            respond_to do |format|
              format.html { redirect_to recommendation_path(@recommendation) }
              format.json
            end
          else
            handle_review_errors
          end
        end
      rescue => e
        handle_unexpected_errors(e)
      end
    end
  end

  private

  def update_recommendation_rating
    @recommendation.update!(rating: @recommendation.reviews.average(:rating).round(2))
  end

  def review_params
    params.require(:review).permit(:text, :rating, :visit_date)
  end

  def handle_review_errors
    respond_to do |format|
      format.html { render "recommendations/show", status: :unprocessable_entity }
      format.json {
        render json: {
          errors: @review.errors.full_messages,
          form: render_to_string(partial: "recommendations/review_form", locals: { recommendation: @recommendation, review: @review }, formats: :html)
        }, status: :unprocessable_entity
      }
    end
  end

  def handle_unexpected_errors(exception)
    respond_to do |format|
      format.html { redirect_to recommendation_path(@recommendation), alert: 'An unexpected error occurred. Please try again later.' }
      format.json { render json: { errors: ["An unexpected error occurred. Please try again later."] }, status: :internal_server_error }
    end
  end
end
