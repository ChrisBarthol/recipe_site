require 'spec_helper'

describe Makerecipe do
  let(:maker) { FactoryGirl.create(:user) }
  let(:made) { FactoryGirl.create(:recipe) }
  let(:make) { maker.makerecipes.build(made_id: made.id) }

subject { make }

  it { should be_valid }

  describe "made methods" do
  	it { should respond_to(:maker) }
  	it { should respond_to(:made) }
  	its(:maker) { should eq maker }
  	its(:made) { should eq made }
  end 

  describe "when maker id is not present" do
  	before { make.maker_id = nil }
  	it { should_not be_valid }
  end

  describe "when made is is not present" do
  	before { make.made_id = nil}
  	it { should_not be_valid }
  end
end
