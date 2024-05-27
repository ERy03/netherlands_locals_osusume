class ChangeDefaultDateInRecommendations < ActiveRecord::Migration[7.1]
  def change
    change_column_default :recommendations, :visit_date, Date.today
  end
end
