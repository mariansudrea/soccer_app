class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :name
      t.string :email
	  t.integer :team_id
      t.string :password_digest
      t.string :remember_token

      t.timestamps
    end
  end
end
