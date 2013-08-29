class Recipe < ActiveRecord::Base
	before_save { self.name = name.downcase }

	belongs_to :user
	default_scope -> { order('name') }
	has_many :ingredients, dependent: :destroy
	has_many :reverse_reciperelationships, foreign_key: "recipesaved_id", class_name: "Reciperelationship", dependent: :destroy
 	has_many :recipesavers, through: :reverse_reciperelationships, source: :recipesaver
 	has_many :reciperelationships, foreign_key: "recipesaver_id", dependent: :destroy
	accepts_nested_attributes_for :ingredients, :reject_if => lambda { |a| a[:name].blank? }, :reject_if => lambda { |a| a[:quantity].blank? }, allow_destroy: true
	
	validates :name, presence: true, uniqueness: { case_sensitive: false }
	validates :description, presence: true
	validates :user_id, presence: true
	validates :direction, presence: true

	def recipesaved?(recipe)
 		reciperelationships.find_by(recipesaved_id: recipe.id)
 	end

 	def recipesave!(recipe)
 		reciperelationships.create!(recipesaved_id: recipe.id)
 	end

 	def recipedelete!(recipe)
 		reciperelationships.find_by(recipesaved_id: recipe.id).destroy
 	end
end	