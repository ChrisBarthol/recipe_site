require 'spec_helper'

describe "RecipePages" do

  subject {page}

  describe "index" do
    let(:recipe) { FactoryGirl.create(:recipe) }
    let(:user)	 { FactoryGirl.create(:user) }
    before(:each) do
      sign_in user
      visit recipes_path
    end

    it { should have_title('All recipes') }
    it { should have_content('All recipes') }

    describe "pagination" do

      before(:all) { 31.times { FactoryGirl.create(:recipe) } }
      after(:all)  { Recipe.delete_all }

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
  	let(:recipe) { FactoryGirl.create(:recipe) }
  	let!(:i1) { FactoryGirl.create(:ingredient, recipe: recipe, quantity: "2") }
  	let!(:i2) { FactoryGirl.create(:ingredient, recipe: recipe, quantity: "234") }

  	before { visit recipe_path(recipe) }

  	it { should have_content(recipe.name.titleize) }
  	it { should have_title(recipe.name.titleize) }

  	describe "ingredients" do
  		it { should have_content(i1.quantity) }
  		it { should have_content(i2.quantity) }
  		it { should have_content(recipe.ingredients.count) }
  	end
  end
end


















