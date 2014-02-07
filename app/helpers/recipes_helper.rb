module RecipesHelper
	def current_recipe=(recipe)
  		recipe == current_recipe
  	end
    #NOT USED
  	def random_recipe	
  		randomrecipe = Recipe.find_by_sql("SELECT id FROM recipes ORDER BY RANDOM() LIMIT 1")
  		rand2_id = randomrecipe[1]
  		rand_id = rand(Recipe.count)
  		@recipe.id = rand_id  

  		#This changes the recipe.id of the page therefore edit and fork don't work properly
  	end
end
