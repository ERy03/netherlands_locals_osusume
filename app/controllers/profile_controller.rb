class ProfileController < ApplicationController
  def show
    @user = User.find(params[:id])
    @recommendations = @user.recommendations
  end
end
