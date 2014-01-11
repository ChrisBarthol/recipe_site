class PantryItemsController < ApplicationController
	before_action :signed_in_user

	def new

	end


	def create
		@recipe = Recipe.find(params[:recipe_id])
		@recipe.ingredients.each do |ingredient|
			@ingredient = ingredient.id
			current_user.save_ingredient!(ingredient)	
		end

		redirect_to recipe_path(@recipe)
	end

	def destroy
	end
end