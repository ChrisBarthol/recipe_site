require 'spec_helper'

describe "CommentPages" do

	subject { page }

	let(:user) { FactoryGirl.create(:user) }
	let(:recipe) { FactoryGirl.create(:recipe) }
	before { sign_in user }

	describe "comment destruction" do
		before { FactoryGirl.create(:comment, user: user) }

		describe "as correct user" do
			before { visit root_path }

			it "should delete a comment" do
				expect { click_link "delete" }.to change(Comment, :count).by(-1)
			end
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
				it { should have_content('Error') }
			end
		end

		describe "with valid information" do

			before { fill_in 'comment_content', with: "Lorem ipsum" }
			it "should create a comment" do
				expect { click_button "Post" }.to change(Comment, :count).by(1)
			end
		end
	end
end
