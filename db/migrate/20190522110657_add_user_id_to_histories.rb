class AddUserIdToHistories < ActiveRecord::Migration[5.2]
  def change
    add_column :histories, :user_id, :integer
    add_index :histories, :user_id
  end
end
