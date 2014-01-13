class CommentsController < ApplicationController
  before_action :signed_in_user
  before_action :correct_user, only: :destroy

  def create
  	@comment = current_user.comments.build(comment_params)
    if @comment.nil? || @comment.content.length > 500
      redirect_to @comment.recipe :flash => { error: "There was an error: Failed to save"}
    end
  	if @comment.save
  		
  		respond_to do |format|
        format.html { redirect_to @comment.recipe, :flash => {notice: "Comment was fully created." }}
        format.js
      end
  	else
  		@feed_items = []
  		redirect_to @comment.recipe, :flash => {error: "There was an error: Failed to save"}
  	end
  end

  def index
  end

  def destroy
  	@comment.destroy
  	respond_to do |format|
        format.html { redirect_to @comment.recipe, :flash =>{info: "Comment removed"}}
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