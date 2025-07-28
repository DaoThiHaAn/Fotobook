class Profile < ApplicationRecord
  validates :photos_count, :albums_count, :followers_count, :follwings_count, numericality: { greater_than_or_equal_to:  0 }

  belongs_to :user
  has_many :photos, dependent: :destroy
  has_many :albums, dependent: :destroy

  # Follows the user initiated (user is the follower)
  has_many :active_follows,
           class_name: "Follow",
           foreign_key: :follower_id,
           dependent: :destroy,
           inverse_of: :follower

  has_many :followings,
           through: :active_follows,
           source: :followee

  # Follows the user received (user is the followee)
  has_many :passive_follows,
           class_name: "Follow",
           foreign_key: :followee_id,
           dependent: :destroy,
           inverse_of: :followee

  has_many :followers,
           through: :passive_follows,
           source: :follower
end
