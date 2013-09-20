class RecipesController < ApplicationController
	before_action :signed_in_user, only: [:create, :destroy, :new]
  


  def new
  	@recipe = Recipe.new
  	3.times { @recipe.ingredients.build }
  end

  def fork
    @existing_recipe = Recipe.find(params[:id])
    @recipe= Recipe.new(@existing_recipe.attributes)
    if @recipe.fork_id.nil?
      @recipe.fork_id = 1
    else
      fork_id + 1
    end
    @recipe.name = Recipe.find(params[:id]).name + "-" + @recipe.fork_id.to_s
    @recipe.ingredients.each do |ingredient|
      ingredient.id = nil
    end
    render 'new'
  end

  def destroy
    recipe = Recipe.find(params[:id])

      recipe.destroy
      flash[:success] = "Recipe destroyed"

      redirect_to recipes_path
  end

  def edit
    @recipe = Recipe.find(params[:id])
  end

  def update
    @recipe = Recipe.find(params[:id])
    @ingredients = @recipe.ingredients
    if @recipe.update_attributes(recipe_params)
      flash[:success] = "Recipe Updated"
      redirect_to @recipe
    else
      render 'edit'
    end
  end

  def show
    
  	@recipe = Recipe.find(params[:id])
  	@ingredients = @recipe.ingredients
    @comment = current_user.comments.build if signed_in?
    @commentfeed = @recipe.commentfeed.paginate(page: params[:page])
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
  		params.require(:recipe).permit(:name, :id, :description, :direction, :fork_id, :recipeimage, :remote_recipeimage_url, ingredients_attributes: [:name, :id, :_destroy, :quantity, :created_at, :updated_at])
    end



end
