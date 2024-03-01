class Recommendation < ApplicationRecord
  belongs_to :user

  # TODO: add more validations if necessary
  validates :name, presence: true, uniqueness: true
  validates :visit_date, comparison: {less_than_or_equal_to: Date.today}
  enum recommendation_type: { 'Other': 8, 'Scenery': 7, 'Market': 6, 'Bakery': 5, 'Park': 4, 'Event': 3, 'Shop': 2, 'Cafe': 1, 'Restaurant': 0 }
end
