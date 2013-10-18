class RecipesController < ApplicationController
	before_action :signed_in_user, only: [:create, :destroy, :new]
  


  def new
  	@recipe = Recipe.new
  	3.times { @recipe.ingredients.build }
  end

  def fork
    @existing_recipe = Recipe.find(params[:id])
    @newfork = @existing_recipe.id
    @name=@existing_recipe.name
    @username = @existing_recipe.user.name.downcase
    array = [Regexp.union(@username), Regexp.union('forked by')]
    @name2 = @name.gsub(Regexp.union(array), '').split.join(' ')
    @recipe= Recipe.new(@existing_recipe.attributes)
    @recipe.fork_id = @newfork
    @recipe.name = @name2 + ' forked by ' + current_user.name
    
    @recipe.ingredients.each do |ingredient|
      ingredient.id = nil
    end

      if @recipe.name.downcase == @existing_recipe.name.downcase
          flash[:warning] = "You've forked this recipe please update your fork"
          render 'new'
      else
          render 'new'
      end
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

    @recipetwo = Recipe.find_by_id(@recipe.id+1)
    if @recipetwo.nil?
      @recipetwo = Recipe.order('random()').first
    end
    @recipethree = Recipe.find_by_id(@recipe.id-1)
    if @recipethree.nil?
      @recipethree = Recipe.order('random()').first
    end


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
    @newest = Recipe.order('created_at DESC').limit(5)
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
