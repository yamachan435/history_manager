class CreateZaimUser < ActiveRecord::Migration[5.2]
  def change
    create_table :zaim_users do |t|
      t.string :access_token, null: false
      t.string :access_token_secret, null: false
    end
  end
end
