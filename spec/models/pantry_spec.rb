require 'spec_helper'

describe Pantry do
  before { @pantry = Pantry.new(name: "Cheese", quantity: "2",
  							unit: "cup", user_id: "1") }

  subject { @pantry }

  it { should respond_to(:name) }
  it { should respond_to(:quantity) }
  it { should respond_to(:unit) }
  it { should respond_to(:user_id) }

  it { should be_valid }

  describe "when name is not present" do
  	before { @pantry.name = " " }
  	it { should_not be_valid }
  end

  describe "when user_id is not present" do
  	before { @pantry.user_id = " " }
  	it { should_not be_valid }
  end
end
