class RatingsController < ApplicationController
  before_action :signed_in_user
  before_action :correct_user, only: :destroy

  def create
  	@rating = Rating.new(rating_params)
  	@oldrating = Rating.where("recipe_id = ?", @rating.recipe_id).sum('ranking') #old rating
  	@ratingcount = Rating.where("recipe_id = ?", @rating.recipe_id).count #number of ratings
  	@newrating = ((@oldrating*@ratingcount+@rating.ranking)/(@ratingcount+1)).round #average of recipe with new rating (xy+z)/(x+1)
  	@yourrating = @rating.ranking
    	if @rating.save
      	respond_to do |format|
            format.html { redirect_to root_url, :flash => {notice: "Rating was added!" }}
            format.js
        end
      end
  end

  def destroy
  	respond_to do |format|
        format.html { redirect_to @recipe, :flash => {notice: "Rating was deleted!" }}
        format.js #requires remote true added
    end
  end

    private

  	def rating_params
  		params.require(:rating).permit(:ranking, :user_id, :recipe_id)
  	end

  	def correct_user
  		@rating = current_user.ratings.find_by(id: params[:id])
  		redirect_to root_url if @rating.nil?
  	end
end