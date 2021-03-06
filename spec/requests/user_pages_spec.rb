require 'spec_helper'

RSpec.configure do |c|
  c.filter_run_excluding :broken => true
end

describe "User pages" do   

	subject { page }
  keypress = "var e = $.Event('keydown', { keyCode: 13 }); $('body').trigger(e);"

  describe "pantry" do
    let(:user) { FactoryGirl.create(:user) }
    let(:recipe) { FactoryGirl.create(:singlerecipe, :with_ingredients) }
    let(:ingredient) { recipe.ingredients.first }

    before do
      sign_in user
      visit recipe_path(recipe)
      click_button "I Made This!"
      visit pantry_user_path(user)
    end

    it { should have_content('Made Recipes') }
    it { should have_content('Recently Used Pantry Items') }
    it { should have_content('Add an Ingredient to Your Pantry') }
    it { should have_content(recipe.name) }
    it { should have_content('My Pantry') }
    it { page.should have_selector('li.negative') } 
    it { should have_content(ingredient.name) }

    describe "removing a pantry ingredient" do
      before { click_button "Remove" }

      it { page.should_not have_selector('li.red') }
      #Will still have ingredient in recently used pantry items
    end

    describe "adding an expiration", :js => true do
      before do
        fill_in "pantry_expiration", with: "2011-11-13"
        find('#pantry_expiration').native.send_keys(:return)
        #keypress = "var e = $.Event('keydown', { keyCode: 13 }); $('body').trigger(e);"
        #page.driver.execute_script(keypress)
      end

      it { should have_content("2011-11-13") }
    end


    describe "expanding a recipe", :js => true do
      before { click_link "Expand", match: :first }

      it { should have_content('Directions') }
      it { should have_content('Ingredients') }
      it { should have_link('Minimize') }
      it { should have_content(recipe.direction) }
      it { should have_content(ingredient.name) }

      describe "minimize" do
        before { click_link "Minimize" }

        it { should_not have_content('Directions') }
        it { should_not have_content('Ingredients') }
        it { should_not have_link('Minimize') }
        it { should have_link("Expand")}
        it { should_not have_content(recipe.direction) }
        it { should_not have_content(recipe.ingredients) }
      end
    end

    describe "add ingredient for positive value" do
      before do
        fill_in "Ingredient Name", with: ingredient.name
        fill_in "Quantity", with: "142"
        select 'lb', :from => "Units"
        click_button "Add Ingredient to Pantry"
      end

      it { page.should_not have_selector('li.red') } 
      it { should have_content("141") }
    end


    describe "add an ingredient to pantry" do
      before do
        fill_in "Ingredient Name", with: "cheese"
        fill_in "Quantity", with: "142"
        select 'lb', :from => "Units"
        click_button "Add Ingredient to Pantry"
      end

      it { should have_content("cheese") }
      it { should have_content('142') }
      it { should have_content('lbs') }

      describe "add the same ingredient to pantry" do
        before do
          fill_in "Ingredient Name", with: "cheese"
          fill_in "Quantity", with: "100"
          select 'lbs', :from => "Units"
          click_button "Add Ingredient to Pantry"
        end

        it { should have_content("cheese") }
        #these should change once the units are working
        it { should have_content('242') }
        it { should have_content('lbs') }
      end
    end

  end

  describe "saving recipes" do
    let(:user) { FactoryGirl.create(:user) }
    let(:recipe) { FactoryGirl.create(:recipe) }
    before { user.recipesave!(recipe) }

    describe "saved recipes" do
      before do
        sign_in user
        visit saved_recipes_user_path(user)
      end

      it { should have_title(full_title('Saved Recipes')) }
      it { should have_selector('h3', text: "Saved Recipes") }
      it { should have_link(recipe.name, href: recipe_path(recipe)) }
    end
  end

  describe "following/followers" do
    let(:user) { FactoryGirl.create(:user) }
    let(:other_user) { FactoryGirl.create(:user) }
    before { user.follow!(other_user) }

    describe "followed users" do
      before do
        sign_in user
        visit following_user_path(user)
      end

      it { should have_title(full_title('Following')) }
      it { should have_selector('h3', text: 'Following') }
      it { should have_link(other_user.name, href: user_path(other_user)) }
    end

    describe "followers" do
      before do
        sign_in other_user
        visit followers_user_path(other_user)
      end

      it { should have_title(full_title('Followers')) }
      it { should have_selector('h3', text: 'Followers') }
      it { should have_link(user.name, href: user_path(user)) }
    end
  end

  describe "index" do
    let(:user) { FactoryGirl.create(:user) }
    before(:each) do
      sign_in user
      visit users_path
    end

    it { should have_title('All users') }
    it { should have_content('All users') }

    describe "pagination" do

      before do
        54.times { FactoryGirl.create(:user) }
        visit users_path
      end

      it { should have_selector('div.pagination') }

      it "should list each user" do
        User.paginate(page: 1).each do |user|
          expect(page).to have_selector('li', text: user.name)
        end
      end
    end

    it "should list each user" do
      User.all.each do |user|
        expect(page).to have_selector('li', text: user.name)
      end
    end

    describe "delete links" do

      it { should_not have_link('delete') }

      describe "as an admin user" do
        let(:admin) { FactoryGirl.create(:admin) }
        before do
          sign_in admin
          visit users_path
        end

        it { should have_link('delete', href: user_path(User.first)) }
        it "should be able to delete another user" do
          expect do
            click_link('delete', match: :first)
          end.to change(User, :count).by(-1)
        end
        it { should_not have_link('delete', href: user_path(admin)) }

        describe "dont delete yourself" do
          it { expect { delete user_path(admin) }.to_not change(User, :count) }
        end
      end
    end
  end

	describe "signup page" do
		before { visit signup_path }

		it { should have_content('Sign up') }
		it { should have_title(full_title('Sign up')) }
	end

	describe "profile page" do
		let(:user) { FactoryGirl.create(:user) }
    let!(:c1)  { FactoryGirl.create(:comment, user: user, content: "Foo") }
    let!(:c2)  { FactoryGirl.create(:comment, user: user, content: "Bar") }
    let(:submituser) { FactoryGirl.create(:user) }
    let(:submitrecipe) { FactoryGirl.create(:recipe, user: user) }

		before { visit user_path(user) }

		it { should have_content(user.name) }
		it { should have_title(user.name) }
    it { should have_content('submitted recipes')}

    describe "show recipes" do
      before do
        sign_in user
        visit user_path(user)
      end

      it { should have_link("0 submitted recipes", href: show_recipes_user_path(user)) }
    end


    describe "comments" do
      it { should have_content(c1.content) }
      it { should have_content(c2.content) }
      it { should have_content(user.comments.count) }
    end

    describe "follower/following counts" do
      let(:other_user) { FactoryGirl.create(:user) }
      before do
        other_user.follow!(user)
        visit user_path(user)
      end

      it { should have_link("0 following", href: following_user_path(user)) }
      it { should have_link("1 followers", href: followers_user_path(user)) }
    end

    describe "saving a recipe counts" do
      let(:recipe) { FactoryGirl.create(:recipe) }
      before do
        user.recipesave!(recipe)
        visit user_path(user)
      end

      it { should have_link("1 saved recipe", href:saved_recipes_user_path(user)) }
    end

    describe "Follow/unfollow buttons" do
      let(:other_user) { FactoryGirl.create(:user) }
      before { sign_in user }

      describe "following a user" do
        before { visit user_path(other_user) }

        it "should increment the followed user count" do
          expect do
            click_button "Follow"
          end.to change(user.followed_users, :count).by(1)
        end

        it "should increment the other user's followers count" do
          expect do
            click_button "Follow"
          end.to change(other_user.followers, :count).by(1)
        end

        describe "toggling the button" do
          before { click_button "Follow" }
          it { should have_xpath("//input[@value='Unfollow']") }
        end
      end

      describe "unfollowing a user" do
        before do
          user.follow!(other_user)
          visit user_path(other_user)
        end

        it "should decrement the followed user count" do
          expect do
            click_button "Unfollow"
          end.to change(user.followed_users, :count).by(-1)
        end

        it "should decrement the other user's followers count" do
          expect do
            click_button "Unfollow"
          end.to change(other_user.followers, :count).by(-1)
        end

        describe "toggling the button" do
          before { click_button "Unfollow" }
          it { should have_xpath("//input[@value='Follow']") }
        end
      end
    end


	end

	describe "signup" do

    before { visit signup_path }

    let(:submit) { "Create my account" }
    

    describe "with invalid information" do
      it "should not create a user" do
        expect { click_button submit }.not_to change(User, :count)
      end

      describe "after submission" do
      	before { click_button submit }

      	it { should have_title('Sign up') }
      	it { should have_content('error') }
      end
    end

    describe "with valid information" do
      before do
        fill_in "Name",         with: "Example User"
        fill_in "Email",        with: "user@example.com"
        fill_in "Password",     with: "foobar"
        fill_in "Confirmation", with: "foobar"
      end

      let(:recipe1) { FactoryGirl.create(:recipe) }
      let(:recipe2) { FactoryGirl.create(:recipe) }

      it "should create a user" do
        expect { click_button submit }.to change(User, :count).by(1)
      end

      describe "after saving the user" do
      	before { click_button submit }
      	let(:user) { User.find_by(email: 'user@example.com') }

      	it { should have_title('Use Your Foodle') }
        it { should have_link('Sign out') }
      	it { should have_selector('div.alert.alert-success', text: 'Welcome') }
      end
    end
  end

  describe "edit" do
    let(:user) { FactoryGirl.create(:user) }
    before do
      sign_in user
      visit edit_user_path(user)
    end

    describe "forbidden attributes" do
      let(:params) do
        { user: { admin: true, password: user.password,
                  password_confirmation: user.password } }
      end
      before { patch user_path(user), params }
      specify { expect(user.reload).not_to be_admin }
    end


    describe "with valid information" do
      let(:new_name) { "New Name" }
      let(:new_email) { "new@example.com" }

      before do
        fill_in "Name",         with: new_name
        fill_in "Email",        with: new_email
        fill_in "Password",     with: user.password
        fill_in "Confirmation",   with: user.password   
        click_button "Save changes"
      end

      it { should have_title(new_name) }
      it { should have_selector('div.alert.alert-info') }
      it { should have_link('Sign out', href: signout_path) }
      specify { expect(user.reload.name).to eq new_name }
      specify { expect(user.reload.email).to eq new_email }
    end


    describe "page" do
      it { should have_content("Update your profile") }
      it { should have_title("Edit user") }
      it { should have_link('change', href: 'http://gravatar.com/emails') }
    end

    describe "with invalid information" do
      before { click_button "Save changes" }

      it { should have_content('error') }
    end
  end
end

















