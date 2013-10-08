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
      @recipe.fork_id + 1
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
      redirect_to recipes_path, :flash => {warning: "Recipe destroyed" }
  end

  def edit
    @recipe = Recipe.find(params[:id])
  end

  def update
    @recipe = Recipe.find(params[:id])
    @ingredients = @recipe.ingredients
    if @recipe.update_attributes(recipe_params)
      redirect_to @recipe, :flash => {notice: "Recipe Updated" }
    else
      render 'edit'
    end
  end

  def show
    
  	@recipe = Recipe.find(params[:id])
  	@ingredients = @recipe.ingredients
    @comment = current_user.comments.build if signed_in?
    @commentfeed = @recipe.commentfeed.paginate(page: params[:page])
    @random_recipe = Recipe.order('random()').first

    @ratings = @recipe.ratings

    if @ratings.length > 0
       @newrating = @ratings.collect{|r| r.rankings[label]}.compact.map(&:to_f).sum / @ratings.length
    else
      @newrating = "Not Reviewed"
    end

    #@rating.reject{|rating| rating.rankings[label].nil?}.collect{|rating| rating.rankings[label].to_i}.sum.to_f/@ratings.length if @ratings.length > 0

    #@rating = @recipe.rating.average('ranking')

    #@ordered_hash = Rating.group('recipe_id').average('ranking')
    #@keys = @ordered_hash.keys
    #@ratings = Rating.where(:recipe_id=>@keys).uniq { |x| x.recipe_id}
    
  end

  def index
    @recipes = Recipe.paginate(page: params[:page])
  end

  def create
  	@recipe = current_user.recipes.build(recipe_params)
  	if @recipe.ingredients.blank?
      3.times { @recipe.ingredients.build } if @recipe.ingredients.blank?
  		redirect_to newrecipe_path, :flash => {error: "Error: Ingredients cannot be blank" }
  	else
  		if @recipe.save
  			redirect_to @recipe, :flash => {notice: "New recipe created!" }
  		else
  			redirect_to newrecipe_path, :flash => {error: "Error: Failed to save" }
  		end
  	end
  end

  private

  	def recipe_params
  		params.require(:recipe).permit(:name, :id, :description, :direction, :fork_id, :recipeimage, :serving, :preptime, :totaltime, :nutrition, :ratings, :remote_recipeimage_url, ratings_attributes: [:ranking, :id, :user_id, :recipe_id], ingredients_attributes: [:name, :id, :_destroy, :quantity, :unit, :style, :created_at, :updated_at])
    end



end
