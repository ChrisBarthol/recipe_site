class PantryItemController < ApplicationController
	before_action :sign_in_user

	def create
		#@recipe =

		@pantry_item = User.find(params[:ingredient][:ingredient_id])
		current_user.save_ingredient!(@pantry_item)
		redirect_to @recipe
	end

	def destroy
	end
end