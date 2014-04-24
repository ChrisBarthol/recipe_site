class StaticPagesController < ApplicationController

  layout 'nosidebar', :only =>[:home]

  def home
    if signed_in?
      redirect_to '/dashboard'
    end
    @recipecount = Recipe.count
  end

  def help
  end

  def about
  end
  
  def contact
  end

  def dashboard
    @comment = current_user.comments.build
    @feed_items = current_user.feed.paginate(page:params[:page])
    @newest = Recipe.order('created_at DESC').limit(5)
  end

  def tour
    @newest = Recipe.order('created_at DESC').limit(5)
    @recipe = Recipe.find_by_id(10)
  end
end
