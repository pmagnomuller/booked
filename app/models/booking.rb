class Booking < ApplicationRecord
  belongs_to :user
  belongs_to :property
  
  # Associations
  has_one :review, dependent: :destroy

  # Enums
  enum status: {
    pending: 'pending',
    confirmed: 'confirmed',
    canceled: 'canceled',
    completed: 'completed'
  }, _default: 'pending'

  # Validations
  validates :start_date, presence: true
  validates :end_date, presence: true
  validates :total_price, presence: true, numericality: { greater_than: 0 }
  validates :status, presence: true, inclusion: { in: statuses.keys }
  validate :end_date_after_start_date
  validate :no_overlapping_bookings

  # Scopes
  scope :upcoming, -> { where('start_date > ?', Date.today).order(start_date: :asc) }
  scope :past, -> { where('end_date < ?', Date.today).order(end_date: :desc) }
  scope :current, -> { where('start_date <= ? AND end_date >= ?', Date.today, Date.today) }

  # Custom validation methods
  def end_date_after_start_date
    return if end_date.blank? || start_date.blank?
    
    if end_date <= start_date
      errors.add(:end_date, "must be after the start date")
    end
  end

  def no_overlapping_bookings
    return if start_date.blank? || end_date.blank?
    
    overlapping_bookings = property.bookings
                            .where.not(id: id)
                            .where.not(status: 'canceled')
                            .where('(start_date <= ? AND end_date >= ?) OR (start_date <= ? AND end_date >= ?) OR (start_date >= ? AND end_date <= ?)',
                                   end_date, start_date, end_date, start_date, start_date, end_date)
    
    if overlapping_bookings.exists?
      errors.add(:base, "There is already a booking for this property during this period")
    end
  end

  # Calculate the number of nights
  def nights
    (end_date - start_date).to_i
  end
  
  # Calculate total price
  def calculate_total_price
    nights * property.price_per_night
  end
end
