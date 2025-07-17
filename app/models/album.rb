class Album < ApplicationRecord
  validates :title, presence: true, length: { maximum: 140 }
  validates :description, presence: true, length: { maximum: 300 }
  validates :photos_count, numericality: { in: 1..25 }

  belongs_to :profile, primary_key: :user_id, foreign_key: :user_id, counter_cache: true
  has_many :photos, through: :album_components
  has_many :album_components, dependent: :destroy
end
