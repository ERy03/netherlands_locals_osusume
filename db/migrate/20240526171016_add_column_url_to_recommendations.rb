class AddColumnUrlToRecommendations < ActiveRecord::Migration[7.1]
  def change
    add_column :recommendations, :image_url, :string
  end
end
