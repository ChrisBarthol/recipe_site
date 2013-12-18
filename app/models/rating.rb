class Rating < ActiveRecord::Base
	belongs_to :recipe
	validates :user_id, presence: true
	validates :recipe_id, presence: true
	validates :ranking, :inclusion => 1..10
end
