class RenameActionColumnToHistories < ActiveRecord::Migration[5.2]
  def change
    rename_column :histories, :action, :process
  end
end
