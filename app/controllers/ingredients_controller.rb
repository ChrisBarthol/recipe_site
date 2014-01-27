class IngredientsController < ApplicationController
	before_action :signed_in_user

	def new
		@ingredient = Ingredient.new
	end

	def create
		@ingredient = Ingredient.new(ingred_params)
		if @ingredient.save
		 redirect_to pantry_user_path(current_user), :flash => {notice: "Ingredient Added!" }
		else
		 redirect_to pantry_user_path(current_user), :flash => {error: "Error: Failed to save" }
		end
	end

	def destroy
	end

	private

		def ingred_params
			params.require(:ingredient).permit(:name, :quantity, :unit, :id, :style, :create_at, :updated_at)
		end
	
end