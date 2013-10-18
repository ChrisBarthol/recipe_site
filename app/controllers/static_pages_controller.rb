class StaticPagesController < ApplicationController
  def home
    if signed_in?
      @comment = current_user.comments.build
      @feed_items = current_user.feed.paginate(page:params[:page])
      @newest = Recipe.order('created_at DESC').limit(5)
    end
  end

  def help
  end

  def about
  end
  
  def contact
  end

  def tour
  end
end
