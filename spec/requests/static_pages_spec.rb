require 'spec_helper'

describe "Static pages" do

  describe "Home page" do

    it "should have the content 'Sample App'" do
      visit '/static_pages/home'
      expect(page).to have_content('Recipe Site')
    end

    it "should have the title 'Home'" do
    	visit '/static_pages/home'
    	expect(page).to have_title('Pantry Raid | Home')
    end
  end

  describe "Help Page" do

  	it "should have the content 'Help Page'" do
  		visit '/static_pages/help'
  		expect(page).to have_content('Need Some Help?')
  	end

  	it "should have the title 'Help'" do
  		visit '/static_pages/help'
  		expect(page).to have_title("Pantry Raid | Help")
  	end
  end

  describe "About page" do

  	it "should have the content 'About This Site'" do
  		visit '/static_pages/about'
  		expect(page).to have_content('About This Site')
  	end

  	it "should have the title 'About'" do
  		visit '/static_pages/about'
  		expect(page).to have_title("Pantry Raid | About")
  	end
  end
end