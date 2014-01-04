class User < ActiveRecord::Base
	has_many :stats
	belongs_to :team
end
