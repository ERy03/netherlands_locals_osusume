class ReviewsController < ApplicationController
  before_action :set_review_and_recommendation, only: [:edit, :update, :destroy]
  before_action :authorize_user!, only: [:edit, :update, :destroy]

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

  def edit
  end

  def update
     begin
      ActiveRecord::Base.transaction do
        if @review.update(review_params)
          update_recommendation_rating
          redirect_to recommendation_path(@recommendation), notice: "Review was successfully updated."
        else
          render :edit, status: :unprocessable_entity
        end
      end
    rescue => e
      redirect_to edit_review_path(@review), alert: 'An unexpected error occurred. Please try again later.'
    end
  end

  def destroy
    begin
      ActiveRecord::Base.transaction do
        @review.destroy!
        update_recommendation_rating
      end
      redirect_to recommendation_path(@recommendation), status: :see_other, notice: "Review was successfully deleted."
      rescue ActiveRecord::RecordInvalid, ActiveRecord::RecordNotDestroyed => e
      redirect_to recommendation_path(@recommendation), alert: "Failed to delete review: #{e.message}"
    end
  end

  private

  def set_review_and_recommendation
    @review = Review.find(params[:id])
    @recommendation = @review.recommendation
  end


  def authorize_user!
    unless @review.user == current_user || current_user.is_admin
      redirect_to recommendation_path(@recommendation), alert: "You are not authorized to perform this action."
    end
  end

  def update_recommendation_rating
    if @recommendation.reviews.any?
      @recommendation.update!(rating: @recommendation.reviews.average(:rating).round(2))
    else
      @recommendation.update!(rating: nil)
    end
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
