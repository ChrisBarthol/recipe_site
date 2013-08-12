class RecipesController < ApplicationController
	before_action :signed_in_user, only: [:create, :destroy, :new]
  


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
  	@recipe = current_user.recipes.build(recipe_params)
  	if @recipe.ingredients.blank?
  		flash[:notice] = "There are errors on this page"
      3.times { @recipe.ingredients.build } if @recipe.ingredients.blank?
  		render 'new'
  	else
  		if @recipe.save
  			flash.now[:success] = "New recipe created"
  			redirect_to @recipe
  		else
        flash[:notice] = "Error: Failed to save"
  			redirect_to newrecipe_path
  		end
  	end
  end

  private

  	def recipe_params
  		params.require(:recipe).permit(:name, :description, ingredients_attributes: [:name, :quantity, :recipe_id])

  	end

end
