class AddZaimIdToHistories < ActiveRecord::Migration[5.2]
  def change
    add_column :histories, :zaim_id, :integer
  end
end
