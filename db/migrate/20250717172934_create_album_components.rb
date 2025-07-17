class CreateAlbumComponents < ActiveRecord::Migration[8.0]
  def change
    create_table :album_components, primary_key: [:album_id, :photo_id] do |t|
      t.belongs_to :album
      t.belongs_to :photo

      t.timestamps
    end
  end
end
