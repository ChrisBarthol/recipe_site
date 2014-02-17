require 'spec_helper'

describe "RecipePages" do

  subject {page}

  describe "I made it button" do
    let(:user) { FactoryGirl.create(:user) }
    let(:recipe) { FactoryGirl.create(:recipe, :with_ingredients) }
    let(:ingredient) { FactoryGirl.create(:ingredient) }
    let(:recipe2) { FactoryGirl.create(:recipeingredient) }
    before do
      sign_in user
      visit recipe_path(recipe)
    end

    it "should increment the pantry_item count" do
      expect do
        click_button "I Made This!"
      end.to change(user.ingredients, :count).by(2)
    end

    it "should create a made_recipe" do
        expect { click_button "I Made This!" }.to change(user.made_recipes, :count).by(1)
    end

    describe "java click I made it", :js => true do
      before do
        click_button("I Made This!")
      end

      it { should have_button("You've made it!") }
    end
  end

  describe "JS submits" do
    let(:user) { FactoryGirl.create(:user) }
    let(:recipe) { FactoryGirl.create(:recipe) }

    before do
      sign_in user
      visit recipe_path(recipe)
    end
    
    describe "submit a rating", :js => true do

      before do
        fill_in "Rating", with: "2"
        click_button "Rate this Recipe"
      end
      
      it { should have_content('Your Rating') }
      it { should_not have_button('Rate this Recipe') }

      describe "resubmitting a rating" do

        before do
          visit recipe_path(recipe)
        end

        it { should_not have_button('Rate this Recipe') }
        it { should have_content('Your Rating') }
      end
    end

    describe "submit a comment", :js => true do

      before do 
        fill_in "comment_content", with: "Testing the comment"
        click_button "Post"
      end

      it { should have_content(user.name) }
      it { should have_content( "Testing the comment") }
    end


  end


  describe "edit" do
    let(:user) { FactoryGirl.create(:user, id: 10) }
    let(:recipe) {FactoryGirl.create(:recipe, user_id: 10)}
    let(:other_user) {FactoryGirl.create(:user, id: 12) }

    before do
      sign_in user
      visit recipe_path(recipe)
    end

    it {should have_link('Edit this Recipe', href: edit_recipe_path(recipe)) }

    describe "others should not edit recipe" do
      before do
        sign_in other_user
        visit recipe_path(recipe)
      end

      it {should_not have_link('Edit this Recipe', href: edit_recipe_path(recipe)) }
    end

    describe "Editing the recipe" do
      let(:new_name) {"New Salt Recipe"}
      let(:new_description) {"This is a new salt recipe"}
      let(:new_ingredient) {"Sea Salt"}
      let(:new_quantity) {"2"}
      let(:new_unit) {"cup"}
      let(:new_direction) {"Add all the things together"}
      before do
        visit recipe_path(recipe)
        click_link "Edit this Recipe"
        fill_in "Name",     with: new_name
        fill_in "Description", with: new_description
        fill_in "Direction", with: new_direction
        click_button "Create this recipe"
      end

      it { should have_title(new_name) }
      it { should have_selector('div.alert.alert-success') }
      it { should have_link('Edit this Recipe') }
      specify { expect(recipe.reload.name).to eq new_name.downcase }
      specify { expect(recipe.reload.description).to eq new_description }
      specify { expect(recipe.reload.direction).to eq new_direction }
    end
  end



  describe "index" do
    let(:recipe) { FactoryGirl.create(:recipe) }
    let(:user)	 { FactoryGirl.build(:user) }
    before(:each) do
      sign_in user
      visit recipes_path
    end

    it { should have_title('All recipes') }
    it { should have_content('All recipes') }

    describe "pagination" do
      let(:user1) {FactoryGirl.create(:user, name: "erfn", email: "ena@gmail.com") }
      let(:user2) {FactoryGirl.create(:user) }
      let(:recipe) {FactoryGirl.create(:recipe, id:100) }
      before do
        31.times { FactoryGirl.create(:recipe, user: user1) }
        31.times { FactoryGirl.create(:recipe, user: user2) }
        visit recipes_path
      end

      it { should have_selector('div.pagination') }

      it "should list each recipe" do
        Recipe.paginate(page: 1).each do |recipe|
          expect(page).to have_selector('li', text: recipe.name)
        end
      end
    end

    it "should list each recipe" do
      Recipe.all.each do |recipe|
        expect(page).to have_selector('li', text: recipe.name)
      end
    end
  end

  describe "new recipe page" do
  	let(:user) { FactoryGirl.create(:user) }
  	before do
  		sign_in user
  		visit newrecipe_path
  	end

  	let(:submit) { "Create this recipe" }

  	describe "delete links" do

  		it { should have_content('Delete this ingredient') }
  	end

  	describe "with invalid information" do
  		it "should not create a new recipe" do
  			expect { click_button submit }.not_to change(Recipe, :count)
  		end

  		describe "error messages" do
  			before { click_button submit }
  			it { should have_content('Error') }
  		end

  		describe "it should redirect to new recipe path" do
  			before { click_button submit }
  			it { should have_content('Add a recipe') }
  		end

  		
  	end

  	describe "with valid information" do
      before do
        visit newrecipe_path
        fill_in "Name",         with: "Example Recipe"
        fill_in "Description",   with: "Example Description"
        fill_in "Direction",    with: "Example Direction"
        fill_in "Servings",   with: "4"
        fill_in "Prep Time",  with: "23 minutes"
        fill_in "Total Time", with: "6 hours"

        fill_in "Nutrition",  with: "2 calories"
        fill_in "Ingredient",	with: "Example Ingredient", :match => :first
        fill_in "Quantity",		with: "1",  :match => :first
        fill_in "Units",      with: "cup", :match => :first
      end

       it { should have_content("Upload an image") }

      it "should create a recipe" do
        expect { click_button submit }.to change(Recipe, :count).by(1)
      end

      describe " it should show the recipe" do
      	before { click_button submit }

      	it { should have_title('Example Recipe') }
        it { should have_content('Example Direction') }
      	it { should have_content('Example Description') }
      	it { should have_content('Example Ingredient') }
      	it { should have_content('1') }
        it { should have_content('cup') }
        it { should have_content('4') }
        it { should have_content('23 minutes') }
        it { should have_content(' 6 hours') }
        it { should have_content('2 calories') }
        it { should have_content("Fork this recipe") }
      end
    end



  	it { should have_content('Add a recipe') }
  	it { should have_title(full_title('Add a recipe')) }
  end

  describe "recipe page" do
    let(:user) { FactoryGirl.create(:user, name: "stuff", email: "otherstuff@example.com") }
  	let(:recipe) { FactoryGirl.create(:recipe, user: user, name: "Ex", description: "Yep", direction: "Add") }
  	let!(:i1) { FactoryGirl.create(:ingredient, recipe: recipe, quantity: "2") }
  	let!(:i2) { FactoryGirl.create(:ingredient, recipe: recipe, quantity: "234") }

  	before { visit recipe_path(recipe) }

  	it { should have_content(recipe.name.titleize) }
  	it { should have_title(recipe.name.titleize) }
    it { should have_content(recipe.user.name) }
    it { should have_content("Random Recipe") }
    it { should have_content(recipe.rating) }

    #not signed in user
    it { should_not have_button("Rate this recipe!")}
    it { should_not have_button("Post") }
    it { should_not have_content("Your Rating") }
    it { should have_link('Sign in to rate!', href: signin_path) }

    describe "Fork tree" do
      before do
        sign_in user
        visit recipe_path(recipe)
        click_link "View the Forktree"
      end

        it { should have_title('Ex Fork Tree') }
        it { should have_content(recipe.name.titleize)}

    end
   

    #describe "when uploading a picture" do
      #image = :photo => File.new(RAILS_ROOT + '/spec/fixtures/files/pplogo.png')
    #end
    

    describe "forking a recipe" do
      before do
        sign_in user
        visit recipe_path(recipe)
        click_link "Fork this recipe"
      end

      #Don't know how to implement this yet
      #it "should not make a new recipe" do
      #  expect { click_button 'Create this recipe' }.to_not change(Recipe, :count)
      #end

      describe "change the recipe" do
        before do
          fill_in "Name",         with: "New Example Recipe"
          fill_in "Description",  with: "New Description"
          click_button "Create this recipe"
        end

        it { should have_title("New Example Recipe") }
        it { should have_content("New Description") }
        #it { should have_content("New Example Recipe Forked By "+recipe.user.name.capitalize) }

        
      end

    end


  	describe "ingredients" do
  		it { should have_content(i1.quantity) }
  		it { should have_content(i2.quantity) }
  		it { should have_content(recipe.ingredients.count) }
  	end

    describe "save/remove recipe buttons" do
      let(:user) { FactoryGirl.create(:user) }
      let(:recipe) {FactoryGirl.create(:recipe) }
      before { sign_in user }

      describe "following a recipe" do
        before { visit recipe_path(recipe) }

        it "should increment the saved recipe count" do
          expect do
            click_button "Save"
          end.to change(user.saved_recipes, :count).by(1)
        end

        describe "toggling the button" do
          before { click_button "Save" }
          it { should have_xpath("//input[@value='Remove']") }
        end
      end

      describe "removing a recipe" do
        before do
          user.recipesave!(recipe)
          visit recipe_path(recipe)
        end

        it "should decrement the saved recipes count" do
          expect do
            click_button "Remove"
          end.to change(user.saved_recipes, :count).by(-1)
        end

        describe "toggling the button" do
          before { click_button "Remove" }
          it { should have_xpath("//input[@value='Save']") }
        end
      end
    end
  end
end


















