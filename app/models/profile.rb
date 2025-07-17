class Profile < ApplicationRecord
  validates :photos_count, :albums_count, :followers_count, :follwings_count, numericality: { greater_than_or_equal_to:  0 }

  belongs_to :user
  has_many :photos, dependent: :destroy
  has_many :albums, dependent: :destroy
end
