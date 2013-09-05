class UsersController < ApplicationController
  before_action :signed_in_user, only: [:index, :edit, :update, :destroy, :following, :followers, :saved_recipes]
  before_action :correct_user, only: [:edit, :update]
  before_action :admin_user,  only: :destroy

  def destroy
    user = User.find(params[:id])
      unless current_user?(user)
      user.destroy
      flash[:success] = "User destroyed"
      end
      redirect_to users_path
  end

  def saved_recipes
    @title= "Saved Recipes"
    @user= User.find(params[:id])
    @recipe = @user.saved_recipes.paginate(page: params[:page])
    render 'show_saved'
  end

  def following
    @title="Following"
    @user = User.find(params[:id])
    @users = @user.followed_users.paginate(page: params[:page])
    render 'show_follow'
  end

  def followers
    @title = "Followers"
    @user = User.find(params[:id])
    @users = @user.followers.paginate(page: params[:page])
    render 'show_follow'
  end

  def show
  	@user = User.find(params[:id])
    @comments = @user.comments.paginate(page: params[:page])
  end

  def index
    @users = User.paginate(page: params[:page])
  end
  
  def new
    if signed_in?
      redirect_to root_url
    else
      @user = User.new
    end
  end

  def create
  	@user = User.new(user_params)
  	if @user.save
      UserMailer.signup_confirmation(@user).deliver
      sign_in @user
  		flash[:success] = "Welcome to Pantry Raid!"
  		redirect_to @user
  	else
  		render 'new'
  	end
  end

  def edit
  end

  def update
    if @user.update_attributes(user_params)
      flash[:success] = "Profile Updated"
      sign_in @user
      redirect_to @user
    else
      render 'edit'
    end
  end

  private

  	def user_params
  		params.require(:user).permit(:name, :email, :password, :password_confirmation)
  	end

    # Before filters



    def correct_user
      @user = User.find(params[:id])
      redirect_to(root_url) unless current_user?(@user)
    end

    def admin_user
      redirect_to(root_url) unless current_user.admin?
    end

end
