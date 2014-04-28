class PantriesController < ApplicationController
	before_action :signed_in_user
	include UnitsHelper

	def new
		@ingredient = Pantry.new
	end

	def create
		@ingredient = Pantry.new(ingred_params)
		@id = @ingredient.id
		@ingredient.user_id = current_user.id

		@exists = Pantry.where(name: @ingredient.name).first

		if @exists.nil?
			if @ingredient.save
			 redirect_to pantry_user_path(current_user), :flash => {notice: "Ingredient Added!" }
			else
			 redirect_to pantry_user_path(current_user), :flash => {error: "Error: Failed to save" }
			end
		else
			@quantity = UnitsHelper.conversion(@exists.quantity.to_r.to_f, @ingredient.quantity.to_r.to_f, @exists.unit, @ingredient.unit)
			#quantity = @exists.conversion +@ingredient.conversion
			#@conversion = @exists.quantity.to_r.to_f + @ingredient.quantity.to_r.to_f
			@exists.quantity = @quantity.to_s
			@exists.update_attributes(params[ingred_params])
			redirect_to pantry_user_path(current_user) , :flash =>{error: "Error: #{@quantity}"}
		end
	end

	def edit
	end

	def update
		@ingredient = Pantry.find(params[:id])
		#update_attributes! throws no erroe but doesnt save to db, update_column does, reason unknown
		if @ingredient.update_column(:expiration, params[:pantry][:expiration])
			redirect_to pantry_user_path(current_user), :flash => {info: "Ingredient Updated"}
		else
			redirect_to @recipe, :flash => {info: "Failed"}
		end
	end


	def destroy
	  	ingredient = Pantry.find(params[:id])

      	ingredient.destroy
      	redirect_to pantry_user_path(current_user), :flash => {warning: "Ingredient destroyed" }
	end

	private

		def ingred_params
			params.permit(:name, :quantity, :unit, :id, :style, :created_at, :updated_at, :expiration, :user_id)
		end
	
end