class PantryItemsController < ApplicationController
	before_action :signed_in_user

	def new
		@pantry_item =Pantry_Item.new
	end


	def create
		@recipe = Recipe.find(params[:recipe_id])
		current_user.makerecipes.create!(made_id: @recipe.id) #add relationship to make recipe table
		@recipe.ingredients.each do |ingredient|

			@ingredient = Pantry.new
			@ingredient.name = ingredient.name.downcase
			@ingredient.quantity = ingredient.quantity.to_r*-1
			@ingredient.unit = ingredient.unit

			@ingredient.user_id = current_user.id

			@exists= Pantry.where(name: @ingredient.name.downcase)
			@exists_first = @exists.first
			@exists_last = @exists.last

			if @exists.empty?
				if @ingredient.save
				 
				else
				 
				end
			else
				if @ingredient.unit.empty?
					if @exists_first.unit.empty?	
						@quantity = @exists_first.quantity.to_r + @ingredient.quantity.to_r
						@exists_first.quantity = @quantity.to_f.to_s
						@exists_first.update_attributes(params[ingred_params])
						
					elsif @exists_last.unit.empty?
						@quantity = @exists_last.quantity.to_r + @ingredient.quantity.to_r
						@exists.last_quantity = @quantity.to_f.to_s
						@exists.update_attributes(params[ingred_params])
						
					else
						@ingredient.save
						
					end
				else
					if @exists_first.unit.empty?
						if @exists_last.unit.empty?
							@ingredient.save
					
						else
							@quantity = UnitsHelper.conversion(@exists_last.quantity.to_r, @ingredient.quantity.to_r, @exists_last.unit, @ingredient.unit)
							@exists_last.quantity = @quantity[0].to_s
							@exists_last.unit = @quantity[1]
							@exists_last.update_attributes(params[ingred_params])
							
						end
					else

						@quantity = UnitsHelper.conversion(@exists_first.quantity.to_r, @ingredient.quantity.to_r, @exists_first.unit, @ingredient.unit)
						@exists_first.quantity = @quantity[0].to_s
						@exists_first.unit = @quantity[1]
						@exists_first.update_attributes(params[ingred_params])

					end

				end
			end

			# if @pantry.nil?
			# 	@ingredient = Pantry.new
			# 	@ingredient.user_id = current_user.id
			# 	@ingredient.name = ingredient.name
			# 	@ingredient.unit = ingredient.unit
			# 	@ingredient.quantity = ingredient.quantity
			# 	@item = @ingredient.quantity.to_r.to_f
			# 	@item *= -1
			# 	@ingredient.quantity = @item.to_s
			# 	@ingredient.save!
			# else
			# 	@item1 = @pantry.quantity.to_r.to_f
			# 	@item2 = ingredient.quantity.to_r.to_f
			# 	@subtract = @item1-@item2
			# 	@pantry.quantity = @subtract.to_s
			# 	@pantry.update_attributes(ingred_params)
			# end
			# @alreadysaved = current_user.ingredients.find_by_id(ingredient.id) #check it ingredient is already saved this needs to be removed once queries get sorted
			# if @alreadysaved.nil?
			# 	current_user.save_ingredient!(ingredient)
			# else
			# 	#updated created_at and recipe_id, render update?
			# end
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