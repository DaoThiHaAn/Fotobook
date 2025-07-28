class AddUserIdToAlbums < ActiveRecord::Migration[8.0]
  def change
    add_column :albums, :user_id, :bigint
    add_index :albums, :user_id
    add_foreign_key :albums, :profiles, column: :user_id, primary_key: :user_id
  end
end
