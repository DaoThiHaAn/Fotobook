class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable,
         :trackable, :confirmable
  validates :email,  presence: true, uniqueness: true, length: { maximum: 25 }, on: :create
  validates :last_name, :first_name, presence: true, length: { in: 2..25 }

  has_one :profile, dependent: :destroy
end
