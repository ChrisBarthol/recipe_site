require 'spec_helper'

describe Ingredient do
  let(:user) { FacatoryGirl.create(:user) }
  let(:recipe) { FactoryGirl.create(:recipe) }
  before do
  	@ingredient = Ingredient.new(name: "Salt", quantity: "1", unit: "cup", style: "finely chopped", recipe_id: recipe.id)
  end

  subject { @ingredient }

  it { should respond_to(:name) }
  it { should respond_to(:quantity) }
  it { should respond_to(:recipe_id) }
  it { should respond_to(:unit) }
  it { should respond_to(:style) }
  its(:recipe) { should eq recipe }

  it { should be_valid }



  describe "when name is not present" do
  	before { @ingredient.name = nil }
  	it { should_not be_valid }
  end


end
