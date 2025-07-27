class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable,
         :trackable, :confirmable,
        :omniauthable, omniauth_providers: %i[facebook google_oauth2]
  validates :email,  presence: true, uniqueness: true, length: { maximum: 25 }, on: :create
  validates :last_name, :first_name, presence: true, length: { in: 2..25 }

  has_one :profile, dependent: :destroy
  has_many :identities, dependent: :destroy


  def self.from_omniauth(auth)
    identity = Identity.find_by(
      provider: auth.provider,
      uid: auth.uid
    )

    return identity.user if identity

    # Find existing user by email
    user = User.find_by(email: auth.info.email)

    unless user
      user = User.create(
        email: auth.info.email,
        password: Devise.friendly_token[0, 20],
        first_name: auth.info.first_name || auth.info.name&.split&.first || "First",
        last_name: auth.info.last_name || auth.info.name&.split&.last || "Last"
      )
    end

    # Create identity for the user
    user.identities.create!(
      provider: auth.provider,
      uid: auth.uid)

      user
  end

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
