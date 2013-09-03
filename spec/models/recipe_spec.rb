require 'spec_helper'

describe Recipe do

  let(:user) { FactoryGirl.create(:user, name: "Why", email: "Isthishappening@example.com") }
  before { @recipe = user.recipes.build(name: "Ex Name", description: "Ex Des", direction: "Add")}

  subject { @recipe }

  it { should respond_to(:name) }
  it { should respond_to(:description) }
  it { should respond_to(:ingredients) }
  it { should respond_to(:user_id) }
  it { should respond_to(:user) }
  it { should respond_to(:reverse_reciperelationships) }
  it { should respond_to(:recipesavers) }
  it { should respond_to(:direction) }
 
  its(:user) { should eq user }

  it { should be_valid }




  describe "when user_id is not present" do
    before { @recipe.user_id = nil }
    it { should_not be_valid }
  end


   describe "when recipe name is already taken" do
    	before do 
  			recipe_with_same_name = @recipe.dup
  			recipe_with_same_name.name = @recipe.name.upcase
  			recipe_with_same_name.save
  		end

  		it { should_not be_valid }
 	end

  describe "ingredient associations" do

  	before { @recipe.save }
  	let!(:a_ingredient) do
  		FactoryGirl.create(:ingredient, name: "apple", quantity: "1 ton", recipe: @recipe)
  	end
  	let!(:s_ingredient) do
  		FactoryGirl.create(:ingredient, name: "salt", quantity: "1 cup", recipe: @recipe)
  	end
  	let!(:m_ingredient) do
  		FactoryGirl.create(:ingredient, name: 'mutton', quantity: "2 lbs", recipe: @recipe)
  	end

  	it "should have the ingredients in the right order" do
  		expect(@recipe.ingredients.to_a).to eq [a_ingredient, m_ingredient, s_ingredient]
  	end

  	it "should destroy associated ingredients" do
  		ingredients = @recipe.ingredients.to_a
  		@recipe.destroy
  		expect(ingredients).not_to be_empty
  		ingredients.each do |ingredient|
  			expect(Ingredient.where(id: ingredient.id)).to be_empty
  		end
  	end

  end

  describe "when name is not present" do
  	before { @recipe.name = " " }
  	it { should_not be_valid }
  end

  describe "when direction is not present" do
    before { @recipe.direction = " " }
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
