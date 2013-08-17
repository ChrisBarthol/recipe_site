class Reciperelationship < ActiveRecord::Base
	belongs_to :recipesaver, class_name: "User"
	belongs_to :recipesaved, class_name: "Recipe"
	validates :recipesaver_id, presence: true
	validates :recipesaved_id, presence: true
end
