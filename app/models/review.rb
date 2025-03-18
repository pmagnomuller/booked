class Review < ApplicationRecord
  belongs_to :user
  belongs_to :property
  belongs_to :booking

  # Validations
  validates :rating, presence: true, inclusion: { in: 1..5 }
  validates :comment, presence: true, length: { minimum: 10, maximum: 1000 }
  validates :booking_id, uniqueness: { message: "has already been reviewed" }
  validate :booking_completed
  validate :user_is_booking_owner

  # Custom validations
  def booking_completed
    return unless booking
    
    unless booking.completed?
      errors.add(:booking, "must be completed before reviewing")
    end
  end

  def user_is_booking_owner
    return unless booking && user
    
    unless booking.user_id == user.id
      errors.add(:user, "must be the booking owner")
    end
  end
end
