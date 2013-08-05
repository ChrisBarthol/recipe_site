class RecipesController < ApplicationController


  def new
  	@recipe = Recipe.new
  end

  def show
  	@recipe = Recipe.find(params[:id])
  end

  def create
  	@recipe = Recipe.new(recipe_params)
  	if @recipe.save
  		flash.now[:success] = "New recipe created"
  		redirect_to @recipe
  	else
  		render 'new'
  	end
  end

  private

  	def recipe_params
  		params.require(:recipe).permit(:name, :description)
  	end

end
