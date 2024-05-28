class Recommendation < ApplicationRecord
  belongs_to :user

  before_validation :set_default_visit_date, on: :create

  # Enum for recommendation_type
  enum recommendation_type: {
    'Restaurant': 0,
    'Cafe': 1,
    'Shop': 2,
    'Event': 3,
    'Park': 4,
    'Bakery': 5,
    'Market': 6,
    'Scenery': 7,
    'Other': 8
  }

  # Validations
  validates :name, presence: true, uniqueness: true
  validates :visit_date, comparison: { less_than_or_equal_to: Date.today }
  validates :recommendation_type, inclusion: { in: Recommendation.recommendation_types.keys }

  private

  def set_default_visit_date
    self.visit_date ||= Date.today
  end
end
