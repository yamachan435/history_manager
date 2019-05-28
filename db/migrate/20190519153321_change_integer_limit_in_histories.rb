class ChangeIntegerLimitInHistories < ActiveRecord::Migration[5.2]
  def change
    change_column :histories, :zaim_id, :integer, limit: 8
  end
end
