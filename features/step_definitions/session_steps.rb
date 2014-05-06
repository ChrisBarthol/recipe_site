Given /^I am an authenticated user$/ do   
	user = FactoryGirl.create(:user)
	
	visit signin_url
	fill_in "Email", :with => user.email
	fill_in "Password", :with => user.password
	click_button "Sign in"
end

When /^I sign out$/ do
	Given "I am an authenticated user"
	click_link"Sign out", :match => :first
end

Given /^I am not logged in$/ do
	user = FactoryGirl.create(:user)
end

When(/^I sign\-in$/) do
	user = FactoryGirl.create(:user)
	visit signin_url
	fill_in "Email", :with => user.email
	fill_in "Password", :with => user.password
	click_button "Sign in"
end

Then(/^I should see "(.*?)"$/) do |text|
  page.should have_content(text)
end