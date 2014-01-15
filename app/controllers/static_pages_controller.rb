class StaticPagesController < ApplicationController
  def home
    if signed_in?
      @comment = current_user.comments.build
      @feed_items = current_user.feed.paginate(page:params[:page])
      @newest = Recipe.order('created_at DESC').limit(5)
    end
    @recipecount = Recipe.count
  end

  def help
  end

  def about
  end
  
  def contact
  end

  def tour
    @newest = Recipe.order('created_at DESC').limit(5)
    @recipe = Recipe.find_by_id(10)
  end
end
