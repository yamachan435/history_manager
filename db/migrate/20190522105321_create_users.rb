class CreateUsers < ActiveRecord::Migration[5.2]
  def change
    create_table :users do |t|
      t.string :name, null: false
      t.integer :zaim_user_id
      t.timestamps
    end
    add_index :users, :zaim_user_id
  end
end
