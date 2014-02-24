class Ingredient < ActiveRecord::Base
	before_save { self.name = name.downcase }
	include Tire::Model::Search
    include Tire::Model::Callbacks
	belongs_to :recipe
	has_many :pantry_items

	#default_scope -> { order(:name) }

	validates :name, presence: true

	def self.search(params)
    	tire.search(load: true) do  
    		query { string params[:query]} if params[:query].present?
    	end
    end
end
