class User < ApplicationRecord
  has_secure_password

  # Active Storage
  has_one_attached :avatar
  
  # Associations
  has_many :properties, dependent: :destroy
  has_many :bookings, dependent: :destroy
  has_many :reviews, dependent: :destroy

  # Validations
  validates :email, presence: true, uniqueness: true,
                    format: { with: URI::MailTo::EMAIL_REGEXP }
  validates :password_digest, presence: true
  validates :first_name, presence: true
  validates :last_name, presence: true
  validates :avatar, content_type: { in: ['image/png', 'image/jpeg'], message: 'must be a valid image format (PNG or JPEG)' },
                     size: { less_than: 2.megabytes, message: 'must be less than 2MB' },
                     allow_blank: true

  # Methods
  def full_name
    "#{first_name} #{last_name}"
  end
end
