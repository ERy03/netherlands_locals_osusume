class CreateRecommendations < ActiveRecord::Migration[7.1]
  def change
    create_table :recommendations do |t|
      t.string :name
      t.references :user, null: false, foreign_key: true
      t.text :description
      t.date :visit_date
      t.string :address
      t.integer :recommendation_type
      t.float :price
      t.float :rating

      t.timestamps
    end
  end
end
