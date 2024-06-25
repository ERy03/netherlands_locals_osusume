class AddUrlsAndChangePriceToEnumInRecommendations < ActiveRecord::Migration[7.1]
  def change
    add_column :recommendations, :website_url, :string
    add_column :recommendations, :instagram_url, :string
    remove_column :recommendations, :price, :float
    add_column :recommendations, :price, :integer
  end
end
