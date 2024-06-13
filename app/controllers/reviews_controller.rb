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

        respond_to do |format|
          if @review.save
            format.html { redirect_to recommendation_path(@recommendation) }
            format.json
          else
            format.html { render "recommendations/show", status: :unprocessable_entity }
            format.json {
              render json: {
                errors: @review.errors.full_messages,
                form: render_to_string(partial: "recommendations/review_form", locals: { recommendation: @recommendation, review: @review }, formats: :html)
              }, status: :unprocessable_entity
            }
          end
        end
    end
  end

  private

  def review_params
    params.require(:review).permit(:text, :rating, :visit_date)
  end
end
