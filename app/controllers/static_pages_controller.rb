class StaticPagesController < ApplicationController
	include ActionView::Helpers::NumberHelper
#	force_ssl if Rails.env.production?


  
  def home
	@team = Team.find(8)
	@schedule = Team.find(8).matches.first(5).collect.sort_by { |c| c.played_at }.reverse
	@nextGame = Game.where("played_at >= :start_date AND (away_team_id = '8' OR home_team_id = '8')",{start_date: Time.now-8.hours}).first
	@lastFifteen = Game.where("played_at <= :start_date AND (away_score >= 0) AND (away_team_id = '8' OR home_team_id = '8')",{start_date: Time.now-8.hours}).last(15)
	@season = Game.where("played_at >= :start_date",{start_date: DateTime.new(2015,11,18)})
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

  def stats 
	@players = User.all()
	@opponents = Team.where.not(id: 8)
	@goalRankings = Array.new()
	@assistRankings = Array.new()
	@efficiencyRankings = Array.new()



	@season_start = Array.new()
	@season_start[141]=9999;
	@season_start[140]=1117;
	@season_start[139]=1084;
	@season_start[138]=1052;
	@season_start[137]=1052;
	@season_start[136]=1026;
	@season_start[135]=994;
	@season_start[134]=970;
	@season_start[133]=943;
	@season_start[132]=911;
	@season_start[131]=883;
	@season_start[130]=859;
	@season_start[129]=823;
	@season_start[128]=799;
	@season_start[127]=767;
	@season_start[126]=735;
	@season_start[125]=699;
	@season_start[124]=667;
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

###################	INIT BASED ON REQUEST PARAMETERS #######################
	@seasonId = params[:id].to_i || 0
	@who = params[:who].to_i || 0
	@field = params[:field].to_i || 0
	@opp = params[:opp].to_i || 0
	@user = params[:user].to_i || 0

	if @seasonId > 0  
		@title = "Filter: Sesssion " + @seasonId.to_s
 		@stat = Stat.where(game_id: @season_start[params[:id].to_i]..@season_start[params[:id].to_i+1]-1)
		@games = Game.where(id: @season_start[params[:id].to_i]..@season_start[params[:id].to_i+1]-1).collect  
	elsif @seasonId == 0 && @who == 0
		if @field == 0 && @opp == 0
			@games = Game.all.sort{ |a,b| a.id <=> b.id }
			@title = "Filter: All Stats"
			@stat = Stat.all
		elsif @field == 0 && @opp > 0
			@games = (Game.where(home_team_id: @opp.to_s, away_team_id: "8")	+ Game.where(home_team_id: "8", away_team_id: @opp.to_s)).sort{ |a,b| a.id <=> b.id }
			@title = "Filter: All Stats vs " + Team.find(@opp).name
			@containerArray = Array.new
			@games.each do |game|
				game.stats.each do |stat|
					@containerArray.push(stat)
				end
			end  
			@stat = @containerArray 	
		elsif @field > 0 && @opp == 0
			@containerArray = Array.new
			@title = "Filter: All Stats, Field " + @field.to_s + "(field data available since 2014)"
			@games = ((Team.find(8).home_games) + (Team.find(8).away_games)).select{ |x| x.field == @field }.sort{ |a,b| a.id <=> b.id }
			@games.each do |game|
				Game.find(game.id).stats.each do |stat|
					@containerArray.push(stat)
				end
			end  
			@stat = @containerArray 
		elsif @field > 0 && @opp > 0
			@containerArray = Array.new
			@title = "Filter: vs" + Team.find(@opp).name + ", Field " + @field.to_s + "(field data available since 2014)"
			@games = (Game.where(home_team_id: @opp.to_s, away_team_id: "8")	+ Game.where(home_team_id: "8", away_team_id: @opp.to_s)).sort{ |a,b| a.id <=> b.id }
			@games = @games.select { |x| x.field == @field}
			@games.each do |game|
				Game.find(game.id).stats.each do |stat|
					@containerArray.push(stat)
				end
			end  
			@stat = @containerArray 
		end
	elsif @seasonId == 0 && @who > 0
        @player = User.find(params[:user])
        @gpg = 0
        @apg = 0
        @player.stats.each do |stat|
            @gpg = stat.goals.to_i + @gpg||0.00
            @apg = stat.assists.to_i + @apg||0.00
        end
        @gpg = (@gpg.to_f / @player.stats.length).round(2)
        @apg = (@apg.to_f / @player.stats.length).round(2)
	end

