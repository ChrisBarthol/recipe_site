class PantryItemsController < ApplicationController
	before_action :signed_in_user

	def new
		@pantry_item =Pantry_Item.new
	end


	def create
		@recipe = Recipe.find(params[:recipe_id])
		current_user.makerecipes.create!(made_id: @recipe.id)
		@recipe.ingredients.each do |ingredient|
			@ingredient = ingredient.id
			@alreadysaved = current_user.ingredients.find_by_id(@ingredient)
			if @alreadysaved.nil?
				current_user.save_ingredient!(ingredient)
			else
				#updated created at and recipe_id render update?
			end
		end

		respond_to do |format|
      		format.html { redirect_to recipe_path(@recipe) }
      		format.js
    	end
	end

	def destroy
	end

	def update
	end
end