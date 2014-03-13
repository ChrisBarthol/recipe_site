class UsersController < ApplicationController
  before_action :signed_in_user, only: [:index, :edit, :update, :destroy, :following, :followers, :saved_recipes, :show_recipes, :pantry]
  before_action :correct_user, only: [:edit, :update]
  before_action :admin_user,  only: :destroy

  def destroy
    user = User.find(params[:id])
      unless current_user?(user)
      user.destroy
      end
      redirect_to users_path, :flash => {warning: "User destroyed" }
  end

  def show
  	@user = User.find(params[:id])
    @comments = @user.comments.paginate(page: params[:page])
  end

  def index
    @users = User.paginate(page: params[:page])
    @newest = User.order('created_at DESC').limit(5)
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
      sign_in @user
      UserMailer.signup_confirmation(@user).deliver
      flash.now[:notice] = "Welcome to Use Your Foodle!" 
  		redirect_to help_url, :flash =>{notice: "Welcome to Use Your Foodle!"}
  	else
  		render 'new'
  	end
  end

  def edit
  end

  def update
    if @user.update_attributes(user_params)
      sign_in @user
      redirect_to @user, :flash => {info: "Profile updated." }
    else
      render 'edit'
    end
  end

  def newuser
    @title = "Welcome to Use Your Foodle!"
    @user = User.find(params[:id])
  end

  def saved_recipes
    @title= "Saved Recipes"
    @user= User.find(params[:id])
    @recipe = @user.saved_recipes.paginate(page: params[:page])
    render 'show_saved'
  end

  def show_recipes
    @title = "Submitted Recipes"
    @user= User.find(params[:id])
    @recipe = @user.recipes.paginate(page: params[:page])
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

  def pantry
    @title = "Pantry Items"
    @user = User.find(params[:id])
    @pitems = Ingredient.group('name')
;
    @stored_ingred = Pantry.where(user_id: current_user.id).order(created_at: :desc)

    #@pantry_items = Ingredient.all(:joins => {:user => :pantry_items => :ingredients}, )
    @pantry_items = Ingredient.joins(:pantry_items).where(pantry_items: {user_id: current_user.id}, pantry_items: {:created_at => Time.now-21.days..Time.now}).order(created_at: :asc)
    #@pantry_items = Ingredient.all(:joins => {:pantry_items => :user}, :conditions => { :pantry_items => { :user_id => current_user.id}},:order =>"pantry_items.created_at asc")
    #@pitems = @pantry_items.all(:joins => {:pantry_items => :ingredient}, :conditions => { :pantry_item => { :ingredient_id => ingredient.id}}, :group => "ingredient.name")
    #@new_p_items = PantryItem.where(maker_id = @user.id).first.id
    #@pi = @user.pantry_items.created_at
    @recipe = @user.made_recipes
    @pp = false
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
