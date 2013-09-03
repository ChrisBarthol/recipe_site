class CommentsController < ApplicationController
  before_action :signed_in_user

  def create
  	@comment = current_user.comments.build(comment_params)
  	if @comment.save
  		flash[:success] = "Comment created!"
  		redirect_back_or root_url  #Doesn't redirect back to recipe
  	else
  		@feed_items = []
  		flash[:notice] = "Error: Failed to save"
  		render 'static_pages/home'
  	end
  end

  def index
  end

  def destroy
  end

  private

  	def comment_params
  		params.require(:comment).permit(:content)
  	end
end