class CreateFavorites < ActiveRecord::Migration[8.0]
  def change
      create_table :favorites do |t|
        t.bigint  :user_id, null: false
        t.bigint  :post_id, null: false
        t.string  :post_type, null: false
        t.timestamps
      end

      add_index :favorites, [ :user_id, :post_id, :post_type ], unique: true
      add_index :favorites, [ :post_type, :post_id ] # for polymorphic association speed
      add_foreign_key :favorites, :profiles, column: :user_id, primary_key: :user_id
  end
end
