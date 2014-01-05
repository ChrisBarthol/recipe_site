require 'spec_helper'

describe User do

  before { @user = User.new(name: "Example User", email: "user@example.com",
  							password: "foobar", password_confirmation: "foobar") }

  subject { @user }

  it { should respond_to(:name) }
  it { should respond_to(:email) }
  it { should respond_to(:password_digest) }
  it { should respond_to(:password) }
  it { should respond_to(:password_confirmation) }
  it { should respond_to(:authenticate) }
  it { should respond_to(:remember_token) }
  it { should respond_to(:admin) }
  it { should respond_to(:relationships) }
  it { should respond_to(:followed_users) }
  it { should respond_to(:following?) }
  it { should respond_to(:follow!) }
  it { should respond_to(:unfollow!) }
  it { should respond_to(:reverse_relationships) }
  it { should respond_to(:followers) }
  it { should respond_to(:reciperelationships) }
  it { should respond_to(:saved_recipes) }
  it { should respond_to(:recipesaved?) }
  it { should respond_to(:recipesave!) }
  it { should respond_to(:recipedelete!) }
  it { should respond_to(:reverse_reciperelationships) }
  it { should respond_to(:recipesavers) }
  it { should respond_to(:comments) }
  it { should respond_to(:feed) }
  it { should respond_to(:pantry_items) }
  it { should respond_to(:save_ingredient!) }
  it { should respond_to(:ingredient_saved?) }
  it { should respond_to(:remove_ingredient!) }

  it { should be_valid }
  it { should_not be_admin }

  describe "pantry items" do

    describe "saving ingredient" do
      let(:user) { FactoryGirl.create(:user) }
      let(:ingredient) { FactoryGirl.create(:ingredient) }
      before do
        @user.save
        @user.save_ingredient!(ingredient)
      end

      it { should be_ingredient_saved(ingredient) }
      its(:ingredients) { should include(ingredient) }

      describe "and removing an ingredient" do
        before { @user.remove_ingredient!(ingredient) }

        it { should_not be_ingredient_saved(ingredient) }
        its(:pantry_items) { should_not include(ingredient) }
      end
    end
  end





  describe "comment associations" do

    before { @user.save }
    let!(:older_comment) do
      FactoryGirl.create(:comment, user: @user, created_at: 1.day.ago)
    end
    let!(:newer_comment) do
      FactoryGirl.create(:comment, user: @user, created_at: 1.hour.ago)
    end

    describe "status" do
      let(:unfollowed_comment) do
        FactoryGirl.create(:comment, user: FactoryGirl.create(:user))
      end
      let(:followed_user) { FactoryGirl.create(:user) }

      before do
        @user.follow!(followed_user)
        3.times { followed_user.comments.create!(content: "Lorem ipsum", recipe_id: 1) }
      end

      its(:feed) { should include(newer_comment) }
      its(:feed) { should include(older_comment) }
      its(:feed) { should_not include(unfollowed_comment) }
      its(:feed) do
        followed_user.comments.each do |comment|
          should include(comment)
        end
      end
    end

    it "should have the right comments in the right order" do
      expect(@user.comments.to_a).to eq [newer_comment, older_comment]
    end

    it "should destroy associated comments" do
      comments = @user.comments.to_a
      @user.destroy
      expect(comments).not_to be_empty
      comments.each do |comment|
        expect(Comment.where(id: comment.id)).to be_empty
      end
    end
  end

  describe "recipesave" do
    let(:recipe) { FactoryGirl.create(:recipe) }
    before do
      @user.save
      @user.recipesave!(recipe)
    end

    it { should be_recipesaved(recipe) }
    its(:saved_recipes) { should include(recipe) }

    describe "saved recipe" do
      subject { recipe }
      its(:recipesavers) { should include(@user) }
    end

    describe "and deleting" do
      before { @user.recipedelete!(recipe)}

      it { should_not be_recipesaved(recipe) }
      its(:saved_recipes) { should_not include(recipe) }
    end
  end

  describe "following" do
    let(:other_user) { FactoryGirl.create(:user) }
    before do
      @user.save
      @user.follow!(other_user)
    end

    it { should be_following(other_user) }
    its(:followed_users) { should include(other_user) }

    describe "followed user" do
      subject { other_user }
      its(:followers) { should include(@user) }
    end

    describe "and unfollowing" do
      before { @user.unfollow!(other_user) }

      it { should_not be_following(other_user) }
      its(:followed_users) { should_not include(other_user) }
    end
  end

  describe "recipe associations" do

    before { @user.save }
    let!(:older_recipe) do
      FactoryGirl.create(:recipe, name: "Old", user: @user, created_at: 1.day.ago)
    end
    let!(:newer_recipe) do
      FactoryGirl.create(:recipe, name: "A", user: @user, created_at: 1.hour.ago)
    end

    it "should have the right recipes in the right order" do
      expect(@user.recipes.to_a).to eq [newer_recipe, older_recipe]
    end

    it "should NOT destroy associated recipes when user is deleted" do
      recipes = @user.recipes.to_a
      @user.destroy
      expect(recipes).not_to be_empty

      recipes.each do |recipe|
        expect(Recipe.where(id: recipe.id)).not_to be_empty
      end
      
    end
  end

  describe "with admin attribute set to true" do
    before do
      @user.save!
      @user.toggle!(:admin)
    end

    it { should be_admin }
  end

  describe "remember token" do
    before { @user.save }
    its(:remember_token) { should_not be_blank }
  end

  describe "when name is not present" do  
  	before { @user.name = " " }
  	it { should_not be_valid }
  end

  describe "when email is not present" do
  	before { @user.email = " " }
  	it { should_not be_valid }
  end

  describe "when name is too long" do
  	before { @user.name = "a" * 51 }
  	it { should_not be_valid }
  end

  describe "when name is too short" do
  	before { @user.name = "a" *2 }
  	it { should_not be_valid }
  end

  describe "email address with mixed case" do
  	let(:mixed_case_email) { "Foo@ExAMPle.CoM"}

  	it "should be saved as all lower-case" do
  		@user.email = mixed_case_email
  		@user.save
  		expect(@user.reload.email).to eq mixed_case_email.downcase
  	end
  end

  describe "with a password that's too short" do
  	before { @user.password = @user.password_confirmation = "a" * 5 }
  	it { should be_invalid }
  end

  describe "when password is not present" do
  	before do
  		@user = User.new(name: "Example User", email: "user@example.com",
  							password: " ", password_confirmation: " ")
  	end

  	it { should_not be_valid }
  end

  describe "when password doesn't match confirmation" do
  	before { @user.password_confirmation = "mismatch" }
  	it { should_not be_valid }
  end

  describe "when email address is already taken" do
  	before do
  		user_with_same_email = @user.dup
  		user_with_same_email.email = @user.email.upcase
  		user_with_same_email.save
  	end

  	it { should_not be_valid }
  end

  describe "when email format is invalid" do
    it "should be invalid" do
      addresses = %w[user@foo,com user_at_foo.org example.user@foo.
                     foo@bar_baz.com foo@bar+baz.com foo@bar..com]
      addresses.each do |invalid_address|
        @user.email = invalid_address
        expect(@user).not_to be_valid
      end
    end
  end

  describe "when email format is valid" do
    it "should be valid" do
      addresses = %w[user@foo.COM A_US-ER@f.b.org frst.lst@foo.jp a+b@baz.cn]
      addresses.each do |valid_address|
        @user.email = valid_address
        expect(@user).to be_valid
      end
    end
  end

  describe "return value of authenticate method" do
  	before { @user.save }
  	let(:found_user) { User.find_by(email: @user.email) }

  	describe "with valid password" do
    	it { should eq found_user.authenticate(@user.password) }
  	end

 	 describe "with invalid password" do
    	let(:user_for_invalid_password) { found_user.authenticate("invalid") }

    	it { should_not eq user_for_invalid_password }
    	specify { expect(user_for_invalid_password).to be_false }
  	end
  end
end











