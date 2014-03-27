class RecipesController < ApplicationController
	before_action :signed_in_user, only: [:create, :destroy, :new]
  


  def new
  	@recipe = Recipe.new
  	3.times { @recipe.ingredients.build }
  end

  def search
    @recipe = Recipe.search(params)
  end

  def forktree
    @recipe = Recipe.find(params[:id])
    @fork = Recipe.where(fork_id: @recipe.id)
  end

  def fork
    @existing_recipe = Recipe.find(params[:id])  #get recipe
    @newfork = @existing_recipe.id  #isolate recipe.id
    @name=@existing_recipe.name  #isolate recipe.name

    #@username = @existing_recipe.user.name.downcase  #isolate username
    #array = [Regexp.union(@username), Regexp.union('forked by')]
    #@name2 = @name.gsub(Regexp.union(array), '').split.join(' ')

    @recipe= Recipe.new(@existing_recipe.attributes)
    @recipe.fork_id = @existing_recipe.id
    @recipe.name = @name.titleize + ' forked by ' + current_user.name.titleize
    
    @recipe.ingredients.each do |ingredient|  #reset ingredient.id for new ingredients
      ingredient.id = nil
    end

      if @recipe.name.downcase == @existing_recipe.name.downcase
          flash[:warning] = "You've forked this recipe please update your fork or change the name"
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

  def newingredient
    @newingredient = Ingredient.find_by_name(params[:name])
    t = Ingredient.where("name = ?", @newingredient.name).first
    #get recipes with same ingredient and have the first 3 available ---- Better Implementation? 
    @getthree = Recipe.joins(:ingredients).where('ingredients.name = ?', params[:name]).order('random()').first(3)
    @one1 = @getthree.first
    @getthree.shift
    @two2 = @getthree.first
    @getthree.shift
    @three3 = @getthree.first

    #get recipe.id for displaying and linking
    @one = Recipe.find_by_id(@one1.id) 
    @two = Recipe.find_by_id(@two2.id)
    @three = Recipe.find_by_id(@three3.id)

    respond_to do |format|
        format.js
        format.html { redirect_to root_url, :flash => {notice: "Comment was fully created." }}
         
     end
  end

  def show
  	@recipe = Recipe.find(params[:id])                                   #get recipe
  	@ingredients = @recipe.ingredients                                   #get ingredients
    @comment = current_user.comments.build if signed_in?                 #get comments
    @commentfeed = @recipe.commentfeed.paginate(page: params[:page])     #display comments
    @random_recipe = Recipe.order('random()').first                      #random recipe for the random link
    @ingredient = @recipe.ingredients.first                             


    @alreadysaved = current_user.ingredients.find_by_id(@ingredient) if signed_in?

    #Carousel Images
    @recipetwo = Recipe.find_by_id(@recipe.id+1)
    if @recipetwo.nil?
      @recipetwo = Recipe.order('random()').first
    end
    @recipethree = Recipe.find_by_id(@recipe.id-1)
    if @recipethree.nil?
      @recipethree = Recipe.order('random()').first
    end

    #Recipe Rankings
    if signed_in?
    @haverating = Rating.where('recipe_id = ?', @recipe.id).first
    end

    t = Ingredient.where("name = ?", :data).first
    #submit name of ingredient from jquery when users clicks
    #@submitedname = 

    #@oneingredient = Ingredient.where("name = ?", @submitedname)


    @newrating = Rating.where("recipe_id = ?", @recipe.id).average('ranking')
    if @newrating == nil
      @newrating1 = "Not Reviewed"
    else
      @newrating1 = @newrating.round
    end
    
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

  def expand
    @recipe = Recipe.find(params[:id])


    respond_to do |format|
      format.html
      format.js
    end
  end

  def minimize
    @recipe = Recipe.find(params[:id])
    respond_to do |format|
      format.html
      format.js
    end
  end

  private

  	def recipe_params
  		params.require(:recipe).permit(:name, :id, :description, :direction, :fork_id, :recipeimage, :serving, :preptime, :totaltime, :nutrition, :ratings, :remote_recipeimage_url, ratings_attributes: [:ranking, :id, :user_id, :recipe_id], ingredients_attributes: [:name, :id, :_destroy, :quantity, :unit, :style, :created_at, :updated_at])
    end



end
