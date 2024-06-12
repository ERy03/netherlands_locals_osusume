class Review < ApplicationRecord
  belongs_to :user
  belongs_to :recommendation

  before_validation :set_default_values, on: :create

  validates :text, presence: true, length: { minimum: 10, maximum: 1000 }
  validates :rating, presence: true, numericality: { greater_than_or_equal_to: 1, less_than_or_equal_to: 5 }
  validates :visit_date, comparison: { less_than_or_equal_to: Date.today }
  validates :user_id, uniqueness: { scope: :recommendation_id, message: "You have already submitted a review for this recommendation" }

  private

  def set_default_values
    self.rating ||= 5
    self.visit_date ||= Date.today
  end
end
