class User < ApplicationRecord
  validates :email,  presence: true, uniqueness: true, length: {maximum: 25}, on: :create
  validates :lname, :fname, presence: true, length: {maximum: 25}
  
  has_one :profile, dependent: :destroy
end
