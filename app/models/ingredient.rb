class Ingredient < ActiveRecord::Base
	include Tire::Model::Search
    include Tire::Model::Callbacks
	belongs_to :recipe

	#default_scope -> { order(:name) }

	validates :name, presence: true
end
