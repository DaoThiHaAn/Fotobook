class AlbumComponent < ApplicationRecord
  belongs_to :album, counter_cache: :photos_count
  belongs_to :photo, optional: true

  # nest photo attributes directly under album_component (for new photo uploads)
  accepts_nested_attributes_for :photo, reject_if: :all_blank
end
