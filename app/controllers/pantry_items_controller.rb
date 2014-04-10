class PantryItemsController < ApplicationController
	before_action :signed_in_user

	def new
		@pantry_item =Pantry_Item.new
	end


	def create
		@recipe = Recipe.find(params[:recipe_id])
		current_user.makerecipes.create!(made_id: @recipe.id) #add relationship to make recipe table
		@recipe.ingredients.each do |ingredient|
			@pantry = Pantry.where(name: ingredient.name).first
			if @pantry.nil?
				@ingredient = Pantry.new
				@ingredient.user_id = current_user.id
				@ingredient.name = ingredient.name
				@ingredient.unit = ingredient.unit
				@ingredient.quantity = ingredient.quantity
				@item = @ingredient.quantity.to_r.to_f
				@item *= -1
				@ingredient.quantity = @item.to_s
				@ingredient.save!
			else
				@item1 = @pantry.quantity.to_r.to_f
				@item2 = ingredient.quantity.to_r.to_f
				@subtract = @item1-@item2
				@pantry.quantity = @subtract.to_s
				@pantry.update_attributes(ingred_params)
			end
			@alreadysaved = current_user.ingredients.find_by_id(ingredient.id) #check it ingredient is already saved this needs to be removed once queries get sorted
			if @alreadysaved.nil?
				current_user.save_ingredient!(ingredient)
			else
				#updated created_at and recipe_id, render update?
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

	private

	def ingred_params
		params.permit(:name, :quantity, :unit, :id, :style, :created_at, :updated_at, :expiration, :user_id)
	end
end