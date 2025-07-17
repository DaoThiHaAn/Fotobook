class CreateProfiles < ActiveRecord::Migration[8.0]
  def change
    create_table :profiles, id: false do |t|
      t.bigint :user_id, primary_key: true
      t.integer :photos_count, default: 0
      t.integer :albums_count, default: 0
      t.integer :followers_count, default: 0
      t.integer :followings_count, default: 0
      t.timestamps
    end

    add_foreign_key :profiles, :users, column: :user_id, primary_key: :id, on_delete: :cascade
  end
end
