class Recommendation < ApplicationRecord
  belongs_to :user

  before_validation :set_default_visit_date, on: :create

  # Validations
  validates :name, presence: true, uniqueness: true
  validates :visit_date, comparison: { less_than_or_equal_to: Date.today }

  # Enum for recommendation_type
  enum recommendation_type: {
    'Other': 8,
    'Scenery': 7,
    'Market': 6,
    'Bakery': 5,
    'Park': 4,
    'Event': 3,
    'Shop': 2,
    'Cafe': 1,
    'Restaurant': 0
  }

  private

  def set_default_visit_date
    self.visit_date ||= Date.today
  end
end
