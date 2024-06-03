module ApplicationHelper
  def user_initial(user)
    user.user_name[0].upcase
  end
end
