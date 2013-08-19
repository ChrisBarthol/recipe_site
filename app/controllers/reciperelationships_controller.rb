class ReciperelationshipsController < ApplicationController
  before_action :signed_in_user

  def create
    @recipe = Recipe.find(params[:reciperelationship][:recipesaved_id])
    current_user.recipesave!(@recipe)
    redirect_to @recipe
  end

  def destroy
    @recipe = Reciperelationship.find(params[:id]).recipesaved
    current_user.recipedelete!(@recipe)
    redirect_to @recipe
  end
end