require 'spec_helper'

describe Reciperelationship do
  let(:recipesaver) { FactoryGirl.create(:user) }
  let(:recipesaved) { FactoryGirl.create(:recipe) }
  let(:reciperelationship) { recipesaver.reciperelationships.build(recipesaved_id: recipesaved.id) }

  subject { reciperelationship }

  it { should be_valid }

  describe "recipesaver methods" do
  	it { should respond_to(:recipesaver) }
  	it { should respond_to(:recipesaved) }
  	its(:recipesaver) { should eq recipesaver }
  	its(:recipesaved) { should eq recipesaved }
  end

  describe "when recipesaved id is not present" do
  	before { reciperelationship.recipesaved_id = nil }
  	it { should_not be_valid }
  end

  describe "when recipesaver id is not present" do
  	before { reciperelationship.recipesaver_id = nil }
  	it { should_not be_valid }
  end
end







