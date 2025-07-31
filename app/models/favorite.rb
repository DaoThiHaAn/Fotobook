class Favorite < ApplicationRecord
  belongs_to :post, polymorphic: true, counter_cache: :hearts_count
  belongs_to :profile, foreign_key: :user_id, primary_key: :user_id
end
