json.extract! photo, :id, :image_path, :title, :description, :is_public, :hearts_count, :created_at, :updated_at
json.url photo_url(photo, format: :json)
