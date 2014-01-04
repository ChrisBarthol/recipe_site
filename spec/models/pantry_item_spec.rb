require 'spec_helper'

describe PantryItem do
  
  let(:user) { FactoryGirl.create(:user) }
  let(:ingredient) {FactoryGirl.create(:ingredient) }
  let(:pantry_item) {user.panty_item.build(ingredient_id: ingredient.id) }

  subject { pantry_item }

  it { should be_valid }
end
