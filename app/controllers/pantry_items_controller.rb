class PantryItemsController < ApplicationController
	before_action :signed_in_user

	def new
		@ingredient = Ingredient.find(params[:ingredient_id])
		@user = User.find(params[:id])
		@pantry_item = Array.new(3) { @user.pantry_items.build }
	end


	def create
		@recipe = Recipe.find(params[:recipe_id])
		@recipe.ingredients.each do |ingredient|
			@ingredient = ingredient.id
			current_user.save_ingredient!(ingredient)	
		end

		#@ingredient = Ingredient.find(params[:ingredient_id])
		#@recipe = Recipe.find_by_id(@ingredient.recipe_id)
		#@pantry_item = current_user.pantry_items.build(ingredient_id: @ingredient.id)
		#current_user.save_ingredient!(@ingredient)
		redirect_to recipe_path(@recipe)
	end

	def destroy
	end
end