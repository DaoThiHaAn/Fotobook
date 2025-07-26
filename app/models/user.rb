class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable,
         :trackable, :confirmable
  validates :email,  presence: true, uniqueness: true, length: { maximum: 25 }, on: :create
  validates :last_name, :first_name, presence: true, length: { in: 2..25 }

  has_one :profile, dependent: :destroy

  # Override Devise's default password validation
  validate :password_complexity

  private

  def password_complexity
    return if password.blank?

    # Example: at least 8 characters, one lowercase, one uppercase, one digit
    unless password.match?(/\A(?=.*[a-z])(?=.*[A-Z])(?=.*\d).{8,}\z/)
      errors.add :password, :invalid_password_format
    end
  end
end
