class CreateFollows < ActiveRecord::Migration[8.0]
  def change
    create_table :follows, primary_key: [ :follower_id, :followee_id ] do |t|
      t.bigint :follower_id, null: false  # references profiles.user_id
      t.bigint :followee_id, null: false  # references profiles.user_id
      t.timestamps
    end

    add_foreign_key :follows, :profiles, column: :follower_id, primary_key: :user_id
    add_foreign_key :follows, :profiles, column: :followee_id, primary_key: :user_id
  end
end
