class AddForeignKeysToAlbumComponents < ActiveRecord::Migration[8.0]
  def change
    add_foreign_key :album_components, :albums
    add_foreign_key :album_components, :photos
  end
end
