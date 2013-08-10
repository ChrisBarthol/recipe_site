require 'spec_helper'

describe Ingredient do
  let(:user) { FacatoryGirl.create(:user) }
  let(:recipe) { FactoryGirl.create(:recipe) }
  before do
  	@ingredient = Ingredient.new(name: "Salt", quantity: "1 cup", recipe_id: recipe.id)
  end

  subject { @ingredient }

  it { should respond_to(:name) }
  it { should respond_to(:quantity) }
  it { should respond_to(:recipe_id) }
  its(:recipe) { should eq recipe }

  it { should be_valid }


  describe "when quantity is not present" do
  	before { @ingredient.quantity = nil }
  	it { should_not be_valid }
  end

  describe "when name is not present" do
  	before { @ingredient.name = nil }
  	it { should_not be_valid }
  end


end
