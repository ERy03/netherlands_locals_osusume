class AddLikesCountToRecommendations < ActiveRecord::Migration[7.1]
  def change
    add_column :recommendations, :likes_count, :integer,  default: 0
  end
end
