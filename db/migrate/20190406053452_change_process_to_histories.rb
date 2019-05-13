class ChangeProcessToHistories < ActiveRecord::Migration[5.2]
  def change
    change_column(:histories, :process, :integer)
  end
end
