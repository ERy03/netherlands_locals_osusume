json.extract! @recommendation, :id, :name, :description, :likes_count
json.liked current_user.likes.exists?(recommendation: @recommendation)
