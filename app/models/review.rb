class Review < ApplicationRecord
  belongs_to :user
  belongs_to :recommendation

  before_validation :set_default_visit_date, on: :create

  validates :text, presence: true, length: { minimum: 10, maximum: 1000 }
  validates :rating, presence: true, numericality: { greater_than_or_equal_to: 0, less_than_or_equal_to: 5 }
  validates :visit_date, comparison: { less_than_or_equal_to: Date.today }

  private

  def set_default_visit_date
    self.visit_date ||= Date.today
  end
end
