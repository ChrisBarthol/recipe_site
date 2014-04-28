class Recipe < ActiveRecord::Base
	
	before_save { self.name = name.downcase }


	belongs_to :user
	
	has_many :ingredients, dependent: :destroy
	has_many :reverse_reciperelationships, foreign_key: "recipesaved_id", class_name: "Reciperelationship", dependent: :destroy
 	has_many :recipesavers, through: :reverse_reciperelationships, source: :recipesaver
 	has_many :reciperelationships, foreign_key: "recipesaver_id", dependent: :destroy
	accepts_nested_attributes_for :ingredients, :reject_if => lambda { |a| a[:name].blank? }, allow_destroy: true
	has_many :comments
	has_many :ratings, dependent: :destroy
	has_many :reverse_makerecipes, foreign_key: "made_id", class_name: "Makerecipe", dependent: :destroy
	has_many :makers, through: :reverse_makerecipes, source: :maker

	validates :name, presence: true, uniqueness: { case_sensitive: false }
	validates :description, presence: true
	validates :user_id, presence: true
	validates :direction, presence: true

	mount_uploader :recipeimage, RecipeimageUploader

	include Tire::Model::Search
    include Tire::Model::Callbacks

    #SCOPES

    scope :by_newest, order("created_at ASC")
    scope :by_name, order("name DESC")
    scope :random, order("RANDOM()")
    #default_scope -> { order('name') }

    def self.search(params)
    	tire.search(load: true) do  
    		query { string params[:query]} if params[:query].present?
    	end
    end

	#def to_param
	#	"#{id}-#{name}".parameterize
	#end


	def average_rating
		ratings.sum(:ranking) / ratings.size
	end

	def commentfeed
		Comment.where("recipe_id = ?", id)
	end

	def rankingrecipe(recipe)
		Ranking.where("recipe_id = ? AND user_id = ?", recipe.id, current_user.id)
	end

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