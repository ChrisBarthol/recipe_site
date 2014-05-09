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
		redirect_to shopping_list_user_path(current_user)
	end

	def create
		@shopping = ShoppingList.new(shopping_params)
		@shopping.user_id = current_user.id
		if @shopping.save
			redirect_to shopping_list_user_path(current_user)
		end
	end

	def show
	end

	def update
		@item = ShoppingList.find(params[:id])
		@item.user_id = current_user.id

		if @item.update_attributes(shop_params)
			respond_to do |format|
				format.html
				format.js
			end
		else
			redirect_to shopping_list_user_path(current_user)
		end

	else

	end

	def edit
		@item = ShoppingList.find(params[:id])
		respond_to do |format|
			format.html
			format.js
		end
	end

	def destroy
		@item = ShoppingList.find(params[:id])
		@item.destroy
		respond_to do |format|
			format.html
			format.js
		end
	end


	private
		def shopping_params
			params.permit(:name, :quantity, :unit, :id, :style, :created_at, :updated_at, :expiration, :user_id, :recipe_id)
		end

		def shop_params
			params.require(:shopping_list).permit(:name, :quantity, :unit, :id, :style, :created_at, :updated_at, :user_id)
		end
end