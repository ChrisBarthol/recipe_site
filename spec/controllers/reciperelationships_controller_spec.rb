require 'spec_helper'

describe ReciperelationshipsController do 

	let(:user) { FactoryGirl.create(:user) }
	let(:recipe) { FactoryGirl.create(:recipe) }

	before { sign_in user, no_capybara: true }

	describe "creating a reciperelationship with Ajax" do

		it "should increment the Reciperelationship count" do
			expect do
				xhr :post, :create, reciperelationship: { recipesaved_id: recipe.id }
			end.to change(Reciperelationship, :count).by(1)
		end

		it "should respond with sucess" do
			xhr :post, :create, reciperelationship: { recipesaved_id: recipe.id }
			expect(response).to be_success
		end
	end

	describe "destroying a recipe relationship with Ajax" do

		before { user.recipesave!(recipe) }
		let(:reciperelationship) { user.reciperelationships.find_by(recipesaved_id: recipe) }

		it "should decrement the Reciperelationship count" do
			expect do
				xhr :delete, :destroy, id: reciperelationship.id
			end.to change(Reciperelationship, :count).by(-1)
		end

		it "should respond with succes" do
			xhr :delete, :destroy, id: reciperelationship.id
			expect(response).to be_success
		end
	end
end





