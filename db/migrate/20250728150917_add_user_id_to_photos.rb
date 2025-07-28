class AddUserIdToPhotos < ActiveRecord::Migration[8.0]
  def change
    add_column :photos, :user_id, :bigint
    add_index :photos, :user_id
    add_foreign_key :photos, :profiles, column: :user_id, primary_key: :user_id
  end
end
