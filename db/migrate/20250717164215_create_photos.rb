class CreatePhotos < ActiveRecord::Migration[8.0]
  def change
    create_table :photos do |t|
      t.string :image_path
      t.text :title
      t.text :description
      t.boolean :is_public
      t.integer :hearts_count, default: 0

      t.timestamps
    end
  end
end
