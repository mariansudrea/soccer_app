class PlayersController < ApplicationController

	def view
		@player = User.find(params[:id])
		@gpg = 0
		@apg = 0
		@player.stats.each do |stat|
			@gpg = stat.goals.to_i + @gpg||0.00
			@apg = stat.assists.to_i + @apg||0.00
		end
		@gpg = (@gpg.to_f / @player.stats.length).round(2)
		@apg = (@apg.to_f / @player.stats.length).round(2)
	end

end
