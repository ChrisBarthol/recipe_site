require 'spec_helper'

describe Rating do
  let(:user) { FactoryGirl.create(:user) }
  let(:recipe) { FactoryGirl.create(:recipe) }

 before { @rating = recipe.ratings.build(ranking: 10, user_id: 1) }

  subject { @rating }

  it { should respond_to(:ranking) }
  it { should respond_to(:user_id) }
  it { should respond_to(:recipe_id) }
  it { should respond_to(:recipe) }
  its(:recipe) { should eq recipe} 

  describe "when user_id is not present" do
  	before { @rating.user_id = nil }
  	it { should_not be_valid }
  end

  describe "when recipe_id is not present" do
  	before { @rating.recipe_id = nil }
  	it { should_not be_valid }
  end
end
