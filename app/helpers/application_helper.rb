module ApplicationHelper
  def user_initial(user)
    user.user_name[0].upcase
  end

  # Prevent Cross-Site Scripting
  def safe_url(url)
    ERB::Util.html_escape(url)
  end
end
