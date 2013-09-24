class CommentsController < ApplicationController
  before_action :signed_in_user
  before_action :correct_user, only: :destroy

  def create
  	@comment = current_user.comments.build(comment_params)

  	if @comment.save
  		flash[:success] = "Comment created!"
  		respond_to do |format|
        format.html { redirect_to @comment.recipe,:flash => { :notice => "Comment Created!" }}
        format.js #requires remote true added
      end
  	else
  		@feed_items = []
  		flash[:notice] = "Error: Failed to save"
  		redirect_to @comment.recipe,:flash => { :error => "Error: Failed to save" }
  	end
  end

  def index
  end

  def destroy
  	@comment.destroy
    flash[:notice] = "Comment deleted"
  	respond_to do |format|
        format.html { redirect_to @comment.recipe,:flash => { :notice => "Comment removed" }}
        format.js #requires remote true added
      end
  end

  private

  	def comment_params
  		params.require(:comment).permit(:content, :recipe_id)
  	end

  	def correct_user
  		@comment = current_user.comments.find_by(id: params[:id])
  		redirect_to root_url if @comment.nil?
  	end
end