class AddUniqueIndexToReviews < ActiveRecord::Migration[7.1]
  def change
    add_index :reviews, [:user_id, :recommendation_id], unique: true
  end
end
