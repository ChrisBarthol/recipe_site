class ReciperelationshipsController < ApplicationController
  before_action :signed_in_user

  def create
    @recipe = Recipe.find(params[:reciperelationship][:recipesaved_id])
    current_user.recipesave!(@recipe)
     respond_to do |format|
      format.html { redirect_to @recipe }
      format.js
    end
  end

  def destroy
    @recipe = Reciperelationship.find(params[:id]).recipesaved
    current_user.recipedelete!(@recipe)
     respond_to do |format|
      format.html { redirect_to @recipe }
      format.js
    end
  end
end