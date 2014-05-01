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
		@exists= Pantry.where('name=? OR name=?', @ingredient.name.singularize, @ingredient.name.pluralize)
		@exists_first = @exists.first
		@exists_last = @exists.last

		if @exists.empty?
			if @ingredient.save
			 redirect_to pantry_user_path(current_user), :flash => {notice: "Ingredient Added!" }
			else
			 redirect_to pantry_user_path(current_user), :flash => {error: "Error: Failed to save" }
			end
		else
			if @ingredient.unit.empty?
				if @exists_first.unit.empty?	
					@quantity = @exists_first.quantity.to_r + @ingredient.quantity.to_r
					@exists_first.quantity = @quantity.to_f.to_s
					@exists_first.update_attributes(params[ingred_params])
					redirect_to pantry_user_path(current_user), :flash => {notice: "#{@ingredient.name} is unitless."}
				elsif @exists_last.unit.empty?
					@quantity = @exists_last.quantity.to_r + @ingredient.quantity.to_r
					@exists.last_quantity = @quantity.to_f.to_s
					@exists.update_attributes(params[ingred_params])
					redirect_to pantry_user_path(current_user)
				else
					@ingredient.save
					redirect_to pantry_user_path(current_user), :flash => {notice: "#{@ingredient.name} had no units.  Unitless #{@ingredient.name} added!"}
				end
			else
				if @exists_first.unit.empty?
					if @exists_last.unit.empty?
						@ingredient.save
						redirect_to pantry_user_path(current_user), :flash => {notice: "Previously saved #{@ingredient.name} had no units.  #{@ingredient.name} with units added!"}
					else
						@quantity = UnitsHelper.conversion(@exists_last.quantity.to_r, @ingredient.quantity.to_r, @exists_last.unit, @ingredient.unit)
						@exists_last.quantity = @quantity[0].to_s
						@exists_last.unit = @quantity[1]
						@exists_last.update_attributes(params[ingred_params])
						redirect_to pantry_user_path(current_user) , :flash =>{error: "Error: #{@quantity}"}
					end
				else

					@quantity = UnitsHelper.conversion(@exists_first.quantity.to_r, @ingredient.quantity.to_r, @exists_first.unit, @ingredient.unit)
					@exists_first.quantity = @quantity[0].to_s
					@exists_first.unit = @quantity[1]
					@exists_first.update_attributes(params[ingred_params])
					redirect_to pantry_user_path(current_user) , :flash =>{error: "Error: #{@quantity}"}
				end

			end
		end
	end

	def edit
		@units = ['','tsp','tbsp','floz','cup','pint','quart','gallon','mL','L','dL','lb','oz','mg','g','kg','inch','foot','mm','cm','m']
;
		@ingredient = Pantry.find(params[:id])
		respond_to do |format|
        	format.html
        	format.js
     	end
	end

	def update
		@ingredient = Pantry.find(params[:id])

		@ingredient.user_id= current_user.id

		ingredient = @ingredient
		if @ingredient.update_attributes(ingredient_params)
			respond_to do |format|
        		format.html
        		format.js
     		end
		else
			redirect_to pantry_user_path(current_user), :flash => {info: "Failed"}
		end
	end


	def destroy
	  	@ingredient = Pantry.find(params[:id])

      	@ingredient.destroy
       	respond_to do |format|
         	format.html
       		format.js
     	end
      	#redirect_to pantry_user_path(current_user), :flash => {warning: "Ingredient destroyed" }
	end

	private

		def ingred_params
			params.permit(:name, :quantity, :unit, :id, :style, :created_at, :updated_at, :expiration, :user_id, :recipe_id)
		end

		def ingredient_params
			params.require(:pantry).permit(:name, :quantity, :unit, :expiration, :created_at, :updated_at, :user_id)
		end
	
end