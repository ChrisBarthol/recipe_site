class Ingredient < ActiveRecord::Base
	belongs_to :recipe

	#default_scope -> { order(:name) }


	validates :name, presence: true
end
