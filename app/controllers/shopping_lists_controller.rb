class ShoppingListsController < ApplicationController


	def new
		data=params[:pass]
		data.each do |id|
			ingredient = Ingredient.find_by_id(id)
			item = ShoppingList.new
			item.name = ingredient.name
			item.quantity = ingredient.quantity
			item.unit = ingredient.unit
			item.style = ingredient.style
			item.user_id = current_user.id
			item.save
		end
		redirect_to pantry_user_path(current_user)
	end

	def create
		@shopping = ShoppingList.new(shopping_params)
		@rep = Recipe.find(params[:id])
		#@rep.ingredients.each do |ingredient|

	end

	def show
	end

	def update
	end

	def edit
	end

	def destroy
	end


	private
		def shopping_params
			params.permit(:name, :quantity, :unit, :id, :style, :created_at, :updated_at, :expiration, :user_id, :recipe_id)
		end


end