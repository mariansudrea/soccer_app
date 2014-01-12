class PlayersController < ApplicationController

	def view
		@player = User.find(params[:id])
	end

end
