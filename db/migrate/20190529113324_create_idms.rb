class CreateIdms < ActiveRecord::Migration[5.2]
  def change
    create_table :idms do |t|
      t.string :idm
      t.references :user
    end
  end
end
