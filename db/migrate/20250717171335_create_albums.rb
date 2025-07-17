class CreateAlbums < ActiveRecord::Migration[8.0]
  def change
    create_table :albums do |t|
      t.text :title
      t.text :description
      t.boolean :is_public
      t.integer :hearts_count, default: 0
      t.integer :photos_count, default: 1

      t.timestamps
    end
  end
end
