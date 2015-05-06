class StaticPagesController < ApplicationController
include ActionView::Helpers::NumberHelper
  def home
	@team = Team.find(8)
	@schedule = Team.find(8).matches.first(5).collect.sort_by { |c| c.played_at }.reverse
	@nextGame = Game.where("played_at >= :start_date AND (away_team_id = '8' OR home_team_id = '8')",{start_date: Time.now-8.hours}).first
	@lastFifteen = Game.where("played_at <= :start_date AND (away_score >= 0) AND (away_team_id = '8' OR home_team_id = '8')",{start_date: Time.now-8.hours}).last(15)
	@season = Game.where("played_at >= :start_date",{start_date: DateTime.new(2015,4,9)})
	@a = Array.new
	@season.each do |game|
	  if game.home_score
		@a[game.home_team_id.to_i] = Hash.new unless @a[game.home_team_id.to_i]
		@a[game.away_team_id.to_i] = Hash.new unless @a[game.away_team_id.to_i]
		@a[game.home_team_id.to_i][:id] = game.home_team_id.to_i 
		@a[game.away_team_id.to_i][:id] = game.away_team_id.to_i 
		@a[game.home_team_id.to_i][:gp] = !(@a[game.home_team_id.to_i][:gp].nil?) ? @a[game.home_team_id.to_i][:gp].to_i + 1 : 1
		@a[game.away_team_id.to_i][:gp] = !(@a[game.away_team_id.to_i][:gp].nil?) ? @a[game.away_team_id.to_i][:gp].to_i + 1 : 1
		@a[game.home_team_id.to_i][:gf] = !(@a[game.home_team_id.to_i][:gf].nil?) ? @a[game.home_team_id.to_i][:gf] + game.home_score||0 : game.home_score||0
		@a[game.away_team_id.to_i][:gf] = !(@a[game.away_team_id.to_i][:gf].nil?) ? @a[game.away_team_id.to_i][:gf].to_i + game.away_score||0 : game.away_score||0
		@a[game.away_team_id.to_i][:ga] = !(@a[game.away_team_id.to_i][:ga].nil?) ? @a[game.away_team_id.to_i][:ga].to_i + game.home_score||0 : game.home_score||0
		@a[game.home_team_id.to_i][:ga] = !(@a[game.home_team_id.to_i][:ga].nil?) ? @a[game.home_team_id.to_i][:ga].to_i + game.away_score||0 : game.away_score||0

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
	
	@goalRankings = Array.new()
	Stat.all.collect.each do |s|
		@goalRankings[s.user_id.to_i] = Hash.new() unless !(@goalRankings[s.user_id.to_i].nil?)
		@goalRankings[s.user_id.to_i][:id] = s.user_id
	@goalRankings[s.user_id.to_i][:goals] = !(@goalRankings[s.user_id.to_i][:goals].nil?) ? @goalRankings[s.user_id.to_i][:goals] + s.goals : s.goals||0
	@goalRankings[s.user_id.to_i][:gp] = !(@goalRankings[s.user_id.to_i][:gp].nil?) ? @goalRankings[s.user_id.to_i][:gp] + 1 : 1
	end
	@goalRankings.compact.each do |x|
		f=(x[:goals].to_f/x[:gp]).round(2)
		x[:gpg] = number_with_precision(f, :precision => 2)
	end
	@goalRankings = @goalRankings.compact.sort_by { |x| [x[:goals],x[:gpg]] }.reverse

	@assistRankings = Array.new()
	Stat.all.collect.each do |s|
		@assistRankings[s.user_id.to_i] = Hash.new() unless !(@assistRankings[s.user_id.to_i].nil?)
		@assistRankings[s.user_id.to_i][:id] = s.user_id
		@assistRankings[s.user_id.to_i][:assists] = !(@assistRankings[s.user_id.to_i][:assists].nil?) ? @assistRankings[s.user_id.to_i][:assists] + s.assists : s.assists||0
		@assistRankings[s.user_id.to_i][:gp] = !(@assistRankings[s.user_id.to_i][:gp].nil?) ? @assistRankings[s.user_id.to_i][:gp] + 1 : 1
	end
	@assistRankings.compact.each do |x|
		f=(x[:assists].to_f/x[:gp]).round(2)
		x[:apg] = number_with_precision(f, :precision => 2)
	end
	@assistRankings = @assistRankings.compact.sort_by { |x| [x[:assists],x[:apg],-(User.find(x[:id]).id)] }.reverse






  end

  def help
  end

  
  def schedule
	@schedule = Team.find(8).matches.collect.sort_by { |c| c.played_at }.reverse
	@standings = Game.where(played_at: (DateTime.new(2014,8,14).getutc)..(DateTime.new(2014,10,25).getutc))
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

  def season
	
	@goalRankings = Array.new()
	@season_start = Array.new()
	@season_start[124]=9000;
	@season_start[123]=636;
	@season_start[122]=600;
	@season_start[121]=568;
	@season_start[120]=536;
	@season_start[119]=507;
	@season_start[118]=507;
	@season_start[117]=480;
	@season_start[116]=438;
	@season_start[115]=414;
	@season_start[114]=350;
	@season_start[113]=350;
	@season_start[112]=296;
	@season_start[111]=226;
	@season_start[110]=154;
	@season_start[108]=86;
	@season_start[107]=8;
	 
	Stat.where(game_id: @season_start[params[:id].to_i]..@season_start[params[:id].to_i+1]-1).collect.each do |s|
		@goalRankings[s.user_id.to_i] = Hash.new() unless !(@goalRankings[s.user_id.to_i].nil?)
		@goalRankings[s.user_id.to_i][:id] = s.user_id
		@goalRankings[s.user_id.to_i][:goals] = !(@goalRankings[s.user_id.to_i][:goals].nil?) ? @goalRankings[s.user_id.to_i][:goals] + s.goals : s.goals||0
		@goalRankings[s.user_id.to_i][:gp] = !(@goalRankings[s.user_id.to_i][:gp].nil?) ? @goalRankings[s.user_id.to_i][:gp] + 1 : 1
	end
	@goalRankings.compact.each do |x|
		f=(x[:goals].to_f/x[:gp]).round(2)
		x[:gpg] = number_with_precision(f, :precision => 2)
	end
	@goalRankings = @goalRankings.compact.sort_by { |x| [x[:goals],x[:gpg]] }.reverse
	
	@assistRankings = Array.new()
	Stat.where(game_id: @season_start[params[:id].to_i]..@season_start[params[:id].to_i+1]-1).collect.each do |s|
		@assistRankings[s.user_id.to_i] = Hash.new() unless !(@assistRankings[s.user_id.to_i].nil?)
		@assistRankings[s.user_id.to_i][:id] = s.user_id
		@assistRankings[s.user_id.to_i][:assists] = !(@assistRankings[s.user_id.to_i][:assists].nil?) ? @assistRankings[s.user_id.to_i][:assists] + s.assists : s.assists||0
		@assistRankings[s.user_id.to_i][:gp] = !(@assistRankings[s.user_id.to_i][:gp].nil?) ? @assistRankings[s.user_id.to_i][:gp] + 1 : 1
	end
	@assistRankings.compact.each do |x|
		f=(x[:assists].to_f/x[:gp]).round(2)
		x[:apg] = number_with_precision(f, :precision => 2)
	end
	@assistRankings = @assistRankings.compact.sort_by { |x| [x[:assists],x[:apg]] }.reverse
	@season = Game.where(id: @season_start[params[:id].to_i]..@season_start[params[:id].to_i+1]-1)

	@a = Array.new
	@season.each do |game|
	  if game.home_score
		@a[game.home_team_id.to_i] = Hash.new unless @a[game.home_team_id.to_i]
		@a[game.away_team_id.to_i] = Hash.new unless @a[game.away_team_id.to_i]
		@a[game.home_team_id.to_i][:id] = game.home_team_id.to_i 
		@a[game.away_team_id.to_i][:id] = game.away_team_id.to_i 
		@a[game.home_team_id.to_i][:gp] = !(@a[game.home_team_id.to_i][:gp].nil?) ? @a[game.home_team_id.to_i][:gp].to_i + 1 : 1
		@a[game.away_team_id.to_i][:gp] = !(@a[game.away_team_id.to_i][:gp].nil?) ? @a[game.away_team_id.to_i][:gp].to_i + 1 : 1
		@a[game.home_team_id.to_i][:gf] = !(@a[game.home_team_id.to_i][:gf].nil?) ? @a[game.home_team_id.to_i][:gf] + game.home_score||0 : game.home_score||0
		@a[game.away_team_id.to_i][:gf] = !(@a[game.away_team_id.to_i][:gf].nil?) ? @a[game.away_team_id.to_i][:gf].to_i + game.away_score||0 : game.away_score||0
		@a[game.away_team_id.to_i][:ga] = !(@a[game.away_team_id.to_i][:ga].nil?) ? @a[game.away_team_id.to_i][:ga].to_i + game.home_score||0 : game.home_score||0
		@a[game.home_team_id.to_i][:ga] = !(@a[game.home_team_id.to_i][:ga].nil?) ? @a[game.home_team_id.to_i][:ga].to_i + game.away_score||0 : game.away_score||0

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
	

  end
end
