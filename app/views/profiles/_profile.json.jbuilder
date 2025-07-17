json.extract! profile, :id, :photos_count, :albums_count, :followers_count, :followings_count, :created_at, :updated_at
json.url profile_url(profile, format: :json)
