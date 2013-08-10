class Ingredient < ActiveRecord::Base
	belongs_to :recipe

	default_scope -> { order(:name) }


	validates :quantity, presence: true
	validates :name, presence: true
end
