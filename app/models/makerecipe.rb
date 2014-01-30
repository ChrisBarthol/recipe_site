class Makerecipe < ActiveRecord::Base
	belongs_to :maker, class_name: "User"
	belongs_to :made, class_name: "Recipe"

	validates :maker_id, presence: true
	validates :made_id, presence: true
end
