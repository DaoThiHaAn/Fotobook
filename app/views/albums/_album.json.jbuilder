json.extract! album, :id, :title, :description, :is_public, :hearts_count, :photos_count, :created_at, :updated_at
json.url album_url(album, format: :json)
