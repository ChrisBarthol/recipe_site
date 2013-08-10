class RecipesController < ApplicationController
	before_action :signed_in_user, only: [:create, :destroy]
  


  def new
  	@recipe = Recipe.new
  	3.times { @recipe.ingredients.build }
  end

  def destroy
    recipe = Recipe.find(params[:id])

      recipe.destroy
      flash[:success] = "Recipe destroyed"

      redirect_to recipes_path
  end

  def show
  	@recipe = Recipe.find(params[:id])
  	@ingredients = @recipe.ingredients
  end

  def index
    @recipes = Recipe.paginate(page: params[:page])
  end

  def create
  	@recipe = Recipe.new(recipe_params)
  	if @recipe.ingredients.blank?
  		flash[:notice] = "There are errors on this page"
  		redirect_to newrecipe_path
  	else
  		if @recipe.save
  			flash.now[:success] = "New recipe created"
  			redirect_to @recipe
  		else
  			redirect_to newrecipe_path
  		end
  	end
  end

  private

  	def recipe_params
  		params.require(:recipe).permit(:name, :description, ingredients_attributes: [:name, :quantity, :recipe_id])

  	end

end
