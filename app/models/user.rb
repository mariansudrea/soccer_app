class User < ActiveRecord::Base
	has_many :stats
	belongs_to :team
	has_secure_password
end
