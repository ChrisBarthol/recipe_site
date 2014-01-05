require 'spec_helper'

describe PantryItem do
  
  let(:user) { FactoryGirl.create(:user) }
  let(:ingredient) {FactoryGirl.create(:ingredient) }
  let(:pantry_item) {user.pantry_items.build(ingredient_id: ingredient.id) }

  subject { pantry_item }

  it { should be_valid }

  describe "when user id is not present" do
  	before { pantry_item.user_id = nil }
  	it { should_not be_valid }
  end

  describe "when ingredient id is not present" do
  	before { pantry_item.ingredient_id = nil }
  	it { should_not be_valid }
  end
end
