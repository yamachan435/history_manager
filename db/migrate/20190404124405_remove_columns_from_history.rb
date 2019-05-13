class RemoveColumnsFromHistory < ActiveRecord::Migration[5.2]
  def change
    remove_column :histories, :in_station_line, :string
    remove_column :histories, :out_station_line, :string
  end
end
