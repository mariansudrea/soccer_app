class StaticPagesController < ApplicationController
  def home
	@team = Team.find(8)
	@player = User.find(1)
  end

  def help
  end

  def schedule
	@schedule = Team.find(8).matches.collect.sort_by { |c| c.played_at }.reverse
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
