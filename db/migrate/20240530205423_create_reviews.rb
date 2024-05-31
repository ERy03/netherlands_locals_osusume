class CreateReviews < ActiveRecord::Migration[7.1]
  def change
    create_table :reviews do |t|
      t.references :user, null: false, foreign_key: true
      t.references :recommendation, null: false, foreign_key: true
      t.text :text
      t.float :rating
      t.date :visit_date

      t.timestamps
    end
  end
end
