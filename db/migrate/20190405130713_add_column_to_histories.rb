class AddColumnToHistories < ActiveRecord::Migration[5.2]
  def change
    add_column :histories, :linked_at, :date
    add_column :histories, :amount, :integer
  end
end
