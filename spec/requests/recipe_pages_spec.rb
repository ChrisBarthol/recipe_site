require 'spec_helper'

describe "RecipePages" do

  subject {page}

  describe "edit" do
    let(:user) { FactoryGirl.create(:user, id: 10) }
    let(:recipe) {FactoryGirl.create(:recipe, user_id: 10)}

    before do
      sign_in user
      visit recipe_path(recipe)
    end

    it {should have_link('Edit this Recipe', href: edit_recipe_path(recipe)) }

    describe "Editing the recipe" do
      let(:new_name) {"New Salt Recipe"}
      let(:new_description) {"This is a new salt recipe"}
      let(:new_ingredient) {"Sea Salt"}
      let(:new_quantity) {"2 Cups"}
      before do
        visit recipe_path(recipe)
        click_link "Edit this Recipe"
        fill_in "Name",     with: new_name
        fill_in "Description", with: new_description
        click_button "Create this recipe"
      end

      it { should have_title(new_name) }
      it { should have_selector('div.alert.alert-success') }
      it { should have_link('Edit this Recipe') }
      specify { expect(recipe.reload.name).to eq new_name.downcase }
      specify { expect(recipe.reload.description).to eq new_description }
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
      before do
        31.times { FactoryGirl.create(:recipe, user: user1) }
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
  			it { should have_content('error') }
  		end

  		describe "it should redirect to new recipe path" do
  			before { click_button submit }
  			it { should have_content('Add a recipe') }
  		end

  		
  	end

  	describe "with valid information" do
      before do
        fill_in "Name",         with: "Example Recipe"
        fill_in "Description",   with: "Example Description"
        fill_in "Ingredient",	with: "Example Ingredient", :match => :first
        fill_in "Quantity",		with: "1 cup",  :match => :first
      end

      it "should create a recipe" do
        expect { click_button submit }.to change(Recipe, :count).by(1)
      end

      describe " it should show the recipe" do
      	before { click_button submit }

      	it { should have_title('Example Recipe') }
      	it { should have_content('Example Description') }
      	it { should have_content('Example Ingredient') }
      	it { should have_content('1 cup') }
      end
    end



  	it { should have_content('Add a recipe') }
  	it { should have_title(full_title('Add a recipe')) }
  end

  describe "recipe page" do
    let(:user) { FactoryGirl.create(:user, name: "stuff", email: "otherstuff@example.com") }
  	let(:recipe) { FactoryGirl.create(:recipe, user: user, name: "Ex", description: "Yep") }
  	let!(:i1) { FactoryGirl.create(:ingredient, recipe: recipe, quantity: "2") }
  	let!(:i2) { FactoryGirl.create(:ingredient, recipe: recipe, quantity: "234") }

  	before { visit recipe_path(recipe) }

  	it { should have_content(recipe.name.titleize) }
  	it { should have_title(recipe.name.titleize) }
    it { should have_content(recipe.user_id) }
    it { should have_content("Fork this recipe") }

    describe "forking a recipe" do
      before do
        sign_in user
        visit recipe_path(recipe)
        click_link "Fork this recipe"
      end

      describe "change the recipe" do
        before do
          fill_in "Name",         with: "New Example Recipe"
          fill_in "Description",  with: "New Description"
          click_button "Create this recipe"
        end

        it { should have_title("New Example Recipe") }
        it { should have_content("New Description") }
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

















