require 'spec_helper'

describe "Static pages" do

  subject { page }

  shared_examples_for "all static pages" do
    it { should have_selector('h1', text: heading) }
    it { should have_title(full_title(page_title)) }
  end

  describe "Home page" do
    before { visit root_path }
    let(:heading)     { 'Welcome to Use Your Foodle' }
    let(:page_title)  { '' }

    it_should_behave_like "all static pages"
    it { should_not have_title('| Home') }

    describe "for signed-in users" do
      let(:user) { FactoryGirl.create(:user) }
      let(:recipe) {FactoryGirl.create(:recipe, user: user)}
      let(:ingredient) {FactoryGirl.create(:ingredient) }
      let(:pantry_item) {user.pantry_items.build(ingredient_id: ingredient.id) }
      before do
        FactoryGirl.create(:comment, user: user, content: "Lorem ipsum")
        FactoryGirl.create(:comment, user: user, content: "Dolor sit amet")
        sign_in user
        visit root_path
      end

      it "should render the user's feed" do
        user.feed.each do |item|
          expect(page).to have_selector("li##{item.id}", text: item.content)
        end
      end

      it "should render the user's saved recipes" do
        user.saved_recipes.each do |item|
          expect(page).to have_selector("li##{item.id}", text: item.name)
        end
      end

      describe "should render the user's pantry" do
        it { should have_link("1 ingredient in your pantry", href: pantry_user_path(user)) }
      end
    end

  end

  describe "Tour a tour page" do
    before { visit tour_path }

    it { should have_content('Tour') }
  end

  describe "Help page" do
    before { visit help_path }

    it { should have_content('Help') }
    it { should have_title(full_title('Help')) }
  end

  describe "About page" do
    before { visit about_path }

    it { should have_content('About This Site') }
    it { should have_title(full_title('About')) }
  end

  describe "Contact page" do
    before { visit contact_path }

    it { should have_selector('h1', text: 'Contact') }
    it { should have_title(full_title('Contact')) }
  end

  it "should have the right links on the layout" do
    visit root_path
    click_link "About"
    expect(page).to have_title(full_title('About'))
    click_link "Contact"
    expect(page).to have_title(full_title('Contact'))
    click_link "Help"
    expect(page).to have_title(full_title('Help'))
    click_link "Home"
    click_link "Sign up now!"
    expect(page).to have_title(full_title('Sign up'))
    click_link "Use Your Foodle"
    expect(page).to have_title(full_title(''))
  end
end