################### END INIT ###############################
  if @who == 0
	@stat.collect.each do |s|
		@goalRankings[s.user_id.to_i] = Hash.new() unless !(@goalRankings[s.user_id.to_i].nil?)
		@goalRankings[s.user_id.to_i][:id] = s.user_id
		@goalRankings[s.user_id.to_i][:goals] = !(@goalRankings[s.user_id.to_i][:goals].nil?) ? @goalRankings[s.user_id.to_i][:goals] + s.goals : s.goals||0
		@goalRankings[s.user_id.to_i][:gp] = !(@goalRankings[s.user_id.to_i][:gp].nil?) ? @goalRankings[s.user_id.to_i][:gp] + 1 : 1
		@assistRankings[s.user_id.to_i] = Hash.new() unless !(@assistRankings[s.user_id.to_i].nil?)
		@assistRankings[s.user_id.to_i][:id] = s.user_id
		@assistRankings[s.user_id.to_i][:assists] = !(@assistRankings[s.user_id.to_i][:assists].nil?) ? @assistRankings[s.user_id.to_i][:assists] + s.assists : s.assists||0
		@assistRankings[s.user_id.to_i][:gp] = !(@assistRankings[s.user_id.to_i][:gp].nil?) ? @assistRankings[s.user_id.to_i][:gp] + 1 : 1
		@efficiencyRankings[s.user_id.to_i] = Hash.new() unless !(@efficiencyRankings[s.user_id.to_i].nil?)
		@efficiencyRankings[s.user_id.to_i][:id] = s.user_id
		@efficiencyRankings[s.user_id.to_i][:gp] = !(@efficiencyRankings[s.user_id.to_i][:gp].nil?) ? @efficiencyRankings[s.user_id.to_i][:gp] + 1 : 1
		a = Game.find(s.game_id)
		if a.home_team.id.to_s == "8"
			@efficiencyRankings[s.user_id.to_i][:eff] = !(@efficiencyRankings[s.user_id.to_i][:eff].nil?) ? @efficiencyRankings[s.user_id.to_i][:eff] + a.home_score.to_i - a.away_score.to_i : a.home_score.to_i - a.away_score.to_i || 0
		else
			@efficiencyRankings[s.user_id.to_i][:eff] = !(@efficiencyRankings[s.user_id.to_i][:eff].nil?) ? @efficiencyRankings[s.user_id.to_i][:eff] + a.away_score.to_i - a.home_score.to_i : a.away_score.to_i - a.home_score.to_i||0
		end
	end
	@goalRankings.compact.each do |x|
		f=(x[:goals].to_f/x[:gp]).round(2)
		x[:gpg] = number_with_precision(f, :precision => 2)
	end
	@goalRankings = @goalRankings.compact.sort_by { |x| [x[:goals]] }.reverse
	if params[:gpg].to_i == 1
		@goalRankings = @goalRankings.compact.sort_by { |x| [x[:gpg]] }.reverse
	end
	@assistRankings.compact.each do |x|
		f=(x[:assists].to_f/x[:gp]).round(2)
		x[:apg] = number_with_precision(f, :precision => 2)
	end
	@efficiencyRankings.compact.each do |x|
		f=(x[:eff].to_f/x[:gp]).round(2)
		x[:eff] = number_with_precision(f, :precision => 2)
	end




	@assistRankings = @assistRankings.compact.sort_by { |x| [x[:assists]] }.reverse
	@efficiencyRankings = @efficiencyRankings.compact.sort! { |a,b| a[:eff].to_f <=> b[:eff].to_f }.reverse
	if params[:apg].to_i == 1
		@assistRankings = @assistRankings.compact.sort_by { |x| [x[:apg]] }.reverse
	end
	if params[:id] != "0" && params[:id]
		@season = Game.where(id: @season_start[params[:id].to_i]..@season_start[params[:id].to_i+1]-1)
	else
		@season = Game.all()
	end
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
	  end
	end
  end
	respond_to do |format|
		format.html
      	format.js 
    end
  end
end
