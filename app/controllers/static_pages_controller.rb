class StaticPagesController < ApplicationController
  def home
	@team = Team.find(1)
	@player = User.find(1)
  end

  def help
  end

  def schedule
	@schedule = Team.find(1).matches.collect.sort_by { |c| c.id }
  end
	
  def team
	@players = Team.find(1).users.collect.sort_by { |c| c.id }
  end

  def feed
  end

  def about
  end

  def contact
  end
end
