class Recommendation < ApplicationRecord
  has_many_attached :photos
  belongs_to :user
  has_many :reviews, dependent: :destroy
  has_many :likes, dependent: :destroy

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
  validates :rating, numericality: { greater_than_or_equal_to: 1, less_than_or_equal_to: 5 }, allow_nil: true
  validates :name, presence: true, uniqueness: true
  validates :website_url, format: { with: /\Ahttps?:\/\/[^\s\/$.?#].[^\s]*\z/i }, allow_blank: true
  validates :instagram_url, format: { with: /\Ahttps:\/\/(?:www\.)?instagram\.com\/[^\s]*\z/ }, allow_blank: true
  validates :visit_date, presence: true, comparison: { less_than_or_equal_to: Date.today }
  validates :recommendation_type, inclusion: { in: Recommendation.recommendation_types.keys }, presence: true
  validates :photos, length: {maximum: 4, message: "count maximum is 4"}
  validate :correct_photo_mime_type, :photo_size_validation

  private

  def correct_photo_mime_type
    return unless photos.attached?

    invalid_photos = photos.select do |photo|
      !photo.content_type.in?(%w(image/jpeg image/png image/heic image/heif image/avif))
    end

    if invalid_photos.any?
      errors.add(:photos, 'must be a JPEG, PNG, HEIF or HEIC')
    end
  end

  def photo_size_validation
    return unless photos.attached?

    large_photos = photos.select do |photo|
      photo.byte_size > 5.megabytes
    end

    if large_photos.any?
      errors.add(:photos, "should be less than 5MB")
    end
  end

  def set_default_values
    self.visit_date ||= Date.today
  end
end
