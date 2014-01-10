class GamesController < ApplicationController
	def view
		@game = Game.find(params[:id])
		@stats = @game.stats.all.collect
	end

end
