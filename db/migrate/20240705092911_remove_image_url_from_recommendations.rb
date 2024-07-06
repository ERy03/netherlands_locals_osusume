class RemoveImageUrlFromRecommendations < ActiveRecord::Migration[7.1]
  def change
    remove_column :recommendations, :image_url
  end
end
