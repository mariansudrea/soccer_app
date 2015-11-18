class GamesController < ApplicationController
	def view
		@game = Game.find(params[:id])
		@sloboz = params[:sloboz]
		@stats = @game.stats.all.collect.sort_by { |x| [x.goals,x.assists] }.reverse
		respond_to do |format| 
			format.html
			format.js
		end
	end

end
