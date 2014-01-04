class Ingredient < ActiveRecord::Base
	include Tire::Model::Search
    include Tire::Model::Callbacks
	belongs_to :recipe
	has_many :pantry_items

	#default_scope -> { order(:name) }

	validates :name, presence: true
end
