class PantryItemsController < ApplicationController
	before_action :signed_in_user

	def new

	end


	def create
		@recipe = Recipe.find(params[:recipe_id])
		@recipe.ingredients.each do |ingredient|
			@ingredient = ingredient.id
			@alreadysaved = current_user.ingredients.find_by_id(@ingredient)
			if @alreadysaved.nil?
				current_user.save_ingredient!(ingredient)
			else
				#updated created at and recipe_id render update?
			end
		end

		redirect_to recipe_path(@recipe)
	end

	def destroy
	end
end