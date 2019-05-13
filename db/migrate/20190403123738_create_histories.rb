class CreateHistories < ActiveRecord::Migration[5.2]
  def change
    create_table :histories do |t|
      t.string :console
      t.string :action
      t.date :date
      t.string :in_station_line
      t.string :in_station
      t.string :out_station_line
      t.string :out_station
      t.integer :balance

      t.timestamps
    end
  end
end
