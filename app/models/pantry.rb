class Pantry < ActiveRecord::Base
	before_save { self.name = name.downcase }

	validates :name, presence: true#, uniqueness: true
	validates :user_id, presence: true
end
