class CreateStats < ActiveRecord::Migration
  def change
    create_table :stats do |t|
	  
	  t.integer :user_id
      t.integer :goals
      t.integer :assists
      t.integer :game_id

      t.timestamps
    end
  end
end
