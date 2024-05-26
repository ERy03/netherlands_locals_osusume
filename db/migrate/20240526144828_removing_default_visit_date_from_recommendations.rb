class RemovingDefaultVisitDateFromRecommendations < ActiveRecord::Migration[7.1]
  def up
    change_column_default :recommendations, :visit_date, nil
  end

  def down
    change_column_default :recommendations, :visit_date, '2024-05-26'
  end
end
