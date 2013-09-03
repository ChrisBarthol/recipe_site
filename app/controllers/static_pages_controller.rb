class StaticPagesController < ApplicationController
  def home
    if signed_in?
      @comment = current_user.comments.build
      @feed_items = current_user.feed.paginate(page:params[:page])
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
