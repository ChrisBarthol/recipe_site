module RecipesHelper
	def current_recipe=(recipe)
  		recipe == current_recipe
  	end

  	def random_recipe_link
  		random_recipe = Recipe.find_by_sql("SELECT 1 FROM recipes ORDER BY RANDOM() LIMIT 1") # for MySql RAND()	
	end
end
