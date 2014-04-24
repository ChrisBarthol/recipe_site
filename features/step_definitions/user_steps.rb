Given /^I am an authenticated user$/ do   
	user = FactoryGirl.create(:user)
	
	visit signin_url
	fill_in "Email", :with => user.email
	fill_in "Password", :with => user.password
	click_button "Sign in"
end

When /^I sign out$/ do
	Given "I am an authenticated user"
	click_link"Sign out"
end

Then /^I am redirected to "([^\"]*)"$/ do |url|
      assert [301, 302].include?(@integration_session.status), "Expected status to be 301 or 302, got #{@integration_session.status}"
      location = @integration_session.headers["Location"]
      assert_equal url, location
      visit location
 end
