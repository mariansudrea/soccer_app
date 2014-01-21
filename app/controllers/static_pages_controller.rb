class StaticPagesController < ApplicationController
  def home
	@team = Team.find(8)
	@schedule = Team.find(8).matches.first(5).collect.sort_by { |c| c.played_at }.reverse
	@season = Game.where("played_at >= :start_date",{start_date: DateTime.new(2013,12,15)})
	@a = Array.new
	@season.each do |game|
		@a[game.home_team_id.to_i] = Hash.new unless @a[game.home_team_id.to_i]
		@a[game.away_team_id.to_i] = Hash.new unless @a[game.away_team_id.to_i]
		@a[game.home_team_id.to_i][:id] = game.home_team_id.to_i 
		@a[game.away_team_id.to_i][:id] = game.away_team_id.to_i 
		@a[game.home_team_id.to_i][:gp] = !(@a[game.home_team_id.to_i][:gp].nil?) ? @a[game.home_team_id.to_i][:gp].to_i + 1 : 1
		@a[game.away_team_id.to_i][:gp] = !(@a[game.away_team_id.to_i][:gp].nil?) ? @a[game.away_team_id.to_i][:gp].to_i + 1 : 1
		@a[game.home_team_id.to_i][:gf] = !(@a[game.home_team_id.to_i][:gf].nil?) ? @a[game.home_team_id.to_i][:gf] + game.home_score : game.home_score
		@a[game.away_team_id.to_i][:gf] = !(@a[game.away_team_id.to_i][:gf].nil?) ? @a[game.away_team_id.to_i][:gf].to_i + game.away_score : game.away_score
		@a[game.away_team_id.to_i][:ga] = !(@a[game.away_team_id.to_i][:ga].nil?) ? @a[game.away_team_id.to_i][:ga].to_i + game.home_score : game.home_score
		@a[game.home_team_id.to_i][:ga] = !(@a[game.home_team_id.to_i][:ga].nil?) ? @a[game.home_team_id.to_i][:ga].to_i + game.away_score : game.away_score

	 	if game.home_score == game.away_score 
			@a[game.away_team_id.to_i][:t] = !(@a[game.away_team_id.to_i][:t].nil?) ? @a[game.away_team_id.to_i][:t].to_i + 1 : 1
			@a[game.home_team_id.to_i][:t] = !(@a[game.home_team_id.to_i][:t].nil?) ? @a[game.home_team_id.to_i][:t].to_i + 1 : 1
			@a[game.away_team_id.to_i][:pts] = !(@a[game.away_team_id.to_i][:pts].nil?) ? @a[game.away_team_id.to_i][:pts].to_i + 1 : 1
			@a[game.home_team_id.to_i][:pts] = !(@a[game.home_team_id.to_i][:pts].nil?) ? @a[game.home_team_id.to_i][:pts].to_i + 1 : 1

		elsif game.home_score > game.away_score 
			@a[game.away_team_id.to_i][:l] = !(@a[game.away_team_id.to_i][:l].nil?) ? @a[game.away_team_id.to_i][:l].to_i + 1 : 1
			@a[game.home_team_id.to_i][:w] = !(@a[game.home_team_id.to_i][:w].nil?) ? @a[game.home_team_id.to_i][:w].to_i + 1 : 1
			@a[game.home_team_id.to_i][:pts] = !(@a[game.home_team_id.to_i][:pts].nil?) ? @a[game.home_team_id.to_i][:pts].to_i + 3 : 3
		else
			@a[game.away_team_id.to_i][:w] = !(@a[game.away_team_id.to_i][:w].nil?) ? @a[game.away_team_id.to_i][:w].to_i + 1 : 1
			@a[game.home_team_id.to_i][:l] = !(@a[game.home_team_id.to_i][:l].nil?) ? @a[game.home_team_id.to_i][:l].to_i + 1 : 1
			@a[game.away_team_id.to_i][:pts] = !(@a[game.away_team_id.to_i][:pts].nil?) ? @a[game.away_team_id.to_i][:pts].to_i + 3 : 3
		end
		@a
	end
  end

  def help
  end

  
  def schedule
	@schedule = Team.find(8).matches.collect.sort_by { |c| c.played_at }.reverse
	@standings = Game.where(played_at: (DateTime.new(2013,12,15).getutc)..(DateTime.new(2014,2,15).getutc))
	respond_to do |format|
      format.html
      format.xml 
    end
  end
  def results
	@schedule = Team.find(8).matches.collect.sort_by { |c| c.played_at }.reverse
	respond_to do |format|
      format.xml 
    end
  end
  def roster
	respond_to do |format|
      format.xml 
    end
  end
  def team
	@players = Team.find(8).users.collect.sort_by { |c| c.id }
  end

  def feed
  end

  def about
  end

  def contact
  end
end
