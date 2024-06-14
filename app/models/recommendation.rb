class Recommendation < ApplicationRecord
  belongs_to :user
  has_many :reviews, dependent: :destroy

  before_validation :set_default_values, on: :create

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
  validates :description, presence: true, length: { minimum: 10, maximum: 1000 }
  validates :rating, presence: true
  validates :name, presence: true, uniqueness: true
  validates :visit_date, comparison: { less_than_or_equal_to: Date.today }
  validates :recommendation_type, inclusion: { in: Recommendation.recommendation_types.keys }

  private

  def set_default_values
    self.rating ||= 5
    self.visit_date ||= Date.today
  end
end
