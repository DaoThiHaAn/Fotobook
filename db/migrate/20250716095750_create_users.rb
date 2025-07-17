class CreateUsers < ActiveRecord::Migration[8.0]
  def change
    create_table :users do |t|
      t.string :email, null: false, index: { unique: true, name: "unique_emails"   }
      t.string :avatar
      t.boolean :is_active, default: true
      t.boolean :is_admin, default: false
      t.string :first_name, null: false
      t.string :last_name, null: false

      t.timestamps
    end
  end
end
