class AlterUserAndZaimUser < ActiveRecord::Migration[5.2]
  def change
    add_column :zaim_users, :user_id, :integer
    remove_column :users, :zaim_user_id, :integer
  end
end
