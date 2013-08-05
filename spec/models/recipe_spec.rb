require 'spec_helper'

describe Recipe do
  
  before { @recipe = Recipe.new(name: "Example Recipe", description: "This is an example recipe.  It has some text for the decription") }

  subject { @recipe }

  it { should respond_to(:name) }
  it { should respond_to(:description) }

  it { should be_valid }

  describe "when name is not present" do
  	before { @recipe.name = " " }
  	it { should_not be_valid }
  end

  describe "when description is not present" do
  	before { @recipe.description = " " }
  	it { should_not be_valid }
  end

  describe "when name is already taken" do
  	before do
  		recipe_with_same_name = @recipe.dup
  		recipe_with_same_name.name = @recipe.name.upcase
  		recipe_with_same_name.save
  	end

  	it { should_not be_valid }
  end

end
