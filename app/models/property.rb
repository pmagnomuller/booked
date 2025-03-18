class Property < ApplicationRecord
  belongs_to :user
  
  # Active Storage
  has_many_attached :images
  
  # Associations
  has_many :bookings, dependent: :destroy
  has_many :reviews, dependent: :destroy

  # Validations
  validates :title, presence: true
  validates :description, presence: true
  validates :address, presence: true
  validates :city, presence: true
  validates :country, presence: true
  validates :price_per_night, presence: true, numericality: { greater_than: 0 }
  validates :max_guests, presence: true, numericality: { greater_than: 0 }
  validates :bedrooms, presence: true, numericality: { greater_than: 0 }
  validates :bathrooms, presence: true, numericality: { greater_than: 0 }
  validates :property_type, presence: true
  validates :images, content_type: { in: ['image/png', 'image/jpeg'], message: 'must be a valid image format (PNG or JPEG)' },
                     size: { less_than: 5.megabytes, message: 'must be less than 5MB' }

  # Scopes
  scope :available, -> { where(active: true) }
  scope :by_city, ->(city) { where("city ILIKE ?", "%#{city}%") }
  scope :by_price_range, ->(min, max) { where(price_per_night: min..max) }
  
  # Calculate average rating
  def average_rating
    reviews.average(:rating) || 0
  end
end
