class AlbumComponent < ApplicationRecord
  belongs_to :album, counter_cache: :photos_count
  belongs_to :photo
end
