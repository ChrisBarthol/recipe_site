class PantryItem < ActiveRecord::Base
	belongs_to :user
	belongs_to :ingredient

	validates :user_id, presence: true
	validates :ingredient_id, presence: true

end
