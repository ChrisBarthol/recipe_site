require 'spec_helper'

describe "CommentPages" do

	subject { page }

	let(:user) { FactoryGirl.create(:user) }
	let(:user2) { FactoryGirl.create(:user) }
	let(:recipe) { FactoryGirl.create(:recipe) }
	let(:recipe2) { FactoryGirl.create(:recipe) }
	before { sign_in user }

	describe "comment destruction" do
		before do
			 FactoryGirl.create(:comment, user: user, recipe_id: recipe.id) 
			 FactoryGirl.create(:comment, user: user2, recipe_id: recipe2.id) 
		end

		describe "as correct user" do
			before { visit root_path }

			it "should delete a comment" do
				expect { click_link "delete" }.to change(Comment, :count).by(-1)
			end
		end

		describe "as incorrect user" do
			before { visit recipe_path(recipe2) }

			it {should_not have_link('delete') }
		end
	end

	describe "comment creation" do
		before { visit recipe_path(recipe) }

		describe "with invalid information" do

			it "should not create a micropost" do
				expect { click_button "Post" }.not_to change(Comment, :count)
			end

			describe "error messages" do
				before { click_button "Post" }
				it { should have_content('error') }
			end
		end

		describe "with valid information" do

			before { fill_in 'comment_content', with: "Lorem ipsum" }
			it "should create a comment" do
				expect { click_button "Post" }.to change(Comment, :count).by(1)
			end

			describe "returns to recipe page" do
				before { click_button "Post" }
				it { should have_content("Lorem ipsum") }
				it { should have_content(recipe.direction) } 
			end
		end
	end
end
