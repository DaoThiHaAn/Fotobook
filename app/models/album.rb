class Album < ApplicationRecord
  validates :title, presence: true, length: { maximum: 140 }
  validates :description, presence: true, length: { maximum: 300 }
  # validates :photos_count, numericality: { in: 1..25 }

  belongs_to :profile, primary_key: :user_id, foreign_key: :user_id, counter_cache: true
  has_many :album_components, dependent: :destroy
  has_many :photos, through: :album_components

  # This is crucial for accepting nested photo attributes
  accepts_nested_attributes_for :album_components, allow_destroy: true, reject_if: :all_blank
  accepts_nested_attributes_for :photos
end
