class ProfileController < ApplicationController
  def show
    @user = User.find(params[:id])
    @recommendations = @user.recommendations
  end

  def reviews
    @reviews = current_user.reviews.includes(:recommendation)
  end
end
