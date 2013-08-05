require 'spec_helper'

describe "RecipePages" do
  subject {page}

  describe "new recipe page" do
  	before { visit newrecipe_path }

  	let(:submit) { "Create this recipe" }

  	describe "with invalid information" do
  		it "should not create a new recipe" do
  			expect { click_button submit }.not_to change(Recipe, :count)
  		end
  	end

  	describe "with valid information" do
      before do
        fill_in "Name",         with: "Example User"
        fill_in "Description",   with: "Example Description"
        
      end

      it "should create a user" do
        expect { click_button submit }.to change(Recipe, :count).by(1)
      end
    end



  	it { should have_content('Add a recipe') }
  	it { should have_title(full_title('Add a recipe')) }
  end

  describe "recipe page" do
  	let(:recipe) { FactoryGirl.create(:recipe) }
  	before { visit recipe_path(recipe) }

  	it { should have_content(recipe.name) }
  	it { should have_title(recipe.name) }
  end
end
