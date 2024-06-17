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

  # Enum for price
  enum price: {
    'Free': 0,
    '€1-10': 1,
    '€10-30': 2,
    '€30+': 3
  }

  # Validations
  validates :description, presence: true, length: { minimum: 10, maximum: 1000 }
  validates :rating, presence: true
  validates :name, presence: true, uniqueness: true
  validates :website_url, format: URI::regexp(%w[http https]), allow_blank: true
  validates :instagram_url, format: URI::regexp(%w[http https]), allow_blank: true
  validates :visit_date, presence: true, comparison: { less_than_or_equal_to: Date.today }
  validates :recommendation_type, inclusion: { in: Recommendation.recommendation_types.keys }, presence: true

  private

  def set_default_values
    self.rating ||= 5
    self.visit_date ||= Date.today
  end
end
