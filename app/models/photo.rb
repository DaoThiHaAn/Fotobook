class Photo < ApplicationRecord
  validates :title, presence: true, length: { maximum: 140 }
  validates :description, length: { maximum: 300 }

  mount_uploader :image_path, PhotoUploader

  has_many :album_components, dependent: :destroy
  has_many :albums, through: :album_components
  belongs_to :profile, primary_key: :user_id, foreign_key: :user_id, counter_cache: true

  has_many :favorites, as: :post, dependent: :destroy
end
