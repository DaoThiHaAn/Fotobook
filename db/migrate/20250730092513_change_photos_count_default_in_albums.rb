class ChangePhotosCountDefaultInAlbums < ActiveRecord::Migration[8.0]
  def change
    change_column_default :albums, :photos_count, 0
  end
end
