class Follow < ApplicationRecord
    belongs_to :follower, class_name: "Profile", primary_key: :user_id, foreign_key: :follower_id, counter_cache: :followings_count
    belongs_to :followee, class_name: "Profile", primary_key: :user_id, foreign_key: :followee_id, counter_cache: :followers_count
end
