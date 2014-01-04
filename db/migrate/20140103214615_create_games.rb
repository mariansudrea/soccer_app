class CreateGames < ActiveRecord::Migration
  def change
    create_table :games do |t|
      t.string :home_team_id
      t.string :away_team_id
      t.integer :home_score
      t.integer :away_score
	  t.datetime :played_at

      t.timestamps
    end
  end
end
