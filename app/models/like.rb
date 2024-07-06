class Like < ApplicationRecord
  belongs_to :user
  belongs_to :recommendation, counter_cache: true

  validates :user_id, uniqueness: { scope: :recommendation_id }
end
