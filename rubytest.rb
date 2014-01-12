@counter=2;
File.open("IMPORT_READY.txt", "r").each_line do |line|
	if /\S/ =~ line
		@a = line.split("#")
		if !Team.find_by(name: @a[1]) 
		 	c = Team.new(name: @a[1]) 
			c.save
		end 
		if !Team.find_by(name: @a[4]) 
		 	d = Team.new(name: @a[4]) 
			d.save
		end 
		@g=Team.find_by(name: @a[1]).id
		@h=Team.find_by(name: @a[4]).id
		if @a[5].respond_to?(:split)
			@j=@a[5].split(",")
		else
			@j=[1,1,14]
		end
		t=Date.new(@j[0].to_i,@j[1].to_i,@j[2].to_i)
		f=Game.new(home_team_id: @g, away_team_id: @h, home_score: @a[2], away_score: @a[3], played_at: t)
		f.save
	end
end
