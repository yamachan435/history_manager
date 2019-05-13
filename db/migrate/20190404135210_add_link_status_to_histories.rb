class AddLinkStatusToHistories < ActiveRecord::Migration[5.2]
  def change
    add_column :histories, :link_status, :integer, null: false, default: 0
  end
end
